   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  57                     ; 87 void adcInit(void)
  57                     ; 88 {
  59                     .text:	section	.text,new
  60  0000               _adcInit:
  62  0000 88            	push	a
  63       00000001      OFST:	set	1
  66                     ; 89 	u8 delay = 0;
  68  0001 0f01          	clr	(OFST+0,sp)
  70                     ; 90 	ADC1->CSR &= ~ADC1_CSR_EOCIE;					// Disable interrupts
  72  0003 721b5400      	bres	21504,#5
  73                     ; 91 	ADC_CSR_SELECT_CHANNEL(AC_SENSE_ADC_CHANNEL);	// Select channel 3 to start with (AC voltage)
  75  0007 c65400        	ld	a,21504
  76  000a a4f0          	and	a,#240
  77  000c c75400        	ld	21504,a
  78                     ; 93 	ADC1->CR1 &= ~ADC1_CR1_SPSEL;
  80  000f c65401        	ld	a,21505
  81  0012 a48f          	and	a,#143
  82  0014 c75401        	ld	21505,a
  83                     ; 94 	ADC1->CR1 |= SPSEL_MSTR_EIGHTEENTH;		// Select fmaster/18 as prescaler
  85  0017 c65401        	ld	a,21505
  86  001a aa70          	or	a,#112
  87  001c c75401        	ld	21505,a
  88                     ; 95 	ADC1->CR2 |= ADC1_CR2_ALIGN;					// Align result for easy conversion to 10 bit number
  90  001f 72165402      	bset	21506,#3
  91                     ; 97 	ADC1->TDRL = 0x70;										// disable Schmitt trigger on active ADC inputs (AIN4-6)
  93  0023 35705407      	mov	21511,#112
  94                     ; 98 	ADC1->CR1	&= ~ADC1_CR1_CONT;					// Ensure continuous mode is not enabled
  96  0027 72135401      	bres	21505,#1
  97                     ; 99   ADC1->CR1 |= ADC1_CR1_ADON;            // ADC on - power up
  99  002b 72105401      	bset	21505,#0
 101  002f               L13:
 102                     ; 101 	while (delay++ < 21) ;								// delay to stabilise ( 150% of datasheet estimate)
 104  002f 7b01          	ld	a,(OFST+0,sp)
 105  0031 0c01          	inc	(OFST+0,sp)
 107  0033 a115          	cp	a,#21
 108  0035 25f8          	jrult	L13
 109                     ; 103 }
 112  0037 84            	pop	a
 113  0038 81            	ret	
 137                     ; 109 u16 getVoltageADC(void)
 137                     ; 110 {
 138                     .text:	section	.text,new
 139  0000               _getVoltageADC:
 143                     ; 111 	ADCclearEOC;								// clear ADC flag
 145  0000 721f5400      	bres	21504,#7
 146                     ; 112 	ADC_CSR_SELECT_CHANNEL(AC_SENSE_ADC_CHANNEL);	// Select channel 3 (PD2)
 148  0004 c65400        	ld	a,21504
 149  0007 a4f0          	and	a,#240
 150  0009 c75400        	ld	21504,a
 151                     ; 113 	ADCon;											// set next conversion going
 153  000c 72105401      	bset	21505,#0
 155  0010               L74:
 156                     ; 114 	while (!ADCisEOC) ;					// poll for conversion finish	
 158  0010 720f5400fb    	btjf	21504,#7,L74
 159                     ; 115 	return (getADCReading());
 164  0015 cc0000        	jp	_getADCReading
 207                     ; 123 u16 getIntDelay(void)
 207                     ; 124 {
 208                     .text:	section	.text,new
 209  0000               _getIntDelay:
 211  0000 5206          	subw	sp,#6
 212       00000006      OFST:	set	6
 215                     ; 125 	u32 smooth = 100;
 217  0002 ae0064        	ldw	x,#100
 218  0005 1f05          	ldw	(OFST-1,sp),x
 219  0007 5f            	clrw	x
 220  0008 1f03          	ldw	(OFST-3,sp),x
 222                     ; 126 	u16 count = 0;
 224                     ; 135 	smooth >>=4;
 226  000a 96            	ldw	x,sp
 227  000b 1c0003        	addw	x,#OFST-3
 228  000e a604          	ld	a,#4
 229  0010 cd0000        	call	c_lgursh
 232                     ; 136 	return ((u16)smooth);
 234  0013 ae0006        	ldw	x,#6
 237  0016 5b06          	addw	sp,#6
 238  0018 81            	ret	
 281                     ; 144 u16 getPotADC(void)
 281                     ; 145 {
 282                     .text:	section	.text,new
 283  0000               _getPotADC:
 285  0000 5206          	subw	sp,#6
 286       00000006      OFST:	set	6
 289                     ; 146 	u32 smooth = 1;
 291  0002 ae0001        	ldw	x,#1
 292  0005 1f05          	ldw	(OFST-1,sp),x
 293  0007 5f            	clrw	x
 294  0008 1f03          	ldw	(OFST-3,sp),x
 296                     ; 147 	u16 count = 0;
 298                     ; 156 	smooth >>=4;
 300  000a 96            	ldw	x,sp
 301  000b 1c0003        	addw	x,#OFST-3
 302  000e a604          	ld	a,#4
 303  0010 cd0000        	call	c_lgursh
 306                     ; 157 	return (1);//((u16)smooth);
 308  0013 ae0001        	ldw	x,#1
 311  0016 5b06          	addw	sp,#6
 312  0018 81            	ret	
 360                     ; 162 _Bool is12Vbad(void)
 360                     ; 163 {
 361                     .text:	section	.text,new
 362  0000               _is12Vbad:
 364       00000006      OFST:	set	6
 367                     ; 164 	u32 smooth = 0;
 369                     ; 165 	u16 count = 0;
 371                     ; 167 	return(FALSE);//2024
 373  0000 4f            	clr	a
 376  0001 81            	ret	
 428                     ; 191 u16 getADCReading(void)
 428                     ; 192 {
 429                     .text:	section	.text,new
 430  0000               _getADCReading:
 432  0000 5206          	subw	sp,#6
 433       00000006      OFST:	set	6
 436                     ; 193 	vu8 adcLowByte = 0;
 438  0002 0f03          	clr	(OFST-3,sp)
 440                     ; 194 	vu8 adcHighByte = 0;
 442  0004 0f04          	clr	(OFST-2,sp)
 444                     ; 195 	u16 dummy = 0;
 446                     ; 198 	adcLowByte = ADC1->DRL;
 448  0006 c65405        	ld	a,21509
 449  0009 6b03          	ld	(OFST-3,sp),a
 451                     ; 199 	adcHighByte = ADC1->DRH;
 453  000b c65404        	ld	a,21508
 454  000e 6b04          	ld	(OFST-2,sp),a
 456                     ; 200 	dummy = ((u16)adcHighByte)<<8;
 458  0010 7b04          	ld	a,(OFST-2,sp)
 459  0012 97            	ld	xl,a
 460  0013 4f            	clr	a
 461  0014 02            	rlwa	x,a
 462  0015 1f05          	ldw	(OFST-1,sp),x
 464                     ; 201 	dummy += adcLowByte;
 466  0017 7b03          	ld	a,(OFST-3,sp)
 467  0019 5f            	clrw	x
 468  001a 97            	ld	xl,a
 469  001b 1f01          	ldw	(OFST-5,sp),x
 471  001d 72fb05        	addw	x,(OFST-1,sp)
 473                     ; 202 	return (dummy);
 477  0020 5b06          	addw	sp,#6
 478  0022 81            	ret	
 491                     	xdef	_getADCReading
 492                     	xref.b	_strNum
 493                     	xref	_Hex2str
 494                     	xref	_UART1_PutString
 495                     	xdef	_is12Vbad
 496                     	xdef	_getPotADC
 497                     	xdef	_getIntDelay
 498                     	xdef	_getVoltageADC
 499                     	xdef	_adcInit
 518                     	xref	c_lgursh
 519                     	end
