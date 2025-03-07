#include "stm8s.h"
//#include <string.h>
#include "stm8s_type.h"
#include "timers.h"
#include "adc.h"
#include "globals.h"
#include "options.h"

//public functions
void initRelays(void);
void processRelay(Relay *rel);
void relayFunction(Relay *rel);
void updateRelayTimer(Relay *rel);

//public variables
Relay relay1;
volatile u8 randomStandardDelay = STANDARD_WAIT_DELAY_SECS_MIN;
volatile _Bool enterONMode = FALSE;

//private functions
void initRelay(Relay *rel, void (*enable_func_pointer)(void), void (*disable_func_pointer)(void));
void getSensitivityStatus(Relay *rel);
void getOffPositionStatus(Relay *rel);
void getIntDelayStatus(Relay *rel);
void tempProc(Relay *rel);
void voltageProc(Relay *rel);
void enableRelay1(void);
void disableRelay1(void);
void enableRelay2(void);
void disableRelay2(void);
void enableRelay3(void);
void disableRelay3(void);
void enableRelay4(void);
void disableRelay4(void);
//------------------------------------------------------------------------------------------------------------------------

// public function initializing all relays
void initRelays(void)
{
	initRelay(&relay1, &enableRelay1, &disableRelay1);
}
//------------------------------------------------------------------------------------------------------------------------

// private function initialalizing single relay. Pointers to enable and disable functions are passed
void initRelay(Relay *rel, void (*enable_func_pointer)(void), void (*disable_func_pointer)(void))
{
	// status flags
	rel->voltageOK = FALSE;
	rel->notOFF = FALSE;
	rel->intDelayOK = FALSE;
	rel->tempOK = FALSE;
	rel->testMode = FALSE;	//not used in this firmware
	rel->relayON = FALSE;
	
	// options
	rel->voltProtEnabled = VOLTAGE_PROTECTION_ENABLED;
	rel->aspEnabled = ASP_ENABLED;
	rel->sensitivityEnabled = SENSITIVITY_ENABLED;
	rel->offDetectEnabled = OFF_POSITION_DETECT_ENABLED;
	rel->intDelayEnabled = TIMESAVE_DELAY_ENABLED;
	rel->tempEnabled = TEMPERATURE_PROTECTION_ENABLED;
	rel->probeFaultDetectEnabled = PROBE_FAULT_DETECTION_ENABLED;
	rel->defrostEnabled = DEFROST_ENABLED;
	rel->condensorBlockDetectEnabled = CONDENSOR_BLOCKAGE_DETECTION_ENABLED;
	
	rel->state = REL_OFF;
	
	// settings
	rel->LVD = LOW_VOLTAGE_DISCONNECT;
	rel->fastLVD = LOW_VOLTAGE_DISCONNECT_FAST;
	rel->HVD = HIGH_VOLTAGE_DISCONNECT;
	rel->fastHVD = HIGH_VOLTAGE_DISCONNECT_FAST;
	
	rel->LVR = LOW_VOLTAGE_RECONNECT;
	rel->HVR = HIGH_VOLTAGE_RECONNECT;

	// timers
	rel->nsec = 0;				//reconnect delay counter
	rel->milliSec = 0;		//blind time counter
	rel->waitDelay = randomStandardDelay;			//random delay     // STANDARD_WAIT_DELAY_SECS;
	rel->uVBlindTime = UNDERVOLTAGE_BLIND_TIME_MSEC;
	rel->oVBlindTime = OVERVOLTAGE_BLIND_TIME_MSEC;
	
	rel->enableRelay = enable_func_pointer;			// assign function pointers
	rel->disableRelay = disable_func_pointer;
	
	rel->disableRelay();	//make sure relay is disabled after initialization
}	//initRelay
//------------------------------------------------------------------------------------------------------------------------

