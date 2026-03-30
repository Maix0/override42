# Level level06

## how to login

username: level06

password: h4GtNnaMs2kZFN92ymTr2DcJHAzMfzLW25Ep59mq

## Goal

read `.pass` as user `level07`

## Actually doing something

```bash
level06@OverRide:~$ gdb ./level06 
This GDB was configured as "x86_64-linux-gnu"...
Reading symbols from /home/users/level06/level06...(no debugging symbols found)...done.
(gdb) b *auth+109
Breakpoint 1 at 0x80487b5
(gdb) b *auth+286
Breakpoint 2 at 0x8048866
(gdb) r
Starting program: /home/users/level06/level06 
***********************************
*		level06		  *
***********************************
-> Enter Login: AAAAAA
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 1234

Breakpoint 1, 0x080487b5 in auth ()
=> 0x080487b5 <auth+109>:	e8 36 fe ff ff	call   0x80485f0 <ptrace@plt>
(gdb) nexti
0x080487ba in auth ()
=> 0x080487ba <auth+114>:	83 f8 ff	cmp    eax,0xffffffff
(gdb) set $eax = 0
(gdb) c
Continuing.

Breakpoint 2, 0x08048866 in auth ()
=> 0x08048866 <auth+286>:	3b 45 f0	cmp    eax,DWORD PTR [ebp-0x10]
(gdb) x/d $ebp-0x10
0xffffd6b8:	6229050
```


```bash
level06@OverRide:~$ ./level06
***********************************
*		level06		  *
***********************************
-> Enter Login: AAAAAA
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 6229050
Authenticated!
$ cat ~level07/.pass
GbcPDRgsFK77LNnnuh7QyFYA2942Gp8yKj9KrWD8
```

Why does this work ?

The code just checks perform a mathematical operation using the login as a input, and check that the serial is equal to that result.

What we did ? We just bypassed the debugging check (first breakpoint)
and the checked the expected value.

When we run, we get such value :D
