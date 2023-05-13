
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
SRCS = src/main.cpp

SRCS.O = $(addprefix $(OBJ_DIR),$(SRCS:.cpp=.o))

ELF_FILE = Tutorial.elf
PRX_FILE = Tutorial.prx
SFO_FILE = PARAM.SFO
NAME_APP = 'Our Application'
NAME = EBOOT.PBP

all:  $(NAME)
#	$(GCC_CPP) $(INCLUDES_CPP) $(CPP_FLAGS) -c -o main.o $(SRCS)
#	$(GCC) $(INCLUDES_C) $(CFLAGS) $(LIBIRES_C) -specs=$(PSP_SDK_LIB)/prxspecs -Wl,-q,-T$(PSP_SDK_LIB)/linkfile.prx main.o $(PSP_SDK_LIB)/prxexports.o $(PSP_FLAGS) -o Tutorial.elf#
	
#	$(PATH_PSP_DEV)/bin/psp-fixup-imports Tutorial.elf
#	$(PATH_PSP_DEV)/bin/psp-prxgen Tutorial.elf Tutorial.prx
#	$(PATH_PSP_DEV)/bin/mksfoex -d MEMSIZE=1 'Our Application' PARAM.SFO
#	$(PATH_PSP_DEV)/bin/pack-pbp EBOOT.PBP PARAM.SFO NULL \
				NULL NULL NULL \
				NULL Tutorial.prx NULL



$(NAME): $(OBJ_DIR)	$(SRCS.O) $(HEADERS) $(ELF_FILE) $(PRX_FILE) $(SFO_FILE)
	$(PATH_PSP_DEV)/bin/pack-pbp $(NAME) $(SFO_FILE) NULL \
				NULL NULL NULL \
				NULL $(PRX_FILE) NULL
		
	@echo "$(F_GREEN) $(NAME) CREATE! $(F_NONE)"


$(ELF_FILE):
	$(GCC) $(INCLUDES_C) $(CFLAGS) $(LIBIRES_C) -specs=$(PSP_SDK_LIB)/prxspecs -Wl,-q,-T$(PSP_SDK_LIB)/linkfile.prx $(SRCS.O) $(PSP_SDK_LIB)/prxexports.o $(PSP_FLAGS) -o $(ELF_FILE)
	$(PATH_PSP_DEV)/bin/psp-fixup-imports $(ELF_FILE)
	@echo "$(F_YELLOW) $(ELF_FILE) CREATE! $(F_NONE)"

$(PRX_FILE): $(ELF_FILE)
	$(PATH_PSP_DEV)/bin/psp-prxgen $(ELF_FILE) $(PRX_FILE)
	@echo "$(F_YELLOW) $(PRX_FILE) CREATE! $(F_NONE)"

$(SFO_FILE):
	$(PATH_PSP_DEV)/bin/mksfoex -d MEMSIZE=1 $(NAME_APP) $(SFO_FILE)
	@echo "$(F_YELLOW) $(SFO_FILE) CREATE! $(F_NONE)"


## creare obj dir
$(OBJ_DIR):
	mkdir $(OBJ_DIR)
	mkdir  $(addprefix $(OBJ_DIR),$(SRC_DIR))

# 	обьектные файлы зависят от такоего же файла только .cpp  и от хейдера					
$(SRCS.O):  $(OBJ_DIR)%.o:%.cpp  $(HEADERS)   
	$(GCC_CPP) $(INCLUDES_CPP) $(CPP_FLAGS) -c $< -o $@
	@echo "$(F_BLUE)Object files psp in ready! $(F_NONE)"

clean:
	rm -rf $(OBJ_DIR)
	@echo "$(F_GREEN)Object files psp delete! $(F_NONE)"
	rm -rf $(ELF_FILE)
	rm -rf $(PRX_FILE)
	rm -rf $(SFO_FILE)

fclean:		clean
			$(RM) $(NAME)
			@echo "$(F_GREEN)Delete $(NAME) FCleaned! $(F_NONE)"

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