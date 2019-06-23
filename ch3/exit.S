# a program illustrating exit() syscall

.section .data    # the data section holds initialized static varaibles

.section .text    # the text section contains executable instructions
.globl _start     # making _start visible to the linker (ld)
                  # so _start will be added in the object code's export table

_start:
  movl $1, %eax    # 1 -> exit(int status)
  movl $0, %ebx    # 0 -> status
  int $0x80        # use interrupt vector 0x80 (software interrupt)
