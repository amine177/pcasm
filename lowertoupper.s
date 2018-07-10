# assemble using : as lowertoupper.s -o lowertoupper.o
# on x86_64 : as --32 lowertoupper.s -o lowertoupper.o
# link using : ld lowertoupper.o -o lowertoupper
# on x86_64: ld -m elf_i386 lowertoupper.o -o lowertoupper
.section .data

  .equ SYS_OPEN, 5
  .equ SYS_WRITE, 4
  .equ SYS_READ, 3
  .equ SYS_CLOSE, 6
  .equ SYS_EXIT, 1

  .equ O_RDONLY, 0
  .equ O_CREAT_WRONLY_TRUNC, 03101
  .equ STDIN, 0
  .equ STDOUT, 1
  .equ STDERR, 2
  .equ LINUX_SYSCALL, 0x80
  .equ END_OF_FILE, 0
  .equ NUMBER_ARGUMENTS, 2

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

.globl _start
_start:
  movl %esp, %ebp             # make %ebp point to current frame as a base for it
  subl $ST_SIZE_RESERVE, %esp # put %esp to point at 8 bytes from current address
                              #  equ reserving 8 bytes of memory

open_files:
open_fd_in:
  movl $SYS_OPEN, %eax        # 5 is the system call number for
                              # int open(char *path, int flag, mode_t mode)
  movl ST_ARGV_1(%ebp), %ebx  # char* path
  movl $O_RDONLY, %ecx        # int flag
  movl $0666, %edx            # mode_t mode rw-rw-rw, not important when reading
  int $LINUX_SYSCALL          # interrupt call, filedescriptor will be on %eax

store_fd_in:
  movl %eax, ST_FD_IN(%ebp)   # move the fd in %ebp - 4, stack grows down :P

open_fd_out:
  movl $SYS_OPEN, %eax        # opening the destination file, if it doesn't exist
                              # int open() would create it
  movl ST_ARGV_2(%ebp), %ebx
  movl $O_CREAT_WRONLY_TRUNC, %ecx # if it doesn't exist, create it with
  movl $0666, %edx                 # mode_t mode rw-rw-rw
  int $LINUX_SYSCALL               # interrupt call, fd in %eax

store_fd_out:
  movl %eax, ST_FD_OUT(%ebp)       # store the second fd in %ebp - 8

read_loop_begin:
  movl $SYS_READ, %eax             # 3 is the syscall for
                                   #ssize_t read(int fd, void *buf, size_t count)
  movl ST_FD_IN(%ebp), %ebx   # pass int fd from %ebp - 4 
  movl $BUFFER_DATA, %ecx     # pass *buf
  movl $BUFFER_SIZE, %edx     # pass size_t count, reading 500 bytes from the input file
  int $LINUX_SYSCALL          # interrupt call

  cmpl $END_OF_FILE, %eax     # if read returned 0 bytes
  jle end_loop                # exit loop

continue_read_loop:
  pushl $BUFFER_DATA          # else save the buffer' address
  pushl %eax                  # save the number of bytes returned
  call convert_to_upper       # convert the bytes to uppercase
  popl %eax                   # get the number of the bytes retuned
  addl $4, %esp               # deallocate the space taken by $BUFFER_DATA
  movl %eax, %edx             # setting size_t count for ssize_t write()
  movl $SYS_WRITE, %eax       # 4 is ssize_t write(int fd, void *buf, size_t count)
  movl ST_FD_OUT(%ebp), %ebx  # int fd
  movl $BUFFER_DATA, %ecx     # void *buf : buffer to read from, %edx gives number of bytes
  int $LINUX_SYSCALL          # interrupt
  jmp read_loop_begin         # loop again

end_loop:
  movl $SYS_CLOSE, %eax       # 6 is for int close(int fd)
  movl ST_FD_OUT(%ebp), %ebx  # int fd , closing the output file
  int $LINUX_SYSCALL          # interrupt

  movl $SYS_CLOSE, %eax       # same here, but closing the input file
  movl ST_FD_IN(%ebp), %ebx
  int $LINUX_SYSCALL

  movl $SYS_EXIT, %eax        # 0 is for void exit(int status)
  movl $0, %ebx               # 0 is for normal exit
  int $LINUX_SYSCALL          # interrupt

#Function
.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'
.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

convert_to_upper:
  pushl %ebp                      # save old frame
  movl %esp, %ebp                 # make %ebp point to old %ebp to be a base pointer
  movl ST_BUFFER(%ebp), %eax      # get the void* buf address
  movl ST_BUFFER_LEN(%ebp), %ebx  # get the number of bytes
  movl $0, %edi                   # first byte is at index 0

  cmpl $0, %ebx                   #  if  getting 0 bytes
  je end_convert_loop             # exit
  
convert_loop:
  movb (%eax, %edi, 1), %cl       # else move the current byte to %cl
  cmpb $LOWERCASE_A, %cl          # if not lowercase
  jl next_byte                    # go to next byte

  addb $UPPER_CONVERSION, %cl     # esle make upper
  movb %cl, (%eax, %edi, 1)       # save to the buffer *void buf
next_byte:
  incl %edi                       # increment index
  cmpl %edi, %ebx                 # if  not last byte is done
  jne convert_loop                # continue converting

end_convert_loop:
  movl %ebp, %esp                 # else end loop restore old %esp, restore %ebp
  popl %ebp
  ret                             # return

