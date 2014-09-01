# Atmel Software Framework Library Makefile
# Mini-disclaimer: This file was not developed or endorsed by Atmel

# List of phony commands
.PHONY: all library clean

#-----------------------------------------------------------------------------------
# ASF Locations
#-----------------------------------------------------------------------------------
# ASF_PATH: Path to top level ASF directory relative to this project directory -
#            this allows the compiler to find everything it needs to build a
#            library of all ASF/CMSIS files relevant to a particular board.
#            Unless you mess around with the directories, because this is located
#            in the $(PROJECT_ROOT)/common directory, the path here should be left 
#            as:    lib/ASF
#
ASF_PATH = lib/ASF

#-----------------------------------------------------------------------------------
# ASF-Specific Declarations
#-----------------------------------------------------------------------------------
# BOARD:        The name of the board from $(ASF_PATH)/common/boards/board.h
#                If you're using an Arduino Due, this is:  ARDUINO_DUE_X .
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
# ASF_FOLDER:   The name of the board folder that holds configuration files for your
#                board within the Atmel Software Framework
#                If you're using an Arduino Due, this is:  arduino_due_x
#                If you're using a different board, find its folder in the 
#                $(ASF_PATH)/sam/boards directory and use that folder name.
#                For non-standard boards, you should be able to set this up using
#                the USER_BOARD setup mentioned above.
#
BOARD = ARDUINO_DUE_X
ASF_FOLDER = arduino_due_x

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
# ASF File/Directory Locations
#-----------------------------------------------------------------------------------
# A list of files and directories in which source files (*.cpp, *.c) and 
# headers (.h). Because of the introduction of architecture and part-specific code,
# and the way ASF defines parts within $(ASF_PATH)/common/util/parts.h, specific
# targets need to be identified rather than grabbing whole directories during
# building. While this has the benefit of reducing the library size substantially,
# it does have the unfortunate side-effect of needed a separate definition of the
# directories we pull files from, otherwise it'd be hard to clean them up.
#
# ASF_FILES:    The specific file locations for what we want in the library.
#                For the Arduino Due, the Non-Volatile Memory, ADC, PIO, PMC, sleep,
#                SPI, TWI, UART, USART, and Watchdog Timer drivers are selected,
#                along with a clock, serial, and SPI service.
#                The standard SAM interrupt vectors, as well as the MCU-specific
#                startup files are also included.
#                If you want to use another board or change these includes, you'll
#                have to do a bit of digging in the $(ASF_PATH)/common and
#                $(ASF_PATH)/sam directories for drivers, services, and utilities.
#
# ASF_CL_DIR:   The directories for files to be included in the library. This is
#                used only to make cleaning the created object files out of
#                the directories possible.
#                In general, if you add a driver, service, or utility to the
#                $(ASF_FILES), you should add its direcory here.
#                This define could probably be removed by replacing the ".c"
#                extension with a ".o" extension for every member of $(ASF_FILES),
#                but that hasn't been toyed with because this framework is in its
#                infancy.
#
# ASF_INCLUDE:  The directories containing files that need to be included for library
#                compilation. NOTE: These are _NOT_ recursive.
#                In general, if you see a header in a directory with something you
#                want to add to $(ASF_FILES), include that directory. Try to compile
#                and figure out what headers you're missing, if there are any.
#                If you are missing a header and can't find it, run a "grep -r"
#                search in Linux environment. In Windows, indexing the project 
#                directory and using Windows search should work.
#

ASF_FILES = \
       common/drivers/nvm/sam                              \
       common/services/clock/$(PART_BASE)                  \
       common/services/serial                              \
       common/services/spi/sam_spi                         \
       common/utils/interrupt                              \
       common/utils/stdio                                  \
       sam/boards/$(ASF_FOLDER)                            \
       sam/drivers/adc                                     \
       sam/drivers/efc                                     \
       sam/drivers/pio                                     \
       sam/drivers/pmc                                     \
       sam/drivers/spi                                     \
       sam/drivers/tc                                      \
       sam/drivers/twi                                     \
       sam/drivers/uart                                    \
       sam/drivers/usart                                   \
       sam/drivers/wdt                                     \
       sam/utils/cmsis/$(PART_BASE)/source/templates       \
       sam/utils/cmsis/$(PART_BASE)/source/templates/gcc

ASF_CL_DIR = $(ASF_FILES)

