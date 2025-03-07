#ifndef __relay_H
#define __relay_H

#include "stm8s_type.h"
#include "stm8s.h"

typedef enum {REL_OFF, REL_WAIT, REL_ON, REL_TEST, REL_ENTER_ON, REL_ENTER_WAIT, REL_YG} relay_state;

typedef struct relay_struct			
{
	// status flags
	volatile _Bool voltageOK;
	volatile _Bool notOFF;
	volatile _Bool intDelayOK;
	volatile _Bool tempOK;
	volatile _Bool energySavingMode;
	volatile _Bool sensitivityOK;
	volatile _Bool testMode;	//pulled low when SWIM pin pulled low
	volatile _Bool relayON;		//physical state of relay
	
	// options
	volatile _Bool voltProtEnabled;		//voltage protection enable (if not then no switching)
	volatile _Bool tempEnabled;				//temperature dependance enable flag 
	volatile _Bool defrostEnabled;		
	volatile _Bool condensorBlockDetectEnabled;
	volatile _Bool offDetectEnabled;	//intelligent (hardware) delay enable flag (used to recover after power loss)
	volatile _Bool intDelayEnabled;
	volatile _Bool probeFaultDetectEnabled;
	volatile _Bool aspEnabled;
	volatile _Bool sensitivityEnabled;		//adaptable sensitivity setting to limit number of switching per hour
	
	volatile relay_state state;
	
	// settings
	volatile u16 LVD;
	volatile u16 fastLVD;
	volatile u16 HVD;
	volatile u16 fastHVD;
	
	volatile u16 LVR;
	volatile u16 HVR;

	// timers
	volatile u16 nsec;					//time couter incremented every s. Used to measure reconnect delays
	volatile u32 milliSec;		//time counter incremented every ms. used to measure blind times
	volatile u16 waitDelay;		//delay before reconnecting
	volatile u16 uVBlindTime;	//undervoltage blind time
	volatile u16 oVBlindTime;	//overvoltage blind time
	
	// function pointer
	void (*enableRelay)(void);
	void (*disableRelay)(void);
}																	
Relay;


#endif	// __relay_H