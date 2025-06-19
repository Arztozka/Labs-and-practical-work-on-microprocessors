.586
.MODEL flat, C

.DATA
    step DD ?       ; шаг интегрирования h = 1/n
    x    DD 0.0     ; текущая точка x_i
    sum  DD 0.0     ; накапливаемая сумма

.CODE
extern fun_el:near   ; Объявление функции fun_el
public CalcIntegral  ; Экспорт функции

CalcIntegral proc C
    push ebp
    mov ebp, esp

    ; Аргумент:
    ; [ebp+8] = n (количество интервалов)

    ; Проверка, что n > 0
    mov eax, [ebp+8]
    test eax, eax
    jle error

    ; Вычисляем шаг h = 1.0 / n
    fld1                ; st(0) = 1.0
    fidiv dword ptr [ebp+8]  ; st(0) = h = 1.0 / n
    fstp dword ptr [step]    ; сохраняем шаг

    ; Инициализация x = h (начинаем с x = h, т.к. в 0 функция не определена)
    fld dword ptr [step]
    fstp dword ptr [x]  ; x = h

    ; Цикл интегрирования (метод прямоугольников)
    mov ecx, [ebp+8]    ; счетчик цикла = n
    fldz                ; st(0) = sum = 0.0

@@loop:
    ; Вычисляем f(x_i)
    push dword ptr [x]
    call fun_el
    add esp, 4

    ; sum += f(x_i) * h
    fmul dword ptr [step]  ; st(0) = f(x_i) * h
    faddp st(1), st(0)     ; sum += f(x_i) * h

    ; x += h
    fld dword ptr [x]
    fadd dword ptr [step]
    fstp dword ptr [x]

    loop @@loop

    ; Возвращаем sum (результат)
    fstp dword ptr [sum]
    fld dword ptr [sum]
    jmp exit

error:
    fldz                ; Возвращаем 0 в случае ошибки

exit:
    pop ebp
    ret

CalcIntegral endp
End