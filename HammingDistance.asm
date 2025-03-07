section .data
    newLine db 0xA ;New line

    outputString db 'Hamming distance: ', 0x0A ;Final Display
    len1 equ $-outputString

    request db 'Enter string: ', 0x0A     ;prompting for first string
    len2 equ $-request

section .bss
    string1 resd 10
    string2 resd 10
    distance resb 10  ;Reserve space for distance to be stored

section .text
    global _start

_start:

    ;Request string1
    mov eax, 4
    mov ebx, 1
    mov ecx, request 
    mov edx, len2
    int 0x80

    ;Read and store string1
    mov eax, 3
    mov ebx, 0
    lea ecx, string1
    mov edx, 100
    int 0x80

    ;Request string2
    mov eax, 4
    mov ebx, 1
    mov ecx, request 
    mov edx, len2
    int 0x80

    ;Read and store string2
    mov eax, 3
    mov ebx, 0
    lea ecx, string2
    mov edx, 100
    int 0x80

    ;Put binary value of strings into registers
    mov eax, [string1]
    mov ebx, [string2]

    ;Compare bit values
    xor eax, ebx

    ;Sum the 1's in EAX
    mov ecx, 0 ;Hamming distance counter

.sum_ones:
    test eax, 1 ;Check if 1
    jz .no_bit ;Skip when 0
    inc ecx ;Increment counter

.no_bit:
    shr eax, 1 ;Shift to next bit
    jnz .sum_ones ;Repeat for all bits


    mov eax, ecx ;Move hamming distance into eax
    mov ebx, distance ;Put buffer into ebx
    add ebx, 10 ;Move to end of the buffer
    mov byte [ebx], 0 ;Add the end to buffer
    dec ebx ;Point to the end
.convert_to_ascii:
    xor edx, edx ;Clear
    mov ecx, 10 ;Set divisor to 10
    div ecx ;Divide eax by 10 and put remainder in EDX
    add dl, '0' ;Convert remainder to ASCII
    mov [ebx], dl ;Store the digit
    dec ebx ;Next character
    test eax, eax ;Check if 0
    jnz .convert_to_ascii ;Continue if not 0

    ;Print outputString
    mov eax, 4
    mov ebx, 1
    lea ecx, outputString
    mov edx, len1
    int 0x80

    ;Print hamming distance
    mov eax, 4
    mov ebx, 1
    lea ecx, [distance]
    mov edx, 10
    int 0x80

    ;Print newLine
    mov eax, 4
    mov ebx, 1
    lea ecx, [newLine]
    mov edx, 1
    int 0x80

    ;Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80