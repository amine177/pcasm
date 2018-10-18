.section .data
ls1:
  .long 3, 2, 5, 8
ls2:
  .long 5, 122, 3
ls3:
  .long -14, -50, -100

.section .text
.globl _start
_start:
  movl $4, %ebx
  movl $ls1, %eax
  call max
  addl $4, %esp
  movl $3, %ebx
  movl $ls2, %eax
  call max
  addl $4, %esp
  movl %edi, %ebx
  movl $1, %eax
  int $0x80

.type max, @function
max:
  movl (%eax), %edi
  movl $1, %ecx
  cmpl %ecx, %ebx
  jg max_loop
  jmp max_fin
max_loop:
  cmpl %ecx, %ebx
  je max_fin
  movl (%eax,%ecx,4), %edx
  incl %ecx
  cmpl %edx, %edi
  jge max_loop
  movl %edx, %edi
  jmp max_loop

max_fin:
  ret
