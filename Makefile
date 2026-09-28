CC = gcc
CFLAGS = -O2
LDFLAGS = -lm

all: comprestimator

comprestimator: comprestimator.o libz.a
	$(CC) $(CFLAGS) -no-pie -o $@ comprestimator.o libz.a $(LDFLAGS)

comprestimator.o: comprestimator.c
	$(CC) $(CFLAGS) -c comprestimator.c

clean:
	rm -f comprestimator comprestimator.o
