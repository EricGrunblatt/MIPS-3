.data
direction: .byte 'U'
.align 2
state:
.byte 5  # num_rows
.byte 5  # num_cols
.byte 1  # head_row
.byte 2  # head_col
.byte 3  # length
# Game grid:
.asciiz "....a..1...#2#..#3#..###."

.text
.globl main
main:
la $a0, state
lbu $a1, direction
jal increase_snake_length
# You must write your own code here to check the correctness of the function implementation.

li $v0, 10
syscall

.include "hwk3.asm"
