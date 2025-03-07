#include "stm8s.h"
#include "stm8s_type.h"
//#include "GPIO.h"
#include "globals.h"
#include "options.h"



// Global Function Prototypes

void GPIOinit(void);

//setting pins
void GPIOsetInputFloatNoInt(GPIO_TypeDef *, u8);
void GPIOsetInputPullupNoInt(GPIO_TypeDef *, u8);
void GPIOsetInputFloatInt(GPIO_TypeDef *, u8);
void GPIOsetInputPullupInt(GPIO_TypeDef *, u8);
void GPIOsetOutputOpenDrain(GPIO_TypeDef *, u8);	// default sets 10MHz BW limit
void GPIOsetOutputPushPull(GPIO_TypeDef *, u8);		// default sets 10MHz BW limit
void GPIOsetHigh(GPIO_TypeDef *, u8);
void GPIOtoggle(GPIO_TypeDef *, u8);
void GPIOsetLow(GPIO_TypeDef *, u8);
void GPIOportValue(GPIO_TypeDef *, u8);

// reading input
_Bool GPIOisBitHigh(GPIO_TypeDef *, u8);
u8 GPIObyteState(GPIO_TypeDef *);

_Bool isYGlow(void);
_Bool isButtonPressed(void);
_Bool isButtonPressed2(void);
_Bool isButtonPressed3(void);

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
void GPIOinit(void)
{
	//set all IO to pullup inpput as default (recommended for unused pins)
	GPIOsetInputPullupNoInt(GPIOA, ALLBITS);
	GPIOsetInputPullupNoInt(GPIOC, ALLBITS);
	GPIOsetInputPullupNoInt(GPIOD, ALLBITS);
	GPIOsetInputPullupNoInt(GPIOE, ALLBITS);
	GPIOsetInputPullupNoInt(GPIOF, ALLBITS);
	
	//set all ADC inputs to floating inputs
	//GPIOsetInputFloatNoInt(INT_DELAY_PORT);
	GPIOsetInputFloatNoInt(AC_SENSE_PORT);	//voltage sesing
	//GPIOsetInputFloatNoInt(POT_PORT);
	
	//other ports
	GPIOsetOutputPushPull(DEBUG_SYNC_PORT);	//PD2 used for debugging
	GPIOsetInputPullupInt(ID_PORT);				//Likely PA1, pulled up if AVS13 and pulled down if AVS15
	GPIOsetInputFloatNoInt(SWITCH_PORT);// GND for pressed else 3.3V
	GPIOsetInputFloatNoInt(SWITCH2_PORT);
	GPIOsetInputFloatNoInt(SWITCH3_PORT);
	//relay port is configured during relay initialisation
	SevenSegmentGPIOinit();
}

void SevenSegmentGPIOinit(void)
{
	//LEDs ports
	GPIOsetOutputPushPull(SIG_DATA_PORT, ALLBITS);
	GPIOsetOutputPushPull(DIGIT0);
	GPIOsetOutputPushPull(DIGIT1);
	GPIOsetOutputPushPull(DIGIT2);
	GPIOsetOutputPushPull(DIGIT3);
	GPIOsetOutputPushPull(TEST_LED_DISC);
}


void GPIOsetInputFloatNoInt(GPIO_TypeDef *port, u8 pattern)
{
	port->DDR &=(~pattern);
	port->CR1 &=(~pattern);
	port->CR2 &=(~pattern);
}	

void GPIOsetInputPullupNoInt(GPIO_TypeDef *port, u8 pattern)
{
	port->DDR &=(~pattern);
	port->CR1 |= pattern;
	port->CR2 &=(~pattern);
}

void GPIOsetInputFloatInt(GPIO_TypeDef *port, u8 pattern)
{
	port->DDR &=(~pattern);
	port->CR1 &=(~pattern);
	port->CR2 |= pattern;
}

void GPIOsetInputPullupInt(GPIO_TypeDef *port, u8 pattern)
{
	port->DDR &=(~pattern);
	port->CR1 |= pattern;
	port->CR2 |= pattern;
}

void GPIOsetOutputOpenDrain(GPIO_TypeDef *port, u8 pattern)
{
	port->DDR |= pattern;
	port->CR1 &= (~pattern);
	port->CR2 |= pattern;
}

void GPIOsetOutputPushPull(GPIO_TypeDef *port, u8 pattern)
{
	port->DDR |= pattern;
	port->CR1 |= pattern;	
	port->CR2 &=~pattern;
}

void GPIOsetHigh(GPIO_TypeDef *port, u8 pattern)
{
	port->ODR |= pattern;
}

void GPIOtoggle(GPIO_TypeDef *port, u8 pattern)
{
	port->ODR ^= pattern;
}

void GPIOsetLow(GPIO_TypeDef *port, u8 pattern)
{
	port->ODR &= (~pattern);
}

void GPIOportValue(GPIO_TypeDef *port, u8 pattern)
{
	port->ODR = pattern;
}

_Bool GPIOisBitHigh(GPIO_TypeDef *port, u8 pattern)
{
	if (port->IDR & pattern) return ((_Bool)TRUE);
	return ((_Bool)FALSE);
}

_Bool GPIOisBitLow(GPIO_TypeDef *port, u8 pattern)
{
	if ((port->IDR & pattern)) return ((_Bool)FALSE);
	return ((_Bool)TRUE);
}

u8 GPIObyteState(GPIO_TypeDef *port)
{
	return (u8)(port->IDR);
}

//------------------------------------------------------------------------------------------------------------------------
_Bool isYGlow(void)
{
	u8 i;
	
	for (i=0; i<5; i++)
		if (GPIOisBitHigh(TEST_PORT))
			return (FALSE);
	
	return (TRUE);
	
	//if (GPIOisBitHigh(TEST_PORT)) return (FALSE);		//if Y->G shorted, return true
	//return (TRUE);
}
//------------------------------------------------------------------------------------------------------------------------

_Bool isButtonPressed(void)
{
	u16 i;
	
	for (i=0; i<10; i++)
		if (GPIOisBitHigh(SWITCH_PORT))
			return (FALSE);
	
	return (TRUE);
}

_Bool isButtonPressed2(void)
{
	u8 i;
	
	for (i=0; i<10; i++)
		if (GPIOisBitHigh(SWITCH2_PORT))
			return (FALSE);
	
	return (TRUE);
}

_Bool isButtonPressed3(void)
{
	u8 i;
	
	for (i=0; i<10; i++)
		if (GPIOisBitHigh(SWITCH3_PORT))
			return (FALSE);
	
	return (TRUE);
}

