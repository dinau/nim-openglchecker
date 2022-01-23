# 2022/01
#
TARGET = openglCheckerNim
# OpenGL
# for static link
#OPT += -d:glfwStaticLib

#TC = clang
TC = gcc
#TC = vcc
#TC = tcc

#DEBUG = true
FLTO = true

ifeq ($(OS),Windows_NT)
    EXE = .exe
endif


OPT += --cc:$(TC)

ifeq ($(DEBUG),true)
    OPT += -d:debug
else
    OPT += -d:danger
    OPT += --opt:size
endif

OPT += -d:strip
#OPT += --app:gui


# for TCC
ifneq ($(TC),tcc)
    ifneq ($(TC),vcc)
        OPT +=--passC:-ffunction-sections --passC:-fdata-sections
        OPT +=--passL:-Wl,--gc-sections
        ifneq ($(TC),clang)
            ifeq ($(FLTO),true)
                OPT += --passC:-flto --passL:-flto
            endif
        endif
    endif
endif


all:$(TARGET).exe
	@./$(<)

NIMCACHE=.nimcache_$(TC)

$(TARGET)$(EXE): src/$(TARGET).nim Makefile
	nim c $(OPT) -o:$@ --nimcache:$(NIMCACHE) $(<)
	@size $(@)

run: all
	$(TARGET)$(EXE)

clean:
	-@rm -fr .nimcache_*
	-@rm -fr .nimcache
	rm $(TARGET)$(EXE)
	-rm openGL_ext.ext

