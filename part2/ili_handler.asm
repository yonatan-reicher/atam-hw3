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
  # RBX, RCX - helpers

  # Set rax. The address is on the stack (from the frame).
  mov 8(%rbp), %rax

  # I think the opcode starts at the lower byte?
  mov 0(%rax), %dl
  
  # Testing first byte is 0F
  cmp $0x0F, %dl
  jne length_is_1
  # Length is 2. Skip the first one.
  mov 1(%rax), %dl
length_is_1:

  # Call the function!
  mov %rdx, %rdi
  mov %rax, %rbx
  call what_to_do
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
