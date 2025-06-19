.686
.model flat,stdcall
.stack 100h

ExitProcess PROTO STDCALL :DWORD

.data
X   dd 02231h
Y   dd 048B3h
Z   dd 06BB8h

L   dd ?
M   dd ?
R   dd ?

.code
Start:
    ; L = F291h - X - Y - Z
    mov eax, 0F291h
    mov esi, offset X    ; Указатель на X, Y, Z подряд
    mov ecx, 3           ; 3 элемента

SubLoop:
    sub eax, [esi]
    add esi, 4           ; Переход к следующему элементу 
    loop SubLoop

    mov L, eax

    ; M = L/2 + (X & Y)
    mov eax, L
    sar eax, 1           ; деление на 2 со знаком
    mov ebx, X
    and ebx, Y
    add eax, ebx
    mov M, eax

    ; Если M < 099Fh => Proc1, иначе Proc2
    cmp eax, 0099Fh
    jl  PProc1           
    jmp PProc2

PProc1:
    Call Proc1
    ret

PProc2:
    Call Proc2
    ret

Proc1:
    ; R = ст.М <=> мл.М 
    mov eax, M
    xchg ah, al
    mov R, eax
    jmp CheckBits
    ret

Proc2:
    ; R = M + 10BAh
    mov eax, M
    add eax, 010BAh
    mov R, eax
    ret

CheckBits:
    ; Проверка количества единиц в младшем байте R
    mov eax, R
    mov bl, al         ; младший байт R в bl
    mov cl, 0
    mov bh, 8
CountBits:
    shr bl, 1
    adc cl, 0
    dec bh
    jnz CountBits

    test cl, 1         ; чётное ли количество единиц?
    jz  Adr1           ; если чётное, то Adr1

Adr2:
    mov eax, R
    xor eax, 00F0Fh
    mov R, eax
    jmp Done

Adr1:
    mov eax, R
    and eax, 0F0F0h
    mov R, eax

Done:
    invoke ExitProcess, 0
End Start