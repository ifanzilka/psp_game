
F_NONE		= \033[37m
F_BOLD		= \033[1m
F_RED		= \033[31m
F_ORANGE	= \033[38m
F_YELLOW	= \033[0;33m
F_GREEN		= \033[32m
F_CYAN		= \033[36m
F_BLUE		= \033[34m 


PATH_PSP_DEV = /usr/local/pspdev
PSP_SDK_LIB = $(PATH_PSP_DEV)/psp/sdk/lib

GCC_CPP = $(PATH_PSP_DEV)/bin/psp-g++
GCC = $(PATH_PSP_DEV)/bin/psp-gcc
CPP_FLAGS = -std=c++14 -fno-rtti -D_PSP_FW_VERSION=500 
CFLAGS =  -D_PSP_FW_VERSION=500
PSP_FLAGS = -lg -lc -lpspdebug -lpspdisplay -lpspge -lpspctrl -lpspsdk  -lpspnet -lpspnet_inet -lpspnet_apctl -lpspaudiolib -lpspnet_resolver -lpsputility -lpspuser -lpspkernel
INCLUDES_CPP = -I. -I$(PATH_PSP_DEV)/psp/sdk/include -I./includes
INCLUDES_C = -I. -I$(PATH_PSP_DEV)/psp/sdk/include
LIBIRES_C = -L. -L$(PSP_SDK_LIB)

HEADER	= ./includes
HEADERS = $(addprefix $(HEADER)/,gfx.h)

OBJ_DIR = BIN/

SRC_DIR	= src/
SRCS = src/main.cpp src/gfx.cpp

SRCS.O = $(addprefix $(OBJ_DIR),$(SRCS:.cpp=.o))


PSP_EBOOT_ICON  =   media_files/rick_morty.png


ifndef PSP_EBOOT_TITLE
PSP_EBOOT_TITLE = $(TARGET)
endif

ifndef PSP_EBOOT_SFO
PSP_EBOOT_SFO = PARAM.SFO
endif

ifndef PSP_EBOOT_ICON
PSP_EBOOT_ICON = NULL
endif

ifndef PSP_EBOOT_ICON1
PSP_EBOOT_ICON1 = NULL
endif

ifndef PSP_EBOOT_UNKPNG
PSP_EBOOT_UNKPNG = NULL
endif

ifndef PSP_EBOOT_PIC1
PSP_EBOOT_PIC1 = NULL
endif

ifndef PSP_EBOOT_SND0
PSP_EBOOT_SND0 = NULL
endif

ifndef PSP_EBOOT_PSAR
PSP_EBOOT_PSAR = NULL
endif

ifndef PSP_EBOOT
PSP_EBOOT = EBOOT.PBP
endif






ELF_FILE = Tutorial.elf
PRX_FILE = Tutorial.prx
SFO_FILE = PARAM.SFO
NAME_APP = 'Our Application'
#NAME = EBOOT.PBP

all:  $(PSP_EBOOT)
#	$(GCC_CPP) $(INCLUDES_CPP) $(CPP_FLAGS) -c -o main.o $(SRCS)
#	$(GCC) $(INCLUDES_C) $(CFLAGS) $(LIBIRES_C) -specs=$(PSP_SDK_LIB)/prxspecs -Wl,-q,-T$(PSP_SDK_LIB)/linkfile.prx main.o $(PSP_SDK_LIB)/prxexports.o $(PSP_FLAGS) -o Tutorial.elf#
	
#	$(PATH_PSP_DEV)/bin/psp-fixup-imports Tutorial.elf
#	$(PATH_PSP_DEV)/bin/psp-prxgen Tutorial.elf Tutorial.prx
#	$(PATH_PSP_DEV)/bin/mksfoex -d MEMSIZE=1 'Our Application' PARAM.SFO
#	$(PATH_PSP_DEV)/bin/pack-pbp EBOOT.PBP PARAM.SFO NULL \
				NULL NULL NULL \
				NULL Tutorial.prx NULL



$(PSP_EBOOT): $(OBJ_DIR)	$(SRCS.O) $(HEADERS) $(ELF_FILE) $(PRX_FILE) $(PSP_EBOOT_SFO)
	$(PATH_PSP_DEV)/bin/pack-pbp $(PSP_EBOOT) $(PSP_EBOOT_SFO) $(PSP_EBOOT_ICON) \
				$(PSP_EBOOT_ICON1) $(PSP_EBOOT_UNKPNG) $(PSP_EBOOT_PIC1) \
				$(PSP_EBOOT_SND0) $(PRX_FILE) $(PSP_EBOOT_PSAR)
		
	@echo "$(F_GREEN) $(PSP_EBOOT) CREATE! $(F_NONE)"


$(ELF_FILE):
	$(GCC) $(INCLUDES_C) $(CFLAGS) $(LIBIRES_C) -specs=$(PSP_SDK_LIB)/prxspecs -Wl,-q,-T$(PSP_SDK_LIB)/linkfile.prx $(SRCS.O) $(PSP_SDK_LIB)/prxexports.o $(PSP_FLAGS) -o $(ELF_FILE)
	$(PATH_PSP_DEV)/bin/psp-fixup-imports $(ELF_FILE)
	@echo "$(F_YELLOW) $(ELF_FILE) CREATE! $(F_NONE)"

$(PRX_FILE): $(ELF_FILE)
	$(PATH_PSP_DEV)/bin/psp-prxgen $(ELF_FILE) $(PRX_FILE)
	@echo "$(F_YELLOW) $(PRX_FILE) CREATE! $(F_NONE)"

$(PSP_EBOOT_SFO):
	$(PATH_PSP_DEV)/bin/mksfoex -d MEMSIZE=1 $(NAME_APP) $(PSP_EBOOT_SFO)
	@echo "$(F_YELLOW) $(PSP_EBOOT_SFO) CREATE! $(F_NONE)"


## creare obj dir
$(OBJ_DIR):
	mkdir $(OBJ_DIR)
	mkdir  $(addprefix $(OBJ_DIR),$(SRC_DIR))

# 	обьектные файлы зависят от такоего же файла только .cpp  и от хейдера					
$(SRCS.O):  $(OBJ_DIR)%.o:%.cpp  $(HEADERS)   
	$(GCC_CPP) $(INCLUDES_CPP) $(CPP_FLAGS) -c $< -o $@
	@echo "$(F_BLUE)Object files psp in ready! $(F_NONE)"

config:
	
	include $(PATH_PSP_DEV)/psp/sdk/lib/build.mak
#	bash $(PATH_PSP_DEV)/bin/psp-config --pspsdk-path

clean:
	rm -rf $(OBJ_DIR)
	@echo "$(F_GREEN)Object files psp delete! $(F_NONE)"
	rm -rf $(ELF_FILE)
	rm -rf $(PRX_FILE)
	rm -rf $(PSP_EBOOT_SFO)

fclean:		clean
			$(RM) $(PSP_EBOOT)
			@echo "$(F_GREEN)Delete $(PSP_EBOOT) FCleaned! $(F_NONE)"

re:	fclean all

code:
	@echo " ~~~~~~~~~~~~~~~~"
	@echo "$(F_BOLD)  * Make code, *"
	@echo "$(F_BOLD)   * not war! *"
	@echo "$(F_RED)    ..10101.."
	@echo "$(F_ORANGE)  01   1   011"
	@echo "$(F_YELLOW) 10     0     00"
	@echo "$(F_GREEN) 11   .010.   11"
	@echo "$(F_CYAN) 00 .01 1 01. 10"
	@echo "$(F_BLUE) 010   1   110"
	@echo "$(F_BLUE)   11011010**$(F_NONE)"