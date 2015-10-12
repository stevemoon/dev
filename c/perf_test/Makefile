all: add.c loop.c proc_call.c
	gcc -o add add.c
	gcc -o loop loop.c
	gcc -o proc_call proc_call.c
clean:
	rm add loop proc_call
test: add loop proc_call
	time ./add && time ./loop && time ./proc_call
