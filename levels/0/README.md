# Level level00

## how to login

username: level00

password: level00

## Goal

read `.pass` as user `level01`

## Actually doing something


When disassembling main, we see a scanf call.

Scanf is basically reverse printf, reading from stdin and storing data in places from a format string

Here the format string is a `%d` which reads a number from stdin.

This number is compared to `5276`

We get a shell if they are the same.

```bash
level00@OverRide:~$ ./level00
***********************************
* 	     -Level00 -		  *
***********************************
Password:5276

Authenticated!
$ id
uid=1000(level00) gid=1000(level00) euid=1001(level01) egid=100(users) groups=1001(level01),100(users),1000(level00)
$ cat ~level01/.pass
uSq2ehEGT6c9S24zbshexZQBXUGrncxn5sD5QfGL
```
