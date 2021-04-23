Flags = -std=gnu++11 -Wall -W -O2 -static
CPP = g++

main : Makefile main.o
	$(CPP) $(Flags) -o main main.o

main.o : Makefile main.cpp
	$(CPP) -c $(Flags) main.cpp -o main.o
