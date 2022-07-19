CC = g++
.DEFAULT_GOAL := output

.PHONY: help clean
help:
	@echo "To run the probram path to the image must be passed as an argument.\nExapmle: make run PATH=/home/user/g3-2021/data/Lenna.png,\nmake - compiles the whole program in output executable,\nmake run PATH='path to the image' compiles and runs executable,"

output: main.o
	@$(CC) main.o -o output 
	@echo "Making output executable\n"
main.o: main.cpp 
	@$(CC) -c main.cpp
	@echo "Recompiling main.cpp\n"
run: 
	@make output
	@echo "Running exeutable\n"
	@./output $(PATH)
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"
