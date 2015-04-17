# MIPS assembly program written by D.Taylor to be snake.

.data
# Store all important and starting data in this section, and make any other necessary notes
# even if it does endup huge being enourmous.

stageWidth:		.half 32			# Store stage size
stageHeight:		.half 32			# Usual settings $gp, 32x32, 16xScaling, 512x512

headX:			.half 5				# Store player possition in memory
headY:			.half 5	
tailX:			.half 4
tailY:			.half 5

tailSize:		.word 3				# Store player's initial tail size

defaultDir:		.word 0x01000000		# Store default dir as right

food01X:		.half 30			# Store intial foods' possitions in memory
food01Y:		.half 30
food02X:		.half 60
food02Y:		.half 60
	
drawColour:		.word 0x0022CC22		# Store colour to draw objects
bgColour:		.word 0xFF003300		# Store colour to draw background

# I should explain at this point that I'll be using the otherwise unused alpha channel (leftmost two bytes) to store additional information relating to each tile.
							# Alpha channel meanings (00 to FF) should be noted also:
							# 00 to 31 kill player
								# 00 = wall
								# 01 = snake moving right
								# 02 = snake moving up
								# 03 = snake moving left
								# 04 = snake moving down
							# 32 to 3B grow player
								# 32 = food
							# FF is empty space
							
.text
# Main and other methods go here. Hopefully they'll cooperate and play nicely, because 
# I really want to play snake, and there's definately not any snake clones available elsewhere...
Main:
			# Seed pseudorandom number generator 1 with lower order bytes of system clock
			ori $v0, $zero, 30		# Retrieve system time
			syscall
			or $a1, $zero, $a0		# Move the low order bytes to a1
			ori $a0, $zero, 1		# Set generator number
			ori $v0, $zero, 40		# Seed the generator with it
			syscall				

Main_init:
			# Load player info
			lh $a0, headX 			# Get player's head possition
			lh $a1, headY			
			jal CoordsToAddress		# Calculate possition in stage memory
			nop
			or $s0, $zero, $v0		# Store stage memory possition in s0
			
			lh $a0, tailX 			# Get player's tail possition
			lh $a1, tailY			
			jal CoordsToAddress		# Calculate possition in stage memory
			nop
			or $s1, $zero, $v0		# Store stage memory possition in s1
			
			lw $s3, tailSize		# Store tail size # in s3
			
			lw $s4, defaultDir		# Store default dir in s4
			
			
			# Load colour info
			lw $s6, drawColour		# Store drawing colour in s6
			lw $s7, bgColour		# Store background colour in s7


			# Prepare the arena
			or $a0, $zero, $s7		# Clear stage to background colour
			jal FillMemory
			nop
			jal AddBoundaries		# Add walls
			nop
			
			# Draw player's initial head
			or $a0, $zero, $s6		# Load draw colour	
			or $a1, $zero, $s0		# Load possition
			jal PaintMemory			# Call the paint function
			nop
			# Draw player's initial tail
			ori $a0, $s6, 0x01000000	# Load draw colour and attach right movement bytes
			or $a1, $zero, $s1		# Load possition
			jal PaintMemory			# Call the paint function
			nop

			# Draw initial food
			jal GetFoodPos			# Get a random possition for the new food
			nop
			ori $a0, $zero, 0x32FFFFFF	# Load white as the colour and attach the food bytes
			or $a1, $zero, $v0		# Load possition
			jal PaintMemory			# Call the paint function
			nop
			

Main_waitLoop:
			# Wait for the player to press a key
			jal Sleep			# Zzzzzzzzzzz...
			nop
			lw $t0, 0xFFFF0000		# Retrieve transmitter control ready bit
			blez $t0, Main_waitLoop		# Check if a key was pressed
			nop
Main_gameLoop:
			# Main game loop in which the program should spend most of it's time
			jal Sleep			# Sleep for 60 miliseconds so that the game is playable
			nop
			
			blez $s3, Main_tailBegin	# Skip removing the tail if food was picked up previously
			nop				
			subi $s3, $s3, 1		# Take one from food pick-up
			b Main_skipTail			# Jump to skip reducing tail length
			nop
