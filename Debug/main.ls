   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     .bit:	section	.data,bit
  19  0000               _intDelayPrimed:
  20  0000 00            	dc.b	0
  21                     	bsct
  22  0000               _errors:
  23  0000 00            	dc.b	0
  24  0001               L3_digits:
  25  0001 00            	dc.b	0
  26  0002 0000          	ds.b	2
  27  0004               L5_currentSegment:
  28  0004 00            	dc.b	0
  29  0005               _ledCount:
  30  0005 00            	dc.b	0
  31  0006               _dimmingSet:
  32  0006 01            	dc.b	1
  33  0007               _menuDisplay:
  34  0007 00            	dc.b	0
 116                     ; 48 void main(void)
 116                     ; 49 {
 118                     .text:	section	.text,new
 119  0000               _main:
 121  0000 88            	push	a
 122       00000001      OFST:	set	1
 125                     ; 50 	u8 counter30min = 0;
 127  0001 0f01          	clr	(OFST+0,sp)
 129                     ; 53 	disableInterrupts();	
 132  0003 9b            	sim	
 134                     ; 54 	enableIWatchDog();		// 100ms
 137  0004 cd0000        	call	_enableIWatchDog
 139                     ; 55 	setClock();	// set clock to 16MHz
 141  0007 cd0000        	call	_setClock
 143                     ; 56 	GPIOinit();
 145  000a cd0000        	call	_GPIOinit
 147                     ; 57 	initIntPriorities();	// priorities to various interrupts
 149  000d cd0000        	call	_initIntPriorities
 151                     ; 58 	timer4Init();					// timer4 is set to every 250us, gives a 1ms, 1/2sec, 1sec etc.
 153  0010 cd0000        	call	_timer4Init
 155                     ; 59 	adcInit(); 						
 157  0013 cd0000        	call	_adcInit
 159                     ; 63 	UART1_Config();
 161  0016 cd0000        	call	_UART1_Config
 163                     ; 66 	initRelays();
 165  0019 cd0000        	call	_initRelays
 167                     ; 72 	enableInterrupts();	
 170  001c 9a            	rim	
 172                     ; 87 	UART1_PutString(FW_VERSION, NL);
 175  001d 4b01          	push	#1
 176  001f ae0068        	ldw	x,#L33
 177  0022 cd0000        	call	_UART1_PutString
 179  0025 84            	pop	a
 180                     ; 91 	if(checkForTestProcedure())//(isYGlow())//(isSWIMLow())
 182  0026 cd0000        	call	_checkForTestProcedure
 184  0029 4d            	tnz	a
 185  002a 2718          	jreq	L53
 186                     ; 93 		UART1_PutString("Test Start",NL);
 188  002c 4b01          	push	#1
 189  002e ae005d        	ldw	x,#L73
 190  0031 cd0000        	call	_UART1_PutString
 192  0034 84            	pop	a
 193                     ; 95 		testProcedure();	//test procedure to be executed with stable input voltage of 110V
 195  0035 cd0000        	call	_testProcedure
 197                     ; 96 		errorMode();
 199  0038 cd0000        	call	_errorMode
 201                     ; 97 		UART1_PutString("Test End",NL);
 203  003b 4b01          	push	#1
 204  003d ae0054        	ldw	x,#L14
 205  0040 cd0000        	call	_UART1_PutString
 207  0043 84            	pop	a
 208  0044               L53:
 209                     ; 100 	resDog();
 211  0044 cd0000        	call	_resDog
 213                     ; 104 		UART1_PutString("CorrFact = \x09", NO_NL);			// 0x09 is horizontal tab in ASCII
 215  0047 4b00          	push	#0
 216  0049 ae0047        	ldw	x,#L34
 217  004c cd0000        	call	_UART1_PutString
 219  004f 84            	pop	a
 220                     ; 105 		Hex2str(strNum, (u32)getCorrectionFactor());		//change hex to string representation
 222  0050 cd0000        	call	_getCorrectionFactor
 224  0053 cd0000        	call	c_uitolx
 226  0056 be02          	ldw	x,c_lreg+2
 227  0058 89            	pushw	x
 228  0059 be00          	ldw	x,c_lreg
 229  005b 89            	pushw	x
 230  005c ae0000        	ldw	x,#_strNum
 231  005f cd0000        	call	_Hex2str
 233  0062 5b04          	addw	sp,#4
 234                     ; 106 		UART1_PutString(strNum, NL);
 236  0064 4b01          	push	#1
 237  0066 ae0000        	ldw	x,#_strNum
 238  0069 cd0000        	call	_UART1_PutString
 240  006c 84            	pop	a
 241                     ; 109 	resDog();
 243  006d cd0000        	call	_resDog
 245                     ; 128 	UART1_PutString("Freq\x09Voltage\x09RelComb\x09RelState", NL);
 247  0070 4b01          	push	#1
 248  0072 ae0029        	ldw	x,#L54
 249  0075 cd0000        	call	_UART1_PutString
 251  0078 84            	pop	a
 252                     ; 131 	updateIntDelay();
 254  0079 cd0000        	call	_updateIntDelay
 256                     ; 132 	isSwitchOn =  !(IntDelaySecs == 0xFFFF);
 258  007c be00          	ldw	x,_IntDelaySecs
 259  007e 5c            	incw	x
 260  007f 2704          	jreq	L26
 261  0081 a601          	ld	a,#1
 262  0083 2001          	jra	L46
 263  0085               L26:
 264  0085 4f            	clr	a
 265  0086               L46:
 266  0086 b704          	ld	_isSwitchOn,a
 267                     ; 137 	measureACPeriod();
 269  0088 cd0000        	call	_measureACPeriod
 271                     ; 138 	resDog();
 273  008b cd0000        	call	_resDog
 275                     ; 139 	measureACPeriod();
 277  008e cd0000        	call	_measureACPeriod
 279                     ; 140 	resDog();
 281  0091 cd0000        	call	_resDog
 283                     ; 141 	measureACPeriod();
 285  0094 cd0000        	call	_measureACPeriod
 287                     ; 142 	resDog();
 289  0097 cd0000        	call	_resDog
 291                     ; 143 	measureACPeriod();	//4th added because first measurement is always not accurate (too short period measured)
 293  009a cd0000        	call	_measureACPeriod
 295                     ; 145 	GPIOsetLow(DIGIT0);
 297  009d 4b04          	push	#4
 298  009f ae500f        	ldw	x,#20495
 299  00a2 cd0000        	call	_GPIOsetLow
 301  00a5 84            	pop	a
 302                     ; 146 	GPIOsetLow(DIGIT1);
 304  00a6 4b08          	push	#8
 305  00a8 ae500f        	ldw	x,#20495
 306  00ab cd0000        	call	_GPIOsetLow
 308  00ae 84            	pop	a
 309                     ; 147 	GPIOsetLow(DIGIT2);
 311  00af 4b40          	push	#64
 312  00b1 ae5005        	ldw	x,#20485
 313  00b4 cd0000        	call	_GPIOsetLow
 315  00b7 84            	pop	a
 316                     ; 148 	GPIOsetLow(DIGIT3);
 318  00b8 4b80          	push	#128
 319  00ba ae5005        	ldw	x,#20485
 320  00bd cd0000        	call	_GPIOsetLow
 322  00c0 ae007b        	ldw	x,#123
 323  00c3 84            	pop	a
 324                     ; 149 	prepareValueToDisplay(123);
 326  00c4 cd0000        	call	_prepareValueToDisplay
 328  00c7               L74:
 329                     ; 156 		GPIOtoggle(TEST_LED_DISC);//2024
 331  00c7 4b01          	push	#1
 332  00c9 ae500f        	ldw	x,#20495
 333  00cc cd0000        	call	_GPIOtoggle
 335  00cf 84            	pop	a
 336                     ; 157 		refreshDisplay();
 338  00d0 cd0000        	call	_refreshDisplay
 340                     ; 158 		checkSwiches();
 342  00d3 cd0000        	call	_checkSwiches
 344                     ; 161 		resDog();
 346  00d6 cd0000        	call	_resDog
 348                     ; 164 		measureACPeriod();		//max 57ms (2 longest periods)
 350  00d9 cd0000        	call	_measureACPeriod
 352                     ; 167 		sampleVoltage(0);			//max 29ms (half of longest period
 354  00dc 4f            	clr	a
 355  00dd cd0000        	call	_sampleVoltage
 357                     ; 170 		processRelay(&relay1);
 359  00e0 ae0000        	ldw	x,#_relay1
 360  00e3 cd0000        	call	_processRelay
 362                     ; 173 		relayFunction(&relay1);
 364  00e6 ae0000        	ldw	x,#_relay1
 365  00e9 cd0000        	call	_relayFunction
 367                     ; 175 		resDog();
 369  00ec cd0000        	call	_resDog
 371                     ; 178 		operateRelay(&relay1);
 373  00ef ae0000        	ldw	x,#_relay1
 374  00f2 cd0000        	call	_operateRelay
 376                     ; 180 		resDog();
 378  00f5 cd0000        	call	_resDog
 380                     ; 182 		updateAVSState(&relay1);
 382  00f8 ae0000        	ldw	x,#_relay1
 383  00fb cd0000        	call	_updateAVSState
 385                     ; 183 		if(!menuDisplay)
 387  00fe b607          	ld	a,_menuDisplay
 388  0100 2608          	jrne	L35
 389                     ; 184 			prepareValueToDisplay(outputVoltage/160);//(testVal);
 391  0102 be00          	ldw	x,_outputVoltage
 392  0104 a6a0          	ld	a,#160
 393  0106 62            	div	x,a
 394  0107 cd0000        	call	_prepareValueToDisplay
 396  010a               L35:
 397                     ; 194 		if (secondTicker)
 399  010a 720100001a    	btjf	_secondTicker,L55
 400                     ; 196 			secondTicker = FALSE;
 402  010f 72110000      	bres	_secondTicker
 403                     ; 198 			updateIntDelay();
 405  0113 cd0000        	call	_updateIntDelay
 407                     ; 199 			localCounter++;
 409  0116 be00          	ldw	x,_localCounter
 410  0118 5c            	incw	x
 411  0119 bf00          	ldw	_localCounter,x
 412                     ; 201 			if(menuDisplay)
 414  011b b607          	ld	a,_menuDisplay
 415  011d 2707          	jreq	L75
 416                     ; 203 				if(localCounter > 15)
 418  011f a30010        	cpw	x,#16
 419  0122 2502          	jrult	L75
 420                     ; 205 					menuDisplay = FALSE;
 422  0124 3f07          	clr	_menuDisplay
 423  0126               L75:
 424                     ; 218 					TransmitData();
 426  0126 cd0000        	call	_TransmitData
 428  0129               L55:
 429                     ; 223 		if (minuteTicker)
 431  0129 7201000099    	btjf	_minuteTicker,L74
 432                     ; 225 			minuteTicker = FALSE;
 434  012e 72110000      	bres	_minuteTicker
 435                     ; 226 			if (isFirst30min())		// if first 30 minutes is disabled then it will always read false
 437  0132 cd0000        	call	_isFirst30min
 439  0135 4d            	tnz	a
 440  0136 278f          	jreq	L74
 441                     ; 227 				if (++counter30min >= 30) 
 443  0138 0c01          	inc	(OFST+0,sp)
 445  013a 7b01          	ld	a,(OFST+0,sp)
 446  013c a11e          	cp	a,#30
 447  013e 2587          	jrult	L74
 449  0140 2009          	jra	L37
 450  0142               L17:
 451                     ; 229 						writeInternalEEPROM16bit(0x0000, EEPROM_FIRST_30_MIN_ADD);	//reset flag in EEPROM when unit is no longer in initial 30 minutes of operation
 453  0142 ae4002        	ldw	x,#16386
 454  0145 89            	pushw	x
 455  0146 5f            	clrw	x
 456  0147 cd0000        	call	_writeInternalEEPROM16bit
 458  014a 85            	popw	x
 459  014b               L37:
 460                     ; 228 					while (isFirst30min())
 462  014b cd0000        	call	_isFirst30min
 464  014e 4d            	tnz	a
 465  014f 26f1          	jrne	L17
 466  0151 cc00c7        	jra	L74
 469                     .const:	section	.text
 470  0000               _segArray:
 471  0000 81            	dc.b	129
 472  0001 f3            	dc.b	243
 473  0002 49            	dc.b	73
 474  0003 61            	dc.b	97
 475  0004 33            	dc.b	51
 476  0005 25            	dc.b	37
 477  0006 05            	dc.b	5
 478  0007 f1            	dc.b	241
 479  0008 01            	dc.b	1
 480  0009 21            	dc.b	33
 481  000a 00            	dc.b	0
 482  000b               _ledArray:
 483  000b 00            	dc.b	0
 484  000c 40            	dc.b	64
 485  000d 80            	dc.b	128
 486  000e 08            	dc.b	8
 487  000f 10            	dc.b	16
 488  0010 20            	dc.b	32
 489  0011 04            	dc.b	4
 490  0012 02            	dc.b	2
 491                     	bsct
 492  0008               L77_menuSwState:
 493  0008 00            	dc.b	0
 554                     ; 242 void checkSwiches(void)
 554                     ; 243 {
 555                     .text:	section	.text,new
 556  0000               _checkSwiches:
 560                     ; 246 	if (isButtonPressed3()) 
 562  0000 cd0000        	call	_isButtonPressed3
 564  0003 4d            	tnz	a
 565  0004 2721          	jreq	L721
 566                     ; 248 	  if(dimmingSet)dimmingSet = FALSE;
 568  0006 b606          	ld	a,_dimmingSet
 569  0008 2704          	jreq	L131
 572  000a 3f06          	clr	_dimmingSet
 574  000c 2004          	jra	L331
 575  000e               L131:
 576                     ; 249 		else dimmingSet = TRUE;
 578  000e 35010006      	mov	_dimmingSet,#1
 579  0012               L331:
 580                     ; 251 		UART1_PutString("SW3",NL);
 582  0012 4b01          	push	#1
 583  0014 ae0025        	ldw	x,#L531
 584  0017 cd0000        	call	_UART1_PutString
 586  001a 84            	pop	a
 588  001b 2003          	jra	L141
 589  001d               L731:
 590                     ; 254 					resDog();
 592  001d cd0000        	call	_resDog
 594  0020               L141:
 595                     ; 252 		while(isButtonPressed3())
 597  0020 cd0000        	call	_isButtonPressed3
 599  0023 4d            	tnz	a
 600  0024 26f7          	jrne	L731
 603  0026 81            	ret	
 604  0027               L721:
 605                     ; 258 	else if(isButtonPressed2())
 607  0027 cd0000        	call	_isButtonPressed2
 609  002a 4d            	tnz	a
 610  002b 270a          	jreq	L741
 611                     ; 260 		UART1_PutString("SW2",NL);
 613  002d 4b01          	push	#1
 614  002f ae0021        	ldw	x,#L151
 615  0032 cd0000        	call	_UART1_PutString
 617  0035 84            	pop	a
 620  0036 81            	ret	
 621  0037               L741:
 622                     ; 263 	else if(isButtonPressed())
 624  0037 cd0000        	call	_isButtonPressed
 626  003a 4d            	tnz	a
 627  003b 2721          	jreq	L541
 628                     ; 265 		if(localCounter && !menuSwState)
 630  003d be00          	ldw	x,_localCounter
 631  003f 270c          	jreq	L751
 633  0041 b608          	ld	a,L77_menuSwState
 634  0043 2608          	jrne	L751
 635                     ; 267 			 localCounter = 0;
 637  0045 5f            	clrw	x
 638  0046 bf00          	ldw	_localCounter,x
 639                     ; 268 			 menuSwState = TRUE;
 641  0048 35010008      	mov	L77_menuSwState,#1
 644  004c 81            	ret	
 645  004d               L751:
 646                     ; 270 		else if(menuSwState && localCounter > 2)
 648  004d b608          	ld	a,L77_menuSwState
 649  004f 270d          	jreq	L541
 651  0051 a30003        	cpw	x,#3
 652  0054 2508          	jrult	L541
 653                     ; 272 			resDog();
 655  0056 cd0000        	call	_resDog
 657                     ; 273 			updateDelay();
 659  0059 cd0000        	call	_updateDelay
 661                     ; 274 			menuSwState = FALSE;
 663  005c 3f08          	clr	L77_menuSwState
 664  005e               L541:
 665                     ; 278 }
 668  005e 81            	ret	
 713                     ; 280 void prepareValueToDisplay(u16 value) 
 713                     ; 281 {
 714                     .text:	section	.text,new
 715  0000               _prepareValueToDisplay:
 717  0000 89            	pushw	x
 718  0001 88            	push	a
 719       00000001      OFST:	set	1
 722                     ; 283 		u8 loopCount = 0;  
 724                     ; 285     for (loopCount = 0; loopCount < 3; loopCount++) 
 726  0002 0f01          	clr	(OFST+0,sp)
 728  0004               L702:
 729                     ; 287         digits[2 - loopCount] = value % 10; // Extract the least significant digit
 731  0004 4f            	clr	a
 732  0005 97            	ld	xl,a
 733  0006 a602          	ld	a,#2
 734  0008 1001          	sub	a,(OFST+0,sp)
 735  000a 2401          	jrnc	L012
 736  000c 5a            	decw	x
 737  000d               L012:
 738  000d 02            	rlwa	x,a
 739  000e 1602          	ldw	y,(OFST+1,sp)
 740  0010 a60a          	ld	a,#10
 741  0012 9062          	div	y,a
 742  0014 905f          	clrw	y
 743  0016 9097          	ld	yl,a
 744  0018 9001          	rrwa	y,a
 745  001a e701          	ld	(L3_digits,x),a
 746                     ; 288         value /= 10; // Remove the last digit
 748  001c a60a          	ld	a,#10
 749  001e 1e02          	ldw	x,(OFST+1,sp)
 750  0020 62            	div	x,a
 751  0021 1f02          	ldw	(OFST+1,sp),x
 752                     ; 285     for (loopCount = 0; loopCount < 3; loopCount++) 
 754  0023 0c01          	inc	(OFST+0,sp)
 758  0025 7b01          	ld	a,(OFST+0,sp)
 759  0027 a103          	cp	a,#3
 760  0029 25d9          	jrult	L702
 761                     ; 290 }
 764  002b 5b03          	addw	sp,#3
 765  002d 81            	ret	
 768                     	bsct
 769  0009               L512_dimmingCounter:
 770  0009 00            	dc.b	0
 771                     	switch	.bit
 772  0001               L712_previousDimState:
 773  0001 00            	dc.b	0
 826                     ; 292 void refreshDisplay(void)
 826                     ; 293 {
 827                     .text:	section	.text,new
 828  0000               _refreshDisplay:
 832                     ; 297 	if(dimmingSet)
 834  0000 b606          	ld	a,_dimmingSet
 835  0002 2603cc00da    	jreq	L362
 836                     ; 299 		if(dimmingFlag < DIMMING_DUTY)
 838  0007 b600          	ld	a,_dimmingFlag
 839  0009 a102          	cp	a,#2
 840  000b 2503cc00a4    	jruge	L562
 841                     ; 302 			if(!previousDimState)
 843  0010 7201000103cc  	btjt	L712_previousDimState,L313
 844                     ; 304 				previousDimState = TRUE;
 846  0018 72100001      	bset	L712_previousDimState
 847                     ; 306 				currentSegment = (currentSegment + 1);
 849  001c 3c04          	inc	L5_currentSegment
 850                     ; 307 				if(currentSegment > 3) currentSegment = 0;
 852  001e b604          	ld	a,L5_currentSegment
 853  0020 a104          	cp	a,#4
 854  0022 2503          	jrult	L172
 857  0024 4f            	clr	a
 858  0025 b704          	ld	L5_currentSegment,a
 859  0027               L172:
 860                     ; 309 				if(currentSegment < 3)
 862  0027 a103          	cp	a,#3
 863  0029 240c          	jruge	L372
 864                     ; 310 					GPIOportValue(SIG_DATA_PORT, ~segArray[digits[currentSegment]]);
 866  002b 5f            	clrw	x
 867  002c 97            	ld	xl,a
 868  002d e601          	ld	a,(L3_digits,x)
 869  002f 5f            	clrw	x
 870  0030 97            	ld	xl,a
 871  0031 d60000        	ld	a,(_segArray,x)
 872  0034 43            	cpl	a
 875  0035 200b          	jp	LC001
 876  0037               L372:
 877                     ; 311 				else if (currentSegment == 3)
 879  0037 a103          	cp	a,#3
 880  0039 260f          	jrne	L572
 881                     ; 312 					GPIOportValue(SIG_DATA_PORT, ledArray[ledCount]);
 883  003b b605          	ld	a,_ledCount
 884  003d 5f            	clrw	x
 885  003e 97            	ld	xl,a
 886  003f d6000b        	ld	a,(_ledArray,x)
 888  0042               LC001:
 889  0042 88            	push	a
 890  0043 ae500a        	ldw	x,#20490
 891  0046 cd0000        	call	_GPIOportValue
 892  0049 84            	pop	a
 893  004a               L572:
 894                     ; 314 				GPIOsetLow(DIGIT3);
 896  004a 4b80          	push	#128
 897  004c ae5005        	ldw	x,#20485
 898  004f cd0000        	call	_GPIOsetLow
 900  0052 84            	pop	a
 901                     ; 315 				GPIOsetLow(DIGIT2);
 903  0053 4b40          	push	#64
 904  0055 ae5005        	ldw	x,#20485
 905  0058 cd0000        	call	_GPIOsetLow
 907  005b 84            	pop	a
 908                     ; 316 				GPIOsetLow(DIGIT1);
 910  005c 4b08          	push	#8
 911  005e ae500f        	ldw	x,#20495
 912  0061 cd0000        	call	_GPIOsetLow
 914  0064 84            	pop	a
 915                     ; 317 			  GPIOsetLow(DIGIT0);	
 917  0065 4b04          	push	#4
 918  0067 ae500f        	ldw	x,#20495
 919  006a cd0000        	call	_GPIOsetLow
 921  006d 84            	pop	a
 922                     ; 319 				switch (currentSegment) 
 924  006e b604          	ld	a,L5_currentSegment
 926                     ; 324 						case 3: GPIOsetHigh(DIGIT0); break;
 927  0070 270a          	jreq	L122
 928  0072 4a            	dec	a
 929  0073 2711          	jreq	L322
 930  0075 4a            	dec	a
 931  0076 2718          	jreq	L522
 932  0078 4a            	dec	a
 933  0079 271f          	jreq	L722
 935  007b 81            	ret	
 936  007c               L122:
 937                     ; 321 						case 0: GPIOsetHigh(DIGIT3); break;
 939  007c 4b80          	push	#128
 940  007e ae5005        	ldw	x,#20485
 941  0081 cd0000        	call	_GPIOsetHigh
 943  0084 84            	pop	a
 947  0085 81            	ret	
 948  0086               L322:
 949                     ; 322 						case 1: GPIOsetHigh(DIGIT2); break;
 951  0086 4b40          	push	#64
 952  0088 ae5005        	ldw	x,#20485
 953  008b cd0000        	call	_GPIOsetHigh
 955  008e 84            	pop	a
 959  008f 81            	ret	
 960  0090               L522:
 961                     ; 323 						case 2: GPIOsetHigh(DIGIT1); break;
 963  0090 4b08          	push	#8
 964  0092 ae500f        	ldw	x,#20495
 965  0095 cd0000        	call	_GPIOsetHigh
 967  0098 84            	pop	a
 971  0099 81            	ret	
 972  009a               L722:
 973                     ; 324 						case 3: GPIOsetHigh(DIGIT0); break;
 975  009a 4b04          	push	#4
 976  009c ae500f        	ldw	x,#20495
 977  009f cd0000        	call	_GPIOsetHigh
 979  00a2 84            	pop	a
 983  00a3 81            	ret	
 984  00a4               L562:
 985                     ; 328 		else if(dimmingFlag < DIMMING_OFF_DUTY)
 987  00a4 b600          	ld	a,_dimmingFlag
 988  00a6 a11a          	cp	a,#26
 989  00a8 2429          	jruge	L703
 990                     ; 330 			previousDimState = FALSE;
 992  00aa 72110001      	bres	L712_previousDimState
 993                     ; 331 			GPIOsetLow(DIGIT3);
 995  00ae 4b80          	push	#128
 996  00b0 ae5005        	ldw	x,#20485
 997  00b3 cd0000        	call	_GPIOsetLow
 999  00b6 84            	pop	a
1000                     ; 332 			GPIOsetLow(DIGIT2);
1002  00b7 4b40          	push	#64
1003  00b9 ae5005        	ldw	x,#20485
1004  00bc cd0000        	call	_GPIOsetLow
1006  00bf 84            	pop	a
1007                     ; 333 			GPIOsetLow(DIGIT1);
1009  00c0 4b08          	push	#8
1010  00c2 ae500f        	ldw	x,#20495
1011  00c5 cd0000        	call	_GPIOsetLow
1013  00c8 84            	pop	a
1014                     ; 334 			GPIOsetLow(DIGIT0);
1016  00c9 4b04          	push	#4
1017  00cb ae500f        	ldw	x,#20495
1018  00ce cd0000        	call	_GPIOsetLow
1020  00d1 84            	pop	a
1023  00d2 81            	ret	
1024  00d3               L703:
1025                     ; 338 			dimmingFlag = 0;
1027  00d3 3f00          	clr	_dimmingFlag
1028                     ; 339 			previousDimState = FALSE;
1030  00d5 72110001      	bres	L712_previousDimState
1032  00d9 81            	ret	
1033  00da               L362:
1034                     ; 342 	else if (displayUpdate && !dimmingSet) 
1036  00da 7200000003cc  	btjf	_displayUpdate,L313
1038  00e2 267d          	jrne	L313
1039                     ; 346     GPIOsetLow(DIGIT1);
1041  00e4 4b08          	push	#8
1042  00e6 ae500f        	ldw	x,#20495
1043  00e9 cd0000        	call	_GPIOsetLow
1045  00ec 84            	pop	a
1046                     ; 347     GPIOsetLow(DIGIT2);
1048  00ed 4b40          	push	#64
1049  00ef ae5005        	ldw	x,#20485
1050  00f2 cd0000        	call	_GPIOsetLow
1052  00f5 84            	pop	a
1053                     ; 348     GPIOsetLow(DIGIT3);
1055  00f6 4b80          	push	#128
1056  00f8 ae5005        	ldw	x,#20485
1057  00fb cd0000        	call	_GPIOsetLow
1059  00fe 84            	pop	a
1060                     ; 349 		GPIOsetLow(DIGIT0);
1062  00ff 4b04          	push	#4
1063  0101 ae500f        	ldw	x,#20495
1064  0104 cd0000        	call	_GPIOsetLow
1066  0107 3c04          	inc	L5_currentSegment
1067  0109 84            	pop	a
1068                     ; 352 		currentSegment = (currentSegment + 1);
1070                     ; 353 		if(currentSegment > 3)currentSegment = 0;
1072  010a b604          	ld	a,L5_currentSegment
1073  010c a104          	cp	a,#4
1074  010e 2503          	jrult	L713
1077  0110 4f            	clr	a
1078  0111 b704          	ld	L5_currentSegment,a
1079  0113               L713:
1080                     ; 355 		if(currentSegment < 3)
1082  0113 a103          	cp	a,#3
1083  0115 240c          	jruge	L123
1084                     ; 356 			GPIOportValue(SIG_DATA_PORT, ~segArray[digits[currentSegment]]);
1086  0117 5f            	clrw	x
1087  0118 97            	ld	xl,a
1088  0119 e601          	ld	a,(L3_digits,x)
1089  011b 5f            	clrw	x
1090  011c 97            	ld	xl,a
1091  011d d60000        	ld	a,(_segArray,x)
1092  0120 43            	cpl	a
1095  0121 200b          	jp	LC002
1096  0123               L123:
1097                     ; 357 		else if (currentSegment == 3)
1099  0123 a103          	cp	a,#3
1100  0125 260f          	jrne	L323
1101                     ; 358 			GPIOportValue(SIG_DATA_PORT, ledArray[ledCount]);
1103  0127 b605          	ld	a,_ledCount
1104  0129 5f            	clrw	x
1105  012a 97            	ld	xl,a
1106  012b d6000b        	ld	a,(_ledArray,x)
1108  012e               LC002:
1109  012e 88            	push	a
1110  012f ae500a        	ldw	x,#20490
1111  0132 cd0000        	call	_GPIOportValue
1112  0135 84            	pop	a
1113  0136               L323:
1114                     ; 361 		switch (currentSegment) 
1116  0136 b604          	ld	a,L5_currentSegment
1118                     ; 366 				case 3: GPIOsetHigh(DIGIT0); break;
1119  0138 270b          	jreq	L132
1120  013a 4a            	dec	a
1121  013b 270c          	jreq	L332
1122  013d 4a            	dec	a
1123  013e 2710          	jreq	L532
1124  0140 4a            	dec	a
1125  0141 2711          	jreq	L732
1126  0143 2018          	jra	L133
1127  0145               L132:
1128                     ; 363 				case 0: GPIOsetHigh(DIGIT3); break;
1130  0145 4b80          	push	#128
1134  0147 2002          	jp	LC005
1135  0149               L332:
1136                     ; 364 				case 1: GPIOsetHigh(DIGIT2); break;
1138  0149 4b40          	push	#64
1139  014b               LC005:
1140  014b ae5005        	ldw	x,#20485
1144  014e 2009          	jp	LC003
1145  0150               L532:
1146                     ; 365 				case 2: GPIOsetHigh(DIGIT1); break;
1148  0150 4b08          	push	#8
1152  0152 2002          	jp	LC004
1153  0154               L732:
1154                     ; 366 				case 3: GPIOsetHigh(DIGIT0); break;
1156  0154 4b04          	push	#4
1157  0156               LC004:
1158  0156 ae500f        	ldw	x,#20495
1160  0159               LC003:
1161  0159 cd0000        	call	_GPIOsetHigh
1162  015c 84            	pop	a
1165  015d               L133:
1166                     ; 372     displayUpdate = FALSE;
1168  015d 72110000      	bres	_displayUpdate
1169  0161               L313:
1170                     ; 374 }
1173  0161 81            	ret	
1210                     ; 376 void updateDelay(void)
1210                     ; 377 {
1211                     .text:	section	.text,new
1212  0000               _updateDelay:
1214  0000 89            	pushw	x
1215       00000002      OFST:	set	2
1218                     ; 378 	 u16 intDelay = *EEPROM_AVS_DELAY_SECS;
1220  0001 ce4008        	ldw	x,16392
1221  0004 1f01          	ldw	(OFST-1,sp),x
1223                     ; 380 	menuDisplay = TRUE;
1225  0006 35010007      	mov	_menuDisplay,#1
1226                     ; 381 	prepareValueToDisplay(intDelay);
1228  000a cd0000        	call	_prepareValueToDisplay
1230                     ; 382 	intDelay = intDelay + 10;
1232  000d 1e01          	ldw	x,(OFST-1,sp)
1233  000f 1c000a        	addw	x,#10
1234  0012 1f01          	ldw	(OFST-1,sp),x
1236                     ; 384 	writeInternalEEPROM16bit(intDelay, EEPROM_AVS_DELAY_SECS);
1238  0014 ae4008        	ldw	x,#16392
1239  0017 89            	pushw	x
1240  0018 1e03          	ldw	x,(OFST+1,sp)
1241  001a cd0000        	call	_writeInternalEEPROM16bit
1243                     ; 386 }
1246  001d 5b04          	addw	sp,#4
1247  001f 81            	ret	
1288                     ; 390 void errorMode(void)
1288                     ; 391 {
1289                     .text:	section	.text,new
1290  0000               _errorMode:
1292  0000 5203          	subw	sp,#3
1293       00000003      OFST:	set	3
1296                     ; 395 	if (!errors)	//if no errors
1298  0002 3d00          	tnz	_errors
1299  0004 260e          	jrne	L763
1300                     ; 405 		if (UART_ENABLED) UART1_PutString("No errors", NL);
1302  0006 4b01          	push	#1
1303  0008 ae0017        	ldw	x,#L173
1304  000b cd0000        	call	_UART1_PutString
1306  000e 84            	pop	a
1307  000f               L373:
1308                     ; 407 		while(1)	resDog();		//stay here happy and wait for cycling power
1310  000f cd0000        	call	_resDog
1313  0012 20fb          	jra	L373
1314  0014               L763:
1315                     ; 410 		writeInternalEEPROM16bit(0, EEPROM_CALIBRATION_DONE);	//reset calibration flag in EEPROM
1317  0014 ae4004        	ldw	x,#16388
1318  0017 89            	pushw	x
1319  0018 5f            	clrw	x
1320  0019 cd0000        	call	_writeInternalEEPROM16bit
1322  001c 85            	popw	x
1323  001d               L104:
1324                     ; 413 			for(i=0;i<8;i++)
1326  001d 0f03          	clr	(OFST+0,sp)
1328  001f               L504:
1329                     ; 414 				if (errors & 1<<i)	//if error found then blink it
1331  001f b600          	ld	a,_errors
1332  0021 5f            	clrw	x
1333  0022 97            	ld	xl,a
1334  0023 1f01          	ldw	(OFST-2,sp),x
1336  0025 ae0001        	ldw	x,#1
1337  0028 7b03          	ld	a,(OFST+0,sp)
1338  002a 2704          	jreq	L213
1339  002c               L413:
1340  002c 58            	sllw	x
1341  002d 4a            	dec	a
1342  002e 26fc          	jrne	L413
1343  0030               L213:
1344  0030 01            	rrwa	x,a
1345  0031 1402          	and	a,(OFST-1,sp)
1346  0033 01            	rrwa	x,a
1347  0034 1401          	and	a,(OFST-2,sp)
1348  0036 01            	rrwa	x,a
1349  0037 5d            	tnzw	x
1350  0038 272e          	jreq	L314
1351                     ; 419 						UART1_PutString("ERR", NO_NL);
1353  003a 4b00          	push	#0
1354  003c ae0013        	ldw	x,#L514
1355  003f cd0000        	call	_UART1_PutString
1357  0042 84            	pop	a
1358                     ; 420 						Int2str(strNum, i+1);
1360  0043 7b03          	ld	a,(OFST+0,sp)
1361  0045 5f            	clrw	x
1362  0046 97            	ld	xl,a
1363  0047 5c            	incw	x
1364  0048 cd0000        	call	c_itolx
1366  004b be02          	ldw	x,c_lreg+2
1367  004d 89            	pushw	x
1368  004e be00          	ldw	x,c_lreg
1369  0050 89            	pushw	x
1370  0051 ae0000        	ldw	x,#_strNum
1371  0054 cd0000        	call	_Int2str
1373  0057 5b04          	addw	sp,#4
1374                     ; 421 						UART1_PutString(strNum, NL);
1376  0059 4b01          	push	#1
1377  005b ae0000        	ldw	x,#_strNum
1378  005e cd0000        	call	_UART1_PutString
1380  0061 ae07d0        	ldw	x,#2000
1381  0064 84            	pop	a
1382                     ; 424 					waitms(2000);		//wait for 1.5sec between errors
1384  0065 cd0000        	call	_waitms
1386  0068               L314:
1387                     ; 413 			for(i=0;i<8;i++)
1389  0068 0c03          	inc	(OFST+0,sp)
1393  006a 7b03          	ld	a,(OFST+0,sp)
1394  006c a108          	cp	a,#8
1395  006e 25af          	jrult	L504
1397  0070 20ab          	jra	L104
1421                     ; 429 _Bool isFirst30min(void)
1421                     ; 430 {
1422                     .text:	section	.text,new
1423  0000               _isFirst30min:
1427                     ; 431 	return (*EEPROM_FIRST_30_MIN_ADD == 0x00FE);
1429  0000 ce4002        	ldw	x,16386
1430  0003 a300fe        	cpw	x,#254
1431  0006 2603          	jrne	L033
1432  0008 a601          	ld	a,#1
1434  000a 81            	ret	
1435  000b               L033:
1436  000b 4f            	clr	a
1439  000c 81            	ret	
1463                     ; 435 _Bool isCalibrationDone(void)
1463                     ; 436 {
1464                     .text:	section	.text,new
1465  0000               _isCalibrationDone:
1469                     ; 437 	return (*EEPROM_CALIBRATION_DONE == 0x00FE);
1471  0000 ce4004        	ldw	x,16388
1472  0003 a300fe        	cpw	x,#254
1473  0006 2603          	jrne	L633
1474  0008 a601          	ld	a,#1
1476  000a 81            	ret	
1477  000b               L633:
1478  000b 4f            	clr	a
1481  000c 81            	ret	
1515                     ; 442 void setClock(void)
1515                     ; 443 {
1516                     .text:	section	.text,new
1517  0000               _setClock:
1519  0000 89            	pushw	x
1520       00000002      OFST:	set	2
1523                     ; 444 	u16 counter = 12590;
1525  0001 ae312e        	ldw	x,#12590
1526  0004 1f01          	ldw	(OFST-1,sp),x
1528                     ; 445 	CLK->CKDIVR = 0;	// set prescaler to 0
1530  0006 725f50c6      	clr	20678
1531                     ; 447 	CLK->SWCR |= CLK_SWCR_SWEN;
1533  000a 721250c5      	bset	20677,#1
1534                     ; 449 	CLK->SWCR &= (u8)(~CLK_SWCR_SWIEN); // disable int
1536  000e 721550c5      	bres	20677,#2
1537                     ; 451 	CLK->SWR = 0xE1;	// 0xB4 = HSE
1539  0012 35e150c4      	mov	20676,#225
1541  0016 2003          	jra	L164
1542  0018               L554:
1543                     ; 456 	while ((CLK->SWCR & CLK_SWCR_SWBSY) && counter) counter--;
1545  0018 5a            	decw	x
1546  0019 1f01          	ldw	(OFST-1,sp),x
1548  001b               L164:
1551  001b 720150c504    	btjf	20677,#0,L564
1553  0020 1e01          	ldw	x,(OFST-1,sp)
1554  0022 26f4          	jrne	L554
1555  0024               L564:
1556                     ; 457 }
1559  0024 85            	popw	x
1560  0025 81            	ret	
1586                     ; 461 void primeIntDelay(void)
1586                     ; 462 {
1587                     .text:	section	.text,new
1588  0000               _primeIntDelay:
1592                     ; 463 	GPIOsetOutputPushPull(INT_DELAY_PORT);
1594  0000 4b40          	push	#64
1595  0002 ae500f        	ldw	x,#20495
1596  0005 cd0000        	call	_GPIOsetOutputPushPull
1598  0008 84            	pop	a
1599                     ; 464 	GPIOsetLow(INT_DELAY_PORT);
1601  0009 4b40          	push	#64
1602  000b ae500f        	ldw	x,#20495
1603  000e cd0000        	call	_GPIOsetLow
1605  0011 72100000      	bset	_intDelayPrimed
1606  0015 84            	pop	a
1607                     ; 465 	intDelayPrimed = TRUE;
1609                     ; 466 }
1612  0016 81            	ret	
1637                     ; 470 void releaseIntDelay(void)
1637                     ; 471 {
1638                     .text:	section	.text,new
1639  0000               _releaseIntDelay:
1643                     ; 472 	GPIOsetInputFloatNoInt(INT_DELAY_PORT);
1645  0000 4b40          	push	#64
1646  0002 ae500f        	ldw	x,#20495
1647  0005 cd0000        	call	_GPIOsetInputFloatNoInt
1649  0008 72110000      	bres	_intDelayPrimed
1650  000c 84            	pop	a
1651                     ; 473 	intDelayPrimed = FALSE;
1653                     ; 474 }
1656  000d 81            	ret	
1816                     	xdef	_ledArray
1817                     	xdef	_segArray
1818                     	xdef	_main
1819                     	xdef	_checkSwiches
1820                     	xdef	_updateDelay
1821                     	xdef	_prepareValueToDisplay
1822                     	xdef	_errorMode
1823                     	xdef	_setClock
1824                     	xdef	_menuDisplay
1825                     	xdef	_dimmingSet
1826                     	switch	.ubsct
1827  0000               _localCounter:
1828  0000 0000          	ds.b	2
1829                     	xdef	_localCounter
1830                     	xdef	_ledCount
1831                     	xref.b	_dimmingFlag
1832                     	xbit	_displayUpdate
1833  0002               _i:
1834  0002 0000          	ds.b	2
1835                     	xdef	_i
1836                     	switch	.bit
1837  0002               _isAVS13:
1838  0002 00            	ds.b	1
1839                     	xdef	_isAVS13
1840                     	xref.b	_strNum
1841                     	xref	_TransmitData
1842                     	xref	_Int2str
1843                     	xref	_Hex2str
1844                     	xref	_UART1_PutString
1845                     	xref	_UART1_Config
1846                     	xref	_waitms
1847                     	xref	_resDog
1848                     	xref	_enableIWatchDog
1849                     	xref	_timer4Init
1850                     	xref	_checkForTestProcedure
1851                     	xref	_testProcedure
1852                     	xbit	_secondTicker
1853                     	xbit	_minuteTicker
1854                     	xref.b	_relay1
1855                     	xref	_relayFunction
1856                     	xref	_processRelay
1857                     	xref	_initRelays
1858                     	switch	.ubsct
1859  0004               _isSwitchOn:
1860  0004 00            	ds.b	1
1861                     	xdef	_isSwitchOn
1862                     	xdef	_errors
1863                     	xdef	_intDelayPrimed
1864                     	xdef	_isCalibrationDone
1865                     	xdef	_isFirst30min
1866                     	xdef	_releaseIntDelay
1867                     	xdef	_primeIntDelay
1868                     	xref	_initIntPriorities
1869                     	xref.b	_outputVoltage
1870                     	xref	_getCorrectionFactor
1871                     	xref	_sampleVoltage
1872                     	xref	_measureACPeriod
1873                     	xref	_GPIOportValue
1874                     	xref	_isButtonPressed3
1875                     	xref	_isButtonPressed2
1876                     	xref	_isButtonPressed
1877                     	xref	_GPIOsetLow
1878                     	xref	_GPIOtoggle
1879                     	xref	_GPIOsetHigh
1880                     	xref	_GPIOsetOutputPushPull
1881                     	xref	_GPIOsetInputFloatNoInt
1882                     	xref	_GPIOinit
1883                     	xref	_writeInternalEEPROM16bit
1884                     	xref.b	_IntDelaySecs
1885                     	xref	_updateIntDelay
1886                     	xref	_updateAVSState
1887                     	xref	_operateRelay
1888                     	xref	_adcInit
1889                     	xdef	_refreshDisplay
1890                     	switch	.const
1891  0013               L514:
1892  0013 45525200      	dc.b	"ERR",0
1893  0017               L173:
1894  0017 4e6f20657272  	dc.b	"No errors",0
1895  0021               L151:
1896  0021 53573200      	dc.b	"SW2",0
1897  0025               L531:
1898  0025 53573300      	dc.b	"SW3",0
1899  0029               L54:
1900  0029 4672657109    	dc.b	"Freq",9
1901  002e 566f6c746167  	dc.b	"Voltage",9
1902  0036 52656c436f6d  	dc.b	"RelComb",9
1903  003e 52656c537461  	dc.b	"RelState",0
1904  0047               L34:
1905  0047 436f72724661  	dc.b	"CorrFact = ",9,0
1906  0054               L14:
1907  0054 546573742045  	dc.b	"Test End",0
1908  005d               L73:
1909  005d 546573742053  	dc.b	"Test Start",0
1910  0068               L33:
1911  0068 41565331335f  	dc.b	"AVS13_15V02",0
1912                     	xref.b	c_lreg
1932                     	xref	c_itolx
1933                     	xref	c_uitolx
1934                     	end
