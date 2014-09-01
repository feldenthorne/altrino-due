//**************************************************************************************
/** \file main.cpp
 *  FreeRTOS Demo Application with C++ wrapper
 *
 *  Revisions:
 *    \li 19-08-2014 RZ Created original main file
 *
 *  License:
 *    This file is copyright 2014 by R. Zimmerman. It currently intended 
 *    for educational use only, but its use is not limited thereto. */
/*    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 *    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 *    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 *    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 *    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUEN-
 *    TIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
 *    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 *    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
 *    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
 *    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
//**************************************************************************************

#include "shares.h"
#include "system_functions.h"
#include "lib/FreeRTOS_CPP/task_wrap.h"
#include "task_blink1.h"
#include "task_blink2.h"

/** \brief Define the header string, shown to the user on startup
 */
#define STRING_HEADER "-- FreeRTOS C++ Demo --\r\n"
	
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

/** \brief Declare a semaphore handle.
 */
SemaphoreHandle_t sem;

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
	
	// Initialize fifoData semaphore to no data available
	sem = xSemaphoreCreateCounting(1, 0);
	
	// Create task objects for FreeRTOS
	//new task_main ("Main", 1, configMINIMAL_STACK_SIZE + 50);
	new task_blink1 ("Blnk1", 2, configMINIMAL_STACK_SIZE + 50);
	new task_blink2 ("Blnk2", 2, configMINIMAL_STACK_SIZE + 50);

	// Output example information
	puts(STRING_HEADER);
		
	// Start the FreeRTOS Task Scheduler
	vTaskStartScheduler();
	
	// Let the user know if FreeRTOS crashes.
	printf("Something terrible has happened and FreeRTOS exited!");

	// Loop until a reset
	while (1) {
		// Wait for 500ms
		sys_function->mdelay(500);
	}
}