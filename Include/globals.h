// global function declarations
// global variable declarations

/* Define to prevent recursive inclusion -------------------------------------*/

#ifndef __global_H
#define __global_H

//#include "eeprom.h"
//#include "clock.h"
#include "gpio.h"
#include "stm8s_it.h"
#include "relay.h"
#include "eeprom.h"
#include "leds.h"
#include "avs.h"

#define NL			TRUE		//new line flag
#define NO_NL		FALSE		//no new line flag

#define DIMMING_CYCLE 28 // Carefully done to avouid flickring, flikers at 30.
#define DIMMING_DUTY  2//(2 to 13) set this for brightness (1 to halfof DIMMING_CYCLE)
#define DIMMING_OFF_DUTY (DIMMING_CYCLE - DIMMING_DUTY)

#define LED_1 1
#define LED_2 2
#define LED_3 3
#define LED_4 4
#define LED_5 5
#define LED_6 6
#define LED_7 7

void refreshDisplay(void);
//adc.c
extern void adcInit(void);
//extern u16 getACRMSVoltage(u32);
extern u16 getVoltageADC(void);
extern u16 getIntDelay(void);
extern u16 getPotADC(void);
extern _Bool is12Vbad(void);

//asp.c
extern void aspFunction(void);
extern void initSensitivity(void);
extern void updateSensitivity(void);
extern void checkSensitivityArrays(void);
extern u8 getASPSensitivityLevel(void);
extern void testRelays(u8*);
extern void operateRelay(Relay *);
//extern void updateSensitivityTimers(void);
extern volatile u16 tapChangeBlindTime;
extern volatile u8 relayCombination;
extern vu16 selectedTapUpVoltage;
extern vu16 selectedTapDownVoltage; 

//avs.h
//functions
extern void updateAVSState(Relay *);
extern void updateIntDelay(void);
//variables
extern avs_state_type avs_state;
extern u16 IntDelaySecs;
extern u16 IntDelayADCLevel;

//eeprom.c
extern u8 writeInternalEEPROM16bit(u16 data, u16* loc);

//GPIO.c
extern void GPIOinit(void);
extern void GPIOsetInputFloatNoInt(GPIO_TypeDef *, u8);
extern void GPIOsetInputPullupNoInt(GPIO_TypeDef *, u8);
extern void GPIOsetInputFloatInt(GPIO_TypeDef *, u8);
extern void GPIOsetInputPullupInt(GPIO_TypeDef *, u8);
extern void GPIOsetOutputOpenDrain(GPIO_TypeDef *, u8);	// default sets 10MHz BW limit
extern void GPIOsetOutputPushPull(GPIO_TypeDef *, u8);		// default sets 10MHz BW limit
extern void GPIOsetHigh(GPIO_TypeDef *, u8);
extern void GPIOtoggle(GPIO_TypeDef *, u8);
extern void GPIOsetLow(GPIO_TypeDef *, u8);
extern _Bool GPIOisBitHigh(GPIO_TypeDef *, u8);
extern _Bool GPIOisBitLow(GPIO_TypeDef *, u8);
extern u8 GPIObyteState(GPIO_TypeDef *);
extern _Bool isYGlow(void);
extern _Bool isButtonPressed(void);
extern _Bool isButtonPressed2(void);
extern _Bool isButtonPressed3(void);
extern void SevenSegmentGPIOinit(void);
extern void GPIOportValue(GPIO_TypeDef *, u8);

//outputVoltage.c
//functions
extern void measureACPeriod(void);
extern void sampleVoltage(_Bool);
//extern void waitPos(void);
extern void waitNeg(void);
extern _Bool isCorrectionFactorBad(void);
_Bool isVoltageONok(void);
_Bool isVoltageOFF(void);
extern u16 getCorrectionFactor(void);
//variables
//extern volatile u16 inputVoltageRMS;
extern u16 outputVoltage;
extern u16 period;
extern u16 frequency;
//extern volatile _Bool frequencyErrorLow;
//extern volatile _Bool frequencyErrorHigh;
extern _Bool acVmeasurementOK;
extern u8 generateRandomDelay(void);

//interrupt priority.c
extern void initIntPriorities(void);

//leds.c
extern void initLEDs(void);
extern void handleLEDS(void);
extern void handleLEDSInt(void);
extern void checkLEDs(void);
extern void turnLEDOff(GPIO_TypeDef *, u8);
extern void turnLEDOn(GPIO_TypeDef *, u8);
extern void NblinkRED(u8);

extern volatile LEDpattern led1, led2, led3, led4, led5, led6, led7;

//main.c
//functions
//extern void wait100usNoInt(void);
//extern void wait1usNoInt(void);
extern void primeIntDelay(void);
extern void releaseIntDelay(void);
extern _Bool isFirst30min(void);
_Bool isCalibrationDone(void);
//variables
extern volatile _Bool intDelayPrimed;
extern vu8 errors;
extern volatile FlagStatus isSwitchOn; 

//relay.c
//functions
extern void initRelays(void);
extern void processRelay(Relay *);
extern void relayFunction(Relay *);
extern void updateRelayTimer(Relay *);
//variables
extern Relay relay1;
extern _Bool enterONMode;
extern volatile u8 randomStandardDelay;

//stm8s_it.c
extern @tiny vu16 milliSeconds;
extern @tiny vu8 minutes;
extern volatile _Bool minuteTicker;
extern volatile _Bool secondTicker;
extern volatile _Bool millisecondTicker;
//extern vu16 waitPosCtr250us;

//tables.c
//extern const u16 tempTable[];
//extern const u32 voltTable[];

//test.c
//functions
extern void testProcedure(void);
extern _Bool checkForTestProcedure(void);
//variables
extern _Bool isCalibrating;
extern volatile _Bool delayGood;

//timers.c
extern void timer4Init(void);
extern void startTimer2(void);
extern void resetTimer2(u16);
extern void stopTimer2(void);
extern void timer1Init(void);
extern void stopTimer1(void);
extern _Bool hasTimer2Expired(void);
extern u16 getTimer2uSec(void);
extern void enableIWatchDog(void);
extern void resDog(void);
extern void holdus(u16 delay);
extern void waitms(u16);
//variables
extern volatile _Bool timer2OverflowFlag;
extern volatile u16 holdusCtr;

//uart.c
//functions
extern void UART1_Config(void);
extern void UART1_PutString(char *, _Bool);
//extern void UART1_PutStringNL(char *);
extern void Hex2str(char *, u32);
extern void Int2str(char *, u32);
extern void TransmitData(void);
//variables
extern char strNum[11];

#endif //__global_H
