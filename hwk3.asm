# Eric Grunbatt
# egrunblatt
# 112613770

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
load_game:
	addi $sp, $sp, -20			# allocate 24 bytes of space
	sw $s0, 0($sp)				# $s0 = state
	sw $s1, 4($sp)				# $s1 = filename
	sw $s2, 8($sp)				# $s2 = $v0
	sw $s4, 12($sp)				# number of rows
	sw $s5, 16($sp)				# number of columns
	move $s0, $a0				# $s0 = state
	move $s1, $a1				# $s1 = filename

	# Read to a file
	li $v0, 13				# gets ready to open file
	li $a1, 0				# flags = 0
	move $a0, $s1				# $a0 = filename
	syscall					# open file	
	move $s2, $v0				# $s2 = descriptor
	
	li $t0, -1				# $t0 = -1
	beq $s2, $t0, load_neg_1		# descriptor = -1, set $v1 to -1
	
	li $t3, 0				# allocated space counter
	li $t0, 0				# number counter
	move $t4, $s0				# move state to $t1 just to store the contents
	
	# Read number of rows
	get_num_rows_loop:
		addi $sp, $sp, -1		# allocate 1 byte of space to get current character
		addi $t3, $t3, 1		# add 1 to counter
		li $v0, 14			# get ready to read from file
		move $a1, $sp			# $a1 = stack
		li $a2, 1			# $a2 = 1 for buffer
		move $a0, $s2			# $a0 = descriptor
		syscall 			# read from file
		
		lb $a0, 0($sp)			# $a0 = current byte on stack	
		
		li $t1, 10				# $t1 = \n
		beq $a0, $t1, end_get_num_rows_loop	# $a0 = \n, end loop
		li $t1, 13				# $t1 = \r
		beq $a0, $t1, get_num_rows_loop		# $a0 = \r, jump to top
		
		sb $a0, 0($t4)				# store $a0 to string
		addi $t4, $t4, 1			# move position in string
		addi $t0, $t0, 1			# add to number counter
		j get_num_rows_loop			# jump to top of loop
	end_get_num_rows_loop:
	add $sp, $sp, $t3				# deallocate space on stack
	
	li $t1, 1					# $t1 = 1
	beq $t0, $t1, rows_equals_1			# $t0 = 1, rows_equals_1
	li $t1, 2					# $t1 = 2
	beq $t0, $t1, rows_equals_2			# $t0 = 2, rows_equals_2
	rows_equals_1:
		move $t4, $s0				# $t4 = state
		lb $t0, 0($t4)				# $t0 = first byte (ones place)
		addi $t0, $t0, -48			# subtract 48 to get number value
		sb $t0, 0($t4)				# store byte in first position of state
		j get_num_cols				# jump to get_num_cols
	rows_equals_2:
		move $t4, $s0				# $t4 = state
		lb $t0, 0($t4)				# $t0 = first byte (tens place)
		lb $t1, 1($t4)				# $t1 = second byte (ones place)
		addi $t0, $t0, -48			# subtract 48 to get number value
		addi $t1, $t1, -48			# subtract 48 to get number value
		li $t2, 10				# $t2 = 10
		mul $t0, $t0, $t2			# multiply $t0 by ten since it is tens place
		add $t0, $t0, $t1			# add 1s place ($t1) to $t0
		sb $t0, 0($t4)				# store byte in first position of state
	
	get_num_cols:
	li $t3, 0				# allocated space counter
	li $t0, 0				# number counter
	# Read number of rows
	get_num_cols_loop:
		addi $sp, $sp, -1		# allocate 1 byte of space to get current character
		addi $t3, $t3, 1		# add 1 to counter
		li $v0, 14			# get ready to read from file
		move $a1, $sp			# $a1 = stack
		li $a2, 1			# $a2 = 1 for buffer
		move $a0, $s2			# $a0 = descriptor
		syscall 			# read from file
		
		lb $a0, 0($sp)			# $a0 = current byte on stack	
		
		li $t1, 10				# $t1 = \n
		beq $a0, $t1, end_get_num_cols_loop	# $a0 = \n, end loop
		li $t1, 13				# $t1 = \r
		beq $a0, $t1, get_num_cols_loop		# $a0 = \r, jump to top
		
		sb $a0, 1($t4)				# store $a0 to string
		addi $t4, $t4, 1			# move position in string
		addi $t0, $t0, 1			# add to number counter
		j get_num_cols_loop			# jump to top of loop
	end_get_num_cols_loop:
	add $sp, $sp, $t3				# deallocate space on stack
	
	li $t1, 1					# $t1 = 1
	beq $t0, $t1, cols_equals_1			# $t0 = 1, cols_equals_1
	li $t1, 2					# $t1 = 2
	beq $t0, $t1, cols_equals_2			# $t0 = 2, cols_equals_2
	cols_equals_1:
		move $t4, $s0				# $t4 = state
		addi $t4, $t4, 1			# add 1 to state
		lb $t0, 0($t4)				# $t0 = first byte (ones place)
		addi $t0, $t0, -48			# subtract 48 to get number value
		sb $t0, 0($t4)				# store byte in second position
		addi $t4, $t4, 4			# add 4 to state (gives space for other info)
		j print_file				# jump to print_file
	cols_equals_2:	
		move $t4, $s0				# $t4 = state
		addi $t4 ,$t4, 1			# add 1 to state
		lb $t0, 0($t4)				# $t0 = first byte (tens place)
		lb $t1, 1($t4)				# $t1 = second byte (ones place)
		addi $t0, $t0, -48			# subtract 48 to get number value
		addi $t1, $t1, -48			# subtract 48 to get number value
		li $t2, 10				# $t2 = 10
		mul $t0, $t0, $t2			# multiply $t0 by ten since it is tens place
		add $t0, $t0, $t1			# add 1s place ($t1) to $t0
		sb $t0, 0($t4)				# store byte in first position of state
		addi $t4, $t4, 4			# add 4 to state (gives space for other info)
		j print_file				# jump to print_file
	
	# Print contents of file
	print_file:
	li $t3, 0						# allocated space counter
	li $t5, 0						# number of #s counted
	print_file_loop:
		addi $sp, $sp, -1				# allocate 1 byte of space to get current character
		addi $t3, $t3, 1				# add 1 to counter
		li $v0, 14					# get ready to read from file
		move $a1, $sp					# $a1 = stack
		li $a2, 1					# $a2 = 1 for buffer
		move $a0, $s2					# $a0 = descriptor
		syscall 					# read from file	
	
		lb $a0, 0($sp)					# $a0 = current byte on stack	
		
		li $t0, 'a'					# $t0 = a
		beq $a0, $t0, return_1				# $a0 = a, return_1
		
		li $t0, '#'					# $t0 = #
		beq $a0, $t0, add_v1_1				# $a0 = #, add_v1_1
		
		beq $a0, $0, end_print_file_loop		# $a0 = null terminator, end_print_file_loop
		li $t0, 10					# $t0 = 10
		beq $a0, $t0, print_file_loop			# $a0 = \n, print_file_loop
		li $t0, 13					# $t0 = 13
		beq $a0, $t0, print_file_loop			# $a0 = \r, print_file_loop
		sb $a0, 0($t4)					# store byte in state
		addi $t4, $t4, 1				# add 1 to state
		j print_file_loop				# jump to print_file_loop
		
		return_1:
			li $t0, 1				# $t0 = 1
			move $t6, $t0				# $t6 = 1
			sb $a0, 0($t4)				# store current byte in state
			addi $t4, $t4, 1			# add 1 to state
			j print_file_loop			# jump to print_file_loop
			
		add_v1_1:
			addi $t5, $t5, 1			# add 1 to $t5 (# counter)
			sb $a0, 0($t4)				# store current byte in state
			addi $t4, $t4, 1			# add 1 to state
			j print_file_loop			# jump to print_file_loop
	end_print_file_loop:
	sb $0, 0($t4)						# null terminate the string
	add $sp, $sp, $t3					# dealloate space in stack
	move $v0, $t6						# $v0 = 0 or 1 if there is an "a"
	move $v1, $t5						# move number of #s to $v1 
	
	# Gets head row and column location
	move $t0, $s0						# $t0 = state that will be changed
	addi $t0, $t0, 5					# add 5 to state to get first byte of game
	li $t1, 1						# current column
	get_head_and_tail_loop:
		lb $t2, 0($t0)					# $t2 = current byte
		beq $t2, $0, end_get_head_and_tail_loop		# $t2 = null terminator, end loop
		addi $t0, $t0, 1				# add 1 to state
		li $t3, 49					# $t3 = 49 (ascii value for 1)
		beq $t2, $t3, get_head_address			# $t2 = 49, get head address
		addi $t1, $t1, 1				# add 1 to current column
		j get_head_and_tail_loop			# jump to get_head_and_tail
		
		get_head_address:
			lb $t5, 1($s0)				# $t5 = total number of columns
			addi $t1, $t1, -1			# subtract one from index counter
			div $t1, $t5				# divide index counter by total number of columns
			mfhi $t7				# $t7 = remainder
			sb $t7, 3($s0)				# stores head column 
			sub $t5, $t0, $s0			# subtracts current address from original address
			addi $t5, $t5, -5			# subtract 5 from original
			sub $t5, $t5, $t7			# $t3 = current row * total number of columns
			
			lb $t6, 1($s0)				# gets total number of columns
			div $t5, $t6				# divides (current row * total number of columns) / total number of columns
			mflo $t5				# $t3 = current row
			sb $t5, 2($s0)				# stores head row
			addi $t1, $t1, 1			# add 1 to current column
			j get_head_and_tail_loop		# jump to top of loop
	end_get_head_and_tail_loop:
	
	move $t0, $s0						# $t0 = state
	addi $t0, $t0, 5					# add 5 to state to start at game board
	li $t1, 0						# $t1 = 0, length counter
	get_length_loop:
		lb $t2, 0($t0)					# $t2 = current character
		beq $t2, $0, end_get_length_loop		# $t2 = null terminator, end loop
		addi $t0, $t0, 1				# add 1 to state
		li $t3, 64					# $t3 = 64, min for letters
		bgt $t2, $t3, check_length_64			# $t2 > 64, check_length_64
		li $t3, 48					# $t3 = 48, min for numbers
		bgt $t2, $t3, check_length_48			# $t2 > 48, check_length_48
		j get_length_loop				# jump to top of loop
		
		check_length_48:
			li $t3, 57					# $t3 = 57, max for numbers
			bgt $t2, $t3, get_length_loop			# $t2 > 57, jump to top of loop
			addi $t1, $t1, 1				# add 1 to length
			j get_length_loop				# jump to top of loop
		check_length_64:
			li $t3, 90					# $t3 = 90, max for letters
			bgt $t2, $t3, get_length_loop			# $t2 > 90, jump to top of loop
			addi $t1, $t1, 1				# add 1 to length
			j get_length_loop				# jump to top of loop	
	end_get_length_loop:
	sb $t1, 4($s0)							# store length in 5th position			
			
	lw $s0, 0($sp)						# load $s0 from stack
	lw $s1, 4($sp)						# load $s1 from stack
	lw $s2, 8($sp)						# load $s2 from stack
	lw $s4, 12($sp)						# load $s4 from stack
	lw $s5, 16($sp)						# load $s5 from stack
	addi $sp, $sp, 20					# deallocate 20 bytes
	
	li $v0, 16						# get ready to close file
	move $a0, $s2						# $a0 = descriptor
	syscall							# close file
	
	load_game_end:
    	jr $ra							# return to main address
    	
    	load_neg_1:
    		li $t0, -1					# $t0 = -1
    		move $v1, $t0					# $v1 = -1
    		j load_game_end					# jump to load_game_end
