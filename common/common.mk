# Common ARM Makefile

# List of phony commands
.PHONY: all library clean install putty

#-----------------------------------------------------------------------------------
# Compiler Object/Flag Setup
# You REALLY Shouldn't Need to Change Anything Below Here
#-----------------------------------------------------------------------------------
# This is the name of the library file which will hold object code which has been
# compiled from all the source files in the library subdirectories
#
LIB_NAME = syslib.a
LIB_INCLUDE = $(FRT_INCLUDE) \
              $(addprefix $(ASF_PATH)/,$(ASF_INCLUDE)) \
              $(SYSCALL_INCLUDE)
CMSIS_LIB = $(addprefix $(ASF_PATH)/$(LIB_PATH)/,$(CMSIS_LIBS))

# Populate the C compiler flags with includes for all relevant directories
#
CFLAGS += $(patsubst %,-I%,$(LIB_INCLUDE))
CFLAGS += $(patsubst %,-I%,$(PROJ_INC))

CPPFLAGS += $(patsubst %,-I%,$(LIB_INCLUDE))
CPPFLAGS += $(patsubst %,-I%,$(PROJ_INC))

CXXFLAGS += $(patsubst %,-I%,$(LIB_INCLUDE))
CXXFLAGS += $(patsubst %,-I%,$(PROJ_INC))

# Add in the user-defined syscalls
#
PROJ_DIRS += \
          $(SYSCALL_DIRS)

