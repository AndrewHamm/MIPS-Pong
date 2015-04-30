.data
	xDir:			.word 1		# start going right (x always moves one so it doesnt need speed)
	ySpeed:			.word -1		# wait this long before you move over 1 y
	yDir:			.word -1		# start going to the down
	P1Score:		.word 0
	P2Score:		.word 0
	compCount:		.word 0
	compSpeed:		.word 0		# this gets set to level after the first collision
	Level:			.word 6
	colorOne:		.word 0x00ff8000
	colorTwo:		.word 0x00c00080
	ballColor:		.word 0x00ffffff
	backgroundColor:	.word 0x00000000
	blueColor:		.word 0x0012fff7
	mode:			.word 0  # 1 denotes 1 Player mode
					 # 2 denotes 2 Player mode
					 # Room for more...

.text

NewGame:
	jal ClearBoard

	Lines:
		li $a0, 10 
		li $a1, 13 
		lw $a2, colorTwo
		li $a3, 18 
		jal DrawHorizontalLine
		
		li $a1, 14
		jal DrawHorizontalLine
		
		li $a0, 46
		li $a3, 54
		jal DrawHorizontalLine
		
		li $a1, 13
		jal DrawHorizontalLine
		
		li $a0, 10
		li $a1, 15
		lw $a2, blueColor
		li $a3, 18 
		jal DrawHorizontalLine
		
		li $a1, 16 
		jal DrawHorizontalLine
		
		li $a0, 46
		li $a3, 54 
		jal DrawHorizontalLine
		
		li $a1, 15
		jal DrawHorizontalLine
		
		li $a0, 10
		li $a1, 17
		lw $a2, colorOne
		li $a3, 18
		jal DrawHorizontalLine
		
		li $a1, 18
		jal DrawHorizontalLine
		
		li $a0, 46
		li $a3, 54
		jal DrawHorizontalLine
		
		li $a1, 17
		jal DrawHorizontalLine	
		
	PONG:
		li $a0, 21
		li $a1, 13
		lw $a2, ballColor
		li $a3, 18
		jal DrawVerticalLine
		
		li $a0, 27
		jal DrawVerticalLine
		
		li $a0, 31
		jal DrawVerticalLine
		
		li $a0, 33
		jal DrawVerticalLine
		
		li $a0, 37
		jal DrawVerticalLine
		
		li $a0, 39
		jal DrawVerticalLine
		
		li $a0, 34 
		li $a1, 13
		li $a3, 14
		jal DrawVerticalLine
	
		li $a0, 35
		li $a1, 15
		li $a3, 16
		jal DrawVerticalLine
		
		li $a0, 25
		li $a1, 14
		jal DrawVerticalLine
		
		li $a0, 22
		li $a1, 16
		li $a3, 24
		jal DrawHorizontalLine
	
		li $a0, 22
		li $a1, 16
		li $a3, 25
		jal DrawHorizontalLine
	
		li $a1, 13
		jal DrawHorizontalLine
		
		li $a0, 27
		li $a3, 30
		jal DrawHorizontalLine
	
		li $a1, 18
		jal DrawHorizontalLine
		
		li $a0, 40
		li $a3, 43
		jal DrawHorizontalLine
		
		li $a1, 13
		jal DrawHorizontalLine
		
		li $a0, 41
		li $a1, 16
		jal DrawHorizontalLine
		
		li $a0, 36
		li $a1, 17
		jal DrawPoint
		
		li $a0, 43
		jal DrawPoint
	
	Press1or2:
		li $a0, 35
		li $a1, 25
		li $a3, 29
		jal DrawVerticalLine
		
		li $a0, 17
		jal DrawVerticalLine
		
		li $a0, 19
		jal DrawVerticalLine
		
		li $a0, 21
		jal DrawVerticalLine
		
		li $a0, 39
		jal DrawVerticalLine
		
		li $a0, 41
		jal DrawVerticalLine
		
		li $a0, 43
		jal DrawVerticalLine
		
		li $a0, 45
		jal DrawVerticalLine
		
		li $a0, 12
		jal DrawVerticalLine
		
		li $a3, 15
		jal DrawHorizontalLine
		
		li $a1, 27
		jal DrawHorizontalLine
		
		li $a0, 15
		li $a1, 26
		li $a3, 27
		jal DrawVerticalLine
		
		li $a0, 18
		li $a1, 25
		li $a3, 27
		jal DrawVerticalLine
		
		li $a0, 22
		li $a1, 27
		jal DrawPoint
		
		li $a1, 29
		jal DrawPoint
		
		li $a1, 25
		jal DrawPoint
		
		li $a0, 24 
		li $a1, 29
		li $a3, 26
		jal DrawHorizontalLine
		
		li $a0, 24
		li $a1, 27
		jal DrawHorizontalLine
		
		li $a1, 25
		jal DrawHorizontalLine
		
		li $a1, 26
		jal DrawPoint
		
		li $a0, 26
		li $a1, 28
		jal DrawPoint
		
		li $a0, 22
		li $a1, 25
		jal DrawPoint
		
		li $a0, 34
		li $a1, 26
		jal DrawPoint
		
		li $a1, 29
		li $a3, 36
		jal DrawHorizontalLine

		li $a0, 40
		jal DrawPoint
		
		li $a1, 25
		jal DrawPoint

		li $a0, 44
		li $a3, 27
		jal DrawVerticalLine
			
		li $a0, 49
		li $a1, 25
		li $a3, 50
		jal DrawHorizontalLine
	
		li $a1, 28
		jal DrawPoint
	
		li $a0, 50
		li $a1, 29
		jal DrawPoint
		
		li $a1, 27
		jal DrawPoint
	
		li $a0, 51
		li $a1, 26
		jal DrawPoint
	
		li $a0, 48
		jal DrawPoint
		
		li $a1, 29
		li $a3, 51
		jal DrawHorizontalLine

		li $a0, 28
		li $a3, 30
		jal DrawHorizontalLine
	
		li $a1, 27
		jal DrawHorizontalLine
		
		li $a1, 25
		li $a3, 30
		jal DrawHorizontalLine
	
		li $a1, 26
		jal DrawPoint
	
		li $a0, 30
		li $a1, 28
		jal DrawPoint
		
		li $a1, 26
		lw $a2, backgroundColor
		jal DrawPoint
		
		li $a0, 19
		li $a1, 27
		jal DrawPoint
		
		li $a0, 45
		jal DrawPoint
		
		li $a0, 44
		li $a1, 26
		jal DrawPoint
		
		li $a0, 18
		jal DrawPoint
		
