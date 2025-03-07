/**
  ******************************************************************************
  * @file stm8s_it.c
  * @brief This file contains all the interrupt routines, for Cosmic compiler.
  * @author STMicroelectronics - MCD Application Team
  * @version V1.1.1
  * @date 06/05/2009
  ******************************************************************************
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2009 STMicroelectronics</center></h2>
  * @image html logo.bmp
  ******************************************************************************
  */
	
//******************************************************************************
// ANY INTERRUPT ROUTINE THAT USES 32BIT (u32, s32, long, etc) VARIABLES
// SHOULD HAVE @svlreg in their declaration. This forces the ISR to save a register
// called c_lreg, which is used in maths operations on long & float variables
// FAILURE TO DO SO WILL RESULT IN CORRUPTED MATHS on long variables, particularly
// in routines that are running in background or lower priority ISRs
// See timer4 interrupt declaration as an example.
//******************************************************************************

/* Includes ------------------------------------------------------------------*/
//#include "stm8s_it.h"
#include "stm8s_type.h"
#include "timers.h"
//#include "GPIO.h"
//#include "EEPROM.h"
//#include "clock.h"
#include "globals.h"
//#include <string.h>
#include "options.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

// UART3 TX/RX


// TIM4 interrupt
@tiny vu8 TIM4counter = 0;
@tiny vu16 milliSeconds;
@tiny vu8 seconds;
@tiny vu8 minutes = 0;
@tiny vu8 displayMilliSec = 0;

volatile _Bool minuteTicker;
volatile _Bool secondTicker;
volatile _Bool displayUpdate;
volatile u8 dimmingFlag;

//vu16 waitPosCtr250us = 0;

/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/* Public functions ----------------------------------------------------------*/
// Global variables ----------------------------------------------------------*/
volatile _Bool millisecondTicker;

/** @addtogroup IT_Functions
  * @{
  */
#ifdef _COSMIC_
/**
  * @brief Dummy interrupt routine
  * @par Parameters:
  * None
  * @retval
  * None
*/
@far @interrupt void NonHandledInterrupt(void)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief TRAP interrupt routine
  * @par Parameters:
  * None
  * @retval
  * None
*/
@far @interrupt void TRAP_IRQHandler(void)
{
}
#else /*_RAISONANCE_*/

/**
  * @brief TRAP interrupt routine
  * @par Parameters:
  * None
  * @retval
  * None
*/
void TRAP_IRQHandler(void) trap
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*_COSMIC_*/

/**
  * @brief Top Level Interrupt Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TLI_IRQHandler(void)
#else /* _RAISONANCE_ */
void TLI_IRQHandler(void) interrupt 0
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Auto Wake Up Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void AWU_IRQHandler(void)
#else /* _RAISONANCE_ */
void AWU_IRQHandler(void) interrupt 1
#endif /* _COSMIC_ */	
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Clock Controller Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void CLK_IRQHandler(void)
#else /* _RAISONANCE_ */
void CLK_IRQHandler(void) interrupt 2
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief External Interrupt PORTA Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void EXTI_PORTA_IRQHandler(void)
#else /* _RAISONANCE_ */
void EXTI_PORTA_IRQHandler(void) interrupt 3
#endif /* _COSMIC_ */
{
//	GPIOA->CR2 &= ~(BIT(0));		// disable interrupt
}

/**
  * @brief External Interrupt PORTB Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
*/
#ifdef _COSMIC_
@far @interrupt void EXTI_PORTB_IRQHandler(void)
#else /* _RAISONANCE_ */
void EXTI_PORTB_IRQHandler(void) interrupt 4
#endif /* _COSMIC_ */
{
	//	GPIOB->CR2 &= ~(BIT(0));		// disable interrupt
}

/**
  * @brief External Interrupt PORTC Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void EXTI_PORTC_IRQHandler(void)
#else /* _RAISONANCE_ */
void EXTI_PORTC_IRQHandler(void) interrupt 5
#endif /* _COSMIC_ */
{
	//GPIOC->CR2 =0xE8;		// disable interrupt
}

/**
  * @brief External Interrupt PORTD Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void EXTI_PORTD_IRQHandler(void)
#else /* _RAISONANCE_ */
void EXTI_PORTD_IRQHandler(void) interrupt 6
#endif /* _COSMIC_ */
{
	GPIOD->CR2 &= ~(BIT(1));		// disable interrupt on pin 1
}

/**
  * @brief External Interrupt PORTE Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void EXTI_PORTE_IRQHandler(void)
#else /* _RAISONANCE_ */
void EXTI_PORTE_IRQHandler(void) interrupt 7
#endif /* _COSMIC_ */
{

}
#ifdef STM8S903
/**
  * @brief External Interrupt PORTF Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void EXTI_PORTF_IRQHandler(void)
#else /* _RAISONANCE_ */
void EXTI_PORTF_IRQHandler(void) interrupt 8
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S903*/

