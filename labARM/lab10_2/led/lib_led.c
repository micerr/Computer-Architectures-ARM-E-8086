/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           lib_led.c
** Last modified Date:  2019-12-05
** Last Version:        V1.00
** Descriptions:        Atomic led init functions
** Correlated files:    
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/
#define LED_NUM     8                   /* Number of user LEDs                */
#include "LPC17xx.h"
#include "led.h"

/*----------------------------------------------------------------------------
  Function that initializes LEDs
 *----------------------------------------------------------------------------*/

void LED_init(void)
{
	LPC_PINCON->PINSEL4 &= 0xFFFF0000;	// PIN mode GPIO: P2.0-P2.7 are set to zero
	LPC_GPIO2->FIODIR |= 0x000000FF;		// P2.0-P2.7 on PORT2 defined as Output
}

void LED_deinit(void)
{
  LPC_GPIO2->FIODIR &= 0xFFFFFF00;
}

/*----------------------------------------------------------------------------
  Function that turn off all led
 *----------------------------------------------------------------------------*/

void all_LED_off(void)
{
	LPC_GPIO2->FIOCLR = 0x000000FF;
}

/*----------------------------------------------------------------------------
  Functions that light up four LEDs at a time
 *----------------------------------------------------------------------------*/

void LED_On(unsigned int led)
{
	// led=0 => LED4
  LPC_GPIO2->FIOPIN= 0x80>>led;
}

void show_num(unsigned int num){
	LPC_GPIO2->FIOPIN=num;
}