//decide whether to change state
void relayFunction(Relay *rel)
{
	volatile _Bool test = FALSE;
	switch (rel->state)
	{
		case REL_OFF:
		default:
			//Off state operating functions
			releaseIntDelay();
			rel->state = REL_OFF;	// paranoia if we have got here with an unhandled state
			
			//decide whether to change state
			test = rel->voltageOK;
			if (test) test = rel->tempOK;
			if (test) test = rel->notOFF;
			if (test) 
			{
				rel->state = REL_WAIT;
				randomStandardDelay = generateRandomDelay();		//generates random delay if enabled in options.h. If not then fixed minimum delay.
				if (rel->waitDelay != IntDelaySecs)	//if we are measuring standard delay, we should start now
																												//if we are measuring int delay then we don't want to reset counter,
																												//it will be reset after intelligent delay
					rel->nsec = 0;
			}
			else rel->state = REL_OFF;
			break;
		
		case REL_WAIT:
			//Wait state operating functions
			releaseIntDelay();
			
			//decide whether to change state
			test = rel->voltageOK;
			if (test) test = rel->tempOK;
			if (test) test = rel->notOFF;
			if (!test) 
			{
				rel->state = REL_OFF;
				return;
			}
			test = rel->sensitivityOK;
			// check for reconnect delay only after standard delay (after int delay there is always random standard delay added)
			if (test && (rel->waitDelay != IntDelaySecs) && (rel->nsec > rel->waitDelay) && isSwitchOn) 
			{
				rel->state = REL_ON;
				rel->nsec = 0;			// reset delay counters when entering ON state
				rel->milliSec = 0;
				enterONMode = TRUE;	// force ASP control to enable relevant output relay combination
			}
			else rel->state = REL_WAIT;
			break;
			
		case REL_ON:
			//On state operating functions
			primeIntDelay(); //assert intelligent delay
		
			//decide whether to change state
			test = rel->voltageOK;
			if (test) test = rel->tempOK;
			if (test) test = rel->notOFF;
			if (test) test = rel->sensitivityOK;
			if ((!test) || (!isSwitchOn)) 
			{
				rel->state = REL_OFF;
				rel->nsec = 0;				// reset delay counters to be able to measure reconnect delay
				rel->milliSec = 0;
				if (avs_state == AVS_MAN_ON)
					isSwitchOn = FALSE;		//in manual mode if we turn off relay for whatever reason we also need to change button state to off
					//generateRandomDelay();	//we are switching off so we should prepare random delay for reconnect
			}
			else rel->state = REL_ON;
			break;
	}
}	//relayFunction
//------------------------------------------------------------------------------------------------------------------------

//called every millisecond in timer 4 interrupt
void updateRelayTimer(Relay *rel)
{
	//update relay milliSec timer(s)
	if (rel->milliSec < 0xFFFFFFFF) 
	{
		rel->milliSec++;
		if (!(rel->milliSec % 1000))
		{
			if (rel->nsec < 0xFFFE) rel->nsec++;	//nsec shouldn't reach 0xFFFF because this is reserved for manual mode (infinity)
		}
	}
}
//------------------------------------------------------------------------------------------------------------------------
	
//update relay flags based on conditions
void processRelay(Relay *rel)
{
	//see if ac voltage is OK
	voltageProc(rel);
	
	//handle temperature measurements
	tempProc(rel);
	
	//handle intellligent time delay
	getIntDelayStatus(rel);
	
	//get status of OFF postion
	getOffPositionStatus(rel);
	
	//set status of sensitivity
	getSensitivityStatus(rel);
}
//------------------------------------------------------------------------------------------------------------------------

void getSensitivityStatus(Relay *rel)
{
	if (!rel->sensitivityEnabled || getASPSensitivityLevel() || isYGlow()) rel->sensitivityOK = TRUE;
	else	rel->sensitivityOK = FALSE;
}
//------------------------------------------------------------------------------------------------------------------------

