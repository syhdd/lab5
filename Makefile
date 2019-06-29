all: dynamic_block static_block
clean:
	rm *.o *.so *.a dynamic_block static_block	
dynamic_block: program.o shared.so
	cc program.o shared.so -o dynamic_block -Wl,-rpath .
static_block: program.o static.a
	cc program.o static.a -o static_block -Wl,-rpath .
program.o: program.c
	cc -c program.c -o program.o	
block.o: ./source/block.c
	cc -c ./source/block.c -o ./source/block.o
shared.so: block.o
	cc -shared -o shared.so ./source/block.o
static.a: block.o
	ar qc -o static.a ./source/block.o	
program.o: headers/block.h
block.o: ./headers/block.h
