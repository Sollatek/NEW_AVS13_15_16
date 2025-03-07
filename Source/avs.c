#include "stm8s.h"
#include "stm8s_type.h"
#include "timers.h"
#include "adc.h"
#include "globals.h"
#include "options.h"


//public functions
void updateAVSState(Relay *);
void updateIntDelay(void);

//public variables
avs_state_type avs_state = AVS_LVR;
u16 IntDelaySecs;
u16 IntDelayADCLevel;
extern u8 ledCount;

//private functions


//private variables
const u16 IntDelayADCTable[301];

//------------------------------------------------------------------------------------------------------------------------

//updates avs state (used by led handler)
void updateAVSState(Relay *rel)
{
	static _Bool isButtonDown;
	
	//if ((avs_state == AVS_INIT) && (IntDelaySecs == MANUAL_MODE_SECS))
	//	avs_state = AVS_MAN_OFF;
	
	switch (rel->state){
	case REL_OFF:
	default:
	ledCount = LED_7;
		//if (pot set to manual)
		//avs_state = AVS_MAN_OFF;
		if (outputVoltage < rel->LVD)
		{
			avs_state = AVS_LVD;
			ledCount = LED_4;
		}
		else if (outputVoltage > rel->HVD)
		{
			avs_state = AVS_HVD;
			ledCount = LED_3;
		}
		break;
	
	case REL_WAIT:
		if (avs_state == AVS_LVD)
		{
			avs_state = AVS_LVR;
		}
		else if (avs_state == AVS_HVD)
		{
			avs_state = AVS_HVR;
		}
		ledCount = LED_5;
		break;
			
	case REL_ON:
		if (IntDelaySecs == MANUAL_MODE_SECS)
		{
			avs_state = AVS_MAN_ON;
		}
		else
		{
			avs_state = AVS_ON;
		}
		ledCount = LED_6;
	}
	
	//button is sensitove to pressing, not releasing
	if (!isButtonPressed2())	//if I/0 reads high..was sw1 2025
		isButtonDown = FALSE;	//..button not pressed
	else if (!isButtonDown)
	{
		isButtonDown = TRUE;	//every time button is down we toggle switch state
		isSwitchOn = !isSwitchOn;
	}
		
}
//------------------------------------------------------------------------------------------------------------------------

//reads pot position and adjusts Intelligent delay accordingly
void updateIntDelay(void)
{
	u16 potADC = 1;//getPotADC();
	
	if (potADC >= MANUAL_MODE_ADC)		//pot fully clockwise
		IntDelaySecs = MANUAL_MODE_SECS;
	else if (potADC <= MIN_DELAY_MODE)
		IntDelaySecs = 0;		//only std delay if pot fully anticlockwise
	else
	{
		//pot position is calculated using linear trendlines of actual ADC vs label function (see "Pot calculations.xls")
		if (*EEPROM_AVS_TYPE == AVS13_FLAG)
			IntDelaySecs = (potADC * 17) / 10 + 115;		//result in sec x10
		else	
			IntDelaySecs = (potADC * 2) + 1077;				//result in sec x10
		IntDelaySecs = (IntDelaySecs + 5) / 10;			//result in seconds (rounded)
		if (IntDelaySecs < randomStandardDelay)	//additional condition check for std delay only mode
			IntDelaySecs = 0;
		else
			IntDelaySecs -= randomStandardDelay;	//standard dealy is always added after intelligent delay so we need to subtract it from it delay
	}
	
	if (IntDelaySecs > 300)		//covers 0xFFFF (manual mode) and any unexpected value above 5 min
	{
		IntDelaySecs = MANUAL_MODE_SECS;
		IntDelayADCLevel = IntDelayADCTable[randomStandardDelay];	//in manual mode there is only intelligent delay = standard delay (no std delay after that)
	}
	else
		IntDelayADCLevel = IntDelayADCTable[IntDelaySecs];
}
//------------------------------------------------------------------------------------------------------------------------

//lookup table for intelligent delay ADC
const u16 IntDelayADCTable[301] = {
0,
93,
101,
109,
116,
124,
131,
139,
146,
153,
161,
168,
175,
182,
189,
196,
203,
209,
216,
223,
230,
236,
243,
249,
256,
262,
268,
275,
281,
287,
293,
299,
305,
311,
317,
323,
329,
334,
340,
346,
351,
357,
363,
368,
373,
379,
384,
389,
395,
400,
405,
410,
415,
420,
425,
430,
435,
440,
445,
450,
455,
459,
464,
469,
473,
478,
482,
487,
491,
496,
500,
504,
509,
513,
517,
521,
526,
530,
534,
538,
542,
546,
550,
554,
558,
562,
565,
569,
573,
577,
580,
584,
588,
591,
595,
599,
602,
606,
609,
612,
616,
619,
623,
626,
629,
632,
636,
639,
642,
645,
648,
652,
655,
658,
661,
664,
667,
670,
673,
676,
678,
681,
684,
687,
690,
693,
695,
698,
701,
703,
706,
709,
711,
714,
716,
719,
722,
724,
726,
729,
731,
734,
736,
739,
741,
743,
746,
748,
750,
753,
755,
757,
759,
761,
764,
766,
768,
770,
772,
774,
776,
778,
780,
782,
784,
786,
788,
790,
792,
794,
796,
798,
800,
802,
803,
805,
807,
809,
811,
812,
814,
816,
818,
819,
821,
823,
824,
826,
828,
829,
831,
833,
834,
836,
837,
839,
840,
842,
843,
845,
846,
848,
849,
851,
852,
854,
855,
856,
858,
859,
861,
862,
863,
865,
866,
867,
868,
870,
871,
872,
874,
875,
876,
877,
878,
880,
881,
882,
883,
884,
886,
887,
888,
889,
890,
891,
892,
893,
894,
895,
897,
898,
899,
900,
901,
902,
903,
904,
905,
906,
907,
908,
909,
910,
911,
911,
912,
913,
914,
915,
916,
917,
918,
919,
920,
920,
921,
922,
923,
924,
925,
925,
926,
927,
928,
929,
929,
930,
931,
932,
933,
933,
934,
935,
936,
936,
937,
938,
938,
939,
940,
941,
941,
942,
943,
943,
944,
945,
945,
946,
947
};

