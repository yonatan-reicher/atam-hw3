get_element_from_matrix(int**, int, int, int):
        pushq   %rbp
        movq    %rsp, %rbp
        movq    %rdi, -8(%rbp)
        movl    %esi, -12(%rbp)
        movl    %edx, -16(%rbp)
        movl    %ecx, -20(%rbp)
        movl    -12(%rbp), %eax
        imull   -16(%rbp), %eax
        movl    %eax, %edx
        movl    -20(%rbp), %eax
        addl    %edx, %eax
        cltq
        leaq    0(,%rax,4), %rdx
        movq    -8(%rbp), %rax
        addq    %rdx, %rax
        movl    (%rax), %eax
        popq    %rbp
        ret
inner_prod(int**, int**, unsigned int, unsigned int, unsigned int, unsigned int):
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $48, %rsp
        movq    %rdi, -24(%rbp)
        movq    %rsi, -32(%rbp)
        movl    %edx, -36(%rbp)
        movl    %ecx, -40(%rbp)
        movl    %r8d, -44(%rbp)
        movl    %r9d, -48(%rbp)
        movl    $0, -4(%rbp)
        movl    $0, -8(%rbp)
        jmp     .L13
.L14:
        movl    -36(%rbp), %edx
        movl    -44(%rbp), %esi
        movl    -8(%rbp), %ecx
        movq    -24(%rbp), %rax
        movq    %rax, %rdi
        call    get_element_from_matrix(int**, int, int, int)
        movl    %eax, -12(%rbp)
        movl    -40(%rbp), %ecx
        movl    -48(%rbp), %esi
        movl    -8(%rbp), %edx
        movq    -32(%rbp), %rax
        movq    %rax, %rdi
        call    get_element_from_matrix(int**, int, int, int)
        imull   -12(%rbp), %eax
        addl    %eax, -4(%rbp)
        addl    $1, -8(%rbp)
.L13:
        movl    -8(%rbp), %eax
        cmpl    %eax, -44(%rbp)
        ja      .L14
        movl    -4(%rbp), %eax
        leave
        ret
matrix_multiplication(int**, int**, int**, unsigned int, unsigned int, unsigned int, unsigned int):
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $56, %rsp
        movq    %rdi, -24(%rbp)
        movq    %rsi, -32(%rbp)
        movq    %rdx, -40(%rbp)
        movl    %ecx, -44(%rbp)
        movl    %r8d, -48(%rbp)
        movl    %r9d, -52(%rbp)
        movl    -48(%rbp), %eax
        cmpl    -52(%rbp), %eax
        je      .L17
        movl    $0, %eax
        jmp     .L18
.L17:
        movl    $0, -4(%rbp)
        jmp     .L19
.L22:
        movl    $0, -8(%rbp)
        jmp     .L20
.L21:
        movl    -8(%rbp), %ecx
        movl    -4(%rbp), %edx
        movl    -48(%rbp), %edi
        movq    -40(%rbp), %rsi
        movq    -32(%rbp), %rax
        movl    16(%rbp), %r9d
        movl    %edi, %r8d
        movq    %rax, %rdi
        call    inner_prod(int**, int**, unsigned int, unsigned int, unsigned int, unsigned int)
        movl    %eax, -12(%rbp)
        movl    -8(%rbp), %ecx
        movl    -4(%rbp), %edx
        movl    -12(%rbp), %esi
        movq    -24(%rbp), %rax
        movl    %esi, %r8d
        movl    16(%rbp), %esi
        movq    %rax, %rdi
        call    set_element_in_matrix(int**, unsigned int, unsigned int, unsigned int, int)
        addl    $1, -8(%rbp)
.L20:
        movl    -8(%rbp), %eax
        cmpl    %eax, 16(%rbp)
        ja      .L21
        addl    $1, -4(%rbp)
.L19:
        movl    -4(%rbp), %eax
        cmpl    %eax, -44(%rbp)
        ja      .L22
        movl    $1, %eax
.L18:
        leave
        ret