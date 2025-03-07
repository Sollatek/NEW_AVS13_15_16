// timers.h

/* Define to prevent recursive inclusion -------------------------------------*/

#ifndef __timers_H
#define __timers_H

#include "stm8s_type.h"
//#include "clock.h"

// Work out some values:

#define MAX_FREQ_PERIOD_US	(1000000/MAX_FREQUENCY)
#define MIN_FREQ_PERIOD_US	(1000000/MIN_FREQUENCY)


// With a clock frequency of 16MHz , the ctr Value and prescalar provide a Timer4 interrupt
// every 250us. 
#define TIMER4_CTR_VALUE	(249)
#define TIMER4_PRESCALER	(0x04)

// So a 1ms scheduler should run every 4th interrupt
#define TIMER4_SCHEDULER_1MS	(4)

// defines for various times: (relative to TIMER4_SCHEDULER_1MS)

#define TM4_HALF_SECOND				(500)
#define TM4_TENTH_SECOND			(100)
#define TM4_HUNDREDTH_SECOND	(10)

// Timer 2
//Settings for measure frequency function
#define TIMER2_PRESCALER	(0x04) // 1 count = 1us
#define TIMER2_CTR_VALUE_MF	(57142)
#define TIMER2_CTR_H_MF			((u8)(TIMER2_CTR_VALUE_MF>>8))
#define TIMER2_CTR_L_MF			((u8)TIMER2_CTR_VALUE_MF)

//Settings for sampV function
#define TIMER2_PRESCALER_SV	(0x04)	//divide by 16 = 1us/count

//Timer 1 settings for test procedure
#define TIMER1_PRESCALER		(16000)		//Master Clock is 16MHz so TIM1 increments every ms
#define TIMER1_CTR_VALUE		(1000)		//update every second


#endif	// __timers_H