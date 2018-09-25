# exit

.section .data

.section .text
.globl _start
_start:
  movl $1, %eax #syscall 1, exit()
  movl $2, %ebx #argument[0] = 0
  int $0x80
