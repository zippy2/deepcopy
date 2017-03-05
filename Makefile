STRUCTS=structs.x
DEEPCOPY=deepcopy.pl
CFLAGS=-O0 -ggdb -std=c99 -pedantic -D_XOPEN_SOURCE=600

all: structs

structs_gen.h: $(STRUCTS) $(DEEPCOPY)
	perl -w $(DEEPCOPY) --mode=header $(STRUCTS) > $@

structs_gen.c: $(STRUCTS) $(DEEPCOPY)
	perl -w $(DEEPCOPY) --mode=source $(STRUCTS) > $@

%.o: %.c %.h

structs.o: structs_gen.h

structs: structs.o structs_gen.o

clean:
	rm -f *.o structs_gen.h structs_gen.c structs
