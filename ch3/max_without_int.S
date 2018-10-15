.section .data
data_items:
  .long 3, 15, -1, 2, 5

.section .text

.globl _start
_start:
  movl $0, %edi
  movl data_items(,%edi,4), %eax
  movl %eax, %ebx

max:
  cmpl $4, %edi
  je fin
  incl %edi
  movl data_items(, %edi, 4), %eax
  cmpl %ebx, %eax
  jle max
  movl %eax, %ebx
  jmp max

fin:
