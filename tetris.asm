#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Name, Student Number, UTorID, official email
# Student2: Name, Student Number, UTorID, official email
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed) 
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 512 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# Hard Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# How to play:
# (Include any instructions)
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################

# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000

# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

# The height of a single unit in pixels.
.eqv UNIT_HEIGHT 4

# The height of the display in unit heights.
.eqv HEIGHT_IN_UNITS 128

# The width of a single unit in pixels.
.eqv UNIT_WIDTH 4

# The width of the display in unit widths.
.eqv WIDTH_IN_UNITS 64

# The height of the display in pixels.
.eqv GRID_HEIGHT_IN_UNITS 4
.eqv GRID_WIDTH_IN_UNITS 4

# Constants defining the top-left corner of the playing area.
.eqv PLAYING_AREA_START_X_IN_UNITS 4
.eqv PLAYING_AREA_START_Y_IN_UNITS 4

# Constants defining the size of the playing area.
.eqv PLAYING_AREA_WIDTH_IN_UNITS 56
.eqv PLAYING_AREA_HEIGHT_IN_UNITS 120

# Colour constants.
.eqv DARK_GREY 0x7e7e7e
.eqv LIGHT_GREY 0xbcbcbc

# The time to sleep between frames in milliseconds.
.eqv SLEEP_TIME_IN_MS 1000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    # Initialize the game

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen

DRAW_SCREEN:
    # Draw the checkered pattern
    li		$a0, PLAYING_AREA_START_X_IN_UNITS		# $a0 = PLAYING_AREA_START_X_IN_UNITS
    li		$a1, PLAYING_AREA_START_Y_IN_UNITS		# $a1 = PLAYING_AREA_START_Y_IN_UNITS
    li		$a2, GRID_WIDTH_IN_UNITS                # $a2 = GRID_WIDTH_IN_UNITS
    li		$a3, GRID_HEIGHT_IN_UNITS               # $a3 = GRID_HEIGHT_IN_UNITS
    la		$t0, ADDR_DSPL							# $t0 = ADDR_DSPL
    lw		$t0, 0($t0)                             # $t0 = *ADDR_DSPL
    li		$t1, LIGHT_GREY							# $t1 = LIGHT_GREY

    # Calculate the rightmost x coordinate of the playing area
    addi	$s0, $a0, PLAYING_AREA_WIDTH_IN_UNITS			# $s0 = $a0 + PLAYING_AREA_WIDTH_IN_UNITS

    # Calculate the bottommost y coordinate of the playing area
    addi	$s1, $a1, PLAYING_AREA_HEIGHT_IN_UNITS		    # $s1 = $a1 + PLAYING_AREA_HEIGHT_IN_UNITS

DRAW_ROWS_LOOP:
    bge		$a1, $s1, END_DRAW_PLAYING_AREA	        # if $a1 >= $s1 then goto END_DRAW_PLAYING_AREA

DRAW_ROW_LOOP:
    bge		$a0, $s0, END_DRAW_ROW	# if $a0 >= $s0 then goto END_DRAW_ROW

    # Draw a light grey square iff the current x and y coordinates are both odd or both even

    # Divide x by GRID_WIDTH_IN_UNITS
    div		$a0, $a2			# $a0 / $a2
    mflo	$t2					# $t2 = floor($a0 / $a2)
    
    # Divide y by GRID_HEIGHT_IN_UNITS
    div		$a1, $a3			# $a1 / $a3
    mflo	$t3					# $t3 = floor($a1 / $a3)     
    
    # Check if x and y are both odd or both even
    andi	$t2, $t2, 1							# $t2 = $a0 & 1
    andi	$t3, $t3, 1							# $t3 = $a1 & 1
    bne		$t2, $t3, DRAW_DARK_GREY_SQUARE     # if $t2 != $t3 then goto DRAW_DARK_GREY_SQUARE

DRAW_LIGHT_GREY_SQUARE:
    li		$t1, LIGHT_GREY                     # $t1 = LIGHT_GREY
    j		DRAW_SQUARE				            # jump to DRAW_SQUARE

DRAW_DARK_GREY_SQUARE:
    li		$t1, DARK_GREY							# $t1 = DARK_GREY

DRAW_SQUARE:
    jal		fill_rect								# fill_rect(PLAYING_AREA_HEIGHT_IN_UNITS, PLAYING_AREA_START_Y_IN_UNITS, GRID_WIDTH_IN_UNITS, GRID_HEIGHT_IN_UNITS, ADDR_DSPL, LIGHT_GREY)

    # Restore modified registers
    li		$a3, GRID_HEIGHT_IN_UNITS               # $a3 = GRID_HEIGHT_IN_UNITS

INCREMENT_X:
    # Shift x to the right by GRID_WIDTH_IN_UNITS
    addi	$a0, $a0, GRID_WIDTH_IN_UNITS			# $a0 = $a0 + GRID_WIDTH_IN_UNITS

    j		DRAW_ROW_LOOP                           # jump to DRAW_ROW_LOOP
    
END_DRAW_ROW:
    # Move x back to the left and move y down by GRID_HEIGHT_IN_UNITS
    li		$a0, PLAYING_AREA_START_X_IN_UNITS		# $a0 = PLAYING_AREA_START_X_IN_UNITS
    addi	$a1, $a1, GRID_HEIGHT_IN_UNITS			# $a1 = $a1 + GRID_HEIGHT_IN_UNITS
    
    j		DRAW_ROWS_LOOP                          # jump to DRAW_ROWS_LOOP

END_DRAW_PLAYING_AREA:

	# 4. Sleep
    li		$v0, 32		# $v0 = 32
    li		$a0, SLEEP_TIME_IN_MS		# $a0 = SLEEP_TIME_IN_MS
    syscall		# syscall(32, SLEEP_TIME_IN_MS)

    #5. Go back to 1
    b game_loop

# arguments: a0 to a3, v0 and t0, t1
# a0 = start x
# a1 = start y
# a2 = width
# a3 = height (modified)
# ra = return address (pc)
# t0 = screen location 
# t1 = colour
# uses registers t2, t3, t4
fill_rect: 
    # t2 = pointer of y
    # t2 = 4(start_x + 32 start_y) + display_offset
    # t2 = 4(a0 + 32a1) + t0
    sll $t2, $a1, 6 # a1 * 32
    add $t2, $t2, $a0 # a0 + 32a1
    sll $t2, $t2, 2 # 4(a0 + 32a1)
    add $t2, $t2, $t0

outer_fill_rect_loop:
    # t3 = pointer of x
    move $t3, $t2
    # t4 = copy of width (so we can decrease it in a loop)
    move $t4, $a2

inner_fill_rect_loop:
    sw $t1, 0($t3) # draw pixel
    addi $t3, $t3, 4 # move x pointer
    addi $a2, $a2, -1 # decrease width
    bgtz $a2, inner_fill_rect_loop

# outer loop end
    addi $t2, $t2, 256 # increment the y pointer to the next line (this is the start x position)
    addi $a3, $a3, -1 # decrease height
    move $a2, $t4 # restore the width
    bgtz $a3, outer_fill_rect_loop

    # link back to the program
    jr $ra
