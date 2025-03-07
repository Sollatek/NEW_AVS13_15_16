   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  51                     ; 36 void GPIOinit(void)
  51                     ; 37 {
  53                     .text:	section	.text,new
  54  0000               _GPIOinit:
  58                     ; 39 	GPIOsetInputPullupNoInt(GPIOA, ALLBITS);
  60  0000 4bff          	push	#255
  61  0002 ae5000        	ldw	x,#20480
  62  0005 cd0000        	call	_GPIOsetInputPullupNoInt
  64  0008 84            	pop	a
  65                     ; 40 	GPIOsetInputPullupNoInt(GPIOC, ALLBITS);
  67  0009 4bff          	push	#255
  68  000b ae500a        	ldw	x,#20490
  69  000e cd0000        	call	_GPIOsetInputPullupNoInt
  71  0011 84            	pop	a
  72                     ; 41 	GPIOsetInputPullupNoInt(GPIOD, ALLBITS);
  74  0012 4bff          	push	#255
  75  0014 ae500f        	ldw	x,#20495
  76  0017 cd0000        	call	_GPIOsetInputPullupNoInt
  78  001a 84            	pop	a
  79                     ; 42 	GPIOsetInputPullupNoInt(GPIOE, ALLBITS);
  81  001b 4bff          	push	#255
  82  001d ae5014        	ldw	x,#20500
  83  0020 cd0000        	call	_GPIOsetInputPullupNoInt
  85  0023 84            	pop	a
  86                     ; 43 	GPIOsetInputPullupNoInt(GPIOF, ALLBITS);
  88  0024 4bff          	push	#255
  89  0026 ae5019        	ldw	x,#20505
  90  0029 cd0000        	call	_GPIOsetInputPullupNoInt
  92  002c 84            	pop	a
  93                     ; 47 	GPIOsetInputFloatNoInt(AC_SENSE_PORT);	//voltage sesing
  95  002d 4b01          	push	#1
  96  002f ae5005        	ldw	x,#20485
  97  0032 cd0000        	call	_GPIOsetInputFloatNoInt
  99  0035 84            	pop	a
 100                     ; 51 	GPIOsetOutputPushPull(DEBUG_SYNC_PORT);	//PD2 used for debugging
 102  0036 4b04          	push	#4
 103  0038 ae500f        	ldw	x,#20495
 104  003b cd0000        	call	_GPIOsetOutputPushPull
 106  003e 84            	pop	a
 107                     ; 52 	GPIOsetInputPullupInt(ID_PORT);				//Likely PA1, pulled up if AVS13 and pulled down if AVS15
 109  003f 4b02          	push	#2
 110  0041 ae5000        	ldw	x,#20480
 111  0044 cd0000        	call	_GPIOsetInputPullupInt
 113  0047 84            	pop	a
 114                     ; 53 	GPIOsetInputFloatNoInt(SWITCH_PORT);// GND for pressed else 3.3V
 116  0048 4b10          	push	#16
 117  004a ae5019        	ldw	x,#20505
 118  004d cd0000        	call	_GPIOsetInputFloatNoInt
 120  0050 84            	pop	a
 121                     ; 54 	GPIOsetInputFloatNoInt(SWITCH2_PORT);
 123  0051 4b08          	push	#8
 124  0053 ae5000        	ldw	x,#20480
 125  0056 cd0000        	call	_GPIOsetInputFloatNoInt
 127  0059 84            	pop	a
 128                     ; 55 	GPIOsetInputFloatNoInt(SWITCH3_PORT);
 130  005a 4b04          	push	#4
 131  005c ae5000        	ldw	x,#20480
 132  005f cd0000        	call	_GPIOsetInputFloatNoInt
 134  0062 84            	pop	a
 135                     ; 57 	SevenSegmentGPIOinit();
 138                     ; 58 }
 141  0063 cc0000        	jp	_SevenSegmentGPIOinit
 166                     ; 60 void SevenSegmentGPIOinit(void)
 166                     ; 61 {
 167                     .text:	section	.text,new
 168  0000               _SevenSegmentGPIOinit:
 172                     ; 63 	GPIOsetOutputPushPull(SIG_DATA_PORT, ALLBITS);
 174  0000 4bff          	push	#255
 175  0002 ae500a        	ldw	x,#20490
 176  0005 cd0000        	call	_GPIOsetOutputPushPull
 178  0008 84            	pop	a
 179                     ; 64 	GPIOsetOutputPushPull(DIGIT0);
 181  0009 4b04          	push	#4
 182  000b ae500f        	ldw	x,#20495
 183  000e cd0000        	call	_GPIOsetOutputPushPull
 185  0011 84            	pop	a
 186                     ; 65 	GPIOsetOutputPushPull(DIGIT1);
 188  0012 4b08          	push	#8
 189  0014 ae500f        	ldw	x,#20495
 190  0017 cd0000        	call	_GPIOsetOutputPushPull
 192  001a 84            	pop	a
 193                     ; 66 	GPIOsetOutputPushPull(DIGIT2);
 195  001b 4b40          	push	#64
 196  001d ae5005        	ldw	x,#20485
 197  0020 cd0000        	call	_GPIOsetOutputPushPull
 199  0023 84            	pop	a
 200                     ; 67 	GPIOsetOutputPushPull(DIGIT3);
 202  0024 4b80          	push	#128
 203  0026 ae5005        	ldw	x,#20485
 204  0029 cd0000        	call	_GPIOsetOutputPushPull
 206  002c 84            	pop	a
 207                     ; 68 	GPIOsetOutputPushPull(TEST_LED_DISC);
 209  002d 4b01          	push	#1
 210  002f ae500f        	ldw	x,#20495
 211  0032 cd0000        	call	_GPIOsetOutputPushPull
 213  0035 84            	pop	a
 214                     ; 69 }
 217  0036 81            	ret	
 316                     ; 72 void GPIOsetInputFloatNoInt(GPIO_TypeDef *port, u8 pattern)
 316                     ; 73 {
 317                     .text:	section	.text,new
 318  0000               _GPIOsetInputFloatNoInt:
 320       fffffffe      OFST: set -2
 323                     ; 74 	port->DDR &=(~pattern);
 325  0000 7b03          	ld	a,(OFST+5,sp)
 326  0002 43            	cpl	a
 327  0003 e402          	and	a,(2,x)
 328  0005 e702          	ld	(2,x),a
 329                     ; 75 	port->CR1 &=(~pattern);
 331  0007 7b03          	ld	a,(OFST+5,sp)
 332  0009 43            	cpl	a
 333  000a e403          	and	a,(3,x)
 334  000c e703          	ld	(3,x),a
 335                     ; 76 	port->CR2 &=(~pattern);
 337  000e 7b03          	ld	a,(OFST+5,sp)
 338  0010 43            	cpl	a
 339  0011 e404          	and	a,(4,x)
 340  0013 e704          	ld	(4,x),a
 341                     ; 77 }	
 344  0015 81            	ret	
 391                     ; 79 void GPIOsetInputPullupNoInt(GPIO_TypeDef *port, u8 pattern)
 391                     ; 80 {
 392                     .text:	section	.text,new
 393  0000               _GPIOsetInputPullupNoInt:
 395       fffffffe      OFST: set -2
 398                     ; 81 	port->DDR &=(~pattern);
 400  0000 7b03          	ld	a,(OFST+5,sp)
 401  0002 43            	cpl	a
 402  0003 e402          	and	a,(2,x)
 403  0005 e702          	ld	(2,x),a
 404                     ; 82 	port->CR1 |= pattern;
 406  0007 e603          	ld	a,(3,x)
 407  0009 1a03          	or	a,(OFST+5,sp)
 408  000b e703          	ld	(3,x),a
 409                     ; 83 	port->CR2 &=(~pattern);
 411  000d 7b03          	ld	a,(OFST+5,sp)
 412  000f 43            	cpl	a
 413  0010 e404          	and	a,(4,x)
 414  0012 e704          	ld	(4,x),a
 415                     ; 84 }
 418  0014 81            	ret	
 465                     ; 86 void GPIOsetInputFloatInt(GPIO_TypeDef *port, u8 pattern)
 465                     ; 87 {
 466                     .text:	section	.text,new
 467  0000               _GPIOsetInputFloatInt:
 469       fffffffe      OFST: set -2
 472                     ; 88 	port->DDR &=(~pattern);
 474  0000 7b03          	ld	a,(OFST+5,sp)
 475  0002 43            	cpl	a
 476  0003 e402          	and	a,(2,x)
 477  0005 e702          	ld	(2,x),a
 478                     ; 89 	port->CR1 &=(~pattern);
 480  0007 7b03          	ld	a,(OFST+5,sp)
 481  0009 43            	cpl	a
 482  000a e403          	and	a,(3,x)
 483  000c e703          	ld	(3,x),a
 484                     ; 90 	port->CR2 |= pattern;
 486  000e e604          	ld	a,(4,x)
 487  0010 1a03          	or	a,(OFST+5,sp)
 488  0012 e704          	ld	(4,x),a
 489                     ; 91 }
 492  0014 81            	ret	
 539                     ; 93 void GPIOsetInputPullupInt(GPIO_TypeDef *port, u8 pattern)
 539                     ; 94 {
 540                     .text:	section	.text,new
 541  0000               _GPIOsetInputPullupInt:
 543       fffffffe      OFST: set -2
 546                     ; 95 	port->DDR &=(~pattern);
 548  0000 7b03          	ld	a,(OFST+5,sp)
 549  0002 43            	cpl	a
 550  0003 e402          	and	a,(2,x)
 551  0005 e702          	ld	(2,x),a
 552                     ; 96 	port->CR1 |= pattern;
 554  0007 e603          	ld	a,(3,x)
 555  0009 1a03          	or	a,(OFST+5,sp)
 556  000b e703          	ld	(3,x),a
 557                     ; 97 	port->CR2 |= pattern;
 559  000d e604          	ld	a,(4,x)
 560  000f 1a03          	or	a,(OFST+5,sp)
 561  0011 e704          	ld	(4,x),a
 562                     ; 98 }
 565  0013 81            	ret	
 612                     ; 100 void GPIOsetOutputOpenDrain(GPIO_TypeDef *port, u8 pattern)
 612                     ; 101 {
 613                     .text:	section	.text,new
 614  0000               _GPIOsetOutputOpenDrain:
 616       fffffffe      OFST: set -2
 619                     ; 102 	port->DDR |= pattern;
 621  0000 e602          	ld	a,(2,x)
 622  0002 1a03          	or	a,(OFST+5,sp)
 623  0004 e702          	ld	(2,x),a
 624                     ; 103 	port->CR1 &= (~pattern);
 626  0006 7b03          	ld	a,(OFST+5,sp)
 627  0008 43            	cpl	a
 628  0009 e403          	and	a,(3,x)
 629  000b e703          	ld	(3,x),a
 630                     ; 104 	port->CR2 |= pattern;
 632  000d e604          	ld	a,(4,x)
 633  000f 1a03          	or	a,(OFST+5,sp)
 634  0011 e704          	ld	(4,x),a
 635                     ; 105 }
 638  0013 81            	ret	
 685                     ; 107 void GPIOsetOutputPushPull(GPIO_TypeDef *port, u8 pattern)
 685                     ; 108 {
 686                     .text:	section	.text,new
 687  0000               _GPIOsetOutputPushPull:
 689       fffffffe      OFST: set -2
 692                     ; 109 	port->DDR |= pattern;
 694  0000 e602          	ld	a,(2,x)
 695  0002 1a03          	or	a,(OFST+5,sp)
 696  0004 e702          	ld	(2,x),a
 697                     ; 110 	port->CR1 |= pattern;	
 699  0006 e603          	ld	a,(3,x)
 700  0008 1a03          	or	a,(OFST+5,sp)
 701  000a e703          	ld	(3,x),a
 702                     ; 111 	port->CR2 &=~pattern;
 704  000c 7b03          	ld	a,(OFST+5,sp)
 705  000e 43            	cpl	a
 706  000f e404          	and	a,(4,x)
 707  0011 e704          	ld	(4,x),a
 708                     ; 112 }
 711  0013 81            	ret	
 757                     ; 114 void GPIOsetHigh(GPIO_TypeDef *port, u8 pattern)
 757                     ; 115 {
 758                     .text:	section	.text,new
 759  0000               _GPIOsetHigh:
 761       fffffffe      OFST: set -2
 764                     ; 116 	port->ODR |= pattern;
 766  0000 f6            	ld	a,(x)
 767  0001 1a03          	or	a,(OFST+5,sp)
 768  0003 f7            	ld	(x),a
 769                     ; 117 }
 772  0004 81            	ret	
 818                     ; 119 void GPIOtoggle(GPIO_TypeDef *port, u8 pattern)
 818                     ; 120 {
 819                     .text:	section	.text,new
 820  0000               _GPIOtoggle:
 822       fffffffe      OFST: set -2
 825                     ; 121 	port->ODR ^= pattern;
 827  0000 f6            	ld	a,(x)
 828  0001 1803          	xor	a,(OFST+5,sp)
 829  0003 f7            	ld	(x),a
 830                     ; 122 }
 833  0004 81            	ret	
 879                     ; 124 void GPIOsetLow(GPIO_TypeDef *port, u8 pattern)
 879                     ; 125 {
 880                     .text:	section	.text,new
 881  0000               _GPIOsetLow:
 883       fffffffe      OFST: set -2
 886                     ; 126 	port->ODR &= (~pattern);
 888  0000 7b03          	ld	a,(OFST+5,sp)
 889  0002 43            	cpl	a
 890  0003 f4            	and	a,(x)
 891  0004 f7            	ld	(x),a
 892                     ; 127 }
 895  0005 81            	ret	
 941                     ; 129 void GPIOportValue(GPIO_TypeDef *port, u8 pattern)
 941                     ; 130 {
 942                     .text:	section	.text,new
 943  0000               _GPIOportValue:
 945       fffffffe      OFST: set -2
 948                     ; 131 	port->ODR = pattern;
 950  0000 7b03          	ld	a,(OFST+5,sp)
 951  0002 f7            	ld	(x),a
 952                     ; 132 }
 955  0003 81            	ret	
