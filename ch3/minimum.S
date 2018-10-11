.section .data
data_items:
  .long 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66, 255

.section .text

.globl _start

_start:
  movl $0, %edx
  movl data_items(,%edx,4), %eax
  movl %eax, %ebx

min:
  cmpl $255, %eax
  je fin
  incl %edx
  movl data_items(,%edx, 4), %eax
  cmpl %ebx, %eax
  jge min
  movl %eax, %ebx
  jmp min

fin:
  movl $1, %eax
  int $0x80