get_slot:
	addi $sp, $sp, -12					# allocate 12 bytes of space
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	move $s0, $a0						# $s0 = state (rows, columns, head row, head column, length, string)
	move $s1, $a1						# $s1 = row given
	move $s2, $a2						# $s2 = column given
	
	lb $t0, 0($s0)						# $t1 = first byte from state (row)
	bgt $s1, $t0, get_slot_neg_1				# row given > num rows, get_slot_neg_1
	lb $t0, 1($s0)						# $t1 = second byte from state (col)
	bgt $s2, $t0, get_slot_neg_1				# col given > col rows, get_slot_neg_1
	li $t0, 0						# $t1 = 0
	blt $s1, $t0, get_slot_neg_1				# row given < 1, get_slot_neg_1	
	blt $s2, $t0, get_slot_neg_1				# col given < 1, get_slot_neg_1				
	
	move $t0, $s0						# $t0 = state
	lb $t1, 1($t0)						# $t1 = total number of columns
	mul $t1, $t1, $s1					# $t1 = total number of columns * row given
	add $t1, $t1, $s2					# $t1 = (total number of columns * row given) + column given\
	add $t0, $t0, $t1					# $t0 = base address + $t1
	addi $t0, $t0, 5					# add 5 to base address since first five bytes were information
	lb $t2, 0($t0)						# $t2 = current byte
	move $v0, $t2						# $v0 = $t2																				
	
	get_slot_end:
	lw $s0, 0($sp)						# load $s0 from stack
	lw $s1, 4($sp)						# load $s1 from stack
	lw $s2, 8($sp)						# load $s2 from stack
	addi $sp, $sp, 12					# deallocate 20 bytes
	
    	jr $ra							# return to main address

	get_slot_neg_1:
		li $t0, -1					# $t0 = -1
    		move $v0, $t0					# $v0 = -1
    		j get_slot_end					# jump to load_game_end
