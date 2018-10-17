.section .data
.section .text
.globl _start
_start:
  movl $3, %eax
  call square
  movl %edi, %ebx
  movl $1, %eax
  int $0x80

.type square,@function
square:
  imull %eax, %eax
  movl %eax, %edi
  ret
