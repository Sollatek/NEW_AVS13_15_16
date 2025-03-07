   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     	bsct
  19  0000               _randomStandardDelay:
  20  0000 0a            	dc.b	10
  21                     .bit:	section	.data,bit
  22  0000               _enterONMode:
  23  0000 00            	dc.b	0
  58                     ; 38 void initRelays(void)
  58                     ; 39 {
  60                     .text:	section	.text,new
  61  0000               _initRelays:
  65                     ; 40 	initRelay(&relay1, &enableRelay1, &disableRelay1);
  67  0000 ae0000        	ldw	x,#_disableRelay1
  68  0003 89            	pushw	x
  69  0004 ae0000        	ldw	x,#_enableRelay1
  70  0007 89            	pushw	x
  71  0008 ae0000        	ldw	x,#_relay1
  72  000b cd0000        	call	_initRelay
  74  000e 5b04          	addw	sp,#4
  75                     ; 41 }
  78  0010 81            	ret	
 505                     ; 45 void initRelay(Relay *rel, void (*enable_func_pointer)(void), void (*disable_func_pointer)(void))
 505                     ; 46 {
 506                     .text:	section	.text,new
 507  0000               _initRelay:
 509  0000 89            	pushw	x
 510       00000000      OFST:	set	0
 513                     ; 48 	rel->voltageOK = FALSE;
 515  0001 f6            	ld	a,(x)
 516  0002 a4fe          	and	a,#254
 517  0004 f7            	ld	(x),a
 518                     ; 49 	rel->notOFF = FALSE;
 520  0005 f6            	ld	a,(x)
 521  0006 a4fd          	and	a,#253
 522  0008 f7            	ld	(x),a
 523                     ; 50 	rel->intDelayOK = FALSE;
 525  0009 f6            	ld	a,(x)
 526  000a a4fb          	and	a,#251
 527  000c f7            	ld	(x),a
 528                     ; 51 	rel->tempOK = FALSE;
 530  000d f6            	ld	a,(x)
 531  000e a4f7          	and	a,#247
 532  0010 f7            	ld	(x),a
 533                     ; 52 	rel->testMode = FALSE;	//not used in this firmware
 535  0011 f6            	ld	a,(x)
 536  0012 a4bf          	and	a,#191
 537  0014 f7            	ld	(x),a
 538                     ; 53 	rel->relayON = FALSE;
 540  0015 f6            	ld	a,(x)
 541  0016 a47f          	and	a,#127
 542  0018 f7            	ld	(x),a
 543                     ; 56 	rel->voltProtEnabled = VOLTAGE_PROTECTION_ENABLED;
 545  0019 e601          	ld	a,(1,x)
 546  001b aa01          	or	a,#1
 547  001d e701          	ld	(1,x),a
 548                     ; 57 	rel->aspEnabled = ASP_ENABLED;
 550  001f e601          	ld	a,(1,x)
 551  0021 a47f          	and	a,#127
 552  0023 e701          	ld	(1,x),a
 553                     ; 58 	rel->sensitivityEnabled = SENSITIVITY_ENABLED;
 555  0025 e602          	ld	a,(2,x)
 556  0027 a4fe          	and	a,#254
 557  0029 e702          	ld	(2,x),a
 558                     ; 59 	rel->offDetectEnabled = OFF_POSITION_DETECT_ENABLED;
 560  002b e601          	ld	a,(1,x)
 561  002d a4ef          	and	a,#239
 562  002f e701          	ld	(1,x),a
 563                     ; 60 	rel->intDelayEnabled = TIMESAVE_DELAY_ENABLED;
 565  0031 e601          	ld	a,(1,x)
 566  0033 aa20          	or	a,#32
 567  0035 e701          	ld	(1,x),a
 568                     ; 61 	rel->tempEnabled = TEMPERATURE_PROTECTION_ENABLED;
 570  0037 e601          	ld	a,(1,x)
 571  0039 a4fd          	and	a,#253
 572  003b e701          	ld	(1,x),a
 573                     ; 62 	rel->probeFaultDetectEnabled = PROBE_FAULT_DETECTION_ENABLED;
 575  003d e601          	ld	a,(1,x)
 576  003f a4bf          	and	a,#191
 577  0041 e701          	ld	(1,x),a
 578                     ; 63 	rel->defrostEnabled = DEFROST_ENABLED;
 580  0043 e601          	ld	a,(1,x)
 581  0045 a4fb          	and	a,#251
 582  0047 e701          	ld	(1,x),a
 583                     ; 64 	rel->condensorBlockDetectEnabled = CONDENSOR_BLOCKAGE_DETECTION_ENABLED;
 585  0049 e601          	ld	a,(1,x)
 586  004b a4f7          	and	a,#247
 587  004d e701          	ld	(1,x),a
 588                     ; 66 	rel->state = REL_OFF;
 590  004f 6f03          	clr	(3,x)
 591                     ; 69 	rel->LVD = LOW_VOLTAGE_DISCONNECT;
 593  0051 90ae5e87      	ldw	y,#24199
 594  0055 ef04          	ldw	(4,x),y
 595                     ; 70 	rel->fastLVD = LOW_VOLTAGE_DISCONNECT_FAST;
 597  0057 90ae348b      	ldw	y,#13451
 598  005b ef06          	ldw	(6,x),y
 599                     ; 71 	rel->HVD = HIGH_VOLTAGE_DISCONNECT;
 601  005d 90aebb12      	ldw	y,#47890
 602  0061 ef08          	ldw	(8,x),y
 603                     ; 72 	rel->fastHVD = HIGH_VOLTAGE_DISCONNECT_FAST;
 605  0063 90aed902      	ldw	y,#55554
 606  0067 ef0a          	ldw	(10,x),y
 607                     ; 74 	rel->LVR = LOW_VOLTAGE_RECONNECT;
 609  0069 90ae63c2      	ldw	y,#25538
 610  006d ef0c          	ldw	(12,x),y
 611                     ; 75 	rel->HVR = HIGH_VOLTAGE_RECONNECT;
 613  006f 90aeb81a      	ldw	y,#47130
 614  0073 ef0e          	ldw	(14,x),y
 615                     ; 78 	rel->nsec = 0;				//reconnect delay counter
 617  0075 905f          	clrw	y
 618  0077 ef10          	ldw	(16,x),y
 619                     ; 79 	rel->milliSec = 0;		//blind time counter
 621  0079 4f            	clr	a
 622  007a e715          	ld	(21,x),a
 623  007c e714          	ld	(20,x),a
 624  007e e713          	ld	(19,x),a
 625  0080 e712          	ld	(18,x),a
 626                     ; 80 	rel->waitDelay = randomStandardDelay;			//random delay     // STANDARD_WAIT_DELAY_SECS;
 628  0082 b600          	ld	a,_randomStandardDelay
 629  0084 9097          	ld	yl,a
 630  0086 ef16          	ldw	(22,x),y
 631                     ; 81 	rel->uVBlindTime = UNDERVOLTAGE_BLIND_TIME_MSEC;
 633  0088 90ae03e8      	ldw	y,#1000
 634  008c ef18          	ldw	(24,x),y
 635                     ; 82 	rel->oVBlindTime = OVERVOLTAGE_BLIND_TIME_MSEC;
 637  008e 90ae0050      	ldw	y,#80
 638  0092 ef1a          	ldw	(26,x),y
 639                     ; 84 	rel->enableRelay = enable_func_pointer;			// assign function pointers
 641  0094 1605          	ldw	y,(OFST+5,sp)
 642  0096 ef1c          	ldw	(28,x),y
 643                     ; 85 	rel->disableRelay = disable_func_pointer;
 645  0098 1607          	ldw	y,(OFST+7,sp)
 646  009a ef1e          	ldw	(30,x),y
 647                     ; 87 	rel->disableRelay();	//make sure relay is disabled after initialization
 649  009c ee1e          	ldw	x,(30,x)
 650  009e fd            	call	(x)
 652                     ; 88 }	//initRelay
 655  009f 85            	popw	x
 656  00a0 81            	ret	
 711                     ; 92 void relayFunction(Relay *rel)
 711                     ; 93 {
 712                     .text:	section	.text,new
 713  0000               _relayFunction:
 715  0000 89            	pushw	x
 716  0001 88            	push	a
 717       00000001      OFST:	set	1
 720                     ; 94 	volatile _Bool test = FALSE;
 722  0002 0f01          	clr	(OFST+0,sp)
 724                     ; 95 	switch (rel->state)
 726  0004 e603          	ld	a,(3,x)
 728                     ; 163 			break;
 729  0006 2709          	jreq	L372
 730  0008 4a            	dec	a
 731  0009 2750          	jreq	L572
 732  000b 4a            	dec	a
 733  000c 2603cc00c4    	jreq	L772
 734  0011               L372:
 735                     ; 97 		case REL_OFF:
 735                     ; 98 		default:
 735                     ; 99 			//Off state operating functions
 735                     ; 100 			releaseIntDelay();
 737  0011 cd0000        	call	_releaseIntDelay
 739                     ; 101 			rel->state = REL_OFF;	// paranoia if we have got here with an unhandled state
 741  0014 1e02          	ldw	x,(OFST+1,sp)
 742  0016 6f03          	clr	(3,x)
 743                     ; 104 			test = rel->voltageOK;
 745  0018 f6            	ld	a,(x)
 746  0019 a401          	and	a,#1
 747  001b 6b01          	ld	(OFST+0,sp),a
 749                     ; 105 			if (test) test = rel->tempOK;
 751  001d 0d01          	tnz	(OFST+0,sp)
 752  001f 2708          	jreq	L133
 755  0021 f6            	ld	a,(x)
 756  0022 a408          	and	a,#8
 757  0024 44            	srl	a
 758  0025 44            	srl	a
 759  0026 44            	srl	a
 760  0027 6b01          	ld	(OFST+0,sp),a
 762  0029               L133:
 763                     ; 106 			if (test) test = rel->notOFF;
 765  0029 0d01          	tnz	(OFST+0,sp)
 766  002b 2706          	jreq	L333
 769  002d f6            	ld	a,(x)
 770  002e a402          	and	a,#2
 771  0030 44            	srl	a
 772  0031 6b01          	ld	(OFST+0,sp),a
 774  0033               L333:
 775                     ; 107 			if (test) 
 777  0033 0d01          	tnz	(OFST+0,sp)
 778  0035 271f          	jreq	L533
 779                     ; 109 				rel->state = REL_WAIT;
 781  0037 a601          	ld	a,#1
 782  0039 e703          	ld	(3,x),a
 783                     ; 110 				randomStandardDelay = generateRandomDelay();		//generates random delay if enabled in options.h. If not then fixed minimum delay.
 785  003b cd0000        	call	_generateRandomDelay
 787  003e b700          	ld	_randomStandardDelay,a
 788                     ; 111 				if (rel->waitDelay != IntDelaySecs)	//if we are measuring standard delay, we should start now
 790  0040 1602          	ldw	y,(OFST+1,sp)
 791  0042 90ee16        	ldw	y,(22,y)
 792  0045 90b300        	cpw	y,_IntDelaySecs
 793  0048 2603cc0114    	jreq	L723
 794                     ; 114 					rel->nsec = 0;
 796  004d 1e02          	ldw	x,(OFST+1,sp)
 797  004f 905f          	clrw	y
 798  0051 ef10          	ldw	(16,x),y
 799  0053 cc0114        	jra	L723
 800  0056               L533:
 801                     ; 116 			else rel->state = REL_OFF;
 803  0056 6f03          	clr	(3,x)
 804  0058 cc0114        	jra	L723
 805  005b               L572:
 806                     ; 119 		case REL_WAIT:
 806                     ; 120 			//Wait state operating functions
 806                     ; 121 			releaseIntDelay();
 808  005b cd0000        	call	_releaseIntDelay
 810                     ; 124 			test = rel->voltageOK;
 812  005e 1e02          	ldw	x,(OFST+1,sp)
 813  0060 f6            	ld	a,(x)
 814  0061 a401          	and	a,#1
 815  0063 6b01          	ld	(OFST+0,sp),a
 817                     ; 125 			if (test) test = rel->tempOK;
 819  0065 0d01          	tnz	(OFST+0,sp)
 820  0067 2708          	jreq	L343
 823  0069 f6            	ld	a,(x)
 824  006a a408          	and	a,#8
 825  006c 44            	srl	a
 826  006d 44            	srl	a
 827  006e 44            	srl	a
 828  006f 6b01          	ld	(OFST+0,sp),a
 830  0071               L343:
 831                     ; 126 			if (test) test = rel->notOFF;
 833  0071 0d01          	tnz	(OFST+0,sp)
 834  0073 2706          	jreq	L543
 837  0075 f6            	ld	a,(x)
 838  0076 a402          	and	a,#2
 839  0078 44            	srl	a
 840  0079 6b01          	ld	(OFST+0,sp),a
 842  007b               L543:
 843                     ; 127 			if (!test) 
 845  007b 0d01          	tnz	(OFST+0,sp)
 846  007d 2605          	jrne	L743
 847                     ; 129 				rel->state = REL_OFF;
 849  007f 6f03          	clr	(3,x)
 850                     ; 130 				return;
 852  0081 cc0114        	jra	L723
 853  0084               L743:
 854                     ; 132 			test = rel->sensitivityOK;
 856  0084 f6            	ld	a,(x)
 857  0085 4e            	swap	a
 858  0086 a402          	and	a,#2
 859  0088 44            	srl	a
 860  0089 6b01          	ld	(OFST+0,sp),a
 862                     ; 134 			if (test && (rel->waitDelay != IntDelaySecs) && (rel->nsec > rel->waitDelay) && isSwitchOn) 
 864  008b 0d01          	tnz	(OFST+0,sp)
 865  008d 272f          	jreq	L153
 867  008f 9093          	ldw	y,x
 868  0091 90ee16        	ldw	y,(22,y)
 869  0094 90b300        	cpw	y,_IntDelaySecs
 870  0097 2725          	jreq	L153
 872  0099 1602          	ldw	y,(OFST+1,sp)
 873  009b ee10          	ldw	x,(16,x)
 874  009d 90e316        	cpw	x,(22,y)
 875  00a0 231c          	jrule	L153
 877  00a2 3d00          	tnz	_isSwitchOn
 878  00a4 2718          	jreq	L153
 879                     ; 136 				rel->state = REL_ON;
 881  00a6 93            	ldw	x,y
 882  00a7 a602          	ld	a,#2
 883  00a9 e703          	ld	(3,x),a
 884                     ; 137 				rel->nsec = 0;			// reset delay counters when entering ON state
 886  00ab 905f          	clrw	y
 887  00ad ef10          	ldw	(16,x),y
 888                     ; 138 				rel->milliSec = 0;
 890  00af 4f            	clr	a
 891  00b0 e715          	ld	(21,x),a
 892  00b2 e714          	ld	(20,x),a
 893  00b4 e713          	ld	(19,x),a
 894  00b6 e712          	ld	(18,x),a
 895                     ; 139 				enterONMode = TRUE;	// force ASP control to enable relevant output relay combination
 897  00b8 72100000      	bset	_enterONMode
 899  00bc 2056          	jra	L723
 900  00be               L153:
 901                     ; 141 			else rel->state = REL_WAIT;
 903  00be 1e02          	ldw	x,(OFST+1,sp)
 904  00c0 a601          	ld	a,#1
 905  00c2 204e          	jp	LC001
 906  00c4               L772:
 907                     ; 144 		case REL_ON:
 907                     ; 145 			//On state operating functions
 907                     ; 146 			primeIntDelay(); //assert intelligent delay
 909  00c4 cd0000        	call	_primeIntDelay
 911                     ; 149 			test = rel->voltageOK;
 913  00c7 1e02          	ldw	x,(OFST+1,sp)
 914  00c9 f6            	ld	a,(x)
 915  00ca a401          	and	a,#1
 916  00cc 6b01          	ld	(OFST+0,sp),a
 918                     ; 150 			if (test) test = rel->tempOK;
 920  00ce 0d01          	tnz	(OFST+0,sp)
 921  00d0 2708          	jreq	L553
 924  00d2 f6            	ld	a,(x)
 925  00d3 a408          	and	a,#8
 926  00d5 44            	srl	a
 927  00d6 44            	srl	a
 928  00d7 44            	srl	a
 929  00d8 6b01          	ld	(OFST+0,sp),a
 931  00da               L553:
 932                     ; 151 			if (test) test = rel->notOFF;
 934  00da 0d01          	tnz	(OFST+0,sp)
 935  00dc 2706          	jreq	L753
 938  00de f6            	ld	a,(x)
 939  00df a402          	and	a,#2
 940  00e1 44            	srl	a
 941  00e2 6b01          	ld	(OFST+0,sp),a
 943  00e4               L753:
 944                     ; 152 			if (test) test = rel->sensitivityOK;
 946  00e4 0d01          	tnz	(OFST+0,sp)
 947  00e6 2707          	jreq	L163
 950  00e8 f6            	ld	a,(x)
 951  00e9 4e            	swap	a
 952  00ea a402          	and	a,#2
 953  00ec 44            	srl	a
 954  00ed 6b01          	ld	(OFST+0,sp),a
 956  00ef               L163:
 957                     ; 153 			if ((!test) || (!isSwitchOn)) 
 959  00ef 0d01          	tnz	(OFST+0,sp)
 960  00f1 2704          	jreq	L563
 962  00f3 3d00          	tnz	_isSwitchOn
 963  00f5 2619          	jrne	L363
 964  00f7               L563:
 965                     ; 155 				rel->state = REL_OFF;
 967  00f7 6f03          	clr	(3,x)
 968                     ; 156 				rel->nsec = 0;				// reset delay counters to be able to measure reconnect delay
 970  00f9 905f          	clrw	y
 971  00fb ef10          	ldw	(16,x),y
 972                     ; 157 				rel->milliSec = 0;
 974  00fd 4f            	clr	a
 975  00fe e715          	ld	(21,x),a
 976  0100 e714          	ld	(20,x),a
 977  0102 e713          	ld	(19,x),a
 978  0104 e712          	ld	(18,x),a
 979                     ; 158 				if (avs_state == AVS_MAN_ON)
 981  0106 b600          	ld	a,_avs_state
 982  0108 a107          	cp	a,#7
 983  010a 2608          	jrne	L723
 984                     ; 159 					isSwitchOn = FALSE;		//in manual mode if we turn off relay for whatever reason we also need to change button state to off
 986  010c 3f00          	clr	_isSwitchOn
 987  010e 2004          	jra	L723
 988  0110               L363:
 989                     ; 162 			else rel->state = REL_ON;
 991  0110 a602          	ld	a,#2
 992  0112               LC001:
 993  0112 e703          	ld	(3,x),a
 994  0114               L723:
 995                     ; 165 }	//relayFunction
 998  0114 5b03          	addw	sp,#3
 999  0116 81            	ret	
