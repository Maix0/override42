#include <stdlib.h>
#include <stdio.h>

int main(int argc, const char **argv, const char **envp)
{
  int num; // [esp+1Ch] [ebp-4h] BYREF

  puts("***********************************");
  puts("* \t     -Level00 -\t\t  *");
  puts("***********************************");
  printf("Password:");
  scanf("%d", &num);
  if ( num == 5276 )
  {
    puts("\nAuthenticated!");
    system("/bin/sh");
    return 0;
  }
  else
  {
    puts("\nInvalid Password!");
    return 1;
  }
}
