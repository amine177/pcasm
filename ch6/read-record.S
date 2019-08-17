.include "record-def.s"
.include "linux.s"




# arguments: fd, buf
# result : writes from fd to buf



.equ FD, 0x8
.equ BUFF, 0xc

.section .text
.globl read_record
type read_record, @function

read_record:
  pushl %ebp
  movl %esp, %ebp
  
  movl FD(%ebp), %ebx
  movl BUFF(%ebp), %ecx
  movl $RECORD_SIZE, %edx
  movl $SYS_READ, %eax
  int $0x80

  movl %ebp, %esp
  popl %ebp
  ret
