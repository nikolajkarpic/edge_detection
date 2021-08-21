CC = g++ -lsystemc
CFLAGS = `pkg-config --cflags --libs opencv4` 
.DEFAULT_GOAL := output

.PHONY: help clean
help:
	@echo "To run the probram path to the image must be passed as an argument.\nExapmle: make run PATH=/home/user/g3-2021/data/Lenna.png,\nmake - compiles the whole program in output executable,\nmake run PATH='path to the image' compiles and runs executable,"

output: imageProccesing.o inputOutput.o kernelGeneration.o bitTest.o main.o
	@$(CC) main.o bitTest.o imageProccesing.o inputOutput.o kernelGeneration.o -o output $(CFLAGS)
	@echo "Making output executable\n"
imageProccesing.o: imageProccesing.cpp imageProccesing.h common.h
	@$(CC) -c imageProccesing.cpp $(CFLAGS)
	@echo "Compiling imageProccesing.cpp\n"
inputOutput.o: inputOutput.cpp inputOutput.h common.h
	@$(CC) -c inputOutput.cpp $(CFLAGS)
	@echo "Compiling inputOutput.cpp\n"
kernelGeneration.o: kernelGeneration.cpp kernelGeneration.h common.h
	@$(CC) -c kernelGeneration.cpp $(CFLAGS)
	@echo "Compiling kernelGeneration.cpp\n"
bitTest.o: bitTest.cpp bitTest.h common.h
	@$(CC) -c bitTest.cpp $(CFLAGS)
	@echo "Compiling bitTest.cpp\n"
main.o: main.cpp common.h imageProccesing.h kernelGeneration.h inputOutput.h
	@$(CC) -c main.cpp $(CFLAGS)
	@echo "Compiling main.cpp\n"
run: 
	@make output
	@echo "Running exeutable\n"
	@./output $(PATH)
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"
