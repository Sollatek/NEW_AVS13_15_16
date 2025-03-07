   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     .bit:	section	.data,bit
  19  0000               _timer2OverflowFlag:
  20  0000 00            	dc.b	0
  21                     	bsct
  22  0000               _holdusCtr:
  23  0000 0000          	dc.w	0
  52                     ; 32 void startTimer2(void)
  52                     ; 33 {
  54                     .text:	section	.text,new
  55  0000               _startTimer2:
  59                     ; 34 	TIM2->CR1 |= TIM2_CR1_CEN;//(TIM2_CR1_CEN | TIM2_CR1_URS | TIM2_CR1_UDIS);
  61  0000 72105300      	bset	21248,#0
  62                     ; 35 	TIM2->IER 	|= TIM2_IER_UIE; 	// enable timer overflow interrupt
  64  0004 72105303      	bset	21251,#0
  65                     ; 36 }
  68  0008 81            	ret	
 102                     ; 39 void resetTimer2(u16 timerValUs)
 102                     ; 40 {
 103                     .text:	section	.text,new
 104  0000               _resetTimer2:
 108                     ; 41 	TIM2->PSCR 	= TIMER2_PRESCALER;			// Set the Prescaler value 
 110  0000 3504530e      	mov	21262,#4
 111                     ; 42 	TIM2->ARRH = ((u8)(timerValUs>>8));
 113  0004 9e            	ld	a,xh
 114  0005 c7530f        	ld	21263,a
 115                     ; 43 	TIM2->ARRL = ((u8)timerValUs);
 117  0008 9f            	ld	a,xl
 118  0009 c75310        	ld	21264,a
 119                     ; 44 	TIM2->CNTRH = 0;
 121  000c 725f530c      	clr	21260
 122                     ; 45 	TIM2->CNTRL = 0;
 124  0010 725f530d      	clr	21261
 125                     ; 46 	TIM2->SR1 &=~TIM2_SR1_UIF;
 127  0014 72115304      	bres	21252,#0
 128                     ; 47 }
 131  0018 81            	ret	
 154                     ; 50 void timer1Init(void)
 154                     ; 51 {
 155                     .text:	section	.text,new
 156  0000               _timer1Init:
 160                     ; 52 	TIM1->PSCRH = (u8)(TIMER1_PRESCALER>>8);											// Set the Prescaler value (increment every 64us)
 162  0000 353e5260      	mov	21088,#62
 163                     ; 53 	TIM1->PSCRL = (u8)(TIMER1_PRESCALER);											// Set the Prescaler value (increment every 64us)
 165  0004 35805261      	mov	21089,#128
 166                     ; 54 	TIM1->ARRH = (u8)(TIMER1_CTR_VALUE>>8);											// Set the Autoreload value (15625)
 168  0008 35035262      	mov	21090,#3
 169                     ; 55 	TIM1->ARRL = (u8)(TIMER1_CTR_VALUE);
 171  000c 35e85263      	mov	21091,#232
 172                     ; 56 	TIM1->SR1 &= ~TIM1_SR1_UIF;
 174  0010 72115255      	bres	21077,#0
 175                     ; 57 	TIM1->IER |= TIM1_IER_UIE;
 177  0014 72105254      	bset	21076,#0
 178                     ; 58 	TIM1->CR1 |= TIM1_CR1_CEN;	// enable counting
 180  0018 72105250      	bset	21072,#0
 181                     ; 59 }
 184  001c 81            	ret	
 207                     ; 62 void stopTimer1(void)
 207                     ; 63 {
 208                     .text:	section	.text,new
 209  0000               _stopTimer1:
 213                     ; 64 	TIM1->CR1 &= (u8)(~TIM1_CR1_CEN);
 215  0000 72115250      	bres	21072,#0
 216                     ; 65 }
 219  0004 81            	ret	
 253                     ; 68 u16 getTimer2uSec(void)
 253                     ; 69 {
 254                     .text:	section	.text,new
 255  0000               _getTimer2uSec:
 257       00000002      OFST:	set	2
 260                     ; 70 	u16 ctrval = ((TIM2->CNTRH<<8) + TIM2->CNTRL);
 262  0000 c6530c        	ld	a,21260
 263  0003 5f            	clrw	x
 264  0004 97            	ld	xl,a
 265  0005 4f            	clr	a
 266  0006 cb530d        	add	a,21261
 267  0009 2401          	jrnc	L61
 268  000b 5c            	incw	x
 269  000c               L61:
 270  000c 02            	rlwa	x,a
 272                     ; 71 	return (ctrval);
 276  000d 81            	ret	
 299                     ; 75 void stopTimer2(void)
 299                     ; 76 {
 300                     .text:	section	.text,new
 301  0000               _stopTimer2:
 305                     ; 77 	TIM2->CR1 &=~TIM2_CR1_CEN;
 307  0000 72115300      	bres	21248,#0
 308                     ; 78 	TIM2->IER &=~TIM2_IER_UIE; 	// enable timer overflow interrupt
 310  0004 72115303      	bres	21251,#0
 311                     ; 79 }
 314  0008 81            	ret	
 338                     ; 82 _Bool hasTimer2Expired(void)	
 338                     ; 83 {
 339                     .text:	section	.text,new
 340  0000               _hasTimer2Expired:
 344                     ; 84 	if (TIM2->SR1 & TIM2_SR1_UIF)
 346  0000 7201530407    	btjf	21252,#0,L511
 347                     ; 86 		TIM2->SR1 &=~TIM2_SR1_UIF;
 349  0005 72115304      	bres	21252,#0
 350                     ; 87 		return (TRUE);
 352  0009 a601          	ld	a,#1
 355  000b 81            	ret	
 356  000c               L511:
 357                     ; 89 	return (FALSE);
 359  000c 4f            	clr	a
 362  000d 81            	ret	
 424                     ; 96 void holdus(u16 delay)
 424                     ; 97 {
 425                     .text:	section	.text,new
 426  0000               _holdus:
 428  0000 5205          	subw	sp,#5
 429       00000005      OFST:	set	5
 432                     ; 98 	u8 cntrStartPoint = TIM4->CNTR;
 434  0002 c65346        	ld	a,21318
 435  0005 6b05          	ld	(OFST+0,sp),a
 437                     ; 99 	u16 del = delay;
 439  0007 1f03          	ldw	(OFST-2,sp),x
 441                     ; 100 	u16 nloops = del/TIM4->ARR;
 443  0009 c65348        	ld	a,21320
 444  000c 62            	div	x,a
 445  000d 1f01          	ldw	(OFST-4,sp),x
 447                     ; 101 	holdusCtr = nloops;
 449  000f bf00          	ldw	_holdusCtr,x
 451  0011               L551:
 452                     ; 102 	while (holdusCtr) ;
 454  0011 be00          	ldw	x,_holdusCtr
 455  0013 26fc          	jrne	L551
 456                     ; 103 	del -= (nloops*TIM4->ARR);
 458  0015 1e01          	ldw	x,(OFST-4,sp)
 459  0017 c65348        	ld	a,21320
 460  001a cd0000        	call	c_bmulx
 462  001d 72f003        	subw	x,(OFST-2,sp)
 463  0020 50            	negw	x
 464  0021 1f03          	ldw	(OFST-2,sp),x
 466                     ; 104 	if ((255-del) < cntrStartPoint) holdusCtr++;
 468  0023 ae00ff        	ldw	x,#255
 469  0026 72f003        	subw	x,(OFST-2,sp)
 470  0029 7b05          	ld	a,(OFST+0,sp)
 471  002b 905f          	clrw	y
 472  002d 9097          	ld	yl,a
 473  002f 90bf00        	ldw	c_y,y
 474  0032 b300          	cpw	x,c_y
 475  0034 2405          	jruge	L561
 478  0036 be00          	ldw	x,_holdusCtr
 479  0038 5c            	incw	x
 480  0039 bf00          	ldw	_holdusCtr,x
 481  003b               L561:
 482                     ; 105 	while (holdusCtr) ;
 484  003b be00          	ldw	x,_holdusCtr
 485  003d 26fc          	jrne	L561
 486                     ; 106 	cntrStartPoint +=del;
 488  003f 1b04          	add	a,(OFST-1,sp)
 489  0041 6b05          	ld	(OFST+0,sp),a
 491                     ; 107 	if (cntrStartPoint > TIMER4_CTR_VALUE) cntrStartPoint = TIMER4_CTR_VALUE; //min ctr value to catch before reload
 493  0043 a1fa          	cp	a,#250
 494  0045 2504          	jrult	L571
 497  0047 a6f9          	ld	a,#249
 498  0049 6b05          	ld	(OFST+0,sp),a
 500  004b               L571:
 501                     ; 108 	while (TIM4->CNTR < cntrStartPoint) ;
 503  004b c65346        	ld	a,21318
 504  004e 1105          	cp	a,(OFST+0,sp)
 505  0050 25f9          	jrult	L571
 506                     ; 109 }
 509  0052 5b05          	addw	sp,#5
 510  0054 81            	ret	
 533                     ; 113 void timer4Init(void)
 533                     ; 114 {
 534                     .text:	section	.text,new
 535  0000               _timer4Init:
 539                     ; 115 	TIM4->PSCR 	= TIMER4_PRESCALER;											// Set the Prescaler value (increment every us)
 541  0000 35045347      	mov	21319,#4
 542                     ; 116 	TIM4->ARR 	= TIMER4_CTR_VALUE;											// Set the Autoreload value (250)
 544  0004 35f95348      	mov	21320,#249
 545                     ; 117 	TIM4->CR1 	|= (u8) (TIM4_CR1_CEN | TIM4_CR1_URS) ;			// Enable the timer
 547  0008 c65340        	ld	a,21312
 548  000b aa05          	or	a,#5
 549  000d c75340        	ld	21312,a
 550                     ; 118 	TIM4->IER 	|= TIM4_IER_UIE;												// Enable the Interrupt sources
 552  0010 72105343      	bset	21315,#0
 553                     ; 119 }
 556  0014 81            	ret	
 580                     ; 122 void enableIWatchDog(void)
 580                     ; 123 {
 581                     .text:	section	.text,new
 582  0000               _enableIWatchDog:
 586                     ; 124 	IWDG->KR = 0xCC;	// key value to enable watchdog
 588  0000 35cc50e0      	mov	20704,#204
 589                     ; 125 	resDog();	// set watchdog to running values
 592                     ; 126 }
 595  0004 cc0000        	jp	_resDog
 618                     ; 129 void resDog(void)
 618                     ; 130 {	
 619                     .text:	section	.text,new
 620  0000               _resDog:
 624                     ; 132 	IWDG->KR = 0x55;	// enable access to modify prescalar and timer value
 626  0000 355550e0      	mov	20704,#85
 627                     ; 133 	IWDG->PR = 0x04;	// set prescalar to /64
 629  0004 350450e1      	mov	20705,#4
 630                     ; 134 	IWDG->KR = 0x55;	// enable access to modify prescalar and timer value
 632  0008 355550e0      	mov	20704,#85
 633                     ; 135 	IWDG->RLR = 0x64;	// 100ms
 635  000c 356450e2      	mov	20706,#100
 636                     ; 136 	IWDG->KR = 0xAA; 	// reset watchdog and lock modify access to timer & prescaler
 638  0010 35aa50e0      	mov	20704,#170
 639                     ; 137 }
 642  0014 81            	ret	
 687                     ; 140 void waitms(u16 milliseconds)
 687                     ; 141 {
 688                     .text:	section	.text,new
 689  0000               _waitms:
 691  0000 89            	pushw	x
 692       00000002      OFST:	set	2
 695                     ; 142 	u16 waitCounter = milliseconds;
 697  0001 1f01          	ldw	(OFST-1,sp),x
 700  0003 200f          	jra	L752
 701  0005               L352:
 702                     ; 146 		if (millisecondTicker)
 704  0005 7201000007    	btjf	_millisecondTicker,L362
 705                     ; 148 			millisecondTicker = FALSE;
 707  000a 72110000      	bres	_millisecondTicker
 708                     ; 149 			waitCounter--;
 710  000e 5a            	decw	x
 711  000f 1f01          	ldw	(OFST-1,sp),x
 713  0011               L362:
 714                     ; 151 		resDog();	//timeout is 100ms
 716  0011 cd0000        	call	_resDog
 718  0014               L752:
 719                     ; 144 	while (waitCounter > 0)
 721  0014 1e01          	ldw	x,(OFST-1,sp)
 722  0016 26ed          	jrne	L352
 723                     ; 153 }
 726  0018 85            	popw	x
 727  0019 81            	ret	
 761                     	xdef	_holdusCtr
 762                     	xdef	_timer2OverflowFlag
 763                     	xdef	_waitms
 764                     	xdef	_holdus
 765                     	xdef	_resDog
 766                     	xdef	_enableIWatchDog
 767                     	xdef	_getTimer2uSec
 768                     	xdef	_hasTimer2Expired
 769                     	xdef	_stopTimer1
 770                     	xdef	_timer1Init
 771                     	xdef	_stopTimer2
 772                     	xdef	_resetTimer2
 773                     	xdef	_startTimer2
 774                     	xdef	_timer4Init
 775                     	xbit	_millisecondTicker
 776                     	xref.b	c_x
 777                     	xref.b	c_y
 796                     	xref	c_bmulx
 797                     	end
