//*************************************************************************************
/** \file task_wrap.h
 *    This file contains the necessary methods to wrap FreeRTOS tasks into a C++
 *    environment. It draws heavily on the work of John Ridgely and Stephano Oliveri.
 *
 *  Revisions:
 *    \li 29-04-14 RZ Created initial wrapper. Commented some.
 *    \li 19-08-14 RZ Updated to reflect FreeRTOS 8+ type conventions
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

#ifndef _FRT_TASKWRAP_H_
#define _FRT_TASKWRAP_H_

#include <FreeRTOS.h>
#include <semphr.h>
#include <task.h>

/** \brief The overarching FreeRTOS task wrapper class.
 *  \details It creates an object to for storing the handles for a FreeRTOS task also
 *  defines the destructor for a task when it is deleted. 
 *  \warning This class should probably not be used directly, unless you really want 
 *  to deal with the details of task creation and pointing to a function for the task
 *  loop (see \c TaskClass::_user_run_function() ).
 *  \note Using this wrapper and \c TaskClass for FreeRTOS tasks introduces a memory
 *  overhead of roughly 30000 bytes. If space becomes an issue that's terribly
 *  pressing, reverting to the standard C implementation of FreeRTOS tasks would be a
 *  viable option.
 */

class TaskWrap {
protected:
	/** \brief The handle for the task to be created.
	 *  \details This is a FreeRTOS task handle used to refer to whatever task is 
	 *  instantiated by this wrapper. \note xTaskHandle is only used in FreeRTOS 
	 *  versions below 8.0 - if the version is upgraded, this data type changes to 
	 *  TaskHandle_t.
	 */
	TaskHandle_t handle;
	
public:
	/** \brief The destructor for the base task class.
	 *  \details It is a method by which the memory used for a \c TaskWrap object
	 *  can be freed and the task can be deregistered from the list of active tasks
	 *  that FreeRTOS maintains. In most cases, this shouldn't be necessary to deal
	 *  with - using the \p delete[] operator will first run any destructor for the
	 *  TaskClass wrapper, then the destructor for TaskWrap, as destructors are not
	 *  inherited. Example usage is shown below: 
	 *  \code 
	 *  task_example* pTask = new task_example(args);
	 *  ...
	 *  delete pTask;
	 *  \endcode
	 */
	~TaskWrap()
	{
		// If task deletion is enabled, set the handle to zero and delete it
		#if (INCLUDE_vTaskDelete == 1)
			void* temp_handle = handle;
			handle = 0;
			vTaskDelete (temp_handle);
		// If task deletion is disabled, set this task's handle to 0 but don't delete 
		// task
		#else
			handle = 0;
		#endif
		return;
	}
};

/** \brief The task-specific FreeRTOS task-wrapping class.
 *  \details It uses the \c TaskWrap class as a parent, inheriting the 
 *  \c TaskWrap::handle, but allowing the creation of a specific \c TaskClass
 *  constructor and destructor. \c TaskClass::TaskClass creates and registers
 *  a given task within FreeRTOS, but the destructor has been omitted, as there is
 *  no specific data that needs to be deleted separately from that in \c TaskWrap
 *  upon task deletion at this time.
 * 
 *  In order to create a task that implements this class, simply include the
 *  following within the class header declaration and the task C++ file:
 *  \code
 *  class task_example : public TaskClass {
 *  ...
 *  };
 *  \endcode
 *  The \c : simply tells the compiler that this new class, task_example, inherits
 *  \c TaskClass and its inheritances.
 * 
 *  Tasks that implement this class \b MUST provide a \c run() method because
 *  \c TaskClass::run() is pure virtual - this helps to prevent weird behavior and 
 *  should keep code streamlined, as all the main loops for each task are required
 *  to be in \c run(). This means that, at minimum, a header file for a task must
 *  declare the following:
 *  \code
 *  class task_example : public TaskClass {
 *  public:
 *		// The constructor for the example class, which gives a pointer to the
 *		// task's name string, declares a numeric priority, and defines the stack
 *		// size for the task in bytes.
 *		task_example(const char* aName, unsigned portBASE_TYPE taskPriority, 
 *					 size_t stackSize, ...);
 * 
 *		// The run function for the example class, which is necessary to declare,
 *		// otherwise the compiler will moan about not declaring run() because it's
 *		// pure virtual.
 *		void run(void);
 *  };
 *  \endcode
 * 
 *  Once a task class header and C++ file have been created, the most convenient
 *  method to create a new instance of a class is to use the C++ \c new[] operator
 *  to allocate memory for the task on the fly (after having included the header for
 *  the task, of course). Example usages (within \c main(), or, in the case of
 *  Arduino, \c setup()) are shown below:
 *  \code
 *	#include "task_example.h"
 *	...
 *	// This allocates the memory for a new task_example object and calls its
 *	// constructor, but does not allow its deletion, as the pointer to the task
 *	// is not saved.
 *	new task_example("Example", (portBASE_TYPE) 2, configMINIMAL_STACK_SIZE, ...);
 * 
 *	// This creates a pointer to a task_example object, allocates the memory for it,
 *	// and calls its constructor. It also allows the user to use the delete operator
 *	// to deallocate the memory associated with the task at a later time.
 *	// The destruction line should read:   delete pTask;
 *	task_example* pTask = new task_example("Ex", (portBASE_TYPE) 2, configMINIMAL_STACK_SIZE, ...);
 *	
 *	// Start the FreeRTOS task scheduler
 *	vTaskStartScheduler();
 *	\endcode
 */
