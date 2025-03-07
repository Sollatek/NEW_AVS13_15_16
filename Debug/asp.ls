   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     	bsct
  19  0000               _tapChangeBlindTime:
  20  0000 0000          	dc.w	0
  21  0002               _relayCombination:
  22  0002 00            	dc.b	0
  23  0003               _selectedTapUpVoltage:
  24  0003 5965          	dc.w	22885
  25  0005               _selectedTapDownVoltage:
  26  0005 83da          	dc.w	-31782
  27                     .bit:	section	.data,bit
  28  0000               _resetTapChangeBlindTime:
  29  0000 00            	dc.b	0
  30                     	bsct
  31  0007               _SensitivityArrayPosition:
  32  0007 00            	dc.b	0
  33  0008               _sensitivity:
  34  0008 01            	dc.b	1
  35                     	switch	.bit
  36  0001               _relay1Set:
  37  0001 00            	dc.b	0
  38  0002               _relay2Set:
  39  0002 00            	dc.b	0
  40  0003               _relay3Set:
  41  0003 00            	dc.b	0
  42                     	bsct
  43  0009               _desiredRelayComb:
  44  0009 05            	dc.b	5
  85                     ; 144 void initSensitivity(void)
  85                     ; 145 {
  87                     .text:	section	.text,new
  88  0000               _initSensitivity:
  90  0000 88            	push	a
  91       00000001      OFST:	set	1
  94                     ; 146 	u8 count = 0;
  96  0001 4f            	clr	a
  97  0002 6b01          	ld	(OFST+0,sp),a
  99  0004               L72:
 100                     ; 150 		SensitivityArray[count] = 0xFF;
 102  0004 5f            	clrw	x
 103  0005 97            	ld	xl,a
 104  0006 a6ff          	ld	a,#255
 105  0008 e700          	ld	(_SensitivityArray,x),a
 106                     ; 154 		count++;
 108  000a 0c01          	inc	(OFST+0,sp)
 110                     ; 147 	while (count < DECREASE_SENSITIVITY_THRESHOLD+1)
 112  000c 7b01          	ld	a,(OFST+0,sp)
 113  000e a107          	cp	a,#7
 114  0010 25f2          	jrult	L72
 115                     ; 156 }
 118  0012 84            	pop	a
 119  0013 81            	ret	
 122                     	switch	.bit
 123  0004               L53_firstEntry:
 124  0004 01            	dc.b	1
 125  0005               L73_oldLow:
 126  0005 00            	dc.b	0
 127  0006               L14_oldHigh:
 128  0006 00            	dc.b	0
 129  0007               L34_newLow:
 130  0007 00            	dc.b	0
 131  0008               L54_newHigh:
 132  0008 00            	dc.b	0
 223                     ; 163 void updateSensitivity(void)
 223                     ; 164 {
 224                     .text:	section	.text,new
 225  0000               _updateSensitivity:
 227  0000 88            	push	a
 228       00000001      OFST:	set	1
 231                     ; 174 	if (outputVoltage < selectedTapUpVoltage)
 233  0001 be00          	ldw	x,_outputVoltage
 234  0003 b303          	cpw	x,_selectedTapUpVoltage
 235  0005 2406          	jruge	L121
 236                     ; 175 		newLow = TRUE;
 238  0007 72100007      	bset	L34_newLow
 240  000b 2012          	jra	L321
 241  000d               L121:
 242                     ; 176 	else if (outputVoltage > selectedTapDownVoltage)
 244  000d b305          	cpw	x,_selectedTapDownVoltage
 245  000f 2306          	jrule	L521
 246                     ; 177 		newHigh = TRUE;
 248  0011 72100008      	bset	L54_newHigh
 250  0015 2008          	jra	L321
 251  0017               L521:
 252                     ; 180 		newLow = FALSE;
 254  0017 72110007      	bres	L34_newLow
 255                     ; 181 		newHigh = FALSE;
 257  001b 72110008      	bres	L54_newHigh
 258  001f               L321:
 259                     ; 186 	if (((newLow  && !oldLow) || (newHigh && !oldHigh)) && !firstEntry)
 261  001f 7201000705    	btjf	L34_newLow,L531
 263  0024 720100050a    	btjf	L73_oldLow,L331
 264  0029               L531:
 266  0029 7201000817    	btjf	L54_newHigh,L131
 268  002e 7200000612    	btjt	L14_oldHigh,L131
 269  0033               L331:
 271  0033 720000040d    	btjt	L53_firstEntry,L131
 272                     ; 188 		SensitivityArrayPosition = addEventToSensitivityArray(SensitivityArray, SensitivityArrayPosition);
 274  0038 3b0007        	push	_SensitivityArrayPosition
 275  003b ae0000        	ldw	x,#_SensitivityArray
 276  003e cd0000        	call	_addEventToSensitivityArray
 278  0041 5b01          	addw	sp,#1
 279  0043 b707          	ld	_SensitivityArrayPosition,a
 280  0045               L131:
 281                     ; 192 	tapChangeCounter = getCounterValue(SensitivityArray);
 283  0045 ae0000        	ldw	x,#_SensitivityArray
 284  0048 cd0000        	call	_getCounterValue
 286  004b 6b01          	ld	(OFST+0,sp),a
 288                     ; 195 	switch (sensitivity)
 290  004d b608          	ld	a,_sensitivity
 292                     ; 218 			break;
 293  004f 4a            	dec	a
 294  0050 2703          	jreq	L74
 295  0052 4a            	dec	a
 296  0053 2710          	jreq	L15
 297  0055               L74:
 298                     ; 197 		default:
 298                     ; 198 		case 1:	//high
 298                     ; 199 			sensitivity = 1;		//paranoia
 300  0055 35010008      	mov	_sensitivity,#1
 301                     ; 201 			if (tapChangeCounter > DECREASE_SENSITIVITY_THRESHOLD)
 303  0059 7b01          	ld	a,(OFST+0,sp)
 304  005b a107          	cp	a,#7
 305  005d 2521          	jrult	L141
 306                     ; 203 				sensitivity = 2;
 308  005f 35020008      	mov	_sensitivity,#2
 309                     ; 204 				initSensitivity();		//reset sensitivity array to start counting new level
 311                     ; 205 				SensitivityArrayPosition = 0;
 312  0063 2016          	jp	LC001
 313  0065               L15:
 314                     ; 209 		case 2:	//low
 314                     ; 210 			sensitivity = 2;		//paranoia
 316  0065 35020008      	mov	_sensitivity,#2
 317                     ; 211 			if (tapChangeCounter > DECREASE_SENSITIVITY_THRESHOLD)	sensitivity = 0;//output OFF
 319  0069 7b01          	ld	a,(OFST+0,sp)
 320  006b a107          	cp	a,#7
 321  006d 2504          	jrult	L541
 324  006f 3f08          	clr	_sensitivity
 326  0071 200d          	jra	L141
 327  0073               L541:
 328                     ; 212 			else if (tapChangeCounter < INCREASE_SENSITIVITY_THRESHOLD) 
 330  0073 a104          	cp	a,#4
 331  0075 2409          	jruge	L141
 332                     ; 214 							sensitivity = 1;
 334  0077 35010008      	mov	_sensitivity,#1
 335                     ; 215 							initSensitivity();		//reset sensitivity array to start counting new level
 338                     ; 216 							SensitivityArrayPosition = 0;
 340  007b               LC001:
 342  007b cd0000        	call	_initSensitivity
 344  007e 3f07          	clr	_SensitivityArrayPosition
 345  0080               L141:
 346                     ; 222 	switch (sensitivity)
 348  0080 b608          	ld	a,_sensitivity
 350                     ; 232 			break;
 351  0082 4a            	dec	a
 352  0083 2705          	jreq	L35
 353  0085 4a            	dec	a
 354  0086 270c          	jreq	L55
 355  0088 2014          	jra	L551
 356  008a               L35:
 357                     ; 224 		case 1:
 357                     ; 225 			selectedTapUpVoltage = LVL1_SENSE_TAP_UP_VOLTAGE;
 359  008a ae5965        	ldw	x,#22885
 360  008d bf03          	ldw	_selectedTapUpVoltage,x
 361                     ; 226 			selectedTapDownVoltage = LVL1_SENSE_TAP_DOWN_VOLTAGE;
 363  008f ae83da        	ldw	x,#33754
 364                     ; 227 			break;
 366  0092 2008          	jp	LC002
 367  0094               L55:
 368                     ; 229 		case 2:
 368                     ; 230 			selectedTapUpVoltage = LVL2_SENSE_TAP_UP_VOLTAGE;
 370  0094 ae58b2        	ldw	x,#22706
 371  0097 bf03          	ldw	_selectedTapUpVoltage,x
 372                     ; 231 			selectedTapDownVoltage = LVL2_SENSE_TAP_DOWN_VOLTAGE;
 374  0099 ae8614        	ldw	x,#34324
 375  009c               LC002:
 376  009c bf05          	ldw	_selectedTapDownVoltage,x
 377                     ; 232 			break;
 379  009e               L551:
 380                     ; 236 	oldLow = newLow;
 382                     	btst	L34_newLow
 383  00a3 90110005      	bccm	L73_oldLow
 384                     ; 237 	oldHigh = newHigh;
 386                     	btst	L54_newHigh
 387  00ac 90110006      	bccm	L14_oldHigh
 388                     ; 238 	firstEntry = FALSE;
 390                     ; 239 }		//updateSensivity()
 393  00b0 84            	pop	a
 394  00b1 72110004      	bres	L53_firstEntry
 395  00b5 81            	ret	
 441                     ; 243 u8 addEventToSensitivityArray(u8 *arr, u8 posn)
 441                     ; 244 {
 442                     .text:	section	.text,new
 443  0000               _addEventToSensitivityArray:
 445       fffffffe      OFST: set -2
 448                     ; 245 	*(arr+posn) = minutes;
 450  0000 01            	rrwa	x,a
 451  0001 1b03          	add	a,(OFST+5,sp)
 452  0003 2401          	jrnc	L22
 453  0005 5c            	incw	x
 454  0006               L22:
 455  0006 02            	rlwa	x,a
 456  0007 b600          	ld	a,_minutes
 457  0009 f7            	ld	(x),a
 458                     ; 246 	if (posn >= (DECREASE_SENSITIVITY_THRESHOLD+1))	return (0);
 460  000a 7b03          	ld	a,(OFST+5,sp)
 461  000c a107          	cp	a,#7
 462  000e 2502          	jrult	L102
 465  0010 4f            	clr	a
 468  0011 81            	ret	
 469  0012               L102:
 470                     ; 247 	return (posn+1);
 472  0012 4c            	inc	a
 475  0013 81            	ret	
 512                     ; 255 void checkSensitivityArrays(void)
 512                     ; 256 {
 513                     .text:	section	.text,new
 514  0000               _checkSensitivityArrays:
 516  0000 88            	push	a
 517       00000001      OFST:	set	1
 520                     ; 257 	u8 loop = 0;
 522  0001 4f            	clr	a
 523  0002 6b01          	ld	(OFST+0,sp),a
 525  0004               L122:
 526                     ; 263 		if (minutes == SensitivityArray[loop]) SensitivityArray[loop] = 0xFF;
 528  0004 5f            	clrw	x
 529  0005 97            	ld	xl,a
 530  0006 e600          	ld	a,(_SensitivityArray,x)
 531  0008 b100          	cp	a,_minutes
 532  000a 2608          	jrne	L722
 535  000c 7b01          	ld	a,(OFST+0,sp)
 536  000e 5f            	clrw	x
 537  000f 97            	ld	xl,a
 538  0010 a6ff          	ld	a,#255
 539  0012 e700          	ld	(_SensitivityArray,x),a
 540  0014               L722:
 541                     ; 267 		loop++;
 543  0014 0c01          	inc	(OFST+0,sp)
 545                     ; 261 	while (loop <= (DECREASE_SENSITIVITY_THRESHOLD+1))
 547  0016 7b01          	ld	a,(OFST+0,sp)
 548  0018 a108          	cp	a,#8
 549  001a 25e8          	jrult	L122
 550                     ; 269 }
 553  001c 84            	pop	a
 554  001d 81            	ret	
 618                     ; 274 u8 getCounterValue(u8 *array)
 618                     ; 275 {
 619                     .text:	section	.text,new
 620  0000               _getCounterValue:
 622  0000 5204          	subw	sp,#4
 623       00000004      OFST:	set	4
 626                     ; 276 	u8 loop = 0;
 628  0002 0f02          	clr	(OFST-2,sp)
 630                     ; 277 	u8 counter = 0;
 632  0004 0f01          	clr	(OFST-3,sp)
 634                     ; 278 	u8 *arrayPtr = array;
 636  0006 1f03          	ldw	(OFST-1,sp),x
 639  0008 201b          	jra	L762
 640  000a               L362:
 641                     ; 282 		if (isYGlow())	*arrayPtr = 0xFF;	//blank the array if SWIM low - wipe existing events
 643  000a cd0000        	call	_isYGlow
 645  000d 4d            	tnz	a
 646  000e 2707          	jreq	L372
 649  0010 1e03          	ldw	x,(OFST-1,sp)
 650  0012 a6ff          	ld	a,#255
 651  0014 f7            	ld	(x),a
 653  0015 2009          	jra	L572
 654  0017               L372:
 655                     ; 283 		else if (*arrayPtr<60) counter++;
 657  0017 1e03          	ldw	x,(OFST-1,sp)
 658  0019 f6            	ld	a,(x)
 659  001a a13c          	cp	a,#60
 660  001c 2402          	jruge	L572
 663  001e 0c01          	inc	(OFST-3,sp)
 665  0020               L572:
 666                     ; 284 		arrayPtr++;
 668  0020 5c            	incw	x
 669  0021 1f03          	ldw	(OFST-1,sp),x
 671                     ; 285 		loop++;
 673  0023 0c02          	inc	(OFST-2,sp)
 675  0025               L762:
 676                     ; 280 	while (loop <= DECREASE_SENSITIVITY_THRESHOLD)
 678  0025 7b02          	ld	a,(OFST-2,sp)
 679  0027 a107          	cp	a,#7
 680  0029 25df          	jrult	L362
 681                     ; 287 	return (counter);
 683  002b 7b01          	ld	a,(OFST-3,sp)
 686  002d 5b04          	addw	sp,#4
 687  002f 81            	ret	
 712                     ; 291 u8 getASPSensitivityLevel(void)
 712                     ; 292 {
 713                     .text:	section	.text,new
 714  0000               _getASPSensitivityLevel:
 718                     ; 293 	return (sensitivity);
 720  0000 b608          	ld	a,_sensitivity
 723  0002 81            	ret	
1137                     ; 682 void syncOFF(Relay *rel)
1137                     ; 683 {
1138                     .text:	section	.text,new
1139  0000               _syncOFF:
1141  0000 89            	pushw	x
1142  0001 89            	pushw	x
1143       00000002      OFST:	set	2
1146                     ; 685 	s16 delay = (period) - 320 - RELAY_SWITCH_OFF_TIME_US;
1148  0002 be00          	ldw	x,_period
1149  0004 1d10e0        	subw	x,#4320
1150  0007 1f01          	ldw	(OFST-1,sp),x
1152                     ; 687 	waitNeg();	//wait for start of negative 1/2 cycle
1154  0009 cd0000        	call	_waitNeg
1156                     ; 689 	if (delay > 0)	holdus((u16)delay);	//wait for the calculated time
1158  000c 9c            	rvf	
1159  000d 1e01          	ldw	x,(OFST-1,sp)
1160  000f 2d03          	jrsle	L755
1163  0011 cd0000        	call	_holdus
1165  0014               L755:
1166                     ; 695 	rel->disableRelay();
1168  0014 1e03          	ldw	x,(OFST+1,sp)
1169  0016 ee1e          	ldw	x,(30,x)
1170  0018 fd            	call	(x)
1172                     ; 697 	holdus(period);
1174  0019 be00          	ldw	x,_period
1175  001b cd0000        	call	_holdus
1177                     ; 698 }
1180  001e 5b04          	addw	sp,#4
1181  0020 81            	ret	
1230                     ; 703 void syncON(Relay *rel)
1230                     ; 704 {
1231                     .text:	section	.text,new
1232  0000               _syncON:
1234  0000 89            	pushw	x
1235  0001 89            	pushw	x
1236       00000002      OFST:	set	2
1239                     ; 706 	s16 delay = (period) - 320 - RELAY_SWITCH_ON_TIME_US;
1241  0002 be00          	ldw	x,_period
1242  0004 1d18b0        	subw	x,#6320
1243  0007 1f01          	ldw	(OFST-1,sp),x
1245                     ; 708 	waitNeg();	//wait for start of negative 1/2 cycle
1247  0009 cd0000        	call	_waitNeg
1249                     ; 710 	if (delay > 0)	holdus((u16)delay);	//wait for the calculated time
1251  000c 9c            	rvf	
1252  000d 1e01          	ldw	x,(OFST-1,sp)
1253  000f 2d03          	jrsle	L506
1256  0011 cd0000        	call	_holdus
1258  0014               L506:
1259                     ; 716 	rel->enableRelay();
1261  0014 1e03          	ldw	x,(OFST+1,sp)
1262  0016 ee1c          	ldw	x,(28,x)
1263  0018 fd            	call	(x)
1265                     ; 718 	holdus(period);
1267  0019 be00          	ldw	x,_period
1268  001b cd0000        	call	_holdus
1270                     ; 719 }
1273  001e 5b04          	addw	sp,#4
1274  0020 81            	ret	
1312                     ; 724 void operateRelay(Relay *rel)
1312                     ; 725 {
1313                     .text:	section	.text,new
1314  0000               _operateRelay:
1316  0000 89            	pushw	x
1317       00000000      OFST:	set	0
1320                     ; 726 	if (enterONMode)
1322  0001 7201000009    	btjf	_enterONMode,L726
1323                     ; 728 		rel->enableRelay();
1325  0006 ee1c          	ldw	x,(28,x)
1326  0008 fd            	call	(x)
1328                     ; 729 		enterONMode = 0;
1330  0009 72110000      	bres	_enterONMode
1332  000d 201a          	jra	L136
1333  000f               L726:
1334                     ; 733 		if ((rel->state != REL_ON) && rel->relayON)		 rel->disableRelay();	//if state is not on and relay is on
1336  000f e603          	ld	a,(3,x)
1337  0011 a102          	cp	a,#2
1338  0013 2708          	jreq	L336
1340  0015 f6            	ld	a,(x)
1341  0016 2a05          	jrpl	L336
1344  0018 ee1e          	ldw	x,(30,x)
1345  001a fd            	call	(x)
1347  001b 1e01          	ldw	x,(OFST+1,sp)
1348  001d               L336:
1349                     ; 734 		if ((rel->state == REL_ON) && (!rel->relayON)) 	rel->enableRelay();	//if state is on and relay is off
1351  001d e603          	ld	a,(3,x)
1352  001f a102          	cp	a,#2
1353  0021 2606          	jrne	L136
1355  0023 f6            	ld	a,(x)
1356  0024 2b03          	jrmi	L136
1359  0026 ee1c          	ldw	x,(28,x)
1360  0028 fd            	call	(x)
1362  0029               L136:
1363                     ; 736 }
1366  0029 85            	popw	x
1367  002a 81            	ret	
1499                     	xdef	_desiredRelayComb
1500                     	xdef	_relay3Set
1501                     	xdef	_relay2Set
1502                     	xdef	_relay1Set
1503                     	xdef	_sensitivity
1504                     	xdef	_SensitivityArrayPosition
1505                     	switch	.ubsct
1506  0000               _SensitivityArray:
1507  0000 000000000000  	ds.b	7
1508                     	xdef	_SensitivityArray
1509                     	xdef	_resetTapChangeBlindTime
1510                     	xdef	_syncON
1511                     	xdef	_syncOFF
1512                     	xdef	_getCounterValue
1513                     	xdef	_addEventToSensitivityArray
1514                     	xref	_holdus
1515                     	xref.b	_minutes
1516                     	xbit	_enterONMode
1517                     	xref.b	_period
1518                     	xref.b	_outputVoltage
1519                     	xref	_waitNeg
1520                     	xref	_isYGlow
1521                     	xdef	_selectedTapDownVoltage
1522                     	xdef	_selectedTapUpVoltage
1523                     	xdef	_relayCombination
1524                     	xdef	_tapChangeBlindTime
1525                     	xdef	_operateRelay
1526                     	xdef	_getASPSensitivityLevel
1527                     	xdef	_checkSensitivityArrays
1528                     	xdef	_updateSensitivity
1529                     	xdef	_initSensitivity
1549                     	end
