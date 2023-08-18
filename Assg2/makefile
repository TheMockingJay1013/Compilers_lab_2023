
a.out : main.o libmyl.a 
		gcc main.o -L. -lmyl

main.o : main.c
		gcc -Wall -c main.c

libmyl.a: ass2_21CS30032.o
					ar -rcs libmyl.a ass2_21CS30032.o

ass2_21CS30032.o : ass2_21CS30032.c myl.h
				gcc -Wall -c ass2_21CS30032.c

clean :
	rm -f a.out main.o libmyl.a ass2_21CS30032.o