class TaskClass : public TaskWrap {
private:
	
public:
	/** \brief The constructor for the base task class.
	 *  \details It calls the FreeRTOS task creation function \c xTaskCreate() to
	 *  associate the \c TaskWrap::handle with the actual code specified in an
	 *  individual task's C++ and header files and register it in the FreeRTOS task
	 *  list (and, as such, diagnostic information can be printed out about the task
	 *  via the \c task_ui::printDiagTaskInfo() method.
	 */
	TaskClass(char const*name, unsigned portBASE_TYPE priority,
				unsigned portSHORT stackDepth=configMINIMAL_STACK_SIZE) 
	{
		xTaskCreate((void(*)(void*))(&_user_run_function), 
					(const char*)name, stackDepth, this, priority, &handle);
	}
	
	/** \brief Pure virtual run function for the TaskClass.
	 *  \details \warning This pure virtual run function declaration makes it an 
	 *  absolute requirement that any class that inherits \c TaskClass must supply 
	 *  its own run function. 
	 * 
	 *  It'd be kind of silly to let one be created if it would never run, 
	 *  plus it'd create a task with a pointer to nothing, which seems like poor 
	 *  judgment.
	 */
	virtual void run (void) = 0;
	
	/** \brief Handles the execution of the \c run() function for a task
	 *  \details \warning This method should never be called in a user's code!
	 * 
	 *  This method is passed to the FreeRTOS task-creation function 
	 *  \c xTaskCreate(). It executes the \c run() method that \c TaskClass requires 
	 *  to be created and handles exits by deleting the task (and freeing up space 
	 *  for FreeRTOS) if the vTaskDelete option is enabled in \c FreeRTOSConfig.h. 
	 *  If vTaskDelete is not enabled, the task handle is set to 0 so it can no longer 
	 *  be referred to.
	 *  @param pTask A pointer to the task given as a parameter to this function.
	 *  It is used to point \c TaskClass to the user's \c run() function, as well as
	 *  the task handle, if \c run() exits.
	 */
	static void _user_run_function(TaskClass* pTask) 
	{
		// This is where the user's run() method is actually called
		pTask->run();
		
		// If the run() method exits, and if task deletion is enabled, delete this 
		// task
		#if (INCLUDE_vTaskDelete == 1)
			void* tempHandle = pTask->handle;
			pTask->handle = 0;
			vTaskDelete (tempHandle);
		// If task deletion is disabled, set this task's handle to 0 but don't delete 
		// task
		#else
			pTask->handle = 0;
		#endif

		// If task deletion is not enabled, we get here if the task run method has 
		// exited (which it shouldn't have). 
		for (;;)
		{
			vTaskDelay (portMAX_DELAY);
		}
	}
	
	/** \brief This method suggests that the RTOS lose focus of a task for a time
	 */
	void delayms (uint16_t interval)
	{
		vTaskDelay(configMS_TO_TICKS(interval));
	}
	
	/** \brief This method forces the RTOS to perform a delay for a specified time
	 */
	void delay_from_for(portTickType& fromTicks, uint16_t interval)
	{
		vTaskDelayUntil (&fromTicks, configMS_TO_TICKS(interval));
	}
};

/** \cond NO_DOXY <b>This function never needs to be called by user-written code.</b>
 *  This is the task function which is called by the RTOS scheduler. It needs to call
 *  the task's run function which is a member of the user's task class, which is a
 *  descendent of this class. In order to call the user's run method, the RTOS run
 *  function must first call a static task method, \c _user_run_function(), which 
 *  is also defined in class \c TaskClass. 
 *  @param pTask A pointer to the task is given as a parameter to this task function;
 *                the pointer is used to find the task's static run method
 */
extern "C" inline void runFunctionWrapper (TaskClass* pTask)
{
	TaskClass::_user_run_function(pTask);
}
/** \endcond
 */

#endif // _FRT_TASKWRAP_H_
