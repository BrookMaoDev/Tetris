##############################################################################
# Example: Drawing bash to the screen using the fill_rect fn.
##############################################################################

######################## Bitmap Display Configuration ########################
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
##############################################################################
    .data
ADDR_DSPL:
    .word 0x10008000

    .text
	.globl main

main:
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    li $t1, 0x5e9cff        # $t1 = lighter blue

    # drawing of bash
    # x, y, width, height

stroke1:
    li $a0, 2
    li $a1, 2
    li $a2, 1
    li $a3, 8
    la $v0, stroke2
    j fill_rect

stroke2:
    li $a0, 2
    li $a1, 6
    li $a2, 4
    li $a3, 1
    la $v0, stroke3
    j fill_rect

stroke3:
    li $a0, 2
    li $a1, 10
    li $a2, 4
    li $a3, 1
    la $v0, stroke4
    j fill_rect

stroke4:
    li $a0, 6
    li $a1, 7
    li $a2, 1
    li $a3, 3
    la $v0, stroke5
    j fill_rect

stroke5:
    li $a0, 9
    li $a1, 3
    li $a2, 1
    li $a3, 8
    la $v0, stroke6
    j fill_rect

stroke6:
    li $a0, 13
    li $a1, 3
    li $a2, 1
    li $a3, 8
    la $v0, stroke7
    j fill_rect

stroke7:
    li $a0, 10
    li $a1, 2
    li $a2, 3
    li $a3, 1
    la $v0, stroke8
    j fill_rect

stroke8:
    li $a0, 10
    li $a1, 6
    li $a2, 3
    li $a3, 1
    la $v0, stroke9
    j fill_rect

stroke9:
    li $a0, 17
    li $a1, 2
    li $a2, 4
    li $a3, 1
    la $v0, stroke10
    j fill_rect

stroke10:
    li $a0, 16
    li $a1, 3
    li $a2, 1
    li $a3, 3
    la $v0, stroke11
    j fill_rect

stroke11:
    li $a0, 17
    li $a1, 6
    li $a2, 3
    li $a3, 1
    la $v0, stroke12
    j fill_rect

stroke12:
    li $a0, 20
    li $a1, 7
    li $a2, 1
    li $a3, 3
    la $v0, stroke13
    j fill_rect

stroke13:
    li $a0, 16
    li $a1, 10
    li $a2, 4
    li $a3, 1
    la $v0, stroke14
    j fill_rect

stroke14:
    li $a0, 23
    li $a1, 2
    li $a2, 1
    li $a3, 9
    la $v0, stroke15
    j fill_rect

stroke15:
    li $a0, 27
    li $a1, 2
    li $a2, 1
    li $a3, 9
    la $v0, stroke16
    j fill_rect

stroke16:
    li $a0, 24
    li $a1, 6
    li $a2, 3
    li $a3, 1
    la $v0, stroke17
    j fill_rect

stroke17:
    li $a0, 2
    li $a1, 13
    li $a2, 26
    li $a3, 2
    la $v0, stroke18
    j fill_rect

stroke18:
    li $a0, 8
    li $a1, 15
    li $a2, 14
    li $a3, 3
    la $v0, stroke19
    j fill_rect

stroke19:

# old fill_rect code
    # Paint the second row
    # Start at 256 and paint 128 times?
    
    # start x, start y
    # li $a0, 0
    # li $a1, 0
    # # width, height
    # li $a2, 2
    # li $a3, 2
    # we assume the screen address is in t0 and the colour is in t1

# old impl assumes that start x and start y are multipled by 4
# fill_rect: 
#     sll $a2, $a2, 2 # a2 *= 4 (so it aligns with memory)
#     add $a2, $a2, $a0 # a2 = end x

#     sll 
#     sll $a3, $a3, 2 # repeat for y
#     add $a3, $a3, $a1 # a3 = end y

# # outer_fill_rect_loop:
#     move $t2, $a0 # draw pointer
#     add $t2, $t2, $
# inner_fill_rect_loop:
#     add $t3, $t0, $t2 # mem address to paint
#     sw $t1, 0($t3) # paint

#     addi $t2, $t2, 4 # increment the pointer
#     blt $t2, $a2, inner_fill_rect_loop

exit:
    li $v0, 10              # terminate the program gracefully
    syscall

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
