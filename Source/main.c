#include "stm8s.h"
#include "stm8s_type.h"
#include "timers.h"
#include "adc.h"
#include "globals.h"
#include "options.h"
#include "relay.h"

// main.c

//*************************************************************************
//this firmware is based on FSPE fimware to be used with AVS13/15
//*************************************************************************

// public functions
void primeIntDelay(void);
void releaseIntDelay(void);
_Bool isCalibrationDone(void);

// Global variables
volatile _Bool intDelayPrimed = FALSE;
vu8 errors = 0x00;
volatile FlagStatus isSwitchOn; 
_Bool isAVS13;
volatile int i;
// 7-Seg Display
extern volatile _Bool displayUpdate;
extern volatile u8 dimmingFlag;
static u8 digits[3] = {0}; // To store the digits to be displayed
static u8 currentSegment = 0; // To track the current active segment
u8 ledCount = 0;
u16 localCounter;
bool dimmingSet = TRUE;
bool menuDisplay = FALSE;
//private functions
void setClock(void);
void errorMode(void);
_Bool isFirst30min(void);
void prepareValueToDisplay(u16 value);
void updateDelay(void);

void checkSwiches(void);
//private variables

extern u16 outputVoltage;
extern volatile u16 testVal;
//------------------------------------------------------------------------------------------------------------------------	
void main(void)
{
	u8 counter30min = 0;
	
	
	disableInterrupts();	
	enableIWatchDog();		// 100ms
	setClock();	// set clock to 16MHz
	GPIOinit();
	initIntPriorities();	// priorities to various interrupts
	timer4Init();					// timer4 is set to every 250us, gives a 1ms, 1/2sec, 1sec etc.
	adcInit(); 						
	
	// if serial communication enabled
#if UART_ENABLED
	UART1_Config();
	//if (UART_ENABLED) UART1_Config();
#endif	//UART_ENABLED
	initRelays();

#if SENSITIVITY_ENABLED
	initSensitivity();
#endif	//SENSITIVITY_ENABLED

	enableInterrupts();	
	
	/*//flash all LEDs on startup
	led1 = LED_ON;
	led2 = LED_ON;
	led3 = LED_ON;
	led4 = LED_ON;
	led5 = LED_ON;
	led6 = LED_ON;
	led7 = LED_ON;
	waitms(1000);
	//initLEDs();		// configure initial state of all LEDs	
	*/
#if UART_ENABLED
	//if communication enabled transmit firmware version (set in options.h)
	UART1_PutString(FW_VERSION, NL);
#endif

	//calibration mode
	if(checkForTestProcedure())//(isYGlow())//(isSWIMLow())
	{
		UART1_PutString("Test Start",NL);
		// relay->testMode flag could be set here but we don't make any use of this flag in this software
		testProcedure();	//test procedure to be executed with stable input voltage of 110V
		errorMode();
		UART1_PutString("Test End",NL);
	}

	resDog();
	
	//if communication enabled transmit correction factor
#if UART_ENABLED
		UART1_PutString("CorrFact = \x09", NO_NL);			// 0x09 is horizontal tab in ASCII
		Hex2str(strNum, (u32)getCorrectionFactor());		//change hex to string representation
		UART1_PutString(strNum, NL);
#endif	//UART_ENABLED
	
	resDog();
	
	//Before doing anything check if calibration has been done. If not, stop and blink ERR3.
	//If calibration factor for any reason is out of expected range, or calibration hasn't been done
	if (0)//(isCorrectionFactorBad() || !isCalibrationDone()) //2024
	{
		errors |= ERR3;
		errorMode();
	}
	
	//check if avs type has been correctly written in EEPROM
	if (0)//((*EEPROM_AVS_TYPE != AVS13_FLAG) && (*EEPROM_AVS_TYPE != AVS15_FLAG))
	{
		errors |= ERR4;
		errorMode();
	}
	
	// Header for later measurements
#if UART_ENABLED
	UART1_PutString("Freq\x09Voltage\x09RelComb\x09RelState", NL);
#endif	//UART_ENABLED
	
	updateIntDelay();
	isSwitchOn =  !(IntDelaySecs == 0xFFFF);
	//updateAVSState(&relay1);
	
	// prime ac period measurement averaging process over 4 readings
	
	measureACPeriod();
	resDog();
	measureACPeriod();
	resDog();
	measureACPeriod();
	resDog();
	measureACPeriod();	//4th added because first measurement is always not accurate (too short period measured)
	// All digits off. 
	GPIOsetLow(DIGIT0);
	GPIOsetLow(DIGIT1);
	GPIOsetLow(DIGIT2);
	GPIOsetLow(DIGIT3);
	prepareValueToDisplay(123);
	
//****************************************************************************
// main loop
//****************************************************************************
	while (1)
	{
		GPIOtoggle(TEST_LED_DISC);//2024
		refreshDisplay();
		checkSwiches();
		//GPIOsetHigh(RELAY1_PORT);
		
		resDog();
		
		//Measuring ac frequency
		measureACPeriod();		//max 57ms (2 longest periods)
		
		//Measuring ac voltage
		sampleVoltage(0);			//max 29ms (half of longest period
		
		// update flags for output relay based on conditions and state
		processRelay(&relay1);
		
		//perform output relay state-specific functions and state updates
		relayFunction(&relay1);
		
		resDog();
		
		//aspFunction();	//voltage regulation, max 86ms (3 longest periods) 
		operateRelay(&relay1);
		
		resDog();
		
		updateAVSState(&relay1);
		if(!menuDisplay)
			prepareValueToDisplay(outputVoltage/160);//(testVal);
		//handleLEDS();		//handle leds according to output relay state
		
		// in debug mode transmit all measurements
		#ifdef DEBUG
			#if UART_ENABLED 
				TransmitData();
			#endif	//UART_ENABLED
		#endif	//DEBUG
		
		if (secondTicker)
		{
			secondTicker = FALSE;
			
			updateIntDelay();
			localCounter++;
			
			if(menuDisplay)
			{
				if(localCounter > 15)
				{
					menuDisplay = FALSE;
				}
			}
			
			
			
		#if SENSITIVITY_ENABLED
			updateSensitivity();	//control sensitivity of ASP function
		#endif	//SENSITIVITY_ENABLED
			
			//in normal operation transmit measurements every second
			#ifndef DEBUG
				#if UART_ENABLED
					TransmitData();
				#endif	//UART_ENABLED
			#endif
		}
		
		if (minuteTicker)
		{
			minuteTicker = FALSE;
			if (isFirst30min())		// if first 30 minutes is disabled then it will always read false
				if (++counter30min >= 30) 
					while (isFirst30min())
						writeInternalEEPROM16bit(0x0000, EEPROM_FIRST_30_MIN_ADD);	//reset flag in EEPROM when unit is no longer in initial 30 minutes of operation
		}
			
	}

}	//main
//------------------------------------------------------------------------------------------------------------------------


