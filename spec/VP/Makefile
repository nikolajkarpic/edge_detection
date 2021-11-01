CC = g++ -lsystemc

.PHONY: clean
.DEFAULT_GOAL := output

output: main.o convolution.o cpu.o vp.o
	@$(CC) main.o convolution.o cpu.o vp.o -o output 
	@echo "Making output executable\n"

main.o: main.cpp vp.hpp
	@$(CC) -c main.cpp 
	@echo "Compiling main.cpp\n"

convolution.o: convolution.cpp common.hpp convolution.hpp vp_address.hpp
	@$(CC) -c convolution.cpp
	@echo "Compiling convolution.cpp\n"

cpu.o: cpu.hpp cpu.cpp vp_address.hpp convolution.hpp common.hpp
	@$(CC) -c cpu.cpp 
	@echo "Compiling cpu.cpp\n"

vp.o: vp.cpp vp.hpp common.hpp cpu.hpp convolution.hpp vp_address.hpp
	@$(CC) -c vp.cpp
	@echo "Compiling vp.cpp\n"
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"