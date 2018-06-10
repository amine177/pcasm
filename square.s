.section .data
.section .text
  .globl _start
  .globl square
_start:
  pushl $4
  call square
  movl %eax, %ebx

  movl $1, %eax
  int $0x80

square:
  push %ebp
  movl %esp, %ebp

  movl 8(%ebp), %eax
  imul %eax, %eax

  popl %ebp
  ret
