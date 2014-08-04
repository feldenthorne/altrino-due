/** \file system_functions.h
 *  This file contains the header info system functions for the CPP version of the ASF
 *  getting_started example.
 */

// Prevent this header from being included multiple times in the same file
#ifndef _EX_CPP_SYSTEM_FUNC_H
#define _EX_CPP_SYSTEM_FUNC_H

// Includes for convenience
#include "shares.h"
#include "buttons.h"

// Defines for the system class
class system_functions
{
	private:
	protected:
	public:
		
		/** \brief Pointer to LED0 blinking control. 
		*/
		volatile bool* p_led0_active;
		
		/** \brief Pointer to LED1 blinking control. 
		*/
		#ifdef LED1_GPIO
		volatile bool* p_led1_active;
		#endif
		
		/** \brief Pointer to global g_ul_ms_ticks in milliseconds since start of application 
		*/
		volatile uint32_t* p_ms_ticks;
		
		// Simple constructor, used for access
		system_functions(void);
		
		// Initialize system clock
		static void init_clock(void);
		
		// Initialize board
		static void init_board(void);
		
		//Configure the Pushbuttons
		static void config_buttons(void);
		
		// Configure Timer Counter 0 to generate an interrupt every 250ms.
		static void config_tc(void);
		
		// Configure UART console.
		static void config_console(void);
		
		// Wait for the given number of milliseconds
		void mdelay(uint32_t ul_dly_ticks);
}; // end class system_functions

#endif/* _EX_CPP_SYSTEM_FUNC_H_ */