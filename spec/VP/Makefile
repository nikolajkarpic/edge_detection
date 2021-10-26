CC = g++ -lsystemc

.PHONY: clean
.DEFAULT_GOAL := output

output: main.o
	@$(CC) main.o -o output 
	@echo "Making output executable\n"
clean:
	@rm *.o output
	@echo "Deleting all .o files\n"