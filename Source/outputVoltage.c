#include "stm8s.h"
#include "stm8s_type.h"
#include "globals.h"
#include "adc.h"
#include "timers.h"
#include "options.h"


#define DUMMY_CO_FAC 0x1A0
#define NUM_SAMPLES_PER_CYCLE	(64)		//number of samples to be taken per cycle (x2 of samples per half-cycle)

#define DIV_NO	(8)		//normalizing factor to keep voltage variables in range

#define HALF_CYCLE_NEGATIVE_THRESHOLD		8//(8)	// number of adc counts for negative threshold

#define CORRECTION_FACTOR_HIGH	(0x200)		//correction factor for Vcc=5.3V (including resistors tolerances)
#define CORRECTION_FACTOR_LOW		(0x174)		//correction factor for Vcc=4.7V (including resistors tolerances)
#define CORRECTION_FACTOR_ADDRESS				((u16 *) 0x4000)	//address set to the begining of data EEPROM
//global functions
void measureACPeriod(void);
void sampleVoltage(_Bool);
//void waitPos(void);
void waitNeg(void);
_Bool isCorrectionFactorBad(void);
_Bool isVoltageONok(void);
_Bool isVoltageOFF(void);
u16 getCorrectionFactor(void);
u8 generateRandomDelay(void);

//global variables
volatile u16 outputVoltage = 0;
u16 period = 0;
u16 frequency = 0;
_Bool acVmeasurementOK = FALSE;
u8 randomSource = 0;

volatile u16 testVal = 0;


// local functions
//u16 applyTransformerRatio(u16 acV);

// local variables
//voltage calibration factor to normalize voltage adc measurements to the theoretical value @ Vcc=5.4V
u16 * const correctionFactor = CORRECTION_FACTOR_ADDRESS; //constant pointer to correction factor in data EEPROM
//_Bool frequencyErrorLow = FALSE;
//_Bool frequencyErrorHigh = FALSE;
//------------------------------------------------------------------------------------------------------------------------

//Determines a.c. period, averaged over last 4 measurements
// and resulting frequency.
// Works by waiting for the ac waveform zero cross positive to negative, 
// Then starting timer 2, and waiting for the next + to - zero cross.
// The result is put into a record of the last 4 readings and an average
// value is put into the variables "period" and "frequency".
// status flags frequencyErrorLow and frequencyErrorHigh and 
// acVmeasurementOK are updated.
void measureACPeriod(void)
{
	static vu16 reading1 = 0;
	static vu16 reading2 = 0;
	static vu16 reading3 = 0;
	static vu16 reading4 = 0;
	static u8 currentReading = 0;
	u16 timerReading = 0;
// in debug mode pin3 of port C can be used to synchronize scope and watch relay switching
#ifdef DEBUG	
	GPIOsetOutputPushPull(DEBUG_SYNC_PORT);
	GPIOsetLow(DEBUG_SYNC_PORT);
#endif //debug
	
	resetTimer2((u16)((u32)MIN_FREQ_PERIOD_US));		//initialize to longest acceptable period (in us)
	waitNeg();
	startTimer2();
	waitNeg();
	stopTimer2();
	timerReading = getTimer2uSec();
	//frequencyErrorLow = FALSE;
	//frequencyErrorHigh = FALSE;
	//if (hasTimer2Expired())	frequencyErrorLow = TRUE;		//if counter reloaded than period longer than longest accepted
	//else if (timerReading < MAX_FREQ_PERIOD_US)	frequencyErrorHigh = TRUE;
	
	//record current reading
	if (!currentReading)
	{
		reading1 = timerReading;
		currentReading++;
	}
	else if (currentReading == 1)
	{
		reading2 = timerReading;
		currentReading++;
	}
	else if (currentReading == 2)
	{
		reading3 = timerReading;
		currentReading++;
	}
	else
	{
		reading4 = timerReading;
		currentReading = 0;
		acVmeasurementOK = TRUE;
	}
	//if (frequencyErrorLow || frequencyErrorHigh) acVmeasurementOK = FALSE;
	period = ((u16)(((u32)reading1+(u32)reading2+(u32)reading3+(u32)reading4)>>2));		//averaging 4 period measurements
	frequency = (u16)(((u32)10000000/period));	// frequency x10
	if ((frequency < (MIN_FREQUENCY * 10)) || (frequency > (MAX_FREQUENCY * 10)))			//frequency error based on average value
		acVmeasurementOK = FALSE;
		
}	// measureACPeriod
//------------------------------------------------------------------------------------------------------------------------
	
