.data
direction: .byte 'U'
apples: .byte 4 4 2 7 3 5 1 8 1 7 3 11 1 11 0 4
apples_length: .word 8
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 2  # head_row
.byte 4  # head_col
.byte 7  # length
# Game grid:
.asciiz "...............#a...#......#12..#......#.3..#........4567..."
"


.text
.globl main
main:
la $a0, state
lbu $a1, direction
la $a2, apples
lw $a3, apples_length
jal move_snake

# You must write your own code here to check the correctness of the function implementation.

li $v0, 10
syscall

.include "hwk3.asm"
