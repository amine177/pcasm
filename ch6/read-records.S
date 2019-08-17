.include "linux.S"
.include "record-def.S"

#.equ RECORD_FIRSTNAME, 0
#.equ RECORD_LASTNAME, 40
#.equ RECORD_ADDRESS, 80
#.equ RECORD_AGE, 320

#.equ RECORD_SIZE, 324

.section .data


.section .bss
.equ BUFSIZE, 324
.lcomm BUF, BUFSIZE

.section .text
.globl _start
_start:
  movl %esp, %ebp
  movl 0x8(%ebp), %ebx
  movl $0, %ecx
  movl $SYS_OPEN, %eax
  movl $0666, %edx
  int $0x80

  pushl $BUF
  pushl %eax
  call read_record
  addl $0x8, %esp
  pushl $BUF
  call print_record

  pushl $BUF
  pushl %eax
  call read_record
  addl $0x8, %esp
  pushl $BUF
  call print_record
  

  
  movl $0x0, %ebx
  movl $SYS_EXIT, %eax
  int $0x80

.globl print_record
.type print_record, @function
print_record:
  pushl %ebp
  movl %esp, %ebp
  
  movl 0x8(%ebp), %edi
  pushl %edi
  call print_string
  addl $0x4, %esp
  
  movl $0xa, %edi
  pushl %edi
  pushl %esp
  call print_string
  addl $0x8, %esp

  movl 0x8(%ebp), %edi
  addl $40, %edi
  pushl %edi
  call print_string
  addl $0x4, %esp

  movl $0xa, %edi
  pushl %edi
  pushl %esp
  call print_string
  addl $0x8, %esp

  movl 0x8(%ebp), %edi
  addl $80, %edi
  pushl %edi
  call print_string
  addl $0x4, %esp

  movl $0xa, %edi
  pushl %edi
  pushl %esp
  call print_string
  addl $0x8, %esp

  movl 0x8(%ebp), %edi
  addl $320, %edi
  pushl %edi
  call print_string
  addl $0x4, %esp

  movl $0xa, %edi
  pushl %edi
  pushl %esp
  call print_string
  addl $0x8, %esp

  movl %ebp, %esp
  popl %ebp
  ret
  
  
.globl print_string
.type print_string, @function
print_string:
  pushl %ebp
  movl %esp, %ebp
  movl $0x0, %edi
print_loop:  
  movl 0x8(%ebp), %ecx
  xor %eax, %eax
  addl %edi, %ecx
  movl %ecx, %eax
  cmpb $0x0, (%eax)
  je print_string_end
  
  movl $0x1, %ebx
  movl $0x1, %edx
  movl $SYS_WRITE, %eax
  int $0x80
  incl %edi
  jmp print_loop

print_string_end:
  movl %ebp, %esp
  popl %ebp
  ret
