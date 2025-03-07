#include "stm8s.h"
#include "stm8s_type.h"
#include "timers.h"
#include "adc.h"
#include "globals.h"
#include "options.h"


//public functions
void initSensitivity(void);
void aspFunction(void);
void updateSensitivity(void);
u8 getASPSensitivityLevel(void);
//void updateSensitivityTimers(void);
void checkSensitivityArrays(void);
void testRelays(u8*);
void operateRelay(Relay *);

//private functions
u8 addEventToSensitivityArray(u8 *, u8);
u8 getCounterValue(u8 *);
_Bool relaySelect(void);
void syncTap(void);
void syncOFF(Relay *);
void syncON(Relay *);

//global variables
volatile u16 tapChangeBlindTime = 0;
u8 relayCombination = 0;	// 0 = startup - no relay combination selected
													// 1 = boost, Red-Yellow
													// 2 = boost, Reg-Orange
													// 3 = boost, Grey-Yellow
													// 4 = boost, Grey-Orange
													// 5 = 1:1, Yellow-Yellow
													// 6 = buck, Yellow-Orange
													
vu16 selectedTapUpVoltage = LVL1_SENSE_TAP_UP_VOLTAGE;		// tap-up voltage level according to sensitivity level
vu16 selectedTapDownVoltage = LVL1_SENSE_TAP_DOWN_VOLTAGE;

//private variables
_Bool resetTapChangeBlindTime = FALSE;	//indicates if blind time counter reset has been done or not

	//sensitivity 
	u8 SensitivityArray[DECREASE_SENSITIVITY_THRESHOLD+1];
	//u8 lvl1SensitivityArray[DECREASE_SENSITIVITY_THRESHOLD+1];
	//u8 lvl2SensitivityArray[DECREASE_SENSITIVITY_THRESHOLD+1];
	//u8 lvl3SensitivityArray[DECREASE_SENSITIVITY_THRESHOLD+1];
	u8 SensitivityArrayPosition=0;					// tells where to write new tap change event in sensitivity array
	//u8 lvl1SensitivityArrayPosition;		// tells where to write new tap change event in sensitivity array
	//u8 lvl2SensitivityArrayPosition;
	//u8 lvl3SensitivityArrayPosition;

	vu8 sensitivity = 1;		//high sensitivity

//asp functionality
volatile _Bool relay1Set = FALSE;
volatile _Bool relay2Set = FALSE;
volatile _Bool relay3Set = FALSE;
//volatile _Bool relay4Set = FALSE;
volatile u8 desiredRelayComb = 5;		//desired realy combination initialized to 1:1