SelectMode:
		lw $t1, 0xFFFF0004		# check to see which key has been pressed
		beq $t1, 0x00000031, SetOnePlayerMode # 1 pressed
		beq $t1, 0x00000032, SetTwoPlayerMode # 2 pressed
		
		li $a0, 250	#
		li $v0, 32	# pause for 250 milisec
		syscall		#
		
		j SelectMode    # Jump back to the top of the wait loop
		
SetOnePlayerMode:
		li $t1, 1
		j BeginGame
SetTwoPlayerMode:
		li $t1, 2
BeginGame:
		sw $zero, 0xFFFF0000		# clear the button pushed bit
		sw $t1, mode
		
		

# $s0 stores p1 dir
# $s1 stores p2 dir
# $s2 stores balls x-velocity-count
# $s3 stores balls y-velocity-count
# $s4 stores paddle one's position, 
# $s5 stores paddle two's position
# $s6 stores the balls x position
# $s7 stores the balls y position
NewRound:

		# Initialize all the regesters for a new iteration of the gameplay loop
		li $t0, 1
		li $t1, -1
		sw $t0, ySpeed
		sw $t1, yDir
		sw $zero, compSpeed 	# reset compCount and compSpeed to 0 for first collision
		sw $zero, compCount
		
		li $s0, 0 	# 0x01000000 up; 0x02000000 down; 0 stay
		li $s1, 0	# 0x01000000 up; 0x02000000 down; 0 stay
		lw $s2, xDir	# wait this long before you move over 1 x
		lw $s3, ySpeed	# wait this long before you move over 1 y
		li $s4, 13
		li $s5, 13
		li $s6, 32
		li $s7, 0

		jal ClearBoard
		
		lw $a2, P1Score
		li $a3, 1
		jal DrawScore
		lw $a2, P2Score
		li $a3, 54
		jal DrawScore
		
		li $a0, 13
		move $a1, $s4
		lw $a2, colorOne
		jal DrawPaddle
		
		li $a0, 50
		move $a1, $s5
		lw $a2, colorTwo
		jal DrawPaddle

		li $a0, 1000	#
		li $v0, 32	# pause for 1 second
		syscall		#

