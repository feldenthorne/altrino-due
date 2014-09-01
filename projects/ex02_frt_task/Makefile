#-----------------------------------------------------------------------------------
# General Project Settings
#-----------------------------------------------------------------------------------
#------------------------ Name/Platform --------------------------------------------
# Project name
#
TARGET = ex02_frt_task

# Target board: ARDUINO_DUE_X
#
BOARD = ARDUINO_DUE_X
ASF_FOLDER = arduino_due_x

#------------------------ Source Files ---------------------------------------------
# List of C source files.
#
PROJ_DIRS = . \

# List of assembler source files.
#
ASSRCS = 

# List of include paths.
#
PROJ_INC = \
       . \
       $(FRT_INCLUDE)

#------------------------ Library Locations ----------------------------------------
# Path to top level ASF directory relative to this project directory.
PRJ_PATH = lib/ASF

# Name of the math functions for the MCU architecture you're using
# Arduino Due boards use: libarm_cortexM3l_math.a
# 
CMSIS_LIBS = libarm_cortexM3l_math.a

# Additional search paths for libraries.
LIB_PATH =  \
       thirdparty/CMSIS/Lib/GCC

#------------------------ Optimization ---------------------------------------------
# Application optimization used during compilation and linking:
# -O0, -O1, -O2, -O3 or -Os
OPTIMIZATION = -O2

# Tells the compiler to use newlib.nano, which will generally dramatically reduce 
# program size
#
_USE_NEWLIBNANO_ = 1


#-----------------------------------------------------------------------------------
# FreeRTOS Settings
#-----------------------------------------------------------------------------------
# If you plan on using FreeRTOS, make sure that this variable is set to 1
# This is necessary when compiling examples out of ASF because each example has
# its own SysTick_Handler, which FreeRTOS replaces with its own.
_USE_FREERTOS_ = 1


#-----------------------------------------------------------------------------------
# ASF Custom Settings
#-----------------------------------------------------------------------------------
# If you plan on using a custom UART/USART, Clock, Board, or other module 
# configurations for ASF, put the directory for your config headers here
ASF_CONFIG = lib/ASF_Config

#-----------------------------------------------------------------------------------
# Library/Syscall Setup, Target Naming
# This is where the linker scripts are listed, as well. Tread carefully around here.
# If you really want to go barebones, though, all your REALLY need are
# flash.ld and arduino_due_x.gdb and the associated flags in common.mk.
#-----------------------------------------------------------------------------------
# Include the necessary makefiles to build libraries and include syscall functions
#
ifeq ($(_USE_FREERTOS_),1)
include common/freertoslib.mk
endif
include common/asflib.mk
include common/syscalls.mk

# Application target name. Given with suffix .a for library and .elf for a
# standalone application.
TARGET_FLASH = $(TARGET)_flash
TARGET_SRAM = $(TARGET)_sram

# Path relative to top level directory pointing to a linker script.
LINKER_SCRIPT_FLASH = sam/utils/linker_scripts/$(PART_BASE)/$(PART_BASE)$(PART_SPEC)/gcc/flash.ld

# Path relative to top level directory pointing to a linker script.
DEBUG_SCRIPT_FLASH = sam/boards/$(ASF_FOLDER)/debug_scripts/gcc/$(ASF_FOLDER)_flash.gdb

#-----------------------------------------------------------------------------------
# Compiler Object/Flag Setup
# You REALLY Shouldn't Need to Change Anything Below Here
#-----------------------------------------------------------------------------------

# Extra flags to use when archiving.
ARFLAGS = 

# Extra flags to use when assembling.
ASFLAGS = 

# Extra flags to use when compiling.
CFLAGS =

# Extra flags to use when linking
ifeq ($(_USE_NEWLIBNANO_),1)
LDFLAGS += --specs=nano.specs
endif

# Extra flags to use when building C files
ifeq ($(_USE_FREERTOS_),1)
CFLAGS += -D _USE_FREERTOS_
endif

# Additional options for debugging. By default the common Makefile.in will
# add -g3.
DBGFLAGS = 

#-----------------------------------------------------------------------------------
# Overarching Makefile, glues everything into a coherent, flashable program
#-----------------------------------------------------------------------------------
include common/common.mk