//****************************************************************************************************************************
//SENSITIVITY DETAILED EXPLANATION - Comments imported directly from SVS code so not necessarily all relevant
//****************************************************************************************************************************
/*; The maximum number of relay change to protect the life of the relays over 2 years is 5 changes per one hour. A timer will
; start running at time 0, and it counts the number of tap changes per hour. At any time, if the number of changes exceeds 5, 
; then it changes the sensitivity level to a lower one, and it starts the timer again from time 0 for the current and next
; sensitivity level. If not, then at the end of the one hour timer, it starts the timer again from time 0.

; The firmware now creates a virtual copy of the output voltage for each sensitivity level, based on its own tap-up and 
; tap-down figures, and it will have one one-hour timer per sensitivity setting, and one tap-change counter per
; sensitivity level. This will allow the SVS to perform more than one sensitivity-level step change in one event.

; To provide hysterisis for sensitivity change, the unit moves into a higher sensitive mode if the tap-change
; rate of that mode is equal or less than 4, and it moves into a lower sensitive mode if the tap-change rate of the current
; mode is equal or more than 6.

; If it is on high sensitivity: 
; ----------------------------
; 1. If the rate of tap-change(low sensitivity) is more than 6 times, it switches the output off, and it keeps the SVS o/p
; 	 relay off. 
; 2. If the rate of tap-change(high sensitivity) is more than 6 times, it moves into the medium sensitive mode.
; 3. If the rate of tap-change(medium sensitivity) is more than 6 times, it moves into the low sensitive mode.
; 4. If none of the above is true, it stays in the high sensitive mode.

; If it is on medium sensitivity: 
; -------------------------------
; 1. If the rate of tap-change(high sensitivity) is less than 4 times in the past one hour, it moves into the high
; 	 sensitivity mode.
; 2. If the rate of tap-change(low sensitivity) is more than 6 times, it switches the output off, and it keeps the SVS o/p
;	   relay off.
; 3. If the rate of tap-change(medium sensitivity) is more than 6 times, it moves into the low sensitive mode.
; 4. If none of the above is true, it stays in the medium sensitive mode.

; If it is on low sensitivity: 
; -----------------------------
; 1. If the rate of tap-change(high sensitivity) is less than 4 times in the past one hour, it moves into the high
;	   sensitivity mode.
; 2. If the rate of tap-change(medium sensitivity) is less than 4 times in the past one hour, it moves into the medium
;		 sensitivity mode.
; 3. If the rate of tap-change(low sensitivity) is more than 6 times, it switches the output off, and it keeps the SVS o/p
;	   relay off.
; 4. If none of the above is true, it stays in the low sensitive mode.

; In all the above three scenarios, when the tap-change of the low sensitivity mode is more than 5, it swtiches the AVS
; relay off, and switches
; the SVS o/p relay off too. it recovers from the off mode only of the tap-change rate of the low mode goes down below 5
; within the last one
; hour.

; If the tap-change-rate-low is too high, then the AVS relay is off, 
; also the SVS output relay should stay off (output on yellow all the time to prevent turning it on/off while the voltage
; fluctuates alot).
; When in combination #2 and #4, the output relay normally should be 
; on orange tap, but becasue of this feature, the output relay is on
; yellow tap. Therefore, the actual voltage is different than the measured
; voltage - the measured voltage is on yellow, while the actual voltage
; should be on orange. The f/w takes care of this in routine CALC_AVG
; by taking the transformer ratio into account (orange tap/yellow tap == 0.89).
*/
//****************************************************************************************************************************

//****************************************************************************************************************************
// Basic implementation of sensitivity in ACSTAB
//
// There are 3 levels of sensitivity, each with slightly different tap thresholds.
// There is a maximum of 6 (DECREASE_SENSITIVITY_THRESHOLD) tap events allowed - more than this and the unit move to a lower 
// sensitivity or will shutdown. If a threshold of a particular sensitivity level is exceeded then a "tap change" event, the 
// value of the "minute" variable, is recorded in that particular sensitivity's array, overwriting the oldest event in the 
// array. When the minute variable is updated (once a minute), any events from the same minute in the previous hour are 
// removed. Therefore a tap change event will be active for a 1 hour period.


//One of the sensitivities is active. This starts out as the highest sensitivity - level 3. If the number of tap changes 
//****************************************************************************************************************************

//****************************************************************************************************************************
// No sensitivity in FSPE
//
// sensitivity in this program is simplified and it's not used. 
//****************************************************************************************************************************

// initialise the event arrays
void initSensitivity(void)
{
	u8 count = 0;
	while (count < DECREASE_SENSITIVITY_THRESHOLD+1)
	{
		// initialised with 0xFF because 0 is a legitmate minute number
		SensitivityArray[count] = 0xFF;
		//lvl1SensitivityArray[count] = 0xFF;
		//lvl2SensitivityArray[count] = 0xFF;
		//lvl3SensitivityArray[count] = 0xFF;
		count++;
	}
}
//------------------------------------------------------------------------------------------------------------------------
		
