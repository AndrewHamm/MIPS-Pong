.data
	colourOne:		.word 0x00ff8000
	colourTwo:		.word 0x00c00080
	ballColour:		.word 0x00ffffff
	backgroundColour:	.word 0x00000000

.text
# s0 stores p1dir, s1 stores p2 dir, s2 is OPEN , s3 stores paddle one's position, s4 stores paddle two's position, 
# s5 stores the balls x position, s6 stores the balls y position, #s7 stores the balls direction
Main:
		li $s0, 0 	# 0x01000000 up; 0x02000000 down; 0 stay
		li $s1, 0	# 0x01000000 up; 0x02000000 down; 0 stay
		#s2 open
		li $s3, 13
		li $s4, 13
		li $s5, 16
		li $s6, 16
		li $s7, 0
	
# Wait and read buttons
Begin_standby:
		ori $t0, $zero, 0x00000005			# load 25 into the counter for a ~50 milisec standby
	
Standby:
		blez $t0, EndStandby
		li $a0, 10	#
		li $v0, 32	# pause for 10 milisec
		syscall		#
		
		addi $t0, $t0, -1 		# decrement counter
		
		lw $t1, 0xFFFF0000		# check to see if a key has been pressed
		blez $t1, Standby
				
		jal AdjustDir			# see what was pushed
		sw $zero, 0xFFFF0000		# clear the button pushed bit
		j Standby
EndStandby:		
		j begin

##########################################################
# AdjustDir  changes the players direction registers depending on the key pressed
AdjustDir: 
		lw $a0, 0xFFFF0004		# Load button pressed
		
GetDir_left_up:
		bne $a0, 97, GetDir_left_down  # a
		beq $s0, 0x02000000, Stop_p1	# if you were going down then stop
		ori $s0, $zero, 0x01000000	# up
		j GetDir_done		

GetDir_left_down:
		bne $a0, 122, GetDir_right_up	# z
		beq $s0, 0x01000000, Stop_p1 	# if you were going up then stop
		ori $s0, $zero, 0x02000000	# down
		j GetDir_done
		
Stop_p1:
		or $s0, $zero, $zero		# no dir
		j GetDir_done

GetDir_right_up:
		bne $a0, 107, GetDir_right_down # k
		beq $s1, 0x02000000, Stop_p2	# if you were going down then stop
		ori $s1, $zero, 0x01000000	# up
		j GetDir_done

GetDir_right_down:
		bne $a0, 109, GetDir_none	# m
		beq $s1, 0x01000000, Stop_p2 	# if you were going up then stop
		ori $s1, $zero, 0x02000000	# down
		j GetDir_done
		
Stop_p2:
		or $s1, $zero, $zero		# no dir
		j GetDir_done

GetDir_none:
						# Do nothing
GetDir_done:
		jr $ra				# Return


##########################################################
			
Frame:
	
		# Check what keyboard input has been
		# Move paddles accordingly
		
MoveBall:
		beqz $s7, else
		addi $s5, $s5, 1
		j endif
	else:	
		addi $s5, $s5, -1
	endif:
		
DrawObjects:
		jal ClearScreen

		addi $a0, $zero, 0
		addu $a1, $zero, $s3
		lw $a2, $zero, coulourOne
		jal DrawPaddle
		
		addi $a0, $zero, 31
		addu $a1, $zero, $s4
		lw $a2, colourTwo
		jal DrawPaddle
		
		addu $a0, $zero, $s5
		addu $a1, $zero, $s6
		jal DrawBall
		
		# Check for collisions and react accordingly
CheckForCollisions:
		bne $s5, 30, NoRightCollision
RightCollision:
		ble $s6, $s4, PaddleHit
		addi $t0, $s4, -5
		bge $s6, $t0, PaddleHit
		j PTwoGameLoss
NoRightCollision:
		bne $s5, 1, NoLeftCollision
LeftCollsion:
		ble $s6, $s3, PaddleHit
		addi $t0, $s3, -5
		bge $s6, $t0, PaddleHit
		j POneGameLoss
NoLeftCollision:
		j Standby
		
PaddleHit: 
		xor $s7, $s7, 1
# TODO: Check for inturrupt method of implementation	
Standby:
		li $a0, 50
		li $v0, 32
		syscall
			# addi $t0, $zero, 1000
		# Set $t0 to whatever equals 1/30 of a second
		# Check for keyboard input
		# Record keyboard input
			# subi $t0, $t0, 1
			# beqz $t0, EndStandby
			# j Standby
EndStandby:
		j Frame
		
		
		li $v0, 10
		syscall
		
# $a0 contains the paddles x position, $a1 contains paddles y-top position, $a2 contains paddle color
# $t0 is the loop counter, $t1 is the current y coordinate, the x coordinate does not change
DrawPaddle:
		addi $t0, $zero, 6
	StartPLoop:
		subi $t0, $t0, 1
		addu $t1, $a1, $t0
		
		# Converts to memory address
		sll $t1, $t1, 5   # multiply y-coordinate by 32 (length of the field)
		addu $v0, $a0, $t1
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		
		sw $a2, ($v0)
		beqz $t0, EndPLoop
		j StartPLoop
	EndPLoop:		
		jr $ra
		nop
		
# $a0 contains x position, $a1 contains y position	
DrawBall:
		sll $t0, $a1, 5   # multiply y-coordinate by 32 (length of the field)
		addu $v0, $a0, $t0
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		lw $t0, ballColour # store the ball colour in a temporary
		sw $t0, ($v0)
		
		jr $ra
		
ClearScreen:
		lw $t0, backgroundColour
		li $t1, 4096
	StartCLoop:
		subi $t1, $t1, 4
		addu $t2, $t1, $gp
		sw $t0, ($t2)
		beqz $t1, EndCLoop
		j StartCLoop
	EndCLoop:
		jr $ra
		
POneGameLoss:

PTwoGameLoss:
		li $v0, 10
		syscall
	
				# CURRENTLY NOT USED		
# $a0 contains x position, $a1 contains y position. Outputs memory address in $v0
CoordinateToMemAddress:
		sll $t0, $a1, 5   # multiply y-coordinate by 32 (length of the field)
		addu $v0, $a0, $t0
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		nop
		
		
		
