AR = ar
#CC = gcc
CFLAGS = -std=c99 -Wall -O2 -s -Wextra

ifneq ($(OS),Windows_NT)
	PIC_FLAGS = -fPIC
endif

SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.o)

GENCODESRC = darm-tbl.c armv7-tbl.c thumb-tbl.c ext-tbl.c
GENCODEOBJ = darm-tbl.o armv7-tbl.o thumb-tbl.o ext-tbl.o

STUFF = $(GENCODESRC) $(GENCODEOBJ) $(OBJ) \
	tests/tests.exe libdarm.a libdarm.so \
	cli/cli.exe

#default: libdarm.a libdarm.so cli/cli.exe tests/tests.exe
defatult: $(STUFF)

$(GENCODESRC): darmgen.py darmbits.py darmtbl.py \
	darmtblthumb.py darmtblthumb2.py darmgen.py
	python darmgen.py

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $^ $(PIC_FLAGS)

%.exe: %.c $(OBJ) $(GENCODEOBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.so: $(OBJ) $(GENCODEOBJ)
	$(CC) -shared $(CFLAGS) -o $@ $^

%.a: $(OBJ) $(GENCODEOBJ)
	$(AR) cr $@ $^

test: $(STUFF)
	./tests/tests.exe

clean:
	rm -f $(STUFF)
