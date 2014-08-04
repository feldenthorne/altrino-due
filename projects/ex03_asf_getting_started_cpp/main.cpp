/**
 * \file main.cpp
 *
 * \brief Getting Started Application.
 *
 * Copyright (c) 2011 - 2014 Atmel Corporation. All rights reserved.
 *
 * \page License
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of Atmel may not be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * 4. This software may only be redistributed and used in connection with an
 *    Atmel microcontroller product.
 *
 * THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
 * EXPRESSLY AND SPECIFICALLY DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include "shares.h"
#include "system_functions.h"

/** \brief LED0 blink time, LED1 blink half this time, in ms 
 */
#define BLINK_PERIOD     1000

/** \brief Define the end of line string
 */
#define STRING_EOL    "\r"

/** \brief Define the header string, shown to the user on startup
 */
#define STRING_HEADER "-- Getting Started Example --\r\n" \
		"-- "BOARD_NAME" --\r\n" \
		"-- Compiled: "__DATE__" "__TIME__" --"STRING_EOL
	
/** \brief LED0 blinking control. 
*/
volatile bool g_b_led0_active;

/** \brief LED1 blinking control. 
*/
#ifdef LED1_GPIO
volatile bool g_b_led1_active;
#endif

/** \brief Global g_ul_ms_ticks in milliseconds since start of application 
*/
volatile uint32_t g_ul_ms_ticks;
		
system_functions* sys_function;

/** \brief getting-started Application entry point.
 */
int main(void)
{
	// Create a pointer to a system_function object so we can use the system methods
	sys_function = new system_functions();
	
	// Initialize the SAM system
	sys_function->init_clock();
	sys_function->init_board();

	// Initialize the console UART
	sys_function->config_console();

	// Output example information
	puts(STRING_HEADER);

	// Configure systick for 1 ms
	puts("Configure system tick to get 1ms tick period.\r");
	// Here, we have to make sure FreeRTOS isn't enabled because it has its own
	// SysTick_Handler and this'll undermine it with the ASF functions
	#ifndef _USE_FREERTOS_
		if (SysTick_Config(sysclk_get_cpu_hz() / 1000)) {
			puts("-F- Systick configuration error\r");
			while (1);
		}
	#endif

	puts("Configure TC.\r");
	sys_function->config_tc();

	puts("Configure buttons with debouncing.\r");
	sys_function->config_buttons();

	printf("Press %s to Start/Stop the %s blinking.\r\n",
			PUSHBUTTON_1_NAME, LED_0_NAME);

	#ifndef BOARD_NO_PUSHBUTTON_2
		printf("Press %s to Start/Stop the %s blinking.\r\n",
				PUSHBUTTON_2_NAME, LED_1_NAME);
	#endif

	while (1) {
		/* Wait for LED to be active */
		while (!g_b_led0_active);

		/* Toggle LED state if active */
		if (g_b_led0_active) {
			ioport_toggle_pin_level(LED0_GPIO);
			printf("1 ");
		}

		// Wait for 500ms
		sys_function->mdelay(500);
	}
}