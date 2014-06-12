# Syscalls Makefile
# Mini-disclaimer: This file was not developed or ARM or Atmel.

# List of phony commands
.PHONY: all library clean

#-----------------------------------------------------------------------------------
# Syscalls Location
#-----------------------------------------------------------------------------------
# SYSCALL_PATH: Path to top level FreeRTOS directory relative to this project directory.
#            this allows the compiler to find everything it needs to build a
#            library of all FreeRTOS files relevant to a particular board.
#            Unless you mess around with the directories, because this is located
#            in the $(PROJECT_ROOT)/common directory, the path here should be left 
#            as:    lib/FreeRTOS
#
SYSCALL_PATH = lib/ASF/sam/utils/syscalls/gcc

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
SYSCALL_DIRS = \
       $(SYSCALL_PATH)

SYSCALL_INCLUDE = \
       $(SYSCALL_PATH)

#-----------------------------------------------------------------------------------
# Compiler Object/Flag Setup
# You REALLY Shouldn't Need to Change Anything Below Here
#-----------------------------------------------------------------------------------
# Populate the C compiler flags with includes for all relevant directories
#
CFLAGS += $(patsubst %,-I%,$(SYSCALL_INCLUDE))