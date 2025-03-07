// GPIO.h
/* Define to prevent recursive inclusion -------------------------------------*/

#ifndef __GPIO_H
#define __GPIO_H

#include "stm8s_type.h"

// General defines
#define	BIT(x)		(u8)(0x01 << x)
#define ALLBITS	(0xFF)
#define BW_10MHZ_ON		(_Bool)(TRUE)
#define BW_10MHZ_OFF	(_Bool)(FALSE)



/*	// LED ports
#define LD1_PORT				GPIOA, BIT(1)
#define LD2_PORT				GPIOC, BIT(6)
#define LD3_PORT				GPIOB, BIT(5)
#define LD4_PORT				GPIOC, BIT(4)
#define LD5_PORT				GPIOC, BIT(5)
#define LD6_PORT				GPIOD, BIT(3)
#define LD7_PORT				GPIOC, BIT(7)
*/
#define TEST_LED_DISC		GPIOD, BIT(0)

//7-Seg Port
#define SIG_DATA_PORT		GPIOC // 1 to 7
#define SIG_DIGIT_PORT  GPIOB 

#define DIGIT0			  GPIOD, BIT(2)
#define DIGIT1				GPIOD, BIT(3)
#define DIGIT2				GPIOB, BIT(6)
#define DIGIT3				GPIOB, BIT(7)


	// Relay ports
#define RELAY1_PORT			GPIOD, BIT(4)

	// Switch ports
#define SWITCH_PORT				GPIOF, BIT(4) // Sw1 new 2024
#define SWITCH2_PORT			GPIOA, BIT(3) // Sw1 new 2024
#define SWITCH3_PORT			GPIOA, BIT(2) // Sw1 new 2024

	// identification port (to recognise AVS13 and AVS15)
#define ID_PORT					GPIOA, BIT(1) // PA1

	// intelligent delay related ports
#define TEST_PORT							GPIOA, BIT(1)				//Y->G pin
#define INT_DELAY_PORT				GPIOD, BIT(6)
#define POT_PORT							GPIOD, BIT(5)

	// AC volatge sensing port
#define AC_SENSE_PORT					GPIOB, BIT(0) // PB0  2024

#define DEBUG_SYNC_PORT 			GPIOD, BIT(2)				//pin used to sync scope in debug mode


#endif	// __GPIO_H