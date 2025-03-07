   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  93                     ; 34 void setI2CIntPriority(intPriority l)
  93                     ; 35 {
  95                     .text:	section	.text,new
  96  0000               _setI2CIntPriority:
  98  0000 88            	push	a
  99       00000000      OFST:	set	0
 102                     ; 37 	ITC->ISPR5 &=~ITC_I2C_MASK ;
 104  0001 c67f74        	ld	a,32628
 105  0004 a43f          	and	a,#63
 106  0006 c77f74        	ld	32628,a
 107                     ; 38 	ITC->ISPR5 |= (l & (~ITC_I2C_MASK));
 109  0009 7b01          	ld	a,(OFST+1,sp)
 110  000b a43f          	and	a,#63
 111  000d ca7f74        	or	a,32628
 112  0010 c77f74        	ld	32628,a
 113                     ; 40 }
 116  0013 84            	pop	a
 117  0014 81            	ret	
 153                     ; 42 void setPORTEIntPriority(intPriority l)
 153                     ; 43 {
 154                     .text:	section	.text,new
 155  0000               _setPORTEIntPriority:
 157  0000 88            	push	a
 158       00000000      OFST:	set	0
 161                     ; 45 	ITC->ISPR2 &=~ITC_PORTE_MASK ;
 163  0001 c67f71        	ld	a,32625
 164  0004 a43f          	and	a,#63
 165  0006 c77f71        	ld	32625,a
 166                     ; 46 	ITC->ISPR2 |= (l & (~ITC_PORTE_MASK));
 168  0009 7b01          	ld	a,(OFST+1,sp)
 169  000b a43f          	and	a,#63
 170  000d ca7f71        	or	a,32625
 171  0010 c77f71        	ld	32625,a
 172                     ; 48 }
 175  0013 84            	pop	a
 176  0014 81            	ret	
 211                     ; 50 void setTIM2IntPriority(intPriority l)
 211                     ; 51 {
 212                     .text:	section	.text,new
 213  0000               _setTIM2IntPriority:
 215  0000 88            	push	a
 216       00000000      OFST:	set	0
 219                     ; 53 	ITC->ISPR4 &=~ITC_TIM2_MASK ;
 221  0001 c67f73        	ld	a,32627
 222  0004 a4f3          	and	a,#243
 223  0006 c77f73        	ld	32627,a
 224                     ; 54 	ITC->ISPR4 |= (l & (~ITC_TIM2_MASK));
 226  0009 7b01          	ld	a,(OFST+1,sp)
 227  000b a4f3          	and	a,#243
 228  000d ca7f73        	or	a,32627
 229  0010 c77f73        	ld	32627,a
 230                     ; 56 }
 233  0013 84            	pop	a
 234  0014 81            	ret	
 269                     ; 58 void setTIM3IntPriority(intPriority l)
 269                     ; 59 {
 270                     .text:	section	.text,new
 271  0000               _setTIM3IntPriority:
 273  0000 88            	push	a
 274       00000000      OFST:	set	0
 277                     ; 61 	ITC->ISPR4 &=~ITC_TIM3_MASK ;
 279  0001 c67f73        	ld	a,32627
 280  0004 a43f          	and	a,#63
 281  0006 c77f73        	ld	32627,a
 282                     ; 62 	ITC->ISPR4 |= (l & (~ITC_TIM3_MASK));
 284  0009 7b01          	ld	a,(OFST+1,sp)
 285  000b a43f          	and	a,#63
 286  000d ca7f73        	or	a,32627
 287  0010 c77f73        	ld	32627,a
 288                     ; 64 }
 291  0013 84            	pop	a
 292  0014 81            	ret	
 327                     ; 66 void setTIM4IntPriority(intPriority l)
 327                     ; 67 {
 328                     .text:	section	.text,new
 329  0000               _setTIM4IntPriority:
 331  0000 88            	push	a
 332       00000000      OFST:	set	0
 335                     ; 69 	ITC->ISPR6 &=~ITC_TIM4_MASK ;
 337  0001 c67f75        	ld	a,32629
 338  0004 a43f          	and	a,#63
 339  0006 c77f75        	ld	32629,a
 340                     ; 70 	ITC->ISPR6 |= (l & (~ITC_TIM4_MASK));
 342  0009 7b01          	ld	a,(OFST+1,sp)
 343  000b a43f          	and	a,#63
 344  000d ca7f75        	or	a,32629
 345  0010 c77f75        	ld	32629,a
 346                     ; 72 }
 349  0013 84            	pop	a
 350  0014 81            	ret	
 386                     ; 74 void setUART1RxIntPriority(intPriority l)
 386                     ; 75 {
 387                     .text:	section	.text,new
 388  0000               _setUART1RxIntPriority:
 390  0000 88            	push	a
 391       00000000      OFST:	set	0
 394                     ; 77 	ITC->ISPR5 &=~ITC_UART1_RX_MASK ;
 396  0001 c67f74        	ld	a,32628
 397  0004 a4cf          	and	a,#207
 398  0006 c77f74        	ld	32628,a
 399                     ; 78 	ITC->ISPR5 |= (l & (~ITC_UART1_RX_MASK ));
 401  0009 7b01          	ld	a,(OFST+1,sp)
 402  000b a4cf          	and	a,#207
 403  000d ca7f74        	or	a,32628
 404  0010 c77f74        	ld	32628,a
 405                     ; 80 }
 408  0013 84            	pop	a
 409  0014 81            	ret	
 445                     ; 82 void setUART1TxIntPriority(intPriority l)
 445                     ; 83 {
 446                     .text:	section	.text,new
 447  0000               _setUART1TxIntPriority:
 449  0000 88            	push	a
 450       00000000      OFST:	set	0
 453                     ; 85 	ITC->ISPR5 &=~ITC_UART1_TX_MASK ;
 455  0001 c67f74        	ld	a,32628
 456  0004 a4f3          	and	a,#243
 457  0006 c77f74        	ld	32628,a
 458                     ; 86 	ITC->ISPR5 |= (l & (~ITC_UART1_TX_MASK ));
 460  0009 7b01          	ld	a,(OFST+1,sp)
 461  000b a4f3          	and	a,#243
 462  000d ca7f74        	or	a,32628
 463  0010 c77f74        	ld	32628,a
 464                     ; 88 }
 467  0013 84            	pop	a
 468  0014 81            	ret	
 504                     ; 90 void setUART3TxIntPriority(intPriority l)
 504                     ; 91 {
 505                     .text:	section	.text,new
 506  0000               _setUART3TxIntPriority:
 508  0000 88            	push	a
 509       00000000      OFST:	set	0
 512                     ; 93 	ITC->ISPR6 &=~ITC_UART3_TX_MASK ;
 514  0001 c67f75        	ld	a,32629
 515  0004 a4fc          	and	a,#252
 516  0006 c77f75        	ld	32629,a
 517                     ; 94 	ITC->ISPR6 |= (l & (~ITC_UART3_TX_MASK ));
 519  0009 7b01          	ld	a,(OFST+1,sp)
 520  000b a4fc          	and	a,#252
 521  000d ca7f75        	or	a,32629
 522  0010 c77f75        	ld	32629,a
 523                     ; 96 }
 526  0013 84            	pop	a
 527  0014 81            	ret	
 563                     ; 98 void setUART3RxIntPriority(intPriority l)
 563                     ; 99 {
 564                     .text:	section	.text,new
 565  0000               _setUART3RxIntPriority:
 567  0000 88            	push	a
 568       00000000      OFST:	set	0
 571                     ; 101 	ITC->ISPR6 &=~ITC_UART3_RX_MASK ;
 573  0001 c67f75        	ld	a,32629
 574  0004 a4f3          	and	a,#243
 575  0006 c77f75        	ld	32629,a
 576                     ; 102 	ITC->ISPR6 |= (l & (~ITC_UART3_RX_MASK ));
 578  0009 7b01          	ld	a,(OFST+1,sp)
 579  000b a4f3          	and	a,#243
 580  000d ca7f75        	or	a,32629
 581  0010 c77f75        	ld	32629,a
 582                     ; 104 }
 585  0013 84            	pop	a
 586  0014 81            	ret	
 609                     ; 106 void initIntPriorities(void)	// default lowest priority
 609                     ; 107 {
 610                     .text:	section	.text,new
 611  0000               _initIntPriorities:
 615                     ; 108 	ITC->ISPR1 = ITC_LEVEL1;
 617  0000 35557f70      	mov	32624,#85
 618                     ; 109 	ITC->ISPR2 = ITC_LEVEL1;
 620  0004 35557f71      	mov	32625,#85
 621                     ; 110 	ITC->ISPR3 = ITC_LEVEL1;
 623  0008 35557f72      	mov	32626,#85
 624                     ; 111 	ITC->ISPR4 = ITC_LEVEL1;
 626  000c 35557f73      	mov	32627,#85
 627                     ; 112 	ITC->ISPR5 = ITC_LEVEL1;
 629  0010 35557f74      	mov	32628,#85
 630                     ; 113 	ITC->ISPR6 = ITC_LEVEL1;
 632  0014 35557f75      	mov	32629,#85
 633                     ; 114 	ITC->ISPR7 = ITC_LEVEL1;
 635  0018 35557f76      	mov	32630,#85
 636                     ; 115 	ITC->ISPR8 = ITC_LEVEL1;
 638  001c 35557f77      	mov	32631,#85
 639                     ; 117 	ITC->ISPR2 &=~ITC_PORTE_MASK ;
 641  0020 c67f71        	ld	a,32625
 642  0023 a43f          	and	a,#63
 643  0025 c77f71        	ld	32625,a
 644                     ; 118 	ITC->ISPR2 |= (ITC_LEVEL1 & (~ITC_PORTE_MASK));
 646  0028 c67f71        	ld	a,32625
 647  002b aa15          	or	a,#21
 648  002d c77f71        	ld	32625,a
 649                     ; 120 	ITC->ISPR5 &=~ITC_UART1_RX_MASK ;
 651  0030 c67f74        	ld	a,32628
 652  0033 a4cf          	and	a,#207
 653  0035 c77f74        	ld	32628,a
 654                     ; 121 	ITC->ISPR5 |= (ITC_LEVEL1 & (~ITC_UART1_RX_MASK ));
 656  0038 c67f74        	ld	a,32628
 657  003b aa45          	or	a,#69
 658  003d c77f74        	ld	32628,a
 659                     ; 123 	ITC->ISPR5 &=~ITC_I2C_MASK ;
 661  0040 c67f74        	ld	a,32628
 662  0043 a43f          	and	a,#63
 663  0045 c77f74        	ld	32628,a
 664                     ; 124 	ITC->ISPR5 |= (ITC_LEVEL1 & (~ITC_I2C_MASK ));
 666  0048 c67f74        	ld	a,32628
 667  004b aa15          	or	a,#21
 668  004d c77f74        	ld	32628,a
 669                     ; 126 	ITC->ISPR4 &=~ITC_TIM2_MASK ;
 671  0050 c67f73        	ld	a,32627
 672  0053 a4f3          	and	a,#243
 673  0055 c77f73        	ld	32627,a
 674                     ; 127 	ITC->ISPR4 |= (ITC_LEVEL3 & (~ITC_TIM2_MASK));		//timer2 - priority 3
 676  0058 c67f73        	ld	a,32627
 677  005b aaf3          	or	a,#243
 678  005d c77f73        	ld	32627,a
 679                     ; 129 	ITC->ISPR4 &=~ITC_TIM3_MASK ;
 681  0060 c67f73        	ld	a,32627
 682  0063 a43f          	and	a,#63
 683  0065 c77f73        	ld	32627,a
 684                     ; 130 	ITC->ISPR4 |= (ITC_LEVEL1 & (~ITC_TIM3_MASK));
 686  0068 c67f73        	ld	a,32627
 687  006b aa15          	or	a,#21
 688  006d c77f73        	ld	32627,a
 689                     ; 132 	ITC->ISPR6 &=~ITC_UART3_RX_MASK ;
 691  0070 c67f75        	ld	a,32629
 692  0073 a4f3          	and	a,#243
 693  0075 c77f75        	ld	32629,a
 694                     ; 133 	ITC->ISPR6 |= (ITC_LEVEL1 & (~ITC_UART3_RX_MASK));
 696  0078 c67f75        	ld	a,32629
 697  007b aa51          	or	a,#81
 698  007d c77f75        	ld	32629,a
 699                     ; 136 }
 702  0080 81            	ret	
 715                     	xdef	_setUART3RxIntPriority
 716                     	xdef	_setUART3TxIntPriority
 717                     	xdef	_setUART1TxIntPriority
 718                     	xdef	_setUART1RxIntPriority
 719                     	xdef	_setTIM4IntPriority
 720                     	xdef	_setTIM3IntPriority
 721                     	xdef	_setTIM2IntPriority
 722                     	xdef	_setI2CIntPriority
 723                     	xdef	_setPORTEIntPriority
 724                     	xdef	_initIntPriorities
 743                     	end
