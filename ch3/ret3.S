.section .data

.section .text

.globl _start

_start:
  movl $3, %ebx
  movl $1, %eax
  int $0x80