// Check to see if a tap change occured on current sensitivity level
// Update counters and timers if so, and make the resulting decision
// Runs in main loop
// does not make any decisions on the first time it eneters the routine.
void updateSensitivity(void)
{
	static _Bool firstEntry = TRUE;
	static _Bool oldLow = FALSE;					// indicates if tap-up level hit last time
	static _Bool oldHigh = FALSE;					// indicates if tap-down level hit last time
	static _Bool newLow = FALSE;					// indicates if tap-up level hit in this call
	static _Bool newHigh = FALSE;					// indicates if tap-down level hit in this call 
	
	u8 tapChangeCounter; 
	
	//check thresholds for current sensitivity
	if (outputVoltage < selectedTapUpVoltage)
		newLow = TRUE;
	else if (outputVoltage > selectedTapDownVoltage)
		newHigh = TRUE;
	else
	{
		newLow = FALSE;
		newHigh = FALSE;
	}
	
	// if the values are different and a tap change is required then we need to 
	// increment the tap change counter and add the time in seconds to the counters
	if (((newLow  && !oldLow) || (newHigh && !oldHigh)) && !firstEntry)
	{
		SensitivityArrayPosition = addEventToSensitivityArray(SensitivityArray, SensitivityArrayPosition);
	}
	
	//get the number of active tap change events for current sensitivity level over the active period
	tapChangeCounter = getCounterValue(SensitivityArray);
	
	//decide our current sensitivity
	switch (sensitivity)
	{
		default:
		case 1:	//high
			sensitivity = 1;		//paranoia
			
			if (tapChangeCounter > DECREASE_SENSITIVITY_THRESHOLD)
			{
				sensitivity = 2;
				initSensitivity();		//reset sensitivity array to start counting new level
				SensitivityArrayPosition = 0;
			}
			break;
			
		case 2:	//low
			sensitivity = 2;		//paranoia
			if (tapChangeCounter > DECREASE_SENSITIVITY_THRESHOLD)	sensitivity = 0;//output OFF
			else if (tapChangeCounter < INCREASE_SENSITIVITY_THRESHOLD) 
						{
							sensitivity = 1;
							initSensitivity();		//reset sensitivity array to start counting new level
							SensitivityArrayPosition = 0;
						}
			break;
	}
	
	//apply appropriate limits to the sensitivity level
	switch (sensitivity)
	{
		case 1:
			selectedTapUpVoltage = LVL1_SENSE_TAP_UP_VOLTAGE;
			selectedTapDownVoltage = LVL1_SENSE_TAP_DOWN_VOLTAGE;
			break;
			
		case 2:
			selectedTapUpVoltage = LVL2_SENSE_TAP_UP_VOLTAGE;
			selectedTapDownVoltage = LVL2_SENSE_TAP_DOWN_VOLTAGE;
			break;
	}
	
	//update current states for next time
	oldLow = newLow;
	oldHigh = newHigh;
	firstEntry = FALSE;
}		//updateSensivity()
//------------------------------------------------------------------------------------------------------------------------

//add a tapchange event to the array. Update the position counter to the next spot
u8 addEventToSensitivityArray(u8 *arr, u8 posn)
{
	*(arr+posn) = minutes;
	if (posn >= (DECREASE_SENSITIVITY_THRESHOLD+1))	return (0);
	return (posn+1);
}
//------------------------------------------------------------------------------------------------------------------------

//remove expired tap change events from the sensitivity array
//important that it only runs once at the start of every minute 
//to ensure that any events that have just been added don't get erased
//runs in timer 4 interrupt just after minute is updated
void checkSensitivityArrays(void)
{
	u8 loop = 0;
	
	// see if an event has expired and remove it from the array if so.
	// 0xFF signifies empty because a minute can have a value of zero
	while (loop <= (DECREASE_SENSITIVITY_THRESHOLD+1))
	{
		if (minutes == SensitivityArray[loop]) SensitivityArray[loop] = 0xFF;
		//if (minutes == lvl1SensitivityArray[loop]) lvl1SensitivityArray[loop] = 0xFF;
		//if (minutes == lvl2SensitivityArray[loop]) lvl2SensitivityArray[loop] = 0xFF;
		//if (minutes == lvl3SensitivityArray[loop]) lvl3SensitivityArray[loop] = 0xFF;
		loop++;
	}
}
//------------------------------------------------------------------------------------------------------------------------

