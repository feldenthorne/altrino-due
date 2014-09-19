# FreeRTOS Library Makefile
# Mini-disclaimer: This file was not developed or endorsed by Real Time Engineers
# Ltd., the developers of FreeRTOS.

# List of phony commands
.PHONY: all library clean

#-----------------------------------------------------------------------------------
# FreeRTOS Location
#-----------------------------------------------------------------------------------
# FRT_PATH: Path to top level FreeRTOS directory relative to this project directory.
#            this allows the compiler to find everything it needs to build a
#            library of all FreeRTOS files relevant to a particular board.
#            Unless you mess around with the directories, because this is located
#            in the $(PROJECT_ROOT)/common directory, the path here should be left 
#            as:    lib/FreeRTOS
#
FRT_PATH = lib/FreeRTOS
FRT_CONF_PATH = lib/FreeRTOS_Config

#-----------------------------------------------------------------------------------
# FreeRTOS-Specific Declarations
#-----------------------------------------------------------------------------------
# PORTABLE:     The name of the board from $(ASF_PATH)/common/boards/board.h
#                If you're using an Arduino Due, this is ARDUINO_DUE_X .
#                If you compiling for a custom board, your first step here is
#                to create a board definition and create a define for it in
#                board.h using something like:
#                        #define YOUR_BOARD 70  //!< It's my board.
#                Additionally, you can use the define USER_BOARD .
#                If you define a custom board or use USER_BOARD, your board
#                config files need to go in 
#                $(ASF_PATH)/common/boards/$(ASF_FOLDER) -
#                see below for information on $(ASF_FOLDER)
#
PORTABLE = ARM_CM3
HEAP_NUMBER = 2
FRT_HEAP_DIR = $(FRT_PATH)/Source/portable/MemMang
FRT_HEAP = $(FRT_HEAP_DIR)/heap_$(HEAP_NUMBER).c
FRT_PORT_DIR = $(FRT_PATH)/Source/portable/GCC/$(PORTABLE)
FRT_PORT = $(FRT_PORT_DIR)/port.c

#-----------------------------------------------------------------------------------
# MCU-Specific Declarations
#-----------------------------------------------------------------------------------
# ARCH:         The basic architecture of your MCU
#                If you're using an Arduino Due, this should be set as:  cortex-m3
#                The full list of options depend on what's available for
#                newlib/newlib-nano (embedded standard libraries, similar to
#                avr-libc) - to date, this includes:
#                     cortex-m0, cortex-m0plus
#                     cortex-m1
#                     cortex-m3
#                     cortex-m4
#                     armv7-a, armv7e-m, armv7-r
#
# PART:         The Atmel MCU part name
#                If you're using an Arduino Due, this should be set as:  SAM3X8E
#                If you're working with something else, simple grab its name from
#                its datasheet. Remember, though: The name MUST be in uppercase.
#                If your part number isn't working, check the defines in
#                $(ASF_PATH)/common/utils/parts.h to figure out exactly what to use.
#
# PART_BASE:    The base name for your Atmel MCU
#                If you're using an Arduino Due, this should be set as:  sam3x
#                For other MCUs, this is Atmel's family name - the names under which
#                their MCUs are roughly organized here: 
#                  http://www.atmel.com/products/microcontrollers/arm/
#                ASF uses this name to compartmentalize directories for specific
#                part families, mostly in
#                $(ASF_PATH)/common/services and $(ASF_PATH)/sam/utils/cmsis
#                NOTE: This should be lowercase because it's a directory name
#
# PART_SPEC:    The specific identifier for your Atmel MCU family - its "genus"
#                of sorts.
#                If you're using an Arduino Due, this should be set as:  8
#                For other MCUs, this the the number directly after the MCU
#                family name.
#                Again, this is an aid in Atmel's compartmentalization of specific
#                MCU code.
#                If you're having issues finding out what to use here, good luck!
#                But a good place to check is: $(ASF_PATH)/sam/utils/linker_scripts
#                NOTE: This should be lowercase because it's a directory name
#
# PART_REV:     The specific identifier for your Atmel MCU revision - its "species"
#                If you're using an Arduino Due, this should be set as:  e
#                For other MCUs, this is the final lettering in the MCU's name
#                If you're having issues finding out what to use here, good luck!
#                But a good place to check is: $(ASF_PATH)/sam/utils/linker_scripts
#                NOTE: This should be lowercase because it's a directory name
#                 
#
ARCH= cortex-m3
PART = SAM3X8E
PART_BASE = sam3x
PART_SPEC = 8
PART_REV  = e

