CC = g++ -lsystemc

.PHONY: clean
.DEFAULT_GOAL := output

output: main.o convolution.o cpu.o vp.o
	@$(CC) main.o convolution.o cpu.o vp.o -o output 
	@echo "Making output executable\n"

main.o: main.cpp common.hpp cpu.hpp convolution.hpp vp_address.hpp
	@$(CC) -c main.cpp 
	@echo "Compiling main.cpp\n"

convolution.o: 	
	@$(CC) -c convolution.cpp
	@echo "Compiling convolution.cpp\n"

cpu.o:
	@$(CC) -c cpu.cpp 
	@echo "Compiling cpu.cpp\n"

vp.o:
	@$(CC) -c vp.cpp
	@echo "Compiling vp.cpp\n"
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"