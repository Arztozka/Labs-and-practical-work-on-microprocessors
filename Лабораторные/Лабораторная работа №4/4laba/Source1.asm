.586
.MODEL flat, C

.DATA
    step DD ?       ; ��� �������������� h = 1/n
    x    DD 0.0     ; ������� ����� x_i
    sum  DD 0.0     ; ������������� �����

.CODE
extern fun_el:near   ; ���������� ������� fun_el
public CalcIntegral  ; ������� �������

CalcIntegral proc C
    push ebp
    mov ebp, esp

    ; ��������:
    ; [ebp+8] = n (���������� ����������)

    ; ��������, ��� n > 0
    mov eax, [ebp+8]
    test eax, eax
    jle error

    ; ��������� ��� h = 1.0 / n
    fld1                ; st(0) = 1.0
    fidiv dword ptr [ebp+8]  ; st(0) = h = 1.0 / n
    fstp dword ptr [step]    ; ��������� ���

    ; ������������� x = h (�������� � x = h, �.�. � 0 ������� �� ����������)
    fld dword ptr [step]
    fstp dword ptr [x]  ; x = h

    ; ���� �������������� (����� ���������������)
    mov ecx, [ebp+8]    ; ������� ����� = n
    fldz                ; st(0) = sum = 0.0

@@loop:
    ; ��������� f(x_i)
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

    ; ���������� sum (���������)
    fstp dword ptr [sum]
    fld dword ptr [sum]
    jmp exit

error:
    fldz                ; ���������� 0 � ������ ������

exit:
    pop ebp
    ret

CalcIntegral endp
End