DrawObjects:
		move $a0, $s6
		move $a1, $s7
		jal CheckForCollisions
		jal MoveBall
		
		li $a0, 13
		move $a1, $s4
		lw $a2, colorOne
		move $a3, $s0
		jal DrawPaddle
		move $s4, $a1	# a1 has the new top position stored
		move $s0, $a3	# a3 has the new direction stored if it hit an edge
		
		li $a0, 50		
		move $a1, $s5
		lw $a2, colorTwo
startAi:
		lw $t1, mode
		bne $t1, 1, endAi 	# branches past the Ai if 2 player mode
		
		lw $t0, compCount 	
		addi $t0, $t0, -1	# decrement compCount
		sw $t0, compCount
		bgt $t0, 0, endAi
		lw $t0, compSpeed 	# reset compCount
		sw $t0, compCount
		addi $t1, $s5, 2	# calculate the middle of the paddle
		blt $t1, $s7, goDown	# if bally above paddlemid, dir = 0x01000000
		li $s1, 0x01000000
		j endAi	
goDown: 
		li $s1, 0x02000000
endAi:
		move $a3, $s1
		jal DrawPaddle
		move $s5, $a1	# a1 has the new top position stored
		move $s1, $a3	# a3 has the new direction stored if it hit an edge
		
		
# Wait and read buttons
Begin_standby:	
		li $t0, 0x00000002			# load 25 into the counter for a ~50 milisec standby
	
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
		
# $a0 contains the paddles x position
# $a1 contains paddles y-top position
# $a2 contains paddle color
# $a3 contains the direction
# $t0 is the loop counter
# $t1 is the current y coordinate, the x coordinate does not change
# after completed $a1 "returns" aka has stored the new y-top position, $a3 "returns" the direction
# careful to make sure nothing inbetween alters these  $a registers
DrawPaddle:
	# objective: look at the direction, draw a point on the correct side, erase a point on the correct side
	beq $a3, 0x02000000, down
	bne $a3, 0x01000000, NoMove
	up:
		# erase bottom point
   		move $t2, $a2
   		move $t1, $a1
   		addi $a1, $a1, 5	# the bottom point
		lw $a2, backgroundColor
		addi $sp, $sp, -4
   		sw $ra, 0($sp)   	# saves $ra on stack
		jal DrawPoint
		lw $ra, 0($sp)		# put return back
   		addi $sp, $sp, 4	# change stack back
   		move $a1, $t1	# put back top y position
   		move $a2, $t2	# put back color
   		
		# move top y up (as long as its not at the top)
		beq $a1, 0, NoMove
		addi $a1, $a1, -1
		j Move
	down:
		# erase top point
		move $t1, $a2
		lw $a2, backgroundColor
		addi $sp, $sp, -4
   		sw $ra, 0($sp)   	# saves $ra on stack
		jal DrawPoint
		lw $ra, 0($sp)		# put return back
   		addi $sp, $sp, 4	# change stack back
   		move $a2, $t1	# put back color
   		
		# move down top y (as long as bottom is not at bottom)
		beq $a1, 26, NoMove	# height is 31 - 5 = 26
		addi $a1, $a1, 1
		j Move
	NoMove:
		# else do nothing, make sure the direction is nothing
		li $a3, 0
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

# $a2 contains the score of the player
# $a3 contains the column of the leftmost scoring dot.
# Using this information, draws along the top of the screen to display a player's score	
DrawScore:
		addi $sp, $sp, -12	# Stores regiester values to the stack
   		sw $ra, 0($sp)
   		sw $s2, 4($sp)
   		sw $a2, 8($sp)
   		
   		move $s2, $a2
   		lw $a2, ballColor
   		ble $s2, 5, DrawScoreRow1
   	DrawScoreRow2:			# Draws any score values along the second row
   	
   		sub $t1, $s2, 6
   		sll $t1, $t1, 1
   		add $a0, $t1, $a3
   		li $a1, 3
   		jal DrawPoint
   		
   		addi $s2, $s2 -1
   		
   		bge $s2, 6, DrawScoreRow2
   		
	DrawScoreRow1:			# Draws any score values along the first row
		beq $s2, $zero, DrawScoreEnd
		sub $t1, $s2, 1
		sll $t1, $t1, 1
   		add $a0, $t1, $a3
   		li $a1, 1
   		jal DrawPoint
   		
   		addi $s2, $s2, -1
   		
   		j DrawScoreRow1
	
	DrawScoreEnd:
		lw $ra, 0($sp)		# restores register values from the stack
		lw $s2, 4($sp)
		lw $a2, 8($sp)
   		addi $sp, $sp, 12
		
		jr $ra
		
