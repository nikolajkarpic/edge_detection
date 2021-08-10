CC = g++
<<<<<<< HEAD
CFLAGS = -std=c++11 `pkg-config --cflags --libs opencv`
=======
CFLAGS = -std=c++11 `pkg-config --cflags --libs opencv4`
>>>>>>> b51a75d (Added padding to the input images)
.DEFAULT_GOAL := output

.PHONY: help clean
help:
	@echo "To run the probram path to the image must be passed as an argument.\nExapmle: make run PATH=/home/user/g3-2021/data/Lenna.png,\nmake - compiles the whole program in output executable,\nmake run PATH='path to the image' compiles and runs executable,"

output: main.o imageProccesing.o inputOutput.o kernelGeneration.o
	@$(CC) main.o imageProccesing.o inputOutput.o kernelGeneration.o -o output $(CFLAGS)
	@echo "Making output executable\n"
main.o: main.cpp common.h imageProccesing.h kernelGeneration.h inputOutput.h
	@$(CC) -c main.cpp $(CFLAGS)
	@echo "Recompiling main.cpp\n"
imageProccesing.o: imageProccesing.cpp imageProccesing.h
	@$(CC) -c imageProccesing.cpp $(CFLAGS)
	@echo "Recompiling imageProccesing.cpp\n"
inputOutput.o: inputOutput.cpp inputOutput.h
	@$(CC) -c inputOutput.cpp $(CFLAGS)
	@echo "Recompiling inputOutput.cpp\n"
kernelGeneration.o: kernelGeneration.cpp kernelGeneration.h
	@$(CC) -c kernelGeneration.cpp $(CFLAGS)
	@echo "Recompiling kernelGeneration.cpp\n"
run: 
	@make output
	@echo "Running exeutable\n"
	@./output $(PATH)
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"
