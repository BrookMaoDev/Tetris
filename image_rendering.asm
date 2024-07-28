##############################################################################
# Example: This is to test the image rendering function by drawing an image to the screen.
##############################################################################

######################## Bitmap Display Configuration ########################
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
##############################################################################
    .data
ADDR_DSPL:
    .word 0x10008000

    .eqv SCREEN_WIDTH_IN_UNITS 64

IMAGE_NUMBER_WITH_HOLES: .word 0x00100040, 0x76753737, 0x00000062, 0x41154425, 0x00000055, 0x27373725, 0x00000062, 0x15444125, 0x00000045, 0x17343777, 0x00000042, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000

IMAGE_NUMBER_FILLED: .word 0x00100040, 0x77757737, 0x00000077, 0x41154425, 0x00000055, 0x47777725, 0x00000077, 0x45444125, 0x00000045, 0x47747777, 0x00000047, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000

SYMBOL_ZERO: .word 0x00050003, 0x00007b6f
SYMBOL_ONE: .word 0x00050003, 0x00007493
SYMBOL_TWO: .word 0x00050003, 0x000073e7
SYMBOL_THREE: .word 0x00050003, 0x000079e7
SYMBOL_FOUR: .word 0x00050003, 0x000049ed
SYMBOL_FIVE: .word 0x00050003, 0x000079cf
SYMBOL_SIX: .word 0x00050003, 0x00007bcf
SYMBOL_SEVEN: .word 0x00050003, 0x000012a7
SYMBOL_EIGHT: .word 0x00050003, 0x00007bef
SYMBOL_NINE: .word 0x00050003, 0x000049ef

# to be filled at runtime
SYMBOL_PTR_ARRAY: .word 0:10

LOGO_SHADOW: .word 0x00100010, 0x00800000, 0x02a002a0, 0x00c00000, 0x03c000c0, 0x000003c0, 0x7bde0000, 0x1bd87bde, 0x00001bd8, 0x00000000

BLANK_IMAGE: .word 0x00100010, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff

    .text
	.globl main

main:
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    li $s0, 0

    jal initialize_numeric_symbols

    li $a0, 0
    li $a1, 0
    li $a2, 0x954fff
    la $a3, LOGO_SHADOW
    jal draw_shadow

    li $a1, 16
    li $a2, 0x4fcaff
    la $a3, IMAGE_NUMBER_WITH_HOLES
    jal draw_shadow

    li $a1, 22
    li $a2, 0xe0539c
    la $a3, IMAGE_NUMBER_FILLED
    jal draw_shadow

DRAW_LOOP:
    li $a0, 48
    li $a1, 0
    li $a2, 0x050505
    la $a3, BLANK_IMAGE
    jal draw_shadow

    li $a0, 62
    li $a1, 2
    li $a2, 0x8c34eb
    move $a3, $s0
    jal draw_number

    addi $s0, $s0, 1
    li $v0, 32 # $v0 = 32
    li $a0, 30
    syscall 

    b DRAW_LOOP

exit:
    li $v0, 10              # terminate the program gracefully
    syscall

# Fills the the SYMBOL_PTR_ARRAY with the symbol pointers. Make sure to call this on initilization.
# Arguments:
# ra = return address
# uses registers $t0
initialize_numeric_symbols:
    la $t0, SYMBOL_PTR_ARRAY

    # load the address of the symbol into t1, and then put the address into the ptr array
    la $t1, SYMBOL_ZERO
    sw $t1, 0($t0)
    la $t1, SYMBOL_ONE
    sw $t1, 4($t0)
    la $t1, SYMBOL_TWO
    sw $t1, 8($t0)
    la $t1, SYMBOL_THREE
    sw $t1, 12($t0)
    la $t1, SYMBOL_FOUR
    sw $t1, 16($t0)
    la $t1, SYMBOL_FIVE
    sw $t1, 20($t0)
    la $t1, SYMBOL_SIX
    sw $t1, 24($t0)
    la $t1, SYMBOL_SEVEN
    sw $t1, 28($t0)
    la $t1, SYMBOL_EIGHT
    sw $t1, 32($t0)
    la $t1, SYMBOL_NINE
    sw $t1, 36($t0)

