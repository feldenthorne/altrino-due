//**************************************************************************************
/** \file task_blink2.cpp
 *    This file contains the code for a task class which controls blinking.
 *
 *  Revisions:
 *    \li 19-08-2014 RZ Created original task file
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

#include "task_blink2.h"            // Header for this task

//-------------------------------------------------------------------------------------
/** \brief This constructor creates a task that designates cut patterns.
 *  \details This constructor creates the task that directs the cutting head for the
 *  label cutter.
 *  @param aName A character string which will be the name of this task
 *  @param aPriority The priority at which this task will initially run (default: 0)
 *  @param aStackSize The size of this task's stack in bytes 
 *                    (default: configMINIMAL_STACK_SIZE)
 */

task_blink2::task_blink2 (const char* aName, 
						unsigned portBASE_TYPE aPriority, 
						size_t aStackSize)
						: TaskClass (aName, aPriority, aStackSize)
{
}

//-------------------------------------------------------------------------------------
/** \brief This is the run method for the first blink task.
 */

void task_blink2::run (void)
{
	// MAIN BLINK LOOP
	for (;;) 
	{
		// Turn LED on, display message
		ioport_set_pin_level(LED1_GPIO, IOPORT_PIN_LEVEL_HIGH);
		printf("LED On... ");

		// Sleep for 200 milliseconds.
		delayms(200);

		// Signal thread 1 to turn LED off.
		xSemaphoreGive(sem);

		// Sleep for 200 milliseconds.
		delayms(200);
	}
}