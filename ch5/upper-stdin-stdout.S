# Modifiy the program so that it reads from STDIN and writes to stdout
.section .data
# we define constants here

.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_EXIT, 1


# syscall interrupt
.equ LINUX_SYSCALL, 0x80
.equ EOF, 0

# uninitialized data
.section .bss

.equ MAXSIZE, 1024
.lcomm BUFF, MAXSIZE

.section .text
.globl _start
_start:
read_loop:
  movl $SYS_READ, %eax
  movl $0, %ebx
  movl $BUFF, %ecx
  movl $MAXSIZE, %edx
  int $LINUX_SYSCALL
  
  cmpl $EOF, %eax
  jle read_end
  
  pushl %eax
  pushl $BUFF
  call upper
  popl %edx
  popl %edx
  
  movl  $SYS_WRITE, %eax
  movl $1, %ebx
  movl $BUFF, %ecx
  int $LINUX_SYSCALL

  jmp read_loop

read_end:
  movl $1, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL


# upper(buff, buff.length)
.equ LOWER_A, 'a'
.equ LOWER_Z, 'z'
.equ UPPER_LOWER_OFFSET, 'A' - 'a'
.type upper,@function
upper:
  pushl %ebp
  movl %esp, %ebp

  movl 0xc(%ebp), %ecx
  movl 0x8(%ebp), %eax

upper_loop:
  decl %ecx
  cmpl $-0x1, %ecx
  je upper_end
  xor %edx, %edx
  movb (%eax,%ecx,1), %dl
  cmpb $LOWER_A, %dl
  jl upper_loop
  cmpb $LOWER_Z, %dl
  jg upper_loop
  addb $UPPER_LOWER_OFFSET, %dl
  movb %dl, (%eax, %ecx, 1)
  jmp upper_loop

upper_end:
  movl %ebp, %esp
  popl %ebp
  ret
