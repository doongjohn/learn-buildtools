#include <stdio.h>
#include <stdlib.h>
#include "linenoise.h"

#ifdef _WIN32
#include <windows.h>
#endif

int main() {
#ifdef _WIN32
SetConsoleOutputCP(CP_UTF8);
puts("plat: windows");
#else
puts("plat: linux");
#endif

  char *input = NULL;
  while ((input = linenoise("> "), input)) {
    printf("input: %s\n", input);
    free(input);
  }

  return EXIT_SUCCESS;
}
