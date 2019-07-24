.section .data

.section .text
.globl _start
_start:
  pushl $4
  call square
  movl %eax, %ebx
  movl $1, %eax
  int $0x80


.type square, @function
square:
  movl 4(%esp), %eax
  imull %eax, %eax
  ret
