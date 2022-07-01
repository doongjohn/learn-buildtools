# NOTE: this is not elegant
# I recommend using bear or other build tools to generate compile_commands.json
# https://github.com/rizsotto/Bear

# https://clang.llvm.org/docs/JSONCompilationDatabase.html
# https://github.com/Sarcasm/notes/blob/master/dev/compilation-database.rst#clang
# https://stackoverflow.com/questions/7654386/how-do-i-properly-escape-data-for-a-makefile
.PHONY: compdb

compdb: $(SRCS:.c=.o.json)
	@echo '[compdb] compile_commands.json'
	@sed \
		-e 's/^/  /'       `# prepend 2 spaces` \
		-e '1 s/^/[\n/'    `# add [ at the top` \
		-e 's/$$/,/'       `# append comma` \
		-e '$$ s/,$$/\n]/' `# replace last comma to \n]` \
		$(notdir $^) > compile_commands.json
	@rm *.o.json

# NOTE: may need more elaborate implementation
define SHELL_ESCAPE
sed -z -e 's/\\/\\\\&/g' -e 's/\"/\\"/g' -e 's/\\n/\\\\n/g'
endef

define GEN_JSON
@echo "{"\
	"\"directory\":\"$(shell pwd)\","\
	"\"file\":\"$<\","\
	"\"command\":\"$$(echo '$(COMMAND)' | $(SHELL_ESCAPE))\","\
	"\"output\":\"$(OUTPUT)\""\
	"}" >> $(notdir $@)
endef

$(SRC_DIR)/%.o.json: $(SRC_DIR)/%.c
	@echo '[compdb] '$@
	$(eval OUTPUT := $(OBJ_DIR)/$(<:.c=.o))
	$(eval COMMAND := $(CC) $(CFLAGS_SRC) -c -o $(OUTPUT) $<)
	$(GEN_JSON)

$(LINENOISE_DIR)/%.o.json: $(LINENOISE_DIR)/%.c
	@echo '[compdb] '$@
	$(eval OUTPUT := $(OBJ_DIR)/$(<:.c=.o))
	$(eval COMMAND := $(CC) $(CFLAGS_LINENOISE) -c -o $(OUTPUT) $<)
	$(GEN_JSON)