Main_tailBegin:
			lw $t7, ($s1) 			# Backup tail colour data
			or $a0, $zero, $s7		# Remove tail peice
			or $a1, $zero, $s1		# Load addresss
			jal PaintMemory			# Call the paint function
			nop
			
			srl $t7, $t7, 24		# Extract direction byte from tail colour data
			or $a0, $zero, $s1		# Set a0 to current possition
			or $a1, $zero, 1		# Set distance to one
			
							# Switch to move tail memory address in the correct direction
Main_tailRight:
			bne, $t7, 0x00000001, Main_tailUp
			nop
			jal MoveRight			# Right
			nop
			j Main_tailDone
			nop
Main_tailUp:
			bne, $t7, 0x00000002, Main_tailLeft
			nop
			jal MoveUp			# Up
			nop
			j Main_tailDone
			nop
Main_tailLeft:
			bne, $t7, 0x00000003, Main_tailDown
			nop
			jal MoveLeft			# Left
			nop
			j Main_tailDone
			nop
Main_tailDown:
			bne, $t7, 0x00000004, Main_tailNone
			nop
			jal MoveDown			# Down
			nop
			j Main_tailDone
			nop
Main_tailNone:
			ori $v0, $zero, 10		# Syscall terminate
			syscall
Main_tailDone:
			or $s1, $zero, $v0		# Store player's new tail possition
			
Main_skipTail:
			# Now it's time to move the player's head
			jal GetDir			# Get direction from keyboard
			nop
			or $t6, $zero, $v0		# Backup direction from keyboard
			
			or $a0, $zero, $s0		# Load possition
			ori $a1, $zero, 1		# Set distance to move
			
			# Switch to move head memory address in the correct direction
Main_headRight:
			bne, $t6, 0x01000000, Main_headUp
			nop
			jal MoveRight			# Right
			nop
			j Main_headDone
			nop
Main_headUp:
			bne, $t6, 0x02000000, Main_headLeft
			nop
			jal MoveUp			# Up
			nop
			j Main_headDone
			nop
Main_headLeft:
			bne, $t6, 0x03000000, Main_headDown
			nop
			jal MoveLeft			# Left
			nop
			j Main_headDone
			nop
Main_headDown:
			bne, $t6, 0x04000000, Main_headNone
			nop
			jal MoveDown			# Down
			nop
			j Main_headDone
			nop
Main_headNone:
			or $t6, $zero, $s4		#default to previous direction
			b Main_headRight
			nop
Main_headDone:
			
			or $s4, $zero, $t6		# Backup new direction as previous direction
			add $a0, $s6, $t6		# Redraw current possition with direction headed in the alpha bytes
			or $a1, $zero, $s0		
			jal PaintMemory
			nop
					
									
			or $s0, $zero, $v0		# Store player's new head possition
			
			lw $t0, ($s0)			# Check status of tile moved into
			srl $t0, $t0, 24
			ble $t0, 0x31, Main_reset	# Exit if it's a wall
			nop
			blt $t0, 0x32, Main_noFood	# Skip adding to food if it's not food
			nop
			bgt $t0, 0x3B, Main_noFood
			nop
			addiu $s3, $s3, 2		# Otherwise add 2 to food register - this will extend the snake by two pixels next iteration
			
			# Draw new food
			jal GetFoodPos
			nop
			ori $a0, $zero, 0x32FFFFFF	# Set colour to white with food alpha bytes
			or $a1, $zero, $v0
			jal PaintMemory
			nop
Main_noFood:
			or $a0, $zero, $s6		# Draw new head possition
			or $a1, $zero, $s0
			jal PaintMemory
			nop
			
			b Main_gameLoop			# Loop around again to continue the game
			nop

Main_reset:
			# You died. Oh dead :C
			ori $v0, $zero, 32		# Syscall sleep
			ori $a0, $zero, 1200		# For this many miliseconds
			syscall
			b Main
			nop
Main_exit:
			ori $v0, $zero, 10		# Syscall terminate
			syscall
			
