.section .data

.section .text
  .globl _start
  .globl factorial

_start:

  pushl $4

  call factorial
  movl %eax, %ebx

  movl $1, %eax
  int $0x80

factorial:
  pushl %ebp
  movl %esp, %ebp
  movl 8(%ebp), %eax
  cmpl $1, %eax
  je return_factorial
  decl %eax
  pushl %eax
  call factorial
  movl 8(%ebp), %ebx
  imul %ebx, %eax

return_factorial:
  movl %ebp, %esp
  popl %ebp
  ret
