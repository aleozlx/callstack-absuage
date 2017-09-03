SHELL=/bin/bash
MKDIR=mkdir
RM=rm -fv
AR=ar crs
LD=ld
UNZIP=unzip
TIME=/usr/bin/time -a -o hw2.time -v
INSTALL=install

TOOL_CHAIN=clang
ifeq ($(TOOL_CHAIN),clang)
	CC=clang
	CXX=clang++
	CFLAGS=-std=gnu99 -O2 -Weverything -Wno-sign-conversion -Wno-unused-parameter -Wno-missing-prototypes -Wno-padded -Wno-missing-noreturn -iquote $(INCLUDE)
	CCFLAGS=-std=c++11 -O2 -Weverything -Wno-c++98-compat-pedantic -Wno-sign-conversion -Wno-unused-parameter -Wno-missing-prototypes -Wno-padded -Wno-vla -Wno-vla-extension -Wno-shadow -Wno-double-promotion -iquote $(INCLUDE)
else
	CC=gcc
	CXX=g++
	CFLAGS=-std=gnu99 $(PROF_ARGS) -O3 -Wall -iquote $(INCLUDE)
	CCFLAGS=-std=c++11 $(PROF_ARGS) -O2 -Wall -iquote $(INCLUDE)
endif

LDFLAGS=-lstdc++

BINDIR=bin
SRCDIR=src
LIBDIR=lib
DATADIR=../datafiles
INCLUDE=include
CSOURCES=
SOURCES=yield.cc
OBJECTS=$(patsubst %.c,%.o,$(CSOURCES)) $(patsubst %.cc,%.o,$(SOURCES))
BUILD_DIRS=$(BINDIR) $(LIBDIR)
DEPS=
TARGET=yield

.PHONY: all clean

all: $(BUILD_DIRS) $(DEPS) $(addprefix $(BINDIR)/, $(TARGET))

clean:
	$(RM) -r $(BUILD_DIRS)
	$(RM) $(DEPS)
	$(RM) gmon.out hw2.profile
	$(RM) hw2.out hw2.time hw2.vM.dump
	$(RM) -r analysis

$(LIBDIR)/%.o: $(SRCDIR)/%.c
	$(CC) -c $(CFLAGS) -o $@ $<

$(LIBDIR)/%.o: $(SRCDIR)/%.cc
	$(CXX) -c $(CCFLAGS) -o $@ $<

$(BUILD_DIRS):
	$(MKDIR) -p $@

$(BINDIR)/yield: $(addprefix $(LIBDIR)/, $(OBJECTS))
	$(CXX) $(PROF_ARGS) -L$(LIBDIR) $(LDFLAGS) -o $@ $^

