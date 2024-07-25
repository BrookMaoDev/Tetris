    #####################################################################
    # CSCB58 Summer 2024 Assembly Final Project - UTSC
    # Student1: Brook Mao, Student Number, maofengx, brook.mao@mail.utoronto.ca
    # Student2: Richard Zhang, 1010423276, zha15296, zecro.zhang@mail.utoronto.ca
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
                .word   0x10008000

    # The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:      
                .word   0xffff0000

    # The height of a single unit in pixels.
                .eqv    UNIT_HEIGHT, 4

    # The height of the display in unit heights.
                .eqv    HEIGHT_IN_UNITS, 128

    # The width of a single unit in pixels.
                .eqv    UNIT_WIDTH, 4

    # The width of the display in unit widths.
                .eqv    WIDTH_IN_UNITS, 64
    # log_2(WIDTH_IN_UNITS) - for bitshifting
                .eqv    WIDTH_IN_UNITS_LOG_TWO, 6
    # The width of the display in bytes(ie width in units * 4).
                .eqv    WIDTH_IN_BYTES, 256

    # The height of a grid block in pixels.
                .eqv    GRID_HEIGHT_IN_UNITS, 4
                .eqv    GRID_WIDTH_IN_UNITS, 4
                .eqv    GRID_WIDTH_IN_UNITS_LOG_2, 2

    # Constants defining the top-left corner of the playing area.
                .eqv    PLAYING_AREA_START_X_IN_UNITS, 4
                .eqv    PLAYING_AREA_START_Y_IN_UNITS, 16

    # Constants defining the size of the playing area.
                .eqv    PLAYING_AREA_WIDTH_IN_UNITS, 56
                .eqv    PLAYING_AREA_HEIGHT_IN_UNITS, 108

                .eqv    PLAYING_AREA_WIDTH_IN_BLOCKS, 14
                .eqv    PLAYING_AREA_HEIGHT_IN_BLOCKS, 27

    # Colour constants.
                .eqv    DARK_GREY, 0x7e7e7e
                .eqv    LIGHT_GREY, 0xbcbcbc
                .eqv    TETROMINO_COLOUR, 0x05ffa3

    # The time to sleep between frames in milliseconds.
                .eqv    SLEEP_TIME_IN_MS, 1000

    ##############################################################################
    # Mutable Data
    ##############################################################################

    # Data for the current tetromino(ct) being moved by the player
ct_x:           .word   0
ct_y:           .word   0
ct_colour:      .word   0x05ffa3
    # up to a 4x4 grid. Each block is 1 byte.
    # currently the L piece (todo: change this later)
    # this is rows listed in order
    # 0 means the block is empty, 1 means it's filled
ct_grid:        .byte   0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0
ct_auxiliary_grid: .space 16
ct_grid_size:   .word   3

    ##############################################################################
    # Code
    ##############################################################################
.text   
                .globl  main

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
    li      $a0,            PLAYING_AREA_START_X_IN_UNITS                                   # $a0 = PLAYING_AREA_START_X_IN_UNITS
    li      $a1,            PLAYING_AREA_START_Y_IN_UNITS                                   # $a1 = PLAYING_AREA_START_Y_IN_UNITS
    li      $a2,            GRID_WIDTH_IN_UNITS                                             # $a2 = GRID_WIDTH_IN_UNITS
    li      $a3,            GRID_HEIGHT_IN_UNITS                                            # $a3 = GRID_HEIGHT_IN_UNITS
    la      $t0,            ADDR_DSPL                                                       # $t0 = ADDR_DSPL
    lw      $t0,            0($t0)                                                          # $t0 = *ADDR_DSPL
    li      $t1,            LIGHT_GREY                                                      # $t1 = LIGHT_GREY

    # Calculate the rightmost x coordinate of the playing area
    addi    $s0,            $a0,                            PLAYING_AREA_WIDTH_IN_UNITS     # $s0 = $a0 + PLAYING_AREA_WIDTH_IN_UNITS

    # Calculate the bottommost y coordinate of the playing area
    addi    $s1,            $a1,                            PLAYING_AREA_HEIGHT_IN_UNITS    # $s1 = $a1 + PLAYING_AREA_HEIGHT_IN_UNITS

DRAW_ROWS_LOOP: 
    bge     $a1,            $s1,                            END_DRAW_PLAYING_AREA           # if $a1 >= $s1 then goto END_DRAW_PLAYING_AREA