//returns the number of active events for a sensitivity.
//If in shorted-SWIM mode then we are disabling the sensitivity function so wipe the array
u8 getCounterValue(u8 *array)
{
	u8 loop = 0;
	u8 counter = 0;
	u8 *arrayPtr = array;
	
	while (loop <= DECREASE_SENSITIVITY_THRESHOLD)
	{
		if (isYGlow())	*arrayPtr = 0xFF;	//blank the array if SWIM low - wipe existing events
		else if (*arrayPtr<60) counter++;
		arrayPtr++;
		loop++;
	}
	return (counter);
}
//------------------------------------------------------------------------------------------------------------------------

u8 getASPSensitivityLevel(void)
{
	return (sensitivity);
}
//------------------------------------------------------------------------------------------------------------------------
#if ASP_ENABLED
//Handle regulation of output via tap changes
void aspFunction(void)
{
	// determine the most appropriate tap
	_Bool changeTap = relaySelect();
	
	//The output should be OFF unless we are in ON mode
	/*
	if (relay4.state != REL_ON) 
	{
		if (relay4.relayON) syncOFF();
		//resetTapChangeBlindTime = FALSE;
	}
	*/
	//now change taps if required or turning on. Also control output relay
	if (changeTap || enterONMode) 
	{
		/*
		if (enterONMode && !isSWIMLow()) 
		{
			relay1.testMode = FALSE;
			relay2.testMode = FALSE;
			relay3.testMode = FALSE;
			relay4.testMode = FALSE;
		}
		*/
		enterONMode = FALSE;	//reset flag for next loop cycle
		syncTap();	//switch taps synchronizing to zero-crossing point
	}
	// if no tap change but state changed switch output relay (only in under/over-voltage conditions)
	else 
	{
		if ((relay4.state != REL_ON) && relay4.relayON) relay4.disableRelay();	//if state is not on and relay is on
		if ((relay4.state == REL_ON) && (!relay4.relayON))relay4.enableRelay());	//if state is on and relay is off
	}
		
}
//------------------------------------------------------------------------------------------------------------------------

