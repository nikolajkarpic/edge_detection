CC = g++ -lsystemc

.PHONY: clean
.DEFAULT_GOAL := output

output: main.o
	@$(CC) main.o -o output 
	@echo "Making output executable\n"

main.o: main.cpp common.hpp Hardware.hpp Software.hpp
	@$(CC) -c main.cpp 
	@echo "Compiling main.cpp\n"
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"