/** \file buttons.h
 *  This file contains the header info for button functions for the CPP version of the 
 *  ASF getting_started example.
 */

// Prevent this header from being included multiple times in the same file
#ifndef _EX_CPP_BUTTONS_H
#define _EX_CPP_BUTTONS_H

// Includes for convenience
#include "shares.h"

/** \brief IRQ priority for PIO (The lower the value, the greater the priority) 
 */
#define IRQ_PRIOR_PIO    0

// Rather than skulking around, trying to cast these methods to void*, it's a lot
// easier to just keep them global

void inline InitializeButtonBools(void)
{
	g_b_led0_active = true;
	g_b_led0_active = true;
}

/** \brief Pushbutton Event Handler
 *  Handles setting the states of the pushbuttons on a button press
 */
inline void ProcessButtonEvt(uint8_t uc_button)
{
	if (uc_button == 0) 
	{
		g_b_led0_active = !g_b_led0_active;
		if (!g_b_led0_active) 
		{
			ioport_set_pin_level(LED0_GPIO, IOPORT_PIN_LEVEL_HIGH);
		}
	}
	#ifdef LED1_GPIO 
	else 
	{
		g_b_led1_active = !g_b_led1_active;

		/* Enable LED#2 and TC if they were enabled */
		if (g_b_led1_active) 
		{
			ioport_set_pin_level(LED1_GPIO, IOPORT_PIN_LEVEL_LOW);
			tc_start(TC0, 0);
		}
		/* Disable LED#2 and TC if they were disabled */
		else 
		{
			ioport_set_pin_level(LED1_GPIO, IOPORT_PIN_LEVEL_HIGH);
			tc_stop(TC0, 0);
		}
	}
	#endif
}

/** \brief Handler for Button 1 rising edge interrupt.
 *  Handle process led1 status change.
 */
static inline void Button1_Handler(uint32_t id, uint32_t mask)
{
	if (PIN_PUSHBUTTON_1_ID == id && PIN_PUSHBUTTON_1_MASK == mask) 
	{
		ProcessButtonEvt(0);
	}
}

#ifndef BOARD_NO_PUSHBUTTON_2
/** \brief Handler for Button 2 falling edge interrupt.
 *  Handle process led2 status change.
 */
static inline void Button2_Handler(uint32_t id, uint32_t mask)
{
	if (PIN_PUSHBUTTON_2_ID == id && PIN_PUSHBUTTON_2_MASK == mask) 
	{
		ProcessButtonEvt(1);
	}
}
#endif

/** \brief Configure the Pushbuttons
 *  Configure the PIO as inputs and generate corresponding interrupt when
 *  pressed or released.
 */
void inline configure_buttons(void)
{
	/* Configure Pushbutton 1 */
	pmc_enable_periph_clk(PIN_PUSHBUTTON_1_ID);
	pio_set_debounce_filter(PIN_PUSHBUTTON_1_PIO, PIN_PUSHBUTTON_1_MASK, 10);
	/* Interrupt on rising edge  */
	pio_handler_set(PIN_PUSHBUTTON_1_PIO, PIN_PUSHBUTTON_1_ID,
			PIN_PUSHBUTTON_1_MASK, PIN_PUSHBUTTON_1_ATTR, Button1_Handler);
	NVIC_EnableIRQ((IRQn_Type) PIN_PUSHBUTTON_1_ID);
	pio_handler_set_priority(PIN_PUSHBUTTON_1_PIO,
			(IRQn_Type) PIN_PUSHBUTTON_1_ID, IRQ_PRIOR_PIO);
	pio_enable_interrupt(PIN_PUSHBUTTON_1_PIO, PIN_PUSHBUTTON_1_MASK);
	#ifndef BOARD_NO_PUSHBUTTON_2
		/* Configure Pushbutton 2 */
		pmc_enable_periph_clk(PIN_PUSHBUTTON_2_ID);
		pio_set_debounce_filter(PIN_PUSHBUTTON_2_PIO, PIN_PUSHBUTTON_2_MASK, 10);
		/* Interrupt on falling edge */
		pio_handler_set(PIN_PUSHBUTTON_2_PIO, PIN_PUSHBUTTON_2_ID,
				PIN_PUSHBUTTON_2_MASK, PIN_PUSHBUTTON_2_ATTR, Button2_Handler);
		NVIC_EnableIRQ((IRQn_Type) PIN_PUSHBUTTON_2_ID);
		pio_handler_set_priority(PIN_PUSHBUTTON_2_PIO,
				(IRQn_Type) PIN_PUSHBUTTON_2_ID, IRQ_PRIOR_PIO);
		pio_enable_interrupt(PIN_PUSHBUTTON_2_PIO, PIN_PUSHBUTTON_2_MASK);
	#endif
}

#endif/* _EX_CPP_BUTTONS_H_ */