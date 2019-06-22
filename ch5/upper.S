.section .data
  .equ SYS_READ, 0x3
  .equ SYS_WRITE, 0x4
  .equ SYS_OPEN, 0x5
  .equ SYS_CLOSE, 0x6
  .equ SYS_EXIT, 0x1
  .equ O_RDONLY, 0x0
  .equ O_CREAT_WRONLY_TRUN, 03101
  .equ EOF, 0
  .equ STDIN, 0x0
  .equ STDOUT, 0x1
  .equ STDERR, 0x2
  .equ LINUX_SYSCALL, 0x80
.section .bss
  .equ BUFFER_SIZE, 500
  .lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
  .equ ST_SIZE_RESERVE, 8
  .equ ST_FD_IN, -4
  .equ ST_FD_OUT, -8
  .equ ST_ARGC, 0
  .equ ST_ARGV_0, 4
  .equ ST_ARGV_1, 8
  .equ ST_ARGV_2, 12

.globl _start:
_start:
  movl %esp, %ebp
  subl $ST_SIZE_RESERVE, %esp
open_files:
open_fd_in:
  movl $SYS_OPEN, %eax
  movl ST_ARGV_1(%ebp), %ebx
  movl $O_RDONLY, %ecx
  movl $0666, %edx

  int $LINUX_SYSCALL

stor_fd_out:
  movl %eax, ST_FD_OUT(%ebp)

read_loop_begin:

.type readbytes, @fuction
readbytes:
  pushl %ebp
  movl %esp, %ebp
  movl 8(%ebp), %ecx
  movl 12(%ebp), %edx
  movl SYS_RED, %eax
  int $LINUX_SYSCALL
