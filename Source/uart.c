#include "stm8s.h"
#include "stm8s_type.h"
#include "globals.h"
#include "options.h"
//#include "string.h"



// Global Function Prototypes
void UART1_Config(void);				//configures UART1 to transmit async data
void UART1_PutString(char *, _Bool);		//transmits string and optionally moves to new line
//void UART1_PutStringNL(char *);	//transmits string and moves to new line
void Hex2str(char *, u32);			//converts hex number to string
void Int2Str(char *, u32);			//converts decimal number to string
void TransmitData(void);

// Global variables
char strNum[11];		// string that can store 32b number ('0x' and eight digits plus Null character)

// Private Function Prototypes
void UART1_PutChar(char);				//transmits 1 char
char convertDigit(u8);					//converts hex digit to corresponding char

//------------------------------------------------------------------------------------------------------------------------

void UART1_Config(void)
{
	/* Clear the word length bit*/
  UART1->CR1 &= (u8)(~UART1_CR1_M);  			//M=0 => 8 bit data 
  UART1->CR3 &= (u8)(~UART1_CR3_STOP);  	// STOP BITS=00 => One stop bit is transmitted at the end of frame
  UART1->CR1 &= (u8)(~(UART1_CR1_PCEN));	//PCEN=0 => Parity Control Disabled
  
	// DIV = Fck / baud rate. BBR1 stores middle two hex digits, BBR2 stores first and last hex digit. BBR2 should be written first
	// for Fmaster = 16MHz BRR2:
	//UART1->BRR2 = 0x1B; //2400 baud
	//UART1->BRR2 = 0x03;	//9600 baud
	UART1->BRR2 = 0x01; //19200 baud
	//UART1->BRR2 = 0x06;	//57600 baud
	//UART1->BRR2 = 0x0B; //112200 baud
  //UART1->BRR2 = 0x05; //230400 baud
	//UART1->BRR2 = 0x03; //460800 baud // old
	//UART1->BRR2 = 0x01; //921600 baud
  
	// for Fmaster = 16MHz BRR1:
	//UART1->BRR1 = 0xA0; // 2400 baud
	//UART1->BRR1 = 0x68; // 9600 baud
	UART1->BRR1 = 0x34; // 19200 baud
	//UART1->BRR1 = 0x11; // 57600 baud
	//UART1->BRR1 = 0x08; // 112200 baud
	//UART1->BRR1 = 0x04; // 230400 baud
	//UART1->BRR1 = 0x02; // 460800 baud //old
	//UART1->BRR1 = 0x01; //921600 baud
 
	/* Set the Transmitter Enable bit */
	UART1->CR2 |= (u8)UART1_CR2_TEN;  
		
	// enable transmit interrupt
	//UART1->CR2 |= 0x80;	
	
	//enable UART1
	UART1->CR1 &= (u8)(~UART1_CR1_UARTD); 
}
//------------------------------------------------------------------------------------------------------------------------

void UART1_PutChar(char Data)
{
	UART1->DR = Data;	//put data in data register
	while ((UART1->SR & UART1_SR_TXE ) != UART1_SR_TXE );	//wait for TXE bit (set by hardware when transmit register is empty)
}
//------------------------------------------------------------------------------------------------------------------------

// transmits string and optionally moves to new line
void UART1_PutString(char *s, _Bool NewLine)
{
	while (*s != '\0')
	{
		UART1_PutChar(*s);	//keep sending chars until NULL
		s ++;
	}
	if (NewLine)
	{
		UART1_PutChar('\r');	//return
		UART1_PutChar('\n');	//new line
	}
	while ((UART1->SR & UART1_SR_TC ) != UART1_SR_TC );	//wait for TC bit (transmission comlete, set by hardware)
}
//------------------------------------------------------------------------------------------------------------------------

//converts hex representation of num to string, adding '0x' prefix
void Hex2str(char str[11], u32 num)
{
	u32 hex = num;
	char CharDigits[8] = "00000000";
	u8 i;
	u8 pos = 2;
	
	for (i=0;i<10;i++) str[i] = '0';	//initialize string with zeros
	
	//add '0x' prefix to indicate hex number
	str[0] = '0';	
	str[1] = 'x';
	
	CharDigits[0] = convertDigit(hex % 16);		//convert least significant hex digit to char and save it in array
	
	for (i=1;i<8;i++)
	{
		hex = hex >> 4;	//get rid of the least significant hex digit..
		CharDigits[i] = convertDigit(hex % 16);	//..to convert next one
	}
	while ((CharDigits[--i] == '0') && (i > 0)) ;		//ignore all zeros before actual number
	while (i > 0)
	{
		str[pos] = CharDigits[i];	//put significant chars to the string
		i--;
		pos++;
	}
	str[pos] = CharDigits[0];	//put most significant char to the string (even if it's 0)
	str[++pos] = '\0';	//null must be added at the end of string
}
//------------------------------------------------------------------------------------------------------------------------

//converts single hex digit to corresponding ASCII code
char convertDigit(u8 digit)
{
	if ((digit >= 0) && (digit <= 9))		//0 to 9
		return (digit+48);
	if ((digit >= 10) && (digit <= 15))	//A to F
		return (digit+55);
}
//------------------------------------------------------------------------------------------------------------------------

//converts decimal representation of intnum to string
void Int2str(char str[11], u32 intnum)
{
    u8 i;
		u8 j = 0;
		u8 Status = 0;
		u32 Div = 1000000000;
		
		for (i=0; i<10; i++) str[i] = '0';	//initialize string with zeros
		
    for (i=0; i<10; i++)
    {
      str[j++] = (intnum / Div) + 48;	//start from the most significant digit
      intnum = intnum % Div;	//save the rest 
      Div /= 10;	//reduce divider by one zero
      if ((str[j-1] == '0') & (Status == 0))
        j = 0;	//ignore starting zeros
      else
        Status++;	//indicate significant chars has started
    }
		str[j] = '\0';	//null must be added at the end of string
}
//------------------------------------------------------------------------------------------------------------------------

// transmits frequency (decimal), outputVoltage (hex), relay combination, relay state
void TransmitData(void)
{
	Int2str(strNum, frequency);
	UART1_PutString(strNum, NO_NL);
	UART1_PutString("\x09", NO_NL);
	Hex2str(strNum, (u32)outputVoltage);
	UART1_PutString(strNum, NO_NL);
	UART1_PutString("\x09", NO_NL);	
	Int2str(strNum, relayCombination);
	UART1_PutString(strNum, NO_NL);
	UART1_PutString("\x09", NO_NL);	
	if (relay1.state == REL_OFF) UART1_PutString("OFF", NL);
	if (relay1.state == REL_WAIT) UART1_PutString("WAIT", NL);
	if (relay1.state == REL_ON) UART1_PutString("ON", NL);
}
//------------------------------------------------------------------------------------------------------------------------