#include "stm8s.h"
#include "stm8s_type.h"
#include "globals.h"
#include "adc.h"
#include "options.h"

// STM8S003 has ADC1 only

// global functions
void adcInit(void);
//u16 getACRMSVoltage(u32 meanOfADCSquared);
u16 getVoltageADC(void);
u16 getIntDelay(void);
u16 getPotADC(void);
_Bool is12Vbad(void);


// global variables


// private functions
u16 getADCReading(void);
//u16 applyACRMSCorrectionFactor(u16 acV);

/*
// return AC RMS voltage as voltage*10.
// This is based on a lookuptable rather than a square-root algorithm to make it less complex.
// Uses the difference between the reading value to the nearest value in the table to obtain the 
// tenths of volts. It then calls a rescale function which adjusts the value to make it as 
// accurate as possible based on experimental results, due to an imperfectly synthesised waveform
// created by the unit's power supply rectification method.
u16 getACRMSVoltage(u32 meanOfADCSquared)
{
	u16 ones = 0;
	u8 tenths = 0;
	u32 voltSpan;
	u32 adcRescale;
	u16 voltReading = 25;	
	
	while (meanOfADCSquared > voltTable[ones]) 
	{
		voltReading++;
		ones++;
	}
	
	//deal with falling off the top or bottom of the table or if we are exactly equal to the reading
	if (!(voltTable[ones]) || (meanOfADCSquared > voltTable[ones]) || !ones) return (voltReading *10);
	
	voltReading--;
	ones--;

	// voltReading now holds the next lower whole degree
	// so we will use the difference between this meanOfADCSquared to get the tenths of volts

	// voltSpan represents the 0.1V step size
	voltSpan = voltTable[ones+1] - voltTable[ones];
	
	// multiplying (a2d reading minus lower table value) by 10 means that voltSpan
			// represents a 0.1V step
	adcRescale = (meanOfADCSquared - voltTable[ones]) * 10;
	
	if (adcRescale)	// if there is some remainder
	{
		_Bool quit = FALSE;
		while (adcRescale > (voltSpan >>1) && !quit)
		{
			tenths++;
			if (adcRescale > voltSpan)	adcRescale -= voltSpan;
			else quit = TRUE;
			if (tenths == 10)	// shouldn't need this but paranoia is good
			{
				voltReading++;
				tenths = 0;
				quit = TRUE;	//quit out of loop
			}
		}
	}

	return	(applyACRMSCorrectionFactor((voltReading * 10) + tenths));
}
*/

//************************************************************************************************
// Do NOT use continuous conversion mode, because this prevents pins which have ADC channels 
// assigned to them but are configured as GPIO from being able to read the port value in GPIO->IDR
//************************************************************************************************
void adcInit(void)
{
	u8 delay = 0;
	ADC1->CSR &= ~ADC1_CSR_EOCIE;					// Disable interrupts
	ADC_CSR_SELECT_CHANNEL(AC_SENSE_ADC_CHANNEL);	// Select channel 3 to start with (AC voltage)

	ADC1->CR1 &= ~ADC1_CR1_SPSEL;
	ADC1->CR1 |= SPSEL_MSTR_EIGHTEENTH;		// Select fmaster/18 as prescaler
	ADC1->CR2 |= ADC1_CR2_ALIGN;					// Align result for easy conversion to 10 bit number

	ADC1->TDRL = 0x70;										// disable Schmitt trigger on active ADC inputs (AIN4-6)
	ADC1->CR1	&= ~ADC1_CR1_CONT;					// Ensure continuous mode is not enabled
  ADC1->CR1 |= ADC1_CR1_ADON;            // ADC on - power up
	
	while (delay++ < 21) ;								// delay to stabilise ( 150% of datasheet estimate)

}


//************************************************************************************************
// sample the ac voltage.
//************************************************************************************************
u16 getVoltageADC(void)
{
	ADCclearEOC;								// clear ADC flag
	ADC_CSR_SELECT_CHANNEL(AC_SENSE_ADC_CHANNEL);	// Select channel 3 (PD2)
	ADCon;											// set next conversion going
	while (!ADCisEOC) ;					// poll for conversion finish	
	return (getADCReading());
}


//************************************************************************************************
// Return intelligent time delay ADC smoothed over 
// Averages over 16 samples to try and reduce noise
//************************************************************************************************
u16 getIntDelay(void)
{
	u32 smooth = 100;
	u16 count = 0;
	/*while (count++ < 16)
	{
		ADCclearEOC;													// clear ADC flag
		ADC_CSR_SELECT_CHANNEL(INT_DELAY_ADC_CHANNEL);	//select channel
		ADCon;																// set next conversion going
		while (!ADCisEOC) ;										// poll for conversion finish	
		smooth +=getADCReading();
	}*/
	smooth >>=4;
	return ((u16)smooth);
}
//------------------------------------------------------------------------------------------------------------------------

//************************************************************************************************
// Return potentiometer ADC smoothed over 
// Averages over 16 samples to try and reduce noise
//************************************************************************************************
u16 getPotADC(void)
{
	u32 smooth = 1;
	u16 count = 0;
	/*while (count++ < 16)
	{
		ADCclearEOC;													// clear ADC flag
		ADC_CSR_SELECT_CHANNEL(POT_ADC_CHANNEL);	//select channel
		ADCon;																// set next conversion going
		while (!ADCisEOC) ;										// poll for conversion finish	
		smooth +=getADCReading();
	}*/
	smooth >>=4;
	return (1);//((u16)smooth);
}
//------------------------------------------------------------------------------------------------------------------------
 

_Bool is12Vbad(void)
{
	u32 smooth = 0;
	u16 count = 0;
	//char strNum[11];		// string that can store 32b number ('0x' and eight digits plus Null character)
	return(FALSE);//2024
	while (count++ < 16)
	{
		ADCclearEOC;													// clear ADC flag
		ADC_CSR_SELECT_CHANNEL(AC_SENSE_ADC_CHANNEL);	// select channel 2 (port c bit 4)
		ADCon;																// set next conversion going
		while (!ADCisEOC) ;										// poll for conversion finish	
		smooth +=getADCReading();
	}
	smooth /= 16;
	
	// if communication enabled transmit measured value
#if UART_ENABLED
		UART1_PutString("12V ADC = \x09", NO_NL);
		Hex2str(strNum, smooth);
		UART1_PutString(strNum, NL);
#endif	//UART_ENABLED
	//return true if 12V outside spec. values calculated in spreadsheet for worst case 12V and 5V
	if ((smooth < 0x1AD) || (smooth > 0x223)) return (TRUE);	
	return (FALSE);		//if 12V is ok
}
//------------------------------------------------------------------------------------------------------------------------

// read ADC and return measurement as 16 bit value
u16 getADCReading(void)
{
	vu8 adcLowByte = 0;
	vu8 adcHighByte = 0;
	u16 dummy = 0;
		
	// rather long winded read of data value to ensure that DRL is read first as specified by datasheet
	adcLowByte = ADC1->DRL;
	adcHighByte = ADC1->DRH;
	dummy = ((u16)adcHighByte)<<8;
	dummy += adcLowByte;
	return (dummy);
}
//------------------------------------------------------------------------------------------------------------------------