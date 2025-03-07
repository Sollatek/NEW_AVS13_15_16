   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     .bit:	section	.data,bit
  19  0000               _isCalibrating:
  20  0000 00            	dc.b	0
  21  0001               _delayGood:
  22  0001 00            	dc.b	0
  94                     ; 23 void testProcedure(void)
  94                     ; 24 {
  96                     .text:	section	.text,new
  97  0000               _testProcedure:
  99  0000 89            	pushw	x
 100       00000002      OFST:	set	2
 103                     ; 26 	u8 test = 4;
 105  0001 a604          	ld	a,#4
 106  0003 6b01          	ld	(OFST-1,sp),a
 108                     ; 27 	isCalibrating = TRUE;
 110  0005 72100000      	bset	_isCalibrating
 111                     ; 28 	primeIntDelay();	// pull low and charge capacitor
 113  0009 cd0000        	call	_primeIntDelay
 115                     ; 30 	timer1Init();	//initialise TIM2 to generate interrrupt every 1s.
 117  000c cd0000        	call	_timer1Init
 119                     ; 32 	resDog();
 121  000f cd0000        	call	_resDog
 123                     ; 34 	led3 = LED_BLINK;
 125  0012 35020000      	mov	_led3,#2
 126                     ; 35 	led4 = LED_BLINK;
 128  0016 35020000      	mov	_led4,#2
 129                     ; 37 	resDog();
 131  001a cd0000        	call	_resDog
 133                     ; 39 	for (i=0; i<6; i++)	//four measurements needed to calculate valid period (we use 5 for stability)
 135  001d 0f02          	clr	(OFST+0,sp)
 137  001f               L33:
 138                     ; 41 		resDog();
 140  001f cd0000        	call	_resDog
 142                     ; 42 		measureACPeriod();
 144  0022 cd0000        	call	_measureACPeriod
 146                     ; 39 	for (i=0; i<6; i++)	//four measurements needed to calculate valid period (we use 5 for stability)
 148  0025 0c02          	inc	(OFST+0,sp)
 152  0027 7b02          	ld	a,(OFST+0,sp)
 153  0029 a106          	cp	a,#6
 154  002b 25f2          	jrult	L33
 155                     ; 44 	resDog();
 157  002d cd0000        	call	_resDog
 159                     ; 45 	sampleVoltage(1);	// determine correction factor
 161  0030 a601          	ld	a,#1
 162  0032 cd0000        	call	_sampleVoltage
 164                     ; 46 	resDog();
 166  0035 cd0000        	call	_resDog
 168                     ; 49 		UART1_PutString("Freq = \x09", NO_NL);
 170  0038 4b00          	push	#0
 171  003a ae002a        	ldw	x,#L14
 172  003d cd0000        	call	_UART1_PutString
 174  0040 be00          	ldw	x,_frequency
 175  0042 84            	pop	a
 176                     ; 50 		Int2str(strNum, frequency);
 178  0043 cd0000        	call	c_uitolx
 180  0046 be02          	ldw	x,c_lreg+2
 181  0048 89            	pushw	x
 182  0049 be00          	ldw	x,c_lreg
 183  004b 89            	pushw	x
 184  004c ae0000        	ldw	x,#_strNum
 185  004f cd0000        	call	_Int2str
 187  0052 5b04          	addw	sp,#4
 188                     ; 51 		UART1_PutString(strNum, NL);
 190  0054 4b01          	push	#1
 191  0056 ae0000        	ldw	x,#_strNum
 192  0059 cd0000        	call	_UART1_PutString
 194  005c 84            	pop	a
 195                     ; 52 		UART1_PutString("CorrFact = \x09", NO_NL);
 197  005d 4b00          	push	#0
 198  005f ae001d        	ldw	x,#L34
 199  0062 cd0000        	call	_UART1_PutString
 201  0065 84            	pop	a
 202                     ; 53 		Hex2str(strNum, (u32)getCorrectionFactor());
 204  0066 cd0000        	call	_getCorrectionFactor
 206  0069 cd0000        	call	c_uitolx
 208  006c be02          	ldw	x,c_lreg+2
 209  006e 89            	pushw	x
 210  006f be00          	ldw	x,c_lreg
 211  0071 89            	pushw	x
 212  0072 ae0000        	ldw	x,#_strNum
 213  0075 cd0000        	call	_Hex2str
 215  0078 5b04          	addw	sp,#4
 216                     ; 54 		UART1_PutString(strNum, NL);
 218  007a 4b01          	push	#1
 219  007c ae0000        	ldw	x,#_strNum
 220  007f cd0000        	call	_UART1_PutString
 222                     	btst	_acVmeasurementOK
 223  0087 84            	pop	a
 224                     ; 57 	if (!acVmeasurementOK) 
 226  0088 2506          	jrult	L54
 227                     ; 59 		errors |= ERR2;		//wrong period so no point in going further
 229  008a 72120000      	bset	_errors,#1
 230                     ; 60 		return;
 232  008e 200a          	jra	L27
 233  0090               L54:
 234                     ; 63 	if (isCorrectionFactorBad()) 
 236  0090 cd0000        	call	_isCorrectionFactorBad
 238  0093 4d            	tnz	a
 239  0094 2706          	jreq	L74
 240                     ; 65 		errors |= ERR3;
 242  0096 72140000      	bset	_errors,#2
 243                     ; 66 		return;
 244  009a               L27:
 247  009a 85            	popw	x
 248  009b 81            	ret	
 249  009c               L74:
 250                     ; 106 	stopTimer1();
 252  009c cd0000        	call	_stopTimer1
 254                     ; 115 	waitms(1000);
 256  009f ae03e8        	ldw	x,#1000
 257  00a2 cd0000        	call	_waitms
 259                     ; 116 	relay1.enableRelay();
 261  00a5 92cd1c        	call	[_relay1+28.w]
 263                     ; 117 	led1 = LED_ON;
 265  00a8 35010000      	mov	_led1,#1
 266                     ; 119 	resDog();
 268  00ac cd0000        	call	_resDog
 271  00af 200b          	jra	L35
 272  00b1               L15:
 273                     ; 128 			writeInternalEEPROM16bit(AVS13_FLAG, EEPROM_AVS_TYPE);
 275  00b1 ae4006        	ldw	x,#16390
 276  00b4 89            	pushw	x
 277  00b5 aea5a5        	ldw	x,#42405
 278  00b8 cd0000        	call	_writeInternalEEPROM16bit
 280  00bb 85            	popw	x
 281  00bc               L35:
 282                     ; 127 		while (*EEPROM_AVS_TYPE != AVS13_FLAG)
 284  00bc ce4006        	ldw	x,16390
 285  00bf a3a5a5        	cpw	x,#42405
 286  00c2 26ed          	jrne	L15
 287                     ; 138 	resDog();	
 289  00c4 cd0000        	call	_resDog
 291                     ; 144 		writeInternalEEPROM16bit(0x0000, EEPROM_FIRST_30_MIN_ADD);	//reset flag in EEPROM when this feature is disabled
 293  00c7 ae4002        	ldw	x,#16386
 294  00ca 89            	pushw	x
 295  00cb 5f            	clrw	x
 298  00cc 2007          	jra	L16
 299  00ce               L75:
 300                     ; 148 		writeInternalEEPROM16bit(0x00FE, EEPROM_CALIBRATION_DONE);	//set calibration flag in EEPROM
 302  00ce ae4004        	ldw	x,#16388
 303  00d1 89            	pushw	x
 304  00d2 ae00fe        	ldw	x,#254
 306  00d5               L16:
 307  00d5 cd0000        	call	_writeInternalEEPROM16bit
 308  00d8 85            	popw	x
 309                     ; 147 	while (!isCalibrationDone())
 311  00d9 cd0000        	call	_isCalibrationDone
 313  00dc 4d            	tnz	a
 314  00dd 27ef          	jreq	L75
 315                     ; 151 }	//testProcedure
 317  00df 20b9          	jra	L27
 368                     ; 154 _Bool isDelayBad(void)
 368                     ; 155 {
 369                     .text:	section	.text,new
 370  0000               _isDelayBad:
 372  0000 5204          	subw	sp,#4
 373       00000004      OFST:	set	4
 376                     ; 156 	vu16 delayADCcount = 0, tst = 0;
 378  0002 5f            	clrw	x
 379  0003 1f03          	ldw	(OFST-1,sp),x
 383  0005 1f01          	ldw	(OFST-3,sp),x
 385                     ; 157 	primeIntDelay();	// pull low if it hasn't been already pulled and charge capacitor
 387  0007 cd0000        	call	_primeIntDelay
 389                     ; 158 	waitms(4000);				// wait 4 more sec to make sure delay is primed properly
 391  000a ae0fa0        	ldw	x,#4000
 392  000d cd0000        	call	_waitms
 394                     ; 160 	releaseIntDelay();	// start discharging
 396  0010 cd0000        	call	_releaseIntDelay
 398                     ; 161 	waitms(10000);			//wait for 10s
 400  0013 ae2710        	ldw	x,#10000
 401  0016 cd0000        	call	_waitms
 403                     ; 162 	delayADCcount = getIntDelay();
 405  0019 cd0000        	call	_getIntDelay
 407  001c 1f03          	ldw	(OFST-1,sp),x
 409                     ; 166 		UART1_PutString("DelayStart = \x09", NO_NL);
 411  001e 4b00          	push	#0
 412  0020 ae000e        	ldw	x,#L701
 413  0023 cd0000        	call	_UART1_PutString
 415  0026 84            	pop	a
 416                     ; 167 		Int2str(strNum, tst);
 418  0027 1e01          	ldw	x,(OFST-3,sp)
 419  0029 cd0000        	call	c_uitolx
 421  002c be02          	ldw	x,c_lreg+2
 422  002e 89            	pushw	x
 423  002f be00          	ldw	x,c_lreg
 424  0031 89            	pushw	x
 425  0032 ae0000        	ldw	x,#_strNum
 426  0035 cd0000        	call	_Int2str
 428  0038 5b04          	addw	sp,#4
 429                     ; 168 		UART1_PutString(strNum, NL);
 431  003a 4b01          	push	#1
 432  003c ae0000        	ldw	x,#_strNum
 433  003f cd0000        	call	_UART1_PutString
 435  0042 84            	pop	a
 436                     ; 169 		UART1_PutString("DelayStop = \x09", NO_NL);
 438  0043 4b00          	push	#0
 439  0045 ae0000        	ldw	x,#L111
 440  0048 cd0000        	call	_UART1_PutString
 442  004b 84            	pop	a
 443                     ; 170 		Int2str(strNum, delayADCcount);
 445  004c 1e03          	ldw	x,(OFST-1,sp)
 446  004e cd0000        	call	c_uitolx
 448  0051 be02          	ldw	x,c_lreg+2
 449  0053 89            	pushw	x
 450  0054 be00          	ldw	x,c_lreg
 451  0056 89            	pushw	x
 452  0057 ae0000        	ldw	x,#_strNum
 453  005a cd0000        	call	_Int2str
 455  005d 5b04          	addw	sp,#4
 456                     ; 171 		UART1_PutString(strNum, NL);
 458  005f 4b01          	push	#1
 459  0061 ae0000        	ldw	x,#_strNum
 460  0064 cd0000        	call	_UART1_PutString
 462  0067 84            	pop	a
 463                     ; 175 	if ((delayADCcount < (TEST_INT_DELAY_ADC_LEVEL - 90)) || (delayADCcount > (TEST_INT_DELAY_ADC_LEVEL + 100)))
 465  0068 1e03          	ldw	x,(OFST-1,sp)
 466  006a a30047        	cpw	x,#71
 467  006d 2507          	jrult	L511
 469  006f 1e03          	ldw	x,(OFST-1,sp)
 470  0071 a30106        	cpw	x,#262
 471  0074 2504          	jrult	L311
 472  0076               L511:
 473                     ; 176 		return TRUE;
 475  0076 a601          	ld	a,#1
 477  0078 2001          	jra	L421
 478  007a               L311:
 479                     ; 177 	return FALSE;
 481  007a 4f            	clr	a
 483  007b               L421:
 485  007b 5b04          	addw	sp,#4
 486  007d 81            	ret	
 514                     ; 181 _Bool checkForTestProcedure(void)
 514                     ; 182 {
 515                     .text:	section	.text,new
 516  0000               _checkForTestProcedure:
 520                     ; 183 	if (!isYGlow())
 522  0000 cd0000        	call	_isYGlow
 524  0003 4d            	tnz	a
 525  0004 2601          	jrne	L721
 526                     ; 184 		return (FALSE);
 530  0006 81            	ret	
 531  0007               L721:
 532                     ; 186 	if (!isButtonPressed2())
 534  0007 cd0000        	call	_isButtonPressed2
 536  000a 4d            	tnz	a
 537  000b 2601          	jrne	L131
 538                     ; 187 		return (FALSE);
 542  000d 81            	ret	
 543  000e               L131:
 544                     ; 189 	if (getPotADC() < (ADC_FULL_SCALE - 5))
 546  000e cd0000        	call	_getPotADC
 548  0011 a303fb        	cpw	x,#1019
 549  0014 2402          	jruge	L331
 550                     ; 190 		return (FALSE);
 552  0016 4f            	clr	a
 555  0017 81            	ret	
 556  0018               L331:
 557                     ; 192 	return (TRUE);
 559  0018 a601          	ld	a,#1
 562  001a 81            	ret	
 597                     	xdef	_isDelayBad
 598                     	xref.b	_strNum
 599                     	xref	_Int2str
 600                     	xref	_Hex2str
 601                     	xref	_UART1_PutString
 602                     	xref	_waitms
 603                     	xref	_resDog
 604                     	xref	_stopTimer1
 605                     	xref	_timer1Init
 606                     	xdef	_delayGood
 607                     	xdef	_isCalibrating
 608                     	xdef	_checkForTestProcedure
 609                     	xdef	_testProcedure
 610                     	xref.b	_relay1
 611                     	xref.b	_errors
 612                     	xref	_isCalibrationDone
 613                     	xref	_releaseIntDelay
 614                     	xref	_primeIntDelay
 615                     	xref.b	_led4
 616                     	xref.b	_led3
 617                     	xref.b	_led1
 618                     	xbit	_acVmeasurementOK
 619                     	xref.b	_frequency
 620                     	xref	_getCorrectionFactor
 621                     	xref	_isCorrectionFactorBad
 622                     	xref	_sampleVoltage
 623                     	xref	_measureACPeriod
 624                     	xref	_isButtonPressed2
 625                     	xref	_isYGlow
 626                     	xref	_writeInternalEEPROM16bit
 627                     	xref	_getPotADC
 628                     	xref	_getIntDelay
 629                     .const:	section	.text
 630  0000               L111:
 631  0000 44656c617953  	dc.b	"DelayStop = ",9,0
 632  000e               L701:
 633  000e 44656c617953  	dc.b	"DelayStart = ",9,0
 634  001d               L34:
 635  001d 436f72724661  	dc.b	"CorrFact = ",9,0
 636  002a               L14:
 637  002a 46726571203d  	dc.b	"Freq = ",9,0
 638                     	xref.b	c_lreg
 658                     	xref	c_uitolx
 659                     	end
