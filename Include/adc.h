// adc.h

/* Define to prevent recursive inclusion -------------------------------------*/

#ifndef __adc_H
#define __adc_H

#include "stm8s_type.h"
#include "stm8s.h"


//PCB Specific Calculations

#define ADC_FULL_SCALE	(1024)

#define VSCALE	141	// equivalent to * by 1.1 if divided by 128 after this.//(((((ADC_VREF_MV*RTOP*1024)/ADC_MAX)/RBOTTOM) + ((ADC_VREF_MV*1024)/ADC_MAX))/1024)

#define para(x,y) 			((x*y)/(x+y))
#define para3(x,y,z)		para(para(x,y),z)
#define para4(w,x,y,z)	para(para3(x,y,z),w)

// Various ADC macro functions
#define ADCisEOC		((bool)(ADC1->CSR & ADC1_CSR_EOC))	// returns TRUE if conversion done
#define ADCclearEOC	(ADC1->CSR &= ~ADC1_CSR_EOC)		// clear end of conversion flag
#define ADCoff			(ADC1->CR1 &= ~ADC1_CR1_ADON)		// ensure ADC is off
#define ADCon				(ADC1->CR1 |= ADC1_CR1_ADON)		// Turn ADC on

// ADC_CR1 prescalar SPSEL bit patterns: 14 clock cycle conversions

#define SPSEL_MSTR_HALF				(0x00)	// @24MHz = 12Mhz = 83.3ns = 1.16us
#define SPSEL_MSTR_THIRD			(0x10)	// @24MHz = 8Mhz = 125ns = 1.75us
#define SPSEL_MSTR_QUARTER		(0x20)	// @24MHz = 6Mhz = 166ns = 2.33us
#define SPSEL_MSTR_SIXTH			(0x30)	// @24MHz = 4Mhz = 250ns = 3.5us
#define SPSEL_MSTR_EIGHTH			(0x40)	// @24MHz = 3Mhz = 333ns = 4.66us
#define SPSEL_MSTR_TENTH			(0x50)	// @24MHz = 2.4Mhz = 416ns = 5.83us
#define SPSEL_MSTR_TWELTH			(0x60)	// @24MHz = 2Mhz = 500ns = 7us
#define SPSEL_MSTR_EIGHTEENTH	(0x70)	// @24MHz = 1.33Mhz = 751ns = 10.52us

// Channel select - x should be between 0 and 9

#define ADC_CSR_SELECT_CHANNEL(x)		(ADC1->CSR = (ADC1->CSR & (~ADC1_CSR_CH)) | (x & ADC1_CSR_CH))

#endif	// __adc_H