#ifdef STM8S208
/**
  * @brief CAN RX Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void CAN_RX_IRQHandler(void)
#else /* _RAISONANCE_ */
void CAN_RX_IRQHandler(void) interrupt 8
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief CAN TX Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void CAN_TX_IRQHandler(void)
#else /* _RAISONANCE_ */
void CAN_TX_IRQHandler(void) interrupt 9
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S208*/

/**
  * @brief SPI Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void SPI_IRQHandler(void)
#else /* _RAISONANCE_ */
void SPI_IRQHandler(void) interrupt 10
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Timer1 Update/Overflow/Trigger/Break Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@svlreg @far @interrupt void TIM1_UPD_OVF_TRG_BRK_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM1_UPD_OVF_TRG_BRK_IRQHandler(void) interrupt 11
#endif /* _COSMIC_ */
{
	TIM1->SR1 &= ~TIM1_SR1_UIF;	// clear flag
	
  if (isCalibrating)
	{
		static u8 secCounter = 0;
		static u8 state = 0;
		static u8 testCounter = 0;
		u8 IntDelayADC;
		
		switch(state)
		{
			case 0:
			default:
				secCounter = 0;
				testCounter = 0;
				state = 1;
			
			case 1:
				if (++secCounter >= 4)
				{
					releaseIntDelay();
					secCounter = 0;
					testCounter++;
					state = 2;
				}
				break;
				
			case 2:
				if (++secCounter >= 10)
				{
					IntDelayADC = getIntDelay();
					if ((IntDelayADC < (TEST_INT_DELAY_ADC_LEVEL - 90)) || (IntDelayADC > (TEST_INT_DELAY_ADC_LEVEL + 100)))
					{
						if (testCounter < 3)
						{
							secCounter = 0;
							primeIntDelay();
							state = 1;
						}
						else
							state = 0xFF;
					}		
					else
						state = 0xFE;
				}
				break;
				
			case 0xFE:	// success. stay here forever
				led3 = LED_ON;
				led4 = LED_ON;
				delayGood = TRUE;
				break;
				
			case 0xFF:	// failed. stay here forever
				errors |= ERR1;
				break;
		}
	}
}

/**
  * @brief Timer1 Capture/Compare Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM1_CAP_COM_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM1_CAP_COM_IRQHandler(void) interrupt 12
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

#ifdef STM8S903
/**
  * @brief Timer5 Update/Overflow/Break/Trigger Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM5_UPD_OVF_BRK_TRG_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM5_UPD_OVF_BRK_TRG_IRQHandler(void) interrupt 13
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
/**
  * @brief Timer5 Capture/Compare Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM5_CAP_COM_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM5_CAP_COM_IRQHandler(void) interrupt 14
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

#else /*STM8S208, STM8S207, STM8S105 or STM8S103*/
/**
  * @brief Timer2 Update/Overflow/Break Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM2_UPD_OVF_BRK_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM2_UPD_OVF_BRK_IRQHandler(void) interrupt 13
#endif /* _COSMIC_ */
{
	TIM2->SR1 &= ~TIM2_SR1_UIF;	// clear flag
	timer2OverflowFlag = TRUE;
}

/**
  * @brief Timer2 Capture/Compare Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM2_CAP_COM_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM2_CAP_COM_IRQHandler(void) interrupt 14
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S903*/

#if defined (STM8S208) || defined(STM8S207) || defined(STM8S105)
/**
  * @brief Timer3 Update/Overflow/Break Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM3_UPD_OVF_BRK_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM3_UPD_OVF_BRK_IRQHandler(void) interrupt 15
#endif /* _COSMIC_ */
{

}




/**
  * @brief Timer3 Capture/Compare Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM3_CAP_COM_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM3_CAP_COM_IRQHandler(void) interrupt 16
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S208, STM8S207 or STM8S105*/

#ifndef STM8S105



/**
Tx interrupt: When a character has been sent and the output buffer is empty, the
next character from the output buffer is queued up, unless the max number of 
characters has been transmitted. An \0 will terminate the transmission as well.
*/

#ifdef _COSMIC_
@far @interrupt void UART1_TX_IRQHandler(void)
#else /* _RAISONANCE_ */
void UART1_TX_IRQHandler(void) interrupt 17
#endif /* _COSMIC_ */
{

}


/**
  * @brief UART1 RX Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void UART1_RX_IRQHandler(void)
#else /* _RAISONANCE_ */
void UART1_RX_IRQHandler(void) interrupt 18
#endif /* _COSMIC_ */
{

}
#endif /*STM8S105*/

/**
  * @brief I2C Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void I2C_IRQHandler(void)
#else /* _RAISONANCE_ */
void I2C_IRQHandler(void) interrupt 19
#endif /* _COSMIC_ */
{
}

#ifdef STM8S105
/**
  * @brief UART2 TX interrupt routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void UART2_TX_IRQHandler(void)
#else /* _RAISONANCE_ */
void UART2_TX_IRQHandler(void) interrupt 20
#endif /* _COSMIC_ */
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief UART2 RX interrupt routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void UART2_RX_IRQHandler(void)
#else /* _RAISONANCE_ */
void UART2_RX_IRQHandler(void) interrupt 21
#endif /* _COSMIC_ */
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}
#endif /* STM8S105*/

