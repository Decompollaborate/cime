# Build options can be changed by modifying the makefile or by building with 'make SETTING=value'.
DEBUG           ?= 0
WERROR          ?= 0
ASAN            ?= 0

CC              := clang
IINC            := -I lib/rabbitizer/include
CSTD            := -std=c11
CXXSTD          := -std=c++17
CFLAGS          := -fPIC
LDFLAGS         := -L lib/rabbitizer/build -lrabbitizer
WARNINGS        := -Wall -Wextra -Wpedantic
WARNINGS        += -Werror=vla -Werror=switch -Werror=implicit-fallthrough -Werror=unused-function -Werror=unused-parameter -Werror=shadow -Werror=switch -Werror=implicit-function-declaration -Werror=incompatible-pointer-types


ifeq ($(CC),gcc)
    WARNINGS    += -Wno-cast-function-type
endif

ifeq ($(DEBUG),0)
	OPTFLAGS    := -Os -g
else
	OPTFLAGS    := -O0 -g3
	CFLAGS      += -DDEVELOPMENT=1
	CXXFLAGS    += -DDEVELOPMENT=1
endif

ifneq ($(ASAN),0)
	CFLAGS      += -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=undefined
	CXXFLAGS    += -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=undefined
endif

# Every file under src/
SRC_DIRS        := $(shell find src -type d)
C_FILES         := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
O_FILES         := $(foreach f,$(C_FILES:.c=.o),build/$f)

DEP_FILES       := $(O_FILES:%.o=%.d)

CAS_SRC_DIRS    := $(shell find src/cas -type d)
CAS_C_FILES     := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
CAS_O_FILES     := $(foreach f,$(C_FILES:.c=.o),build/$f)


LIBRARIES       := lib/rabbitizer/build/librabbitizer.a

# create build directories
$(shell mkdir -p $(foreach dir,$(SRC_DIRS),build/$(dir)))




#### Main Targets ###

all: build/cas.elf

clean:
	$(RM) -rf build

distclean: clean
	make -C lib/rabbitizer distclean

format:
	clang-format-11 -i -style=file $(C_FILES)

tidy:
	clang-tidy-11 -p . --fix --fix-errors $(C_FILES) -- $(CSTD) $(OPTFLAGS) $(IINC) $(WARNINGS) $(CFLAGS)

.PHONY: all clean distclean format tidy
.DEFAULT_GOAL := all
.SECONDARY:


#### Binaries ####

build/cas.elf: $(CAS_O_FILES) | $(LIBRARIES)


#### Various Recipes ####

build/%.elf:
	$(CC) -MMD -MP $(CSTD) $(OPTFLAGS) $(IINC) $(WARNINGS) $(CFLAGS) -o $@ $^ $(LDFLAGS)

build/%.o: %.c
	$(CC) -MMD -MP -c $(CSTD) $(OPTFLAGS) $(IINC) $(WARNINGS) $(CFLAGS) -o $@ $<




#### Libraries ####

lib/rabbitizer/build/librabbitizer.a:
	make -C lib/rabbitizer static DEBUG=$(DEBUG) WERROR=$(WERROR) ASAN=$(ASAN)



-include $(DEP_FILES)

# Print target for debugging
print-% : ; $(info $* is a $(flavor $*) variable set to [$($*)]) @true