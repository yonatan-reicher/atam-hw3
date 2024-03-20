
.global get_element_from_matrix, inner_prod, matrix_multiplication

get_element_from_matrix:
imull %esi, %edx #n*row
addl %ecx, %edx #+col
movl %edx, %eax 
cltq #make sure its cool for lea
leaq 0(%rdi,%rax,4), %rax #base+rax*4
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


CHECK_PROD:
movl -28(%rbp), %eax #max_col_a
cmpl  -36(%rbp), %eax #counter==max_col_a?
ja LOOP_PROD
jmp END_PROD

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

addl $1, -36(%rbp) 
jmp CHECK_PROD

END_PROD:
movl -44(%rbp), %eax
leave
	ret


matrix_multiplication:
pushq %rbp
movq %rsp, %rbp
cmp %r8d, %r9d 
jne FAILURE

movq 16(%rbp), %rax # get last parameter before saving rbp
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


CHECK_ROWS:
movl -28(%rbp), %eax
cmpl -44(%rbp), %eax #counter<max_row_a?
je SUCCESS
jmp LOOP_ROWS


LOOP_ROWS: #loop for counter < max row a 
movl $0, -48(%rbp) #col counter

CHECK_COLS:
movl -48(%rbp), %eax 
cmpl -40(%rbp), %eax #counter<max_col_b?
jne LOOP_COLS 
addl $1, -44(%rbp) #row counter
jmp CHECK_ROWS 

LOOP_COLS: #loop for counter < max col b
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

addl $1, -48(%rbp) #col counter
jmp CHECK_COLS


FAILURE:
movl $0, %eax 
jmp END_MUL

SUCCESS:
movl $1, %eax 
jmp END_MUL

END_MUL:
leave
	ret

