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

# TODO: if we want, we can move the ball every 5 milisec in standby then draw where it is when we come out	

DrawObjects:
		addi $a0, $zero, 0
		addu $a1, $zero, $s3
		lw $a2, colourOne
		or $a3, $zero, $s0
		jal DrawPaddle
		or $s3, $zero, $a1	# a1 has the new top position stored
		or $s0, $zero, $a3	# a3 has the new direction stored if it hit an edge
		
		addi $a0, $zero, 31
		addu $a1, $zero, $s4
		lw $a2, colourTwo
		or $a3, $zero, $s1
		jal DrawPaddle
		or $s4, $zero, $a1	# a1 has the new top position stored
		or $s1, $zero, $a3	# a3 has the new direction stored if it hit an edge
		
		addu $a0, $zero, $s5
		addu $a1, $zero, $s6
		jal MoveBall
		
		# Check for collisions and react accordingly
CheckForCollisions:
		bne $s5, 30, NoRightCollision
RightCollision:
		blt $s6, $s4, PTwoGameLoss
		addi $t0, $s4, 5
		bgt $s6, $t0, PTwoGameLoss
		j PaddleHit
NoRightCollision:
		bne $s5, 1, NoLeftCollision
LeftCollsion:
		blt $s6, $s3, POneGameLoss
		addi $t0, $s3, 5
		bgt $s6, $t0, POneGameLoss
		j PaddleHit
NoLeftCollision:
		j Begin_standby
		
PaddleHit: 
		xor $s7, $s7, 1
		
# Wait and read buttons
Begin_standby:
		ori $t0, $zero, 0x00000002			# load 25 into the counter for a ~50 milisec standby
	
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
		j DrawObjects
		
# $a0 contains the paddles x position, $a1 contains paddles y-top position, $a2 contains paddle color, $a3 contains the direction
# $t0 is the loop counter, $t1 is the current y coordinate, the x coordinate does not change
# after completed $a1 "returns" aka has stored the new y-top position, $a3 "returns" the direction
# careful to make sure nothing inbetween alters these  $a registers
DrawPaddle:
	# objective: look at the direction, draw a point on the correct side, erase a point on the correct side
	beq $a3, 0x02000000, down
	bne $a3, 0x01000000, NoMove
	up:
		# erase bottom point
   		or $t2, $zero, $a2
   		or $t1, $zero, $a1
   		addi $a1, $a1, 5	# the bottom point
		lw $a2, backgroundColour
		addi $sp, $sp, -4
   		sw $ra, 0($sp)   	# saves $ra on stack
		jal DrawPoint
		lw $ra, 0($sp)		# put return back
   		addi $sp, $sp, 4	# change stack back
   		or $a1, $zero, $t1	# put back top y position
   		or $a2, $zero, $t2	# put back colour
   		
		# move top y up (as long as its not at the top)
		beq $a1, 0, NoMove
		addi $a1, $a1, -1
		j Move
	down:
		# erase top point
		or $t1, $zero, $a2
		lw $a2, backgroundColour
		addi $sp, $sp, -4
   		sw $ra, 0($sp)   	# saves $ra on stack
		jal DrawPoint
		lw $ra, 0($sp)		# put return back
   		addi $sp, $sp, 4	# change stack back
   		or $a2, $zero, $t1	# put back colour
   		
		# move down top y (as long as bottom is not at bottom)
		beq $a1, 26, NoMove	# height is 31 - 5 = 26
		addi $a1, $a1, 1
		j Move
	NoMove:
		# else do nothing, make sure the direction is nothing
		or $a3, $zero, $zero
	Move:
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
MoveBall:		
		# draw over the last point
		lw $a2, backgroundColour
		addi $sp, $sp, -4
   		sw $ra, 0($sp)   	# saves $ra on stack
		jal DrawPoint
		lw $ra, 0($sp)		# put return back
   		addi $sp, $sp, 4	# change stack back

		beqz $s7, else 		# move the ball based on its direction
		addi $s5, $s5, 1 
		j endif
	else:	
		addi $s5, $s5, -1
	endif:	
		addu $a0, $zero, $s5
		addu $a1, $zero, $s6
		lw $a2, ballColour
		
# $a0 contains x position, $a1 contains y position, $a2 contains the colour	
DrawPoint:
		sll $t0, $a1, 5   # multiply y-coordinate by 32 (length of the field)
		addu $v0, $a0, $t0
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		sw $a2, ($v0)		# draw the colour to the location
		
		jr $ra
		
POneGameLoss:

PTwoGameLoss:
		li $v0, 10
		syscall
		
#################################################################################
# AdjustDir  changes the players direction registers depending on the key pressed
AdjustDir: 
		lw $a0, 0xFFFF0004		# Load button pressed
		
AdjustDir_left_up:
		bne $a0, 97, AdjustDir_left_down  # a
		beq $s0, 0x02000000, Stop_left	# if you were going down then stop
		ori $s0, $zero, 0x01000000	# up
		j AdjustDir_done		

AdjustDir_left_down:
		bne $a0, 122, AdjustDir_right_up	# z
		beq $s0, 0x01000000, Stop_left 	# if you were going up then stop
		ori $s0, $zero, 0x02000000	# down
		j AdjustDir_done
		
Stop_left:
		or $s0, $zero, $zero		# no dir
		j AdjustDir_done

AdjustDir_right_up:
		bne $a0, 107, AdjustDir_right_down # k
		beq $s1, 0x02000000, Stop_right	# if you were going down then stop
		ori $s1, $zero, 0x01000000	# up
		j AdjustDir_done

AdjustDir_right_down:
		bne $a0, 109, AdjustDir_none	# m
		beq $s1, 0x01000000, Stop_right # if you were going up then stop
		ori $s1, $zero, 0x02000000	# down
		j AdjustDir_done
		
Stop_right:
		or $s1, $zero, $zero		# no dir
		j AdjustDir_done

AdjustDir_none:
						# Do nothing
AdjustDir_done:
		jr $ra				# Return
#################################################################################
	
				# CURRENTLY NOT USED		
# $a0 contains x position, $a1 contains y position. Outputs memory address in $v0
CoordinateToMemAddress:
		sll $t0, $a1, 5   # multiply y-coordinate by 32 (length of the field)
		addu $v0, $a0, $t0
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		nop
		
		
		
