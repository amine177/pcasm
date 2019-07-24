.section data

.section .text
.globl factorial # make factorial visible to outside programs
.globl _start
_start:
  pushl $4       # push first argument
  call factorial # factorial(4)
  addl $4, %esp  # free memory
  
  movl %eax, %ebx # ebx = factorial(4)
  movl $1, %eax   # exit()
  int $0x80

.type factorial,@function
factorial:
  pushl %ebp        # save old ebp
  movl %esp, %ebp   # new stack frame base point to old ebp
  
  movl 8(%ebp), %eax # eax = [ebp + 8 ] , assign arg to eax
  cmpl $1, %eax
  je end_factorial
  jmp factorial_cont
  cmpl $0, %eax   # if 0, return 1
  movl $1, %eax
  je end_factorial # if 1, return 1
factorial_cont:

  decl %eax   # decrease for upcoming recursive call
  pushl %eax  # pass parameter
  call factorial # call function recursivle factorial(n - 1)

  movl 8(%ebp), %ebx  # current value
  imull %ebx, %eax # return n * factorial(n - 1)
  
end_factorial:
  movl %ebp, %esp # point on old ebp
  popl %ebp       # restore old ebp
  ret             # return address is on top, we can return
  
