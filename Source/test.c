#include "stm8s.h"
#include "stm8s_type.h"
#include "globals.h"
#include "options.h"
#include "adc.h"

// global functions
void testProcedure(void);
_Bool checkForTestProcedure(void);

// global variables
_Bool isCalibrating = FALSE;
volatile _Bool delayGood = FALSE;

// privare functions
_Bool isDelayBad(void);

// private variables


//------------------------------------------------------------------------------------------------------------------------

void testProcedure(void)
{
	u8 i;
	u8 test = 4;
	isCalibrating = TRUE;
	primeIntDelay();	// pull low and charge capacitor
	
	timer1Init();	//initialise TIM2 to generate interrrupt every 1s.
	
	resDog();
	//checkLEDs();
	led3 = LED_BLINK;
	led4 = LED_BLINK;
	
	resDog();
	
	for (i=0; i<6; i++)	//four measurements needed to calculate valid period (we use 5 for stability)
	{
		resDog();
		measureACPeriod();
	}		
	resDog();
	sampleVoltage(1);	// determine correction factor
	resDog();
	// if communication enabled transmit measured values
#if UART_ENABLED 
		UART1_PutString("Freq = \x09", NO_NL);
		Int2str(strNum, frequency);
		UART1_PutString(strNum, NL);
		UART1_PutString("CorrFact = \x09", NO_NL);
		Hex2str(strNum, (u32)getCorrectionFactor());
		UART1_PutString(strNum, NL);
#endif	//UART_ENABLED
	
	if (!acVmeasurementOK) 
	{
		errors |= ERR2;		//wrong period so no point in going further
		return;
	}

	if (isCorrectionFactorBad()) 
	{
		errors |= ERR3;
		return;
	}
	
	//testRelays(&errors);
	
/*	led5 = LED_BLINK; // 2024
	while (getPotADC() > 5)
		resDog();
	led5 = LED_ON;
	led2 = LED_BLINK;
	while (getPotADC() < (ADC_FULL_SCALE - 5))
		resDog();
	led2 = LED_ON;
	led7 = LED_BLINK;
	while (!isButtonPressed())
		resDog();
	while (isButtonPressed())
		resDog();
	led7 = LED_ON;
	led6 = LED_BLINK;
	while (!isButtonPressed())
		resDog();
	waitms(500);
	while (isButtonPressed())
		resDog();
	while (!isButtonPressed())
		resDog();
	led6 = LED_ON;
	led1 = LED_BLINK;
	
	while (!delayGood)
	{
		resDog();
		if (errors == ERR1)
		{
			stopTimer1();
			return;
		}
	}
			*///2024
	stopTimer1();
	
	
	if (0)//(!isVoltageONok())	//check if voltage is within specified range (230V +-5%)
	{
		errors |= ERR3;			//if input voltage has changed or for some reason correction factor is wrong
		return;
	}
	
	waitms(1000);
	relay1.enableRelay();
	led1 = LED_ON;
	
	resDog();
	/*for (i=0; i<4; i++)
		if (GPIOisBitHigh(ID_PORT))
			test++;
		else
			test--;*/ // 2024
	
	if (1)//(test == 8)	//AVS13 //2024
		while (*EEPROM_AVS_TYPE != AVS13_FLAG)
			writeInternalEEPROM16bit(AVS13_FLAG, EEPROM_AVS_TYPE);
	else if (test == 0)	//AVS15
		while (*EEPROM_AVS_TYPE != AVS15_FLAG)
			writeInternalEEPROM16bit(AVS15_FLAG, EEPROM_AVS_TYPE);
	else
	{
		errors |= ERR4;
		return;
	}
	
	resDog();	

#if FIRST_30_MIN_ENABLED
		while (!isFirst30min())
			writeInternalEEPROM16bit(0x00FE, EEPROM_FIRST_30_MIN_ADD);	//set flag in EEPROM, that unit is in initial 30 minutes of operation
#else 
		writeInternalEEPROM16bit(0x0000, EEPROM_FIRST_30_MIN_ADD);	//reset flag in EEPROM when this feature is disabled
#endif //FIRST_30_MIN_ENABLED

	while (!isCalibrationDone())
		writeInternalEEPROM16bit(0x00FE, EEPROM_CALIBRATION_DONE);	//set calibration flag in EEPROM
		
		
}	//testProcedure
//------------------------------------------------------------------------------------------------------------------------

_Bool isDelayBad(void)
{
	vu16 delayADCcount = 0, tst = 0;
	primeIntDelay();	// pull low if it hasn't been already pulled and charge capacitor
	waitms(4000);				// wait 4 more sec to make sure delay is primed properly
	//tst = getIntDelay();
	releaseIntDelay();	// start discharging
	waitms(10000);			//wait for 10s
	delayADCcount = getIntDelay();
	
	// if communication enabled transmit measured delay adc
#if UART_ENABLED
		UART1_PutString("DelayStart = \x09", NO_NL);
		Int2str(strNum, tst);
		UART1_PutString(strNum, NL);
		UART1_PutString("DelayStop = \x09", NO_NL);
		Int2str(strNum, delayADCcount);
		UART1_PutString(strNum, NL);
#endif	//UART_ENABLED
	
	//delay count range calculated in excel spreadsheet
	if ((delayADCcount < (TEST_INT_DELAY_ADC_LEVEL - 90)) || (delayADCcount > (TEST_INT_DELAY_ADC_LEVEL + 100)))
		return TRUE;
	return FALSE;
}
//------------------------------------------------------------------------------------------------------------------------

_Bool checkForTestProcedure(void)
{
	if (!isYGlow())
		return (FALSE);
		
	if (!isButtonPressed2())
		return (FALSE);
		
	if (getPotADC() < (ADC_FULL_SCALE - 5))
		return (FALSE);
		
	return (TRUE);
}