set_slot:
	addi $sp, $sp, -16					# allocate 16 bytes of space
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	move $s0, $a0						# $s0 = state (rows, columns, head row, head column, length, string)
	move $s1, $a1						# $s1 = row given
	move $s2, $a2						# $s2 = column given
	move $s3, $a3						# $s3 = character
	
	lb $t0, 0($s0)						# $t1 = first byte from state (row)
	bge $s1, $t0, set_slot_neg_1				# row given > num rows, get_slot_neg_1
	lb $t0, 1($s0)						# $t1 = second byte from state (col)
	bge $s2, $t0, set_slot_neg_1				# col given > col rows, get_slot_neg_1
	li $t0, 0						# $t1 = 0
	blt $s1, $t0, set_slot_neg_1				# row given < 1, get_slot_neg_1	
	blt $s2, $t0, set_slot_neg_1				# col given < 1, get_slot_neg_1					
	
	move $t0, $s0						# $t0 = state
	lb $t1, 1($t0)						# $t1 = total number of columns
	mul $t1, $t1, $s1					# $t1 = total number of columns * row given
	add $t1, $t1, $s2					# $t1 = (total number of columns * row given) + column given
	add $t0, $t0, $t1					# $t0 = base address + $t1
	addi $t0, $t0, 5					# add 5 to base address since first five bytes were information
	sb $s3, 0($t0)						# store character in set spot
	move $v0, $s3						# $v0 = $t2	
	
	set_slot_end:
	lw $s0, 0($sp)						# load $s0 from stack
	lw $s1, 4($sp)						# load $s1 from stack
	lw $s2, 8($sp)						# load $s2 from stack
	lw $s3, 12($sp)						# load $s3 from stack
	addi $sp, $sp, 16					# deallocate 20 bytes
	
   
    	jr $ra							# return to main address

	set_slot_neg_1:
		li $t0, -1					# $t0 = -1
    		move $v0, $t0					# $v0 = -1
    		j set_slot_end					# jump to load_game_end

place_next_apple:
	addi $sp, $sp, -28					# allocate 28 bytes of space
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	sw $s4, 16($sp)						# store $s4
	sw $s5, 20($sp)						# store $s5
	sw $ra, 24($sp)						# store $ra
	move $s0, $a0						# $s0 = state
	move $s1, $a1						# $s1 = apples array
	move $s2, $a2						# $s2 = apples array length
	
	move $s5, $s1						# $s5 = state
	place_next_apple_loop:
		lb $s3, 0($s5)					# current row
		lb $s4, 1($s5)					# current column
		move $a0, $s0					# $a0 = state
		move $a1, $s3					# $a1 = current row
		move $a2, $s4					# $a2 = current column
		jal get_slot					# jump and link get_slot
		
		move $t3, $v0					# $t3 = current character from get_slot
		li $t4, '.'					# $t4 = '.'
		beq $t3, $t4, end_place_next_apple_loop		# current character = '.', end loop
		
		addi $s5, $s5, 2				# add 2 to apple array  
		j place_next_apple_loop				# jump to top of loop
	end_place_next_apple_loop:
	li $t0, -1						# $t0 = -1
	sb $t0, 0($s5)						# store -1 in current row
	sb $t0, 1($s5)						# store -1 in current column
	move $a0, $s0						# $a0 = state
	move $a1, $s3						# $a1 = current row
	move $a2, $s4						# $a2 = current column
	li $t3 'a'						# $t3 = 'a'
	move $a3, $t3						# $a3 = 'a'
	jal set_slot						# jump and link set_slot
	
	move $v0, $s3						# $v0 = current row
	move $v1, $s4						# $v1 = current column	
	
	lw $s0, 0($sp)						# loads $s0
	lw $s1, 4($sp)						# loads $s1
	lw $s2, 8($sp)						# loads $s2
	lw $s3, 12($sp)						# loads $s3
	lw $s4, 16($sp)						# loads $s4
	lw $s5, 20($sp)						# store $s5
	lw $ra, 24($sp)						# loads $ra
	addi $sp, $sp, 28					# deallocates 28 bytes of space
	
    	jr $ra							# return to main address

find_next_body_part:
	addi $sp, $sp, -28					# allocate 28 bytes of space
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	sw $s4, 16($sp)						# store $s4
	sw $s5, 20($sp)						# store $s5
	sw $ra, 24($sp)						# store $ra
	move $s0, $a0						# $s0 = state
	move $s1, $a1						# $s1 = current row	
	move $s2, $a2						# $s2 = current column
	move $s3, $a3						# $s3 = target part
	
	# Check up
	check_up_body:
		move $s4, $s1					# $s4 = current row
		addi $s4, $s4, -1				# $s4 subtracts 1 to get row above
		move $s5, $s2					# $s5 = current column
		move $a0, $s0					# $a0 = state
		move $a1, $s4					# $a1 = current row
		move $a2, $s5					# $a2 = current column
		jal get_slot					# jump and link get_slot
		beq $s3, $v0, find_next_body_finish		# $v0 = target part, skip other parts
		
	# Check down
	check_down_body:
		move $s4, $s1					# $s4 = current row
		addi $s4, $s4, 1				# $s4 subtracts 1 to get row below
		move $s5, $s2					# $s5 = current column
		move $a0, $s0					# $a0 = state
		move $a1, $s4					# $a1 = current row
		move $a2, $s5					# $a2 = current column
		jal get_slot					# jump and link get_slot
		beq $s3, $v0, find_next_body_finish		# $v0 = target part, skip other parts
		
	# Check left
	check_left_body:
		move $s4, $s1					# $s4 = current row
		move $s5, $s2					# $s5 = current column
		addi $s5, $s5, -1				# $s5 subtracts 1 to get column to the left
		move $a0, $s0					# $a0 = state
		move $a1, $s4					# $a1 = current row
		move $a2, $s5					# $a2 = current column
		jal get_slot					# jump and link get_slot
		beq $s3, $v0, find_next_body_finish		# $v0 = target part, skip other parts
		
	# Check right
	check_right_body:
		move $s4, $s1					# $s5 = current row
		move $s5, $s2					# $s5 = current column
		addi $s5, $s5, 1				# $s5 adds 1 to get column to the right
		move $a0, $s0					# $a0 = state
		move $a1, $s4					# $a1 = current row
		move $a2, $s5					# $a2 = current column
		jal get_slot					# jump and link get_slot
		beq $s3, $v0, find_next_body_finish		# $v0 = target part, skip other parts
		
	# $v0 = -1, $v1 = -1
	find_next_body_neg_1:
		li $t0, -1					# $t0 = -1
		move $v0, $t0					# $v0 = -1
		move $v1, $t0					# $v1 = -1
		j find_next_body_load				# skip next step
		
	# ends check	
	find_next_body_finish:
		move $v0, $s4					# $v0 = target row
		move $v1, $s5					# $v1 = target column
	
	find_next_body_load:
	lw $s0, 0($sp)						# loads $s0
	lw $s1, 4($sp)						# loads $s1
	lw $s2, 8($sp)						# loads $s2
	lw $s3, 12($sp)						# loads $s3
	lw $s4, 16($sp)						# store $s4
	lw $s5, 20($sp)						# store $s5
	lw $ra, 24($sp)						# store $ra
	addi $sp, $sp, 28					# deallocates 28 bytes
	
    	jr $ra							# return to main address