###########################################################################################
# Sleep function for game loop
# Takes none
# Returns none
Sleep:
			ori $v0, $zero, 32		# Syscall sleep
			ori $a0, $zero, 60		# For this many miliseconds
			syscall
			jr $ra				# Return
			nop
###########################################################################################
# Function to convert coordinates into stage memory addresses
# Takes a0 = x, a1 = y
# Returns  v0 = address
CoordsToAddress:
		or $v0, $zero, $a0		# Move x coordinate to v0
		lh $a0, stageWidth		# Load the screen width into a0
		multu $a0, $a1			# Multiply y coordinate by the screen width
		nop
		mflo $a0			# Retrieve result from lo register
		addu $v0, $v0, $a0		# Add the result to the x coordinate and store in v0
		sll $v0, $v0, 2			# Multiply v0 by 4 (bytes) using a logical shift
		addu $v0, $v0, $gp		# Add gp to v0 to give stage memory address
		jr $ra				# Return
		nop
###########################################################################################
# Function to draw the given colour to the given stage memory address (gp)
# Takes a0 = colour, a1 = address
# Returns none
PaintMemory:
		sw $a0, ($a1)			# Set colour
		jr $ra				# Return
		nop
###########################################################################################
# Function to move a given stage memory address right by a given number of tiles
# Takes a0 = address, a1 = distance
# Returns v0 = new address
MoveRight:
		#address + (distance*width*4)
		or $v0, $zero, $a0		# Move address to v0
		sll $a0, $a1, 2			# Multiply distance by 4 using a logical shift
		add $v0, $v0, $a0		# Add result to v0
		jr $ra				# Return
		nop
###########################################################################################
# Function to move a given stage memory address up by a given number of tiles
# Takes a0 = address, a1 = distance
# Returns v0 = new address
MoveUp:
		or $v0, $zero, $a0		# Move address to v0
		lh $a0, stageWidth		# Load the screen width into a0
		multu $a0, $a1			# Multiply distance by screen width
		nop
		mflo $a0			# Retrieve result from lo register
		sll $a0, $a0, 2			# Multiply v0 by 4 using a logical shift
		subu $v0, $v0, $a0		# Add result to v0
		jr $ra				# Return
		nop
###########################################################################################
# Function to move a given stage memory address left by a given number of tiles
# Takes a0 = address, a1 = distance
# Returns v0 = new address
MoveLeft:
		or $v0, $zero, $a0		# Move address to v0
		sll $a0, $a1, 2			# Multiply distance by 4 using a logical shift
		subu $v0, $v0, $a0		# Subtract result from v0
		jr $ra				# Return
		nop
###########################################################################################
# Function to move a given stage memory address down by a given number of tiles
# Takes a0 = address, a1 = distance
# Returns v0 = new address
MoveDown:
		or $v0, $zero, $a0		# Move address to v0
		lh $a0, stageWidth		# Load the screen width into a0
		multu $a0, $a1			# Multiply distance by screen width
		nop
		mflo $a0			# Retrieve result from lo register
		sll $a0, $a0, 2			# Multiply v0 by 4 using a logical shift
		addu $v0, $v0, $a0		# Subtract result from v0
		jr $ra				# Return
		nop
###########################################################################################
# Function to retrieve input from the kyboard and return it as an alpha channel direction
# Takes none
# Returns v0 = direction
GetDir:
		lw $t0, 0xFFFF0004		# Load input value
		
GetDir_right:
		bne, $t0, 100, GetDir_up
		nop
		ori $v0, $zero, 0x01000000	# Right
		j GetDir_done
		nop
GetDir_up:
		bne, $t0, 119, GetDir_left
		nop
		ori $v0, $zero, 0x02000000	# Up
		j GetDir_done
		nop
GetDir_left:
		bne, $t0, 97, GetDir_down
		nop
		ori $v0, $zero, 0x03000000	# Left
		j GetDir_done
		nop
GetDir_down:
		bne, $t0, 115, GetDir_none
		nop
		ori $v0, $zero, 0x04000000	# Down
		j GetDir_done
		nop
