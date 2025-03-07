#ifndef __avs_H
#define __avs_H

typedef enum {AVS_INIT, AVS_ON, AVS_LVD, AVS_LVR, AVS_HVR, AVS_HVD, AVS_MAN_OFF, AVS_MAN_ON} avs_state_type;

#define MANUAL_MODE_ADC		(1005)			//reading above this value means manual mode
#define MIN_DELAY_MODE		(5)					//reading below this value means 15s std delay only
#define MANUAL_MODE_SECS	(0xFFFF)		//int delay value in seconds used to indicate manual mode

#endif	//__avs_H	
