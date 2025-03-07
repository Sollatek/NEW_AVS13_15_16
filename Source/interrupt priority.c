#include "stm8s.h"
#include "stm8s_type.h"
//#include "stm8s_it.h"
#include "globals.h"

void initIntPriorities(void);
void setPORTEIntPriority(intPriority l);
void setI2CIntPriority(intPriority l);
void setTIM2IntPriority(intPriority l);
void setTIM3IntPriority(intPriority l);
void setTIM4IntPriority(intPriority l);
void setUART1RxIntPriority(intPriority l);
void setUART1TxIntPriority(intPriority l);
void setUART3TxIntPriority(intPriority l);
void setUART3RxIntPriority(intPriority l);

// set interrupt priorities
	// level I1	I0
	//	0			1	0
	//	1			0	1
	//	2			0	0
	//	3			1	1

#define ITC_PORTE_MASK			0xC0 // bit positions for PORTE interrupt 	IRQ7	ITC_SPR2	7-6
#define ITC_UART1_TX_MASK 	0x0C // bit positions for UART1TX interrupt	IRQ17	ITC_SPR5	3-2
#define ITC_UART1_RX_MASK 	0x30 // bit positions for UART1RX interrupt	IRQ18	ITC_SPR5	5-4
#define ITC_I2C_MASK				0xC0 // bit positions for TIMER4 interrupt	IRQ23	ITC_SPR6	7-6
#define ITC_UART3_TX_MASK 	0x03 // bit positions for UART3TX interrupt	IRQ20	ITC_SPR6	1-0
#define ITC_UART3_RX_MASK 	0x0C // bit positions for UART3TX interrupt	IRQ21	ITC_SPR6	3-2
#define ITC_TIM2_MASK				0x0C // bit positions for TIMER2 interrupt	IRQ13	ITC_SPR4	5-4
#define ITC_TIM3_MASK				0xC0 // bit positions for TIMER3 interrupt	IRQ15	ITC_SPR4	7-6
#define ITC_TIM4_MASK				0xC0 // bit positions for TIMER4 interrupt	IRQ23	ITC_SPR6	7-6

void setI2CIntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR5 &=~ITC_I2C_MASK ;
	ITC->ISPR5 |= (l & (~ITC_I2C_MASK));
	//enableInterrupts();
}

void setPORTEIntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR2 &=~ITC_PORTE_MASK ;
	ITC->ISPR2 |= (l & (~ITC_PORTE_MASK));
	//enableInterrupts();
}

void setTIM2IntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR4 &=~ITC_TIM2_MASK ;
	ITC->ISPR4 |= (l & (~ITC_TIM2_MASK));
	//enableInterrupts();
}

void setTIM3IntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR4 &=~ITC_TIM3_MASK ;
	ITC->ISPR4 |= (l & (~ITC_TIM3_MASK));
	//enableInterrupts();
}

void setTIM4IntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR6 &=~ITC_TIM4_MASK ;
	ITC->ISPR6 |= (l & (~ITC_TIM4_MASK));
	//enableInterrupts();
}

void setUART1RxIntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR5 &=~ITC_UART1_RX_MASK ;
	ITC->ISPR5 |= (l & (~ITC_UART1_RX_MASK ));
	//enableInterrupts();
}

void setUART1TxIntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR5 &=~ITC_UART1_TX_MASK ;
	ITC->ISPR5 |= (l & (~ITC_UART1_TX_MASK ));
	//enableInterrupts();
}

void setUART3TxIntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR6 &=~ITC_UART3_TX_MASK ;
	ITC->ISPR6 |= (l & (~ITC_UART3_TX_MASK ));
	//enableInterrupts();
}

void setUART3RxIntPriority(intPriority l)
{
	//disableInterrupts();
	ITC->ISPR6 &=~ITC_UART3_RX_MASK ;
	ITC->ISPR6 |= (l & (~ITC_UART3_RX_MASK ));
	//enableInterrupts();
}

void initIntPriorities(void)	// default lowest priority
{
	ITC->ISPR1 = ITC_LEVEL1;
	ITC->ISPR2 = ITC_LEVEL1;
	ITC->ISPR3 = ITC_LEVEL1;
	ITC->ISPR4 = ITC_LEVEL1;
	ITC->ISPR5 = ITC_LEVEL1;
	ITC->ISPR6 = ITC_LEVEL1;
	ITC->ISPR7 = ITC_LEVEL1;
	ITC->ISPR8 = ITC_LEVEL1;
	
	ITC->ISPR2 &=~ITC_PORTE_MASK ;
	ITC->ISPR2 |= (ITC_LEVEL1 & (~ITC_PORTE_MASK));
	
	ITC->ISPR5 &=~ITC_UART1_RX_MASK ;
	ITC->ISPR5 |= (ITC_LEVEL1 & (~ITC_UART1_RX_MASK ));
	
	ITC->ISPR5 &=~ITC_I2C_MASK ;
	ITC->ISPR5 |= (ITC_LEVEL1 & (~ITC_I2C_MASK ));
	
	ITC->ISPR4 &=~ITC_TIM2_MASK ;
	ITC->ISPR4 |= (ITC_LEVEL3 & (~ITC_TIM2_MASK));		//timer2 - priority 3
	
	ITC->ISPR4 &=~ITC_TIM3_MASK ;
	ITC->ISPR4 |= (ITC_LEVEL1 & (~ITC_TIM3_MASK));
	
	ITC->ISPR6 &=~ITC_UART3_RX_MASK ;
	ITC->ISPR6 |= (ITC_LEVEL1 & (~ITC_UART3_RX_MASK));
	
	
}
	
	