//decide which tap we should be working with - adjust relayCombination & relayXSet accordingly
_Bool relaySelect(void)
{
	_Bool changeRequest = FALSE;
	
	//wait for timer
	
	//check whether we need to switch based on whichever combination we are currently in
	switch (relayCombination)
	{
		case 0:	// startup - no relay selected. We must choose a relay combination
			if (outputVoltage < LOW_VOLTAGE_EXTREME)
				desiredRelayComb = 0;		//if input voltage too low, stay in initial state and do nothing to avoid damage
			
			// if voltage < tap-up level for current sensitivity
			else if (outputVoltage < selectedTapUpVoltage)
			{
				relay1Set = TRUE;
				relay2Set = TRUE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 4;	// boost, Grey-Orange
			}
			else if (outputVoltage > selectedTapDownVoltage)
			{
				relay1Set = FALSE;
				relay2Set = TRUE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 6;	// buck, Yellow-Orange
			}
			else	// voltage betweeen tap change levels
			{
				relay1Set = FALSE;
				relay2Set = FALSE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 5;	//1:1, Yellow-Yellow
			}
			break;
			
		case 1:	//boost, Red-Yellow
			if (outputVoltage > selectedTapDownVoltage)
			{
				relay1Set = FALSE;
				relay2Set = TRUE;
				relay3Set = TRUE;
				changeRequest = TRUE;
				desiredRelayComb = 2;	// boost, Reg-Orange
			}
			else	// voltage betweeen tap change levels or undervoltage
			{
				relay1Set = FALSE;		//setting repeated just in case
				relay2Set = FALSE;
				relay3Set = TRUE;
				changeRequest = FALSE;
				desiredRelayComb = 1;	// boost, Red-Yellow
			}
			break;
			
		case 2:	// boost, Reg-Orange
			if (outputVoltage < selectedTapUpVoltage)
			{
				relay1Set = FALSE;
				relay2Set = FALSE;
				relay3Set = TRUE;
				changeRequest = TRUE;
				desiredRelayComb = 1;	// boost, Red-Yellow
			}
			else if (outputVoltage > selectedTapDownVoltage)
			{
				relay1Set = TRUE;
				relay2Set = FALSE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 3;	// boost, Grey-Yellow
			}
			else	// voltage betweeen tap change levels
			{
				relay1Set = FALSE;
				relay2Set = TRUE;
				relay3Set = TRUE;
				changeRequest = FALSE;
				desiredRelayComb = 2;	// boost, Reg-Orange
			}
			break;
			
		case 3: // boost Grey-Yellow
			if (outputVoltage < selectedTapUpVoltage)
			{
				relay1Set = FALSE;
				relay2Set = TRUE;
				relay3Set = TRUE;
				changeRequest = TRUE;
				desiredRelayComb = 2;	// boost, Reg-Orange
			}
			else if (outputVoltage > selectedTapDownVoltage)
			{
				relay1Set = TRUE;
				relay2Set = TRUE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 4;	// boost, Grey-Orange
			}
			else	// voltage betweeen tap change levels
			{
				relay1Set = TRUE;
				relay2Set = FALSE;
				relay3Set = FALSE;
				changeRequest = FALSE;
				desiredRelayComb = 3;	// boost, Grey-Yellow
			}
			break;
			
		case 4:	// boost, Grey-Orange
			if (outputVoltage < selectedTapUpVoltage)
			{
				relay1Set = TRUE;
				relay2Set = FALSE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 3;	// boost, Grey-Yellow
			}
			else if (outputVoltage > selectedTapDownVoltage)
			{
				relay1Set = FALSE;
				relay2Set = FALSE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 5;	// 1:1, Yellow-Yellow
			}
			else	// voltage betweeen tap change levels
			{
				relay1Set = TRUE;
				relay2Set = TRUE;
				relay3Set = FALSE;
				changeRequest = FALSE;
				desiredRelayComb = 4;	// boost, Grey-Orange
			}
			break;
			
		case 5: //1:1, Yellow-Yellow
		default:
			if ((outputVoltage < selectedTapUpVoltage))// && (outputVoltage > LOW_VOLTAGE_EXTREME))
			{
				relay1Set = TRUE;
				relay2Set = TRUE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 4;	// boost, Grey-Orange
			}
			else if (outputVoltage > selectedTapDownVoltage)
			{
				relay1Set = FALSE;
				relay2Set = TRUE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 6;	// buck, Yellow-Orange
			}
			else	// voltage betweeen tap change levels
			{
				relay1Set = FALSE;
				relay2Set = FALSE;
				relay3Set = FALSE;
				changeRequest = FALSE;
				desiredRelayComb = 5;	// 1:1, Yellow-Yellow
			}
			break;
			
			case 6: // buck, Yellow-Orange
			if (outputVoltage < selectedTapUpVoltage)
			{
				relay1Set = FALSE;
				relay2Set = FALSE;
				relay3Set = FALSE;
				changeRequest = TRUE;
				desiredRelayComb = 5;	// 1:1, Yellow-Yellow
			}
			else	// voltage betweeen tap change levels or overvoltage
			{
				relay1Set = FALSE;		//setting repeated just in case
				relay2Set = TRUE;
				relay3Set = FALSE;
				changeRequest = FALSE;
				desiredRelayComb = 6;	// buck, Yellow-Orange
			}
			break;
	}
	
	//start measuring blind time when detecting that taps need to be changed
	if (changeRequest && (!resetTapChangeBlindTime)) 
	{
		tapChangeBlindTime = 0;	//reset blind time counter
		resetTapChangeBlindTime = TRUE;	//set flag that reset has been done
	}
	return (changeRequest);
}	//relaySelect()
//------------------------------------------------------------------------------------------------------------------------

