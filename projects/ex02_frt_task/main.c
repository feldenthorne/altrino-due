/**
 * \file main.c
 * This file contains an example of the Altrino Due build environment with FreeRTOS
 * and tasks (and semaphores). When the program starts, a string informs the user that
 * this is a task demo (via serial terminal). The FreeRTOS scheduler then starts and
 * uses semaphores to block two different tasks - one that turns on the 
 * TX LED (LED1_GPIO), and one that turns it off. Each time the LED is toggled, a
 * message is sent out through the serial port.
 * 
 * \bug Currently, compiling this will throw a warning that SystemCoreClock is declared
 * redundantly. This does not affect the performance of the example, as far as I can
 * tell. Until I can figure out how to keep system_sam3x.h from declaring this specific
 * extern or think of a pretty workaround, however, this bug shall stay.
 */
/*
 * Example to demonstrate thread definition, semaphores, and thread sleep.
 */
#include <FreeRTOS.h>
#include <semphr.h>
#include <task.h>

// Pop in the library definitions for ASF, the board, and the serial port
#include "include/asf.h"
#include <stdio_serial.h>
#include "include/conf_board.h"
#include "include/conf_clock.h"

// Redefine AVR Flash string macro as nop for ARM
#undef F
#define F(str) str

// Declare a semaphore handle.
SemaphoreHandle_t sem;

//------------------------------------------------------------------------------
/**
 *  Configure UART console.
 */
static void configure_console(void)
{
	const usart_serial_options_t uart_serial_options = 
	{
		.baudrate = CONF_UART_BAUDRATE,
		.paritytype = CONF_UART_PARITY
	};

	/* Configure console UART. */
	sysclk_enable_peripheral_clock(CONSOLE_UART_ID);
	stdio_serial_init(CONF_UART, &uart_serial_options);
}

/*
 * Thread 1, turn the LED off when signalled by thread 2.
 */
static void Thread1(void* arg) 
{
  while (1) {
    // Wait for signal from thread 2.
    xSemaphoreTake(sem, portMAX_DELAY);

    // Turn LED off.
    ioport_set_pin_level(LED1_GPIO, IOPORT_PIN_LEVEL_LOW);
	
	// Print off message
	printf("LED Off... ");
  }

}

//------------------------------------------------------------------------------

/*
 * Thread 2, turn the LED on and signal thread 1 to turn the LED off.
 */
static void Thread2(void* arg) {
  // There's probably a way to set a pin to output in ASF, but the
  // ioport_set_pin_level() function does it for us.
  //pinMode(LED_PIN, OUTPUT);
	
  while (1) {
    // Turn LED on, display message
    ioport_set_pin_level(LED1_GPIO, IOPORT_PIN_LEVEL_HIGH);
	printf("LED On... ");

    // Sleep for 200 milliseconds.
    vTaskDelay((200L * configTICK_RATE_HZ) / 1000L);

    // Signal thread 1 to turn LED off.
    xSemaphoreGive(sem);

    // Sleep for 200 milliseconds.
    vTaskDelay((200L * configTICK_RATE_HZ) / 1000L);
  }

}

//------------------------------------------------------------------------------

int main(void)
{
	// Declares handles for the tasks, essentially, to make sure we can make sure
	// they are created
	portBASE_TYPE s1, s2;
	
	// Initialize the system clock, board peripherals, and the UART console via ASF
	sysclk_init();
	board_init();
	configure_console();
	
	// Initialize fifoData semaphore to no data available
	sem = xSemaphoreCreateCounting(1, 0);
	
	// Create "blink off" task at priority two
	s1 = xTaskCreate(Thread1, NULL, configMINIMAL_STACK_SIZE, NULL, 2, NULL);
	
	// Create "blink on" task at priority one
	s2 = xTaskCreate(Thread2, NULL, configMINIMAL_STACK_SIZE, NULL, 1, NULL);

	// Check for creation errors
	if (sem== NULL || s1 != pdPASS || s2 != pdPASS ) 
	{
		puts("Semaphore/Task Creation Problem!\r\n");
		while(1);
	}
	
	// Toss up a headline, letting the user know what program they're running
	puts("Altrino Due: FreeRTOS Task Example\r\n");

	// Start the FreeRTOS Scheduler
	vTaskStartScheduler();
	
	// If we ever exit, inform the 
	puts("FreeRTOS exited! This was probably because we ran out of RAM.\r\n");
	while(1);
}