/**
 * \file
 * \brief FreeRTOS for ARM
 */
#ifndef _FREERTOSHOOKS_H
#define _FREERTOSHOOKS_H

//#ifndef __arm__
//#error You're not building in an ARM environment - don't try to use this!
//------------------------------------------------------------------------------
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "portmacro.h"

void hard_fault_isr(void);
/** Hard fault - blink one short flash every two seconds */
void HardFault_Handler(void);

/** Bus fault - blink two short flashes every two seconds */
void bus_fault_isr(void);
/** Bus fault - blink two short flashes every two seconds */
void BusFault_Handler(void);

/** Usage fault - blink three short flashes every two seconds */
void usage_fault_isr(void);
/** Usage fault - blink three short flashes every two seconds */
void UsageFault_Handler(void);

void vApplicationMallocFailedHook(void);

void  __attribute__((weak)) vApplicationIdleHook( void );
void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName);
void __attribute__((weak)) vApplicationTickHook(void);
void vMainConfigureTimerForRunTimeStats( void );
unsigned long ulMainGetRunTimeCounterValue(void);

//#endif  // __arm__
#endif  // _FREERTOSHOOKS_H