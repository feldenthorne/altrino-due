/** \file shares.h
 *  This file contains the header info for shared variables for the CPP version of the 
 *  ASF getting_started example.
 */

// Prevent this header from being included multiple times in the same file
#ifndef _EX_CPP_SHARES_H
#define _EX_CPP_SHARES_H

// Includes for convenience
#include "lib/ASF_Config/asf.h"
#include "lib/ASF_Config/conf_board.h"
#include "lib/ASF_Config/conf_clock.h"
#include "lib/ASF_Config/conf_uart_serial.h"
#include <stdio_serial.h>

/** \brief IRQ priority for PIO (The lower the value, the greater the priority) 
 */
#define IRQ_PRIOR_PIO    0

/** \brief LED0 blinking control. 
*/
extern volatile bool g_b_led0_active;

/** \brief LED1 blinking control. 
*/
#ifdef LED1_GPIO
extern volatile bool g_b_led1_active;
#endif

/** \brief Global g_ul_ms_ticks in milliseconds since start of application 
*/
extern volatile uint32_t g_ul_ms_ticks;


#endif/* _EX_CPP_SHARES_H_ */