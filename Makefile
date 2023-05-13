
PATH_PSP_DEV = /usr/local/pspdev
PSP_SDK_LIB = $(PATH_PSP_DEV)/psp/sdk/lib

GCC_CPP = $(PATH_PSP_DEV)/bin/psp-g++
GCC = $(PATH_PSP_DEV)/bin/psp-gcc
CPP_FLAGS = -std=c++14 -fno-rtti -D_PSP_FW_VERSION=500 
CFLAGS =  -D_PSP_FW_VERSION=500
PSP_FLAGS = -lg -lc -lpspdebug -lpspdisplay -lpspge -lpspctrl -lpspsdk  -lpspnet -lpspnet_inet -lpspnet_apctl -lpspaudiolib -lpspnet_resolver -lpsputility -lpspuser -lpspkernel
INCLUDES_CPP = -I. -I$(PATH_PSP_DEV)/psp/sdk/include
INCLUDES_C = -I. -I$(PATH_PSP_DEV)/psp/sdk/include
LIBIRES_C = -L. -L$(PSP_SDK_LIB)



all:
	$(GCC_CPP) $(INCLUDES_CPP) $(CPP_FLAGS) -c -o main.o main.cpp
	$(GCC) $(INCLUDES_C) $(CFLAGS) $(LIBIRES_C) -specs=$(PSP_SDK_LIB)/prxspecs -Wl,-q,-T$(PSP_SDK_LIB)/linkfile.prx main.o $(PSP_SDK_LIB)/prxexports.o $(PSP_FLAGS) -o Tutorial.elf
	
	$(PATH_PSP_DEV)/bin/psp-fixup-imports Tutorial.elf
	$(PATH_PSP_DEV)/bin/psp-prxgen Tutorial.elf Tutorial.prx
	$(PATH_PSP_DEV)/bin/mksfoex -d MEMSIZE=1 'Our Application' PARAM.SFO
	$(PATH_PSP_DEV)/bin/pack-pbp EBOOT.PBP PARAM.SFO NULL \
				NULL NULL NULL \
				NULL Tutorial.prx NULL

clean:
	rm EBOOT.PBP
	rm Tutorial.elf
	rm Tutorial.prx
	rm PARAM.SFO
	rm main.o
