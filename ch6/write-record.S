.include "linux.S"
.include "record-def.S"

# arguments: fd and buff
# result: buff gets record from file


.equ BUF, 0xc
.equ FD, 0x8

.section .text
.globl write_record
.type write_record, @function

write_record:
  pushl %ebp
  movl %esp, %ebp


  movl FD(%ebp), %ebx
  movl BUF(%ebp), %ecx
  movl $RECORD_SIZE, %edx
  movl $SYS_WRITE, %eax
  int $0x80


  movl %ebp, %esp
  popl %ebp
  ret
