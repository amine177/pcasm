# Write a program that will create a file called henow, and write
# the words "Hey diddle diddle!" into it
.section .data
diddle:
.byte 'H', 'e', 'y', ' ', 'd', 'i', 'd', 'd', 'l', 'e', ' ', 'd', 'i', 'd', 'd', 'l', 'e', '!', 0x0

file:
.byte 'h','e','y','n','o','w', 0x0


done:
.byte 'd','o','n','e','\n', 0x0


.section .text

.globl _start
_start:
  movl $0x5, %eax
  movl $file, %ebx
  movl $03101, %ecx
  movl $0666, %edx
  int $0x80

  movl %eax, %ebx
  movl $0x4, %eax
  movl $diddle, %ecx
  movl $0x13, %edx
  int $0x80

  movl $1, %ebx
  movl $0x4, %eax
  movl $done, %ecx
  movl $0x5, %edx
  int $0x80
  
  movl $1, %eax
  movl $0, %ebx
  int $0x80
  