#if defined(STM8S207) || defined(STM8S208)
/**
  * @brief UART3 TX interrupt routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void UART3_TX_IRQHandler(void)
#else /* _RAISONANCE_ */
void UART3_TX_IRQHandler(void) interrupt 20
#endif /* _COSMIC_ */
{
// byte transmission on RS485 handled in RX interrupt function RS485SendByte
}

/**
  * @brief UART3 RX interrupt routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void UART3_RX_IRQHandler(void)
#else /* _RAISONANCE_ */
void UART3_RX_IRQHandler(void) interrupt 21
#endif /* _COSMIC_ */
{
 
}
#endif /*STM8S208 or STM8S207*/

#if defined(STM8S207) || defined(STM8S208)
/**
  * @brief ADC2 interrupt routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void ADC2_IRQHandler(void)
#else /* _RAISONANCE_ */
void ADC2_IRQHandler(void) interrupt 22
#endif /* _COSMIC_ */
{

}	
#else /*STM8S105, STM8S103 or STM8S903*/
/**
  * @brief ADC1 interrupt routine.
  * @par Parameters:
  * None
  * @retval 
  * None
  */
#ifdef _COSMIC_
@far @interrupt void ADC1_IRQHandler(void)
#else /* _RAISONANCE_ */
void ADC1_IRQHandler(void) interrupt 22
#endif /* _COSMIC_ */
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}
#endif /*STM8S208 or STM8S207*/

#ifdef STM8S903
/**
  * @brief Timer6 Update/Overflow/Trigger Interruption routine.
  * @par Parameters:
  * None
  * @retval
  * None
  */
#ifdef _COSMIC_
@far @interrupt void TIM6_UPD_OVF_TRG_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM6_UPD_OVF_TRG_IRQHandler(void) interrupt 23
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#else /*STM8S208, STM8S207, STM8S105 or STM8S103*/
/**
  * @brief Timer4 Update/Overflow Interruption routine.

  */
	
//******************************************************************************
// ANY INTERRUPT ROUTINE THAT USES 32BIT (u32, s32, long, etc) VARIABLES
// SHOULD HAVE @svlreg in their declaration. This forces the ISR to save a compiler
// generated register called c_lreg, which is used in maths operations on long 
// & float variables.
// FAILURE TO DO SO WILL RESULT IN CORRUPTED MATHS on long variables, particularly
// in routines that are running in background or lower priority ISRs
// See timer4 interrupt declaration as an example.
//******************************************************************************
#ifdef _COSMIC_
@far @svlreg @interrupt void TIM4_UPD_OVF_IRQHandler(void)
#else /* _RAISONANCE_ */
void TIM4_UPD_OVF_IRQHandler(void) interrupt 23
#endif /* _COSMIC_ */
{
	// Timer 4 overflows every 250us
	TIM4->SR1 &= ~TIM4_SR1_UIF;	// clear flag

	if (holdusCtr) holdusCtr--;	//decrement timer variable used in holdus function
	
	dimmingFlag++;
	refreshDisplay();
	//every ms
	if (++TIM4counter == TIMER4_SCHEDULER_1MS) 
	{
		TIM4counter = 0;
		millisecondTicker = TRUE;
		
		updateRelayTimer(&relay1);
		//updateRelayTimer(&relay2);
		//updateRelayTimer(&relay3);
		//updateRelayTimer(&relay4);
		
		if (tapChangeBlindTime < 0xFFFF) tapChangeBlindTime++;
		
		//handleLEDSInt();// 2024 not required in new. 
		
		if(displayMilliSec > 5)
		{
			displayMilliSec = 0;
			displayUpdate = TRUE;
		}
		displayMilliSec++;
		
		if (milliSeconds++ >= 999)	
		{
			milliSeconds = 0;
			//randomStandardDelay = generateRandomDelay();		// generate random standard delay every second
			// timers updated every second:
			secondTicker = TRUE;	// activated every second for background timing
			
			if (seconds++ >= 59)
			{
				seconds = 0;
				minuteTicker = TRUE;
				
				minutes++;
				if (minutes >=  SENSITIVITY_RESET_PERIOD_MIN) minutes = 0;
				
				if (SENSITIVITY_ENABLED) checkSensitivityArrays();//purge expired tap change events
			}
		}
	}
}
#endif /*STM8S903*/

/**
  * @brief Eeprom EEC Interruption routine.
  * @par Parameters:
  * None
  * @retval
	* None
  */
#ifdef _COSMIC_
@far @interrupt void EEPROM_EEC_IRQHandler(void)
#else /* _RAISONANCE_ */
void EEPROM_EEC_IRQHandler(void) interrupt 24
#endif /* _COSMIC_ */
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @}
  */

/******************* (C) COPYRIGHT 2009 STMicroelectronics *****END OF FILE****/