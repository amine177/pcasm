.section .data
# we define constants here

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# O_CREAT | O_WRONLY | O_TRUNC = 03101
.equ O_CREAT_WRONLY_TRUNC, 03101

# O_RDONLY
.equ O_RDONLY, 0

# descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# syscall interrupt
.equ LINUX_SYSCALL, 0x80
.equ EOF, 0
.equ ARGC, 2

# uninitialized data
.section .bss

.equ MAXSIZE, 1024
.lcomm BUFF, MAXSIZE

.lcomm FD1, 4
.lcomm FD2, 4

.section .text
.globl _start
_start:
  movl %esp, %ebp # using ebp as frame base
  subl $0x8, %esp # allocate tow words for the tow fds
  # open source file
  movl $SYS_OPEN, %eax
  movl 0x8(%ebp), %ebx
  movl $O_RDONLY, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL
  movl %eax, (FD1)
  
  # open or creat destination file
  movl $SYS_OPEN, %eax
  movl 0xC(%ebp), %ebx
  movl $O_CREAT_WRONLY_TRUNC, %ecx
  movl $0666, %edx # rights for creat if not exist
  int $LINUX_SYSCALL
  movl %eax, (FD2)
read_loop:
  movl $SYS_READ, %eax
  movl (FD1), %ebx
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
  movl (FD2), %ebx
  movl $BUFF, %ecx
  int $LINUX_SYSCALL

  jmp read_loop

read_end:
  movl $SYS_CLOSE, %eax
  movl $FD1, %ebx
  int $LINUX_SYSCALL
  movl $SYS_CLOSE, %eax
  movl $FD2, %ebx
  int $LINUX_SYSCALL

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
