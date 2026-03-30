#include <stdio.h>
#include <string.h>
#include <sys/ptrace.h>
#include <unistd.h>
#include <stdlib.h>

int auth(char *s, int serial) {
  int i;
  int v4;
  int len;

  s[strcspn(s, "\n")] = 0;
  len = strnlen(s, 32);
  if (len <= 5)
    return 1;
  if (ptrace(PTRACE_TRACEME, 0, 1, 0) == -1) {
    puts("\x1B[32m.---------------------------.");
    puts("\x1B[31m| !! TAMPERING DETECTED !!  |");
    puts("\x1B[32m'---------------------------'");
    return 1;
  } else {
    v4 = (s[3] ^ 0x1337) + 0x5EEDED;
    for (i = 0; i < len; ++i) {
      if (s[i] <= 0x1F)
        return 1;
      v4 += (v4 ^ (unsigned int)s[i]) % 0x539;
    }
    return serial != v4;
  }
}

int main(int argc, const char **argv, const char **envp) {
  unsigned int v4;
  char s[32];

  puts("***********************************");
  puts("*\t\tlevel06\t\t  *");
  puts("***********************************");
  printf("-> Enter Login: ");
  fgets(s, 32, stdin);
  puts("***********************************");
  puts("***** NEW ACCOUNT DETECTED ********");
  puts("***********************************");
  printf("-> Enter Serial: ");
  scanf("%u", &v4);
  if (auth(s, v4))
    return 1;
  puts("Authenticated!");
  system("/bin/sh");
  return 0;
}
