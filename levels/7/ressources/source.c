#include <stdio.h>
#include <string.h>

int clear_stdin() {
  int result;

  do
    result = getchar();
  while (result != 10 && result != 0xFF);
  return result;
}

unsigned int get_unum() {
  unsigned int num;

  num = 0;
  fflush(stdout);
  scanf("%u", &num);
  clear_stdin();
  return num;
}

int __cdecl store_number(unsigned int *mem) {
  unsigned int unum;
  unsigned int idx;

  printf(" Number: ");
  unum = get_unum();
  printf(" Index: ");
  idx = get_unum();
  if (idx == 3 * (idx / 3) || (unum >> 24) && 0xFF == 0xB7) {
    puts(" *** ERROR! ***");
    puts("   This index is reserved for wil!");
    puts(" *** ERROR! ***");
    return 1;
  } else {
    mem[idx] = unum;
    return 0;
  }
}

int __cdecl read_number(unsigned int *mem) {
  unsigned int unum;

  printf(" Index: ");
  unum = get_unum();
  printf(" Number at data[%u] is %u\n", unum, mem[unum]);
  return 0;
}

int __cdecl main(int argc, const char **argv, const char **envp) {
  int mem[100];
  int err;
  char str[20];

  err = 0;
  memset(str, 0, sizeof(str));
  memset(mem, 0, sizeof(mem));
  while (*argv) {
    memset((void *)*argv, 0, strlen(*argv));
    ++argv;
  }
  while (*envp) {
    memset((void *)*envp, 0, strlen(*envp));
    ++envp;
  }
  puts("----------------------------------------------------\n"
       "  Welcome to wil's crappy number storage service!   \n"
       "----------------------------------------------------\n"
       " Commands:                                          \n"
       "    store - store a number into the data storage    \n"
       "    read  - read a number from the data storage     \n"
       "    quit  - exit the program                        \n"
       "----------------------------------------------------\n"
       "   wil has reserved some storage :>                 \n"
       "----------------------------------------------------\n");
  while (1) {
    printf("Input command: ");
    err = 1;
    fgets(str, 20, stdin);
    str[strlen(str) - 1] = 0;

    if (!memcmp(str, "store", 5u)) {
      err = store_number((unsigned int *)mem);
    } else if (!memcmp(str, "read", 4u)) {
      err = read_number((unsigned int *)mem);
    } else if (!memcmp(str, "quit", 4u))
      return 0;
    if (err)
      printf(" Failed to do %s command\n", str);
    else
      printf(" Completed %s command successfully\n", str);
    memset(str, 0, sizeof(str));
  }
}