# Displays a number on screen with the top right being the start x and start y.
# 
# Arguments: 
# a0 = end x (modified)
# a1 = start y
# a2 = colour
# a3 = number (modified)
# uses registers t0 to t9, v0, v1
draw_number:
    li $v1, 10 # t0 = 10
    move $v0, $ra # save ra, as we'll be making fn calls. 

DRAW_NUMBER_LOOP:
    # t9 = num/10, t2 = num%10
    div $a3, $v1
    mflo $t9
    mfhi $t2

    addi $a0, $a0, -4 # calculate the start of the letter.
    # draw the letter

    # Get the symbol address. SYMBOL_PTR_ARRAY[num%10]
    la $a3, SYMBOL_PTR_ARRAY
    sll $t2, $t2, 2 # t2 *= 4 as the addr are words
    add $a3, $a3, $t2
    lw $a3, 0($a3)

    # draw the character. All arguments a0 to a3 are set already
    jal draw_shadow

    # load the new value of a4
    move $a3, $t9

    # keep looping while we still have digits to draw.
    bgtz $a3, DRAW_NUMBER_LOOP

    jr $v0


# numbers are 3x5 with a 1px space between them.


# Draws a shadow of a certain colour based on the shadow image onto the board.
# 
# Image format:
# The image consists of words.
# First word is two half words, for width, then height.
# The following words are composed of 32 bits. Each bit represents if the pixel at that position are filled or not.
# 
# Arguments: a0, ..., a3
# ra = return address
# a0 = start x
# a1 = start y
# a2 = colour
# a3 = image address
# uses registers t0 to t8
draw_shadow:
    move $t0, $a3 # t0 = image address

    # the first word of the image is the two half words(width and height)
    lh $t1, 0($t0) # t1 = width of image
    lh $t2, 2($t0) # t2 = height of image

    addi $t0, $t0, 4 # increment image pointer
    lw $t3, 0($t0) # t3 = pixel data/current word of image
    li $t4, 32 # t4 = counter for how many bits we've read of the current word in the image.

    # t7 = screen width (initially), see below 
    li $t7, SCREEN_WIDTH_IN_UNITS # t7 = screen width

    # t5 = screen pointer = 4 * (start_y * screen_width + start_x) + screen_address
    mul $t5, $a1, $t7 # sp = start_y * screen_width
    add $t5, $t5, $a0 # + start_x
    sll $t5, $t5, 2 # sp = 4(start_y * screen_width) + start_x
    lw $t8, ADDR_DSPL
    add $t5, $t5, $t8 # + screen address

    # t7 = 4(screen width - image width) 
    # times 4 so it's the amount of words.
    sub $t7, $t7, $t1
    sll $t7, $t7, 2

OUTER_DRAW_SHADOW_LOOP: 
    move $t6, $t1 # t6 = width_counter = width of image
INNER_DRAW_SHADOW_LOOP:
    andi $t8, $t3, 1 # get the first bit of the image word. 

    # if current px bit isn't 0, draw the colour to the screen.
    beq $t8, $0, SHADOW_PIXEL_EMPTY
    sw $a2, 0($t5)
SHADOW_PIXEL_EMPTY: 
    # move to the next pixel in the word. 
    sra $t3, $t3, 1 # current_word >>= 1
    addi $t4, $t4, -1 # decrement the word bit counter

    # if the bit counter <= 0, then load the next word.
    bgtz $t4, SHADOW_IMAGE_WORD_LOAD_NOT_NEEDED
    addi $t0, $t0, 4 # increment image address to next word
    lw $t3, 0($t0) # load it 
    li $t4, 32 # reset the word bit counter
SHADOW_IMAGE_WORD_LOAD_NOT_NEEDED:

    addi $t6, $t6, -1 # decrement the width of the image
    addi $t5, $t5, 4 # move screen pointer to next pixel
    # while width > 0, keep looping
    bgtz $t6, INNER_DRAW_SHADOW_LOOP

    addi $t2, $t2, -1 # decrement image height
    add $t5, $t5, $t7 # increment the screen pointer to the next row.
    # loop while height > 0
    bgtz $t2, OUTER_DRAW_SHADOW_LOOP

    jr $ra # return
