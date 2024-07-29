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


BACKGROUND_IMAGE: .word 0x00800040, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xffff1fff, 0xfffff013, 0xffff1fff, 0xfffff839, 0xfffe1fff, 0xfffff838, 0xfffe0fff, 0xfffffc38, 0x7ffe07f8, 0xfffffe3c, 0x3ffc0000, 0xfffffe0c, 0x1ffc0000, 0xffffff04, 0x07f80003, 0xffffff00, 0x03f80007, 0xffffff00, 0x70f00003, 0x3fffff80, 0xf8000001, 0x1fffff80, 0xf8000000, 0x07ffff81, 0xfc007fc0, 0x03ffff83, 0xfc00fff8, 0x80ffffc3, 0xfc00fffc, 0xc03fffc3, 0xfe60fffc, 0x8c0fff81, 0x0078fff8, 0x1f81ff80, 0x007cffe0, 0x3fc07f00, 0x007c3fc3, 0x7ff0000c, 0x007e000f, 0x7ff8003e, 0x007f001f, 0xfffc007e, 0x003f003f, 0xffe000fe, 0x0c3f801f, 0x000000fe, 0x1e1f8000, 0x0000007c, 0x1f0f0000, 0x0000001c, 0x1f8001ff, 0x00000000, 0x1f801fff, 0x07e0fc00, 0x1fc07fff, 0x3ff1ff80, 0x1fe07fff, 0xfff3ffe0, 0x1fe0ffff, 0xfff3fff8, 0x1ff0ffff, 0xfff3fffc, 0x0ff1ffff, 0xffe3fffe, 0x0ff1ffff, 0xffc3ffff, 0x87f3ffff, 0x1e03ffff, 0xc3e3ffff, 0x0003ffff, 0xe003ffff, 0x0003ffff, 0xe007ffff, 0xc003ffff, 0xf007ffff, 0xf003ffff, 0xf007ffff, 0xf823ffff, 0xf00fffff, 0xfcf3ffff, 0xe00fffff, 0xf8f3ffff, 0xe00fffff, 0xe1f3ffff, 0xc00fffff, 0x01e3ffff, 0x800fffff, 0x01e3ffff, 0x800ffffe, 0x01c1ffff, 0x000ffff8, 0x0181ffff, 0x3c0fffe0, 0xc001fffc, 0x7f07ff07, 0xe001fff8, 0x7f83f81f, 0xe000fff0, 0x7fc0003f, 0xe000ffc0, 0x7f80007f, 0xe000ff80, 0x7f00007f, 0xe0007e00, 0x7c1f803f, 0xc1c07800, 0x701ff81f, 0x87e00000, 0x001fff07, 0x1ff00000, 0x001fff81, 0x3ff80000, 0x000fffc0, 0x7ffc03fe, 0x0007ffc0, 0xfffc0fff, 0x0003ffc0, 0x7ffc3fff, 0x0001ff80, 0x00003fff, 0x0000ff00, 0x00007fff, 0x07f81c00, 0xfe007fff, 0x0ffe0001, 0xffe03ffe, 0x0fff8001, 0xfffc3ffe, 0x07ffc3e1, 0xfffe3ffc, 0x07ffe3f3, 0xffff1ffc, 0x03fff3f3, 0xffff0ff8, 0x01fff1f3, 0xfffe0ff8, 0x00fff9e3, 0xfff807f0, 0x307ff8e3, 0xfff003f0, 0x383ff843, 0xffe001e0, 0x3e1ff800, 0xff8001c0, 0x3f0ff000, 0xff060000, 0x3f87f080, 0xfc0f000c, 0x3fc1c3e0, 0xf01f801e, 0x3fe007f8, 0xe01fc03e, 0x1fe00ff8, 0x801fe03f, 0x1ff01ffc, 0x003ff07f, 0x0fe03ffe, 0x003ff07f, 0x87e07fff, 0x7c3ff87f, 0x8000ffff, 0xfe3ff83f, 0x8000ffff, 0xfe3ffc1f, 0x8001ffff, 0xfe3ff80f, 0xc003ffff, 0xfe1fe007, 0xc003ffff, 0xfc000003, 0xc007ffff, 0xf80007e0, 0x000fffff, 0xf01e03e0, 0x000fffff, 0xc0ffc3e0, 0x001fffff, 0x83ffe1e0, 0xe01fffff, 0x03fff1c0, 0xf83fffff, 0x01fff08f, 0xfc3fffff, 0xf0fff01f, 0xfc7fffff, 0xfc3ff03f, 0xfc7fffff, 0xfe07e03f, 0xfc7fffff, 0xff00001f, 0xfc7fffff, 0xff00001f, 0xfc7fffff, 0xfe00000f, 0xf87fffff, 0xf8000007, 0xf807fffe, 0xe0383803, 0xf0003ff0, 0x00f83f01, 0xf0000000, 0x03f83fe0, 0x20000000, 0x07f81ff0, 0x00000000, 0x1ffc1ff8, 0x00000000, 0x3ffc0ff8, 0x00000000, 0x3ffc07f8, 0x0003ff00, 0x3ffc01f0, 0x0007ffe0, 0x3ffc0003, 0xf003fff0, 0x1ff8000f, 0xfc03fff0, 0x07f80c1f, 0xff03fff0, 0x00f00c1f, 0xff81ffe0, 0x00001c3f, 0x00000000, 0x00000000, 0x00000000

    .text
	.globl main


main:
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    li $s0, 0

    jal initialize_numeric_symbols

    li $a0, 0
    li $a1, 0
    li $a2, 0x954fff
    la $a3, BACKGROUND_IMAGE
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
