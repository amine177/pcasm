.section .data

.section .text

.globl _start
_start:
  pushl $3
  pushl $2
  call power
  addl $4, %esp
  pushl $0
  pushl $5
  call power
  addl $4, %esp
  movl %eax, %ebx
  movl $1, %eax
  int $0x80


.type power,@function
power:
  pushl %ebp
  movl %esp, %ebp
  subl $4, %esp

  movl 8(%ebp), %eax
  movl 12(%ebp), %ecx

  cmpl $0, %ecx
  jg power_notzero
  movl $1, %eax
  jmp power_fin

power_notzero:
  movl %ebx, %eax

power_loop:
  cmpl $1, %ecx
  je power_fin
  imull %ebx, %eax
  decl %ecx
  jmp power_loop

power_fin:
  movl %ebp, %esp
  popl %ebp
  ret