slide_body:
	addi $sp, $sp, -36					# allocate 36 bytes of space
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	sw $s4, 16($sp)						# store $s4
	sw $s5, 20($sp)						# store $s5
	sw $s6, 24($sp)						# store $s6
	sw $s7, 28($sp)						# store $s7
	sw $ra, 32($sp)						# store $ra
	move $s0, $a0						# $s0 = state
	move $s1, $a1						# $s1 = head row delta
	move $s2, $a2						# $s2 = head column delta
	move $s3, $a3						# $s3 = apples array	
	
	lb $s4, 2($s0)						# $s4 = head row
	lb $s5, 3($s0)						# $s5 = head column
	add $s4, $s4, $s1					# $t4 = new head row
	add $s5, $s5, $s2					# $t5 = new head column
	
	li $t0, 0						# $t0 = 0
	blt $s4, $t0, v0_neg_1_load_3				# $s4 < 0, v0_neg_1_load_3
	blt $s5, $t0, v0_neg_1_load_3				# $s5 < 0, v0_neg_1_load_3
	lb $t0, 0($s0)						# $t0 = number of rows
	lb $t1, 1($s0)						# $t1 = number of columns
	bge $s4, $t0, v0_neg_1_load_3				# $s4 >= number of rows, v0_neg_1_load_3
	bge $s5, $t1, v0_neg_1_load_3				# $s5 >= number of columns, v0_neg_1_load_3
	
	li $t0, 0						# $t0 = 0
	move $t1, $s3						# $t1 = apples array
	slide_apples_length_loop:
		lb $t2, 0($t1)					# $t2 = current character
		beq $t2, $0, end_slide_apples_length_loop	# $t2 = $0, end loop
		addi $t0, $t0, 1				# add 1 to counter
		addi $t1, $t1, 1				# add 1 to apples array
		j slide_apples_length_loop			# jump to top of loop
	end_slide_apples_length_loop:
	li $t1, 2						# $t1 = 2
	div $t0, $t1						# $t0 / 2
	mflo $s6						# $s6 = quotient
	
	
	#move $t1, $s3
	#loop1:
	#	lb $t2, 0($t1)
	#	beq $t2, $0, end_loop1
	#	li $v0, 1
	#	move $a0, $t2
	#	syscall
	#	addi $t1, $t1, 1
	#	j loop1
	#end_loop1:
	
	
	
	
	# Moves snake 
	move $a0, $s0						# $a0 = state
	move $a1, $s4						# $a1 = new head row
	move $a2, $s5						# $a2 = new head column
	jal get_slot						# jump and link get_slot
	
	li $s1, 0
	addi $sp, $sp, -4					# allocate 4 bytes of space
	sw $s1, 0($sp)						# store $s1
	li $t4 'a'						# $t6 = 'a'
	beq $v0, $t4, slide_is_apple				# $v0 = 'a', slide_v0_1
	li $t4, -1						# $t6 = -1
	beq $v0, $t4, slide_body_invalid			# $v0 = -1, slide_end
	li, $t4, '.'						# $t4 = '.'
	beq $v0, $t4, slide_snake_setup				# $v0 = '.', slide_snake_setup
	j v0_neg_1_load_2					# jump to slide_snake_load_2
	
	slide_is_apple:
		lw $s1, 0($sp)					# loads $s1
		addi $sp, $sp, 4				# allocate 4 bytes of space
		
		li $s1, 1					# $s1 = 1
		addi $sp, $sp, -4				# allocate 4 bytes of space
		sw $s1, 0($sp)					# store $s1
						
		move $a0, $s0					# $a0 = state
		move $a1, $s3					# $a1 = apples array
		move $a2, $s6					# $a2 = apples length
		jal place_next_apple				# jump and link place_next_apple	
	
	slide_snake_setup:
		li $t2, '1'
		move $a0, $s0					# $a0 = state
		move $a1, $s4					# $a1 = new head row
		move $a2, $s5					# $a2 = new head column
		move $a3, $t2					# $a3 = character
		jal set_slot					# jump and link set_slot
		
		addi $sp, $sp, -12				# allocate 8 bytes of space
		sw $s1, 0($sp)					# store $s1
		sw $s2, 4($sp)					# store $s2
		sw $s3, 8($sp)					# store $s3
		li $s1, '2'					# $s1 = '2', target character
		lb $s2, 2($s0)					# $s2 = old head row
		lb $s3, 3($s0)					# $s3 = old head column
		sb $s4, 2($s0)					# store new head row
		sb $s5, 3($s0)					# store new head column
		li $s4, 1					# $s4 = counter
		lb $s5, 4($s0)					# $s5 = length
	
	slide_snake_loop:
		beq $s4, $s5, end_slide_snake_loop		# $t0 = snake length, end loop
		move $a0, $s0					# $a0 = state
		move $a1, $s2					# $a1 = current row
		move $a2, $s3					# $a2 = current column
		move $a3, $s1					# $a3 = target
		jal find_next_body_part				# jump and link find_next_body_part
		move $s6, $v0					# $s6 = next body row					
		move $s7, $v1					# $s7 = next body column
		
		move $a0, $s0					# $a0 = state
		move $a1, $s2					# $a1 = new row
		move $a2, $s3					# $a2 = new column
		move $a3, $s1					# $a3 = character
		jal set_slot					# jump and link get_slot
		
		move $s2, $s6					# $s2 = new body row
		move $s3, $s7					# $s3 = new body column
		
		li $t0, '9'					# $t0 = '9'
		beq $s1, $t0, slide_add_8			# $s1 = '9', slide_add_8
		addi $s1, $s1, 1				# add 1 to current character
		addi $s4, $s4, 1				# add 1 to counter
		
		j slide_snake_loop				# jump to top of loop
		
		slide_add_8:
			addi $s1, $s1, 8			# add 1 to current character
			addi $s4, $s4, 1			# add 1 to counter
			j slide_snake_loop			# jump to top of loop
	end_slide_snake_loop:
	li $s1 '.'
	move $a0, $s0						# $a0 = state
	move $a1, $s2						# $a1 = new row
	move $a2, $s3						# $a2 = new column
	move $a3, $s1						# $a3 = character
	jal set_slot						# jump and link get_slot
	
	li $t0, 1						# $t0 = 1
	beq $v1, $t0, slide_body_set_v0				# $v1 = 1, slide_body_set_v0
	
	j slide_body_load_1					# jump to slide_body_load
	
	v0_neg_1_load_2:
		li $v0, -1					# $v0 = -1
		j slide_body_invalid				# jump to slide_body_load_2
		
	v0_neg_1_load_3:
		li $v0, -1					# $v0 = -1
		j slide_body_load_3				# jump to slide_body_load_3
	
	
	slide_body_invalid:
		li $v0, -1					# $v0 = -1
		lw $s1, 0($sp)					# loads $s1
		addi $sp, $sp, 4				# allocate 4 bytes of space
		j slide_body_load_3				# jumps to slide_body_load_3
	
	
	slide_body_set_v0:
		move $v0, $t0					# $v0 = 1
		move $v1, $0					# $v1 = 0
	
	slide_body_load_1:
	lw $s1, 0($sp)						# loads $s1
	lw $s2, 4($sp)						# loads $s2
	lw $s3, 8($sp)						# store $s3
	addi $sp, $sp, 12					# deallocates 8 bytes of space
	
	#move $t1, $s3
	#loop2:
	#	lb $t2, 0($t1)
	#	beq $t2, $0, end_loop2
	#	li $v0, 1
	#	move $a0, $t2
	#	syscall
	#	addi $t1, $t1, 1
	#	j loop2
	#end_loop2:
	
	
	slide_body_load_2:
	lw $s1, 0($sp)						# loads $s1
	addi $sp, $sp, 4					# allocate 4 bytes of space
	move $v0, $s1						# $v0 = $s1	
	
	slide_body_load_3:
	lw $s0, 0($sp)						# loads $s0
	lw $s1, 4($sp)						# loads $s1
	lw $s2, 8($sp)						# loads $s2
	lw $s3, 12($sp)						# loads $s3
	lw $s4, 16($sp)						# loads $s4
	lw $s5, 20($sp)						# loads $s5
	lw $s6, 24($sp)						# loads $s6
	lw $s7, 28($sp)						# loads $s7
	lw $ra, 32($sp)						# loads #ra
	addi $sp, $sp, 36					# deallocates 36 bytes of space
	
	slide_end:
    	jr $ra							# return to main address

