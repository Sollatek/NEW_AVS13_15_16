   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
   4                     ; Optimizer V4.6.3 - 22 Aug 2024
  18                     	bsct
  19  0000               _avs_state:
  20  0000 03            	dc.b	3
  21                     .bit:	section	.data,bit
  22  0000               L3_isButtonDown:
  23  0000 00            	ds.b	1
 447                     ; 28 void updateAVSState(Relay *rel)
 447                     ; 29 {
 449                     .text:	section	.text,new
 450  0000               _updateAVSState:
 452  0000 89            	pushw	x
 453       00000000      OFST:	set	0
 456                     ; 35 	switch (rel->state){
 458  0001 e603          	ld	a,(3,x)
 460                     ; 74 		ledCount = LED_6;
 461  0003 2706          	jreq	L5
 462  0005 4a            	dec	a
 463  0006 272f          	jreq	L7
 464  0008 4a            	dec	a
 465  0009 2746          	jreq	L11
 466  000b               L5:
 467                     ; 36 	case REL_OFF:
 467                     ; 37 	default:
 467                     ; 38 	ledCount = LED_7;
 469  000b 35070000      	mov	_ledCount,#7
 470                     ; 41 		if (outputVoltage < rel->LVD)
 472  000f 9093          	ldw	y,x
 473  0011 90ee04        	ldw	y,(4,y)
 474  0014 90b300        	cpw	y,_outputVoltage
 475  0017 230a          	jrule	L372
 476                     ; 43 			avs_state = AVS_LVD;
 478  0019 35020000      	mov	_avs_state,#2
 479                     ; 44 			ledCount = LED_4;
 481  001d 35040000      	mov	_ledCount,#4
 483  0021 2041          	jra	L172
 484  0023               L372:
 485                     ; 46 		else if (outputVoltage > rel->HVD)
 487  0023 9093          	ldw	y,x
 488  0025 90ee08        	ldw	y,(8,y)
 489  0028 90b300        	cpw	y,_outputVoltage
 490  002b 2437          	jruge	L172
 491                     ; 48 			avs_state = AVS_HVD;
 493  002d 35050000      	mov	_avs_state,#5
 494                     ; 49 			ledCount = LED_3;
 496  0031 35030000      	mov	_ledCount,#3
 497  0035 202d          	jra	L172
 498  0037               L7:
 499                     ; 53 	case REL_WAIT:
 499                     ; 54 		if (avs_state == AVS_LVD)
 501  0037 b600          	ld	a,_avs_state
 502  0039 a102          	cp	a,#2
 503  003b 2606          	jrne	L103
 504                     ; 56 			avs_state = AVS_LVR;
 506  003d 35030000      	mov	_avs_state,#3
 508  0041 2008          	jra	L303
 509  0043               L103:
 510                     ; 58 		else if (avs_state == AVS_HVD)
 512  0043 a105          	cp	a,#5
 513  0045 2604          	jrne	L303
 514                     ; 60 			avs_state = AVS_HVR;
 516  0047 35040000      	mov	_avs_state,#4
 517  004b               L303:
 518                     ; 62 		ledCount = LED_5;
 520  004b 35050000      	mov	_ledCount,#5
 521                     ; 63 		break;
 523  004f 2013          	jra	L172
 524  0051               L11:
 525                     ; 65 	case REL_ON:
 525                     ; 66 		if (IntDelaySecs == MANUAL_MODE_SECS)
 527  0051 be02          	ldw	x,_IntDelaySecs
 528  0053 5c            	incw	x
 529  0054 2606          	jrne	L703
 530                     ; 68 			avs_state = AVS_MAN_ON;
 532  0056 35070000      	mov	_avs_state,#7
 534  005a 2004          	jra	L113
 535  005c               L703:
 536                     ; 72 			avs_state = AVS_ON;
 538  005c 35010000      	mov	_avs_state,#1
 539  0060               L113:
 540                     ; 74 		ledCount = LED_6;
 542  0060 35060000      	mov	_ledCount,#6
 543  0064               L172:
 544                     ; 78 	if (!isButtonPressed2())	//if I/0 reads high..was sw1 2025
 546  0064 cd0000        	call	_isButtonPressed2
 548  0067 4d            	tnz	a
 549  0068 2606          	jrne	L313
 550                     ; 79 		isButtonDown = FALSE;	//..button not pressed
 552  006a 72110000      	bres	L3_isButtonDown
 554  006e 2014          	jra	L513
 555  0070               L313:
 556                     ; 80 	else if (!isButtonDown)
 558  0070 720000000f    	btjt	L3_isButtonDown,L513
 559                     ; 82 		isButtonDown = TRUE;	//every time button is down we toggle switch state
 561  0075 72100000      	bset	L3_isButtonDown
 562                     ; 83 		isSwitchOn = !isSwitchOn;
 564  0079 3d00          	tnz	_isSwitchOn
 565  007b 2604          	jrne	L21
 566  007d a601          	ld	a,#1
 567  007f 2001          	jra	L41
 568  0081               L21:
 569  0081 4f            	clr	a
 570  0082               L41:
 571  0082 b700          	ld	_isSwitchOn,a
 572  0084               L513:
 573                     ; 86 }
 576  0084 85            	popw	x
 577  0085 81            	ret	
 615                     ; 90 void updateIntDelay(void)
 615                     ; 91 {
 616                     .text:	section	.text,new
 617  0000               _updateIntDelay:
 619       00000002      OFST:	set	2
 622                     ; 92 	u16 potADC = 1;//getPotADC();
 624                     ; 97 		IntDelaySecs = 0;		//only std delay if pot fully anticlockwise
 626  0000 5f            	clrw	x
 627  0001 bf02          	ldw	_IntDelaySecs,x
 628                     ; 118 		IntDelayADCLevel = IntDelayADCTable[IntDelaySecs];
 630  0003 ce0000        	ldw	x,_IntDelayADCTable
 631  0006 bf00          	ldw	_IntDelayADCLevel,x
 632                     ; 119 }
 635  0008 81            	ret	
 638                     .const:	section	.text
 639  0000               _IntDelayADCTable:
 640  0000 0000          	dc.w	0
 641  0002 005d          	dc.w	93
 642  0004 0065          	dc.w	101
 643  0006 006d          	dc.w	109
 644  0008 0074          	dc.w	116
 645  000a 007c          	dc.w	124
 646  000c 0083          	dc.w	131
 647  000e 008b          	dc.w	139
 648  0010 0092          	dc.w	146
 649  0012 0099          	dc.w	153
 650  0014 00a1          	dc.w	161
 651  0016 00a8          	dc.w	168
 652  0018 00af          	dc.w	175
 653  001a 00b6          	dc.w	182
 654  001c 00bd          	dc.w	189
 655  001e 00c4          	dc.w	196
 656  0020 00cb          	dc.w	203
 657  0022 00d1          	dc.w	209
 658  0024 00d8          	dc.w	216
 659  0026 00df          	dc.w	223
 660  0028 00e6          	dc.w	230
 661  002a 00ec          	dc.w	236
 662  002c 00f3          	dc.w	243
 663  002e 00f9          	dc.w	249
 664  0030 0100          	dc.w	256
 665  0032 0106          	dc.w	262
 666  0034 010c          	dc.w	268
 667  0036 0113          	dc.w	275
 668  0038 0119          	dc.w	281
 669  003a 011f          	dc.w	287
 670  003c 0125          	dc.w	293
 671  003e 012b          	dc.w	299
 672  0040 0131          	dc.w	305
 673  0042 0137          	dc.w	311
 674  0044 013d          	dc.w	317
 675  0046 0143          	dc.w	323
 676  0048 0149          	dc.w	329
 677  004a 014e          	dc.w	334
 678  004c 0154          	dc.w	340
 679  004e 015a          	dc.w	346
 680  0050 015f          	dc.w	351
 681  0052 0165          	dc.w	357
 682  0054 016b          	dc.w	363
 683  0056 0170          	dc.w	368
 684  0058 0175          	dc.w	373
 685  005a 017b          	dc.w	379
 686  005c 0180          	dc.w	384
 687  005e 0185          	dc.w	389
 688  0060 018b          	dc.w	395
 689  0062 0190          	dc.w	400
 690  0064 0195          	dc.w	405
 691  0066 019a          	dc.w	410
 692  0068 019f          	dc.w	415
 693  006a 01a4          	dc.w	420
 694  006c 01a9          	dc.w	425
 695  006e 01ae          	dc.w	430
 696  0070 01b3          	dc.w	435
 697  0072 01b8          	dc.w	440
 698  0074 01bd          	dc.w	445
 699  0076 01c2          	dc.w	450
 700  0078 01c7          	dc.w	455
 701  007a 01cb          	dc.w	459
 702  007c 01d0          	dc.w	464
 703  007e 01d5          	dc.w	469
 704  0080 01d9          	dc.w	473
 705  0082 01de          	dc.w	478
 706  0084 01e2          	dc.w	482
 707  0086 01e7          	dc.w	487
 708  0088 01eb          	dc.w	491
 709  008a 01f0          	dc.w	496
 710  008c 01f4          	dc.w	500
 711  008e 01f8          	dc.w	504
 712  0090 01fd          	dc.w	509
 713  0092 0201          	dc.w	513
 714  0094 0205          	dc.w	517
 715  0096 0209          	dc.w	521
 716  0098 020e          	dc.w	526
 717  009a 0212          	dc.w	530
 718  009c 0216          	dc.w	534
 719  009e 021a          	dc.w	538
 720  00a0 021e          	dc.w	542
 721  00a2 0222          	dc.w	546
 722  00a4 0226          	dc.w	550
 723  00a6 022a          	dc.w	554
 724  00a8 022e          	dc.w	558
 725  00aa 0232          	dc.w	562
 726  00ac 0235          	dc.w	565
 727  00ae 0239          	dc.w	569
 728  00b0 023d          	dc.w	573
 729  00b2 0241          	dc.w	577
 730  00b4 0244          	dc.w	580
 731  00b6 0248          	dc.w	584
 732  00b8 024c          	dc.w	588
 733  00ba 024f          	dc.w	591
 734  00bc 0253          	dc.w	595
 735  00be 0257          	dc.w	599
 736  00c0 025a          	dc.w	602
 737  00c2 025e          	dc.w	606
 738  00c4 0261          	dc.w	609
 739  00c6 0264          	dc.w	612
 740  00c8 0268          	dc.w	616
 741  00ca 026b          	dc.w	619
 742  00cc 026f          	dc.w	623
 743  00ce 0272          	dc.w	626
 744  00d0 0275          	dc.w	629
 745  00d2 0278          	dc.w	632
 746  00d4 027c          	dc.w	636
 747  00d6 027f          	dc.w	639
 748  00d8 0282          	dc.w	642
 749  00da 0285          	dc.w	645
 750  00dc 0288          	dc.w	648
 751  00de 028c          	dc.w	652
 752  00e0 028f          	dc.w	655
 753  00e2 0292          	dc.w	658
 754  00e4 0295          	dc.w	661
 755  00e6 0298          	dc.w	664
 756  00e8 029b          	dc.w	667
 757  00ea 029e          	dc.w	670
 758  00ec 02a1          	dc.w	673
 759  00ee 02a4          	dc.w	676
 760  00f0 02a6          	dc.w	678
 761  00f2 02a9          	dc.w	681
 762  00f4 02ac          	dc.w	684
 763  00f6 02af          	dc.w	687
 764  00f8 02b2          	dc.w	690
 765  00fa 02b5          	dc.w	693
 766  00fc 02b7          	dc.w	695
 767  00fe 02ba          	dc.w	698
 768  0100 02bd          	dc.w	701
 769  0102 02bf          	dc.w	703
 770  0104 02c2          	dc.w	706
 771  0106 02c5          	dc.w	709
 772  0108 02c7          	dc.w	711
 773  010a 02ca          	dc.w	714
 774  010c 02cc          	dc.w	716
 775  010e 02cf          	dc.w	719
 776  0110 02d2          	dc.w	722
 777  0112 02d4          	dc.w	724
 778  0114 02d6          	dc.w	726
 779  0116 02d9          	dc.w	729
 780  0118 02db          	dc.w	731
 781  011a 02de          	dc.w	734
 782  011c 02e0          	dc.w	736
 783  011e 02e3          	dc.w	739
 784  0120 02e5          	dc.w	741
 785  0122 02e7          	dc.w	743
 786  0124 02ea          	dc.w	746
 787  0126 02ec          	dc.w	748
 788  0128 02ee          	dc.w	750
 789  012a 02f1          	dc.w	753
 790  012c 02f3          	dc.w	755
 791  012e 02f5          	dc.w	757
 792  0130 02f7          	dc.w	759
 793  0132 02f9          	dc.w	761
 794  0134 02fc          	dc.w	764
 795  0136 02fe          	dc.w	766
 796  0138 0300          	dc.w	768
 797  013a 0302          	dc.w	770
 798  013c 0304          	dc.w	772
 799  013e 0306          	dc.w	774
 800  0140 0308          	dc.w	776
 801  0142 030a          	dc.w	778
 802  0144 030c          	dc.w	780
 803  0146 030e          	dc.w	782
 804  0148 0310          	dc.w	784
 805  014a 0312          	dc.w	786
 806  014c 0314          	dc.w	788
 807  014e 0316          	dc.w	790
 808  0150 0318          	dc.w	792
 809  0152 031a          	dc.w	794
 810  0154 031c          	dc.w	796
 811  0156 031e          	dc.w	798
 812  0158 0320          	dc.w	800
 813  015a 0322          	dc.w	802
 814  015c 0323          	dc.w	803
 815  015e 0325          	dc.w	805
 816  0160 0327          	dc.w	807
 817  0162 0329          	dc.w	809
 818  0164 032b          	dc.w	811
 819  0166 032c          	dc.w	812
 820  0168 032e          	dc.w	814
 821  016a 0330          	dc.w	816
 822  016c 0332          	dc.w	818
 823  016e 0333          	dc.w	819
 824  0170 0335          	dc.w	821
 825  0172 0337          	dc.w	823
 826  0174 0338          	dc.w	824
 827  0176 033a          	dc.w	826
 828  0178 033c          	dc.w	828
 829  017a 033d          	dc.w	829
 830  017c 033f          	dc.w	831
 831  017e 0341          	dc.w	833
 832  0180 0342          	dc.w	834
 833  0182 0344          	dc.w	836
 834  0184 0345          	dc.w	837
 835  0186 0347          	dc.w	839
 836  0188 0348          	dc.w	840
 837  018a 034a          	dc.w	842
 838  018c 034b          	dc.w	843
 839  018e 034d          	dc.w	845
 840  0190 034e          	dc.w	846
 841  0192 0350          	dc.w	848
 842  0194 0351          	dc.w	849
 843  0196 0353          	dc.w	851
 844  0198 0354          	dc.w	852
 845  019a 0356          	dc.w	854
 846  019c 0357          	dc.w	855
 847  019e 0358          	dc.w	856
 848  01a0 035a          	dc.w	858
 849  01a2 035b          	dc.w	859
 850  01a4 035d          	dc.w	861
 851  01a6 035e          	dc.w	862
 852  01a8 035f          	dc.w	863
 853  01aa 0361          	dc.w	865
 854  01ac 0362          	dc.w	866
 855  01ae 0363          	dc.w	867
 856  01b0 0364          	dc.w	868
 857  01b2 0366          	dc.w	870
 858  01b4 0367          	dc.w	871
 859  01b6 0368          	dc.w	872
 860  01b8 036a          	dc.w	874
 861  01ba 036b          	dc.w	875
 862  01bc 036c          	dc.w	876
 863  01be 036d          	dc.w	877
 864  01c0 036e          	dc.w	878
 865  01c2 0370          	dc.w	880
 866  01c4 0371          	dc.w	881
 867  01c6 0372          	dc.w	882
 868  01c8 0373          	dc.w	883
 869  01ca 0374          	dc.w	884
 870  01cc 0376          	dc.w	886
 871  01ce 0377          	dc.w	887
 872  01d0 0378          	dc.w	888
 873  01d2 0379          	dc.w	889
 874  01d4 037a          	dc.w	890
 875  01d6 037b          	dc.w	891
 876  01d8 037c          	dc.w	892
 877  01da 037d          	dc.w	893
 878  01dc 037e          	dc.w	894
 879  01de 037f          	dc.w	895
 880  01e0 0381          	dc.w	897
 881  01e2 0382          	dc.w	898
 882  01e4 0383          	dc.w	899
 883  01e6 0384          	dc.w	900
 884  01e8 0385          	dc.w	901
 885  01ea 0386          	dc.w	902
 886  01ec 0387          	dc.w	903
 887  01ee 0388          	dc.w	904
 888  01f0 0389          	dc.w	905
 889  01f2 038a          	dc.w	906
 890  01f4 038b          	dc.w	907
 891  01f6 038c          	dc.w	908
 892  01f8 038d          	dc.w	909
 893  01fa 038e          	dc.w	910
 894  01fc 038f          	dc.w	911
 895  01fe 038f          	dc.w	911
 896  0200 0390          	dc.w	912
 897  0202 0391          	dc.w	913
 898  0204 0392          	dc.w	914
 899  0206 0393          	dc.w	915
 900  0208 0394          	dc.w	916
 901  020a 0395          	dc.w	917
 902  020c 0396          	dc.w	918
 903  020e 0397          	dc.w	919
 904  0210 0398          	dc.w	920
 905  0212 0398          	dc.w	920
 906  0214 0399          	dc.w	921
 907  0216 039a          	dc.w	922
 908  0218 039b          	dc.w	923
 909  021a 039c          	dc.w	924
 910  021c 039d          	dc.w	925
 911  021e 039d          	dc.w	925
 912  0220 039e          	dc.w	926
 913  0222 039f          	dc.w	927
 914  0224 03a0          	dc.w	928
 915  0226 03a1          	dc.w	929
 916  0228 03a1          	dc.w	929
 917  022a 03a2          	dc.w	930
 918  022c 03a3          	dc.w	931
 919  022e 03a4          	dc.w	932
 920  0230 03a5          	dc.w	933
 921  0232 03a5          	dc.w	933
 922  0234 03a6          	dc.w	934
 923  0236 03a7          	dc.w	935
 924  0238 03a8          	dc.w	936
 925  023a 03a8          	dc.w	936
 926  023c 03a9          	dc.w	937
 927  023e 03aa          	dc.w	938
 928  0240 03aa          	dc.w	938
 929  0242 03ab          	dc.w	939
 930  0244 03ac          	dc.w	940
 931  0246 03ad          	dc.w	941
 932  0248 03ad          	dc.w	941
 933  024a 03ae          	dc.w	942
 934  024c 03af          	dc.w	943
 935  024e 03af          	dc.w	943
 936  0250 03b0          	dc.w	944
 937  0252 03b1          	dc.w	945
 938  0254 03b1          	dc.w	945
 939  0256 03b2          	dc.w	946
 940  0258 03b3          	dc.w	947
1053                     	xdef	_IntDelayADCTable
1054                     	xref.b	_ledCount
1055                     	xref.b	_randomStandardDelay
1056                     	xref.b	_isSwitchOn
1057                     	xref.b	_outputVoltage
1058                     	xref	_isButtonPressed2
1059                     	switch	.ubsct
1060  0000               _IntDelayADCLevel:
1061  0000 0000          	ds.b	2
1062                     	xdef	_IntDelayADCLevel
1063  0002               _IntDelaySecs:
1064  0002 0000          	ds.b	2
1065                     	xdef	_IntDelaySecs
1066                     	xdef	_avs_state
1067                     	xdef	_updateIntDelay
1068                     	xdef	_updateAVSState
1088                     	end
