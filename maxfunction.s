.section .data
list1:
  .long 3, 4, 2, 15, 1, 102
list2:
  .long 1, 1, 2, 1, 5
list3:
  .long -4, -3, -5, -2, -1
hell:
  .asciz "hello\n"

format:
  .ascii "%d\n"

.section .text
  .globl _start
  .globl maximum
  
_start:
  pushl $list1
  pushl $6
  call maximum

  movl $0x1, %eax
  int $0x80
.type maximum @function
maximum:
  pushl %ebp
  movl %esp, %ebp
  movl 8(%ebp), %edx
  cmpl $0x0, %edx
  je maximum_return
  movl 12(%ebp), %eax
  movl (%eax), %eax
  movl $0x0, %ecx
loop:
  incl %ecx
  cmpl %ecx, %edx
  je maximum_return
  movl 12(%ebp), %ebx
  movl (%ebx, %ecx, 4), %ebx
  cmpl %eax, %ebx
  jle loop
  movl %ebx, %eax
  jmp loop
maximum_return:
  movl %eax, %ebx
  movl %ebp, %esp
  popl %ebp
  ret
