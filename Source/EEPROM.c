#include "stm8s.h"
#include "stm8s_type.h"
//#include <string.h>
//#include "eeprom.h"
//#include "timers.h"
#include "globals.h"
//#include "clock.h"
//#include "GPIO.h"
//#include "adc.h"

//EEPROM.c

// Global Functions
u8 writeInternalEEPROM(u8*, u8*, u8);
_Bool writeFLASH(u8*, u8 *, u8);
u8 writeInternalEEPROM16bit(u16 data, u16* loc);

//global variable


// lock is u16 so that high byte = seg1 and low byte = seg2 (paranoia)
u8 writeInternalEEPROM(u8* data, u8* loc, u8 len)
{
	u8 done = 0;
	vu16	msec = milliSeconds;
	u8* d = data;
	u8* l = loc;
	u8 le = len;

	// unlock EEPROM
	FLASH->DUKR = 0xAE;
	FLASH->DUKR = 0x56;
	
	while (msec == milliSeconds) ;
	
	//wait for flash to be ready to program
	while (!(FLASH->IAPSR & FLASH_IAPSR_DUL)) // wait for DUL bit in EEPROM status register to be set
	{
		if (milliSeconds == msec) break;
	}
	msec = milliSeconds;
	
	do
	{
		if (le >= 4)	// if more than 4 bytes then enable long word programming mode
		{
			FLASH->CR2 |= 0x40;
			FLASH->NCR2 &= ~0x40;
			//load bytes in 
			*l++ = *d++;
			*l++ = *d++;
			*l++ = *d++;
			*l++ = *d++;
			le -= 4;
		}
		else // do the single byte programming
		{ 
		// load single byte in
			*l++ = *d++;
			le--;
		}
		
		// wait for programming to complete
		while (!done || (msec != milliSeconds)) 
		{
			done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
		}
		done = 0;
	}
	while (le);
	FLASH->IAPSR &= ~FLASH_IAPSR_DUL;	// clear DUL bit to re-enable EEPROM write protection
	//enableInterrupts();
}

u8 writeInternalEEPROM16bit(u16 data, u16* loc)
{
	u8 done = 0;
	vu16	msec = milliSeconds;
	u8 dlow  = data;
	u8 dhigh = data>>8;
	u8* l = (u8 *)loc;

	// unlock EEPROM
	FLASH->DUKR = 0xAE;
	FLASH->DUKR = 0x56;
	
	while (msec == milliSeconds) ;
	
	//wait for flash to be ready to program
	while (!(FLASH->IAPSR & FLASH_IAPSR_DUL)) // wait for DUL bit in EEPROM status register to be set
	{
		if (milliSeconds == msec) break;
	}
	msec = milliSeconds;
	
	// load high byte in
	*l++ = dhigh;
	// wait for programming to complete
	while (!done || (msec != milliSeconds)) 
	{
		done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
	}
	done = 0;
	// load low byte in
	*l = dlow;
	// wait for programming to complete
	while (!done || (msec != milliSeconds)) 
	{
		done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
	}
	done = 0;

	FLASH->IAPSR &= ~FLASH_IAPSR_DUL;	// clear DUL bit to re-enable EEPROM write protection
	//enableInterrupts();
}

_Bool writeFLASH(u8 *data, u8 *loc, u8 len)
{
	u8 done = 0;
	vu16	msec = milliSeconds;
	u8* d = data;
	u8* l = loc;
	u8 le = len;

	//disableInterrupts();
	//unlock flash
	FLASH->PUKR = 0x56;
	FLASH->PUKR = 0xAE;

	//wait for flash to be ready to program
	while (!(FLASH->IAPSR & FLASH_IAPSR_PUL)) // wait for PUL bit if flash status register to be set
	{
		//if (milliSeconds > msec) if ((milliSeconds - msec) > 500) return (FALSE);
		//else if ((1000 - msec)+ milliSeconds > 500) return (FALSE);
	}
	
	do
	{
		if (le >= 4)	// if more than 4 bytes then enable long word programming mode
		{
			FLASH->CR2 |= 0x40;
			FLASH->NCR2 &= ~0x40;
			//load bytes in 
			*l++ = *d++;
			*l++ = *d++;
			*l++ = *d++;
			*l++ = *d++;
			le -= 4;
		}
		else // do the single byte programming
		{ 
		// load single byte in
			*l++ = *d++;
			le--;
		}
		
		// wait for programming to complete
		while (!done) 
		{
			done = (FLASH->IAPSR & FLASH_IAPSR_EOP);
			//if (milliSeconds > msec) if ((milliSeconds - msec) > 500) return (FALSE);
			//else if ((1000 - msec)+ milliSeconds > 500) return (FALSE);
		}
		done = 0;
		//msec = milliSeconds;
	}
	while (le);
	FLASH->IAPSR &= ~FLASH_IAPSR_PUL;	// clear PUL bit to re-enable flash write protection
	//enableInterrupts();
}
