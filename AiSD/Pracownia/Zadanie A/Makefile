Flags = -std=gnu99 -Wall -W -O2 -static -lm
CPP = gcc

main : Makefile main.o
	$(CPP) $(Flags) -o main main.o

main.o : Makefile main.c
	$(CPP) -c $(Flags) main.c -o main.o
