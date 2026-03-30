# Level level03

## how to login

username: level03

password: Hh74RPnuQ9sa5JAEXgNWCqz7sXGnh5J5M9KfPg3H

## Goal

read `.pass` as user `level04`

## Actually doing something

Looking at the decompiled code, we see a function that checks multiple switch case scenarii, but only one of them supposedly works as the passsword.

The brute force approach here is thus the easiest, and by checking all possibilities we can get access to the level04 shell!

EMol's stylish brute force solution:
```bash
for i in {1..9} {16..21}; do ~/level03 < <(echo $(( $(python -c 'print(0x1337d00d)') - $i )) ); done
***********************************
*		level03		**
***********************************
Password:
Invalid password
***********************************
*		level03		**
***********************************
Password:
Invalid Password
[...]
***********************************
*		level03		**
***********************************
hello
/bin/sh: 1: hello: not found
id
uid=1003(level03) gid=1003(level03) euid=1004(level04) egid=100(users) groups=1004(level04),100(users),1003(level03)
cat ~level04/.pass
kgv3tkEb9h2mLkRsPkXRfc2mHbjMxQzvb2FrgKkf
```

Maix's brutish brute force solution:
```bash
for i in {322424815..322424865}; do cat <(echo $i) - | ./level03; done
[... same result but way more useless tries >:) ]
```
