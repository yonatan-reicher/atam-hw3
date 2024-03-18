.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  # The address of the invalid instruction is the first pointer 8 bytes
  # on the stack.
  push %rbp
  mov %rsp, %rbp

  push %rax
  push %rbx
  push %rdx
  push %rdi
 
  xor %rax, %rax
  xor %rbx, %rbx
  xor %rdx, %rdx

  # RAX - Address of instruction
  # RDX - opcode holder
  # RBX - Incremented return address

  # Set rax. The address is on the stack (from the frame).
  mov 8(%rbp), %rax

  # I think the opcode starts at the lower byte?
  mov 0(%rax), %dl
  
  # Testing first byte is 0F
  cmp $0x0F, %dl
  jne length_is_1
  # Length is 2. Skip the first one.
  mov 1(%rax), %dl
  inc %rbx
length_is_1:
  inc %rbx
  add %rax, %rbx

  # Call the function!
  mov %rdx, %rdi
    push %rcx
    push %rdx
    push %rsi
    push %rdi
    push %r8
    push %r9
    push %r10
    push %r11
    call what_to_do
    pop %r11
    pop %r10
    pop %r9
    pop %r8
    pop %rdi
    pop %rsi
    pop %rdx
    pop %rcx
  cmp $0, %rax
  jnz my_return_path
  # Do the original interrupt on a rax=0!
  pop %rdi
  pop %rdx
  pop %rbx
  pop %rax
  pop %rbp
  # This code will call iretq
  jmp *old_ili_handler
my_return_path:
  # What we need to do:
  # 1. RDI <- RAX
  # 2. Set return address to one instruction after!
  mov %rax, %rdi
  # Right now RBX has the return address
  inc %rbx
  mov %rbx, 8(%rbp)

  pop %rdx # Ignore the stored %rdi value!
  pop %rdx
  pop %rbx
  pop %rax
  pop %rbp
  iretq
