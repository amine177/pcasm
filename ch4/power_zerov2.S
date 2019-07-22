.section .data
.section .text
.globl _start
_start:
  pushl $4
  pushl $0
  call power
  addl $8, %esp
  movl %eax, %ebx
  movl $1, %eax
  int $0x80

.type  power, @function
power:
  pushl %ebp
  movl %esp, %ebp
  subl $4, %esp
  movl 8(%ebp), %ebx
  movl 12(%ebp), %edx
  movl $1, -4(%ebp)
  
power_iter_start:
  cmpl $1, %edx
  je end_iter
  cmpl $0, %edx
  movl $1, %eax
  je end_iter
  testb $1, %dl
  jnz odd_mul
  imull %ebx, %ebx
  movl %edx, %eax
  movl $2, %ecx
  movl $0, %edx
  divl  %ecx
  movl %eax, %edx
  jmp power_iter_start
odd_mul:
  movl -4(%ebp), %eax
  imull %ebx, %eax
  subl $1, %edx
  movl %eax, -4(%ebp)
  jmp power_iter_start


end_iter:
  movl -4(%ebp), %eax
  imull %ebx, %eax
end_iter_zero:
  movl %ebp, %esp
  popl %ebp
  ret

