   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.2 - 04 Jun 2024
   4                     ; Optimizer V4.6.2 - 04 Jun 2024
  18                     .const:	section	.text
  19  0000               __vectab:
  20  0000 82            	dc.b	130
  22  0001 00            	dc.b	page(__stext)
  23  0002 0000          	dc.w	__stext
  24  0004 82            	dc.b	130
  26  0005 00            	dc.b	page(f_TRAP_IRQHandler)
  27  0006 0000          	dc.w	f_TRAP_IRQHandler
  28  0008 82            	dc.b	130
  30  0009 00            	dc.b	page(f_TLI_IRQHandler)
  31  000a 0000          	dc.w	f_TLI_IRQHandler
  32  000c 82            	dc.b	130
  34  000d 00            	dc.b	page(f_AWU_IRQHandler)
  35  000e 0000          	dc.w	f_AWU_IRQHandler
  36  0010 82            	dc.b	130
  38  0011 00            	dc.b	page(f_CLK_IRQHandler)
  39  0012 0000          	dc.w	f_CLK_IRQHandler
  40  0014 82            	dc.b	130
  42  0015 00            	dc.b	page(f_EXTI_PORTA_IRQHandler)
  43  0016 0000          	dc.w	f_EXTI_PORTA_IRQHandler
  44  0018 82            	dc.b	130
  46  0019 00            	dc.b	page(f_EXTI_PORTB_IRQHandler)
  47  001a 0000          	dc.w	f_EXTI_PORTB_IRQHandler
  48  001c 82            	dc.b	130
  50  001d 00            	dc.b	page(f_EXTI_PORTC_IRQHandler)
  51  001e 0000          	dc.w	f_EXTI_PORTC_IRQHandler
  52  0020 82            	dc.b	130
  54  0021 00            	dc.b	page(f_EXTI_PORTD_IRQHandler)
  55  0022 0000          	dc.w	f_EXTI_PORTD_IRQHandler
  56  0024 82            	dc.b	130
  58  0025 00            	dc.b	page(f_EXTI_PORTE_IRQHandler)
  59  0026 0000          	dc.w	f_EXTI_PORTE_IRQHandler
  60  0028 82            	dc.b	130
  62  0029 00            	dc.b	page(f_NonHandledInterrupt)
  63  002a 0000          	dc.w	f_NonHandledInterrupt
  64  002c 82            	dc.b	130
  66  002d 00            	dc.b	page(f_NonHandledInterrupt)
  67  002e 0000          	dc.w	f_NonHandledInterrupt
  68  0030 82            	dc.b	130
  70  0031 00            	dc.b	page(f_SPI_IRQHandler)
  71  0032 0000          	dc.w	f_SPI_IRQHandler
  72  0034 82            	dc.b	130
  74  0035 00            	dc.b	page(f_TIM1_UPD_OVF_TRG_BRK_IRQHandler)
  75  0036 0000          	dc.w	f_TIM1_UPD_OVF_TRG_BRK_IRQHandler
  76  0038 82            	dc.b	130
  78  0039 00            	dc.b	page(f_TIM1_CAP_COM_IRQHandler)
  79  003a 0000          	dc.w	f_TIM1_CAP_COM_IRQHandler
  80  003c 82            	dc.b	130
  82  003d 00            	dc.b	page(f_TIM2_UPD_OVF_BRK_IRQHandler)
  83  003e 0000          	dc.w	f_TIM2_UPD_OVF_BRK_IRQHandler
  84  0040 82            	dc.b	130
  86  0041 00            	dc.b	page(f_TIM2_CAP_COM_IRQHandler)
  87  0042 0000          	dc.w	f_TIM2_CAP_COM_IRQHandler
  88  0044 82            	dc.b	130
  90  0045 00            	dc.b	page(f_NonHandledInterrupt)
  91  0046 0000          	dc.w	f_NonHandledInterrupt
  92  0048 82            	dc.b	130
  94  0049 00            	dc.b	page(f_NonHandledInterrupt)
  95  004a 0000          	dc.w	f_NonHandledInterrupt
  96  004c 82            	dc.b	130
  98  004d 00            	dc.b	page(f_UART1_TX_IRQHandler)
  99  004e 0000          	dc.w	f_UART1_TX_IRQHandler
 100  0050 82            	dc.b	130
 102  0051 00            	dc.b	page(f_UART1_RX_IRQHandler)
 103  0052 0000          	dc.w	f_UART1_RX_IRQHandler
 104  0054 82            	dc.b	130
 106  0055 00            	dc.b	page(f_I2C_IRQHandler)
 107  0056 0000          	dc.w	f_I2C_IRQHandler
 108  0058 82            	dc.b	130
 110  0059 00            	dc.b	page(f_NonHandledInterrupt)
 111  005a 0000          	dc.w	f_NonHandledInterrupt
 112  005c 82            	dc.b	130
 114  005d 00            	dc.b	page(f_NonHandledInterrupt)
 115  005e 0000          	dc.w	f_NonHandledInterrupt
 116  0060 82            	dc.b	130
 118  0061 00            	dc.b	page(f_ADC1_IRQHandler)
 119  0062 0000          	dc.w	f_ADC1_IRQHandler
 120  0064 82            	dc.b	130
 122  0065 00            	dc.b	page(f_TIM4_UPD_OVF_IRQHandler)
 123  0066 0000          	dc.w	f_TIM4_UPD_OVF_IRQHandler
 124  0068 82            	dc.b	130
 126  0069 00            	dc.b	page(f_EEPROM_EEC_IRQHandler)
 127  006a 0000          	dc.w	f_EEPROM_EEC_IRQHandler
 128  006c 82            	dc.b	130
 130  006d 00            	dc.b	page(f_NonHandledInterrupt)
 131  006e 0000          	dc.w	f_NonHandledInterrupt
 132  0070 82            	dc.b	130
 134  0071 00            	dc.b	page(f_NonHandledInterrupt)
 135  0072 0000          	dc.w	f_NonHandledInterrupt
 136  0074 82            	dc.b	130
 138  0075 00            	dc.b	page(f_NonHandledInterrupt)
 139  0076 0000          	dc.w	f_NonHandledInterrupt
 140  0078 82            	dc.b	130
 142  0079 00            	dc.b	page(f_NonHandledInterrupt)
 143  007a 0000          	dc.w	f_NonHandledInterrupt
 144  007c 82            	dc.b	130
 146  007d 00            	dc.b	page(f_NonHandledInterrupt)
 147  007e 0000          	dc.w	f_NonHandledInterrupt
 207                     	xdef	__vectab
 208                     	xref	f_EEPROM_EEC_IRQHandler
 209                     	xref	f_TIM4_UPD_OVF_IRQHandler
 210                     	xref	f_ADC1_IRQHandler
 211                     	xref	f_I2C_IRQHandler
 212                     	xref	f_UART1_RX_IRQHandler
 213                     	xref	f_UART1_TX_IRQHandler
 214                     	xref	f_TIM2_CAP_COM_IRQHandler
 215                     	xref	f_TIM2_UPD_OVF_BRK_IRQHandler
 216                     	xref	f_TIM1_UPD_OVF_TRG_BRK_IRQHandler
 217                     	xref	f_TIM1_CAP_COM_IRQHandler
 218                     	xref	f_SPI_IRQHandler
 219                     	xref	f_EXTI_PORTE_IRQHandler
 220                     	xref	f_EXTI_PORTD_IRQHandler
 221                     	xref	f_EXTI_PORTC_IRQHandler
 222                     	xref	f_EXTI_PORTB_IRQHandler
 223                     	xref	f_EXTI_PORTA_IRQHandler
 224                     	xref	f_CLK_IRQHandler
 225                     	xref	f_AWU_IRQHandler
 226                     	xref	f_TLI_IRQHandler
 227                     	xref	f_TRAP_IRQHandler
 228                     	xref	f_NonHandledInterrupt
 229                     	xref	__stext
 248                     	end
