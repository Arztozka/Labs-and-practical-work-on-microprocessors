.686
.model flat, stdcall
.stack 100h

ExitProcess PROTO STDCALL :DWORD

.data
ARRAY_SIZE equ 70

fib_array SWORD ARRAY_SIZE dup (?)

one_real real8 1.0

.code
Start:
    finit

    mov word ptr [fib_array], 1
    mov word ptr [fib_array + SIZEOF SWORD], 1

    fld qword ptr [one_real]
    fld qword ptr [one_real]

    lea esi, fib_array + SIZEOF SWORD * 2
    
    mov ecx, 2

fib_loop:
    cmp ecx, ARRAY_SIZE
    jge end_program

    fld st(0)
    fadd st(0), st(2)
    fstp st(2)

    mov eax, ecx            
    inc eax                  
    xor edx, edx             

    mov ebx, 3               
    div ebx                  

    cmp edx, 0
    je apply_negative_sign

    jmp save_number

apply_negative_sign:
    fchs

save_number:
    fistp word ptr [esi]

    add esi, SIZEOF SWORD
    inc ecx
    jmp fib_loop

end_program:
    finit

    Invoke ExitProcess,0
end Start