# $a0 contains x position
# $a1 contains y position	
MoveBall:		
		# draw over the last point
		lw $a2, backgroundColor
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
		move $a0, $s6
		move $a1, $s7
		lw $a2, ballColor
		
# $a0 contains x position, $a1 contains y position, $a2 contains the color	
DrawPoint:
		sll $t0, $a1, 6   # multiply y-coordinate by 64 (length of the field)
		addu $v0, $a0, $t0
		sll $v0, $v0, 2
		addu $v0, $v0, $gp
		sw $a2, ($v0)		# draw the color to the location
		
		jr $ra

# $a0 the x starting coordinate
# $a1 the y coordinate
# $a2 the color
# $a3 the x ending coordinate
DrawHorizontalLine:
		
		addi $sp, $sp, -4
   		sw $ra, 0($sp)
		
		sub $t9, $a3, $a0
		move $t1, $a0
		
	HorizontalLoop:
		
		add $a0, $t1, $t9
		jal DrawPoint
		addi $t9, $t9, -1
		
		bge $t9, 0, HorizontalLoop
		
		lw $ra, 0($sp)		# put return back
   		addi $sp, $sp, 4

		jr $ra
		
# $a0 the x coordinate
# $a1 the y starting coordinate
# $a2 the color
# $a3 the y ending coordinate
DrawVerticalLine:

		addi $sp, $sp, -4
   		sw $ra, 0($sp)
		
		sub $t9, $a3, $a1
		move $t1, $a1
		
	VerticalLoop:
		
		add $a1, $t1, $t9
		jal DrawPoint
		addi $t9, $t9, -1
		
		bge $t9, 0, VerticalLoop
		
		lw $ra, 0($sp)		# put return back
   		addi $sp, $sp, 4
   		
		jr $ra
		

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

# Check for collisions and react accordingly
# $a0 contains balls x-pos $a1 contains balls y-pos
# first check if it is a normal collision
# then check if it is a valid corner collsion
CheckForCollisions:
		beq $s6, 0, POneRoundLoss
		beq $s6, 63, PTwoRoundLoss
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
		sub $t3, $s7, $s5		# store distance from top to hit
		li $s2, -1			# change x-dir
		j PaddleHit		

NoPaddleCollision:
		j CheckHorizontalHit
		
PaddleHit: 
		addi $sp, $sp, -8
   		sw $a0, 0($sp)   	# arguments on stack
   		sw $a1, 4($sp)
		
		li $a0, 80		# Make the sound when the ball hits the paddle
		li $a1, 80
		li $a2, 32
		li $a3, 127
		li $v0, 31
		syscall
		
   		lw $a0, 0($sp)   	# Puts arguments back in their registers for later use
   		lw $a1, 4($sp)
   		addi $sp, $sp, 8
		
		lw $t4, Level		# set the compSpeed here so it never misses the first ball
		sw $t4, compSpeed
		beq $t3, 0, tophigh
		beq $t3, 1, topmid
		beq $t3, 2, toplow
		beq $t3, 3, bottomhigh
		beq $t3, 4, bottommid
		beq $t3, 5, bottomlow
tophigh:
		li $s3, 1
		sw $s3, ySpeed
		li $s3, -1
		sw $s3, yDir
		j CheckHorizontalHit
topmid:
		li $s3, 2
		sw $s3, ySpeed
		li $s3, -1
		sw $s3, yDir
		j CheckHorizontalHit
toplow:
		li $s3, 4
		sw $s3, ySpeed
		li $s3, -1
		sw $s3, yDir
		j CheckHorizontalHit
bottomhigh:
		li $s3, 4
		sw $s3, ySpeed
		li $s3, 1
		sw $s3, yDir
		j CheckHorizontalHit
bottommid:
		li $s3, 2
		sw $s3, ySpeed
		li $s3, 1
		sw $s3, yDir
		j CheckHorizontalHit
bottomlow:
		li $s3, 1
		sw $s3, ySpeed
		li $s3, 1
		sw $s3, yDir
		
CheckHorizontalHit:
		beq $s7, 31, HorizontalWallHit
		bne $s7, 0, NoCollision
		
