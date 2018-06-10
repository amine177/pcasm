.section .data
.section .text
  .globl _start
  .globl factorial

_start:
  pushl $5
  call factorial
  movl $1, %eax
  int $0x80

.type factorial @function
factorial:
  pushl %ebp
  movl %esp, %ebp

  movl 8(%ebp), %ecx
  cmpl $0, %ecx
  movl %ecx, %ebx
  jne loop
  movl $1, %ebx
  jmp factorial_return
loop:
  cmpl $1, %ecx
  je factorial_return
  decl %ecx
  imul %ecx, %ebx
  jmp loop

factorial_return:
  movl %ebp, %esp
  popl %ebp
  ret