add_tail_segment:
	addi $sp, $sp, -20					# allocates 20 bytes of space
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	sw $ra, 16($sp)						# store $ra
	move $s0, $a0						# $s0 = state
	move $s1, $a1						# $s1 = direction
	move $s2, $a2						# $s2 = tail row
	move $s3, $a3						# $s3 = tail column
	
	lb $t0, 4($s0)						# $t0 = length
	li $t1, 35						# $t1 = 35
	beq $t0, $t1, add_tail_v0_neg_1				# $t0 = 35, add_tail_v0_neg_1
		
	li $t0, 'U'						# $t0 = 'U'
	beq $s1, $t0, add_tail_up				# $s1 = 'U', add_tail_up
	li $t0, 'D'						# $t0 = 'D'
	beq $s1, $t0, add_tail_down				# $s1 = 'D', add_tail_down				
	li $t0, 'L'						# $t0 = 'L'
	beq $s1, $t0, add_tail_left				# $s1 = 'L', add_tail_left
	li $t0, 'R'						# $t0 = 'R'	
	beq $s1, $t0, add_tail_right				# $s1 = 'R', add_tail_right
	j add_tail_v0_neg_1					# jump to add_tail_v0_neg_1
	
	add_tail_up:
		addi $s2, $s2, -1				# adds -1 to row 
		addi $s3, $s3, 0				# adds 0 to column
	
		li $t0, 0					# $t0 = 0
		blt $s2, $t0, add_tail_v0_neg_1			# $s2 < 0, add_tail_v0_neg_1
		blt $s3, $t0, add_tail_v0_neg_1			# $s3 < 0, add_tail_v0_neg_1
		lb $t0, 0($s0)					# $t0 = number of rows
		lb $t1, 1($s0)					# $t1 = number of columns
		bge $s2, $t0, add_tail_v0_neg_1			# $s2 >= number of rows, add_tail_v0_neg_1
		bge $s3, $t1, add_tail_v0_neg_1			# $s3 >= number of columns, add_tail_v0_neg_1

		
		move $a0, $s0					# $a0 = state
		move $a1, $s2					# $a1 = new row
		move $a2, $s3					# $a2 = same column
		jal get_slot					# jump and link get_slot
		
		li $t0, '.'					# $t0 = '.'
		bne $v0, $t0, add_tail_v0_neg_1			# $v0 = '.', add_tail_v0_neg_1
		
		j add_tail_end_setup				# jump to add_tail_end_setup
		
	add_tail_down:
		addi $s2, $s2, 1				# adds 1 to row 
		addi $s3, $s3, 0				# adds 0 to column
		
		li $t0, 0					# $t0 = 0
		blt $s2, $t0, add_tail_v0_neg_1			# $s2 < 0, add_tail_v0_neg_1
		blt $s3, $t0, add_tail_v0_neg_1			# $s3 < 0, add_tail_v0_neg_1
		lb $t0, 0($s0)					# $t0 = number of rows
		lb $t1, 1($s0)					# $t1 = number of columns
		bge $s2, $t0, add_tail_v0_neg_1			# $s2 >= number of rows, add_tail_v0_neg_1
		bge $s3, $t1, add_tail_v0_neg_1			# $s3 >= number of columns, add_tail_v0_neg_1

		
		move $a0, $s0					# $a0 = state
		move $a1, $s2					# $a1 = new row
		move $a2, $s3					# $a2 = same column
		jal get_slot
		
		li $t0, '.'					# $t0 = '.'
		bne $v0, $t0, add_tail_v0_neg_1			# $v0 = '.', add_tail_v0_neg_1
		
		j add_tail_end_setup				# jump to add_tail_end_setup
	
	add_tail_left:
		addi $s2, $s2, 0				# adds 0 to row 
		addi $s3, $s3, -1				# adds -1 to column 
		
		li $t0, 0					# $t0 = 0
		blt $s2, $t0, add_tail_v0_neg_1			# $s2 < 0, add_tail_v0_neg_1
		blt $s3, $t0, add_tail_v0_neg_1			# $s3 < 0, add_tail_v0_neg_1
		lb $t0, 0($s0)					# $t0 = number of rows
		lb $t1, 1($s0)					# $t1 = number of columns
		bge $s2, $t0, add_tail_v0_neg_1			# $s2 >= number of rows, add_tail_v0_neg_1
		bge $s3, $t1, add_tail_v0_neg_1			# $s3 >= number of columns, add_tail_v0_neg_1

		
		move $a0, $s0					# $a0 = state
		move $a1, $s2					# $a1 = same row
		move $a2, $s3					# $a2 = new column
		jal get_slot					# jump and link get_slot
		
		li $t0, '.'					# $t0 = '.'
		bne $v0, $t0, add_tail_v0_neg_1			# $v0 = '.', add_tail_v0_neg_1
		
		j add_tail_end_setup				# jump to add_tail_end_setup
	
	add_tail_right:
		addi $s2, $s2, 0				# adds 0 to row 
		addi $s3, $s3, 1				# adds 1 to column 
		
		li $t0, 0					# $t0 = 0
		blt $s2, $t0, add_tail_v0_neg_1			# $s2 < 0, add_tail_v0_neg_1
		blt $s3, $t0, add_tail_v0_neg_1			# $s3 < 0, add_tail_v0_neg_1
		lb $t0, 0($s0)					# $t0 = number of rows
		lb $t1, 1($s0)					# $t1 = number of columns
		bge $s2, $t0, add_tail_v0_neg_1			# $s2 >= number of rows, add_tail_v0_neg_1
		bge $s3, $t1, add_tail_v0_neg_1			# $s3 >= number of columns, add_tail_v0_neg_1

		
		move $a0, $s0					# $a0 = state
		move $a1, $s2					# $a1 = same row
		move $a2, $s3					# $a2 = new column
		jal get_slot					# jump and link get_slot
		
		li $t0, '.'					# $t0 = '.'
		bne $v0, $t0, add_tail_v0_neg_1			# $v0 = '.', add_tail_v0_neg_1
		
		j add_tail_end_setup				# jump to add_tail_end_setup
		
	add_tail_end_setup:
		lb $t1, 4($s0)					# $t0 = length
		addi $t1, $t1, 1				# add 1 to length
		sb $t1, 4($s0)					# $t1 = length
		li $t2, 10					# $t2 = 10
		bge $t1, $t2, add_55				# $t1 = 10, add_55
		addi $t1, $t1, 48				# add 48 to $t1
		j add_tail_end					# jump to add_tail_end
		
		add_55:
			addi $t1, $t1, 55			# add 55 to $t1
		
		add_tail_end:
		move $a0, $s0					# $a0 = state
		move $a1, $s2					# $a1 = new row
		move $a2, $s3					# $a2 = new column
		move $a3, $t1					# $a3 = new length
		jal set_slot					# jump and link set_slot
		lb $t0, 4($s0)					# $t0 = length
		move $v0, $t0					# $v0 = length
		j add_tail_load					# jump to add_tail_load
	
	add_tail_v0_neg_1:
		li $v0, -1					# $v0 = -1
	
	add_tail_load:
	lw $s0, 0($sp)						# loads $s0
	lw $s1, 4($sp)						# loads $s1
	lw $s2, 8($sp)						# loads $s2
	lw $s3, 12($sp)						# loads $s3
	lw $ra, 16($sp)						# loads $ra
	addi $sp, $sp, 20					# allocates 20 bytes of space
	
    	jr $ra							# returns to main address

