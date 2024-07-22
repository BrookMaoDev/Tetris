#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Name, Student Number, UTorID, official email
# Student2: Name, Student Number, UTorID, official email
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed) 
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
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
	# 4. Sleep

    #5. Go back to 1
    b game_loop

# arguments: a0 to a3, v0 and t0, t1
# a0 = start x
# a1 = start y
# a2 = width
# a3 = height (modified)
# v0 = return address (pc)
# t0 = screen location 
# t1 = colour
# uses registers t2, t3, t4
fill_rect: 
    # t2 = pointer of y
    # t2 = 4(start_x + 32 start_y) + display_offset
    # t2 = 4(a0 + 32a1) + t0
    sll $t2, $a1, 5 # a1 * 32
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
    addi $t2, $t2, 128 # increment the y pointer to the next line(this is the start x position)
    addi $a3, $a3, -1 # decrease height
    move $a2, $t4 # restore the width
    bgtz $a3, outer_fill_rect_loop

    # link back to the program
    jr $v0