HorizontalWallHit: 
		# play a sound
		addi $sp, $sp, -8
   		sw $a0, 0($sp)   	# arguments on stack
   		sw $a1, 4($sp)
		
   		lw $a0, 0($sp)   	# Puts arguments back in their registers for later use
   		lw $a1, 4($sp)
   		addi $sp, $sp, 8
   		
		# change y direction if y-count=1 (prevents it from switching until y is about to change)
		bgt $s3, 1, NoCollision
		lw $t4, yDir
		xori $t4, $t4, 0xffffffff
		addi $t4, $t4, 1
		sw $t4, yDir
NoCollision:
		jr $ra

# Makes the entire bitmap display the background color (black)
ClearBoard:
		lw $t0, backgroundColor
		li $t1, 8192 # The number of pixels in the display
	StartCLoop:
		subi $t1, $t1, 4
		addu $t2, $t1, $gp
		sw $t0, ($t2)
		beqz $t1, EndCLoop
		j StartCLoop
	EndCLoop:
		jr $ra
		
POneRoundLoss:
		# Increment player 2's score
		lw $t1, P2Score
		addi $t1, $t1, 1
		sw $t1, P2Score
		
		#Ready the next round
		li $t2, 1
		sw $t2, xDir
		
		li $a3, 54
		sw $zero, 0xFFFF0004  # Zeros the key press 
		beq $t1, 10, EndGame
		
		j PlayPointSound
PTwoRoundLoss:	
		# Increment player 1's score
		lw $t1, P1Score
		addi $t1, $t1, 1
		sw $t1, P1Score
		
		#Ready the next round
		li $t2, -1
		sw $t2, xDir
		
		li $a3, 1
		sw $zero, 0xFFFF0004 # Zeros the key press
		beq $t1, 10, EndGame

PlayPointSound:
		# play a sound
		li $a0, 80		# Make the sound when a point is scored
		li $a1, 300
		li $a2, 121
		li $a3, 127
		li $v0, 31
		syscall
   		
   		j NewRound
	
# Ends the game, wrapping up the process
EndGame:
		jal ClearBoard
		
		lw $t0, P1Score
		bne $t0, 10, WinTwo
		
		
	WinOne:	li $a0, 34 #the x coordinate
		li $a1, 12 #the y starting coordinate
		lw $a2, ballColor #the color
		li $a3, 15 #the y ending coordinate
		jal DrawVerticalLine
		
		li $a0, 33
		li $a1, 13
		jal DrawPoint
		
		li $a1, 16 #the y coordinate
		li $a3, 35 #the x ending coordinate
		jal DrawHorizontalLine
		
		j WinP
		
	WinTwo:	li $a0, 33 #the x starting coordinate
		li $a1, 16 #the y coordinate
		lw $a2, ballColor #the color
		li $a3, 36 #the x ending coordinate
		jal DrawHorizontalLine
	
		li $a0, 34 #the x starting coordinate
		li $a1, 12 #the y coordinate
		li $a3, 35 #the x ending coordinate
		jal DrawHorizontalLine
	
		li $a1, 15
		jal DrawPoint
	
		li $a0, 35
		li $a1, 16
		jal DrawPoint
	
		li $a1, 14
		jal DrawPoint
	
		li $a0, 36
		li $a1, 13
		jal DrawPoint
	
		li $a0, 33
		jal DrawPoint
		
	WinP:	li $a0, 27 #the x coordinate
		li $a1, 12 #the y starting coordinate
		li $a3, 16 #the y ending coordinate
		jal DrawVerticalLine
		
		li $a0, 30 #the x coordinate
		li $a3, 14 #the ending y coordinate
		jal DrawVerticalLine
		
		li $a0, 28 #the x starting coordinate
		li $a3, 29 #the x ending coordinate
		jal DrawHorizontalLine
	
		li $a1, 14 #the y coordinate
		jal DrawHorizontalLine

		li $a0, 100 	#
		li $v0, 32	# Pause for 100 milisec
		syscall		#
		
		sw $zero, 0xFFFF0000

WaitForReset:		
		li $a0, 10 	#
		li $v0, 32	# pause for 10 milisec
		syscall		#
		
		lw $t0, 0xFFFF0000
		beq $t0, $zero, WaitForReset
		
		j Reset
		
Reset:		
		sw $zero, P1Score
		sw $zero, P2Score
		sw $zero, 0xFFFF0000	# Zeros the keypress words in memory
		sw $zero, 0xFFFF0004
		
		jal ClearBoard
		
		j NewGame
