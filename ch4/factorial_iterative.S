.section .data
.section .text
.globl _start
_start:
  pushl $4
  call factorial
  addl $4, %esp
  movl %eax, %ebx
  movl $1, %eax
  int $0x80

.type factorial,@function
factorial:
  pushl %ebp
  movl %esp, %ebp

  movl 8(%ebp), %eax
  cmpl $1, %eax
  jg factorial_init
  movl $1, %eax
  jmp factorial_fin
factorial_init:
  movl %eax, %edx
factorial_loop:
  cmpl $1, %eax
  je factorial_fin
  decl %eax
  imull %eax, %edx
  jmp factorial_loop

factorial_fin:
  movl %edx, %eax
  movl %ebp, %esp
  popl %ebp
  ret
