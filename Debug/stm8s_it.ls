   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     	bsct
  19  0000               _TIM4counter:
  20  0000 00            	dc.b	0
  21  0001               _minutes:
  22  0001 00            	dc.b	0
  23  0002               _displayMilliSec:
  24  0002 00            	dc.b	0
  54                     ; 82 @far @interrupt void NonHandledInterrupt(void)
  54                     ; 83 {
  55                     .text:	section	.text,new
  56  0000               f_NonHandledInterrupt:
  60                     ; 87 }
  63  0000 80            	iret	
  85                     ; 96 @far @interrupt void TRAP_IRQHandler(void)
  85                     ; 97 {
  86                     .text:	section	.text,new
  87  0000               f_TRAP_IRQHandler:
  91                     ; 98 }
  94  0000 80            	iret	
 116                     ; 124 @far @interrupt void TLI_IRQHandler(void)
 116                     ; 125 #else /* _RAISONANCE_ */
 116                     ; 126 void TLI_IRQHandler(void) interrupt 0
 116                     ; 127 #endif /* _COSMIC_ */
 116                     ; 128 {
 117                     .text:	section	.text,new
 118  0000               f_TLI_IRQHandler:
 122                     ; 132 }
 125  0000 80            	iret	
 147                     ; 142 @far @interrupt void AWU_IRQHandler(void)
 147                     ; 143 #else /* _RAISONANCE_ */
 147                     ; 144 void AWU_IRQHandler(void) interrupt 1
 147                     ; 145 #endif /* _COSMIC_ */	
 147                     ; 146 {
 148                     .text:	section	.text,new
 149  0000               f_AWU_IRQHandler:
 153                     ; 150 }
 156  0000 80            	iret	
 178                     ; 160 @far @interrupt void CLK_IRQHandler(void)
 178                     ; 161 #else /* _RAISONANCE_ */
 178                     ; 162 void CLK_IRQHandler(void) interrupt 2
 178                     ; 163 #endif /* _COSMIC_ */
 178                     ; 164 {
 179                     .text:	section	.text,new
 180  0000               f_CLK_IRQHandler:
 184                     ; 168 }
 187  0000 80            	iret	
 210                     ; 178 @far @interrupt void EXTI_PORTA_IRQHandler(void)
 210                     ; 179 #else /* _RAISONANCE_ */
 210                     ; 180 void EXTI_PORTA_IRQHandler(void) interrupt 3
 210                     ; 181 #endif /* _COSMIC_ */
 210                     ; 182 {
 211                     .text:	section	.text,new
 212  0000               f_EXTI_PORTA_IRQHandler:
 216                     ; 184 }
 219  0000 80            	iret	
 242                     ; 194 @far @interrupt void EXTI_PORTB_IRQHandler(void)
 242                     ; 195 #else /* _RAISONANCE_ */
 242                     ; 196 void EXTI_PORTB_IRQHandler(void) interrupt 4
 242                     ; 197 #endif /* _COSMIC_ */
 242                     ; 198 {
 243                     .text:	section	.text,new
 244  0000               f_EXTI_PORTB_IRQHandler:
 248                     ; 200 }
 251  0000 80            	iret	
 274                     ; 210 @far @interrupt void EXTI_PORTC_IRQHandler(void)
 274                     ; 211 #else /* _RAISONANCE_ */
 274                     ; 212 void EXTI_PORTC_IRQHandler(void) interrupt 5
 274                     ; 213 #endif /* _COSMIC_ */
 274                     ; 214 {
 275                     .text:	section	.text,new
 276  0000               f_EXTI_PORTC_IRQHandler:
 280                     ; 216 }
 283  0000 80            	iret	
 306                     ; 226 @far @interrupt void EXTI_PORTD_IRQHandler(void)
 306                     ; 227 #else /* _RAISONANCE_ */
 306                     ; 228 void EXTI_PORTD_IRQHandler(void) interrupt 6
 306                     ; 229 #endif /* _COSMIC_ */
 306                     ; 230 {
 307                     .text:	section	.text,new
 308  0000               f_EXTI_PORTD_IRQHandler:
 312                     ; 231 	GPIOD->CR2 &= ~(BIT(1));		// disable interrupt on pin 1
 314  0000 72135013      	bres	20499,#1
 315                     ; 232 }
 318  0004 80            	iret	
 341                     ; 242 @far @interrupt void EXTI_PORTE_IRQHandler(void)
 341                     ; 243 #else /* _RAISONANCE_ */
 341                     ; 244 void EXTI_PORTE_IRQHandler(void) interrupt 7
 341                     ; 245 #endif /* _COSMIC_ */
 341                     ; 246 {
 342                     .text:	section	.text,new
 343  0000               f_EXTI_PORTE_IRQHandler:
 347                     ; 248 }
 350  0000 80            	iret	
 372                     ; 315 @far @interrupt void SPI_IRQHandler(void)
 372                     ; 316 #else /* _RAISONANCE_ */
 372                     ; 317 void SPI_IRQHandler(void) interrupt 10
 372                     ; 318 #endif /* _COSMIC_ */
 372                     ; 319 {
 373                     .text:	section	.text,new
 374  0000               f_SPI_IRQHandler:
 378                     ; 323 }
 381  0000 80            	iret	
 383                     	bsct
 384  0003               L141_secCounter:
 385  0003 00            	dc.b	0
 386  0004               L341_state:
 387  0004 00            	dc.b	0
 388  0005               L541_testCounter:
 389  0005 00            	dc.b	0
 457                     ; 333 @svlreg @far @interrupt void TIM1_UPD_OVF_TRG_BRK_IRQHandler(void)
 457                     ; 334 #else /* _RAISONANCE_ */
 457                     ; 335 void TIM1_UPD_OVF_TRG_BRK_IRQHandler(void) interrupt 11
 457                     ; 336 #endif /* _COSMIC_ */
 457                     ; 337 {
 458                     .text:	section	.text,new
 459  0000               f_TIM1_UPD_OVF_TRG_BRK_IRQHandler:
 461  0000 8a            	push	cc
 462  0001 84            	pop	a
 463  0002 a4bf          	and	a,#191
 464  0004 88            	push	a
 465  0005 86            	pop	cc
 466       00000001      OFST:	set	1
 467  0006 3b0002        	push	c_x+2
 468  0009 be00          	ldw	x,c_x
 469  000b 89            	pushw	x
 470  000c 3b0002        	push	c_y+2
 471  000f be00          	ldw	x,c_y
 472  0011 89            	pushw	x
 473  0012 be02          	ldw	x,c_lreg+2
 474  0014 89            	pushw	x
 475  0015 be00          	ldw	x,c_lreg
 476  0017 89            	pushw	x
 477  0018 88            	push	a
 480                     ; 338 	TIM1->SR1 &= ~TIM1_SR1_UIF;	// clear flag
 482  0019 72115255      	bres	21077,#0
 483                     ; 340   if (isCalibrating)
 485  001d 720100006f    	btjf	_isCalibrating,L312
 486                     ; 347 		switch(state)
 488  0022 b604          	ld	a,L341_state
 490                     ; 393 				break;
 491  0024 270d          	jreq	L741
 492  0026 4a            	dec	a
 493  0027 2712          	jreq	L151
 494  0029 4a            	dec	a
 495  002a 2724          	jreq	L351
 496  002c a0fc          	sub	a,#252
 497  002e 274f          	jreq	L551
 498  0030 4a            	dec	a
 499  0031 275a          	jreq	L751
 500  0033               L741:
 501                     ; 349 			case 0:
 501                     ; 350 			default:
 501                     ; 351 				secCounter = 0;
 503  0033 3f03          	clr	L141_secCounter
 504                     ; 352 				testCounter = 0;
 506  0035 3f05          	clr	L541_testCounter
 507                     ; 353 				state = 1;
 509  0037 35010004      	mov	L341_state,#1
 510  003b               L151:
 511                     ; 355 			case 1:
 511                     ; 356 				if (++secCounter >= 4)
 513  003b 3c03          	inc	L141_secCounter
 514  003d b603          	ld	a,L141_secCounter
 515  003f a104          	cp	a,#4
 516  0041 254e          	jrult	L312
 517                     ; 358 					releaseIntDelay();
 519  0043 cd0000        	call	_releaseIntDelay
 521                     ; 359 					secCounter = 0;
 523  0046 3f03          	clr	L141_secCounter
 524                     ; 360 					testCounter++;
 526  0048 3c05          	inc	L541_testCounter
 527                     ; 361 					state = 2;
 529  004a 35020004      	mov	L341_state,#2
 530  004e 2041          	jra	L312
 531  0050               L351:
 532                     ; 365 			case 2:
 532                     ; 366 				if (++secCounter >= 10)
 534  0050 3c03          	inc	L141_secCounter
 535  0052 b603          	ld	a,L141_secCounter
 536  0054 a10a          	cp	a,#10
 537  0056 2539          	jrult	L312
 538                     ; 368 					IntDelayADC = getIntDelay();
 540  0058 cd0000        	call	_getIntDelay
 542  005b 01            	rrwa	x,a
 543  005c 6b01          	ld	(OFST+0,sp),a
 545                     ; 369 					if ((IntDelayADC < (TEST_INT_DELAY_ADC_LEVEL - 90)) || (IntDelayADC > (TEST_INT_DELAY_ADC_LEVEL + 100)))
 547  005e a147          	cp	a,#71
 548  0060 2417          	jruge	L522
 549                     ; 371 						if (testCounter < 3)
 551  0062 b605          	ld	a,L541_testCounter
 552  0064 a103          	cp	a,#3
 553  0066 240b          	jruge	L722
 554                     ; 373 							secCounter = 0;
 556  0068 3f03          	clr	L141_secCounter
 557                     ; 374 							primeIntDelay();
 559  006a cd0000        	call	_primeIntDelay
 561                     ; 375 							state = 1;
 563  006d 35010004      	mov	L341_state,#1
 565  0071 201e          	jra	L312
 566  0073               L722:
 567                     ; 378 							state = 0xFF;
 569  0073 35ff0004      	mov	L341_state,#255
 570  0077 2018          	jra	L312
 571  0079               L522:
 572                     ; 381 						state = 0xFE;
 574  0079 35fe0004      	mov	L341_state,#254
 575  007d 2012          	jra	L312
 576  007f               L551:
 577                     ; 385 			case 0xFE:	// success. stay here forever
 577                     ; 386 				led3 = LED_ON;
 579  007f 35010000      	mov	_led3,#1
 580                     ; 387 				led4 = LED_ON;
 582  0083 35010000      	mov	_led4,#1
 583                     ; 388 				delayGood = TRUE;
 585  0087 72100000      	bset	_delayGood
 586                     ; 389 				break;
 588  008b 2004          	jra	L312
 589  008d               L751:
 590                     ; 391 			case 0xFF:	// failed. stay here forever
 590                     ; 392 				errors |= ERR1;
 592  008d 72100000      	bset	_errors,#0
 593                     ; 393 				break;
 595  0091               L312:
 596                     ; 396 }
 599  0091 84            	pop	a
 600  0092 85            	popw	x
 601  0093 bf00          	ldw	c_lreg,x
 602  0095 85            	popw	x
 603  0096 bf02          	ldw	c_lreg+2,x
 604  0098 85            	popw	x
 605  0099 bf00          	ldw	c_y,x
 606  009b 320002        	pop	c_y+2
 607  009e 85            	popw	x
 608  009f bf00          	ldw	c_x,x
 609  00a1 320002        	pop	c_x+2
 610  00a4 80            	iret	
 633                     ; 406 @far @interrupt void TIM1_CAP_COM_IRQHandler(void)
 633                     ; 407 #else /* _RAISONANCE_ */
 633                     ; 408 void TIM1_CAP_COM_IRQHandler(void) interrupt 12
 633                     ; 409 #endif /* _COSMIC_ */
 633                     ; 410 {
 634                     .text:	section	.text,new
 635  0000               f_TIM1_CAP_COM_IRQHandler:
 639                     ; 414 }
 642  0000 80            	iret	
 666                     ; 461 @far @interrupt void TIM2_UPD_OVF_BRK_IRQHandler(void)
 666                     ; 462 #else /* _RAISONANCE_ */
 666                     ; 463 void TIM2_UPD_OVF_BRK_IRQHandler(void) interrupt 13
 666                     ; 464 #endif /* _COSMIC_ */
 666                     ; 465 {
 667                     .text:	section	.text,new
 668  0000               f_TIM2_UPD_OVF_BRK_IRQHandler:
 672                     ; 466 	TIM2->SR1 &= ~TIM2_SR1_UIF;	// clear flag
 674  0000 72115304      	bres	21252,#0
 675                     ; 467 	timer2OverflowFlag = TRUE;
 677  0004 72100000      	bset	_timer2OverflowFlag
 678                     ; 468 }
 681  0008 80            	iret	
 704                     ; 478 @far @interrupt void TIM2_CAP_COM_IRQHandler(void)
 704                     ; 479 #else /* _RAISONANCE_ */
 704                     ; 480 void TIM2_CAP_COM_IRQHandler(void) interrupt 14
 704                     ; 481 #endif /* _COSMIC_ */
 704                     ; 482 {
 705                     .text:	section	.text,new
 706  0000               f_TIM2_CAP_COM_IRQHandler:
 710                     ; 486 }
 713  0000 80            	iret	
 736                     ; 539 @far @interrupt void UART1_TX_IRQHandler(void)
 736                     ; 540 #else /* _RAISONANCE_ */
 736                     ; 541 void UART1_TX_IRQHandler(void) interrupt 17
 736                     ; 542 #endif /* _COSMIC_ */
 736                     ; 543 {
 737                     .text:	section	.text,new
 738  0000               f_UART1_TX_IRQHandler:
 742                     ; 545 }
 745  0000 80            	iret	
 768                     ; 556 @far @interrupt void UART1_RX_IRQHandler(void)
 768                     ; 557 #else /* _RAISONANCE_ */
 768                     ; 558 void UART1_RX_IRQHandler(void) interrupt 18
 768                     ; 559 #endif /* _COSMIC_ */
 768                     ; 560 {
 769                     .text:	section	.text,new
 770  0000               f_UART1_RX_IRQHandler:
 774                     ; 562 }
 777  0000 80            	iret	
 799                     ; 573 @far @interrupt void I2C_IRQHandler(void)
 799                     ; 574 #else /* _RAISONANCE_ */
 799                     ; 575 void I2C_IRQHandler(void) interrupt 19
 799                     ; 576 #endif /* _COSMIC_ */
 799                     ; 577 {
 800                     .text:	section	.text,new
 801  0000               f_I2C_IRQHandler:
 805                     ; 578 }
 808  0000 80            	iret	
 830                     ; 677 @far @interrupt void ADC1_IRQHandler(void)
 830                     ; 678 #else /* _RAISONANCE_ */
 830                     ; 679 void ADC1_IRQHandler(void) interrupt 22
 830                     ; 680 #endif /* _COSMIC_ */
 830                     ; 681 {
 831                     .text:	section	.text,new
 832  0000               f_ADC1_IRQHandler:
 836                     ; 685 }
 839  0000 80            	iret	
 878                     ; 722 @far @svlreg @interrupt void TIM4_UPD_OVF_IRQHandler(void)
 878                     ; 723 #else /* _RAISONANCE_ */
 878                     ; 724 void TIM4_UPD_OVF_IRQHandler(void) interrupt 23
 878                     ; 725 #endif /* _COSMIC_ */
 878                     ; 726 {
 879                     .text:	section	.text,new
 880  0000               f_TIM4_UPD_OVF_IRQHandler:
 882  0000 8a            	push	cc
 883  0001 84            	pop	a
 884  0002 a4bf          	and	a,#191
 885  0004 88            	push	a
 886  0005 86            	pop	cc
 887  0006 3b0002        	push	c_x+2
 888  0009 be00          	ldw	x,c_x
 889  000b 89            	pushw	x
 890  000c 3b0002        	push	c_y+2
 891  000f be00          	ldw	x,c_y
 892  0011 89            	pushw	x
 893  0012 be02          	ldw	x,c_lreg+2
 894  0014 89            	pushw	x
 895  0015 be00          	ldw	x,c_lreg
 896  0017 89            	pushw	x
 899                     ; 728 	TIM4->SR1 &= ~TIM4_SR1_UIF;	// clear flag
 901  0018 72115344      	bres	21316,#0
 902                     ; 730 	if (holdusCtr) holdusCtr--;	//decrement timer variable used in holdus function
 904  001c be00          	ldw	x,_holdusCtr
 905  001e 2705          	jreq	L533
 908  0020 be00          	ldw	x,_holdusCtr
 909  0022 5a            	decw	x
 910  0023 bf00          	ldw	_holdusCtr,x
 911  0025               L533:
 912                     ; 732 	dimmingFlag++;
 914  0025 3c00          	inc	_dimmingFlag
 915                     ; 733 	refreshDisplay();
 917  0027 cd0000        	call	_refreshDisplay
 919                     ; 735 	if (++TIM4counter == TIMER4_SCHEDULER_1MS) 
 921  002a 3c00          	inc	_TIM4counter
 922  002c b600          	ld	a,_TIM4counter
 923  002e a104          	cp	a,#4
 924  0030 2650          	jrne	L733
 925                     ; 737 		TIM4counter = 0;
 927  0032 3f00          	clr	_TIM4counter
 928                     ; 738 		millisecondTicker = TRUE;
 930  0034 72100001      	bset	_millisecondTicker
 931                     ; 740 		updateRelayTimer(&relay1);
 933  0038 ae0000        	ldw	x,#_relay1
 934  003b cd0000        	call	_updateRelayTimer
 936                     ; 745 		if (tapChangeBlindTime < 0xFFFF) tapChangeBlindTime++;
 938  003e be00          	ldw	x,_tapChangeBlindTime
 939  0040 a3ffff        	cpw	x,#65535
 940  0043 2405          	jruge	L143
 943  0045 be00          	ldw	x,_tapChangeBlindTime
 944  0047 5c            	incw	x
 945  0048 bf00          	ldw	_tapChangeBlindTime,x
 946  004a               L143:
 947                     ; 749 		if(displayMilliSec > 5)
 949  004a b602          	ld	a,_displayMilliSec
 950  004c a106          	cp	a,#6
 951  004e 2506          	jrult	L343
 952                     ; 751 			displayMilliSec = 0;
 954  0050 3f02          	clr	_displayMilliSec
 955                     ; 752 			displayUpdate = TRUE;
 957  0052 72100000      	bset	_displayUpdate
 958  0056               L343:
 959                     ; 754 		displayMilliSec++;
 961  0056 3c02          	inc	_displayMilliSec
 962                     ; 756 		if (milliSeconds++ >= 999)	
 964  0058 be02          	ldw	x,_milliSeconds
 965  005a 5c            	incw	x
 966  005b bf02          	ldw	_milliSeconds,x
 967  005d 5a            	decw	x
 968  005e a303e7        	cpw	x,#999
 969  0061 251f          	jrult	L733
 970                     ; 758 			milliSeconds = 0;
 972  0063 5f            	clrw	x
 973  0064 bf02          	ldw	_milliSeconds,x
 974                     ; 761 			secondTicker = TRUE;	// activated every second for background timing
 976  0066 72100002      	bset	_secondTicker
 977                     ; 763 			if (seconds++ >= 59)
 979  006a b601          	ld	a,_seconds
 980  006c 3c01          	inc	_seconds
 981  006e a13b          	cp	a,#59
 982  0070 2510          	jrult	L733
 983                     ; 765 				seconds = 0;
 985  0072 3f01          	clr	_seconds
 986                     ; 766 				minuteTicker = TRUE;
 988  0074 72100003      	bset	_minuteTicker
 989                     ; 768 				minutes++;
 991  0078 3c01          	inc	_minutes
 992                     ; 769 				if (minutes >=  SENSITIVITY_RESET_PERIOD_MIN) minutes = 0;
 994  007a b601          	ld	a,_minutes
 995  007c a13c          	cp	a,#60
 996  007e 2502          	jrult	L733
 999  0080 3f01          	clr	_minutes
1000  0082               L733:
1001                     ; 775 }
1004  0082 85            	popw	x
1005  0083 bf00          	ldw	c_lreg,x
1006  0085 85            	popw	x
1007  0086 bf02          	ldw	c_lreg+2,x
1008  0088 85            	popw	x
1009  0089 bf00          	ldw	c_y,x
1010  008b 320002        	pop	c_y+2
1011  008e 85            	popw	x
1012  008f bf00          	ldw	c_x,x
1013  0091 320002        	pop	c_x+2
1014  0094 80            	iret	
1037                     ; 786 @far @interrupt void EEPROM_EEC_IRQHandler(void)
1037                     ; 787 #else /* _RAISONANCE_ */
1037                     ; 788 void EEPROM_EEC_IRQHandler(void) interrupt 24
1037                     ; 789 #endif /* _COSMIC_ */
1037                     ; 790 {
1038                     .text:	section	.text,new
1039  0000               f_EEPROM_EEC_IRQHandler:
1043                     ; 794 }
1046  0000 80            	iret	
1154                     	switch	.ubsct
1155  0000               _dimmingFlag:
1156  0000 00            	ds.b	1
1157                     	xdef	_dimmingFlag
1158                     .bit:	section	.data,bit
1159  0000               _displayUpdate:
1160  0000 00            	ds.b	1
1161                     	xdef	_displayUpdate
1162                     	xdef	_displayMilliSec
1163                     	switch	.ubsct
1164  0001               _seconds:
1165  0001 00            	ds.b	1
1166                     	xdef	_seconds
1167                     	xdef	_TIM4counter
1168                     	xref.b	_holdusCtr
1169                     	xbit	_timer2OverflowFlag
1170                     	xbit	_delayGood
1171                     	xbit	_isCalibrating
1172                     	switch	.bit
1173  0001               _millisecondTicker:
1174  0001 00            	ds.b	1
1175                     	xdef	_millisecondTicker
1176  0002               _secondTicker:
1177  0002 00            	ds.b	1
1178                     	xdef	_secondTicker
1179  0003               _minuteTicker:
1180  0003 00            	ds.b	1
1181                     	xdef	_minuteTicker
1182                     	xdef	_minutes
1183                     	switch	.ubsct
1184  0002               _milliSeconds:
1185  0002 0000          	ds.b	2
1186                     	xdef	_milliSeconds
1187                     	xref.b	_relay1
1188                     	xref	_updateRelayTimer
1189                     	xref.b	_errors
1190                     	xref	_releaseIntDelay
1191                     	xref	_primeIntDelay
1192                     	xref.b	_led4
1193                     	xref.b	_led3
1194                     	xref.b	_tapChangeBlindTime
1195                     	xref	_checkSensitivityArrays
1196                     	xref	_getIntDelay
1197                     	xref	_refreshDisplay
1198                     	xdef	f_EEPROM_EEC_IRQHandler
1199                     	xdef	f_TIM4_UPD_OVF_IRQHandler
1200                     	xdef	f_ADC1_IRQHandler
1201                     	xdef	f_I2C_IRQHandler
1202                     	xdef	f_UART1_RX_IRQHandler
1203                     	xdef	f_UART1_TX_IRQHandler
1204                     	xdef	f_TIM2_CAP_COM_IRQHandler
1205                     	xdef	f_TIM2_UPD_OVF_BRK_IRQHandler
1206                     	xdef	f_TIM1_UPD_OVF_TRG_BRK_IRQHandler
1207                     	xdef	f_TIM1_CAP_COM_IRQHandler
1208                     	xdef	f_SPI_IRQHandler
1209                     	xdef	f_EXTI_PORTE_IRQHandler
1210                     	xdef	f_EXTI_PORTD_IRQHandler
1211                     	xdef	f_EXTI_PORTC_IRQHandler
1212                     	xdef	f_EXTI_PORTB_IRQHandler
1213                     	xdef	f_EXTI_PORTA_IRQHandler
1214                     	xdef	f_CLK_IRQHandler
1215                     	xdef	f_AWU_IRQHandler
1216                     	xdef	f_TLI_IRQHandler
1217                     	xdef	f_TRAP_IRQHandler
1218                     	xdef	f_NonHandledInterrupt
1219                     	xref.b	c_lreg
1220                     	xref.b	c_x
1221                     	xref.b	c_y
1241                     	end