DRAW_ROW_LOOP:  
    bge     $a0,            $s0,                            END_DRAW_ROW                    # if $a0 >= $s0 then goto END_DRAW_ROW

    # Draw a light grey square iff the current x and y coordinates are both odd or both even

    # Divide x by GRID_WIDTH_IN_UNITS
    div     $a0,            $a2                                                             # $a0 / $a2
    mflo    $t2                                                                             # $t2 = floor($a0 / $a2)

    # Divide y by GRID_HEIGHT_IN_UNITS
    div     $a1,            $a3                                                             # $a1 / $a3
    mflo    $t3                                                                             # $t3 = floor($a1 / $a3)

    # Check if x and y are both odd or both even
    andi    $t2,            $t2,                            1                               # $t2 = $a0 & 1
    andi    $t3,            $t3,                            1                               # $t3 = $a1 & 1
    bne     $t2,            $t3,                            DRAW_DARK_GREY_SQUARE           # if $t2 != $t3 then goto DRAW_DARK_GREY_SQUARE

DRAW_LIGHT_GREY_SQUARE:
    li      $t1,            LIGHT_GREY                                                      # $t1 = LIGHT_GREY
    j       DRAW_SQUARE                                                                     # jump to DRAW_SQUARE

DRAW_DARK_GREY_SQUARE:
    li      $t1,            DARK_GREY                                                       # $t1 = DARK_GREY

DRAW_SQUARE:    
    jal     fill_rect                                                                       # fill_rect(PLAYING_AREA_HEIGHT_IN_UNITS, PLAYING_AREA_START_Y_IN_UNITS, GRID_WIDTH_IN_UNITS, GRID_HEIGHT_IN_UNITS, ADDR_DSPL, LIGHT_GREY)

    # Restore modified registers
    li      $a3,            GRID_HEIGHT_IN_UNITS                                            # $a3 = GRID_HEIGHT_IN_UNITS

INCREMENT_X:    
    # Shift x to the right by GRID_WIDTH_IN_UNITS
    addi    $a0,            $a0,                            GRID_WIDTH_IN_UNITS             # $a0 = $a0 + GRID_WIDTH_IN_UNITS

    j       DRAW_ROW_LOOP                                                                   # jump to DRAW_ROW_LOOP

END_DRAW_ROW:   
    # Move x back to the left and move y down by GRID_HEIGHT_IN_UNITS
    li      $a0,            PLAYING_AREA_START_X_IN_UNITS                                   # $a0 = PLAYING_AREA_START_X_IN_UNITS
    addi    $a1,            $a1,                            GRID_HEIGHT_IN_UNITS            # $a1 = $a1 + GRID_HEIGHT_IN_UNITS

    j       DRAW_ROWS_LOOP                                                                  # jump to DRAW_ROWS_LOOP

END_DRAW_PLAYING_AREA:
DRAW_TETROMINOS:
    # Draw the current tetromino (ct).

    # set the colour argument to tetromino colour
    li      $t1,            TETROMINO_COLOUR
    # s0 = length and width of the tetromino grid
    lw      $s0,            ct_grid_size
    # s1 = array representing tetromino piece
    la      $s1,            ct_grid
    # s5 = x position of tetromino on the grid
    lw      $s5,            ct_x
    # s6 = y position of tetromino on the grid
    lw      $s6,            ct_y
    # s3 = row of ct grid
    li      $s3,            0
OUTER_DRAW_CT_LOOP:
    # s4 = column of ct grid
    li      $s4,            0
INNER_DRAW_CT_LOOP:
    # s2 = temp value for item in ct grid
    lb      $s2,            0($s1)                                                          # s2 = ct_grid[s1]

    # continue if this block is not part of the ct
    beq     $s2,            $0,                             INNER_DRAW_CT_LOOP_FINAL

    # start_x = col + grid_x
    add     $a0,            $s4,                            $s5
    # start_y = row + grid_y
    add     $a1,            $s3,                            $s6
    jal     draw_tblock
INNER_DRAW_CT_LOOP_FINAL:
    addi    $s4,            $s4,                            1                               # col ++
    addi    $s1,            $s1,                            1                               # move ct grid pointer to next byte

    # loop inner loop again while col < gt_len
    blt     $s4,            $s0,                            INNER_DRAW_CT_LOOP

    addi    $s3,            $s3,                            1                               # rows ++
    blt     $s3,            $s0,                            OUTER_DRAW_CT_LOOP              # loop outer while rows < gt_len

    jal rotate_ct_cw # rotate the piece clockwise :)
    # Todo: draw the rest of the placed tetrominos.

    # 4. Sleep
    li      $v0,            32                                                              # $v0 = 32
    li      $a0,            SLEEP_TIME_IN_MS                                                # $a0 = SLEEP_TIME_IN_MS
    syscall                                                                                 # syscall(32, SLEEP_TIME_IN_MS)

    # 5. Go back to 1
    b       game_loop

