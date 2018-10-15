.section .data

.section .text
.globl _start
_start:
  pushl $3
  pushl $2
  call power
  addl $8, %esp
  pushl $5
  pushl $2
  call power
  addl $8, %esp
  movl %eax, %ebx
  movl $1, %eax
  int $0x80

.type power, @function
power:
  pushl %ebp
  movl %esp, %ebp
  subl $4, %esp

  #args
  movl 12(%ebp), %ecx
  movl 8(%ebp), %ebx

  movl %ebx, -4(%ebp)
  movl %ebx, %eax

power_loop:
  cmpl $1, %ecx
  je end_power
  imull %ebx, %eax
  decl %ecx
  jmp power_loop

end_power:
  movl %ebp, %esp
  popl %ebp
  ret