// Segment values for displaying digits 0-9 (anode configuration)
const u8 segArray[11] = {0x81, 0xf3, 0x49, 0x61, 0x33, 0x25, 0x05, 0xf1, 0x01, 0x21, 0x00};
const u8 ledArray[8] = {0x00, 0x40, 0x80, 0x08, 0x10, 0x20, 0x04, 0x02};

void checkSwiches(void)
{
	static bool menuSwState = FALSE;
	
	if (isButtonPressed3()) 
	{                            // Debounce delay
	  if(dimmingSet)dimmingSet = FALSE;
		else dimmingSet = TRUE;
		
		UART1_PutString("SW3",NL);
		while(isButtonPressed3())
		{
					resDog();
		}
	}
	
	else if(isButtonPressed2())
	{
		UART1_PutString("SW2",NL);
	}
	
	else if(isButtonPressed())
	{
		if(localCounter && !menuSwState)
		{
			 localCounter = 0;
			 menuSwState = TRUE;
		}
		else if(menuSwState && localCounter > 2)
		{
			resDog();
			updateDelay();
			menuSwState = FALSE;
		}
	}

}

void prepareValueToDisplay(u16 value) 
{
	 // Extract digits and prepare the digits array
		u8 loopCount = 0;  
	 // Extract digits and store them in the `digits` array
    for (loopCount = 0; loopCount < 3; loopCount++) 
    {
        digits[2 - loopCount] = value % 10; // Extract the least significant digit
        value /= 10; // Remove the last digit
    }
}

void refreshDisplay(void)
{
	static u8 dimmingCounter = 0; // Keeps track of the dimming state
	static _Bool previousDimState = FALSE;
	
	if(dimmingSet)
	{
		if(dimmingFlag < DIMMING_DUTY)
		{
			//dimmingFlag = 0;
			if(!previousDimState)
			{
				previousDimState = TRUE;
				// Set the value for the current segment
				currentSegment = (currentSegment + 1);
				if(currentSegment > 3) currentSegment = 0;
				
				if(currentSegment < 3)
					GPIOportValue(SIG_DATA_PORT, ~segArray[digits[currentSegment]]);
				else if (currentSegment == 3)
					GPIOportValue(SIG_DATA_PORT, ledArray[ledCount]);
					
				GPIOsetLow(DIGIT3);
				GPIOsetLow(DIGIT2);
				GPIOsetLow(DIGIT1);
			  GPIOsetLow(DIGIT0);	
				
				switch (currentSegment) 
				{
						case 0: GPIOsetHigh(DIGIT3); break;
						case 1: GPIOsetHigh(DIGIT2); break;
						case 2: GPIOsetHigh(DIGIT1); break;
						case 3: GPIOsetHigh(DIGIT0); break;
				}
			}
		}
		else if(dimmingFlag < DIMMING_OFF_DUTY)
		{
			previousDimState = FALSE;
			GPIOsetLow(DIGIT3);
			GPIOsetLow(DIGIT2);
			GPIOsetLow(DIGIT1);
			GPIOsetLow(DIGIT0);
		}
		else
		{
			dimmingFlag = 0;
			previousDimState = FALSE;
		}
	}
	else if (displayUpdate && !dimmingSet) 
	{
		
    // Clear the previous segment
    GPIOsetLow(DIGIT1);
    GPIOsetLow(DIGIT2);
    GPIOsetLow(DIGIT3);
		GPIOsetLow(DIGIT0);
		//GPIOsetHigh(DIGIT3);

		currentSegment = (currentSegment + 1);
		if(currentSegment > 3)currentSegment = 0;
    // Set the value for the current segment
		if(currentSegment < 3)
			GPIOportValue(SIG_DATA_PORT, ~segArray[digits[currentSegment]]);
		else if (currentSegment == 3)
			GPIOportValue(SIG_DATA_PORT, ledArray[ledCount]);
		//GPIOportValue(SIG_DATA_PORT, segArray[9]);
		// Activate the current segment
		switch (currentSegment) 
		{
				case 0: GPIOsetHigh(DIGIT3); break;
				case 1: GPIOsetHigh(DIGIT2); break;
				case 2: GPIOsetHigh(DIGIT1); break;
				case 3: GPIOsetHigh(DIGIT0); break;
		}
    // Move to the next segment (wrap around after 3)
    //currentSegment = (currentSegment + 1) % 3;
		
    // Reset the displayUpdate flag
    displayUpdate = FALSE;
	}
}

