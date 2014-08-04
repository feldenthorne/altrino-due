# If you plan on using FreeRTOS, make sure that this variable is set to 1
# This is necessary when compiling examples out of ASF because each example has its
# own SysTick_Handler, which FreeRTOS replaces with its own.
_USE_FREERTOS_ = 0

# Include the necessary makefiles to build libraries and include syscall functions
#
ifeq ($(_USE_FREERTOS_),1)
include common/freertoslib.mk
endif
include common/asflib.mk
include common/syscalls.mk

# Project name
TARGET = ex03_asf_getting_started_cpp

# Path to top level ASF directory relative to this project directory.
PRJ_PATH = lib/ASF
CMSIS_LIBS = libarm_cortexM3l_math.a

# Target board: ARDUINO_DUE_X
BOARD = ARDUINO_DUE_X
ASF_FOLDER = arduino_due_x

# Application target name. Given with suffix .a for library and .elf for a
# standalone application.
TARGET_FLASH = $(TARGET)_flash
TARGET_SRAM = $(TARGET)_sram

# List of C source files.
PROJ_DIRS = . \

# List of assembler source files.
ASSRCS = 

# List of include paths.
PROJ_INC = \
       . \
       $(FRT_INCLUDE)

# Additional search paths for libraries.
LIB_PATH =  \
       thirdparty/CMSIS/Lib/GCC

# Path relative to top level directory pointing to a linker script.
LINKER_SCRIPT_FLASH = sam/utils/linker_scripts/$(PART_BASE)/$(PART_BASE)$(PART_SPEC)/gcc/flash.ld

# Path relative to top level directory pointing to a linker script.
DEBUG_SCRIPT_FLASH = sam/boards/$(ASF_FOLDER)/debug_scripts/gcc/$(ASF_FOLDER)_flash.gdb

# Application optimization used during compilation and linking:
# -O0, -O1, -O2, -O3 or -Os
OPTIMIZATION = -O2

#-----------------------------------------------------------------------------------
# Compiler Object/Flag Setup
# You REALLY Shouldn't Need to Change Anything Below Here
#-----------------------------------------------------------------------------------
# Tells the compiler to use newlib.nano, which will generally dramatically reduce program size
#
_USE_NEWLIBNANO_ = 1

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

include common/common.mk