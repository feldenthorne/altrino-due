These Makefiles are conveniently hard to run from this directory... because 
they shouldn't be run from this directory.

If you want to include a feature built by these Makefiles, include them as the first line 
in the main project Makefile in $(PROJECT_ROOT) as follows:
     include (nameofmakefile)

     -in example, to compile the ASF library-
     include asflib.mk