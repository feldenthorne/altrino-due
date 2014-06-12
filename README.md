Altrino Due
Author: Feldenthorne
========

Description: 
This is the source code for an alternative build environment for the Arduino Due. The project 
stemmed from a the need for a more robust development environment for the Arduino
Due than could be (easily) managed within the confines of the Arduino IDE and it's weird
"throw everything in a base folder to compile" approach.

To put a few details to this setup, it:
	* Relies on a modified standard Makefile from the Atmel Software Framework (ASF)
	* Incorporates many ASF features into a system library (timers, UART, GPIO, etcetera)
	* REQUIRES the user to install BOSSA and gcc-arm-none-eabi

Currently, this project builds a slightly modified "Getting Started" example from the
Atmel Software Framework source for the Arduino Due, just to give the user an idea of how
things work.

---
Downloading Source:
In order to download the source, which is maintained with the aid of the version-control software
Git, it is necessary to download a Git or Subversion client. (It's actually not -entirely-
necessary, but highly suggested for retrieving updates. If you're put off by installing one more
piece of software, you can download a tarball of the most recent release.)

When you have your desired client, follow the general procedure for Git or Subversion checkouts

    Repository URL: 	https://github.com/feldenthorne/altrino-due
    Git: 				git clone https://github.com/feldenthorne/altrino-due.git
    Subversion: 		svn checkout https://github.com/feldenthorne/altrino-due

Additionally, when using Subversion, the checked out folder will open directly to the checkout 
folder if the "append source URL name to subfolder" option is disabled upon checkout. This is often 
an option on the Checkout window in a GUI or by specifying the folder path explicitly during a 
command line checkout. 

---
How to Build:
In order to build anything using this framework, it is necessary to download and install two
pieces of software: an ARM-based compiler and a program to upload compiled programs to the Due.
A third required download is the Atmel Software Framework, which only needs to be unzipped and
placed in the lib directory in a folder called ASF.

= COMPILER
The compiler required is arm-none-eabi-gcc, which is a bare-metal (no particular OS) compiler. 
There multitudinous options for installing it, so you should pick one suitable to your needs. 
This project was originally developed on a Linux-based system, however, and this terminal-based 
install method worked for the author:
 * First, grab your dependencies
	sudo apt-get install python-serial python-argparse openocd \
    flex bison libncurses5-dev autoconf texinfo build-essential \
    libftdi-dev libtool zlib1g-dev genromfs git-core wget
    
 * If you're on a 64-bit system, grab
	sudo apt-get install ia32-libs

 * If that throws errors, download the 32-bit packages individually
	sudo apt-get install libc6:i386 libgcc1:i386 gcc-4.6-base:i386 libstdc++5:i386 libstdc++6:i386

 * Download, unzip, and install the toolchain (this takes a while!)
	cd ~
	wget https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q1-update/+download/gcc-arm-none-eabi-4_8-2014q1-20140314-linux.tar.bz2
	tar -jxf gcc-arm-none-eabi-4_8-2014q1-20140314-linux.tar.bz2
	exportline="export PATH=$HOME/gcc-arm-none-eabi-4_7-2014q2/bin:\$PATH"
	if grep -Fxq "$exportline" ~/.profile; then echo nothing to do ; else echo $exportline >> ~/.profile; fi
	. ~/.profile

The above setup method is a slightly condensed version of the explanation given by
pixhawk.org here: http://pixhawk.org/dev/toolchain_installation_lin .

	
= BOSSA (http://www.shumatech.com/web/products/bossa)
BOSSA is an open-source alternative to Atmel's proprietary BIN file uploader for their ARM
processors - and it's the one that the Arduino IDE uses, if you're interested. Needless to say,
it's necessary to install it to upload any programs to your Due using this environment.

If you're using a Debian/Ubuntu distribution, you can download "bossac" using
	sudo apt-get install bossac

Otherwise, you can download the binaries for your particular system on their SourceForge
page: http://sourceforge.net/projects/b-o-s-s-a/files/

= USING THE MAKEFILE
Building using the provided Makefile is pretty simplistic: navigate to the project's
source directory in a command prompt or terminal window and type
	make

For added convenience, the Makefile also supports:
	make clean		Cleans up compiled and temp files
	make lib		Builds the library file
	make install	Builds the project file and uploads it to your Due using bossac

---
Building Documentation:
Documentation will be added in a future release, but it will eventually be buildable with the 
command
	make doc