increase_snake_length:
	addi $sp, $sp, -32					# allocates 32 bytes of space
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	sw $s4, 16($sp)						# store $s4
	sw $s5, 20($sp)						# store $s5
	sw $s6, 24($sp)						# store $s6
	sw $ra, 28($sp)						# store $ra
	move $s0, $a0						# $s0 = state
	move $s1, $a1						# $s1 = direction

	# Get the row and column of tail, store in $a2, $s3
	li $s2, 2						# $t0 = 2, counter 
	lb $s3, 4($s0)						# length of snake
	lb $t0, 2($s0)						# $t0 = head row
	lb $t1, 3($s0)						# $t1 = head column
	increase_snake_tail_loop:
		bgt $s2, $s3, end_increase_snake_tail_loop	# $t0 = length, end loop
		li $t2, 10					# $t2 = 10
		bge $s2, $t2, increase_snake_add_55		# $s2 >= 10, add 55
		addi $t3, $s2, 48				# else, add 48
		increase_snake_tail_find:
			move $a0, $s0				# $a0 = state
			move $a1, $t0				# $a1 = row
			move $a2, $t1				# $a2 = column
			move $a3, $t3				# $a3 = target
			jal find_next_body_part			# jump and link find_next_body_part
			move $t0, $v0				# $t0 = new row
			move $t1, $v1				# $t1 = new column
			addi $s2, $s2, 1			# add 1 to counter
			j increase_snake_tail_loop		# jump to top of loop
		increase_snake_add_55:
			addi $t3, $s2, 55			# add 55 to counter to get character
			j increase_snake_tail_find		# jump to middle of loop
	end_increase_snake_tail_loop:
	move $s4, $t0						# $s4 = tail row
	move $s5, $t1						# $s5 = tail column
	
	li $s6, 0						# $s6 = 0, counter
	li $t1, 'U'						# $t1 = 'U'
	beq $s1, $t1, snake_tail_down				# $s1 = 'U', snake_tail_down
	li $t1, 'D'						# $t1 = 'D'
	beq $s1, $t1, snake_tail_up				# $s1 = 'D', snake_tail_up
	li $t1, 'L'						# $t1 = 'L'
	beq $s1, $t1, snake_tail_right				# $s1 = 'L', snake_tail_right
	li $t1, 'R'						# $t1 = 'R'
	beq $s1, $t1, snake_tail_left				# $s1 = 'R', snake_tail_left
	j increase_snake_v0_neg_1				# jump to increase_snake_v0_neg_1
	
	snake_tail_up:
		li $t1, 4					# $t1 = 4, counter max
		beq $s6, $t1, increase_snake_v0_neg_1		# $s6 = 4, end loop	
		addi $s6, $s6, 1				# add 1 to counter
		li $t2, 'U'					# $t2 = 'U', direction needed
		move $a0, $s0					# $a0 = state
		move $a1, $t2					# $a1 = direction
		move $a2, $s4					# $a2 = tail row
		move $a3, $s5					# $a3 = tail column
		jal add_tail_segment				# jump and link add_tail_segment
		li $t3, -1					# $t3 = -1
		beq $v0, $t3, snake_tail_left			# $v0 = -1, snake_tail_left
		j increase_snake_end_setup			# jump to increase_snake_end_setup
				
	snake_tail_left:
		li $t1, 4					# $t1 = 4, counter max
		beq $s6, $t1, increase_snake_v0_neg_1		# $s6 = 4, end loop	
		addi $s6, $s6, 1				# add 1 to counter
		li $t2, 'L'					# $t2 = 'L', direction needed
		move $a0, $s0					# $a0 = state
		move $a1, $t2					# $a1 = direction
		move $a2, $s4					# $a2 = tail row
		move $a3, $s5					# $a3 = tail column
		jal add_tail_segment				# jump and link add_tail_segment
		li $t3, -1					# $t3 = -1
		beq $v0, $t3, snake_tail_down			# $v0 = -1, snake_tail_down
		j increase_snake_end_setup			# jump to increase_snake_end_setup
		
	snake_tail_down:
		li $t1, 4					# $t1 = 4, counter max
		beq $s6, $t1, increase_snake_v0_neg_1		# $s6 = 4, end loop	
		addi $s6, $s6, 1				# add 1 to counter
		li $t2, 'D'					# $t2 = 'D', direction needed
		move $a0, $s0					# $a0 = state
		move $a1, $t2					# $a1 = direction
		move $a2, $s4					# $a2 = tail row
		move $a3, $s5					# $a3 = tail column
		jal add_tail_segment				# jump and link add_tail_segment
		li $t3, -1					# $t3 = -1
		beq $v0, $t3, snake_tail_right			# $v0 = -1, snake_tail_right
		j increase_snake_end_setup			# jump to increase_snake_end_setup
		
	snake_tail_right:
		li $t1, 4					# $t1 = 4, counter max
		beq $s6, $t1, increase_snake_v0_neg_1		# $s6 = 4, end loop	
		addi $s6, $s6, 1				# add 1 to counter
		li $t2, 'R'					# $t2 = 'R', direction needed
		move $a0, $s0					# $a0 = state
		move $a1, $t2					# $a1 = direction
		move $a2, $s4					# $a2 = tail row
		move $a3, $s5					# $a3 = tail column
		jal add_tail_segment				# jump and link add_tail_segment
		li $t3, -1					# $t3 = -1
		beq $v0, $t3, snake_tail_up			# $v0 = -1, snake_tail_up
		j increase_snake_end_setup			# jump to increase_snake_end_setup
		
	increase_snake_v0_neg_1:
		li $v0, -1					# $v0 = -1
		j increase_snake_load				# jump to increase_snake_load
	
	increase_snake_end_setup:
		lb $t0, 4($s0)					# $t0 = length
		move $v0, $t0					# $v0 = length
		li $v1, 0					# $v1 = 0
	
	increase_snake_load:
	lw $s0, 0($sp)						# loads $s0
	lw $s1, 4($sp)						# loads $s1
	lw $s2, 8($sp)						# loads $s2
	lw $s3, 12($sp)						# loads $s3
	lw $s4, 16($sp)						# loads $s4
	lw $s5, 20($sp)						# loads $s5
	lw $s6, 24($sp)						# loads $s6
	lw $ra, 28($sp)						# loads $ra
	addi $sp, $sp, 32					# deallocates 32 bytes of space
	
    	jr $ra							# returns to main address