/*
// wait for start of positive half cycle. Measure frequency of negative 1/2 cycle
// blocking - other process wait for this to finish
void waitPos(void)
{
	u8 count = 0;

		// waiting for positive to negative half cycle
		
	//wait until voltage sample is low for 5 successive readings
	while (count < 5)
	{
		if (getVoltageADC() < HALF_CYCLE_NEGATIVE_THRESHOLD) count++;
		else count = 0;
	}
	
	//320us blanking delay
	holdus(320);
	
	//Now wait for the start of the positive half-cycle
	
	//Originally this was done by checking for the ADC to rise above a threshold, but this level varies
	//with line due to irregularities in the waveform (Due I believe to the input cap on the power supply), so it was replaced.
	
	//waiting for ADC level to rise back above threshold to indicate positive half cycle for 5 successive readings
	//count = 0;
	//while (count < 5)
	//{
	//	if (getVoltageADC() >= HALF_CYCLE_NEGATIVE_THRESHOLD) count++;
	//	else count = 0;
	//}
	
	// This method looks at the slope of the waveform - looking for a significant change in slope. If the reading changes by > 8 counts
	// within 100us then the start of the positive cycle is deemed to have started.
	count = 0;
	//wait for adc count to at least double from 100us ago
	while (count < 10)
	{
		u16 newReading = 0;
		u16 oldReading = getVoltageADC();
		holdus(100);
		newReading = getVoltageADC();
		if ((newReading > oldReading) && (newReading > HALF_CYCLE_NEGATIVE_THRESHOLD))
		{
			if ((newReading - oldReading) > 8) count = 11;
		}
	}
}

*/

//wait for start of negative half-cycle, by sampling the ac waveform
void waitNeg(void)
{
	u8 count = 0;
	testVal = getVoltageADC();
	// Stop until we are in the positive half-cycle
	while (count < 5)
	{
		if (getVoltageADC() >= HALF_CYCLE_NEGATIVE_THRESHOLD) count++;
		else count = 0;
	}
	
	count = 0;
	//wait until voltage sample is low for 5 successive readings - the start of the negative half cycle
	while (count < 5)
	{
		if (getVoltageADC() < HALF_CYCLE_NEGATIVE_THRESHOLD) count++;
		else count = 0;
	}
	//half-period blanking delay to start of positive half-cycle
	//holdus(period>>1);
}
//------------------------------------------------------------------------------------------------------------------------
	

// calculates ac MS output voltage or performs calibration.
// In normal mode (parameter 0) function takes 32 samples over the positive half-cycle at equally spaced
// intervals, squares them and adds them to a running total.
// It then takes the average and applies correction factor (bsed on factory calibration)
// To keep 16 bit numbers result is divided by 8
// In calibration mode (parameter 1) function calculates correction factor based on known ideal value.
// This ideal value is calculated in excel spreadsheet for Vcc=5.4V, so that factor Videal/Vmeas will always
// be <1. We store it as factor * 512. Correction factor is stored in data EEPROM.
void sampleVoltage(_Bool calibration)
{
	u8 nSamples = (NUM_SAMPLES_PER_CYCLE / 2);	//number of samples to be taken per half-cycle
	vu32 samplesSum = 0;
	vu32 square = 0;
	_Bool ovf = FALSE;
	//return; // 2024
	//reset timer
	stopTimer2();
	resetTimer2(period / NUM_SAMPLES_PER_CYCLE);	//sampling period
	
	holdus(period / 2 - period / NUM_SAMPLES_PER_CYCLE / 2);	//wait for positive half cycle minus half sampling cycle to achieve symmetrical sampling
	while (nSamples--)
	{		
		startTimer2();
		// wait for timer to expire
		while (!timer2OverflowFlag) ;
		//get voltage sample, square it and add to summation
		square = getVoltageADC();
		timer2OverflowFlag = FALSE;
		//if (square == 1023) ovf = TRUE;	// overflow set if any sample saturates ADC
		square *= square;
		samplesSum += square;
	}
	stopTimer2();
	
	if (samplesSum > (u32)0xFFFFFF) ovf = TRUE;
	randomSource = samplesSum;
	
	samplesSum /= (NUM_SAMPLES_PER_CYCLE / 2);	//average of square values
	
	//if in calibration mode
	if (calibration)
	{
		samplesSum /= DIV_NO; // dividing factor used to achieve 16-bit number (this is the way we store voltage value)
		writeInternalEEPROM16bit(((CAL_REF_VOLT * (u32)512) / samplesSum), correctionFactor);	//correction factor is stored as (V_ideal/V_measured)*512
		return;
	}

	samplesSum *= DUMMY_CO_FAC;//0x13A;//*correctionFactor;	//2024	//correction factor applied (value stored in EEPROM is correction factor (<1) multiplied by 512)
	
	/* if unit works in boost (settings 1-4) and suddenly voltage jumps up, measured output voltage is too high to keep samplesSum size of 16 bits
	so after reducing to 16b we would have wrong small value of outputVoltage, which would cause wrong operation and possible damage. 
	So when ovf flag is set, outputVoltage is arbitrary set to max value FFFF*/
	if (ovf)
		outputVoltage = 0xFFFF;
	else
		//calibrated value
		outputVoltage = (u16)(samplesSum / (u32)(DIV_NO * 512));			//divided by 4096 (=512*8). 512 because of calibration factor, 8 to reduce number of bits to 16
}	// sampleVoltage
//------------------------------------------------------------------------------------------------------------------------

