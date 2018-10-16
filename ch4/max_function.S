.section .data
ls1:
  .long 3, 4, 5, 110
ls2:
  .long 120, -1, 200
ls3:
  .long 3, 3, -2

.section .text
  .globl _start
_start:

  pushl $4
  pushl $ls1
  call max
  addl $4, %esp
  pushl $4
  pushl $ls2
  call max
  addl $4, %esp
  pushl $3
  pushl $ls3
  call max
  addl $4, %esp
  movl %eax, %ebx
  movl $1, %eax
  int $0x80

.type max,@function
max:
  pushl %ebp
  movl %esp, %ebp
  movl $0, %edi
  movl 8(%ebp), %ebx
  movl 12(%ebp), %ecx
  movl 0(%ebx, %edi, 4), %eax
  cmpl $1, %ecx
  jbe max_fin

max_loop:
  incl %edi
  cmpl %edi, %ecx
  je max_fin
  movl 0(%ebx,%edi,4), %edx
  cmpl %edx, %eax
  jge max_loop
  movl %edx, %eax
  jmp max_loop


max_fin:
  movl %ebp, %esp
  popl %ebp
  ret
