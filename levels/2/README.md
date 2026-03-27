# Level level02

## how to login

username: level02

password: PwBLgNa8p8MTKW57S7zxVAQCxnCpV8JqTTs9XEBv

## Goal

read `.pass` as user `level03`

## Actually doing something

Why does the payload work:

The code asks for a username and a password, and checks that the password is equal to the flag.

We dont know the flag.

When it doesnt match, it prints the username and a text saying "no access"

The username printing is done using printf with the username as a format string
The flag buffer is on the stack, this we can print the flag buffer using usual printf format string abuse.

We just put the address of said buffer in the username, say to printf "Hey use the x'th argument" and it prints the flag !

```bash
env -i PWD=/tmp SHLVL=0 ~/level02 < <(python -c 'print("%29$s\0  " + "\xa0\xec\xff\xff\xff\x7f\0\0" + "." * 60)')
```
