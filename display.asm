.data
	xDir:			.word 1		# start going down (x always moves one so it doesnt need speed)
	ySpeed:			.word 1		# wait this long before you move over 1 y
	yDir:			.word 1			# start going to the right
	colourOne:		.word 0x00ff8000
	colourTwo:		.word 0x00c00080
	ballColour:		.word 0x00ffffff
	backgroundColour:	.word 0x00000000

.text
# s0 stores p1dir, s1 stores p2 dir, s2 stores balls x-velocity-count, s3 stores balls y-velocity-count, s4 stores paddle one's position, 
# s5 stores paddle two's position, s6 stores the balls x position, s7 stores the balls y position
NewGame:
		li $t0, 1
		sw $t0, ySpeed
		
		li $s0, 0 	# 0x01000000 up; 0x02000000 down; 0 stay
		li $s1, 0	# 0x01000000 up; 0x02000000 down; 0 stay
		lw $s2, xDir	# wait this long before you move over 1 x
		lw $s3, ySpeed	# wait this long before you move over 1 y
		li $s4, 13
		li $s5, 13
		li $s6, 32
		li $s7, 0

		jal ClearBoard
		
# TODO: if we want, we can move the ball every 5 milisec in standby then draw where it is when we come out
WaitForButton:
		li $a0, 10	#
		li $v0, 32	# pause for 10 milisec
		syscall		#
		
		lw $t1, 0xFFFF0000		# check to see if a key has been pressed
		blez $t1, WaitForButton
		
		sw $zero, 0xFFFF0000		# clear the button pushed bit

DrawObjects:
		or $a0, $zero, $s6
		or $a1, $zero, $s7
		jal CheckForCollisions
		jal MoveBall
		
		li $a0, 13
		or $a1, $zero, $s4
		lw $a2, colourOne
		or $a3, $zero, $s0
		jal DrawPaddle
		or $s4, $zero, $a1	# a1 has the new top position stored
		or $s0, $zero, $a3	# a3 has the new direction stored if it hit an edge
		
		li $a0, 50		
		or $a1, $zero, $s5
		lw $a2, colourTwo
		or $a3, $zero, $s1
		jal DrawPaddle
		or $s5, $zero, $a1	# a1 has the new top position stored
		or $s1, $zero, $a3	# a3 has the new direction stored if it hit an edge
		
# Wait and read buttons
Begin_standby:	
		# TODO: Store this somewhere besides $t0
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
		li $t0, 6
	StartPLoop:
		subi $t0, $t0, 1
		addu $t1, $a1, $t0
		
		# Converts to memory address
		sll $t1, $t1, 6   # multiply y-coordinate by 64 (length of the field)
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
   		
   		add $s6, $s6, $s2	# add the x velocity to the x coord
   		# y doesnt always change, check if it needs to
   		addi $s3, $s3, -1
   		bgt $s3, 0, NoYChange
ChangeY:
		lw $t0, yDir	
		add $s7, $s7, $t0
		lw $s3, ySpeed
NoYChange:
   		# do nothing
   		
   		# draw the new loc
		or $a0, $zero, $s6
		or $a1, $zero, $s7
		lw $a2, ballColour
		
# $a0 contains x position, $a1 contains y position, $a2 contains the colour	
DrawPoint:
		sll $t0, $a1, 6   # multiply y-coordinate by 64 (length of the field)
		addu $v0, $a0, $t0
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		sw $a2, ($v0)		# draw the colour to the location
		
		jr $ra
		
#################################################################################
# AdjustDir  changes the players direction registers depending on the key pressed
AdjustDir: 
		lw $a0, 0xFFFF0004		# Load button pressed
		
AdjustDir_left_up:
		bne $a0, 97, AdjustDir_left_down  # a
		li $s0, 0x01000000	# up
		j AdjustDir_done		

AdjustDir_left_down:
		bne $a0, 122, AdjustDir_right_up	# z
		li $s0, 0x02000000	# down
		j AdjustDir_done

AdjustDir_right_up:
		bne $a0, 107, AdjustDir_right_down # k
		li $s1, 0x01000000	# up
		j AdjustDir_done

AdjustDir_right_down:
		bne $a0, 109, AdjustDir_none	# m
		li $s1, 0x02000000	# down
		j AdjustDir_done

AdjustDir_none:
						# Do nothing
AdjustDir_done:
		jr $ra				# Return
#################################################################################
# Check for collisions and react accordingly
# $a0 contains balls x-pos $a1 contains balls y-pos
# first check if it is a normal collision
# then check if it is a valid corner collsion
CheckForCollisions:
		beq $s6, 0, POneGameLoss
		beq $s6, 63, PTwoGameLoss
		bne $s6, 14, NoLeftCollision	# see if it is in the left-paddle collsion section
LeftCollision:
		blt $s7, $s4, NoPaddleCollision	# see if its above paddle
		addi $t3, $s4, 5		# calculate bottom of paddle
		bgt $s7, $t3, NoPaddleCollision	# see if its below paddle
		sub $t3, $s7, $s4		# store distance from top to hit
		li $s2, 1			# change x-dir
		j PaddleHit
   		
NoLeftCollision:
		bne $s6, 49, NoPaddleCollision	# see if it is in the right-paddle collision section
RightCollision:
		blt $s7, $s5, NoPaddleCollision	# if it is above, there is no vertical collision
		addi $t3, $s5, 5
		bgt $s7, $t3, NoPaddleCollision	# if it is below, there is no vertical collision
		sub $t3, $s7, $s4		# store distance from top to hit
		li $s2, -1			# change x-dir
		j PaddleHit		

NoPaddleCollision:
		j CheckHorizontalHit
		
PaddleHit: 
		beq $t3, 0, tophigh
		beq $t3, 1, topmid
		beq $t3, 2, toplow
		beq $t3, 3, bottomhigh
		beq $t3, 4, bottommid
		beq $t3, 5, bottomlow
tophigh:
		li $s3, 1
		sw $s3, ySpeed
		j CheckHorizontalHit
topmid:
		li $s3, 2
		sw $s3, ySpeed
		j CheckHorizontalHit
toplow:
		li $s3, 4
		sw $s3, ySpeed
		j CheckHorizontalHit
bottomhigh:
		li $s3, 4
		sw $s3, ySpeed
		j CheckHorizontalHit
bottommid:
		li $s3, 2
		sw $s3, ySpeed
		j CheckHorizontalHit
bottomlow:
		li $s3, 1
		sw $s3, ySpeed
		
CheckHorizontalHit:
		beq $s7, 31, HorizontalWallHit
		bne $s7, 0, NoCollision
		
HorizontalWallHit: 
		# change y direction if y-count=1 (prevents it from switching until y is about to change)
		bgt $s3, 1, NoCollision
		li $t3, -1
		lw $t4, yDir
		mult $t4, $t3
		mflo $t4
		sw $t4, yDir
NoCollision:
		jr $ra
#################################################################################

ClearBoard:
		lw $t0, backgroundColour
		li $t1, 8192
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
		j NewGame
		
	
				# CURRENTLY NOT USED		
# $a0 contains x position, $a1 contains y position. Outputs memory address in $v0
CoordinateToMemAddress:
		sll $t0, $a1, 6   # multiply y-coordinate by 64 (length of the field)
		addu $v0, $a0, $t0
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		nop
		
		
		