#-----------------------------------------------------------------------------------
# FreeRTOS File/Directory Locations
#-----------------------------------------------------------------------------------
# A list of files and directories in which source files (*.cpp, *.c) and 
# headers (.h). Because we're using FreeRTOS, we have name the proper portable, 
# which identifies the specific architecture we're building for rather than 
# needlessly grabbing whole directories during building. While this has the 
# benefit of reducing the library size substantially, it does have the 
# unfortunate side-effect of needed a separate definition of the
# directories we pull files from, otherwise it'd be hard to clean them up.
# FRT_DIRS:     The specific directories for what we want in the library.
#                In general, this is simply the $(FRT_PATH)/Source directory, but
#                ARM architectures need to rely on a special memory management
#                implementation, so we also include $(FRT_PATH)/portable/MemMang
#
# FRT_INCLUDE:  The directories containing files that need to be included for library
#                compilation. NOTE: These are _NOT_ recursive.
#                It's pretty hard to miss something here because, except for
#                port macros, which are processor-specific, everything is in the
#                $(FRT_PATH)/Source/include directory. Migrating to a different
#                architecture is simple, especially if it natively supported by
#                FreeRTOS, because changing $(PORTABLE) will make the change for you.
#                Porting FreeRTOS to a new board is fairly simple as well, as it
#                simply requires the creation of a new port.c and portmacro.h file
#                in $(FRT_PATH)/Source/portable/GCC/$(PORTABLE), where
#                $(PORTABLE) is a new folder for your board.
#
FRT_DIRS = \
       $(FRT_PATH)/Source                                  \
       $(FRT_PATH)/Source/portable/MemMang                 \
       $(FRT_PATH)/Source/portable/GCC/$(PORTABLE)         \
       $(FRT_CONF_PATH)

FRT_INCLUDE = \
       $(FRT_PATH)/Source/include                          \
       $(FRT_PATH)/Source/portable/GCC/$(PORTABLE)         \
       $(FRT_CONF_PATH)

#-----------------------------------------------------------------------------------
# Compiler Object/Flag Setup
# You REALLY Shouldn't Need to Change Anything Below Here
#-----------------------------------------------------------------------------------
# This is the name of the library file which will hold object code which has been
# compiled from all the source files in the library subdirectories
#
FRT_LIB_NAME = freertoslib.a

# Populate the C compiler flags with includes for all relevant directories
#
CFLAGS += $(patsubst %,-I%,$(FRT_INCLUDE))

# This section makes a list of object files from the source files in subdirectories
# in the FRT_OBJS list, separating the C++, C, and assembly source files
#
FRT_SRC =  $(foreach A_DIR, $(FRT_DIRS), $(wildcard $(A_DIR)/*.cpp)) \
           $(foreach A_DIR, $(FRT_DIRS), $(wildcard $(A_DIR)/*.cc)) \
           $(foreach A_DIR, $(FRT_DIRS), $(wildcard $(A_DIR)/*.c)) \
           $(foreach A_DIR, $(FRT_DIRS), $(wildcard $(A_DIR)/*.S))

FRT_OBJS = $(patsubst %.cpp, %.o, $(filter %.cpp, $(FRT_SRC))) \
           $(patsubst %.cc, %.o, $(filter %.cc, $(FRT_SRC))) \
           $(patsubst %.c, %.o, $(filter %.c, $(FRT_SRC))) \
           $(LIB_ASRC:.S=.o)