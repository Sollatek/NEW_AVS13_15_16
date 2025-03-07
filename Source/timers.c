#include "stm8s.h"
#include "stm8s_type.h"
#include "stm8s_it.h"
#include "timers.h"
//#include "clock.h"
#include "globals.h"

// global functions
void timer1Init(void);
void stopTimer1(void);
void startTimer2(void);
void resetTimer2(u16 timerValUs);
void stopTimer2(void);
_Bool hasTimer2Expired(void);
u16 getTimer2uSec(void);
void timer4Init(void);
void enableIWatchDog(void);
void resDog(void);
void holdus(u16 delay);
void waitms(u16);

// global variables
volatile _Bool timer2OverflowFlag = FALSE;
volatile u16 holdusCtr = 0;

// private functions

// private variables

//------------------------------------------------------------------------------------------------------------------------

void startTimer2(void)
{
	TIM2->CR1 |= TIM2_CR1_CEN;//(TIM2_CR1_CEN | TIM2_CR1_URS | TIM2_CR1_UDIS);
	TIM2->IER 	|= TIM2_IER_UIE; 	// enable timer overflow interrupt
}
//------------------------------------------------------------------------------------------------------------------------

void resetTimer2(u16 timerValUs)
{
	TIM2->PSCR 	= TIMER2_PRESCALER;			// Set the Prescaler value 
	TIM2->ARRH = ((u8)(timerValUs>>8));
	TIM2->ARRL = ((u8)timerValUs);
	TIM2->CNTRH = 0;
	TIM2->CNTRL = 0;
	TIM2->SR1 &=~TIM2_SR1_UIF;
}
//------------------------------------------------------------------------------------------------------------------------
// This Timer 1 configuration is only used in test procedure. In test procedure it generates interrupt very 1s.
void timer1Init(void)
{
	TIM1->PSCRH = (u8)(TIMER1_PRESCALER>>8);											// Set the Prescaler value (increment every 64us)
	TIM1->PSCRL = (u8)(TIMER1_PRESCALER);											// Set the Prescaler value (increment every 64us)
	TIM1->ARRH = (u8)(TIMER1_CTR_VALUE>>8);											// Set the Autoreload value (15625)
	TIM1->ARRL = (u8)(TIMER1_CTR_VALUE);
	TIM1->SR1 &= ~TIM1_SR1_UIF;
	TIM1->IER |= TIM1_IER_UIE;
	TIM1->CR1 |= TIM1_CR1_CEN;	// enable counting
}
//------------------------------------------------------------------------------------------------------------------------

void stopTimer1(void)
{
	TIM1->CR1 &= (u8)(~TIM1_CR1_CEN);
}
//------------------------------------------------------------------------------------------------------------------------

u16 getTimer2uSec(void)
{
	u16 ctrval = ((TIM2->CNTRH<<8) + TIM2->CNTRL);
	return (ctrval);
}
//------------------------------------------------------------------------------------------------------------------------

void stopTimer2(void)
{
	TIM2->CR1 &=~TIM2_CR1_CEN;
	TIM2->IER &=~TIM2_IER_UIE; 	// enable timer overflow interrupt
}
//------------------------------------------------------------------------------------------------------------------------

_Bool hasTimer2Expired(void)	
{
	if (TIM2->SR1 & TIM2_SR1_UIF)
	{
		TIM2->SR1 &=~TIM2_SR1_UIF;
		return (TRUE);
	}
	return (FALSE);
}
//------------------------------------------------------------------------------------------------------------------------

// wait the specified number of microseconds.
// The timer 2 counter increments every microsecond
// dont do anything less than 7us!
void holdus(u16 delay)
{
	u8 cntrStartPoint = TIM4->CNTR;
	u16 del = delay;
	u16 nloops = del/TIM4->ARR;
	holdusCtr = nloops;
	while (holdusCtr) ;
	del -= (nloops*TIM4->ARR);
	if ((255-del) < cntrStartPoint) holdusCtr++;
	while (holdusCtr) ;
	cntrStartPoint +=del;
	if (cntrStartPoint > TIMER4_CTR_VALUE) cntrStartPoint = TIMER4_CTR_VALUE; //min ctr value to catch before reload
	while (TIM4->CNTR < cntrStartPoint) ;
}
//------------------------------------------------------------------------------------------------------------------------

// Timer 4
void timer4Init(void)
{
	TIM4->PSCR 	= TIMER4_PRESCALER;											// Set the Prescaler value (increment every us)
	TIM4->ARR 	= TIMER4_CTR_VALUE;											// Set the Autoreload value (250)
	TIM4->CR1 	|= (u8) (TIM4_CR1_CEN | TIM4_CR1_URS) ;			// Enable the timer
	TIM4->IER 	|= TIM4_IER_UIE;												// Enable the Interrupt sources
}
//------------------------------------------------------------------------------------------------------------------------

void enableIWatchDog(void)
{
	IWDG->KR = 0xCC;	// key value to enable watchdog
	resDog();	// set watchdog to running values
}
//------------------------------------------------------------------------------------------------------------------------

void resDog(void)
{	
	// set up watchdog timer - repeated each time wdog is reset as a matter of paranoia
	IWDG->KR = 0x55;	// enable access to modify prescalar and timer value
	IWDG->PR = 0x04;	// set prescalar to /64
	IWDG->KR = 0x55;	// enable access to modify prescalar and timer value
	IWDG->RLR = 0x64;	// 100ms
	IWDG->KR = 0xAA; 	// reset watchdog and lock modify access to timer & prescaler
}
//------------------------------------------------------------------------------------------------------------------------

void waitms(u16 milliseconds)
{
	u16 waitCounter = milliseconds;
	
	while (waitCounter > 0)
	{
		if (millisecondTicker)
		{
			millisecondTicker = FALSE;
			waitCounter--;
		}
		resDog();	//timeout is 100ms
	}
}
//------------------------------------------------------------------------------------------------------------------------