//function not complete, to be written if off detection is needed
void getOffPositionStatus(Relay *rel)
{
	if (!rel->offDetectEnabled)	rel->notOFF = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------

// getIntDelayStatus determines the intelligent time delay status
// using an averaged sample of the int D voltage level
void getIntDelayStatus(Relay *rel)
{
	u16 intDelayLevel;
	u16 appliedADCThreshold;
	
	// if intelligent delay not enabled or we are in initial 30 minutes of operation 
	// then intdelay is ok and we just assign new standard delay value
	if (!rel->intDelayEnabled || isFirst30min())
	{
		rel->intDelayOK = TRUE;
		rel->waitDelay = randomStandardDelay;
		return;
	}
	
	//if Y-G pin is low then skip delays
	if (isYGlow())
	{
		rel->intDelayOK = TRUE;
		rel->waitDelay = 0;
		return;
	}
	
	// if delay capacitor kept charged then no delay
	if (intDelayPrimed) 
	{
		rel->intDelayOK = TRUE;
		rel->waitDelay = randomStandardDelay;
		return;
	}
	
	//read intDelay ADC level
	intDelayLevel = getIntDelay();
	
	if (isYGlow())	appliedADCThreshold = TEST_INT_DELAY_ADC_LEVEL;
	else appliedADCThreshold = IntDelayADCLevel;//INT_DELAY_ADC_LEVEL;
	
	// The intelligent delay period is over if the reading is greater than the threshold, 
	// or the threshold - INT_DELAY_HYST_COUNTS adc counts if already deemed over, 
	if ((intDelayLevel >= appliedADCThreshold) 
			|| ((intDelayLevel > (appliedADCThreshold - INT_DELAY_HYST_COUNTS)) && rel->intDelayOK))
	{
		if (!(rel->intDelayOK))		//do this only once after Int Delay finish
		{
			rel->nsec = 0;				// counter is already higher than threshold so reset counter to add standard delay
		}
		rel->intDelayOK = TRUE;
		if (IntDelaySecs == MANUAL_MODE_SECS)	//in manual mode there is only intelligent delay so we set std to 0
			rel->waitDelay = 0;
		else										//in any other mode we add std delay at this point
			rel->waitDelay = randomStandardDelay;
	}
	else 
	{
		rel->intDelayOK = FALSE;
		rel->waitDelay = IntDelaySecs;//INT_DELAY_WAIT_TIME_SECS;
	}
}	//getIntDelayStatus
//------------------------------------------------------------------------------------------------------------------------

// tempProc determines whether the relay should be on based on the 
// temperature reading.
void tempProc(Relay *rel)
{
	if (!rel->tempEnabled) 
	{
		rel->tempOK = TRUE;
		return;
	}
	rel->tempOK = FALSE;
}
//------------------------------------------------------------------------------------------------------------------------

//voltageProc decides whether or not the input voltage is acceptable
//based on what the voltage reading is, current state, blind time etc.
void voltageProc(Relay *rel)
{
	_Bool blindTime = FALSE;
	static _Bool milliSecResetDone = FALSE;
	
	// quit if voltage protection not enabled
	if (!rel->voltProtEnabled) 
	{
		rel->voltageOK = TRUE;
		return;
	}
	
	// voltage is not OK if period measurement was bad
	if (!acVmeasurementOK)
	{
		rel->voltageOK = FALSE;
		return;
	}
	
	//detemine voltageOK based on current state, output voltage, thresholds and blind time status
	if (rel->state != REL_OFF)
	{
		// output is on so we are looking at disconnects
		//if (relayCombination == 1) 		// check LVDs only when lowest setting selected
		//{
			// check if voltage is below fast-off threshold
			if (outputVoltage < rel->fastLVD) 
			{
				rel->voltageOK = FALSE;			// if below fastLVD reset flag immediately
				milliSecResetDone = FALSE;	// in case we were in normal LVD blind time and voltage drops below fast LVD
				return;
			}
			//voltage is > fast threshold. See if < normal LVD threshold
			else if (outputVoltage < rel->LVD)	//See if voltage < normal LVD threshold
			{
				if (!milliSecResetDone)			// check if LVD blind time has been triggered
				{
					rel->milliSec = 0;				// if not then trigger..
					milliSecResetDone = TRUE;	// and set flag
				}
				rel->voltageOK = (rel->milliSec < rel->uVBlindTime);		// voltage ok if still in blind time (before switch off)
			}
		
			// check if voltage is above fast-off threshold
			else if (outputVoltage > rel->fastHVD)
			{
				rel->voltageOK = FALSE;			// if above fastHVD reset flag immediately
				milliSecResetDone = FALSE;	// in case we were in normal HVD blind time and voltage goes above fast HVD
				return;
			}
			//voltage is < fast threshold. See if > normal HVD threshold
			else if (outputVoltage > rel->HVD)
			{
				if (!milliSecResetDone)
				{
					rel->milliSec = 0;
					milliSecResetDone = TRUE;
				}
				rel->voltageOK = (rel->milliSec < rel->oVBlindTime);		// set flag if still in blind time (before switch off)
			}
			else milliSecResetDone = FALSE;		// if voltage is ok again before blind time run out, clear reset flag
	
		// if voltage is not ok (and blind time is out) clear counter reset flag to be able to trigger blind time next time
		if (!rel->voltageOK) milliSecResetDone = FALSE;
	}
	else	//output disabled (off state)
	{
		//output is OFF so we are looking at reconnects
		rel->voltageOK = ((outputVoltage > rel->LVR) && (outputVoltage < rel->HVR));
		/*
		if (relayCombination == 1) 
			rel->voltageOK = (outputVoltage > rel->LVR);				//lowest tap so look for LVR
		else if (relayCombination == 6) rel->voltageOK = (outputVoltage < rel->HVR);	//highest tap so look for HVR
		else 	// any other tap - look for operating range (important during power-up)
		{
			rel->voltageOK = (outputVoltage > selectedTapUpVoltage);
			if (rel->voltageOK) rel->voltageOK = (outputVoltage < selectedTapDownVoltage);
		}
		*/
		
	}
}	//voltageProc
//------------------------------------------------------------------------------------------------------------------------

//functions to drive relays pointed to from within relay structs
void enableRelay1(void)
{
	GPIOsetHigh(RELAY1_PORT);
	relay1.relayON = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------

void disableRelay1(void)
{
	GPIOsetOutputPushPull(RELAY1_PORT);
	GPIOsetLow(RELAY1_PORT);
	relay1.relayON = FALSE;
}
//------------------------------------------------------------------------------------------------------------------------
/*
void enableRelay2(void)
{
	GPIOsetHigh(RELAY2_PORT);
	relay2.relayON = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------

void disableRelay2(void)
{
	GPIOsetOutputPushPull(RELAY2_PORT);
	GPIOsetLow(RELAY2_PORT);
	relay2.relayON = FALSE;
}
//------------------------------------------------------------------------------------------------------------------------

void enableRelay3(void)
{
	GPIOsetHigh(RELAY3_PORT);
	relay3.relayON = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------

void disableRelay3(void)
{
	GPIOsetOutputPushPull(RELAY3_PORT);
	GPIOsetLow(RELAY3_PORT);
	relay3.relayON = FALSE;
}
//------------------------------------------------------------------------------------------------------------------------

void enableRelay4(void)
{
	GPIOsetHigh(RELAY4_PORT);
	relay4.relayON = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------

void disableRelay4(void)
{
	GPIOsetOutputPushPull(RELAY4_PORT);
	GPIOsetLow(RELAY4_PORT);
	relay4.relayON = FALSE;
}
*/
//------------------------------------------------------------------------------------------------------------------------