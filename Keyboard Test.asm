.data
	Player1: .asciiz "p1 "
	Player2: .asciiz "p2 "
	up: .asciiz "up "
	down: .asciiz "down "
	newline: .asciiz "\n"
.text

# a test to see if we can hold down
begin:
	jal Print_playerone_dir
	jal Print_playertwo_dir
	# print newline
	la $a0, newline
	li $v0, 4
	syscall 
	
	#ori $t3, $zero, 0x00000005			# load 25 into the counter for a ~50 milisec standby
	ori $t3, $zero, 0x00000010			# load 25 into the counter for a ~50 milisec standby

Standby:
		blez $t3, EndStandby
		# pause for 10 milisec
		li $a0, 10
		li $v0, 32
		syscall
		
		addi $t3, $t3, -1 		# decrement counter
		
		# check to see if a key has been pressed
		lw $t0, 0xFFFF0000		# Retrieve transmitter control ready bit
		blez $t0, Standby		# if nothing was pressed go to standby
		
				
		jal GetDir			# see what was pushed
		sw $zero, 0xFFFF0000		# clear the buttons
		j Standby
EndStandby:		
		j begin



GetDir:
		lw $t0, 0xFFFF0004		# Load input value
		
GetDir_left_up:
		bne, $t0, 97, GetDir_left_down
		beq $s0, 0x02000000, Stop_p1	# if you were going down then stop
		ori $s0, $zero, 0x01000000	# a
		j GetDir_done		

GetDir_left_down:
		bne, $t0, 122, GetDir_right_up
		beq $s0, 0x01000000, Stop_p1 	# if you were going up then stop
		ori $s0, $zero, 0x02000000	# z
		j GetDir_done
		
Stop_p1:
		or $s0, $zero, $zero		# no dir
		j GetDir_done

GetDir_right_up:
		bne, $t0, 107, GetDir_right_down
		beq $s1, 0x02000000, Stop_p2	# if you were going down then stop
		ori $s1, $zero, 0x01000000	# k
		j GetDir_done

GetDir_right_down:
		bne, $t0, 109, GetDir_none
		beq $s1, 0x01000000, Stop_p2 	# if you were going up then stop
		ori $s1, $zero, 0x02000000	# m
		j GetDir_done
		
Stop_p2:
		or $s1, $zero, $zero	# no dir
		j GetDir_done

GetDir_none:
						# Do nothing
GetDir_done:
		jr $ra				# Return


Print_playerone_dir:
	or $t1, $zero, $s0			# move player ones dir to $t1
	
	# print "player 1 "
	la $a0, Player1
	li $v0, 4
	syscall 
	
	j Print_dir
	
Print_playertwo_dir:
	or $t1, $zero, $s1			# move player twos dir to $t1
	
	# print "player 2 "
	la $a0, Player2
	li $v0, 4
	syscall
	
	j Print_dir

Print_dir:
	Check_up:
		bne, $t1, 0x01000000, Check_down
		la $a0, up
		li $v0, 4
		syscall 
		j Check_done

	Check_down:
		bne, $t1, 0x02000000, Check_none
		la $a0, down
		li $v0, 4
		syscall 
		j Check_done
	Check_none:
						# Do nothing
	Check_done:
		or $t1, $zero, $zero		# clear for next print
		jr $ra				# Return	