void updateDelay(void)
{
	 u16 intDelay = *EEPROM_AVS_DELAY_SECS;
	
	menuDisplay = TRUE;
	prepareValueToDisplay(intDelay);
	intDelay = intDelay + 10;
	
	writeInternalEEPROM16bit(intDelay, EEPROM_AVS_DELAY_SECS);
	
}

//Something unexpected has happened, so wait for 30 seconds blinking red LED
// before resetting in order to see if normal operation can be resumed
void errorMode(void)
{
	u8 i;
	u8 waitCounter;
	//return; // 2024
	if (!errors)	//if no errors
	{
		/*led2 = LED_BLINK;	//indicate OK by flashing all leds apart from led1
		led3 = LED_BLINK;
		led4 = LED_BLINK;
		led5 = LED_BLINK;
		led6 = LED_BLINK;
		led7 = LED_BLINK;*/
				
		// if communication enabled transmit message
		if (UART_ENABLED) UART1_PutString("No errors", NL);
		
		while(1)	resDog();		//stay here happy and wait for cycling power
	}
	else 
		writeInternalEEPROM16bit(0, EEPROM_CALIBRATION_DONE);	//reset calibration flag in EEPROM
		//initLEDs();
		while(1)
			for(i=0;i<8;i++)
				if (errors & 1<<i)	//if error found then blink it
				{
					// if communication enabled transmit error number
					if (UART_ENABLED) 
					{
						UART1_PutString("ERR", NO_NL);
						Int2str(strNum, i+1);
						UART1_PutString(strNum, NL);
					}
					//NblinkRED(i+1);	
					waitms(2000);		//wait for 1.5sec between errors
				}
}
//------------------------------------------------------------------------------------------------------------------------

_Bool isFirst30min(void)
{
	return (*EEPROM_FIRST_30_MIN_ADD == 0x00FE);
}
//------------------------------------------------------------------------------------------------------------------------

_Bool isCalibrationDone(void)
{
	return (*EEPROM_CALIBRATION_DONE == 0x00FE);
}
//------------------------------------------------------------------------------------------------------------------------

//Set Clock to internal HSI 16MHz
void setClock(void)
{
	u16 counter = 12590;
	CLK->CKDIVR = 0;	// set prescaler to 0
	// 1. Set SWEN bit in SWCR
	CLK->SWCR |= CLK_SWCR_SWEN;
	// 2. Ensure clock switch interrupt is disabled	
	CLK->SWCR &= (u8)(~CLK_SWCR_SWIEN); // disable int
	// 3. Write target clock source in CLK->SWR
	CLK->SWR = 0xE1;	// 0xB4 = HSE
										// 0xE1 = HSI
										// 0xD2 = LSI

	// 4. Poll for SWBSY flag in CLK->SWCR
	while ((CLK->SWCR & CLK_SWCR_SWBSY) && counter) counter--;
}
//------------------------------------------------------------------------------------------------------------------------

//Prime the intelligent time delay by pulling the pin low to charge the int delay capacitor
void primeIntDelay(void)
{
	GPIOsetOutputPushPull(INT_DELAY_PORT);
	GPIOsetLow(INT_DELAY_PORT);
	intDelayPrimed = TRUE;
}
//------------------------------------------------------------------------------------------------------------------------

//Allow the inteilligent delay to run, by releasing the pin, allowing the cap to discharge, so that it can be monitored.
void releaseIntDelay(void)
{
	GPIOsetInputFloatNoInt(INT_DELAY_PORT);
	intDelayPrimed = FALSE;
}
//------------------------------------------------------------------------------------------------------------------------