move_snake:
	addi $sp, $sp, -20					# allocates 20 bytes
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	sw $ra, 16($sp)						# store $ra
	move $s0, $a0						# $s0 = state
	move $s1, $a1						# $s1 = direction
	move $s2, $a2						# $s2 = apples array
	move $s3, $a3						# $s3 = apples length
	
	li $t0, 'U'						# $t0 = 'U'
	beq $s1, $t0, move_snake_up				# $s1 = 'U', move_snake_up
	li $t0, 'D'						# $t0 = 'D'
	beq $s1, $t0, move_snake_down				# $s1 = 'D', move_snake_down
	li $t0, 'L'						# $t0 = 'L'
	beq $s1, $t0, move_snake_left				# $s1 = 'L', move_snake_left
	li $t0, 'R'						# $t0 = 'R'
	beq $s1, $t0, move_snake_right				# $s1 = 'R', move_snake_right
	j move_snake_invalid					# jump to move_snake_invalid
	
	# Checks where snake moved
	move_snake_up:
		li $t0, -1					# $t0 = -1
		li $t1, 0					# $t1 = 0
		move $a0, $s0					# $a0 = state
		move $a1, $t0					# $a1 = head row delta
		move $a2, $t1					# $a2 = head column delta
		move $a3, $s2					# $a3 = apples array
		jal slide_body					# jump and link slide_body
		li $t0, -1					# $t0 = -1
		beq $v0, $t0, move_snake_invalid		# $v0 = -1, move_snake_invalid
		li $t0, 0					# $t0 = 0
		beq $v0, $t0, move_snake_no_points		# $v0 = 0, move_snake_no_points
		li $t0 'U'					# $t0 = 'U'
		j move_snake_100_points				# jump to move_snake_100_points
		
	move_snake_down:
		li $t0, 1					# $t0 = 1
		li $t1, 0					# $t1 = 0
		move $a0, $s0					# $a0 = state
		move $a1, $t0					# $a1 = head row delta
		move $a2, $t1					# $a2 = head column delta
		move $a3, $s2					# $a3 = apples array
		jal slide_body					# jump and link slide_body
		li $t0, -1					# $t0 = -1
		beq $v0, $t0, move_snake_invalid		# $v0 = -1, move_snake_invalid
		li $t0, 0					# $t0 = 0
		beq $v0, $t0, move_snake_no_points		# $v0 = 0, move_snake_no_points
		li $t0 'D'					# $t0 = 'D'
		j move_snake_100_points				# jump to move_snake_100_points
	
	move_snake_left:
		li $t0, 0					# $t0 = 0
		li $t1, -1					# $t1 = -1
		move $a0, $s0					# $a0 = state
		move $a1, $t0					# $a1 = head row delta
		move $a2, $t1					# $a2 = head column delta
		move $a3, $s2					# $a3 = apples array
		jal slide_body					# jump and link slide_body
		li $t0, -1					# $t0 = -1
		beq $v0, $t0, move_snake_invalid		# $v0 = -1, move_snake_invalid
		li $t0, 0					# $t0 = 0
		beq $v0, $t0, move_snake_no_points		# $v0 = 0, move_snake_no_points
		li $t0 'L'					# $t0 = 'L'
		j move_snake_100_points				# jump to move_snake_100_points
	
	move_snake_right:
		li $t0, 0					# $t0 = 0
		li $t1, 1					# $t1 = 1
		move $a0, $s0					# $a0 = state
		move $a1, $t0					# $a1 = head row delta
		move $a2, $t1					# $a2 = head column delta
		move $a3, $s2					# $a3 = apples array
		jal slide_body					# jump and link slide_body
		li $t0, -1					# $t0 = -1
		beq $v0, $t0, move_snake_invalid		# $v0 = -1, move_snake_invalid
		li $t0, 0					# $t0 = 0
		beq $v0, $t0, move_snake_no_points		# $v0 = 0, move_snake_no_points
		li $t0 'R'					# $t0 = 'R'
		j move_snake_100_points				# jump to move_snake_100_points
		
	# Invalid direction, or snake did not move
	move_snake_invalid:
		li $v0, 0					# $v0 = 0
		li $v1, -1					# $v1 = -1
		j move_snake_load				# jump to move_snake_load
	
	move_snake_no_points:
		li $v1, 1					# $v1 = 1
		j move_snake_load				# jump to move_snake_load
	
	move_snake_100_points:
		li $t1, 1					# $t0 = 1
		beq $v0, $t1, move_snake_increase_length	# $v0 = 1, move_snake_increase_length
		j move_snake_load				# jump to move_snake_load
		
		move_snake_increase_length:
			move $a0, $s0				# $a0 = state
			move $a1, $t0				# $a1 = direction
			jal increase_snake_length		# jump and link increase_snake_length
			li $t0, -1				# $t0 = -1
			beq $v0, $t0, move_snake_invalid	# $v0 = -1, move_snake_invalid
			li $v0, 100				# $v0 = 100	
			li $v1, 1				# $v1 = 1
	
	move_snake_load:	
	lw $s0, 0($sp)						# loads $s0
	lw $s1, 4($sp)						# loads $s1
	lw $s2, 8($sp)						# loads $s2
	lw $s3, 12($sp)						# loads $s3
	lw $ra, 16($sp)						# loads $ra
	addi $sp, $sp, 20					# deallocates 20 bytes
	
    	jr $ra							# return to main address

