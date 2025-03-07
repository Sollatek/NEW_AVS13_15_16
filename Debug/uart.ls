   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  46                     ; 26 void UART1_Config(void)
  46                     ; 27 {
  48                     .text:	section	.text,new
  49  0000               _UART1_Config:
  53                     ; 29   UART1->CR1 &= (u8)(~UART1_CR1_M);  			//M=0 => 8 bit data 
  55  0000 72195234      	bres	21044,#4
  56                     ; 30   UART1->CR3 &= (u8)(~UART1_CR3_STOP);  	// STOP BITS=00 => One stop bit is transmitted at the end of frame
  58  0004 c65236        	ld	a,21046
  59  0007 a4cf          	and	a,#207
  60  0009 c75236        	ld	21046,a
  61                     ; 31   UART1->CR1 &= (u8)(~(UART1_CR1_PCEN));	//PCEN=0 => Parity Control Disabled
  63  000c 72155234      	bres	21044,#2
  64                     ; 37 	UART1->BRR2 = 0x01; //19200 baud
  66  0010 35015233      	mov	21043,#1
  67                     ; 47 	UART1->BRR1 = 0x34; // 19200 baud
  69  0014 35345232      	mov	21042,#52
  70                     ; 55 	UART1->CR2 |= (u8)UART1_CR2_TEN;  
  72  0018 72165235      	bset	21045,#3
  73                     ; 61 	UART1->CR1 &= (u8)(~UART1_CR1_UARTD); 
  75  001c 721b5234      	bres	21044,#5
  76                     ; 62 }
  79  0020 81            	ret	
 113                     ; 65 void UART1_PutChar(char Data)
 113                     ; 66 {
 114                     .text:	section	.text,new
 115  0000               _UART1_PutChar:
 119                     ; 67 	UART1->DR = Data;	//put data in data register
 121  0000 c75231        	ld	21041,a
 123  0003               L34:
 124                     ; 68 	while ((UART1->SR & UART1_SR_TXE ) != UART1_SR_TXE );	//wait for TXE bit (set by hardware when transmit register is empty)
 126  0003 720f5230fb    	btjf	21040,#7,L34
 127                     ; 69 }
 130  0008 81            	ret	
 176                     ; 73 void UART1_PutString(char *s, _Bool NewLine)
 176                     ; 74 {
 177                     .text:	section	.text,new
 178  0000               _UART1_PutString:
 180  0000 89            	pushw	x
 181       00000000      OFST:	set	0
 184  0001 2008          	jra	L37
 185  0003               L17:
 186                     ; 77 		UART1_PutChar(*s);	//keep sending chars until NULL
 188  0003 cd0000        	call	_UART1_PutChar
 190                     ; 78 		s ++;
 192  0006 1e01          	ldw	x,(OFST+1,sp)
 193  0008 5c            	incw	x
 194  0009 1f01          	ldw	(OFST+1,sp),x
 195  000b               L37:
 196                     ; 75 	while (*s != '\0')
 198  000b f6            	ld	a,(x)
 199  000c 26f5          	jrne	L17
 200                     ; 80 	if (NewLine)
 202  000e 7b05          	ld	a,(OFST+5,sp)
 203  0010 a501          	bcp	a,#1
 204  0012 270a          	jreq	L301
 205                     ; 82 		UART1_PutChar('\r');	//return
 207  0014 a60d          	ld	a,#13
 208  0016 cd0000        	call	_UART1_PutChar
 210                     ; 83 		UART1_PutChar('\n');	//new line
 212  0019 a60a          	ld	a,#10
 213  001b cd0000        	call	_UART1_PutChar
 215  001e               L301:
 216                     ; 85 	while ((UART1->SR & UART1_SR_TC ) != UART1_SR_TC );	//wait for TC bit (transmission comlete, set by hardware)
 218  001e 720d5230fb    	btjf	21040,#6,L301
 219                     ; 86 }
 222  0023 85            	popw	x
 223  0024 81            	ret	
 226                     .const:	section	.text
 227  0000               L701_CharDigits:
 228  0000 30            	dc.b	48
 229  0001 30            	dc.b	48
 230  0002 30            	dc.b	48
 231  0003 30            	dc.b	48
 232  0004 30            	dc.b	48
 233  0005 30            	dc.b	48
 234  0006 30            	dc.b	48
 235  0007 30            	dc.b	48
 315                     ; 90 void Hex2str(char str[11], u32 num)
 315                     ; 91 {
 316                     .text:	section	.text,new
 317  0000               _Hex2str:
 319  0000 89            	pushw	x
 320  0001 5210          	subw	sp,#16
 321       00000010      OFST:	set	16
 324                     ; 92 	u32 hex = num;
 326  0003 1e17          	ldw	x,(OFST+7,sp)
 327  0005 1f06          	ldw	(OFST-10,sp),x
 328  0007 1e15          	ldw	x,(OFST+5,sp)
 329  0009 1f04          	ldw	(OFST-12,sp),x
 331                     ; 93 	char CharDigits[8] = "00000000";
 333  000b 96            	ldw	x,sp
 334  000c 1c0008        	addw	x,#OFST-8
 335  000f 90ae0000      	ldw	y,#L701_CharDigits
 336  0013 a608          	ld	a,#8
 337  0015 cd0000        	call	c_xymov
 339                     ; 95 	u8 pos = 2;
 341  0018 a602          	ld	a,#2
 342  001a 6b03          	ld	(OFST-13,sp),a
 344                     ; 97 	for (i=0;i<10;i++) str[i] = '0';	//initialize string with zeros
 346  001c 4f            	clr	a
 347  001d 6b10          	ld	(OFST+0,sp),a
 349  001f               L351:
 352  001f 5f            	clrw	x
 353  0020 97            	ld	xl,a
 354  0021 72fb11        	addw	x,(OFST+1,sp)
 355  0024 a630          	ld	a,#48
 356  0026 f7            	ld	(x),a
 359  0027 0c10          	inc	(OFST+0,sp)
 363  0029 7b10          	ld	a,(OFST+0,sp)
 364  002b a10a          	cp	a,#10
 365  002d 25f0          	jrult	L351
 366                     ; 100 	str[0] = '0';	
 368  002f 1e11          	ldw	x,(OFST+1,sp)
 369  0031 a630          	ld	a,#48
 370  0033 f7            	ld	(x),a
 371                     ; 101 	str[1] = 'x';
 373  0034 a678          	ld	a,#120
 374  0036 e701          	ld	(1,x),a
 375                     ; 103 	CharDigits[0] = convertDigit(hex % 16);		//convert least significant hex digit to char and save it in array
 377  0038 7b07          	ld	a,(OFST-9,sp)
 378  003a a40f          	and	a,#15
 379  003c cd0000        	call	_convertDigit
 381  003f 6b08          	ld	(OFST-8,sp),a
 383                     ; 105 	for (i=1;i<8;i++)
 385  0041 a601          	ld	a,#1
 386  0043 6b10          	ld	(OFST+0,sp),a
 388  0045               L161:
 389                     ; 107 		hex = hex >> 4;	//get rid of the least significant hex digit..
 391  0045 96            	ldw	x,sp
 392  0046 1c0004        	addw	x,#OFST-12
 393  0049 a604          	ld	a,#4
 394  004b cd0000        	call	c_lgursh
 397                     ; 108 		CharDigits[i] = convertDigit(hex % 16);	//..to convert next one
 399  004e 96            	ldw	x,sp
 400  004f 1c0008        	addw	x,#OFST-8
 401  0052 9f            	ld	a,xl
 402  0053 5e            	swapw	x
 403  0054 1b10          	add	a,(OFST+0,sp)
 404  0056 2401          	jrnc	L42
 405  0058 5c            	incw	x
 406  0059               L42:
 407  0059 02            	rlwa	x,a
 408  005a 89            	pushw	x
 409  005b 7b09          	ld	a,(OFST-7,sp)
 410  005d a40f          	and	a,#15
 411  005f cd0000        	call	_convertDigit
 413  0062 85            	popw	x
 414  0063 f7            	ld	(x),a
 415                     ; 105 	for (i=1;i<8;i++)
 417  0064 0c10          	inc	(OFST+0,sp)
 421  0066 7b10          	ld	a,(OFST+0,sp)
 422  0068 a108          	cp	a,#8
 423  006a 25d9          	jrult	L161
 425  006c               L171:
 426                     ; 110 	while ((CharDigits[--i] == '0') && (i > 0)) ;		//ignore all zeros before actual number
 428  006c 96            	ldw	x,sp
 429  006d 1c0008        	addw	x,#OFST-8
 430  0070 1f01          	ldw	(OFST-15,sp),x
 432  0072 0a10          	dec	(OFST+0,sp)
 434  0074 5f            	clrw	x
 435  0075 7b10          	ld	a,(OFST+0,sp)
 436  0077 97            	ld	xl,a
 437  0078 72fb01        	addw	x,(OFST-15,sp)
 438  007b f6            	ld	a,(x)
 439  007c a130          	cp	a,#48
 440  007e 2621          	jrne	L102
 442  0080 7b10          	ld	a,(OFST+0,sp)
 443  0082 26e8          	jrne	L171
 444  0084 201b          	jra	L102
 445  0086               L771:
 446                     ; 113 		str[pos] = CharDigits[i];	//put significant chars to the string
 448  0086 7b03          	ld	a,(OFST-13,sp)
 449  0088 5f            	clrw	x
 450  0089 97            	ld	xl,a
 451  008a 72fb11        	addw	x,(OFST+1,sp)
 452  008d 89            	pushw	x
 453  008e 96            	ldw	x,sp
 454  008f 1c000a        	addw	x,#OFST-6
 455  0092 9f            	ld	a,xl
 456  0093 5e            	swapw	x
 457  0094 1b12          	add	a,(OFST+2,sp)
 458  0096 2401          	jrnc	L03
 459  0098 5c            	incw	x
 460  0099               L03:
 461  0099 02            	rlwa	x,a
 462  009a f6            	ld	a,(x)
 463  009b 85            	popw	x
 464  009c f7            	ld	(x),a
 465                     ; 114 		i--;
 467  009d 0a10          	dec	(OFST+0,sp)
 469                     ; 115 		pos++;
 471  009f 0c03          	inc	(OFST-13,sp)
 473  00a1               L102:
 474                     ; 111 	while (i > 0)
 476  00a1 7b10          	ld	a,(OFST+0,sp)
 477  00a3 26e1          	jrne	L771
 478                     ; 117 	str[pos] = CharDigits[0];	//put most significant char to the string (even if it's 0)
 480  00a5 7b03          	ld	a,(OFST-13,sp)
 481  00a7 5f            	clrw	x
 482  00a8 97            	ld	xl,a
 483  00a9 72fb11        	addw	x,(OFST+1,sp)
 484  00ac 7b08          	ld	a,(OFST-8,sp)
 485  00ae f7            	ld	(x),a
 486                     ; 118 	str[++pos] = '\0';	//null must be added at the end of string
 488  00af 0c03          	inc	(OFST-13,sp)
 490  00b1 5f            	clrw	x
 491  00b2 7b03          	ld	a,(OFST-13,sp)
 492  00b4 97            	ld	xl,a
 493  00b5 72fb11        	addw	x,(OFST+1,sp)
 494  00b8 7f            	clr	(x)
 495                     ; 119 }
 498  00b9 5b12          	addw	sp,#18
 499  00bb 81            	ret	
 533                     ; 123 char convertDigit(u8 digit)
 533                     ; 124 {
 534                     .text:	section	.text,new
 535  0000               _convertDigit:
 537       00000000      OFST:	set	0
 540                     ; 125 	if ((digit >= 0) && (digit <= 9))		//0 to 9
 542  0000 a10a          	cp	a,#10
 543  0002 2403          	jruge	L322
 544                     ; 126 		return (digit+48);
 546  0004 ab30          	add	a,#48
 549  0006 81            	ret	
 550  0007               L322:
 551                     ; 127 	if ((digit >= 10) && (digit <= 15))	//A to F
 553  0007 a10a          	cp	a,#10
 554  0009 2506          	jrult	L522
 556  000b a110          	cp	a,#16
 557  000d 2402          	jruge	L522
 558                     ; 128 		return (digit+55);
 560  000f ab37          	add	a,#55
 563  0011               L522:
 564                     ; 129 }
 567  0011 81            	ret	
 647                     	switch	.const
 648  0008               L63:
 649  0008 0000000a      	dc.l	10
 650                     ; 133 void Int2str(char str[11], u32 intnum)
 650                     ; 134 {
 651                     .text:	section	.text,new
 652  0000               _Int2str:
 654  0000 89            	pushw	x
 655  0001 5207          	subw	sp,#7
 656       00000007      OFST:	set	7
 659                     ; 136 		u8 j = 0;
 661  0003 0f06          	clr	(OFST-1,sp)
 663                     ; 137 		u8 Status = 0;
 665  0005 0f01          	clr	(OFST-6,sp)
 667                     ; 138 		u32 Div = 1000000000;
 669  0007 aeca00        	ldw	x,#51712
 670  000a 1f04          	ldw	(OFST-3,sp),x
 671  000c ae3b9a        	ldw	x,#15258
 672  000f 1f02          	ldw	(OFST-5,sp),x
 674                     ; 140 		for (i=0; i<10; i++) str[i] = '0';	//initialize string with zeros
 676  0011 4f            	clr	a
 677  0012 6b07          	ld	(OFST+0,sp),a
 679  0014               L172:
 682  0014 5f            	clrw	x
 683  0015 97            	ld	xl,a
 684  0016 72fb08        	addw	x,(OFST+1,sp)
 685  0019 a630          	ld	a,#48
 686  001b f7            	ld	(x),a
 689  001c 0c07          	inc	(OFST+0,sp)
 693  001e 7b07          	ld	a,(OFST+0,sp)
 694  0020 a10a          	cp	a,#10
 695  0022 25f0          	jrult	L172
 696                     ; 142     for (i=0; i<10; i++)
 698  0024 0f07          	clr	(OFST+0,sp)
 700  0026               L772:
 701                     ; 144       str[j++] = (intnum / Div) + 48;	//start from the most significant digit
 703  0026 96            	ldw	x,sp
 704  0027 1c000c        	addw	x,#OFST+5
 705  002a cd0000        	call	c_ltor
 707  002d 96            	ldw	x,sp
 708  002e 1c0002        	addw	x,#OFST-5
 709  0031 cd0000        	call	c_ludv
 711  0034 a630          	ld	a,#48
 712  0036 cd0000        	call	c_ladc
 714  0039 7b06          	ld	a,(OFST-1,sp)
 715  003b 0c06          	inc	(OFST-1,sp)
 717  003d 5f            	clrw	x
 718  003e 97            	ld	xl,a
 719  003f 72fb08        	addw	x,(OFST+1,sp)
 720  0042 b603          	ld	a,c_lreg+3
 721  0044 f7            	ld	(x),a
 722                     ; 145       intnum = intnum % Div;	//save the rest 
 724  0045 96            	ldw	x,sp
 725  0046 1c000c        	addw	x,#OFST+5
 726  0049 cd0000        	call	c_ltor
 728  004c 96            	ldw	x,sp
 729  004d 1c0002        	addw	x,#OFST-5
 730  0050 cd0000        	call	c_lumd
 732  0053 96            	ldw	x,sp
 733  0054 1c000c        	addw	x,#OFST+5
 734  0057 cd0000        	call	c_rtol
 736                     ; 146       Div /= 10;	//reduce divider by one zero
 738  005a 96            	ldw	x,sp
 739  005b 1c0002        	addw	x,#OFST-5
 740  005e cd0000        	call	c_ltor
 742  0061 ae0008        	ldw	x,#L63
 743  0064 cd0000        	call	c_ludv
 745  0067 96            	ldw	x,sp
 746  0068 1c0002        	addw	x,#OFST-5
 747  006b cd0000        	call	c_rtol
 750                     ; 147       if ((str[j-1] == '0') & (Status == 0))
 752  006e 7b06          	ld	a,(OFST-1,sp)
 753  0070 5f            	clrw	x
 754  0071 97            	ld	xl,a
 755  0072 5a            	decw	x
 756  0073 72fb08        	addw	x,(OFST+1,sp)
 757  0076 f6            	ld	a,(x)
 758  0077 a130          	cp	a,#48
 759  0079 2608          	jrne	L503
 761  007b 7b01          	ld	a,(OFST-6,sp)
 762  007d 2604          	jrne	L503
 763                     ; 148         j = 0;	//ignore starting zeros
 765  007f 6b06          	ld	(OFST-1,sp),a
 768  0081 2002          	jra	L703
 769  0083               L503:
 770                     ; 150         Status++;	//indicate significant chars has started
 772  0083 0c01          	inc	(OFST-6,sp)
 774  0085               L703:
 775                     ; 142     for (i=0; i<10; i++)
 777  0085 0c07          	inc	(OFST+0,sp)
 781  0087 7b07          	ld	a,(OFST+0,sp)
 782  0089 a10a          	cp	a,#10
 783  008b 2599          	jrult	L772
 784                     ; 152 		str[j] = '\0';	//null must be added at the end of string
 786  008d 7b06          	ld	a,(OFST-1,sp)
 787  008f 5f            	clrw	x
 788  0090 97            	ld	xl,a
 789  0091 72fb08        	addw	x,(OFST+1,sp)
 790  0094 7f            	clr	(x)
 791                     ; 153 }
 794  0095 5b09          	addw	sp,#9
 795  0097 81            	ret	
 826                     ; 157 void TransmitData(void)
 826                     ; 158 {
 827                     .text:	section	.text,new
 828  0000               _TransmitData:
 832                     ; 159 	Int2str(strNum, frequency);
 834  0000 be00          	ldw	x,_frequency
 835  0002 cd0000        	call	c_uitolx
 837  0005 be02          	ldw	x,c_lreg+2
 838  0007 89            	pushw	x
 839  0008 be00          	ldw	x,c_lreg
 840  000a 89            	pushw	x
 841  000b ae0000        	ldw	x,#_strNum
 842  000e cd0000        	call	_Int2str
 844  0011 5b04          	addw	sp,#4
 845                     ; 160 	UART1_PutString(strNum, NO_NL);
 847  0013 4b00          	push	#0
 848  0015 ae0000        	ldw	x,#_strNum
 849  0018 cd0000        	call	_UART1_PutString
 851  001b 84            	pop	a
 852                     ; 161 	UART1_PutString("\x09", NO_NL);
 854  001c 4b00          	push	#0
 855  001e ae0018        	ldw	x,#L123
 856  0021 cd0000        	call	_UART1_PutString
 858  0024 be00          	ldw	x,_outputVoltage
 859  0026 84            	pop	a
 860                     ; 162 	Hex2str(strNum, (u32)outputVoltage);
 862  0027 cd0000        	call	c_uitolx
 864  002a be02          	ldw	x,c_lreg+2
 865  002c 89            	pushw	x
 866  002d be00          	ldw	x,c_lreg
 867  002f 89            	pushw	x
 868  0030 ae0000        	ldw	x,#_strNum
 869  0033 cd0000        	call	_Hex2str
 871  0036 5b04          	addw	sp,#4
 872                     ; 163 	UART1_PutString(strNum, NO_NL);
 874  0038 4b00          	push	#0
 875  003a ae0000        	ldw	x,#_strNum
 876  003d cd0000        	call	_UART1_PutString
 878  0040 84            	pop	a
 879                     ; 164 	UART1_PutString("\x09", NO_NL);	
 881  0041 4b00          	push	#0
 882  0043 ae0018        	ldw	x,#L123
 883  0046 cd0000        	call	_UART1_PutString
 885  0049 84            	pop	a
 886                     ; 165 	Int2str(strNum, relayCombination);
 888  004a b600          	ld	a,_relayCombination
 889  004c b703          	ld	c_lreg+3,a
 890  004e 3f02          	clr	c_lreg+2
 891  0050 3f01          	clr	c_lreg+1
 892  0052 3f00          	clr	c_lreg
 893  0054 be02          	ldw	x,c_lreg+2
 894  0056 89            	pushw	x
 895  0057 be00          	ldw	x,c_lreg
 896  0059 89            	pushw	x
 897  005a ae0000        	ldw	x,#_strNum
 898  005d cd0000        	call	_Int2str
 900  0060 5b04          	addw	sp,#4
 901                     ; 166 	UART1_PutString(strNum, NO_NL);
 903  0062 4b00          	push	#0
 904  0064 ae0000        	ldw	x,#_strNum
 905  0067 cd0000        	call	_UART1_PutString
 907  006a 84            	pop	a
 908                     ; 167 	UART1_PutString("\x09", NO_NL);	
 910  006b 4b00          	push	#0
 911  006d ae0018        	ldw	x,#L123
 912  0070 cd0000        	call	_UART1_PutString
 914  0073 3d03          	tnz	_relay1+3
 915  0075 84            	pop	a
 916                     ; 168 	if (relay1.state == REL_OFF) UART1_PutString("OFF", NL);
 918  0076 2609          	jrne	L323
 921  0078 4b01          	push	#1
 922  007a ae0014        	ldw	x,#L523
 923  007d cd0000        	call	_UART1_PutString
 925  0080 84            	pop	a
 926  0081               L323:
 927                     ; 169 	if (relay1.state == REL_WAIT) UART1_PutString("WAIT", NL);
 929  0081 b603          	ld	a,_relay1+3
 930  0083 4a            	dec	a
 931  0084 2609          	jrne	L723
 934  0086 4b01          	push	#1
 935  0088 ae000f        	ldw	x,#L133
 936  008b cd0000        	call	_UART1_PutString
 938  008e 84            	pop	a
 939  008f               L723:
 940                     ; 170 	if (relay1.state == REL_ON) UART1_PutString("ON", NL);
 942  008f b603          	ld	a,_relay1+3
 943  0091 a102          	cp	a,#2
 944  0093 2609          	jrne	L333
 947  0095 4b01          	push	#1
 948  0097 ae000c        	ldw	x,#L533
 949  009a cd0000        	call	_UART1_PutString
 951  009d 84            	pop	a
 952  009e               L333:
 953                     ; 171 }
 956  009e 81            	ret	
 981                     	xdef	_convertDigit
 982                     	xdef	_UART1_PutChar
 983                     	switch	.ubsct
 984  0000               _strNum:
 985  0000 000000000000  	ds.b	11
 986                     	xdef	_strNum
 987                     	xdef	_TransmitData
 988                     	xdef	_Int2str
 989                     	xdef	_Hex2str
 990                     	xdef	_UART1_PutString
 991                     	xdef	_UART1_Config
 992                     	xref.b	_relay1
 993                     	xref.b	_frequency
 994                     	xref.b	_outputVoltage
 995                     	xref.b	_relayCombination
 996                     	switch	.const
 997  000c               L533:
 998  000c 4f4e00        	dc.b	"ON",0
 999  000f               L133:
1000  000f 5741495400    	dc.b	"WAIT",0
1001  0014               L523:
1002  0014 4f464600      	dc.b	"OFF",0
1003  0018               L123:
1004  0018 0900          	dc.b	9,0
1005                     	xref.b	c_lreg
1006                     	xref.b	c_x
1026                     	xref	c_uitolx
1027                     	xref	c_rtol
1028                     	xref	c_lumd
1029                     	xref	c_ladc
1030                     	xref	c_ludv
1031                     	xref	c_ltor
1032                     	xref	c_lgursh
1033                     	xref	c_xymov
1034                     	end