1002                     ; 134 _Bool GPIOisBitHigh(GPIO_TypeDef *port, u8 pattern)
1002                     ; 135 {
1003                     .text:	section	.text,new
1004  0000               _GPIOisBitHigh:
1006       fffffffe      OFST: set -2
1009                     ; 136 	if (port->IDR & pattern) return ((_Bool)TRUE);
1011  0000 e601          	ld	a,(1,x)
1012  0002 1503          	bcp	a,(OFST+5,sp)
1013  0004 2703          	jreq	L514
1016  0006 a601          	ld	a,#1
1019  0008 81            	ret	
1020  0009               L514:
1021                     ; 137 	return ((_Bool)FALSE);
1023  0009 4f            	clr	a
1026  000a 81            	ret	
1073                     ; 140 _Bool GPIOisBitLow(GPIO_TypeDef *port, u8 pattern)
1073                     ; 141 {
1074                     .text:	section	.text,new
1075  0000               _GPIOisBitLow:
1077       fffffffe      OFST: set -2
1080                     ; 142 	if ((port->IDR & pattern)) return ((_Bool)FALSE);
1082  0000 e601          	ld	a,(1,x)
1083  0002 1503          	bcp	a,(OFST+5,sp)
1084  0004 2702          	jreq	L344
1087  0006 4f            	clr	a
1090  0007 81            	ret	
1091  0008               L344:
1092                     ; 143 	return ((_Bool)TRUE);
1094  0008 a601          	ld	a,#1
1097  000a 81            	ret	
1134                     ; 146 u8 GPIObyteState(GPIO_TypeDef *port)
1134                     ; 147 {
1135                     .text:	section	.text,new
1136  0000               _GPIObyteState:
1140                     ; 148 	return (u8)(port->IDR);
1142  0000 e601          	ld	a,(1,x)
1145  0002 81            	ret	
1181                     ; 152 _Bool isYGlow(void)
1181                     ; 153 {
1182                     .text:	section	.text,new
1183  0000               _isYGlow:
1185  0000 88            	push	a
1186       00000001      OFST:	set	1
1189                     ; 156 	for (i=0; i<5; i++)
1191  0001 0f01          	clr	(OFST+0,sp)
1193  0003               L305:
1194                     ; 157 		if (GPIOisBitHigh(TEST_PORT))
1196  0003 4b02          	push	#2
1197  0005 ae5000        	ldw	x,#20480
1198  0008 cd0000        	call	_GPIOisBitHigh
1200  000b 5b01          	addw	sp,#1
1201  000d 4d            	tnz	a
1202  000e 2704          	jreq	L115
1203                     ; 158 			return (FALSE);
1205  0010 4f            	clr	a
1208  0011 5b01          	addw	sp,#1
1209  0013 81            	ret	
1210  0014               L115:
1211                     ; 156 	for (i=0; i<5; i++)
1213  0014 0c01          	inc	(OFST+0,sp)
1217  0016 7b01          	ld	a,(OFST+0,sp)
1218  0018 a105          	cp	a,#5
1219  001a 25e7          	jrult	L305
1220                     ; 160 	return (TRUE);
1222  001c a601          	ld	a,#1
1225  001e 5b01          	addw	sp,#1
1226  0020 81            	ret	
1262                     ; 167 _Bool isButtonPressed(void)
1262                     ; 168 {
1263                     .text:	section	.text,new
1264  0000               _isButtonPressed:
1266  0000 89            	pushw	x
1267       00000002      OFST:	set	2
1270                     ; 171 	for (i=0; i<10; i++)
1272  0001 5f            	clrw	x
1273  0002 1f01          	ldw	(OFST-1,sp),x
1275  0004               L135:
1276                     ; 172 		if (GPIOisBitHigh(SWITCH_PORT))
1278  0004 4b10          	push	#16
1279  0006 ae5019        	ldw	x,#20505
1280  0009 cd0000        	call	_GPIOisBitHigh
1282  000c 5b01          	addw	sp,#1
1283  000e 4d            	tnz	a
1284  000f 2703          	jreq	L735
1285                     ; 173 			return (FALSE);
1287  0011 4f            	clr	a
1289  0012 200b          	jra	L221
1290  0014               L735:
1291                     ; 171 	for (i=0; i<10; i++)
1293  0014 1e01          	ldw	x,(OFST-1,sp)
1294  0016 5c            	incw	x
1295  0017 1f01          	ldw	(OFST-1,sp),x
1299  0019 a3000a        	cpw	x,#10
1300  001c 25e6          	jrult	L135
1301                     ; 175 	return (TRUE);
1303  001e 4c            	inc	a
1305  001f               L221:
1307  001f 85            	popw	x
1308  0020 81            	ret	
1344                     ; 178 _Bool isButtonPressed2(void)
1344                     ; 179 {
1345                     .text:	section	.text,new
1346  0000               _isButtonPressed2:
1348  0000 88            	push	a
1349       00000001      OFST:	set	1
1352                     ; 182 	for (i=0; i<10; i++)
1354  0001 0f01          	clr	(OFST+0,sp)
1356  0003               L755:
1357                     ; 183 		if (GPIOisBitHigh(SWITCH2_PORT))
1359  0003 4b08          	push	#8
1360  0005 ae5000        	ldw	x,#20480
1361  0008 cd0000        	call	_GPIOisBitHigh
1363  000b 5b01          	addw	sp,#1
1364  000d 4d            	tnz	a
1365  000e 2704          	jreq	L565
1366                     ; 184 			return (FALSE);
1368  0010 4f            	clr	a
1371  0011 5b01          	addw	sp,#1
1372  0013 81            	ret	
1373  0014               L565:
1374                     ; 182 	for (i=0; i<10; i++)
1376  0014 0c01          	inc	(OFST+0,sp)
1380  0016 7b01          	ld	a,(OFST+0,sp)
1381  0018 a10a          	cp	a,#10
1382  001a 25e7          	jrult	L755
1383                     ; 186 	return (TRUE);
1385  001c a601          	ld	a,#1
1388  001e 5b01          	addw	sp,#1
1389  0020 81            	ret	
1425                     ; 189 _Bool isButtonPressed3(void)
1425                     ; 190 {
1426                     .text:	section	.text,new
1427  0000               _isButtonPressed3:
1429  0000 88            	push	a
1430       00000001      OFST:	set	1
1433                     ; 193 	for (i=0; i<10; i++)
1435  0001 0f01          	clr	(OFST+0,sp)
1437  0003               L506:
1438                     ; 194 		if (GPIOisBitHigh(SWITCH3_PORT))
1440  0003 4b04          	push	#4
1441  0005 ae5000        	ldw	x,#20480
1442  0008 cd0000        	call	_GPIOisBitHigh
1444  000b 5b01          	addw	sp,#1
1445  000d 4d            	tnz	a
1446  000e 2704          	jreq	L316
1447                     ; 195 			return (FALSE);
1449  0010 4f            	clr	a
1452  0011 5b01          	addw	sp,#1
1453  0013 81            	ret	
1454  0014               L316:
1455                     ; 193 	for (i=0; i<10; i++)
1457  0014 0c01          	inc	(OFST+0,sp)
1461  0016 7b01          	ld	a,(OFST+0,sp)
1462  0018 a10a          	cp	a,#10
1463  001a 25e7          	jrult	L506
1464                     ; 197 	return (TRUE);
1466  001c a601          	ld	a,#1
1469  001e 5b01          	addw	sp,#1
1470  0020 81            	ret	
1483                     	xdef	_GPIOportValue
1484                     	xdef	_SevenSegmentGPIOinit
1485                     	xdef	_isButtonPressed3
1486                     	xdef	_isButtonPressed2
1487                     	xdef	_isButtonPressed
1488                     	xdef	_isYGlow
1489                     	xdef	_GPIObyteState
1490                     	xdef	_GPIOisBitLow
1491                     	xdef	_GPIOisBitHigh
1492                     	xdef	_GPIOsetLow
1493                     	xdef	_GPIOtoggle
1494                     	xdef	_GPIOsetHigh
1495                     	xdef	_GPIOsetOutputPushPull
1496                     	xdef	_GPIOsetOutputOpenDrain
1497                     	xdef	_GPIOsetInputPullupInt
1498                     	xdef	_GPIOsetInputFloatInt
1499                     	xdef	_GPIOsetInputPullupNoInt
1500                     	xdef	_GPIOsetInputFloatNoInt
1501                     	xdef	_GPIOinit
1520                     	end
