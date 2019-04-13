#############################################################################
# Makefile for building: Lolac
# Generated by qmake (3.0) (Qt 5.4.2)
# Project:  Lolac.pro
# Modified by Rochus
#############################################################################

MAKEFILE      = Makefile

####### Compiler, tools and options

CC            = gcc
CXX           = g++
DEFINES       = -DQT_NO_DEBUG -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB
CFLAGS        = -m32 -pipe -O2 -Wall -W -D_REENTRANT -fPIC $(DEFINES)
CXXFLAGS      = -m32 -pipe -Wno-reorder -Wno-unused-parameter -Wno-unused-function -Wno-unused-variable -O2 -Wall -W -D_REENTRANT -fPIC $(DEFINES)
INCPATH       = -I. -I.. 
DEL_FILE      = rm -f
CHK_DIR_EXISTS= test -d
MKDIR         = mkdir -p
COPY          = cp -f
COPY_FILE     = cp -f
COPY_DIR      = cp -f -R
INSTALL_FILE  = install -m 644 -p
INSTALL_PROGRAM = install -m 755 -p
INSTALL_DIR   = $(COPY_DIR)
DEL_FILE      = rm -f
SYMLINK       = ln -f -s
DEL_DIR       = rmdir
MOVE          = mv -f
TAR           = tar -cf
COMPRESS      = gzip -9f
DISTNAME      = Lolac1.0.0
DISTDIR = ./Build
LINK          = g++
LFLAGS        = -m32  -O1 
LIBS          = $(SUBLIBS) 
AR            = ar cqs
RANLIB        = 
SED           = sed
STRIP         = strip

####### Output directory

OBJECTS_DIR   = ./

####### Files

SOURCES       = LlLSB.cpp \
		LlLSC.cpp \
		LlLSP.cpp \
		LlLSS.cpp \
		LlLSV.cpp \
		main.cpp \
		LlFiles.cpp \
		LlOberon.cpp \
		LlTexts.cpp 
OBJECTS       = LlLSB.o \
		LlLSC.o \
		LlLSP.o \
		LlLSS.o \
		LlLSV.o \
		main.o \
		LlFiles.o \
		LlOberon.o \
		LlTexts.o

QMAKE_TARGET  = Lolac
DESTDIR       = #avoid trailing-slash linebreak
TARGET        = Lolac


first: all
####### Implicit rules

.SUFFIXES: .o .c .cpp .cc .cxx .C

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o "$@" "$<"

.cc.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o "$@" "$<"

.cxx.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o "$@" "$<"

.C.o:
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o "$@" "$<"

.c.o:
	$(CC) -c $(CFLAGS) $(INCPATH) -o "$@" "$<"

####### Build rules

$(TARGET):  $(OBJECTS)  
	$(LINK) $(LFLAGS) -o $(TARGET) $(OBJECTS) $(OBJCOMP) $(LIBS)


all: Makefile $(TARGET)


clean:compiler_clean 
	-$(DEL_FILE) $(OBJECTS)
	-$(DEL_FILE) *~ core *.core


####### Compile

LlLSB.o: LlLSB.cpp LlLSB.h \
		../Lolac/Ll_Global.h \
		../Lolac/LlTexts.h \
		../Lolac/LlOberon.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlLSB.o LlLSB.cpp

LlLSC.o: LlLSC.cpp LlLSC.h \
		../Lolac/Ll_Global.h \
		../Lolac/LlTexts.h \
		../Lolac/LlOberon.h \
		../Lolac/LlLSB.h \
		../Lolac/LlLSS.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlLSC.o LlLSC.cpp

LlLSP.o: LlLSP.cpp LlLSP.h \
		../Lolac/Ll_Global.h \
		../Lolac/LlTexts.h \
		../Lolac/LlOberon.h \
		../Lolac/LlLSB.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlLSP.o LlLSP.cpp

LlLSS.o: LlLSS.cpp LlLSS.h \
		../Lolac/Ll_Global.h \
		../Lolac/LlTexts.h \
		../Lolac/LlOberon.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlLSS.o LlLSS.cpp

LlLSV.o: LlLSV.cpp LlLSV.h \
		../Lolac/Ll_Global.h \
		../Lolac/LlFiles.h \
		../Lolac/LlTexts.h \
		../Lolac/LlOberon.h \
		../Lolac/LlLSB.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlLSV.o LlLSV.cpp

main.o: main.cpp LlLSC.h \
		../Lolac/Ll_Global.h \
		../Lolac/LlTexts.h \
		../Lolac/LlOberon.h \
		../Lolac/LlLSB.h \
		../Lolac/LlLSS.h \
		LlLSV.h \
		../Lolac/LlFiles.h \
		LlTexts.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o main.o main.cpp

LlFiles.o: LlFiles.cpp LlFiles.h \
		../Lolac/Ll_Global.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlFiles.o LlFiles.cpp

LlOberon.o: LlOberon.cpp LlOberon.h \
		../Lolac/Ll_Global.h \
		../Lolac/LlTexts.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlOberon.o LlOberon.cpp

LlTexts.o: LlTexts.cpp LlTexts.h \
		../Lolac/Ll_Global.h
	$(CXX) -c $(CXXFLAGS) $(INCPATH) -o LlTexts.o LlTexts.cpp