# This section makes a list of object files from the source files in subdirectories
# in the PROJ_OBJS list, separating the C++, C, and assembly source files
#
PROJ_SRCS =  \
           $(foreach A_DIR, $(PROJ_DIRS), $(wildcard $(A_DIR)/*.cpp)) \
           $(foreach A_DIR, $(PROJ_DIRS), $(wildcard $(A_DIR)/*.cc)) \
           $(foreach A_DIR, $(PROJ_DIRS), $(wildcard $(A_DIR)/*.c)) \
           $(foreach A_DIR, $(PROJ_DIRS), $(wildcard $(A_DIR)/*.S))
           
           
PROJ_SRC  = $(filter-out lib/ASF/sam/applications/getting-started/main_sam4l.c,$(PROJ_SRCS))

PROJ_SRC += $(FRT_HEAP) $(FRT_PORT)

PROJ_OBJS = \
           $(patsubst %.cpp, %.o, $(filter %.cpp, $(PROJ_SRC))) \
           $(patsubst %.cc, %.o, $(filter %.cc, $(PROJ_SRC))) \
           $(patsubst %.c, %.o, $(filter %.c, $(PROJ_SRC))) \
           $(PROJ_ASRC:.S=.o)

#FRT_DIRS += $(FRT_HEAP_DIR) $(FRT_PORT_DIR)
           
#################COMPILER JUNK
CROSS           ?= arm-none-eabi-
AR              := $(CROSS)ar
AS              := $(CROSS)as
CC              := $(CROSS)gcc
CPP             := $(CROSS)gcc -E
CXX             := $(CROSS)g++
LD              := $(CROSS)g++
NM              := $(CROSS)nm
OBJCOPY         := $(CROSS)objcopy
OBJDUMP         := $(CROSS)objdump
SIZE            := $(CROSS)size
GDB             := $(CROSS)gdb

# This section is mostly just taken from the massive default SAM makefile 
# provided by Atmel in their software framework at /sam/utils/make/Makefile.sam.in
# This bit takes all the previously defined flags and stuffs them into
# Make defines that you'd have to be crazy to pick normally, so the average
# Make-r won't overwrite them
arflags-gnu-y           := $(ARFLAGS)
asflags-gnu-y           := $(ASFLAGS)
cflags-gnu-y            := $(CFLAGS)
cxxflags-gnu-y          := $(CXXFLAGS)
cppflags-gnu-y          := $(CPPFLAGS)
cpuflags-gnu-y          := 
dbgflags-gnu-y          := $(DBGFLAGS)
libflags-gnu-y          := $(CMSIS_LIB)
ldflags-gnu-y           := $(LDFLAGS)
flashflags-gnu-y        := 

# Use pipes instead of temporary files for communication between processes
#cflags-gnu-y    += -pipe
#asflags-gnu-y   += -pipe
#ldflags-gnu-y   += -pipe

##########NEWSTUFF
target          = $(TARGET_FLASH)
linker_script   = $(ASF_PATH)/$(LINKER_SCRIPT_FLASH)
debug_script    = $(ASF_PATH)/$(DEBUG_SCRIPT_FLASH)
target_type     = elf


# Create object files list from source files list.
obj-y    = $(PROJ_OBJS)
# Create dependency files list from source files list.
dep-files  = $(wildcard $(foreach f,$(obj-y),$(basename $(f)).d))

####################

optflags-gnu-y  = $(OPTIMIZATION)

# Archiver flags
# NOTE: This is changed slightly from the default SAM Makefile to give the library a
# readable name
arflags-gnu-y   +=  $(LIB_NAME)

# Always enable warnings. And be very careful about implicit
# declarations.
cflags-gnu-y    += -Wall -Wstrict-prototypes -Wmissing-prototypes
cflags-gnu-y    += -Werror-implicit-function-declaration
cxxflags-gnu-y  += -Wall
# IAR doesn't allow arithmetic on void pointers, so warn about that.
cflags-gnu-y    += -Wpointer-arith
cxxflags-gnu-y  += -Wpointer-arith

# CPU specific flags.
cpuflags-gnu-y  += -mcpu=$(ARCH) -mthumb -D__$(PART)__ -D BOARD=$(BOARD)

# Dependency file flags.
depflags        = -MD -MP -MQ $@

# Always preprocess assembler files.
asflags-gnu-y   += -x assembler-with-cpp
# Compile C files using the GNU99 standard.
cflags-gnu-y    += -std=gnu99
# Compile C++ files using the GNU++98 standard.
cxxflags-gnu-y  += -std=gnu++98

# Don't use strict aliasing (very common in embedded applications).
cflags-gnu-y    += -fno-strict-aliasing
cxxflags-gnu-y  += -fno-strict-aliasing

# Separate each function and data into its own separate section to allow
# garbage collection of unused sections.
cflags-gnu-y    += -ffunction-sections -fdata-sections
cxxflags-gnu-y  += -ffunction-sections -fdata-sections

# Various cflags.
cflags-gnu-y += -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int
cflags-gnu-y += -Wmain -Wparentheses
cflags-gnu-y += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
cflags-gnu-y += -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef
cflags-gnu-y += -Wshadow -Wbad-function-cast -Wwrite-strings
cflags-gnu-y += -Wsign-compare -Waggregate-return
cflags-gnu-y += -Wmissing-declarations
cflags-gnu-y += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
cflags-gnu-y += -Wpacked -Wredundant-decls -Wnested-externs -Winline -Wlong-long
cflags-gnu-y += -Wunreachable-code
cflags-gnu-y += -Wcast-align
cflags-gnu-y += --param max-inline-insns-single=500

cppflags-gnu-y += -Wall -Wchar-subscripts -Wcomment -Wformat=2
cppflags-gnu-y += -Wmain -Wparentheses -Wcast-align -Wunreachable-code
cppflags-gnu-y += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
cppflags-gnu-y += -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef
cppflags-gnu-y += -Wshadow -Wpointer-arith -Wwrite-strings
cppflags-gnu-y += -Wsign-compare -Waggregate-return -Wmissing-declarations
cppflags-gnu-y += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
cppflags-gnu-y += -Wpacked -Wredundant-decls -Winline -Wlong-long
cppflags-gnu-y += --param max-inline-insns-single=500
# To reduce application size use only integer printf function.
cppflags-gnu-y += -Dprintf=iprintf

# Garbage collect unreferred sections when linking.
ldflags-gnu-y   += -Wl,--gc-sections

# Use the linker script if provided by the project.
ifneq ($(strip $(linker_script)),)
ldflags-gnu-y += -lgcc -lc -lm
ldflags-gnu-y   += -Wl,-T $(linker_script)
endif

#To check to see if the linker script is giving issues, remove -Wl,-T$(linker-script) above
# and replace it with: -lrdimon
# The rdimon library is one with basic linkages defined for debugging purposes

startgroup-gnu-y = -Wl,--start-group
endgroup-gnu-y = -Wl,--end-group

#ldflags-gnu-y   += $(patsubst %,-L%,$(LIB_PATH))

# Finally, this bit forces all the command-line parameters relevant to building
# specific files into proper flag defines.
# It makes flags for Assembly, C, C++, Mixed C/C++, the Linker, and the Archiver
a_flags  = $(cpuflags-gnu-y) $(depflags) $(cppflags-gnu-y) \
           $(asflags-gnu-y) -D__ASSEMBLY__
c_flags  = $(cpuflags-gnu-y) $(dbgflags-gnu-y) $(depflags) \
           $(optflags-gnu-y) $(cppflags-gnu-y) $(cflags-gnu-y)
cxx_flags= $(cpuflags-gnu-y) $(dbgflags-gnu-y) $(depflags) \
           $(optflags-gnu-y) $(cppflags-gnu-y) $(cxxflags-gnu-y)
l_flags  = $(cpuflags-gnu-y) $(optflags-gnu-y) $(ldflags-gnu-y)
ar_flags = $(arflags-gnu-y)


#-----------------------------------------------------------------------------------
# Inference Rules 
#  Show how to process each kind of file
#-----------------------------------------------------------------------------------
# How to compile a .c file into a .o file
.c.o:
	@echo $<
	@$(CC) -c $(c_flags) $< -o $@

# How to compile a .cc file into a .o file
.cc.o:
	@echo $<
	@$(CXX) -c $(cxx_flags) $< -o $@

# How to compile a .cpp file into a .o file
.cpp.o:
	@echo $<
	@$(CC) -E $(cxx_flags) $< -o $@

# How to compile an .S file into a .o file
.S.o:
	@echo $<
	@$(CC) $(a_flags) -c $< -o $@

	
#-----------------------------------------------------------------------------------
# 'make'
#-----------------------------------------------------------------------------------
# Make the main target of this project.  This target is invoked when the user types 
# 'make' as opposed to 'make <target>'  This must be the first target in Makefile.
#
all: library $(target).elf $(target).bin

#$(target).elf: $(linker_script) $(obj-y)
#	@echo $(linker_script)
#	@echo Linking
#	arm-none-eabi-ld $(l_flags) $(obj-y) $(libflags-gnu-y) -o $@
#	@echo size
#	$(SIZE) -Ax $@
#	$(SIZE) -Bx $@
	
$(target).elf:  $(PROJ_OBJS)
	$(LD) $(startgroup-gnu-y) -Wl,--entry=Reset_Handler $(l_flags) $(PROJ_OBJS)  $(LIB_NAME) $(libflags-gnu-y) $(endgroup-gnu-y)  -g -o $@
	@echo size
	@$(SIZE) -Bx $@
#	@echo flags $(c_flags)
#	$(LD) $(l_flags) $(PROJ_OBJS) -o $@
#	@$(LD) $(l_flags) $(PROJ_OBJS) $(LIB_NAME) $(libflags-gnu-y) -o $@

# Create binary image from ELF output file.
$(target).bin:
	@echo Making bin
	$(OBJCOPY) -O binary $(target).elf $@

#-----------------------------------------------------------------------------------
# 'make library' 
#-----------------------------------------------------------------------------------
# Builds the library file, using an automatically generated list of
# all the C, C++, and assembly source files in the library files 
# listed in $(ASF_FILES)
#
library:  $(FRT_OBJS) $(ASF_LIB_OBJS)
	@echo "cats " $(FRT_OBJS)
	$(AR) r $(ar_flags) $(FRT_OBJS) $(ASF_LIB_OBJS)
	
#-----------------------------------------------------------------------------------
# 'make install' 
#-----------------------------------------------------------------------------------
# Uses the BOSSA command line program bossac to upload the generated 
# $(target).bin file to the board.
# NOTE: This currently fails if the board is programmed, for some reason.
#       It likely has something to do with BOSSA looking to connect on particular
#       serial port (ttyACM0), then not finding it because the board tends to
#       reinitialize to ttyACM1 after programming.
#       If you run into this problem, perform a flash erase on the board:
#       Hold down the reset and erase buttons, let finger off reset, wait a second
#
install:  all 
	bossac -e -w -v -b $(target).bin

#-----------------------------------------------------------------------------------
# 'make clean' 
#-----------------------------------------------------------------------------------
# Erases the compiled files so you can restart the building process
# from a clean slate. It's also useful before committing files to a CVS or SVN 
# or Git repository.
#
clean:
	@echo -n Cleaning up the ASF library build files...
	@rm -f $(ASF_LIB_NAME) *.o *.d *.hex *.lst *.elf *.bin *~
	@for subdir in $(ASF_CLEAN); do \
		rm -f $$subdir/*.o; \
		rm -f $$subdir/*.d; \
		rm -f $$subdir/*.lst; \
		rm -f $$subdir/*~; \
	done
	@echo done.
	
	@echo -n Cleaning up the FreeRTOS library build files...
	@rm -f $(FRT_LIB_NAME) *.d *.o *.hex *.lst *.elf *.bin *~
	@for subdir in $(FRT_DIRS); do \
		rm -f $$subdir/*.o; \
		rm -f $$subdir/*.d; \
		rm -f $$subdir/*.lst; \
		rm -f $$subdir/*~; \
	done
	@echo done.
	
	@echo -n Cleaning up syscall build files...
	@for subdir in $(SYSCALL_DIRS); do \
		rm -f $$subdir/*.o; \
		rm -f $$subdir/*.d; \
		rm -f $$subdir/*.lst; \
		rm -f $$subdir/*~; \
	done
	@echo done.
	
	@echo -n Removing the system library...
	@rm -f $(LIB_NAME)
	@echo done.
	
#-----------------------------------------------------------------------------------
# 'make putty' 
#-----------------------------------------------------------------------------------
# This opens a PuTTY terminal with standard settings for this environment: a serial
# port at /dev/ttyACM0 and a baudrate of 115200 bps. It also states the data transfer
# protocol specifically, but I'm not sure if that's necessary.
#
# The "-serial XXX" argument defines the serial port that the computer identifies the
# MCU with. In most cases, this is /dev/ttyACM0 on Ubuntu, but occasionally if pops
# up as /dev/ttyACM1 if Ubuntu hasn't realized that the device at ACM0 has disconnected.
#
# The "-sercfg XXX" argument defines, in order: baudrate, number of bits transferred,
# parity, and data flow control. The default settings here are '115200' baud, '8' bits 
# per data packet, 'n' for no parity, '1' for a single stop bit, and 'N' for no flow
# control.
#
# As a general note, Ubuntu 14.04 has a bug with GLib that makes the terminal fill with
# garbage when using this command, for now. An article,
# https://bugs.launchpad.net/ubuntu/+source/gnome-control-center/+bug/1264368, describes
# that the g_source_remove() method in GLib throws this warning when an already
# terminated process is passed in for termination. It's a bit annoying, but harmless.
#
putty:
	putty -serial /dev/ttyACM0 -sercfg 115200,8,n,1,N