// this fuction is used to generate random standard delay (within specified range)
// it uses least significant byte of ADC voltage measurement (random timing)
// We need to generate standard delay in two cases - at power up, when there is no intelligent delay,
// and after intelligent delay has finished, to add standard random delay.
u8 generateRandomDelay(void)
{
#if RANDOM_DELAY_ENABLED
	u8 random;

		random = randomSource;
	
	while ((random < STANDARD_WAIT_DELAY_SECS_MIN) || (random >STANDARD_WAIT_DELAY_SECS_MAX))
	{
		if (random < STANDARD_WAIT_DELAY_SECS_MIN)
			random += STANDARD_WAIT_DELAY_SECS_MIN;
		if (random > STANDARD_WAIT_DELAY_SECS_MAX)
			random = random - (STANDARD_WAIT_DELAY_SECS_MAX - STANDARD_WAIT_DELAY_SECS_MIN + 1);
	}
	
	return random;
#else
	if (*EEPROM_AVS_TYPE == AVS13_FLAG)
		return (STANDARD_WAIT_DELAY_SECS_AVS13);
	else
		return (STANDARD_WAIT_DELAY_SECS_AVS15);
#endif 	//RANDOM_DELAY_ENABLED
}
//------------------------------------------------------------------------------------------------------------------------

u16 getCorrectionFactor(void)
{
	return (DUMMY_CO_FAC);//*correctionFactor;//2024//13A
}
//------------------------------------------------------------------------------------------------------------------------

//check if calibration factor is outside expected values (if 5V is wrong)
_Bool isCorrectionFactorBad(void)
{
	return ((*correctionFactor > CORRECTION_FACTOR_HIGH) || (*correctionFactor < CORRECTION_FACTOR_LOW));
}
//------------------------------------------------------------------------------------------------------------------------

// test if output voltage is 230V +-5%
_Bool isVoltageONok(void)
{
	waitNeg();
	sampleVoltage(0);
	//check if measured voltage is 230V+-5%
	if ((outputVoltage < (CAL_REF_VOLT-0xE53)) || (outputVoltage > (CAL_REF_VOLT+0xF13))) return FALSE;
	return TRUE;
}
//------------------------------------------------------------------------------------------------------------------------

// check if output voltage < 30VAC
// voltage can be off, so we can't use normal sampleVoltage function
_Bool isVoltageOFF(void)
{
	u8 nSamples = 8;
	u16 sum = 0;
	stopTimer2();
	resetTimer2(period/8);	// 4 samples taken in one period
	
	while (nSamples--)
	{		
		startTimer2();
		// wait for timer to expire
		while (!timer2OverflowFlag) ;
		timer2OverflowFlag = FALSE;
		//get voltage sample, square it and add to summation
		sum += getVoltageADC();
	}
	stopTimer2();
	if (sum > 0xBB) return FALSE;		//sum of 8 samples is never more than BB (calculated for 30VAC for all start phases)
	return TRUE;
}
//------------------------------------------------------------------------------------------------------------------------
