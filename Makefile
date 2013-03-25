include ../src_config.mk
include config.mk

DEP_FILE = Makefile.deps

OBJ     = sdb.o util.o tracee.o prompt.o arch/arch.o \
					os/${OS_NAME}/ptrace.o os/${OS_NAME}/${OS_NAME}.o

CFLAGS   += -Wmissing-prototypes # until merged into ../
CPPFLAGS += -Iarch/${ARCH}

sdb: ${OBJ}
	${CC} ${LDFLAGS} -o $@ ${OBJ}

.c.o:
	${CC} ${CPPFLAGS} ${CFLAGS} -c -o $@ $<

clean:
	rm -f ${OBJ} sdb

deps:
	cc ${CPPFLAGS} -MM *.c > ${DEP_FILE}
	PRE=arch/         ; cc ${CPPFLAGS} -MM $$PRE/*.c | sed 's;^;'$$PRE';' >> ${DEP_FILE}
	PRE=os/${OS_NAME}/; cc ${CPPFLAGS} -MM $$PRE/*.c | sed 's;^;'$$PRE';' >> ${DEP_FILE}

.PHONY: clean

include ${DEP_FILE}
