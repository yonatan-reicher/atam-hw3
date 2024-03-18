.section .data
A: .int 1, 0, 3, 0, 1, 2 
B: .int 0, 15, 3
C: .int 0, 0

.section .text
.global main
.global get_element_from_matrix, inner_prod, matrix_multiplication, set_element_in_matrix

main:
    pushq %rbp
    movq %rsp, %rbp
    sub $8, %rsp
    movq $A, %rdi
    movq $3, %rsi
    movq $0, %rdx
    movq $0, %rcx
    call get_element_from_matrix
    movq $A, %rdi
    movq $B, %rsi
    movq $0, %rdx
    movq $0, %rcx
    movq $3, %r8
    movq $1, %r9
    call inner_prod
    movq $C, %rdi
    movq $A, %rsi
    movq $B, %rdx
    movq $2, %rcx
    movq $3, %r8
    movq $3, %r9
    pushq $1
    call matrix_multiplication
    xor    %eax, %eax
leave
    ret

.global get_element_from_matrix, inner_prod, matrix_multiplication

get_element_from_matrix:
imull %esi, %edx #n*row
addl %ecx, %edx #+col
movl %edx, %eax #make sure its cool
cltq
leaq 0(,%rax,4), %rax # *4
addq %rdi, %rax #add+rax
movl (%rax), %eax
	ret

inner_prod:
pushq %rbp
movq %rsp, %rbp
sub $44, %rsp #making space
#save variables:
movq %rdi, -8(%rbp) # int* mat[] a
movq %rsi, -16(%rbp) # int* mat[] b
movl %edx, -20(%rbp) # row a
movl %ecx, -24(%rbp) # col b
movl %r8d, -28(%rbp) # max_col a
movl %r9d, -32(%rbp) # max_col b
movl $0, -36(%rbp) # counter
movl $0, -40(%rbp) # temp mul
movl $0, -44(%rbp) # temp sum

LOOP_PROD:
#set up for get element a:
movq -8(%rbp), %rdi #int* mat[] a
movl -28(%rbp), %esi #max col a
movl -20(%rbp), %edx # row a
movl -36(%rbp), %ecx # counter = col a
call get_element_from_matrix

movl %eax, -40(%rbp)

movq -16(%rbp), %rdi # int* mat[] b
movl -32(%rbp), %esi # max col b
movl -36(%rbp), %ecx # counter == row b
movl -24(%rbp), %edx # col b
call get_element_from_matrix

imull -40(%rbp), %eax # multiply  
addl  %eax, -44(%rbp) #add to sum 

incl -36(%rbp) 
movl -28(%rbp), %eax #max_col_a
cmpl %eax, -36(%rbp) #counter==max_col_a?
jne LOOP_PROD

movl -44(%rbp), %eax
leave
	ret


matrix_multiplication:
movq 8(%rbp), %rax # get last parameter before saving rbp
pushq %rbp
movq %rsp, %rbp
cmp %r8d, %r9d 
jne FAILURE


sub $48, %rsp #making space
#save variables:
movq %rdi, -8(%rbp) #int* mat[] res
movq %rsi, -16(%rbp) #int* mat[] a
movq %rdx, -24(%rbp) #int* mat[] b
movl %ecx, -28(%rbp) #max row a
movl %r8d, -32(%rbp) #max col a
movl %r9d, -36(%rbp) #max row b
movl %eax, -40(%rbp) #max col b
movl $0, -44(%rbp) #row counter
movl $0, -48(%rbp) #col counter


LOOP_ROWS: #loop for counter < max row a 
LOOP_COLS: #loop for counter < max col b
movl $0, -48(%rbp) #col counter

# move parameters for inner prod
movq -16(%rbp), %rdi #mat_a
movq -24(%rbp), %rsi #mat_b
movl -44(%rbp), %edx #row counter = row_a
movl -48(%rbp), %ecx #col counter = col_b
movl -32(%rbp), %r8d #max_col_a
movl -40(%rbp), %r9d #max_col_b
call inner_prod

#move parameters(int* matrix[], unsigned int num_of_columns, unsigned int row, unsigned int col, int value
movq -8(%rbp), %rdi #int* mat[] res
movl -40(%rbp), %esi #max_col_b
movl -44(%rbp), %edx #row counter
movl -48(%rbp), %ecx #col counter
movl %eax, %r8d #inner prod res
call set_element_in_matrix

incl -48(%rbp) #col counter
movl -40(%rbp), %eax #max col b
cmpl -48(%rbp), %eax #counter==max_col_b?
jne LOOP_COLS

incl -44(%rbp) #row counter
movl -28(%rbp), %eax
cmpl -44(%rbp), %eax #counter==max_row_a?
jne LOOP_ROWS
jmp SUCCESS

FAILURE:
movl $0, %eax 
jmp END_MUL

SUCCESS:
movl $1, %eax 
jmp END_MUL

END_MUL:
leave
	ret


set_element_in_matrix:
imull %esi, %edx #n*row
addl %ecx, %edx #+col
movl %edx, %eax #make sure its cool
cltq
leaq 0(,%rax,4), %rax # *4
addq %rdi, %rax #add+rax
    movl %r8d,(%rax)
    ret