1036                     .const:	section	.text
1037  0000               L23:
1038  0000 ffffffff      	dc.l	-1
1039  0004               L43:
1040  0004 000003e8      	dc.l	1000
1041                     ; 169 void updateRelayTimer(Relay *rel)
1041                     ; 170 {
1042                     .text:	section	.text,new
1043  0000               _updateRelayTimer:
1045  0000 89            	pushw	x
1046       00000000      OFST:	set	0
1049                     ; 172 	if (rel->milliSec < 0xFFFFFFFF) 
1051  0001 1c0012        	addw	x,#18
1052  0004 cd0000        	call	c_ltor
1054  0007 ae0000        	ldw	x,#L23
1055  000a cd0000        	call	c_lcmp
1057  000d 2432          	jruge	L314
1058                     ; 174 		rel->milliSec++;
1060  000f 1e01          	ldw	x,(OFST+1,sp)
1061  0011 1c0012        	addw	x,#18
1062  0014 a601          	ld	a,#1
1063  0016 cd0000        	call	c_lgadc
1065                     ; 175 		if (!(rel->milliSec % 1000))
1067  0019 1e01          	ldw	x,(OFST+1,sp)
1068  001b 1c0012        	addw	x,#18
1069  001e cd0000        	call	c_ltor
1071  0021 ae0004        	ldw	x,#L43
1072  0024 cd0000        	call	c_lumd
1074  0027 cd0000        	call	c_lrzmp
1076  002a 2615          	jrne	L314
1077                     ; 177 			if (rel->nsec < 0xFFFE) rel->nsec++;	//nsec shouldn't reach 0xFFFF because this is reserved for manual mode (infinity)
1079  002c 1601          	ldw	y,(OFST+1,sp)
1080  002e 90ee10        	ldw	y,(16,y)
1081  0031 90a3fffe      	cpw	y,#65534
1082  0035 240a          	jruge	L314
1085  0037 1e01          	ldw	x,(OFST+1,sp)
1086  0039 9093          	ldw	y,x
1087  003b ee10          	ldw	x,(16,x)
1088  003d 5c            	incw	x
1089  003e 90ef10        	ldw	(16,y),x
1090  0041               L314:
1091                     ; 180 }
1094  0041 85            	popw	x
1095  0042 81            	ret	
1137                     ; 184 void processRelay(Relay *rel)
1137                     ; 185 {
1138                     .text:	section	.text,new
1139  0000               _processRelay:
1141  0000 89            	pushw	x
1142       00000000      OFST:	set	0
1145                     ; 187 	voltageProc(rel);
1147  0001 cd0000        	call	_voltageProc
1149                     ; 190 	tempProc(rel);
1151  0004 1e01          	ldw	x,(OFST+1,sp)
1152  0006 cd0000        	call	_tempProc
1154                     ; 193 	getIntDelayStatus(rel);
1156  0009 1e01          	ldw	x,(OFST+1,sp)
1157  000b cd0000        	call	_getIntDelayStatus
1159                     ; 196 	getOffPositionStatus(rel);
1161  000e 1e01          	ldw	x,(OFST+1,sp)
1162  0010 cd0000        	call	_getOffPositionStatus
1164                     ; 199 	getSensitivityStatus(rel);
1166  0013 1e01          	ldw	x,(OFST+1,sp)
1167  0015 cd0000        	call	_getSensitivityStatus
1169                     ; 200 }
1172  0018 85            	popw	x
1173  0019 81            	ret	
1213                     ; 203 void getSensitivityStatus(Relay *rel)
1213                     ; 204 {
1214                     .text:	section	.text,new
1215  0000               _getSensitivityStatus:
1217  0000 89            	pushw	x
1218       00000000      OFST:	set	0
1221                     ; 205 	if (!rel->sensitivityEnabled || getASPSensitivityLevel() || isYGlow()) rel->sensitivityOK = TRUE;
1223  0001 e602          	ld	a,(2,x)
1224  0003 a501          	bcp	a,#1
1225  0005 270c          	jreq	L364
1227  0007 cd0000        	call	_getASPSensitivityLevel
1229  000a 4d            	tnz	a
1230  000b 2606          	jrne	L364
1232  000d cd0000        	call	_isYGlow
1234  0010 4d            	tnz	a
1235  0011 2708          	jreq	L164
1236  0013               L364:
1239  0013 1e01          	ldw	x,(OFST+1,sp)
1240  0015 f6            	ld	a,(x)
1241  0016 aa20          	or	a,#32
1243  0018               L764:
1244  0018 f7            	ld	(x),a
1245                     ; 207 }
1248  0019 85            	popw	x
1249  001a 81            	ret	
1250  001b               L164:
1251                     ; 206 	else	rel->sensitivityOK = FALSE;
1253  001b 1e01          	ldw	x,(OFST+1,sp)
1254  001d f6            	ld	a,(x)
1255  001e a4df          	and	a,#223
1256  0020 20f6          	jra	L764
1294                     ; 211 void getOffPositionStatus(Relay *rel)
1294                     ; 212 {
1295                     .text:	section	.text,new
1296  0000               _getOffPositionStatus:
1300                     ; 213 	if (!rel->offDetectEnabled)	rel->notOFF = TRUE;
1302  0000 e601          	ld	a,(1,x)
1303  0002 a510          	bcp	a,#16
1304  0004 2604          	jrne	L115
1307  0006 f6            	ld	a,(x)
1308  0007 aa02          	or	a,#2
1309  0009 f7            	ld	(x),a
1310  000a               L115:
1311                     ; 214 }
1314  000a 81            	ret	
1377                     ; 219 void getIntDelayStatus(Relay *rel)
1377                     ; 220 {
1378                     .text:	section	.text,new
1379  0000               _getIntDelayStatus:
1381  0000 89            	pushw	x
1382  0001 5204          	subw	sp,#4
1383       00000004      OFST:	set	4
1386                     ; 226 	if (!rel->intDelayEnabled || isFirst30min())
1388  0003 e601          	ld	a,(1,x)
1389  0005 a520          	bcp	a,#32
1390  0007 2706          	jreq	L545
1392  0009 cd0000        	call	_isFirst30min
1394  000c 4d            	tnz	a
1395  000d 270e          	jreq	L345
1396  000f               L545:
1397                     ; 228 		rel->intDelayOK = TRUE;
1399  000f 1e05          	ldw	x,(OFST+1,sp)
1400  0011 f6            	ld	a,(x)
1401  0012 aa04          	or	a,#4
1402  0014 f7            	ld	(x),a
1403                     ; 229 		rel->waitDelay = randomStandardDelay;
1405  0015 b600          	ld	a,_randomStandardDelay
1406  0017 905f          	clrw	y
1407  0019 9097          	ld	yl,a
1408                     ; 230 		return;
1410  001b 200e          	jra	L47
1411  001d               L345:
1412                     ; 234 	if (isYGlow())
1414  001d cd0000        	call	_isYGlow
1416  0020 4d            	tnz	a
1417  0021 270d          	jreq	L745
1418                     ; 236 		rel->intDelayOK = TRUE;
1420  0023 1e05          	ldw	x,(OFST+1,sp)
1421  0025 f6            	ld	a,(x)
1422  0026 aa04          	or	a,#4
1423  0028 f7            	ld	(x),a
1424                     ; 237 		rel->waitDelay = 0;
1426  0029               LC002:
1427  0029 905f          	clrw	y
1428                     ; 238 		return;
1429  002b               L47:
1430  002b ef16          	ldw	(22,x),y
1433  002d 5b06          	addw	sp,#6
1434  002f 81            	ret	
1435  0030               L745:
1436                     ; 242 	if (intDelayPrimed) 
1438  0030 720100000e    	btjf	_intDelayPrimed,L155
1439                     ; 244 		rel->intDelayOK = TRUE;
1441  0035 1e05          	ldw	x,(OFST+1,sp)
1442  0037 f6            	ld	a,(x)
1443  0038 aa04          	or	a,#4
1444  003a f7            	ld	(x),a
1445                     ; 245 		rel->waitDelay = randomStandardDelay;
1447  003b b600          	ld	a,_randomStandardDelay
1448  003d 905f          	clrw	y
1449  003f 9097          	ld	yl,a
1450                     ; 246 		return;
1452  0041 20e8          	jra	L47
1453  0043               L155:
1454                     ; 250 	intDelayLevel = getIntDelay();
1456  0043 cd0000        	call	_getIntDelay
1458  0046 1f01          	ldw	(OFST-3,sp),x
1460                     ; 252 	if (isYGlow())	appliedADCThreshold = TEST_INT_DELAY_ADC_LEVEL;
1462  0048 cd0000        	call	_isYGlow
1464  004b 4d            	tnz	a
1465  004c 2705          	jreq	L355
1468  004e ae00a1        	ldw	x,#161
1470  0051 2002          	jra	L555
1471  0053               L355:
1472                     ; 253 	else appliedADCThreshold = IntDelayADCLevel;//INT_DELAY_ADC_LEVEL;
1474  0053 be00          	ldw	x,_IntDelayADCLevel
1475  0055               L555:
1476  0055 1f03          	ldw	(OFST-1,sp),x
1478                     ; 257 	if ((intDelayLevel >= appliedADCThreshold) 
1478                     ; 258 			|| ((intDelayLevel > (appliedADCThreshold - INT_DELAY_HYST_COUNTS)) && rel->intDelayOK))
1480  0057 1e01          	ldw	x,(OFST-3,sp)
1481  0059 1303          	cpw	x,(OFST-1,sp)
1482  005b 2410          	jruge	L165
1484  005d 1e03          	ldw	x,(OFST-1,sp)
1485  005f 1d0005        	subw	x,#5
1486  0062 1301          	cpw	x,(OFST-3,sp)
1487  0064 2429          	jruge	L755
1489  0066 1e05          	ldw	x,(OFST+1,sp)
1490  0068 f6            	ld	a,(x)
1491  0069 a504          	bcp	a,#4
1492  006b 2722          	jreq	L755
1493  006d               L165:
1494                     ; 260 		if (!(rel->intDelayOK))		//do this only once after Int Delay finish
1496  006d 1e05          	ldw	x,(OFST+1,sp)
1497  006f f6            	ld	a,(x)
1498  0070 a504          	bcp	a,#4
1499  0072 2604          	jrne	L365
1500                     ; 262 			rel->nsec = 0;				// counter is already higher than threshold so reset counter to add standard delay
1502  0074 905f          	clrw	y
1503  0076 ef10          	ldw	(16,x),y
1504  0078               L365:
1505                     ; 264 		rel->intDelayOK = TRUE;
1507  0078 f6            	ld	a,(x)
1508  0079 aa04          	or	a,#4
1509  007b f7            	ld	(x),a
1510                     ; 265 		if (IntDelaySecs == MANUAL_MODE_SECS)	//in manual mode there is only intelligent delay so we set std to 0
1512  007c be00          	ldw	x,_IntDelaySecs
1513  007e 5c            	incw	x
1514  007f 2604          	jrne	L565
1515                     ; 266 			rel->waitDelay = 0;
1517  0081 1e05          	ldw	x,(OFST+1,sp)
1519  0083 20a4          	jp	LC002
1520  0085               L565:
1521                     ; 268 			rel->waitDelay = randomStandardDelay;
1523  0085 1e05          	ldw	x,(OFST+1,sp)
1524  0087 b600          	ld	a,_randomStandardDelay
1525  0089 905f          	clrw	y
1526  008b 9097          	ld	yl,a
1527                     ; 275 }	//getIntDelayStatus
1529  008d 209c          	jra	L47
1530  008f               L755:
1531                     ; 272 		rel->intDelayOK = FALSE;
1533  008f 1e05          	ldw	x,(OFST+1,sp)
1534  0091 f6            	ld	a,(x)
1535  0092 a4fb          	and	a,#251
1536  0094 f7            	ld	(x),a
1537                     ; 273 		rel->waitDelay = IntDelaySecs;//INT_DELAY_WAIT_TIME_SECS;
1539  0095 90be00        	ldw	y,_IntDelaySecs
1540  0098 2091          	jra	L47
1577                     ; 280 void tempProc(Relay *rel)
1577                     ; 281 {
1578                     .text:	section	.text,new
1579  0000               _tempProc:
1581       00000000      OFST:	set	0
1584                     ; 282 	if (!rel->tempEnabled) 
1586  0000 e601          	ld	a,(1,x)
1587  0002 a502          	bcp	a,#2
1588  0004 2605          	jrne	L316
1589                     ; 284 		rel->tempOK = TRUE;
1591  0006 f6            	ld	a,(x)
1592  0007 aa08          	or	a,#8
1593                     ; 285 		return;
1595  0009 2003          	jra	L001
1596  000b               L316:
1597                     ; 287 	rel->tempOK = FALSE;
1599  000b f6            	ld	a,(x)
1600  000c a4f7          	and	a,#247
1601                     ; 288 }
1602  000e               L001:
1603  000e f7            	ld	(x),a
1606  000f 81            	ret	
1609                     	switch	.bit
1610  0001               L516_milliSecResetDone:
1611  0001 00            	dc.b	0
1668                     ; 293 void voltageProc(Relay *rel)
1668                     ; 294 {
1669                     .text:	section	.text,new
1670  0000               _voltageProc:
1672  0000 89            	pushw	x
1673  0001 88            	push	a
1674       00000001      OFST:	set	1
1677                     ; 295 	_Bool blindTime = FALSE;
1679  0002 0f01          	clr	(OFST+0,sp)
1681                     ; 299 	if (!rel->voltProtEnabled) 
1683  0004 e601          	ld	a,(1,x)
1684  0006 a501          	bcp	a,#1
1685  0008 2605          	jrne	L746
1686                     ; 301 		rel->voltageOK = TRUE;
1688  000a f6            	ld	a,(x)
1689  000b aa01          	or	a,#1
1690                     ; 302 		return;
1692  000d 200a          	jp	LC003
1693  000f               L746:
1694                     ; 306 	if (!acVmeasurementOK)
1696  000f 1e02          	ldw	x,(OFST+1,sp)
1697  0011 7200000007    	btjt	_acVmeasurementOK,L156
1698                     ; 308 		rel->voltageOK = FALSE;
1700  0016 f6            	ld	a,(x)
1701  0017 a4fe          	and	a,#254
1702  0019               LC003:
1703  0019 f7            	ld	(x),a
1704                     ; 309 		return;
1705  001a               L021:
1708  001a 5b03          	addw	sp,#3
1709  001c 81            	ret	
1710  001d               L156:
1711                     ; 313 	if (rel->state != REL_OFF)
1713  001d 6d03          	tnz	(3,x)
1714  001f 9093          	ldw	y,x
1715  0021 2603cc00b1    	jreq	L356
1716                     ; 319 			if (outputVoltage < rel->fastLVD) 
1718  0026 90ee06        	ldw	y,(6,y)
1719  0029 90b300        	cpw	y,_outputVoltage
1720                     ; 321 				rel->voltageOK = FALSE;			// if below fastLVD reset flag immediately
1721                     ; 322 				milliSecResetDone = FALSE;	// in case we were in normal LVD blind time and voltage drops below fast LVD
1722                     ; 323 				return;
1724  002c 2239          	jrugt	LC005
1725                     ; 326 			else if (outputVoltage < rel->LVD)	//See if voltage < normal LVD threshold
1727  002e 9093          	ldw	y,x
1728  0030 90ee04        	ldw	y,(4,y)
1729  0033 90b300        	cpw	y,_outputVoltage
1730  0036 2325          	jrule	L166
1731                     ; 328 				if (!milliSecResetDone)			// check if LVD blind time has been triggered
1733  0038 720000010d    	btjt	L516_milliSecResetDone,L366
1734                     ; 330 					rel->milliSec = 0;				// if not then trigger..
1736  003d 4f            	clr	a
1737  003e e715          	ld	(21,x),a
1738  0040 e714          	ld	(20,x),a
1739  0042 e713          	ld	(19,x),a
1740  0044 e712          	ld	(18,x),a
1741                     ; 331 					milliSecResetDone = TRUE;	// and set flag
1743  0046 72100001      	bset	L516_milliSecResetDone
1744  004a               L366:
1745                     ; 333 				rel->voltageOK = (rel->milliSec < rel->uVBlindTime);		// voltage ok if still in blind time (before switch off)
1747  004a ee18          	ldw	x,(24,x)
1748  004c cd0000        	call	c_uitolx
1750  004f 1e02          	ldw	x,(OFST+1,sp)
1751  0051 1c0012        	addw	x,#18
1752  0054 cd0000        	call	c_lcmp
1754  0057 2343          	jrule	L011
1755  0059               LC008:
1756  0059 a601          	ld	a,#1
1757  005b 2040          	jra	L211
1759  005d               L166:
1760                     ; 337 			else if (outputVoltage > rel->fastHVD)
1762  005d 9093          	ldw	y,x
1763  005f 90ee0a        	ldw	y,(10,y)
1764  0062 90b300        	cpw	y,_outputVoltage
1765  0065 240a          	jruge	L766
1766                     ; 339 				rel->voltageOK = FALSE;			// if above fastHVD reset flag immediately
1768  0067               LC005:
1770  0067 f6            	ld	a,(x)
1771  0068 a4fe          	and	a,#254
1772  006a f7            	ld	(x),a
1773                     ; 340 				milliSecResetDone = FALSE;	// in case we were in normal HVD blind time and voltage goes above fast HVD
1775  006b               LC004:
1778  006b 72110001      	bres	L516_milliSecResetDone
1779                     ; 341 				return;
1781  006f 20a9          	jra	L021
1782  0071               L766:
1783                     ; 344 			else if (outputVoltage > rel->HVD)
1785  0071 9093          	ldw	y,x
1786  0073 90ee08        	ldw	y,(8,y)
1787  0076 90b300        	cpw	y,_outputVoltage
1788  0079 242b          	jruge	L376
1789                     ; 346 				if (!milliSecResetDone)
1791  007b 720000010d    	btjt	L516_milliSecResetDone,L576
1792                     ; 348 					rel->milliSec = 0;
1794  0080 4f            	clr	a
1795  0081 e715          	ld	(21,x),a
1796  0083 e714          	ld	(20,x),a
1797  0085 e713          	ld	(19,x),a
1798  0087 e712          	ld	(18,x),a
1799                     ; 349 					milliSecResetDone = TRUE;
1801  0089 72100001      	bset	L516_milliSecResetDone
1802  008d               L576:
1803                     ; 351 				rel->voltageOK = (rel->milliSec < rel->oVBlindTime);		// set flag if still in blind time (before switch off)
1805  008d ee1a          	ldw	x,(26,x)
1806  008f cd0000        	call	c_uitolx
1808  0092 1e02          	ldw	x,(OFST+1,sp)
1809  0094 1c0012        	addw	x,#18
1810  0097 cd0000        	call	c_lcmp
1812  009a 22bd          	jrugt	LC008
1813  009c               L011:
1814  009c 4f            	clr	a
1815  009d               L211:
1816  009d 1e02          	ldw	x,(OFST+1,sp)
1817  009f f8            	xor	a,(x)
1818  00a0 a401          	and	a,#1
1819  00a2 f8            	xor	a,(x)
1820  00a3 f7            	ld	(x),a
1822  00a4 2004          	jra	L756
1823  00a6               L376:
1824                     ; 353 			else milliSecResetDone = FALSE;		// if voltage is ok again before blind time run out, clear reset flag
1826  00a6 72110001      	bres	L516_milliSecResetDone
1827  00aa               L756:
1828                     ; 356 		if (!rel->voltageOK) milliSecResetDone = FALSE;
1830  00aa f6            	ld	a,(x)
1831  00ab a501          	bcp	a,#1
1832  00ad 26c0          	jrne	L021
1834  00af 20ba          	jp	LC004
1835  00b1               L356:
1836                     ; 361 		rel->voltageOK = ((outputVoltage > rel->LVR) && (outputVoltage < rel->HVR));
1838  00b1 90ee0c        	ldw	y,(12,y)
1839  00b4 90b300        	cpw	y,_outputVoltage
1840  00b7 240e          	jruge	L411
1841  00b9 9093          	ldw	y,x
1842  00bb 90ee0e        	ldw	y,(14,y)
1843  00be 90b300        	cpw	y,_outputVoltage
1844  00c1 2304          	jrule	L411
1845  00c3 a601          	ld	a,#1
1846  00c5 2001          	jra	L611
1847  00c7               L411:
1848  00c7 4f            	clr	a
1849  00c8               L611:
1850  00c8 f8            	xor	a,(x)
1851  00c9 a401          	and	a,#1
1852  00cb f8            	xor	a,(x)
1853                     ; 374 }	//voltageProc
1855  00cc cc0019        	jp	LC003
1880                     ; 378 void enableRelay1(void)
1880                     ; 379 {
1881                     .text:	section	.text,new
1882  0000               _enableRelay1:
1886                     ; 380 	GPIOsetHigh(RELAY1_PORT);
1888  0000 4b10          	push	#16
1889  0002 ae500f        	ldw	x,#20495
1890  0005 cd0000        	call	_GPIOsetHigh
1892  0008 721e0000      	bset	_relay1,#7
1893  000c 84            	pop	a
1894                     ; 381 	relay1.relayON = TRUE;
1896                     ; 382 }
1899  000d 81            	ret	
1925                     ; 385 void disableRelay1(void)
1925                     ; 386 {
1926                     .text:	section	.text,new
1927  0000               _disableRelay1:
1931                     ; 387 	GPIOsetOutputPushPull(RELAY1_PORT);
1933  0000 4b10          	push	#16
1934  0002 ae500f        	ldw	x,#20495
1935  0005 cd0000        	call	_GPIOsetOutputPushPull
1937  0008 84            	pop	a
1938                     ; 388 	GPIOsetLow(RELAY1_PORT);
1940  0009 4b10          	push	#16
1941  000b ae500f        	ldw	x,#20495
1942  000e cd0000        	call	_GPIOsetLow
1944  0011 721f0000      	bres	_relay1,#7
1945  0015 84            	pop	a
1946                     ; 389 	relay1.relayON = FALSE;
1948                     ; 390 }
1951  0016 81            	ret	
1996                     	xdef	_disableRelay1
1997                     	xdef	_enableRelay1
1998                     	xdef	_voltageProc
1999                     	xdef	_tempProc
2000                     	xdef	_getIntDelayStatus
2001                     	xdef	_getOffPositionStatus
2002                     	xdef	_getSensitivityStatus
2003                     	xdef	_initRelay
2004                     	xdef	_randomStandardDelay
2005                     	xdef	_enterONMode
2006                     	switch	.ubsct
2007  0000               _relay1:
2008  0000 000000000000  	ds.b	32
2009                     	xdef	_relay1
2010                     	xdef	_updateRelayTimer
2011                     	xdef	_relayFunction
2012                     	xdef	_processRelay
2013                     	xdef	_initRelays
2014                     	xref.b	_isSwitchOn
2015                     	xbit	_intDelayPrimed
2016                     	xref	_isFirst30min
2017                     	xref	_releaseIntDelay
2018                     	xref	_primeIntDelay
2019                     	xref	_generateRandomDelay
2020                     	xbit	_acVmeasurementOK
2021                     	xref.b	_outputVoltage
2022                     	xref	_isYGlow
2023                     	xref	_GPIOsetLow
2024                     	xref	_GPIOsetHigh
2025                     	xref	_GPIOsetOutputPushPull
2026                     	xref.b	_IntDelayADCLevel
2027                     	xref.b	_IntDelaySecs
2028                     	xref.b	_avs_state
2029                     	xref	_getASPSensitivityLevel
2030                     	xref	_getIntDelay
2031                     	xref.b	c_x
2051                     	xref	c_uitolx
2052                     	xref	c_lrzmp
2053                     	xref	c_lumd
2054                     	xref	c_lgadc
2055                     	xref	c_lcmp
2056                     	xref	c_ltor
2057                     	end
