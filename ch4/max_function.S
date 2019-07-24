.section .data
l1:
  .long 2, 3, 4, 5
l2:
  .long 4, 25, 10
l3:
  .long -1, 101


.section .text
.globl _start

_start:
  pushl $3
  pushl $l2
  call max  # max(l1, l1.length)
  add $4, %esp # free(max.local_variable)

  movl %eax, %ebx # exit(%ebx)
  movl $1, %eax
  int $0x80



.type max,@function

max:
  # prelogue
  pushl %ebp
  movl %esp, %ebp

  movl 0xC(%ebp), %ecx
  movl 0x8(%ebp), %edx
  decl %ecx
  movl (%edx, %ecx, 4), %ebx
  jmp max_loop

max_loop:
  test %ecx, %ecx
  jz max_end
  
  decl %ecx
  movl (%edx, %ecx, 4), %eax
  cmpl %eax, %ebx
  jg max_loop
  movl %eax, %ebx
  jmp max_loop

max_end:
  movl %ebx, %eax

  # epilogue
  movl %ebp, %esp
  popl %ebp
  ret
