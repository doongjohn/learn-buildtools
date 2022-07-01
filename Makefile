.POSIX:

include config.mk

OBJ_DIR := $(OBJ_DIR_NAME)/$(CC)
DEP_DIR := $(DEP_DIR_NAME)/$(CC)

OBJ_FILES := $(SRCS:%.c=$(OBJ_DIR)/%.o)
DEP_FILES := $(SRCS:%.c=$(DEP_DIR)/%.d)
DEP_FLAGS = -MT $@ -MMD -MP -MF $(@:$(OBJ_DIR)/%.o=$(DEP_DIR)/%.d)

.PHONY: all tidy run clean

all: tidy $(BUILD_DIR_NAME)/$(PROG)

$(BUILD_DIR_NAME)/app: $(OBJ_FILES)
	@echo [linking] $@
	@mkdir -p $(BUILD_DIR_NAME)
	@$(CC) $(LDFLAGS) -o $@ $^

$(OBJ_DIR)/$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	@echo [compiling] $@
	@mkdir -p $(@D)
	@mkdir -p $(@D:$(OBJ_DIR)/%=$(DEP_DIR)/%)
	@$(CC) -c $(CFLAGS_SRC) $(DEP_FLAGS) -o $@ $<

$(OBJ_DIR)/$(LINENOISE_DIR)/%.o: $(LINENOISE_DIR)/%.c
	@echo [compiling] $@
	@mkdir -p $(@D)
	@mkdir -p $(@D:$(OBJ_DIR)/%=$(DEP_DIR)/%)
	@$(CC) -c $(CFLAGS_LINENOISE) $(DEP_FLAGS) -o $@ $<

# remove unused *.o and *.d files and empty directories
tidy:
	@mkdir -p $(OBJ_DIR) $(DEP_DIR)
	@fd -t=f . $(OBJ_DIR)/ $(addprefix -E=,$(SRCS:%.c=%.o)) -x rm {}
	@fd -t=f . $(DEP_DIR)/ $(addprefix -E=,$(SRCS:%.c=%.d)) -x rm {}
	@fd -t=e . $(OBJ_DIR)/ -x rm -r {}
	@fd -t=e . $(DEP_DIR)/ -x rm -r {}

run:
ifneq ($(shell echo $(CC) | rg -o 'mingw'),)
	@./$(BUILD_DIR_NAME)/$(PROG).exe
else
	@./$(BUILD_DIR_NAME)/$(PROG)
endif

clean:
	@rm -r $(OBJ_DIR_NAME) $(DEP_DIR_NAME) $(BUILD_DIR_NAME)

include compdb.mk

-include $(DEP_FILES)
