//**************************************************************************************
/** \file task_blink2.h
 *    This file contains the header for a task class that controls blinking.
 * 
 *  Revisions:
 *    \li 19-08-2014 RZ Created original header file
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

// This define prevents this .h file from being included multiple times in a .cpp file
#ifndef _TASK_BLINK2_H_
#define _TASK_BLINK2_H_

#include <FreeRTOS.h>                         // Header for FreeRTOS
#include "shares.h"
#include "lib/FreeRTOS_CPP/task_wrap.h"       // Header for FRT C++ wrapper

//-------------------------------------------------------------------------------------
/** \brief   This task controls the half of the blinking behavior.
 */

class task_blink2 : public TaskClass
{
private:
	
protected:
	
public:
	// This constructor creates a generic task of which many copies can be made
	task_blink2 (const char*, unsigned portBASE_TYPE, size_t);
	
	// This method is called by the RTOS once to run the task loop for ever and ever.
	void run (void);
};

#endif // _TASK_BLINK2_H_