# Rotates current tetromino clockwise.
# Algorithm: 
#   Consider a 2 by 2 matrix A. 
#   Let matrix B be A rotated clockwise by 90 deg.
#   We can create by by reading every row of A starting from the top,
#   into every column of B starting from the right.
#   Ie A = [1, 2: 3, 4], we read the first row into the last column of
#   B = [x, 1: x, 2] then we read the next row of A into the previous
#   column of B. So B = [3, 1; 2, 4] This generalizes to n by n matrices.
#   As the array is stored in a continuous block of memory,
#   we can just have two pointers for A and B.
#   The pointer for A goes from 0 to n^2.
#   The pointer for B needs to start at n-1 and then jump by n each time. 
#   Upon exiting the bounds of the array, it needs to go back to n-2, and n-3 the next time and so on...
# 
# Arguments: 
# ra = return address
# uses registers s0 to s6, t7
rotate_ct_cw: 
    # s0 = matrix length (n)
    lw $s0, ct_grid_size
    # s1 = starting location for pointer of B, initially 
    add $s1, $s0, -1
    # s2 = n^2
    mul $s2, $s0, $s0
    # s3 = pointer for A
    li $s3, 0
    # s4 = pointer for B
    move $s4, $s1
    # s5 = offset A
    la $s5, ct_grid
    # s6 = offset B
    la $s6, ct_auxiliary_grid
ROTATE_CW_LOOP:
    # get A's address
    add $t8, $s3, $s5
    # load the value from A
    lb $t7, 0($t8)

    # get B's address
    add $t8, $s4, $s6
    # copy the value into B
    sb $t7, 0($t8)

    # increment pointers
    addi $s3, $s3, 1
    add $s4, $s4, $s0 # ptrB += n

    # if ptrB < n^2, skip
    blt $s4, $s2, ROTATE_NO_OVERFLOW
    # s1 -- and set ptr B back in bounds
    addi $s1, $s1, -1
    move $s4, $s1
ROTATE_NO_OVERFLOW:
    blt $s3, $s2, ROTATE_CW_LOOP # while ptr A < n^2

    # copy data back
    li $s1, 0
AUXILIARY_COPY_BACK_LOOP:
    # get value from B
    add $t8, $s1, $s6
    lb $t7, 0($t8)
    # copy the value into A
    add $t8, $s1, $s5
    sb $t7, 0($t8)
    addi $s1, $s1, 1
    blt $s1, $s2, AUXILIARY_COPY_BACK_LOOP

    jr $ra # return


    # a0 = grid x (modified)
    # a1 = grid y (modified)
    # ra = return address
    # uses registers v0 + registers needed for fill_rect
draw_tblock:    
    # a0 = grid_x * GRID_WIDTH_IN_UNITS + PLAYING_AREA_START_X_IN_UNITS
    sll     $a0,            $a0,                            GRID_WIDTH_IN_UNITS_LOG_2
    add     $a0,            $a0,                            PLAYING_AREA_START_X_IN_UNITS

    # a1 = same computations for x but for y
    # grid and unit are assumed to be squares
    sll     $a1,            $a1,                            GRID_WIDTH_IN_UNITS_LOG_2
    add     $a1,            $a1,                            PLAYING_AREA_START_Y_IN_UNITS

    # load the width/height of the grid blocks
    li      $a2,            GRID_WIDTH_IN_UNITS
    li      $a3,            GRID_HEIGHT_IN_UNITS

    # save the return address and call fill_rect
    move    $v0,            $ra
    jal     fill_rect

    # return to caller
    move    $ra,            $v0
    jr      $v0


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
    sll     $t2,            $a1,                            WIDTH_IN_UNITS_LOG_TWO          # a1 * 32
    add     $t2,            $t2,                            $a0                             # a0 + 32a1
    sll     $t2,            $t2,                            2                               # 4(a0 + 32a1)
    add     $t2,            $t2,                            $t0

outer_fill_rect_loop:
    # t3 = pointer of x
    move    $t3,            $t2
    # t4 = copy of width (so we can decrease it in a loop)
    move    $t4,            $a2

inner_fill_rect_loop:
    sw      $t1,            0($t3)                                                          # draw pixel
    addi    $t3,            $t3,                            4                               # move x pointer
    addi    $a2,            $a2,                            -1                              # decrease width
    bgtz    $a2,            inner_fill_rect_loop

    # outer loop end
    addi    $t2,            $t2,                            WIDTH_IN_BYTES                  # increment the y pointer to the next line (this is the start x position)
    addi    $a3,            $a3,                            -1                              # decrease height
    move    $a2,            $t4                                                             # restore the width
    bgtz    $a3,            outer_fill_rect_loop

    # link back to the program
    jr      $ra
