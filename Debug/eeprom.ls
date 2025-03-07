   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
 126                     ; 22 u8 writeInternalEEPROM(u8* data, u8* loc, u8 len)
 126                     ; 23 {
 128                     .text:	section	.text,new
 129  0000               _writeInternalEEPROM:
 131  0000 89            	pushw	x
 132  0001 5208          	subw	sp,#8
 133       00000008      OFST:	set	8
 136                     ; 24 	u8 done = 0;
 138  0003 0f04          	clr	(OFST-4,sp)
 140                     ; 25 	vu16	msec = milliSeconds;
 142  0005 be00          	ldw	x,_milliSeconds
 143  0007 1f01          	ldw	(OFST-7,sp),x
 145                     ; 26 	u8* d = data;
 147  0009 1e09          	ldw	x,(OFST+1,sp)
 148  000b 1f05          	ldw	(OFST-3,sp),x
 150                     ; 27 	u8* l = loc;
 152  000d 1e0d          	ldw	x,(OFST+5,sp)
 153  000f 1f07          	ldw	(OFST-1,sp),x
 155                     ; 28 	u8 le = len;
 157  0011 7b0f          	ld	a,(OFST+7,sp)
 158  0013 6b03          	ld	(OFST-5,sp),a
 160                     ; 31 	FLASH->DUKR = 0xAE;
 162  0015 35ae5064      	mov	20580,#174
 163                     ; 32 	FLASH->DUKR = 0x56;
 165  0019 35565064      	mov	20580,#86
 167  001d               L76:
 168                     ; 34 	while (msec == milliSeconds) ;
 170  001d 1e01          	ldw	x,(OFST-7,sp)
 171  001f b300          	cpw	x,_milliSeconds
 172  0021 27fa          	jreq	L76
 174  0023 2050          	jra	L57
 175  0025               L37:
 176                     ; 39 		if (milliSeconds == msec) break;
 178  0025 be00          	ldw	x,_milliSeconds
 179  0027 1301          	cpw	x,(OFST-7,sp)
 180  0029 264a          	jrne	L57
 182  002b               L77:
 183                     ; 41 	msec = milliSeconds;
 185  002b be00          	ldw	x,_milliSeconds
 186  002d 1f01          	ldw	(OFST-7,sp),x
 188  002f 7b03          	ld	a,(OFST-5,sp)
 189  0031               L301:
 190                     ; 45 		if (le >= 4)	// if more than 4 bytes then enable long word programming mode
 192  0031 a104          	cp	a,#4
 193  0033 2547          	jrult	L111
 194                     ; 47 			FLASH->CR2 |= 0x40;
 196  0035 721c505b      	bset	20571,#6
 197                     ; 48 			FLASH->NCR2 &= ~0x40;
 199  0039 721d505c      	bres	20572,#6
 200                     ; 50 			*l++ = *d++;
 202  003d 1e05          	ldw	x,(OFST-3,sp)
 204  003f f6            	ld	a,(x)
 205  0040 5c            	incw	x
 206  0041 1f05          	ldw	(OFST-3,sp),x
 207  0043 1e07          	ldw	x,(OFST-1,sp)
 209  0045 f7            	ld	(x),a
 210  0046 5c            	incw	x
 211  0047 1f07          	ldw	(OFST-1,sp),x
 212                     ; 51 			*l++ = *d++;
 214  0049 1e05          	ldw	x,(OFST-3,sp)
 216  004b f6            	ld	a,(x)
 217  004c 5c            	incw	x
 218  004d 1f05          	ldw	(OFST-3,sp),x
 219  004f 1e07          	ldw	x,(OFST-1,sp)
 221  0051 f7            	ld	(x),a
 222  0052 5c            	incw	x
 223  0053 1f07          	ldw	(OFST-1,sp),x
 224                     ; 52 			*l++ = *d++;
 226  0055 1e05          	ldw	x,(OFST-3,sp)
 228  0057 f6            	ld	a,(x)
 229  0058 5c            	incw	x
 230  0059 1f05          	ldw	(OFST-3,sp),x
 231  005b 1e07          	ldw	x,(OFST-1,sp)
 233  005d f7            	ld	(x),a
 234  005e 5c            	incw	x
 235  005f 1f07          	ldw	(OFST-1,sp),x
 236                     ; 53 			*l++ = *d++;
 238  0061 1e05          	ldw	x,(OFST-3,sp)
 240  0063 f6            	ld	a,(x)
 241  0064 5c            	incw	x
 242  0065 1f05          	ldw	(OFST-3,sp),x
 243  0067 1e07          	ldw	x,(OFST-1,sp)
 245  0069 f7            	ld	(x),a
 246  006a 5c            	incw	x
 247  006b 1f07          	ldw	(OFST-1,sp),x
 248                     ; 54 			le -= 4;
 250  006d 7b03          	ld	a,(OFST-5,sp)
 251  006f a004          	sub	a,#4
 252  0071 6b03          	ld	(OFST-5,sp),a
 255  0073 201e          	jra	L711
 256  0075               L57:
 257                     ; 37 	while (!(FLASH->IAPSR & FLASH_IAPSR_DUL)) // wait for DUL bit in EEPROM status register to be set
 259  0075 7207505fab    	btjf	20575,#3,L37
 260  007a 20af          	jra	L77
 261  007c               L111:
 262                     ; 59 			*l++ = *d++;
 264  007c 1e05          	ldw	x,(OFST-3,sp)
 266  007e f6            	ld	a,(x)
 267  007f 5c            	incw	x
 268  0080 1f05          	ldw	(OFST-3,sp),x
 269  0082 1e07          	ldw	x,(OFST-1,sp)
 271  0084 f7            	ld	(x),a
 272  0085 5c            	incw	x
 273  0086 1f07          	ldw	(OFST-1,sp),x
 274                     ; 60 			le--;
 276  0088 0a03          	dec	(OFST-5,sp)
 278  008a 2007          	jra	L711
 279  008c               L511:
 280                     ; 66 			done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
 282  008c c6505f        	ld	a,20575
 283  008f a404          	and	a,#4
 284  0091 6b04          	ld	(OFST-4,sp),a
 286  0093               L711:
 287                     ; 64 		while (!done || (msec != milliSeconds)) 
 289  0093 7b04          	ld	a,(OFST-4,sp)
 290  0095 27f5          	jreq	L511
 292  0097 1e01          	ldw	x,(OFST-7,sp)
 293  0099 b300          	cpw	x,_milliSeconds
 294  009b 26ef          	jrne	L511
 295                     ; 68 		done = 0;
 297  009d 0f04          	clr	(OFST-4,sp)
 299                     ; 70 	while (le);
 301  009f 7b03          	ld	a,(OFST-5,sp)
 302  00a1 268e          	jrne	L301
 303                     ; 71 	FLASH->IAPSR &= ~FLASH_IAPSR_DUL;	// clear DUL bit to re-enable EEPROM write protection
 305  00a3 7217505f      	bres	20575,#3
 306                     ; 73 }
 309  00a7 5b0a          	addw	sp,#10
 310  00a9 81            	ret	
 402                     ; 75 u8 writeInternalEEPROM16bit(u16 data, u16* loc)
 402                     ; 76 {
 403                     .text:	section	.text,new
 404  0000               _writeInternalEEPROM16bit:
 406  0000 89            	pushw	x
 407  0001 5207          	subw	sp,#7
 408       00000007      OFST:	set	7
 411                     ; 77 	u8 done = 0;
 413  0003 0f07          	clr	(OFST+0,sp)
 415                     ; 78 	vu16	msec = milliSeconds;
 417  0005 be00          	ldw	x,_milliSeconds
 418  0007 1f05          	ldw	(OFST-2,sp),x
 420                     ; 79 	u8 dlow  = data;
 422  0009 7b09          	ld	a,(OFST+2,sp)
 423  000b 6b01          	ld	(OFST-6,sp),a
 425                     ; 80 	u8 dhigh = data>>8;
 427  000d 7b08          	ld	a,(OFST+1,sp)
 428  000f 6b02          	ld	(OFST-5,sp),a
 430                     ; 81 	u8* l = (u8 *)loc;
 432  0011 1e0c          	ldw	x,(OFST+5,sp)
 433  0013 1f03          	ldw	(OFST-4,sp),x
 435                     ; 84 	FLASH->DUKR = 0xAE;
 437  0015 35ae5064      	mov	20580,#174
 438                     ; 85 	FLASH->DUKR = 0x56;
 440  0019 35565064      	mov	20580,#86
 442  001d               L571:
 443                     ; 87 	while (msec == milliSeconds) ;
 445  001d 1e05          	ldw	x,(OFST-2,sp)
 446  001f b300          	cpw	x,_milliSeconds
 447  0021 27fa          	jreq	L571
 449  0023 2014          	jra	L302
 450  0025               L102:
 451                     ; 92 		if (milliSeconds == msec) break;
 453  0025 be00          	ldw	x,_milliSeconds
 454  0027 1305          	cpw	x,(OFST-2,sp)
 455  0029 260e          	jrne	L302
 457  002b               L502:
 458                     ; 94 	msec = milliSeconds;
 460  002b be00          	ldw	x,_milliSeconds
 461  002d 1f05          	ldw	(OFST-2,sp),x
 463                     ; 97 	*l++ = dhigh;
 465  002f 1e03          	ldw	x,(OFST-4,sp)
 466  0031 7b02          	ld	a,(OFST-5,sp)
 468  0033 f7            	ld	(x),a
 469  0034 5c            	incw	x
 470  0035 1f03          	ldw	(OFST-4,sp),x
 472  0037 200e          	jra	L512
 473  0039               L302:
 474                     ; 90 	while (!(FLASH->IAPSR & FLASH_IAPSR_DUL)) // wait for DUL bit in EEPROM status register to be set
 476  0039 7207505fe7    	btjf	20575,#3,L102
 477  003e 20eb          	jra	L502
 478  0040               L112:
 479                     ; 101 		done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
 481  0040 c6505f        	ld	a,20575
 482  0043 a404          	and	a,#4
 483  0045 6b07          	ld	(OFST+0,sp),a
 485  0047               L512:
 486                     ; 99 	while (!done || (msec != milliSeconds)) 
 488  0047 7b07          	ld	a,(OFST+0,sp)
 489  0049 27f5          	jreq	L112
 491  004b 1e05          	ldw	x,(OFST-2,sp)
 492  004d b300          	cpw	x,_milliSeconds
 493  004f 26ef          	jrne	L112
 494                     ; 103 	done = 0;
 496  0051 0f07          	clr	(OFST+0,sp)
 498                     ; 105 	*l = dlow;
 500  0053 1e03          	ldw	x,(OFST-4,sp)
 501  0055 7b01          	ld	a,(OFST-6,sp)
 502  0057 f7            	ld	(x),a
 504  0058 2007          	jra	L522
 505  005a               L122:
 506                     ; 109 		done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
 508  005a c6505f        	ld	a,20575
 509  005d a404          	and	a,#4
 510  005f 6b07          	ld	(OFST+0,sp),a
 512  0061               L522:
 513                     ; 107 	while (!done || (msec != milliSeconds)) 
 515  0061 7b07          	ld	a,(OFST+0,sp)
 516  0063 27f5          	jreq	L122
 518  0065 1e05          	ldw	x,(OFST-2,sp)
 519  0067 b300          	cpw	x,_milliSeconds
 520  0069 26ef          	jrne	L122
 521                     ; 111 	done = 0;
 523                     ; 113 	FLASH->IAPSR &= ~FLASH_IAPSR_DUL;	// clear DUL bit to re-enable EEPROM write protection
 525  006b 7217505f      	bres	20575,#3
 526                     ; 115 }
 529  006f 5b09          	addw	sp,#9
 530  0071 81            	ret	
 633                     ; 117 _Bool writeFLASH(u8 *data, u8 *loc, u8 len)
 633                     ; 118 {
 634                     .text:	section	.text,new
 635  0000               _writeFLASH:
 637  0000 89            	pushw	x
 638  0001 5208          	subw	sp,#8
 639       00000008      OFST:	set	8
 642                     ; 119 	u8 done = 0;
 644  0003 0f04          	clr	(OFST-4,sp)
 646                     ; 120 	vu16	msec = milliSeconds;
 648  0005 be00          	ldw	x,_milliSeconds
 649  0007 1f01          	ldw	(OFST-7,sp),x
 651                     ; 121 	u8* d = data;
 653  0009 1e09          	ldw	x,(OFST+1,sp)
 654  000b 1f05          	ldw	(OFST-3,sp),x
 656                     ; 122 	u8* l = loc;
 658  000d 1e0d          	ldw	x,(OFST+5,sp)
 659  000f 1f07          	ldw	(OFST-1,sp),x
 661                     ; 123 	u8 le = len;
 663  0011 7b0f          	ld	a,(OFST+7,sp)
 664  0013 6b03          	ld	(OFST-5,sp),a
 666                     ; 127 	FLASH->PUKR = 0x56;
 668  0015 35565062      	mov	20578,#86
 669                     ; 128 	FLASH->PUKR = 0xAE;
 671  0019 35ae5062      	mov	20578,#174
 673  001d               L703:
 674                     ; 131 	while (!(FLASH->IAPSR & FLASH_IAPSR_PUL)) // wait for PUL bit if flash status register to be set
 676  001d 7203505ffb    	btjf	20575,#1,L703
 677  0022               L313:
 678                     ; 139 		if (le >= 4)	// if more than 4 bytes then enable long word programming mode
 680  0022 a104          	cp	a,#4
 681  0024 2540          	jrult	L123
 682                     ; 141 			FLASH->CR2 |= 0x40;
 684  0026 721c505b      	bset	20571,#6
 685                     ; 142 			FLASH->NCR2 &= ~0x40;
 687  002a 721d505c      	bres	20572,#6
 688                     ; 144 			*l++ = *d++;
 690  002e 1e05          	ldw	x,(OFST-3,sp)
 692  0030 f6            	ld	a,(x)
 693  0031 5c            	incw	x
 694  0032 1f05          	ldw	(OFST-3,sp),x
 695  0034 1e07          	ldw	x,(OFST-1,sp)
 697  0036 f7            	ld	(x),a
 698  0037 5c            	incw	x
 699  0038 1f07          	ldw	(OFST-1,sp),x
 700                     ; 145 			*l++ = *d++;
 702  003a 1e05          	ldw	x,(OFST-3,sp)
 704  003c f6            	ld	a,(x)
 705  003d 5c            	incw	x
 706  003e 1f05          	ldw	(OFST-3,sp),x
 707  0040 1e07          	ldw	x,(OFST-1,sp)
 709  0042 f7            	ld	(x),a
 710  0043 5c            	incw	x
 711  0044 1f07          	ldw	(OFST-1,sp),x
 712                     ; 146 			*l++ = *d++;
 714  0046 1e05          	ldw	x,(OFST-3,sp)
 716  0048 f6            	ld	a,(x)
 717  0049 5c            	incw	x
 718  004a 1f05          	ldw	(OFST-3,sp),x
 719  004c 1e07          	ldw	x,(OFST-1,sp)
 721  004e f7            	ld	(x),a
 722  004f 5c            	incw	x
 723  0050 1f07          	ldw	(OFST-1,sp),x
 724                     ; 147 			*l++ = *d++;
 726  0052 1e05          	ldw	x,(OFST-3,sp)
 728  0054 f6            	ld	a,(x)
 729  0055 5c            	incw	x
 730  0056 1f05          	ldw	(OFST-3,sp),x
 731  0058 1e07          	ldw	x,(OFST-1,sp)
 733  005a f7            	ld	(x),a
 734  005b 5c            	incw	x
 735  005c 1f07          	ldw	(OFST-1,sp),x
 736                     ; 148 			le -= 4;
 738  005e 7b03          	ld	a,(OFST-5,sp)
 739  0060 a004          	sub	a,#4
 740  0062 6b03          	ld	(OFST-5,sp),a
 743  0064 2017          	jra	L723
 744  0066               L123:
 745                     ; 153 			*l++ = *d++;
 747  0066 1e05          	ldw	x,(OFST-3,sp)
 749  0068 f6            	ld	a,(x)
 750  0069 5c            	incw	x
 751  006a 1f05          	ldw	(OFST-3,sp),x
 752  006c 1e07          	ldw	x,(OFST-1,sp)
 754  006e f7            	ld	(x),a
 755  006f 5c            	incw	x
 756  0070 1f07          	ldw	(OFST-1,sp),x
 757                     ; 154 			le--;
 759  0072 0a03          	dec	(OFST-5,sp)
 761  0074 2007          	jra	L723
 762  0076               L523:
 763                     ; 160 			done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
 765  0076 c6505f        	ld	a,20575
 766  0079 a404          	and	a,#4
 767  007b 6b04          	ld	(OFST-4,sp),a
 769  007d               L723:
 770                     ; 158 		while (!done) 
 772  007d 7b04          	ld	a,(OFST-4,sp)
 773  007f 27f5          	jreq	L523
 774                     ; 164 		done = 0;
 776  0081 0f04          	clr	(OFST-4,sp)
 778                     ; 167 	while (le);
 780  0083 7b03          	ld	a,(OFST-5,sp)
 781  0085 269b          	jrne	L313
 782                     ; 168 	FLASH->IAPSR &= ~FLASH_IAPSR_PUL;	// clear PUL bit to re-enable flash write protection
 784  0087 7213505f      	bres	20575,#1
 785                     ; 170 }
 788  008b 5b0a          	addw	sp,#10
 789  008d 81            	ret	
 802                     	xdef	_writeFLASH
 803                     	xdef	_writeInternalEEPROM
 804                     	xref.b	_milliSeconds
 805                     	xdef	_writeInternalEEPROM16bit
 824                     	end
