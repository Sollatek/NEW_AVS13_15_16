

/* Define to prevent recursive inclusion -------------------------------------*/

#ifndef __options_H
#define __options_H

#define	FW_VERSION		"AVS13_15V02"	// firmware version transmited via UART (if UART supported)
#define TEST_COUNT    "Count: "

//#define DEBUG										// enables synchronizing scope from pin 3 of port C to watch relays switching
																	// and transmitting all measurements (if UART enabled)
																	// mustn't be defined in production firmware

//Define various relay options and thresholds

	// options
#define VOLTAGE_PROTECTION_ENABLED						(1)
#define TEMPERATURE_PROTECTION_ENABLED				(0)
#define DEFROST_ENABLED												(0)
#define CONDENSOR_BLOCKAGE_DETECTION_ENABLED	(0)
#define OFF_POSITION_DETECT_ENABLED						(0)
#define SENSITIVITY_ENABLED										(0)	//sensitivity not implemented in FSP products
#define TIMESAVE_DELAY_ENABLED								(1)	//new name for intelligent delay
#define PROBE_FAULT_DETECTION_ENABLED					(0)
#define ASP_ENABLED														(0)
#define UART_ENABLED													(1)	//serial communication enabled
#define FIRST_30_MIN_ENABLED									(0)	//disable intelligent delay for first 30 minutes of operation
#define RANDOM_DELAY_ENABLED									(0)	//0 - fixed std delay of STANDARD_WAIT_DELAY_SECS_AVS13 or STANDARD_WAIT_DELAY_SECS_AVS15
																									//1 - random std delay between STANDARD_WAIT_DELAY_SECS_MIN STANDARD_WAIT_DELAY_SECS_MAX

 //Voltage Thresholds - calculated from RMS measurements.xls (column marked yellow)
 //voltage values are calculated in excel spreadsheet and they are 16-bit values calculated for Vcc=5.4V 
 //real measurements are normalized to this value by applying correction factor
//#define LOW_VOLTAGE_EXTREME						(0x13C1)		//95V	- Below this voltage at startup unit should be locked because switching relays may lead to damage
#define LOW_VOLTAGE_DISCONNECT_FAST		(0x348B)		//138V		disabled to prevent disconnecting due to inrush
#define LOW_VOLTAGE_DISCONNECT				(0x5E87)		//185V
#define LOW_VOLTAGE_RECONNECT					(0x63C2)		//190V
#define HIGH_VOLTAGE_DISCONNECT				(0xBB12)		//260V
#define HIGH_VOLTAGE_RECONNECT				(0xB81A)		//258V
#define HIGH_VOLTAGE_DISCONNECT_FAST	(0xD902)		//280V

#define CAL_REF_VOLT									(0x9244)		//230V
//Frequency boundaries in Hz
#define MAX_FREQUENCY		(65)
#define MIN_FREQUENCY		(35)

	//transformer winding ratios for taps (*65536)

	// timers

#define STANDARD_WAIT_DELAY_SECS_MIN		(10)				//low limit for randomised standard delay
#define STANDARD_WAIT_DELAY_SECS_MAX		(30)				//high limit for randomised standard delay
#define UNDERVOLTAGE_BLIND_TIME_MSEC		(1000)			//time before turn off when voltage is below LVD
#define OVERVOLTAGE_BLIND_TIME_MSEC			(80)				//time before turn off when voltage is above HVD
//#define TAP_CHANGE_BLIND_TIME_MSEC		(400)				//time between hitting tap-up voltage and actual tap change (not used in tap-down)
#define STANDARD_WAIT_DELAY_SECS_AVS13	(15)				//standard delay for AVS13
#define STANDARD_WAIT_DELAY_SECS_AVS15	(30)				//standard delay for AVS15
#define TEST_MODE_TIME_SECS							(10)				//used it test mode

	// LED parameters
#define LED_BLINK_TIME_MS							(300)

	// ADC channel assignment
#define AC_SENSE_ADC_CHANNEL		(0)			// ch 0 on new
#define POT_ADC_CHANNEL					(5)			// potentioneter adjusting Int Delay
#define INT_DELAY_ADC_CHANNEL		(6)			// Intelligent delay ADC channel

//Various delay adc counts vs Times for intelligent delay timeSave circuit (approx voltages given for Vcc=5V)
#define INTD_0MIN_10SECS					(161)						//0.722V?
#define INTD_1MIN_00SECS					(455)						//2.180V?
#define INTD_2MIN_00SECS					(678)						//3.289V?
#define INTD_3MIN_00SECS					(814)						//3.962V?
#define INTD_4MIN_00SECS					(897)						//4.371V?
#define INTD_5MIN_00SECS					(947)						//4.618V?
//delay selections for unit
//#define INT_DELAY_ADC_LEVEL				(INTD_3MIN_00SECS)		//intelligent delay time setting			<== replaced by variable
#define TEST_INT_DELAY_ADC_LEVEL	(INTD_0MIN_10SECS)		//intelligent delay used in Test mode
#define INT_DELAY_HYST_COUNTS			(5)										//intelligent delay voltage hysteresis (~25mV)
//#define INT_DELAY_WAIT_TIME_SECS	(180)									//intelligent delay expressed in seconds			<== replaced by variable


//ASP function relay characteristics
// sensitivity event thresholds - whether to decrease sensitivity or increase it
#define	INCREASE_SENSITIVITY_THRESHOLD	(4)
#define DECREASE_SENSITIVITY_THRESHOLD	(6)
// Time in minutes for a sensitivity event to be active
#define SENSITIVITY_RESET_PERIOD_MIN		(60)

// Defining tap voltage thresholds for different sensitivities (inputVoltage)
//#define LVL3_SENSE_TAP_UP_VOLTAGE				(0x6E3D)		//224V
//#define LVL3_SENSE_TAP_DOWN_VOLTAGE			(0x7A60)		//236V
#define LVL1_SENSE_TAP_UP_VOLTAGE				(0x5965)		//201.8V	//high sensitivity (we use only this in fspe)
#define LVL1_SENSE_TAP_DOWN_VOLTAGE			(0x83DA)		//245V
#define LVL2_SENSE_TAP_UP_VOLTAGE				(0x58B2)		//201V		//low sensitivity
#define LVL2_SENSE_TAP_DOWN_VOLTAGE			(0x8614)		//247V


//relays switching time (measured)
#define RELAY_SWITCH_OFF_TIME_US			(4000)			//4000 for SangChuan (black), 5500 for Tyco (orange)
#define RELAY_SWITCH_ON_TIME_US				(6000)			//6000 for SangChuan (black), 6500 for Tyco (orange)
//#define RLY_MAX_BOOST	(1)
//#define RLY_MAX_BUCK (2)

//error codes
#define ERR1	0x01	// intelligent delay error
#define ERR2	0x02	// wrong period (can't perform calibration)
#define ERR3	0x04	// calibration factor error (5V supply outside limits, voltage divider error or wrong input voltage)
#define ERR4	0x08	// can't recognise AVS version (13 or 15)
#define ERR5	0x10	// 
#define ERR6	0x20	//
#define ERR7	0x40	// 
#define ERR8	0x80

#endif // __options_H