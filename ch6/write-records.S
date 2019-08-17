.include "linux.S"
.include "record-def.S"


.section .data


r1:
  .ascii "Neo\0"
  .rept 36
  .byte 0
  .endr

  .ascii "Anon\0"
  .rept 35
  .byte 0
  .endr

  .ascii "42 Life blv\nEarth, 1*1\0"
  .rept 217
  .byte 0
  .endr

  .long 32

r2:
  .ascii "Kafka\0"
  .rept 34
  .byte 0
  .endr

  .ascii "Meld\0"
  .rept 35
  .byte 0
  .endr

  .ascii "00 Life blv\nEarth, 1*1\0"
  .rept 217
  .byte 0
  .endr

  .long 34


r3:
  .ascii "Chaka\0"
  .rept 34
  .byte 0
  .endr

  .ascii "Peld\0"
  .rept 35
  .byte 0
  .endr

  .ascii "00 Death  blv\nEarth, 1*1\0"
  .rept 216
  .byte 0
  .endr

  .long 35


file:
  .ascii "database.db\0"

.equ FD, -0x4
.globl _start
_start:
  movl %esp, %ebp
  subl $0x4, %esp

  movl $file, %ebx
  movl $0101, %ecx
  movl $0666, %edx
  movl $SYS_OPEN, %eax
  int $0x80

  movl %eax, FD(%ebp)


  pushl $r1
  pushl FD(%ebp)
  call write_record
  addl $0x8, %esp

  pushl $r2
  pushl FD(%ebp)
  call write_record
  addl $0x8, %esp

  pushl $r3
  pushl FD(%ebp)
  call write_record
  addl $0x8, %esp

  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $0x80