// synchronise any tap changing to switch the relay as close to the zero crossing as possible.
void syncTap(void)
{
	s16 delay = 0;
	// if tap-up requested and still in blind time don't do anything
	if ((desiredRelayComb < relayCombination) && (tapChangeBlindTime < TAP_CHANGE_BLIND_TIME_MSEC)) return;
	
	//reset blind-time-counter-reset-flag (indicating that it needs to be reset on next change request)
	resetTapChangeBlindTime = FALSE; 		
	
	// Need to time the relay switching to as near to going-positive zero crossing as possible
	
	//calculate delay required before switching relays in microseconds
	// ac period - 320us blanking from waitNeg function - relay switch time in us
	delay = (period)-320-RELAY_SWITCH_ON_TIME_US;	//delay to switch on relays that are going to be switched on
										//320us ???
										
	waitNeg();	//wait for start of negative 1/2 cycle
	
	if (delay > 6)	holdus((u16)delay);	//wait for the calculated time
						// don't use holdus with delay <7us
	//now switch on!
	#ifdef DEBUG
		GPIOtoggle(DEBUG_SYNC_PORT);
	#endif //debug
	if (relay2Set) relay2.enableRelay();
	if (relay1Set) relay1.enableRelay();
	if (relay3Set) relay3.enableRelay();
	if (relay4.state == REL_ON) relay4.enableRelay();
	
	delay = RELAY_SWITCH_ON_TIME_US - RELAY_SWITCH_OFF_TIME_US;
	
	if (delay > 6) holdus ((u16)delay);
	/*
	//now switch off!
	relay1.disableRelay();
	relay2.disableRelay();
	
	//wait for the relays to switch OFF.
	
	holdus(RELAY_SWITCH_OFF_TIME_US);
	
	//relays are now all OFF (assuming the delay is OK, and we are on the positive zero crossing.
	//now time the relays that go ON to the negative going half cycle
	delay = (period>>1)-320-RELAY_SWITCH_ON_TIME_US;
	
	if (delay > 0)	holdus((u16)delay);	//wait for the calculated time
	*/
	
	//now switch off!
	#ifdef DEBUG
	GPIOtoggle(DEBUG_SYNC_PORT);
	#endif //debug
	if (relay4.state != REL_ON) relay4.disableRelay();	//turn off the output if in OFF state, but the rest of relays are still switching
	if (!relay1Set)	relay1.disableRelay();
	if (!relay2Set) relay2.disableRelay();
	if (!relay3Set)	relay3.disableRelay();
	
	//wait for 1 complete cycle for things to settle
	holdus(period);
	waitNeg();
	relayCombination = desiredRelayComb;
}	//syncTap()

//------------------------------------------------------------------------------------------------------------------------

