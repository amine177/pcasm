.section .data
data_items:
  .long 3,67,34,222,45,75,54,34,44,50,66,0

.section .text

.globl _start
_start:

  movl $0, %edx                     ; edx := 0
  movl data_items(,%edi,4), %eax    ; eax := data_items[0]
  movl %eax, %ecx                   ; ecx := eax 

_max_loop:
  incl %edx                         ; eax := eax + 1
  movl data_items(,%edx,4), %ecx    ; ecx := data_items[edx * 4]
  cmpl $0, %ecx                     ; if ecx == 0
  je _max_loop_end                  ; goto _max_loop_end
  cmpl %eax, %ecx                   ; if eax < ecx
  jle _max_loop                     ; continue
  movl %ecx, %eax                   ; else eax := ecx
  jmp _max_loop                     ; continue

_max_loop_end:
  movl %eax, %ebx                    ; status := eax
  movl $1, %eax                      ; sys_exit
  int $0x80                          ; interrupt
