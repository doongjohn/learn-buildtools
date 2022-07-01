OBJ_DIR_NAME := .objs
DEP_DIR_NAME := .deps
BUILD_DIR_NAME := bin

# CC := x86_64-w64-mingw32-gcc
CC := gcc
PROG := app
SRC_DIR := src

# use fd to find all *.c files
SRCS := $(shell fd '\.c$$' $(SRC_DIR)/ -E=lib)

LINENOISE_DIR := $(SRC_DIR)/lib/linenoise
SRCS += $(LINENOISE_DIR)/utf8.c
SRCS += $(LINENOISE_DIR)/stringbuf.c
SRCS += $(LINENOISE_DIR)/linenoise.c

INCLUDE_DIR += $(SRC_DIR) $(LINENOISE_DIR)

CFLAGS_ALL       := -Wall
CFLAGS_ALL       += -fsanitize=undefined
CFLAGS_SRC       := $(CFLAGS_ALL) $(addprefix -I,$(INCLUDE_DIR))
CFLAGS_LINENOISE := $(CFLAGS_ALL) -DUSE_UTF8

LDFLAGS := -fsanitize=undefined