ASF_INCLUDE = \
       common/boards                                       \
       common/drivers/nvm                                  \
       common/drivers/nvm/sam/module_config                \
       common/services/clock                               \
       common/services/clock/$(PART_BASE)/module_config    \
       common/services/gpio                                \
       common/services/ioport                              \
       common/services/sleepmgr                            \
       common/services/sleepmgr/sam/module_config          \
       common/services/serial                              \
       common/services/serial/sam_uart                     \
       common/services/spi                                 \
       common/services/spi/sam_spi/module_config           \
       common/services/twi                                 \
       common/services/twi/sam_twi                         \
       common/services/twi/sam_twihs                       \
       common/services/twi/sam_twim                        \
       common/services/usb/udc                             \
       common/services/usb/uhc                             \
       common/services/usb/class/cdc                       \
       common/services/usb/class/cdc/device                \
       common/services/usb/class/cdc/device/module_config  \
       common/services/usb/class/cdc/host                  \
       common/services/usb/class/cdc/host/module_config    \
       common/services/usb/class/cdc                       \
       common/services/usb/class/composite                 \
       common/services/usb/class/composite/device          \
       common/services/usb/class/composite/device/module_config \
       common/services/usb/class/composite/host            \
       common/services/usb/class/composite/host/module_config \
       common/utils                                        \
       common/utils/stdio/stdio_serial                     \
       sam/boards                                          \
       sam/boards/$(ASF_FOLDER)                            \
       sam/boards/$(ASF_FOLDER)/board_config               \
       sam/drivers/adc                                     \
       sam/drivers/efc                                     \
       sam/drivers/pio                                     \
       sam/drivers/pmc                                     \
       sam/drivers/spi                                     \
       sam/drivers/tc                                      \
       sam/drivers/twi                                     \
       sam/drivers/uart                                    \
       sam/drivers/usart                                   \
       sam/drivers/wdt                                     \
       sam/services/flash_efc                              \
       sam/utils                                           \
       sam/utils/cmsis/$(PART_BASE)/include                \
       sam/utils/cmsis/$(PART_BASE)/include/component      \
       sam/utils/cmsis/$(PART_BASE)/include/instance       \
       sam/utils/cmsis/$(PART_BASE)/include/pio            \
       sam/utils/cmsis/$(PART_BASE)/source/templates       \
       sam/utils/header_files                              \
       sam/utils/preprocessor                              \
       thirdparty/CMSIS/Include                            \
       thirdparty/CMSIS/Lib/GCC

# If the user has named a custom UART configuration file, don't use the standard ASF
# file, located at $(ASF_DIR)/common/services/serial/sam_uart/module_config
ifneq ($(ASF_CONFIG),)
ASF_INCLUDE += ../../$(ASF_CONFIG)
else
ASF_INCLUDE += common/services/serial/sam_uart/module_config
endif


#-----------------------------------------------------------------------------------
# Compiler Object/Flag Setup
# You REALLY Shouldn't Need to Change Anything Below Here
#-----------------------------------------------------------------------------------
# This is the name of the library file which will hold object code which has been
# compiled from all the source files in the library subdirectories
#
ASF_LIB_NAME = asflib.a

# Add the path the the ASF folder as a prefix to source files and includes
#
ASF_OBJ   = $(addprefix $(ASF_PATH)/,$(ASF_FILES))
ASF_CLEAN = $(addprefix $(ASF_PATH)/,$(ASF_CL_DIR))
ASF_FLAGS = $(addprefix $(ASF_PATH)/,$(ASF_INCLUDE))

# Populate the C compiler flags with includes for all relevant directories
#
CFLAGS += $(patsubst %,-I%,$(ASF_FLAGS))

# This section makes a list of object files from the source files in subdirectories
# in the ASF_OBJ list, separating the C++, C, and assembly source files
#
ASF_SRCS =  $(foreach A_DIR, $(ASF_OBJ), $(wildcard $(A_DIR)/*.cpp)) \
           $(foreach A_DIR, $(ASF_OBJ), $(wildcard $(A_DIR)/*.cc)) \
           $(foreach A_DIR, $(ASF_OBJ), $(wildcard $(A_DIR)/*.c)) \
           $(foreach A_DIR, $(ASF_OBJ), $(wildcard $(A_DIR)/*.S))
           
ASF_SRC   = $(filter-out lib/ASF/sam/drivers/adc/adc2.c lib/ASF/sam/drivers/wdt/wdt_sam4l.c,$(ASF_SRCS))

ASF_LIB_OBJS = \
           $(patsubst %.cpp, %.o, $(filter %.cpp, $(ASF_SRC))) \
           $(patsubst %.cc, %.o, $(filter %.cc, $(ASF_SRC))) \
           $(patsubst %.c, %.o, $(filter %.c, $(ASF_SRC))) \
           $(LIB_ASRC:.S=.o)
