/* Define to prevent recursive inclusion -------------------------------------*/

#ifndef __eeprom_H
#define __eeprom_H


//internal EEPROM addresses
#define CORRECTION_FACTOR_ADDRESS			((u16 *) 0x4000)	//address set to the begining of data EEPROM
#define EEPROM_FIRST_30_MIN_ADD				((u16 *) 0x4002)		//flag 
#define EEPROM_CALIBRATION_DONE				((u16 *) 0x4004)  	//flag set after successful calibration
#define EEPROM_AVS_TYPE								((u16 *) 0x4006)	//AVS type recognized by reading PA3 (high for 13, low for 15). 
#define EEPROM_AVS_DELAY_SECS					((u16 *) 0x4008) // 2025 S modes																							
																												
																												//=5A5A for AVS15
																												//=A5A5 for AVS13
																												
#define AVS13_FLAG	(0xA5A5)
#define AVS15_FLAG	(0x5A5A)



#endif //__eeprom_H