GetDir_none:
						# Do nothing
GetDir_done:
		jr $ra				# Return
		nop
###########################################################################################
# Function to fill the stage memory with a given colour
# Takes a0 = colour
# Returns none
FillMemory:
		lh $a1, stageWidth		# Calculate ending possition
		lh $a2, stageHeight
		multu $a1, $a2			# Multiply screen width by screen height
		nop
		mflo $a2			# Retreive total tiles
		sll $a2, $a2, 2			# Multiply by 4
		add $a2, $a2, $gp		# Add global pointer
		
		or $a1, $zero, $gp		# Set loop var to global pointer
FillMemory_l:	
		sw $a0, ($a1)
		add $a1, $a1, 4
		blt $a1, $a2, FillMemory_l
		nop
		
		jr $ra				# Return
		nop
###########################################################################################
# Function to add boundary walls
# Takes none
# Returns none
AddBoundaries:
		lh $a1, stageWidth		# Calculate ending possition
		sll $a1, $a1, 2			# Multiply by 4
		add $a2, $a1, $gp		# Add global pointer
		
		or $a1, $zero, $gp		# Set loop var to global pointer
AddBoundaries_t:	
		sw $s6, ($a1)
		add $a1, $a1, 4
		blt $a1, $a2, AddBoundaries_t
		nop
		

		lh $a1, stageWidth		# Calculate next ending condition
		lh $a2, stageHeight
		multu $a1, $a2			# Multiply screen width by screen height
		nop
		mflo $a2			# Retreive total tiles
		sub $a2, $a2, $a1		# Minus one width
		sll $a2, $a2, 2			# Multiply by 4
		add $a2, $a2, $gp		# Add global pointer
		
		subi $a1, $a1, 1		# Take 1 from width
		sll $a3, $a1, 2			# Multiply by 4 to get mem to add
		
		or $a1, $zero, $gp		# Set loop var to global pointer
AddBoundaries_s:	
		sw $s6, ($a1)
		add $a1, $a1, $a3
		sw $s6, ($a1)
		add $a1, $a1, 4
		blt $a1, $a2, AddBoundaries_s
		nop
		
		or $a3, $zero, $a1		# backup a1 (current possition)
		
		lh $a1, stageWidth		# Calculate final ending possition
		lh $a2, stageHeight
		multu $a1, $a2			# Multiply screen width by screen height
		nop
		mflo $a2			# Retreive total tiles
		sll $a2, $a2, 2			# Multiply by 4
		add $a2, $a2, $gp		# Add global pointer
		
		or $a1, $zero, $a3		# restore previous possition
AddBoundaries_b:
		sw $s6, ($a1)
		add $a1, $a1, 4
		blt $a1, $a2, AddBoundaries_b
		nop

		jr $ra				# Return
		nop
###########################################################################################
# Function to return a viable address for a new peice of food
# Takes none
# Returns v0 = viable address
GetFoodPos:
		lh $a1, stageWidth		# Calculate the max
		lh $a2, stageHeight
		multu $a1, $a2			# Multiply screen width by screen height
		nop
		mflo $a3			# Retreive total tiles
		sub $a3, $a3, 2			# take two for width boundaries
		sub $a3, $a3, $a2		# take two stage widths for height boundaries
		sub $a3, $a3, $a2
		
GetFoodPos_tryAgain:	
		ori $v0, $zero, 42		# use syscall 42 to get a random integer under this number
		ori $a0, $zero, 1
		or $a1, $zero, $a3
		syscall
		
		add $v0, $a0, 1			# add 1 for width border
		add $v0, $v0, $a2		# add a width for height border
		
		sll $v0, $v0, 2			# multiply by 4 for word size
		add $v0, $v0, $gp		# add to global pointer
		
		lw $t0, ($v0)			# Check status of tile chosen at random
		srl $t0, $t0, 24
		bne $t0, 0xFF, GetFoodPos_tryAgain	# Try and find a different spot, this one is taken
		nop
		
		jr $ra				# Return
		nop
###########################################################################################