simulate_game:
	lw $t0, 0($sp)						# $t0 = apples array
	lw $t1, 4($sp)						# $t1 = apples array length
	
	addi $sp, $sp, -36					# deallocates 32 bytes
	sw $s0, 0($sp)						# store $s0
	sw $s1, 4($sp)						# store $s1
	sw $s2, 8($sp)						# store $s2
	sw $s3, 12($sp)						# store $s3
	sw $s4, 16($sp)						# store $s4
	sw $s5, 20($sp)						# store $s5
	sw $s6, 24($sp)						# store $s6
	sw $s7, 28($sp)						# store $s7
	sw $ra, 32($sp)						# store $ra
	move $s0, $a0						# $s0 = state
	move $s1, $a1						# $s1 = filename
	move $s2, $a2						# $s2 = directions array
	move $s3, $a3						# $s3 = number of moves to execute
	move $s4, $t0						# $s4 = apples array
	move $s5, $t1						# $s5 = apples array length
	
	move $a0, $s0						# $a0 = state
	move $a1, $s1						# $a1 = filename
	jal load_game						# jump and link load_game
	li $t0 -1						# $t0 = -1
	beq $v0, $t0, simulate_game_invalid			# $v0 = -1, simulate_game_invalid
	li $t0, 0						# $t0 = 0
	beq $v0, $t0, simulate_place_apple			# $v0 = 0, simulate_place_apple
	j simulate_play_game					# jump to simulate_play_game
	
	simulate_place_apple:
		move $a0, $s0					# $a0 = state
		move $a1, $s4					# $a1 = apples array
		move $a2, $s5					# $a2 = apples array length
		jal place_next_apple				# jump and link place_next_apple
	
	simulate_play_game:
		li $s6, 0					# $s6 = 0, total number of moves
		li $s7, 0					# $s7 = 0, total score
		simulate_game_loop:
			beq $s6, $s3, end_simulate_game_loop	# $s6 = number of moves to execute, end loop
			lb $t0, 4($s0)				# $t0 = snake length
			li $t1, 35				# $t1 = 35
			beq $t0, $t1, end_simulate_game_loop	# $t0 = 35, end loop
			lb $t2, 0($s2)				# $t2 = current element in directions
			beq $t2, $0, end_simulate_game_loop	# $t2 = null terminator, end loop
			addi $s2, $s2, 1			# adds 1 to direction array
			move $a0, $s0				# $a0 = state
			move $a1, $t2				# $a1 = direction
			move $a2, $s4				# $a2 = apples array
			move $a3, $s5				# $a3 = apples array length
			jal move_snake				# jump and link move_snake
			li $t0, -1				# $t0 = -1
			beq $v1, $t0, end_simulate_game_loop	# $v1 = -1, end loop
			addi $s6, $s6, 1			# adds 1 to move counter
			lb $t0, 4($s0)				# $t0 = snake length
			addi $t0, $t0, -1			# subtracts 1 from snake length
			mul $t0, $t0, $v0			# $t0 multiplies by 0 or 100
			add $s7, $s7, $t0			# add 0 or 100 to total score
			j simulate_game_loop			# jump to top of loop
		end_simulate_game_loop:
		
	simulate_game_moves_score:
		move $v0, $s6					# $v0 = total moves
		move $v1, $s7					# $v1 = total score
		j simulate_load					# jump to simulate_load
		
	
	simulate_game_invalid:
		li $v0, -1					# $v0 = -1
		li $v1, -1					# $v1 = -1
	
	simulate_load:
	lw $s0, 0($sp)						# loads $s0
	lw $s1, 4($sp)						# loads $s1
	lw $s2, 8($sp)						# loads $s2
	lw $s3, 12($sp)						# loads $s3
	lw $s4, 16($sp)						# loads $s4
	lw $s5, 20($sp)						# loads $s5
	lw $s6, 24($sp)						# loads $s6
	lw $s7, 28($sp)						# loads $s7
	lw $ra, 32($sp)						# loads $ra
	addi $sp, $sp, 36					# deallocates 36 bytes
	
    	jr $ra							# return to main address

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
