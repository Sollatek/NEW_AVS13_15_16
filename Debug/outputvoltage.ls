   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     	bsct
  19  0000               _outputVoltage:
  20  0000 0000          	dc.w	0
  21  0002               _period:
  22  0002 0000          	dc.w	0
  23  0004               _frequency:
  24  0004 0000          	dc.w	0
  25                     .bit:	section	.data,bit
  26  0000               _acVmeasurementOK:
  27  0000 00            	dc.b	0
  28                     	bsct
  29  0006               _randomSource:
  30  0006 00            	dc.b	0
  31  0007               _testVal:
  32  0007 0000          	dc.w	0
  33                     .const:	section	.text
  34  0000               _correctionFactor:
  35  0000 4000          	dc.w	16384
  36                     	bsct
  37  0009               L3_reading1:
  38  0009 0000          	dc.w	0
  39  000b               L5_reading2:
  40  000b 0000          	dc.w	0
  41  000d               L7_reading3:
  42  000d 0000          	dc.w	0
  43  000f               L11_reading4:
  44  000f 0000          	dc.w	0
  45  0011               L31_currentReading:
  46  0011 00            	dc.b	0
 139                     ; 58 void measureACPeriod(void)
 139                     ; 59 {
 141                     .text:	section	.text,new
 142  0000               _measureACPeriod:
 144  0000 520e          	subw	sp,#14
 145       0000000e      OFST:	set	14
 148                     ; 65 	u16 timerReading = 0;
 150                     ; 72 	resetTimer2((u16)((u32)MIN_FREQ_PERIOD_US));		//initialize to longest acceptable period (in us)
 152  0002 ae6f9b        	ldw	x,#28571
 153  0005 cd0000        	call	_resetTimer2
 155                     ; 73 	waitNeg();
 157  0008 cd0000        	call	_waitNeg
 159                     ; 74 	startTimer2();
 161  000b cd0000        	call	_startTimer2
 163                     ; 75 	waitNeg();
 165  000e cd0000        	call	_waitNeg
 167                     ; 76 	stopTimer2();
 169  0011 cd0000        	call	_stopTimer2
 171                     ; 77 	timerReading = getTimer2uSec();
 173  0014 cd0000        	call	_getTimer2uSec
 175  0017 1f0d          	ldw	(OFST-1,sp),x
 177                     ; 84 	if (!currentReading)
 179  0019 b611          	ld	a,L31_currentReading
 180  001b 2604          	jrne	L56
 181                     ; 86 		reading1 = timerReading;
 183  001d bf09          	ldw	L3_reading1,x
 184                     ; 87 		currentReading++;
 186  001f 200e          	jp	LC001
 187  0021               L56:
 188                     ; 89 	else if (currentReading == 1)
 190  0021 a101          	cp	a,#1
 191  0023 2604          	jrne	L17
 192                     ; 91 		reading2 = timerReading;
 194  0025 bf0b          	ldw	L5_reading2,x
 195                     ; 92 		currentReading++;
 197  0027 2006          	jp	LC001
 198  0029               L17:
 199                     ; 94 	else if (currentReading == 2)
 201  0029 a102          	cp	a,#2
 202  002b 2606          	jrne	L57
 203                     ; 96 		reading3 = timerReading;
 205  002d bf0d          	ldw	L7_reading3,x
 206                     ; 97 		currentReading++;
 208  002f               LC001:
 211  002f 3c11          	inc	L31_currentReading
 213  0031 2008          	jra	L76
 214  0033               L57:
 215                     ; 101 		reading4 = timerReading;
 217  0033 bf0f          	ldw	L11_reading4,x
 218                     ; 102 		currentReading = 0;
 220  0035 3f11          	clr	L31_currentReading
 221                     ; 103 		acVmeasurementOK = TRUE;
 223  0037 72100000      	bset	_acVmeasurementOK
 224  003b               L76:
 225                     ; 106 	period = ((u16)(((u32)reading1+(u32)reading2+(u32)reading3+(u32)reading4)>>2));		//averaging 4 period measurements
 227  003b be0f          	ldw	x,L11_reading4
 228  003d cd0000        	call	c_uitolx
 230  0040 96            	ldw	x,sp
 231  0041 1c0009        	addw	x,#OFST-5
 232  0044 cd0000        	call	c_rtol
 235  0047 be0d          	ldw	x,L7_reading3
 236  0049 cd0000        	call	c_uitolx
 238  004c 96            	ldw	x,sp
 239  004d 1c0005        	addw	x,#OFST-9
 240  0050 cd0000        	call	c_rtol
 243  0053 be0b          	ldw	x,L5_reading2
 244  0055 cd0000        	call	c_uitolx
 246  0058 96            	ldw	x,sp
 247  0059 5c            	incw	x
 248  005a cd0000        	call	c_rtol
 251  005d be09          	ldw	x,L3_reading1
 252  005f cd0000        	call	c_uitolx
 254  0062 96            	ldw	x,sp
 255  0063 5c            	incw	x
 256  0064 cd0000        	call	c_ladd
 258  0067 96            	ldw	x,sp
 259  0068 1c0005        	addw	x,#OFST-9
 260  006b cd0000        	call	c_ladd
 262  006e 96            	ldw	x,sp
 263  006f 1c0009        	addw	x,#OFST-5
 264  0072 cd0000        	call	c_ladd
 266  0075 a602          	ld	a,#2
 267  0077 cd0000        	call	c_lursh
 269  007a be02          	ldw	x,c_lreg+2
 270  007c bf02          	ldw	_period,x
 271                     ; 107 	frequency = (u16)(((u32)10000000/period));	// frequency x10
 273  007e cd0000        	call	c_uitolx
 275  0081 96            	ldw	x,sp
 276  0082 1c0009        	addw	x,#OFST-5
 277  0085 cd0000        	call	c_rtol
 280  0088 ae9680        	ldw	x,#38528
 281  008b bf02          	ldw	c_lreg+2,x
 282  008d ae0098        	ldw	x,#152
 283  0090 bf00          	ldw	c_lreg,x
 284  0092 96            	ldw	x,sp
 285  0093 1c0009        	addw	x,#OFST-5
 286  0096 cd0000        	call	c_ludv
 288  0099 be02          	ldw	x,c_lreg+2
 289  009b bf04          	ldw	_frequency,x
 290                     ; 108 	if ((frequency < (MIN_FREQUENCY * 10)) || (frequency > (MAX_FREQUENCY * 10)))			//frequency error based on average value
 292  009d a3015e        	cpw	x,#350
 293  00a0 2505          	jrult	L301
 295  00a2 a3028b        	cpw	x,#651
 296  00a5 2504          	jrult	L101
 297  00a7               L301:
 298                     ; 109 		acVmeasurementOK = FALSE;
 300  00a7 72110000      	bres	_acVmeasurementOK
 301  00ab               L101:
 302                     ; 111 }	// measureACPeriod
 305  00ab 5b0e          	addw	sp,#14
 306  00ad 81            	ret	
 342                     ; 166 void waitNeg(void)
 342                     ; 167 {
 343                     .text:	section	.text,new
 344  0000               _waitNeg:
 346  0000 88            	push	a
 347       00000001      OFST:	set	1
 350                     ; 168 	u8 count = 0;
 352  0001 0f01          	clr	(OFST+0,sp)
 354                     ; 169 	testVal = getVoltageADC();
 356  0003 cd0000        	call	_getVoltageADC
 358  0006 bf07          	ldw	_testVal,x
 360  0008 200e          	jra	L721
 361  000a               L321:
 362                     ; 173 		if (getVoltageADC() >= HALF_CYCLE_NEGATIVE_THRESHOLD) count++;
 364  000a cd0000        	call	_getVoltageADC
 366  000d a30008        	cpw	x,#8
 367  0010 2504          	jrult	L331
 370  0012 0c01          	inc	(OFST+0,sp)
 373  0014 2002          	jra	L721
 374  0016               L331:
 375                     ; 174 		else count = 0;
 377  0016 0f01          	clr	(OFST+0,sp)
 379  0018               L721:
 380                     ; 171 	while (count < 5)
 382  0018 7b01          	ld	a,(OFST+0,sp)
 383  001a a105          	cp	a,#5
 384  001c 25ec          	jrult	L321
 385                     ; 177 	count = 0;
 387  001e 0f01          	clr	(OFST+0,sp)
 389  0020               L731:
 390                     ; 181 		if (getVoltageADC() < HALF_CYCLE_NEGATIVE_THRESHOLD) count++;
 392  0020 cd0000        	call	_getVoltageADC
 394  0023 a30008        	cpw	x,#8
 395  0026 2404          	jruge	L541
 398  0028 0c01          	inc	(OFST+0,sp)
 401  002a 2002          	jra	L741
 402  002c               L541:
 403                     ; 182 		else count = 0;
 405  002c 0f01          	clr	(OFST+0,sp)
 407  002e               L741:
 408                     ; 179 	while (count < 5)
 410  002e 7b01          	ld	a,(OFST+0,sp)
 411  0030 a105          	cp	a,#5
 412  0032 25ec          	jrult	L731
 413                     ; 186 }
 416  0034 84            	pop	a
 417  0035 81            	ret	
 500                     	switch	.const
 501  0002               L25:
 502  0002 01000000      	dc.l	16777216
 503                     ; 198 void sampleVoltage(_Bool calibration)
 503                     ; 199 {
 504                     .text:	section	.text,new
 505  0000               _sampleVoltage:
 507  0000 88            	push	a
 508  0001 520c          	subw	sp,#12
 509       0000000c      OFST:	set	12
 512                     ; 200 	u8 nSamples = (NUM_SAMPLES_PER_CYCLE / 2);	//number of samples to be taken per half-cycle
 514  0003 a620          	ld	a,#32
 515  0005 6b04          	ld	(OFST-8,sp),a
 517                     ; 201 	vu32 samplesSum = 0;
 519  0007 5f            	clrw	x
 520  0008 1f07          	ldw	(OFST-5,sp),x
 521  000a 1f05          	ldw	(OFST-7,sp),x
 523                     ; 202 	vu32 square = 0;
 525  000c 1f0b          	ldw	(OFST-1,sp),x
 526  000e 1f09          	ldw	(OFST-3,sp),x
 528                     ; 203 	_Bool ovf = FALSE;
 530  0010 0f03          	clr	(OFST-9,sp)
 532                     ; 206 	stopTimer2();
 534  0012 cd0000        	call	_stopTimer2
 536                     ; 207 	resetTimer2(period / NUM_SAMPLES_PER_CYCLE);	//sampling period
 538  0015 be02          	ldw	x,_period
 539  0017 a606          	ld	a,#6
 540  0019               L04:
 541  0019 54            	srlw	x
 542  001a 4a            	dec	a
 543  001b 26fc          	jrne	L04
 544  001d cd0000        	call	_resetTimer2
 546                     ; 209 	holdus(period / 2 - period / NUM_SAMPLES_PER_CYCLE / 2);	//wait for positive half cycle minus half sampling cycle to achieve symmetrical sampling
 548  0020 be02          	ldw	x,_period
 549  0022 4f            	clr	a
 550  0023 01            	rrwa	x,a
 551  0024 48            	sll	a
 552  0025 59            	rlcw	x
 553  0026 1f01          	ldw	(OFST-11,sp),x
 555  0028 be02          	ldw	x,_period
 556  002a 54            	srlw	x
 557  002b 72f001        	subw	x,(OFST-11,sp)
 558  002e cd0000        	call	_holdus
 561  0031 2035          	jra	L112
 562  0033               L702:
 563                     ; 212 		startTimer2();
 565  0033 cd0000        	call	_startTimer2
 568  0036               L712:
 569                     ; 214 		while (!timer2OverflowFlag) ;
 571  0036 72010000fb    	btjf	_timer2OverflowFlag,L712
 572                     ; 216 		square = getVoltageADC();
 574  003b cd0000        	call	_getVoltageADC
 576  003e cd0000        	call	c_uitolx
 578  0041 96            	ldw	x,sp
 579  0042 1c0009        	addw	x,#OFST-3
 580  0045 cd0000        	call	c_rtol
 583                     ; 217 		timer2OverflowFlag = FALSE;
 585  0048 72110000      	bres	_timer2OverflowFlag
 586                     ; 219 		square *= square;
 588  004c 96            	ldw	x,sp
 589  004d 1c0009        	addw	x,#OFST-3
 590  0050 cd0000        	call	c_ltor
 592  0053 96            	ldw	x,sp
 593  0054 1c0009        	addw	x,#OFST-3
 594  0057 cd0000        	call	c_lgmul
 597                     ; 220 		samplesSum += square;
 599  005a 96            	ldw	x,sp
 600  005b 1c0009        	addw	x,#OFST-3
 601  005e cd0000        	call	c_ltor
 603  0061 96            	ldw	x,sp
 604  0062 1c0005        	addw	x,#OFST-7
 605  0065 cd0000        	call	c_lgadd
 608  0068               L112:
 609                     ; 210 	while (nSamples--)
 611  0068 7b04          	ld	a,(OFST-8,sp)
 612  006a 0a04          	dec	(OFST-8,sp)
 614  006c 4d            	tnz	a
 615  006d 26c4          	jrne	L702
 616                     ; 222 	stopTimer2();
 618  006f cd0000        	call	_stopTimer2
 620                     ; 224 	if (samplesSum > (u32)0xFFFFFF) ovf = TRUE;
 622  0072 96            	ldw	x,sp
 623  0073 1c0005        	addw	x,#OFST-7
 624  0076 cd0000        	call	c_ltor
 626  0079 ae0002        	ldw	x,#L25
 627  007c cd0000        	call	c_lcmp
 629  007f 2504          	jrult	L322
 632  0081 a601          	ld	a,#1
 633  0083 6b03          	ld	(OFST-9,sp),a
 635  0085               L322:
 636                     ; 225 	randomSource = samplesSum;
 638  0085 7b08          	ld	a,(OFST-4,sp)
 639  0087 b706          	ld	_randomSource,a
 640                     ; 227 	samplesSum /= (NUM_SAMPLES_PER_CYCLE / 2);	//average of square values
 642  0089 96            	ldw	x,sp
 643  008a 1c0005        	addw	x,#OFST-7
 644  008d a605          	ld	a,#5
 645  008f cd0000        	call	c_lgursh
 648                     ; 230 	if (calibration)
 650  0092 7b0d          	ld	a,(OFST+1,sp)
 651  0094 a501          	bcp	a,#1
 652  0096 2726          	jreq	L522
 653                     ; 232 		samplesSum /= DIV_NO; // dividing factor used to achieve 16-bit number (this is the way we store voltage value)
 655  0098 96            	ldw	x,sp
 656  0099 1c0005        	addw	x,#OFST-7
 657  009c a603          	ld	a,#3
 658  009e cd0000        	call	c_lgursh
 661                     ; 233 		writeInternalEEPROM16bit(((CAL_REF_VOLT * (u32)512) / samplesSum), correctionFactor);	//correction factor is stored as (V_ideal/V_measured)*512
 663  00a1 ae4000        	ldw	x,#16384
 664  00a4 89            	pushw	x
 665  00a5 ae8800        	ldw	x,#34816
 666  00a8 bf02          	ldw	c_lreg+2,x
 667  00aa ae0124        	ldw	x,#292
 668  00ad bf00          	ldw	c_lreg,x
 669  00af 96            	ldw	x,sp
 670  00b0 1c0007        	addw	x,#OFST-5
 671  00b3 cd0000        	call	c_ludv
 673  00b6 be02          	ldw	x,c_lreg+2
 674  00b8 cd0000        	call	_writeInternalEEPROM16bit
 676  00bb 85            	popw	x
 677                     ; 234 		return;
 679  00bc 2028          	jra	L132
 680  00be               L522:
 681                     ; 237 	samplesSum *= DUMMY_CO_FAC;//0x13A;//*correctionFactor;	//2024	//correction factor applied (value stored in EEPROM is correction factor (<1) multiplied by 512)
 683  00be ae01a0        	ldw	x,#416
 684  00c1 bf02          	ldw	c_lreg+2,x
 685  00c3 5f            	clrw	x
 686  00c4 bf00          	ldw	c_lreg,x
 687  00c6 96            	ldw	x,sp
 688  00c7 1c0005        	addw	x,#OFST-7
 689  00ca cd0000        	call	c_lgmul
 692                     ; 242 	if (ovf)
 694  00cd 7b03          	ld	a,(OFST-9,sp)
 695  00cf 2705          	jreq	L722
 696                     ; 243 		outputVoltage = 0xFFFF;
 698  00d1 aeffff        	ldw	x,#65535
 700  00d4 200e          	jp	LC002
 701  00d6               L722:
 702                     ; 246 		outputVoltage = (u16)(samplesSum / (u32)(DIV_NO * 512));			//divided by 4096 (=512*8). 512 because of calibration factor, 8 to reduce number of bits to 16
 704  00d6 96            	ldw	x,sp
 705  00d7 1c0005        	addw	x,#OFST-7
 706  00da cd0000        	call	c_ltor
 708  00dd a60c          	ld	a,#12
 709  00df cd0000        	call	c_lursh
 711  00e2 be02          	ldw	x,c_lreg+2
 712  00e4               LC002:
 713  00e4 bf00          	ldw	_outputVoltage,x
 714  00e6               L132:
 715                     ; 247 }	// sampleVoltage
 718  00e6 5b0d          	addw	sp,#13
 719  00e8 81            	ret	
 743                     ; 254 u8 generateRandomDelay(void)
 743                     ; 255 {
 744                     .text:	section	.text,new
 745  0000               _generateRandomDelay:
 749                     ; 271 	if (*EEPROM_AVS_TYPE == AVS13_FLAG)
 751  0000 ce4006        	ldw	x,16390
 752  0003 a3a5a5        	cpw	x,#42405
 753  0006 2603          	jrne	L342
 754                     ; 272 		return (STANDARD_WAIT_DELAY_SECS_AVS13);
 756  0008 a60f          	ld	a,#15
 759  000a 81            	ret	
 760  000b               L342:
 761                     ; 274 		return (STANDARD_WAIT_DELAY_SECS_AVS15);
 763  000b a61e          	ld	a,#30
 766  000d 81            	ret	
 790                     ; 279 u16 getCorrectionFactor(void)
 790                     ; 280 {
 791                     .text:	section	.text,new
 792  0000               _getCorrectionFactor:
 796                     ; 281 	return (DUMMY_CO_FAC);//*correctionFactor;//2024//13A
 798  0000 ae01a0        	ldw	x,#416
 801  0003 81            	ret	
 827                     ; 286 _Bool isCorrectionFactorBad(void)
 827                     ; 287 {
 828                     .text:	section	.text,new
 829  0000               _isCorrectionFactorBad:
 833                     ; 288 	return ((*correctionFactor > CORRECTION_FACTOR_HIGH) || (*correctionFactor < CORRECTION_FACTOR_LOW));
 835  0000 ce4000        	ldw	x,16384
 836  0003 a30201        	cpw	x,#513
 837  0006 2405          	jruge	L07
 838  0008 a30174        	cpw	x,#372
 839  000b 2403          	jruge	L66
 840  000d               L07:
 841  000d a601          	ld	a,#1
 843  000f 81            	ret	
 844  0010               L66:
 845  0010 4f            	clr	a
 848  0011 81            	ret	
 875                     ; 293 _Bool isVoltageONok(void)
 875                     ; 294 {
 876                     .text:	section	.text,new
 877  0000               _isVoltageONok:
 881                     ; 295 	waitNeg();
 883  0000 cd0000        	call	_waitNeg
 885                     ; 296 	sampleVoltage(0);
 887  0003 4f            	clr	a
 888  0004 cd0000        	call	_sampleVoltage
 890                     ; 298 	if ((outputVoltage < (CAL_REF_VOLT-0xE53)) || (outputVoltage > (CAL_REF_VOLT+0xF13))) return FALSE;
 892  0007 be00          	ldw	x,_outputVoltage
 893  0009 a383f1        	cpw	x,#33777
 894  000c 2507          	jrult	L103
 896  000e be00          	ldw	x,_outputVoltage
 897  0010 a3a158        	cpw	x,#41304
 898  0013 2502          	jrult	L772
 899  0015               L103:
 902  0015 4f            	clr	a
 905  0016 81            	ret	
 906  0017               L772:
 907                     ; 299 	return TRUE;
 909  0017 a601          	ld	a,#1
 912  0019 81            	ret	
 962                     ; 305 _Bool isVoltageOFF(void)
 962                     ; 306 {
 963                     .text:	section	.text,new
 964  0000               _isVoltageOFF:
 966  0000 5203          	subw	sp,#3
 967       00000003      OFST:	set	3
 970                     ; 307 	u8 nSamples = 8;
 972  0002 a608          	ld	a,#8
 973  0004 6b01          	ld	(OFST-2,sp),a
 975                     ; 308 	u16 sum = 0;
 977  0006 5f            	clrw	x
 978  0007 1f02          	ldw	(OFST-1,sp),x
 980                     ; 309 	stopTimer2();
 982  0009 cd0000        	call	_stopTimer2
 984                     ; 310 	resetTimer2(period/8);	// 4 samples taken in one period
 986  000c be02          	ldw	x,_period
 987  000e 54            	srlw	x
 988  000f 54            	srlw	x
 989  0010 54            	srlw	x
 990  0011 cd0000        	call	_resetTimer2
 993  0014 2014          	jra	L723
 994  0016               L523:
 995                     ; 314 		startTimer2();
 997  0016 cd0000        	call	_startTimer2
1000  0019               L533:
1001                     ; 316 		while (!timer2OverflowFlag) ;
1003  0019 72010000fb    	btjf	_timer2OverflowFlag,L533
1004                     ; 317 		timer2OverflowFlag = FALSE;
1006  001e 72110000      	bres	_timer2OverflowFlag
1007                     ; 319 		sum += getVoltageADC();
1009  0022 cd0000        	call	_getVoltageADC
1011  0025 72fb02        	addw	x,(OFST-1,sp)
1012  0028 1f02          	ldw	(OFST-1,sp),x
1014  002a               L723:
1015                     ; 312 	while (nSamples--)
1017  002a 7b01          	ld	a,(OFST-2,sp)
1018  002c 0a01          	dec	(OFST-2,sp)
1020  002e 4d            	tnz	a
1021  002f 26e5          	jrne	L523
1022                     ; 321 	stopTimer2();
1024  0031 cd0000        	call	_stopTimer2
1026                     ; 322 	if (sum > 0xBB) return FALSE;		//sum of 8 samples is never more than BB (calculated for 30VAC for all start phases)
1028  0034 1e02          	ldw	x,(OFST-1,sp)
1029  0036 a300bc        	cpw	x,#188
1030  0039 2503          	jrult	L143
1033  003b 4f            	clr	a
1035  003c 2002          	jra	L611
1036  003e               L143:
1037                     ; 323 	return TRUE;
1039  003e a601          	ld	a,#1
1041  0040               L611:
1043  0040 5b03          	addw	sp,#3
1044  0042 81            	ret	
1124                     	xdef	_correctionFactor
1125                     	xdef	_testVal
1126                     	xdef	_randomSource
1127                     	xbit	_timer2OverflowFlag
1128                     	xref	_holdus
1129                     	xref	_getTimer2uSec
1130                     	xref	_stopTimer2
1131                     	xref	_resetTimer2
1132                     	xref	_startTimer2
1133                     	xdef	_generateRandomDelay
1134                     	xdef	_acVmeasurementOK
1135                     	xdef	_frequency
1136                     	xdef	_period
1137                     	xdef	_outputVoltage
1138                     	xdef	_getCorrectionFactor
1139                     	xdef	_isVoltageOFF
1140                     	xdef	_isVoltageONok
1141                     	xdef	_isCorrectionFactorBad
1142                     	xdef	_waitNeg
1143                     	xdef	_sampleVoltage
1144                     	xdef	_measureACPeriod
1145                     	xref	_writeInternalEEPROM16bit
1146                     	xref	_getVoltageADC
1147                     	xref.b	c_lreg
1148                     	xref.b	c_x
1167                     	xref	c_lgursh
1168                     	xref	c_lcmp
1169                     	xref	c_lgadd
1170                     	xref	c_lgmul
1171                     	xref	c_ltor
1172                     	xref	c_ludv
1173                     	xref	c_lursh
1174                     	xref	c_ladd
1175                     	xref	c_rtol
1176                     	xref	c_uitolx
1177                     	end