// self test of relays. This procedure requires 230VAC input and special connections:
// orange, grey, red connectors not connected. Thermal fuse disconnected.
// Yellow tap connected directly to Live (LIN and LIN/TFUSE can be used to connect)
// Live input connected to TFUSE and LOUT. Brown, NIN and Black connected normally. 
// This way brown tap always supplies the board, and 230V are always present at the input of relay 3.
// Switching relays 1-3 results in disconnecting LO from input voltage. 
// switching relay 4 allows to feed LO from LOUT and test relay 4. 
void testRelays(u8* error_vector)
{
	resDog();
	//switch on relay1
	syncON(&relay1);	//this can take up to 3 periods (max 86ms), Watchdog expires after 100ms
	resDog();
	// if voltage is not off then relay1 error set
	if (!isVoltageOFF()) *error_vector |= ERR5;
	resDog();
	relay1.disableRelay();					//switch back off relay1
	holdus(period);
	if (isVoltageOFF())		//if voltage is not back on then set error and return
	{
		*error_vector |= ERR5;
		return;	//if voltage is not back then return. Can't test next relay without voltage
	}
	resDog();
	syncON(&relay2);					//switch on relay2
	resDog();
	// if voltage is not off then relay2 error set
	if (!isVoltageOFF()) *error_vector |= ERR6;
	relay2.disableRelay();					//switch back off relay2
	holdus(period);
	if (isVoltageOFF())		//if voltage is not back on then set error and return
	{
		*error_vector |= ERR6;
		return;	//if voltage is not back then return. Can't test next relay without voltage
	}
	resDog();
	syncON(&relay3);					//switch on relay3
	resDog();
	// if voltage is not off then relay3 error set
	if (!isVoltageOFF())
	{
		*error_vector |= ERR7;
		return;		//if relay3 error then return, we need this relay to be working while testing relay4 
	}
	relay3.disableRelay();					//switch back off relay3
	holdus(period);
	if (isVoltageOFF())		//if voltage is not back on then set error and return
	{
		*error_vector |= ERR7;
		return;	//if voltage is not back then return. Can't test next relay without voltage
	}
	resDog();
	syncON(&relay4);					//switch on relay4
	resDog();
	holdus(period);
	resDog();
	syncON(&relay3);	//switch on relay3 to disconnect relay4 from input
	resDog();
	//now LO is disconnected from input but should be connected through relay4
	if (isVoltageOFF())		//if voltage is not on then set error and return
	{
		*error_vector |= ERR4;
		relay3.disableRelay();	//connect LO through relay3
		holdus(period);
		resDog();
		syncOFF(&relay4);				//having LO we can switch of relay4 in sync way
		return;	//if voltage is not back then return
	}
	resDog();
	syncOFF(&relay4);
	resDog();
	if (!isVoltageOFF()) *error_vector |= ERR4;
	relay3.disableRelay();
}	//testRelays()

#endif	//ASP_ENABLED

//------------------------------------------------------------------------------------------------------------------------

//switches off selected
//ensure relay turn off is sync'd
void syncOFF(Relay *rel)
{
	//calculate delay between positive zero crossing and relays switch off
	s16 delay = (period) - 320 - RELAY_SWITCH_OFF_TIME_US;
												//320us from WaitNeg ???
	waitNeg();	//wait for start of negative 1/2 cycle
	
	if (delay > 0)	holdus((u16)delay);	//wait for the calculated time
	
	//now switch off!
	#ifdef DEBUG
		GPIOtoggle(DEBUG_SYNC_PORT);
	#endif //debug
	rel->disableRelay();
	//waitNeg();		// in FSPE even after disconnecting LO from Live, there is still ~15V wave sensed, so waitNeg can be performed, but we don't need to risk
	holdus(period);
}
//------------------------------------------------------------------------------------------------------------------------

//switches on selected
//ensure relay turn on is sync'd
void syncON(Relay *rel)
{
	//calculate delay between positive zero crossing and relays switch off
	s16 delay = (period) - 320 - RELAY_SWITCH_ON_TIME_US;
												//320us from WaitNeg ???
	waitNeg();	//wait for start of negative 1/2 cycle
	
	if (delay > 0)	holdus((u16)delay);	//wait for the calculated time
	
	//now switch on!
	#ifdef DEBUG
		GPIOtoggle(DEBUG_SYNC_PORT);
	#endif //debug
	rel->enableRelay();
	//waitNeg();
	holdus(period);
}

//------------------------------------------------------------------------------------------------------------------------

//operating output relay (AVS function)
void operateRelay(Relay *rel)
{
	if (enterONMode)
	{
		rel->enableRelay();
		enterONMode = 0;
	}
	else 
	{
		if ((rel->state != REL_ON) && rel->relayON)		 rel->disableRelay();	//if state is not on and relay is on
		if ((rel->state == REL_ON) && (!rel->relayON)) 	rel->enableRelay();	//if state is on and relay is off
	}
}
//------------------------------------------------------------------------------------------------------------------------