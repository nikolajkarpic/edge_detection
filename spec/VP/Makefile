CC = g++ -lsystemc

.PHONY: clean
.DEFAULT_GOAL := output

output: main.o vp.o convolution.o cpu.o memory.o interconnect.o
	@$(CC) main.o convolution.o cpu.o vp.o memory.o interconnect.o -o output 
	@echo "Making output executable\n"

main.o: main.cpp vp.cpp vp.hpp
	@$(CC) -c main.cpp 
	@echo "Compiling main.cpp\n"
vp.o: vp.cpp vp.hpp common.hpp cpu.cpp cpu.hpp convolution.cpp convolution.hpp vp_address.hpp memory.hpp memory.cpp
	@$(CC) -c vp.cpp 
	@echo "Compiling vp.cpp\n"
convolution.o: convolution.cpp common.hpp convolution.hpp vp_address.hpp
	@$(CC) -c convolution.cpp 
	@echo "Compiling convolution.cpp\n"

cpu.o: cpu.hpp cpu.cpp vp_address.hpp convolution.cpp convolution.hpp common.hpp
	@$(CC) -c cpu.cpp 
	@echo "Compiling cpu.cpp\n"

memory.o: memory.cpp memory.hpp common.hpp vp_address.hpp cpu.hpp cpu.cpp convolution.hpp convolution.cpp
	@$(CC) -c memory.cpp 
	@echo "Compiling memory.cpp\n"

interconnect.o: common.hpp cpu.cpp cpu.hpp convolution.cpp convolution.hpp vp_address.hpp memory.hpp memory.cpp
	@$(CC) -c interconnect.cpp
	@echo "Compiling interconnect.cpp\n"
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"