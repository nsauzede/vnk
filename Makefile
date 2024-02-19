# Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
# Use of this source code is governed by an MIT license
# that can be found in the LICENSE file.

TARGET:=
TARGET+=nuklear.h
TARGET+=nuklear_sdl_gl3.h

CP:=cp
NUKLEAR:=nuklear
CFLAGS:=-I.
CFLAGS+=`sdl2-config --cflags`
LDFLAGS+=`sdl2-config --libs`
LDFLAGS+=-lGL -lGLEW -lm

all: $(TARGET)

nuklear.h: $(NUKLEAR)/nuklear.h
	$(CP) $(NUKLEAR)/nuklear.h $@

nuklear_sdl_gl3.h: $(NUKLEAR)/nuklear.h
	$(CP) $(NUKLEAR)/demo/sdl_opengl3/nuklear_sdl_gl3.h $@

$(NUKLEAR)/nuklear.h:
	[ -d nuklear ] || git clone --filter=tree:0 https://github.com/Immediate-Mode-UI/Nuklear nuklear

clean:
	$(RM) *.o *.so $(TARGET) examples/mainnk_v/mainnk

clobber: clean
	$(RM) -Rf nuklear
