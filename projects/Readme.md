If you'd like to test out a project, first delete the following from the Altrino Due 
root folder:
	
	main.c
	Makefile
	include (directory)

Next, copy and paste the contents of any of the example projects into the root folder

Finally, open up a terminal and enter
	
	make install

This should compile the example and upload it to the board. If you have PuTTY installed,
you can also type
	
	make putty
	
which will open a new PuTTY serial connection to the board (assuming it's mounted 
at dev/ttyACM0)