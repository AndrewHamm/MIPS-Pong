.data
	colourOne:		.word 0x00ff8000
	colourTwo:		.word 0x00c00080
	ballColour:		.word 0x00ffffff
	backgroundColour:	.word 0x00000000

.text
# s0-s2 store colors, s3 stores paddle one's position, s4 stores paddle two's position, 
# s5 stores the balls x position, s6 stores the balls y position, #s7 stores the balls direction
Main:
		lw $s0, colourOne
		lw $s1, colourTwo
		lw $s2, ballColour
		li $s3, 13
		li $s4, 13
		li $s5, 16
		li $s6, 16
		li $s7, 0
		
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
		addu $a2, $zero, $s0
		jal DrawPaddle
		
		addi $a0, $zero, 31
		addu $a1, $zero, $s4
		addu $a2, $zero, $s1
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
		sw $s2, ($v0)
		
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
		
		
		
