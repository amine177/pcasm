.section .data
data_items:
  .long 3, 67, 34, 222, 34, 0

.section .text
.globl _start

_start:
  movl $0, %edi
  movl data_items(,%edi, 4), %eax
  movl %eax, %ebx
_max:
  cmpl  $0, %eax
  je _fin
  incl %edi
  movl data_items(,%edi, 4), %eax
  cmpl %ebx, %eax
  jle _max
  movl %eax, %ebx
  jmp _max
_fin:
  movl $1, %eax
  int $0x80
