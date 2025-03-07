   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     	bsct
  19  0000               _blinkTimer:
  20  0000 0000          	dc.w	0
  21                     .bit:	section	.data,bit
  22  0000               _blinkHigh:
  23  0000 00            	dc.b	0
 160                     	xdef	_blinkHigh
 161                     	xdef	_blinkTimer
 162                     	switch	.ubsct
 163  0000               _led7:
 164  0000 00            	ds.b	1
 165                     	xdef	_led7
 166  0001               _led6:
 167  0001 00            	ds.b	1
 168                     	xdef	_led6
 169  0002               _led5:
 170  0002 00            	ds.b	1
 171                     	xdef	_led5
 172  0003               _led4:
 173  0003 00            	ds.b	1
 174                     	xdef	_led4
 175  0004               _led3:
 176  0004 00            	ds.b	1
 177                     	xdef	_led3
 178  0005               _led2:
 179  0005 00            	ds.b	1
 180                     	xdef	_led2
 181  0006               _led1:
 182  0006 00            	ds.b	1
 183                     	xdef	_led1
 203                     	end
