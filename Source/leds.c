#include "stm8s.h"
#include "stm8s_type.h"
#include "globals.h"
#include "options.h"



// global functions
void initLEDs(void);
void handleLEDSInt(void);
void checkLEDs(void);
void turnLEDOff(GPIO_TypeDef *port, u8 pattern);
void turnLEDOn(GPIO_TypeDef *port, u8 pattern);
void handleLEDS(void);
void NblinkRED(u8);

// global variables

// private functions
void UpdateLEDState(LEDpattern,GPIO_TypeDef *, u8);

// private variables
volatile u16 blinkTimer = 0;
volatile LEDpattern led1, led2, led3, led4, led5, led6, led7;
_Bool blinkHigh = FALSE;

//------------------------------------------------------------------------------------------------------------------------

/*void initLEDs(void)
{
	return; //2024
	turnLEDOff(LD1_PORT);
	turnLEDOff(LD2_PORT);
	turnLEDOff(LD3_PORT);
	turnLEDOff(LD4_PORT);
	turnLEDOff(LD5_PORT);
	turnLEDOff(LD6_PORT);
	turnLEDOff(LD7_PORT);
	led1 = LED_OFF;
	led2 = LED_OFF;
	led3 = LED_OFF;
	led4 = LED_OFF;
	led5 = LED_OFF;
	led6 = LED_OFF;
	led7 = LED_OFF;
	blinkTimer = 0;
}
//------------------------------------------------------------------------------------------------------------------------

//Specifies the LED behaviour according to the state of the main relay, or other requirements
void handleLEDS(void)
{
	led1 = LED_OFF;
	led2 = LED_OFF;
	led3 = LED_OFF;
	led4 = LED_OFF;
	led5 = LED_OFF;
	led6 = LED_OFF;
	led7 = LED_OFF;

	if (acVmeasurementOK)	//if frequency ok
		switch (avs_state)
		{
			case AVS_INIT:
			default:
				led3 = LED_ON;
				led4 = LED_ON;
				break;
			
			case AVS_LVD:
				if (!relay1.relayON)
					led5 = LED_ON;
				else
					led5 = LED_BLINK;
				break;	
			
			case AVS_LVR:
				if (!relay1.relayON)
					led4 = LED_ON;
				else
					led4 = LED_BLINK;
				break;
			
			case AVS_HVR:
				if (!relay1.relayON)
					led3 = LED_ON;
				else
					led3 = LED_BLINK;
				break;
			
			case AVS_HVD:
				if (!relay1.relayON)
					led2 = LED_ON;
				else
					led2 = LED_BLINK;
				break;
			
			case AVS_ON:
			case AVS_MAN_ON:
				if (relay1.relayON)
					led1 = LED_ON;
				else
				{
					//led1 = LED_BLINK;
					led1 = LED_OFF;
					led4 = LED_ON;
				}
				break;
			
		}
	else	//bad frequency -> flash LVD and HVD LEDs
	{
		led2 = LED_BLINK;
		led5 = LED_BLINK;
	}
	
	if (isSwitchOn)
		led6 = LED_ON;
	else
		led7 = LED_ON;
}
//------------------------------------------------------------------------------------------------------------------------

//Control scheduling of LEDs based on LED flags
//runs in timer 4 interrupt every 1ms
void handleLEDSInt(void)
{
	blinkTimer++;
	if (blinkTimer > LED_BLINK_TIME_MS)	blinkHigh = TRUE;
	if (blinkTimer > (LED_BLINK_TIME_MS<<1))
	{
		blinkHigh = FALSE;
		blinkTimer = 0;
	}
	
	UpdateLEDState(led1,LD1_PORT);
	UpdateLEDState(led2,LD2_PORT);
	UpdateLEDState(led3,LD3_PORT);
	UpdateLEDState(led4,LD4_PORT);
	UpdateLEDState(led5,LD5_PORT);
	UpdateLEDState(led6,LD6_PORT);
	UpdateLEDState(led7,LD7_PORT);

}	//handleLEDSInt
//------------------------------------------------------------------------------------------------------------------------

//update GPIO pin according to specified led state
void UpdateLEDState(LEDpattern led,GPIO_TypeDef *port, u8 pattern)
{
	switch (led)
	{
		case LED_OFF:
		default:
			turnLEDOff(port, pattern);
			break;
			
		case LED_ON:
			turnLEDOn(port, pattern);
			break;
		
		case LED_BLINK:
			if (blinkHigh)	turnLEDOn(port, pattern);
			else turnLEDOff(port, pattern);
			break;
	}
}
//------------------------------------------------------------------------------------------------------------------------

//trun on LEDs one by one (visual test)
void checkLEDs(void)	
{
	led1 = LED_ON;
	waitms(500);
	led1 = LED_OFF;
	led3 = LED_ON;
	waitms(500);
	led3 = LED_OFF;
	led2 = LED_ON;
	waitms(500);
	led2 = LED_OFF;
	waitms(500);
}
//------------------------------------------------------------------------------------------------------------------------

//blink N times red LED
void NblinkRED(u8 N)
{
	u8 i;
	for (i=0; i<N; i++)
	{
		waitms(500);
		led7 = LED_ON;
		waitms(500);
		led7 = LED_OFF;
	}
}
//------------------------------------------------------------------------------------------------------------------------

void turnLEDOn(GPIO_TypeDef *port, u8 pattern)
{
	GPIOsetLow(port, pattern);
}
//------------------------------------------------------------------------------------------------------------------------

void turnLEDOff(GPIO_TypeDef *port, u8 pattern)
{
	GPIOsetHigh(port, pattern);
}*/