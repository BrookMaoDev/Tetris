    #####################################################################
    # CSCB58 Summer 2024 Assembly Final Project - UTSC
    # Student1: Brook Mao, brook.mao@mail.utoronto.ca
    # Student2: Richard Zhang, zecro.zhang@mail.utoronto.ca
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
    # - Milestone 5 
    #
    # Which approved features have been implemented?
    # (See the assignment handout for the list of features)
    # Easy Features:
    # 1. Gravity
    # 2. Game over screen with retry option.
    # 3. Paused screen with message.
    # 4. High score is tracked and displayed, right below score.
    # 5. Each tetromino type has a unique colour.
    # Hard Features:
    # 1. Tracks and displays the score
    # 2. Full set of tetrominoes
    # How to play:
    # When the game is running, press: 
    #   w - rotate 90 deg clockwise
    #   a - move left
    #   s - move the piece down 4 times as fast
    #   d - move right
    #   p - pause the game
    #   q - quit the game
    #   Note: movement and rotation only works, when you're not moving/rotating into a wall or another piece.
    # 
    # On the pause screen, you can press p to unpause.
    #   No other keys are handled on this screen.
    # Similarly on game over screen, you can only press r to restart.
    #
    # Additional notes:
    #   - You are able to input up to two key inputs per frame.
    #   - The gravity increases to 2x after you reach a score of 250.
    #   
    #
    # Link to video demonstration for final submission:
    # - https://drive.google.com/file/d/1N3wIOPEDyp6KBRZz34mmNHntH7qf-alu/view?usp=sharing
    #       
    # Are you OK with us sharing the video with people outside course staff?
    # - yes
    #       
    # Any additional information that the TA needs to know:
    # N/A
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
    .eqv UNIT_HEIGHT, 4

    # The height of the display in unit heights.
    .eqv HEIGHT_IN_UNITS, 128

    # The width of a single unit in pixels.
    .eqv UNIT_WIDTH, 4

    # The width of the display in unit widths.
    .eqv WIDTH_IN_UNITS, 64
    # log_2(WIDTH_IN_UNITS) - for bitshifting
    .eqv WIDTH_IN_UNITS_LOG_TWO, 6
    # The width of the display in bytes(ie width in units * 4).
    .eqv WIDTH_IN_BYTES, 256

    # The height of a grid block in pixels.
    .eqv GRID_HEIGHT_IN_UNITS, 4
    .eqv GRID_WIDTH_IN_UNITS, 4
    .eqv GRID_WIDTH_IN_UNITS_LOG_2, 2

    .eqv GRID_CENTER_WIDTH_IN_UNITS 2
    .eqv GRID_CENTER_HEIGHT_IN_UNITS 2

    # Constants of the screen, for image drawing
    .eqv SCREEN_WIDTH_IN_UNITS 64
    .eqv SCREEN_AREA_IN_UNITS 8192

    # Constants defining the top-left corner of the playing area.
    .eqv PLAYING_AREA_START_X_IN_UNITS, 4
    .eqv PLAYING_AREA_START_Y_IN_UNITS, 16

    # Constants defining the size of the playing area.
    .eqv PLAYING_AREA_WIDTH_IN_UNITS, 56
    .eqv PLAYING_AREA_HEIGHT_IN_UNITS, 108

    .eqv PLAYING_AREA_WIDTH_IN_BLOCKS, 14
    .eqv PLAYING_AREA_HEIGHT_IN_BLOCKS, 27

    # Colour constants.
    .eqv DARK_GREY, 0x7e7e7e
    .eqv LIGHT_GREY, 0xbcbcbc

    # The time to sleep between ticks in milliseconds.
    .eqv SLEEP_TIME_IN_MS, 50
    .eqv TICKS_PER_FRAME, 2

    .eqv MMIO_KEY_PRESSED_STATUS, 0xffff0000
    .eqv MMIO_KEY_PRESSED_VALUE, 0xffff0004

    .eqv SPEED_UP_GRAVITY_AFTER_SCORE, 250

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
BACKGROUND_IMAGE: .word 0x00800040, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xffff1fff, 0xfffff013, 0xffff1fff, 0xfffff839, 0xfffe1fff, 0xfffff838, 0xfffe0fff, 0xfffffc38, 0x7ffe07f8, 0xfffffe3c, 0x3ffc0000, 0xfffffe0c, 0x1ffc0000, 0xffffff04, 0x07f80003, 0xffffff00, 0x03f80007, 0xffffff00, 0x70f00003, 0x3fffff80, 0xf8000001, 0x1fffff80, 0xf8000000, 0x07ffff81, 0xfc007fc0, 0x03ffff83, 0xfc00fff8, 0x80ffffc3, 0xfc00fffc, 0xc03fffc3, 0xfe60fffc, 0x8c0fff81, 0x0078fff8, 0x1f81ff80, 0x007cffe0, 0x3fc07f00, 0x007c3fc3, 0x7ff0000c, 0x007e000f, 0x7ff8003e, 0x007f001f, 0xfffc007e, 0x003f003f, 0xffe000fe, 0x0c3f801f, 0x000000fe, 0x1e1f8000, 0x0000007c, 0x1f0f0000, 0x0000001c, 0x1f8001ff, 0x00000000, 0x1f801fff, 0x07e0fc00, 0x1fc07fff, 0x3ff1ff80, 0x1fe07fff, 0xfff3ffe0, 0x1fe0ffff, 0xfff3fff8, 0x1ff0ffff, 0xfff3fffc, 0x0ff1ffff, 0xffe3fffe, 0x0ff1ffff, 0xffc3ffff, 0x87f3ffff, 0x1e03ffff, 0xc3e3ffff, 0x0003ffff, 0xe003ffff, 0x0003ffff, 0xe007ffff, 0xc003ffff, 0xf007ffff, 0xf003ffff, 0xf007ffff, 0xf823ffff, 0xf00fffff, 0xfcf3ffff, 0xe00fffff, 0xf8f3ffff, 0xe00fffff, 0xe1f3ffff, 0xc00fffff, 0x01e3ffff, 0x800fffff, 0x01e3ffff, 0x800ffffe, 0x01c1ffff, 0x000ffff8, 0x0181ffff, 0x3c0fffe0, 0xc001fffc, 0x7f07ff07, 0xe001fff8, 0x7f83f81f, 0xe000fff0, 0x7fc0003f, 0xe000ffc0, 0x7f80007f, 0xe000ff80, 0x7f00007f, 0xe0007e00, 0x7c1f803f, 0xc1c07800, 0x701ff81f, 0x87e00000, 0x001fff07, 0x1ff00000, 0x001fff81, 0x3ff80000, 0x000fffc0, 0x7ffc03fe, 0x0007ffc0, 0xfffc0fff, 0x0003ffc0, 0x7ffc3fff, 0x0001ff80, 0x00003fff, 0x0000ff00, 0x00007fff, 0x07f81c00, 0xfe007fff, 0x0ffe0001, 0xffe03ffe, 0x0fff8001, 0xfffc3ffe, 0x07ffc3e1, 0xfffe3ffc, 0x07ffe3f3, 0xffff1ffc, 0x03fff3f3, 0xffff0ff8, 0x01fff1f3, 0xfffe0ff8, 0x00fff9e3, 0xfff807f0, 0x307ff8e3, 0xfff003f0, 0x383ff843, 0xffe001e0, 0x3e1ff800, 0xff8001c0, 0x3f0ff000, 0xff060000, 0x3f87f080, 0xfc0f000c, 0x3fc1c3e0, 0xf01f801e, 0x3fe007f8, 0xe01fc03e, 0x1fe00ff8, 0x801fe03f, 0x1ff01ffc, 0x003ff07f, 0x0fe03ffe, 0x003ff07f, 0x87e07fff, 0x7c3ff87f, 0x8000ffff, 0xfe3ff83f, 0x8000ffff, 0xfe3ffc1f, 0x8001ffff, 0xfe3ff80f, 0xc003ffff, 0xfe1fe007, 0xc003ffff, 0xfc000003, 0xc007ffff, 0xf80007e0, 0x000fffff, 0xf01e03e0, 0x000fffff, 0xc0ffc3e0, 0x001fffff, 0x83ffe1e0, 0xe01fffff, 0x03fff1c0, 0xf83fffff, 0x01fff08f, 0xfc3fffff, 0xf0fff01f, 0xfc7fffff, 0xfc3ff03f, 0xfc7fffff, 0xfe07e03f, 0xfc7fffff, 0xff00001f, 0xfc7fffff, 0xff00001f, 0xfc7fffff, 0xfe00000f, 0xf87fffff, 0xf8000007, 0xf807fffe, 0xe0383803, 0xf0003ff0, 0x00f83f01, 0xf0000000, 0x03f83fe0, 0x20000000, 0x07f81ff0, 0x00000000, 0x1ffc1ff8, 0x00000000, 0x3ffc0ff8, 0x00000000, 0x3ffc07f8, 0x0003ff00, 0x3ffc01f0, 0x0007ffe0, 0x3ffc0003, 0xf003fff0, 0x1ff8000f, 0xfc03fff0, 0x07f80c1f, 0xff03fff0, 0x00f00c1f, 0xff81ffe0, 0x00001c3f, 0x00000000, 0x00000000, 0x00000000

SCORE_TEXT: .word 0x00050015, 0xa2277777, 0x1dd45e2a, 0x77789a8a, 0x00000075
HI_SCORE_TEXT: .word 0x00050009, 0x289e4a75, 0x00000759
PAUSE_TEXT: .word 0x000a0032, 0xf8c63e1f, 0x8c8cf9f8, 0x60663319, 0xcc663235, 0xc8e18180, 0x06033198, 0xc6632386, 0x7e19f878, 0x638319fc, 0x66303860, 0xe1819c0c, 0x603198c0, 0x63038606, 0x58198cfe, 0xe1f18c0d, 0x0003e7e3 
PRESS_P_TO_TEXT: .word 0x0007002b, 0x38319de7, 0x52294b9c, 0x4a624242, 0x12120211, 0x70633bcf, 0x20461890, 0x50c48084, 0x24042522, 0x20c67486, 0x00000e20
UNPAUSE_TEXT: .word 0x00070024, 0x645e7451, 0x45294d1e, 0x52955129, 0xe7551214, 0x1651e645, 0x65128452, 0x4e294521, 0x0e639214
GAME_OVER_TEXT: .word 0x00070032, 0xf0f6379e, 0x528def44, 0x85142055, 0x81494818, 0xee621450, 0xd1423d25, 0x1414a17b, 0x84a14508, 0xa4205052, 0x4149e4a4, 0x22f18f0f
PRESS_R_TO_TEXT: .word 0x0007002b, 0x38319de7, 0x52294b9c, 0x4a624242, 0x12120211, 0x70633bcf, 0x20461890, 0x50c48284, 0x24242522, 0x20c67486, 0x00000e21
RESTART_TEXT: .word 0x0007001f, 0xf3bdcce7, 0x52524914, 0xe929208a, 0x5477919c, 0x4a2a4902, 0xa5252491, 0x00929233

L_TETROMINO: .byte 
    0, 1, 0,
    0, 1, 0,
    0, 1, 1, 0, 0, 0, 0, 0, 0, 0
J_TETROMINO: .byte 
    0, 1, 0, 
    0, 1, 0,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0
I_TETROMINO: .byte 
    0, 1, 0, 0,
    0, 1, 0, 0,
    0, 1, 0, 0,
    0, 1, 0, 0
O_TETROMINO: .byte 
    1, 1,
    1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
S_TETROMINO: .byte 
    0, 1, 1,
    1, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0
T_TETROMINO: .byte 
    1, 1, 1,
    0, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0
Z_TETROMINO: .byte 
    1, 1, 0,
    0, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    .eqv TETROMINO_COUNT, 7
TETROMINO_PTR_ARRAY: .word 0:7 # to be initialized at run time.
TETROMINO_SIZE_ARRAY: .byte 3, 3, 4, 2, 3, 3, 3
TETROMINO_COLOUR_ARRAY: .word 0x9ee4ff, 0x0008ff, 0xd9ff00, 0x82ffc1, 0xba82ff, 0xb02020, 0xff00a6

    ##############################################################################
    # Mutable Data
    ##############################################################################

    # Data for the current tetromino(ct) being moved by the player

# these values are set at runtime.
ct_x: .word 0
ct_y: .word 0
ct_colour: .word 0
ct_colour_index: .word 0 # index of the colour in the array PLUS 1
    # up to a 4x4 grid. Each block is 1 byte.
    # currently the L piece (todo: change this later)
    # this is rows listed in order
    # 0 means the block is empty, 1 means it's filled
ct_grid: .byte 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0
ct_auxiliary_grid: .space 16
ct_grid_size: .word 3
    # Grid of all tetromino blocks which have been placed.
tetromino_grid: .byte 0:378
    .eqv TETROMINO_GRID_LEN, 378
# there might be memory corruption happening here... unable to reproduce though.
score: .word 0 
high_score: .word 0
# 0 = running, 1 = paused, 2 = game over
game_state: .word 0

# buffer to copy the frame into (screen size). This is to prevent flickering.
frame_buffer: .word 0:SCREEN_AREA_IN_UNITS
# load this with the amount of key presses allowed per frame. This is to make movement easier so the user can move multiple times per frame.
ticks_per_frame: .word 4

    ##############################################################################
    # Code
    ##############################################################################
.text 
                    .globl main

    # Run the Tetris game.
main: 
    # Initialize the game
    jal initialize_numeric_symbols # load ptr into number array
    jal initialize_tetromino_ptr_array # load tetromino ptr values into lookup array.
    jal spawn_new_tetromino # create the first tetromino onto memory.  

    # draw the background
    li $a0, 0
    li $a1, 0
    li $a2, 0x525252
    la $a3, BACKGROUND_IMAGE
    jal draw_shadow

    # draw the game logo
    li $a0, 0
    li $a1, 0
    li $a2, 0x0044ff
    la $a3, LOGO_SHADOW
    jal draw_shadow

    # draw the score text
    li $a0, 17
    li $a1, 1
    li $a2, 0xffffff
    la $a3, SCORE_TEXT
    jal draw_shadow

    # draw the high score text
    li $a0, 17
    li $a1, 7
    li $a2, 0xffffff
    la $a3, HI_SCORE_TEXT
    jal draw_shadow

game_loop: 
    # 1a. Check if key has been pressed
    li $t0, MMIO_KEY_PRESSED_STATUS # $t0 = MMIO_KEY_PRESSED_STATUS
    lw $t1, 0($t0) # $t1 = *MMIO_KEY_PRESSED_STATUS
    # t1 stores 1 if a key has been pressed
    # it will be checked later in the run state.
    lw $t0, 4($t0) # $t0 = *MMIO_KEY_PRESSED_VALUE
    # t0 stores the ascii value of the key pressed

    # check if the game is in the paused state
    # check if the game is in the game over state
    lw $t2, game_state # t2 = game state
    beq $t2, $0, RUN_STATE
    beq $t2, 2, GAME_OVER_STATE

PAUSED_STATE:
    bne $t1, 1, NO_KEY_PRESSED_PAUSED_STATE
    # check if p is pressed, to unpause.
    beq $t0, 0x70, P_PRESSED_PAUSED_STATE
NO_KEY_PRESSED_PAUSED_STATE:
    # otherwise, draw shadow with start x, start y, colour, image ptr
    li $a0, 7
    li $a1, 36
    li $a2, 0x000000
    la $a3, PAUSE_TEXT
    jal draw_shadow

    li $a0, 11
    li $a1, 55
    la $a3, PRESS_P_TO_TEXT
    jal draw_shadow

    li $a0, 14
    li $a1, 65
    la $a3, UNPAUSE_TEXT
    jal draw_shadow

    j FINALIZE_FRAME_AND_SLEEP # complete the frame and sleep. 
P_PRESSED_PAUSED_STATE:
    # unpause and go to the game. (set game_state to 0)
    sw $0, game_state

    # set to no key pressed so we don't pause immediately
    li $t1, 0

    j RUN_STATE

GAME_OVER_STATE:
    bne $t1, 1, NO_KEY_PRESSED_GAME_OVER_STATE
    # check if r is pressed, restart.
    beq $t0, 0x72, R_PRESSED_GAME_OVER_STATE
NO_KEY_PRESSED_GAME_OVER_STATE: 
    # display the game over message.
    # draw shadow with start x, start y, colour, image ptr
    li $a0, 7
    li $a1, 36
    li $a2, 0x000000
    la $a3, GAME_OVER_TEXT
    jal draw_shadow

    li $a0, 11
    li $a1, 55
    la $a3, PRESS_R_TO_TEXT
    jal draw_shadow

    li $a0, 14
    li $a1, 65
    la $a3, RESTART_TEXT
    jal draw_shadow

    j FINALIZE_FRAME_AND_SLEEP # complete the frame and sleep. 
R_PRESSED_GAME_OVER_STATE:
    # restart the game.
    jal reset_game

    j RUN_STATE

RUN_STATE:
    # if no key pressed. 
    bne $t1, 1, NO_KEY_PRESSED

    # save the current tetromino position in s0, s1 so it can be undone.
    lw $s0, ct_x
    lw $s1, ct_y

    beq $t0, 0x70, P_PRESSED_RUN_STATE # if $t0 == 'p' then pause the game
    beq $t0, 0x77, W_PRESSED # if $t0 == 'w' then goto W_PRESSED
    beq $t0, 0x61, A_PRESSED # if $t0 == 'a' then goto A_PRESSED
    beq $t0, 0x64, D_PRESSED # if $t0 == 'd' then goto D_PRESSED
    beq $t0, 0x73, S_PRESSED # if $t0 == 's' then goto S_PRESSED
    beq $t0, 0x71, Q_PRESSED # if $t0 == 'q' then goto Q_PRESSED
    j NO_KEY_PRESSED # if no relevant key pressed

P_PRESSED_RUN_STATE:
    # pause the game. 
    # set the state(ie game_state = 0)
    li $a0, 1
    sw $a0, game_state

    # set to no key pressed so we don't pause run immediately
    li $t1, 0

    # draw the paused text.
    j PAUSED_STATE
W_PRESSED: 
    # rotate the current tetromino clockwise
    jal rotate_ct_cw
    # Attempt to bound it if being rotated up against a wall.
    jal bound_ct_horizontally
    # Check if it's colliding anything after being bounded, If so, this move needs to be cancelled. 
    jal ct_is_colliding # v0 = 1 means colliding

    bne $v0, 1, MOVE_IS_LEGAL # no collision (see comment below)
    
    # undo this move.
    # undo movement
    sw $s0, ct_x
    sw $s1, ct_y
    # undo rotation
    jal rotate_ct_cw
    jal rotate_ct_cw
    jal rotate_ct_cw

    j MOVE_IS_LEGAL # skip the no key pressed since we don't need to preform collision check again.

A_PRESSED: 
    jal move_left # move the current tetromino left
    j NO_KEY_PRESSED # jump to NO_KEY_PRESSED

D_PRESSED: 
    jal move_right # move the current tetromino right
    j NO_KEY_PRESSED # jump to NO_KEY_PRESSED

S_PRESSED: 
    # Make the tetromino move down 4 blocks. These 3 + gravity.
    jal move_down
    jal move_down
    jal move_down

    # v0 is set to 0 if it's not colliding from the collision check in move_down. If no collision, add 1 point to the score
    bne $v0, $0, NO_EXTRA_MOVE_DOWN_POINT
    lw $t0, score
    addi $t0, $t0, 1
    sw $t0, score
    j NO_KEY_PRESSED # jump to NO_KEY_PRESSED

Q_PRESSED:
    # exit the game
    li		$v0, 10		# $v0 = 10
    syscall

NO_EXTRA_MOVE_DOWN_POINT:

    j NO_KEY_PRESSED # jump to NO_KEY_PRESSED

NO_KEY_PRESSED: 

    # 2a. Check for collisions
    jal ct_is_colliding # v0 = 1 means colliding

    # if v0 = 1, then cancel the previous move.
    beq $v0, $0, MOVE_IS_LEGAL
    sw $s0, ct_x
    sw $s1, ct_y
MOVE_IS_LEGAL:
    # check if we want to draw the frame, or sleep and let the user continue moving
    lw $t0, ticks_per_frame

    # if we've let the user move enough, continue
    beq $t0, $0, CONTINUE_TO_PHYSICS_AND_DRAW_FRAME
    # otherwise, decrement pointer, and sleep
    addi $t0, $t0, -1
    sw $t0, ticks_per_frame
    j SLEEP_UNTIL_NEXT_FRAME

CONTINUE_TO_PHYSICS_AND_DRAW_FRAME:
    # reset the ticks counter
    li $t0, TICKS_PER_FRAME
    SW $t0, ticks_per_frame

    # Physics
    # Apply gravity
    jal move_down # move the current tetromino down

    li $a2, SPEED_UP_GRAVITY_AFTER_SCORE
    lw $a3, score
    bge $a3, $a2, SCORE_TOO_HIGH # if score >= SPEED_UP_GRAVITY_AFTER_SCORE then goto SCORE_TOO_HIGH
    j SCORE_NORMAL # goto SCORE_NORMAL

SCORE_TOO_HIGH:
    jal move_down # The score is too high, difficulty is increased by moving the tetromino down faster.

SCORE_NORMAL:
    jal clear_lines # clear any lines that are full

    # 3. Draw the screen
DRAW_SCREEN:
    # Draw the checkered pattern
    li $a0, PLAYING_AREA_START_X_IN_UNITS # $a0 = PLAYING_AREA_START_X_IN_UNITS
    li $a1, PLAYING_AREA_START_Y_IN_UNITS # $a1 = PLAYING_AREA_START_Y_IN_UNITS
    li $a2, GRID_WIDTH_IN_UNITS # $a2 = GRID_WIDTH_IN_UNITS
    li $a3, GRID_HEIGHT_IN_UNITS # $a3 = GRID_HEIGHT_IN_UNITS
    la $t0, frame_buffer # $t0 = ADDR_DSPL
    li $t1, LIGHT_GREY # $t1 = LIGHT_GREY

    # Calculate the rightmost x coordinate of the playing area
    addi $s0, $a0, PLAYING_AREA_WIDTH_IN_UNITS # $s0 = $a0 + PLAYING_AREA_WIDTH_IN_UNITS

    # Calculate the bottommost y coordinate of the playing area
    addi $s1, $a1, PLAYING_AREA_HEIGHT_IN_UNITS # $s1 = $a1 + PLAYING_AREA_HEIGHT_IN_UNITS

DRAW_ROWS_LOOP: 
    bge $a1, $s1, END_DRAW_PLAYING_AREA # if $a1 >= $s1 then goto END_DRAW_PLAYING_AREA

DRAW_ROW_LOOP: 
    bge $a0, $s0, END_DRAW_ROW # if $a0 >= $s0 then goto END_DRAW_ROW

    # Draw a light grey square iff the current x and y coordinates are both odd or both even,
    # or draw a square of the tetromino colour if the current x and y coordinates are part of a placed tetromino.

    # Calculate the x and y coordinates of the current grid block in blocks excluding the left and top margins for the playing area.
    li $t6, PLAYING_AREA_START_X_IN_UNITS # $t6 = PLAYING_AREA_START_X_IN_UNITS
    sub $t6, $a0, $t6 # $t6 = $a0 - $t6

    li $t7, PLAYING_AREA_START_Y_IN_UNITS # $t7 = PLAYING_AREA_START_Y_IN_UNITS
    sub $t7, $a1, $t7 # $t7 = $a1 - $t7

    div $t6, $a2 # $t6 / $a2
    mflo $t6 # $t6 = floor($t6 / $a2)

    div $t7, $a3 # $t7 / $a3
    mflo $t7 # $t7 = floor($t7 / $a3)

    # Divide x by GRID_WIDTH_IN_UNITS
    div $a0, $a2 # $a0 / $a2
    mflo $t2 # $t2 = floor($a0 / $a2)

    # Divide y by GRID_HEIGHT_IN_UNITS
    div $a1, $a3 # $a1 / $a3
    mflo $t3 # $t3 = floor($a1 / $a3)

    la $t4, tetromino_grid # $t4 = &tetromino_grid
    li $t5, PLAYING_AREA_WIDTH_IN_BLOCKS # $t5 = PLAYING_AREA_WIDTH_IN_BLOCKS
    mult $t7, $t5 # $t7 * $t5 = Hi and Lo registers
    mflo $t7 # copy Lo to $t7
    add $t7, $t7, $t6 # $t7 = $t7 + $t6
    add $t4, $t4, $t7 # $t4 = $t4 + $t3
    lb $t4, 0($t4) # $t4 = tetromino_grid[t4]

    # Check if the current x and y coordinates are part of a placed tetromino
    beq $t4, $zero, DRAW_CHECKERED_SQARE # if $t4 == $zero then goto DRAW_CHECKERED_SQARE
    j DRAW_TETROMINO_COLOR_SQUARE # jump to DRAW_TETROMINO_COLOR_SQUARE

DRAW_CHECKERED_SQARE:
    # Check if x and y are both odd or both even
    andi $t2, $t2, 1 # $t2 = $a0 & 1
    andi $t3, $t3, 1 # $t3 = $a1 & 1
    bne $t2, $t3, DRAW_DARK_GREY_SQUARE # if $t2 != $t3 then goto DRAW_DARK_GREY_SQUARE

DRAW_LIGHT_GREY_SQUARE:
    li $t1, LIGHT_GREY # $t1 = LIGHT_GREY
    j DRAW_SQUARE # jump to DRAW_SQUARE

DRAW_DARK_GREY_SQUARE:
    li $t1, DARK_GREY # $t1 = DARK_GREY
    j DRAW_SQUARE # jump to DRAW_SQUARE

DRAW_TETROMINO_COLOR_SQUARE:
    # t4 = colour address of current tetromino = (t4 - 1) * 4 + colour_array_ptr 
    addi $t4, $t4, -1 # -1 since the grid indices are offset by 1.
    sll $t4, $t4, 2
    la $t1, TETROMINO_COLOUR_ARRAY
    add $t4, $t4, $t1

    # load the colour value into t1
    lw $t1, 0($t4)

    # draw a specific tetromino block
    jal draw_tblock

    li $a3, GRID_HEIGHT_IN_UNITS # inc like below (since we're skipping that block)
    j INCREMENT_X

DRAW_SQUARE: 
    jal fill_rect # fill_rect(PLAYING_AREA_HEIGHT_IN_UNITS, PLAYING_AREA_START_Y_IN_UNITS, GRID_WIDTH_IN_UNITS, GRID_HEIGHT_IN_UNITS, ADDR_DSPL, LIGHT_GREY)

    # Restore modified registers
    li $a3, GRID_HEIGHT_IN_UNITS # $a3 = GRID_HEIGHT_IN_UNITS

INCREMENT_X: 
    # Shift x to the right by GRID_WIDTH_IN_UNITS
    addi $a0, $a0, GRID_WIDTH_IN_UNITS # $a0 = $a0 + GRID_WIDTH_IN_UNITS

    j DRAW_ROW_LOOP # jump to DRAW_ROW_LOOP

END_DRAW_ROW: 
    # Move x back to the left and move y down by GRID_HEIGHT_IN_UNITS
    li $a0, PLAYING_AREA_START_X_IN_UNITS # $a0 = PLAYING_AREA_START_X_IN_UNITS
    addi $a1, $a1, GRID_HEIGHT_IN_UNITS # $a1 = $a1 + GRID_HEIGHT_IN_UNITS

    j DRAW_ROWS_LOOP # jump to DRAW_ROWS_LOOP

END_DRAW_PLAYING_AREA:
DRAW_TETROMINOS: 
    # Draw the current tetromino (ct).

    # set the colour argument to tetromino colour
    lw $t1, ct_colour
    # s0 = length and width of the tetromino grid
    lw $s0, ct_grid_size
    # s1 = array representing tetromino piece
    la $s1, ct_grid
    # s5 = x position of tetromino on the grid
    lw $s5, ct_x
    # s6 = y position of tetromino on the grid
    lw $s6, ct_y
    # s3 = row of ct grid
    li $s3, 0
OUTER_DRAW_CT_LOOP: 
    # s4 = column of ct grid
    li $s4, 0
INNER_DRAW_CT_LOOP: 
    # s2 = temp value for item in ct grid
    lb $s2, 0($s1) # s2 = ct_grid[s1]

    # continue if this block is not part of the ct
    beq $s2, $0, INNER_DRAW_CT_LOOP_FINAL

    # start_x = col + grid_x
    add $a0, $s4, $s5
    # a0 = grid_x * GRID_WIDTH_IN_UNITS + PLAYING_AREA_START_X_IN_UNITS
    sll $a0, $a0, GRID_WIDTH_IN_UNITS_LOG_2
    add $a0, $a0, PLAYING_AREA_START_X_IN_UNITS

    # start_y = row + grid_y
    add $a1, $s3, $s6
    # a1 = same computations for x but for y
    # grid and unit are assumed to be squares
    sll $a1, $a1, GRID_WIDTH_IN_UNITS_LOG_2
    add $a1, $a1, PLAYING_AREA_START_Y_IN_UNITS

    # load the width/height of the grid blocks
    li $a2, GRID_WIDTH_IN_UNITS
    li $a3, GRID_HEIGHT_IN_UNITS
    jal draw_tblock
INNER_DRAW_CT_LOOP_FINAL:
    addi $s4, $s4, 1 # col ++
    addi $s1, $s1, 1 # move ct grid pointer to next byte

    # loop inner loop again while col < gt_len
    blt $s4, $s0, INNER_DRAW_CT_LOOP

    addi $s3, $s3, 1 # rows ++
    blt $s3, $s0, OUTER_DRAW_CT_LOOP # loop outer while rows < gt_len

    # Draw the score.
    # First, find how long the score is.
    lw $t0, score
    li $t1, 0
    li $t2, 10
    # count how many times score can be divided by 10 to get the digit count
SCORE_LENGTH_COUNTER_LOOP:
    div $t0, $t2
    mflo $t0
    addi $t1, $t1, 1
    bgtz $t0, SCORE_LENGTH_COUNTER_LOOP

    # t1 *= 4 so t1 = length of score text, since every letter is 3x5 and there is a space in between.
    sll $t1, $t1, 2

    # start at (39, 1)
    # fill the rect to overwrite the previous score.
    # call it with arguments: 
    move $a2, $t1 # width
    la $t0, frame_buffer # ptr to screen
    li $t1, 0x0 # black 
    li $a0, 39 # start x
    li $a1, 1 # start y
    li $a3, 5 # height
    jal fill_rect

    # draw the score.
    addi $a0, $a2, 39 # end x = width + 39
    li $a1, 1 # start y
    li $a2, 0xffffff # colour 
    lw $a3, score # number to draw
    jal draw_number

    # do the same but for high score.
    lw $t0, high_score
    lw $t1, score # need to restore this from before.

    # update high score if score is higher
    # if score <= high score, no update needed.
    ble $t1, $t0, NO_HIGH_SCORE_UPDATE_NEEDED
    move $t0, $t1
    sw $t0, high_score
NO_HIGH_SCORE_UPDATE_NEEDED:

    # Find length of high score.
    li $t1, 0
    li $t2, 10
    # count how many times score can be divided by 10 to get the digit count
HIGH_SCORE_LENGTH_COUNTER_LOOP:
    div $t0, $t2
    mflo $t0
    addi $t1, $t1, 1
    bgtz $t0, HIGH_SCORE_LENGTH_COUNTER_LOOP

    sll $t1, $t1, 2

    # start at (27, 7)
    # fill the rect to overwrite the previous high score.
    # call w/ args: 
    move $a2, $t1 # width
    la $t0, frame_buffer # ptr to screen
    li $t1, 0x0 # black 
    li $a0, 27 # start x
    li $a1, 7 # start y
    li $a3, 5 # height
    jal fill_rect

    # draw the score.
    addi $a0, $a2, 27 # end x = width + 27
    li $a1, 7 # start y
    li $a2, 0xffffff # colour 
    lw $a3, high_score # number to draw
    jal draw_number

FINALIZE_FRAME_AND_SLEEP:
    # copy the frame buffer on screen
    lw $t0, ADDR_DSPL # t0 = display address.
    la $t1, frame_buffer # t1 = frame buffer address

    # t2 = pixel count
    li $t2, SCREEN_AREA_IN_UNITS

FRAME_DRAW_LOOP:
    # copy word from buffer to display
    lw $t3, 0($t1)
    sw $t3, 0($t0)

    # inc pointers
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    # decrement loop iterator
    addi $t2, $t2, -1

    # loop while there are pixels remaining
    bgtz $t2, FRAME_DRAW_LOOP

SLEEP_UNTIL_NEXT_FRAME:
    # 4. Sleep
    li $v0, 32 # $v0 = 32
    li $a0, SLEEP_TIME_IN_MS # $a0 = SLEEP_TIME_IN_MS
    syscall # syscall(32, SLEEP_TIME_IN_MS)

    # 5. Go back to 1
    b game_loop

    # Rotates current tetromino clockwise.
    # Algorithm:
    #   Consider a 2 by 2 matrix A.
    #   Let matrix B be A rotated clockwise by 90 deg.
    #   We can create by by reading every row of A starting from the top,
    #   into every column of B starting from the right.
    #   Ie A = [1, 2; 3, 4], we read the first row into the last column of
    #   B = [x, 1; x, 2] then we read the next row of A into the previous
    #   column of B. So B = [3, 1; 2, 4] This generalizes to n by n matrices.
    #   As the array is stored in a continuous block of memory,
    #   we can just have two pointers for A and B.
    #   The pointer for A goes from 0 to n^2.
    #   The pointer for B needs to start at n-1 and then jump by n each time.
    #   Upon exiting the bounds of the array, it needs to go back to n-2, and n-3 the next time and so on...
    #       
    # Arguments:
    # ra = return address
    # uses registers t0 to t6, t7
rotate_ct_cw: 
    # t0 = matrix length (n)
    lw $t0, ct_grid_size
    # t1 = starting location for pointer of B, initially
    add $t1, $t0, -1
    # t2 = n^2
    mul $t2, $t0, $t0
    # t3 = pointer for A
    li $t3, 0
    # t4 = pointer for B
    move $t4, $t1
    # t5 = offset A
    la $t5, ct_grid
    # t6 = offset B
    la $t6, ct_auxiliary_grid
ROTATE_CW_LOOP: 
    # get A's address
    add $t8, $t3, $t5
    # load the value from A
    lb $t7, 0($t8)

    # get B's address
    add $t8, $t4, $t6
    # copy the value into B
    sb $t7, 0($t8)

    # increment pointers
    addi $t3, $t3, 1
    add $t4, $t4, $t0 # ptrB += n

    # if ptrB < n^2, skip
    blt $t4, $t2, ROTATE_NO_OVERFLOW
    # t1 -- and set ptr B back in bounds
    addi $t1, $t1, -1
    move $t4, $t1
ROTATE_NO_OVERFLOW: 
    blt $t3, $t2, ROTATE_CW_LOOP # while ptr A < n^2

    # copy data back
    li $t1, 0
AUXILIARY_COPY_BACK_LOOP:
    # get value from B
    add $t8, $t1, $t6
    lb $t7, 0($t8)
    # copy the value into A
    add $t8, $t1, $t5
    sb $t7, 0($t8)
    addi $t1, $t1, 1
    blt $t1, $t2, AUXILIARY_COPY_BACK_LOOP

    jr $ra # return

    # Places the tetromino block back in bounds based on the pixels.
    # Arguments:
    # ra = return address
    # uses registers t0 to t9
bound_ct_horizontally:
    lw $t0, ct_x # t0 = current tetromino x
    la $t1, ct_grid # t1 = grid address
    lw $t2, ct_grid_size # t2 = grid size (n)
    mul $t3, $t2, $t2 # t3 = n^2
    # t4 = playing area width in blocks
    li $t4, PLAYING_AREA_WIDTH_IN_UNITS
    sra $t4, $t4, GRID_WIDTH_IN_UNITS_LOG_2 # so it's measured in blocks and not units
    li $t5, 0 # t5 = x
OUTER_HORIZONTAL_COLLISION_LOOP:
    # addi $t4, $t4, -1 # start y --
    move $t6, $t5 # t6 = pointer of the grid (not really y)
    li $t7, 0 # t7 = occurences of blocks in this column
INNER_HORIZONTAL_COLLISION_LOOP:
    # check if the grid block at the current x, y is occupied.
    # t8 = (grid[pointer] > 0)
    add $t8, $t6, $t1 # t8 = grid pointer + grid mem addr
    lb $t8, 0($t8)
    slt $t8, $0, $t8 # t8 = 0 < t8

    # if t8 > 0, occurences ++
    add $t7, $t7, $t8

    add $t6, $t6, $t2 # y += n

    # loop while y < n^2
    blt $t6, $t3, INNER_HORIZONTAL_COLLISION_LOOP

    # if occurences > 0, do the following
    beq $t7, $0, NO_GRID_BLOCK_ON_BOUNDS_CHECK
    add $t9, $t0, $t5 # x' = position of the block on the board, ie ct_x + x

    # if x' < 0, then ct_x = -x (back in bounds from the left)
    ble $0, $t9, NOT_OUT_OF_LEFT_BOUNDS
    sub $t0, $0, $t5
NOT_OUT_OF_LEFT_BOUNDS:
    # if x' >= grid width, ct_x = grid width - x - 1 (back in bounds on the right)
    blt $t9, $t4, NOT_OUT_OF_RIGHT_BOUNDS
    sub $t0, $t4, $t5
    addi $t0, $t0, -1
NOT_OUT_OF_RIGHT_BOUNDS:
NO_GRID_BLOCK_ON_BOUNDS_CHECK:
    addi $t5, $t5, 1 # x ++
    # loop while x < n
    blt $t5, $t2, OUTER_HORIZONTAL_COLLISION_LOOP

    # assign the new in bounds ct_x value.
    sw $t0, ct_x

    jr $ra

ct_is_colliding:
    # Putting doc comments in here.
    # Arguments:
    # 
    # Returns: v0
    # uses registers t0 to t8, a0, a1

    li $t0, PLAYING_AREA_WIDTH_IN_BLOCKS # t0 = playing area width
    li $t1, PLAYING_AREA_HEIGHT_IN_BLOCKS # t1 = playing area height
    lw $t2, ct_grid_size # t2 = ct grid size 
    lw $t3, ct_x # t3 = ct x
    lw $t4, ct_y # t4 = ct y
    la $t5, ct_grid # t5 = ct grid address

    # t6 = 4(ct_y * board_width + ct_x) + address
    mul $t6, $t4, $t0 
    add $t6, $t6, $t3 
    # sll $t6, $t6, 2 # add back after colour is added
    la $t8, tetromino_grid
    add $t6, $t6, $t8

    # t7 = 4(board_width - grid_width)
    sub $t7, $t0, $t2
    # sll $t7, $t7, 2 # add back after color update

    li $a0, 0 # a0 = y

CT_COLLIDING_OUTER_LOOP:
    li $a1, 0 # a1 = x
    lw $t3, ct_x # t3 = ct x

CT_COLLIDING_INNER_LOOP:
    # if the current ct grid has a block(ie > 0), then
    lb $t8, 0($t5)
    blez $t8, CT_COLLIDING_INNER_LOOP_END
    
    # if ct_x < 0 or ct_y < 0 or board_width <= ct_x or board_height <= ct_y, return colliding
    blt $t3, 0, COLLISION_OUT_OF_BOUNDS
    blt $t4, 0, COLLISION_OUT_OF_BOUNDS
    ble $t0, $t3, COLLISION_OUT_OF_BOUNDS
    ble $t1, $t4, COLLISION_OUT_OF_BOUNDS
    j COLLISION_IN_BOUNDS # otherwise, continue checking
COLLISION_OUT_OF_BOUNDS:
    # set return value to colliding and return
    li $v0, 1
    jr $ra
COLLISION_IN_BOUNDS:
    # check if the tetromino grid has a block occupying this coordinate.
    # lw $t8, 0($t6) #word?
    lb $t8, 0($t6) # fix after colour update

    # if this unit is occupied, return collidin
    beq $t8, $0, COLLISION_UNIT_NOT_OCCUPIED
    li $v0, 1
    jr $ra
COLLISION_UNIT_NOT_OCCUPIED:
CT_COLLIDING_INNER_LOOP_END:
    # increment x, c_x, grid_ptr, board_pointer (in that order)
    addi $a1, $a1, 1
    addi $t3, $t3, 1
    addi $t5, $t5, 1
    # addi $t6, $t6, 4 # 4?
    addi $t6, $t6, 1 # remove on colour update

    # loop while x < n
    blt $a1, $t2, CT_COLLIDING_INNER_LOOP

    # increment c_y, y
    addi $t4, $t4, 1
    addi, $a0, $a0, 1

    # board pointer needs to be incremented by (board_width - n) to get to the starting x of the next loop.
    add $t6, $t6, $t7

    # loop while y < n
    blt $a0, $t2, CT_COLLIDING_OUTER_LOOP

    li $v0, 0
    jr $ra

    # arguments for fill rect(but make sure it's a sqaure)
    # ra = return address
    # uses registers v0 + registers needed for fill_rect
draw_tblock:
    # save ra to stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # save tetromino colour to stack
    addi $sp, $sp, -4
    sw $t1, 0($sp)

    # See colour change algorithm below. 
    # Shifting down is similar but simpler.
    li $t4, 0x00fefefe # t4 = val used to remove all last bits(of each colour)

    # t1 = (r, g, b) of t1 / 2
    and $t1, $t1, $t4
    sra $t1, $t1, 1

    # fill the entire square with the darker colour
    jal fill_rect

    # draw the center square normal coloured.
    # restore colour from stack
    lw $t1, 0($sp) # this will be decremented below
    # add 1 to x,y to move it right and down
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    # set width/height
    li $a2, GRID_CENTER_WIDTH_IN_UNITS
    li $a3, GRID_CENTER_HEIGHT_IN_UNITS

    jal fill_rect

    # restore the changed x,y
    addi $a0, $a0, -1
    addi $a1, $a1, -1

    # restore colour again (this is decremented later)
    lw $t1, 0($sp)

    # Change the tetromino colour to be 2x brighter. 
    # Algorithm is to multiply each colour code by 2 and cap it at 0xff.
    # To achieve this, for each colour code 0xff, we'll take the first bit,
    # then "sign extend" and save it in t3.
    # The original colour, we will remove all the first bits, and then shift right(so no overflows).
    # Then we use an or operation to make the colour code max if it had a first bit, since 128*2 > 255 = 0xff
    li $t4, 0x00808080 # t4 = val used to get all first bits
    and $t2, $t1, $t4 # t2 = colour & first bits

    li $t4, 0x007f7f7f # opposite of above to get all BUT the first bit
    and $t1, $t1, $t4 # remove first bits from colour
    sll $t1, $t1, 1 # x2

    # "sign extend" t2
    sll $t3, $t2, 1
    or $t2, $t2, $t3

    sll $t3, $t2, 2
    or $t2, $t2, $t3

    sll $t3, $t2, 4
    or $t2, $t2, $t3

    # update the colour so values above 128 are multiplied correctly
    or $t1, $t1, $t2

    # draw the two lighter shade colours.
    # width = tetromino size, height = 1
    li $a2, GRID_WIDTH_IN_UNITS
    li $a3, 1
    jal fill_rect

    # draw the vertical lighter shade
    li $a2, 1
    li $a3, GRID_HEIGHT_IN_UNITS
    jal fill_rect

    # restore modified width
    li $a2, GRID_WIDTH_IN_UNITS

    # final restore colour
    lw $t1, 0($sp)
    addi $sp, $sp, 4
    # restore ra 
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra


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
    sll $t2, $a1, WIDTH_IN_UNITS_LOG_TWO # a1 * 32
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
    addi $t2, $t2, WIDTH_IN_BYTES # increment the y pointer to the next line (this is the start x position)
    addi $a3, $a3, -1 # decrease height
    move $a2, $t4 # restore the width
    bgtz $a3, outer_fill_rect_loop

    # link back to the program
    jr $ra

    # Move the current tetromino left.
    # Uses registers t0, t1 and modifies ct_x
move_left: 
    # Load the current x position of the tetromino.
    la $t0, ct_x # $t0 = &ct_x
    lw $t1, 0($t0) # $t0 = ct_x

    # Move it left.
SHFIT_LEFT: 
    addi $t1, $t1, -1 # $t1--
    sw $t1, 0($t0) # ct_x = $t1

    jr $ra

    # Move the current tetromino right.
    # Uses registers t0 - t3 and modifies ct_x
move_right: 
    # Load the current x position of the tetromino.
    la $t0, ct_x # $t0 = &ct_x
    lw $t1, 0($t0) # $t0 = ct_x

    # Move it right.
SHIFT_RIGHT: 
    addi $t1, $t1, 1 # $t1++
    sw $t1, 0($t0) # ct_x = $t1

    jr $ra

    # Move the current tetromino down.
    # Uses registers t0 - t3 and modifies ct_y
move_down: 
    # Load the current y position of the tetromino.
    la $t0, ct_y # $t0 = &ct_y
    lw $t1, 0($t0) # $t1 = ct_y
    addi $t1, $t1, 1 # $t1++

    addi $sp, $sp, -4 # inc stack.
    sw $ra, 0($sp) # add ra to the stack.

    # save modified ct_y
    sw $t1, ct_y

    # check if it's colliding with something.
    jal ct_is_colliding
    bne $v0, $0, HIT_BOTTOM # v0 = 1 means it's colliding, so goto STORE_TETROMINO

    # Move the tetromino down.
SHIFT_DOWN: 
    j MOVE_DOWN_END # jump to MOVE_DOWN_END

HIT_BOTTOM: 
    # undo the modification of ct_y
    lw $t1, ct_y
    addi $t1, $t1, -1
    sw $t1, ct_y # ct_y = $t1

    jal save_tetromino # jump to save_tetromino and save position to $ra
    jal spawn_new_tetromino # jump to spawn_new_tetromino and spawn a new tetromino

MOVE_DOWN_END: 
    lw $ra, 0($sp) # restore $ra from stack
    addi $sp, $sp, 4 # $sp = $sp - 1

    jr $ra # return

    # Store the current tetromino in the tetromino grid.
    # Uses registers t0 - t8
save_tetromino: 
    lw $t0, ct_x # $t0 = ct_x
    lw $t1, ct_y # $t1 = ct_y
    lw $t2, ct_grid_size # $t2 = ct_grid_size
    li $t3, PLAYING_AREA_WIDTH_IN_BLOCKS # $t3 = PLAYING_AREA_WIDTH_IN_BLOCKS
    la $t4, ct_grid # $t4 = &ct_grid
    la $t5, tetromino_grid # $t5 = &tetromino_grid

    # The counter for the current row of the current tetromino grid.
    li $t6, 0 # $t6 = 0

LOOP_THROUGH_CURRENT_TETROMINO_ROWS:
    # Calculate the starting index to store the current tetromino in the tetromino grid.
    lw $t0, ct_x # $t0 = ct_x
    add $t8, $t1, $t6 # $t1 = $t1 + $t6
    mult $t8, $t3 # $t1 * $t3 = Hi and Lo registers
    mflo $t8 # copy Lo to $t1
    add $t8, $t8, $t0 # $t1 = $t1 + $t0

    # Now $t8 is the starting index to store the current tetromino in the tetromino grid.

    la $t5, tetromino_grid # $t5 = &tetromino_grid
    add $t5, $t5, $t8 # $t5 = $t5 + $t8

    # The counter for the current column of the current tetromino grid.
    li $t0, 0 # $t0 = 0

LOOP_THROUGH_CURRENT_TETROMINO_ROW:
    lb $t7, 0($t4) # $t7 = ct_grid[t4]
    beq $t7, $zero, AFTER_SAVED_BLOCK # if $t7 == $zero then goto AFTER_SAVED_BLOCK

SAVE_BLOCK: 
    # save the colour index to the grid.
    lw $t7, ct_colour_index
    sb $t7, 0($t5) # $t5 = tetromino_grid[t5]

AFTER_SAVED_BLOCK: 
    addi $t4, $t4, 1 # $t4++
    addi $t5, $t5, 1 # $t5++

    addi $t0, $t0, 1 # $t0 = $t0 + 1
    bge $t0, $t2, END_LOOP_THROUGH_CURRENT_TETROMINO_ROW # if $t0 >= $t2 then goto END_LOOP_THROUGH_CURRENT_TETROMINO_ROW
    j LOOP_THROUGH_CURRENT_TETROMINO_ROW # jump to LOOP_THROUGH_CURRENT_TETROMINO_ROW

END_LOOP_THROUGH_CURRENT_TETROMINO_ROW:
    addi $t6, $t6, 1 # $t6 = $t6 + 1
    bge $t6, $t2, END_LOOP_THROUGH_CURRENT_TETROMINO_ROWS # if $t6 >= $t2 then goto END_LOOP_THROUGH_CURRENT_TETROMINO_ROWS
    j LOOP_THROUGH_CURRENT_TETROMINO_ROWS # jump to LOOP_THROUGH_CURRENT_TETROMINO_ROWS

END_LOOP_THROUGH_CURRENT_TETROMINO_ROWS:
    jr $ra # return

spawn_new_tetromino:
    # generate the random number
    li $v0, 42
    li $a0, 0
    li $a1, TETROMINO_COUNT
    syscall

    # save the offset index into colour index
    # colour_index = (a0 + 1) since 0 denotes no tetromino.
    addi $t0, $a0, 1
    sw $t0, ct_colour_index

    # set the current tetromino size before we *4 to v0 for the offset on word arrays.
    la $t0, TETROMINO_SIZE_ARRAY
    add $t0, $t0, $a0
    lb $t3, 0($t0) # t3 = ct_size 
    sw $t3, ct_grid_size

    sll $a0, $a0, 2 # so v0 is the byte offset of the tetromino arr

    # load in our new tetromino
    la $t0, TETROMINO_PTR_ARRAY
    add $t0, $t0, $a0 # increment to our tetromino position
    lw $t0, 0($t0) # this is the address of the tetromino grid.

    la $t1, ct_grid # destination

    # unrolled loop for copying
    # the byte grid's len is a multiple of 4, so we can copy words at a time.
    # load tetrmonio word, then place into ct_grid. Loop for 4 iterations.
    lw $t2, 0($t0)
    sw $t2, 0($t1)
    lw $t2, 4($t0)
    sw $t2, 4($t1)
    lw $t2, 8($t0)
    sw $t2, 8($t1)
    lw $t2, 12($t0)
    sw $t2, 12($t1)

    # load in the new colour.
    la $t0, TETROMINO_COLOUR_ARRAY
    add $t0, $t0, $a0 # increment to our colour
    # copy to ct_colour
    lw $t1, 0($t0)
    sw $t1, ct_colour

    # compute the center of the grid, and put it in t2 (for use updating the positions)
    # t2 = (width - ct_size)/2
    li $t2, PLAYING_AREA_WIDTH_IN_BLOCKS
    sub $t2, $t2, $t3 # t2 = width - ct_size
    sra $t2, $t2, 1 # div 2
    
    # update the positions.
    la $t0, ct_x # $t0 = &ct_x
    la $t1, ct_y # $t1 = &ct_y
    li $t3, 0 # $t3 = 0
    sw $t2, 0($t0) # $t2 = ct_x
    sw $t3, 0($t1) # $t3 = ct_y

    # Check for collisions. If there is a collision, it's game over.
    # push ra to stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal ct_is_colliding # v0 = 0 means not colliding
    
    # load ra back from the stack.
    lw $ra, 0($sp)
    addi $sp, $sp, 4

# if not colliding
beq $v0, $0, SPAWN_TETROMINO_SUCCESS
    # otherwise, game over

    # set state to game over.
    li $t0, 2
    sw $t0, game_state

    j DRAW_SCREEN # have the game advance one more frame in the run state.

SPAWN_TETROMINO_SUCCESS: 
    jr $ra # return


# Fills the TETROMINO_PTR_ARRAY with pointers to the tetromino grids.
initialize_tetromino_ptr_array:
    la $t0, TETROMINO_PTR_ARRAY

    # load the address into t1, then put it into the array at the right offset.
    la $t1, L_TETROMINO
    sw $t1, 0($t0)
    la $t1, J_TETROMINO
    sw $t1, 4($t0)
    la $t1, I_TETROMINO
    sw $t1, 8($t0)
    la $t1, O_TETROMINO
    sw $t1, 12($t0)
    la $t1, S_TETROMINO
    sw $t1, 16($t0)
    la $t1, T_TETROMINO
    sw $t1, 20($t0)
    la $t1, Z_TETROMINO
    sw $t1, 24($t0)


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
    la $t8, frame_buffer
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

# Detects if a line is full and if so, clears it.
# Uses registers t0 to t5 and $ra
clear_lines:
    # What row we are currently checking
    li		$t0, 0		# $t0 = 0
    li		$t2, PLAYING_AREA_WIDTH_IN_BLOCKS		# $t2 = PLAYING_AREA_WIDTH_IN_BLOCKS
    li		$t5, PLAYING_AREA_HEIGHT_IN_BLOCKS		# $t5 = PLAYING_AREA_HEIGHT_IN_BLOCKS

LOOP_THROUGH_ROWS_TO_CLEAR:
    # What column we are currently checking within the row
    li		$t1, 0		# $t1 = 0

LOOP_THROUGH_ROW_TO_CLEAR:
    mult	$t0, $t2			# $t0 * $t2 = Hi and Lo registers
    mflo	$t3					# copy Lo to $t3
    add		$t3, $t3, $t1		# $t3 = $t3 + $t1
    # Now $t3 is the index of the current block in the row within the tetromino grid
    la		$t4, tetromino_grid		# $t4 = &tetromino_grid
    add		$t4, $t4, $t3		# $t4 = $t4 + $t3
    # Now $t4 is the address of the current block in the row within the tetromino grid
    lb      $t4, 0($t4)		# $t4 = tetromino_grid[t4]
    beq		$t4, $zero, END_LOOP_THROUGH_ROW_TO_CLEAR		# if $t4 == $zero then goto END_LOOP_THROUGH_ROW_TO_CLEAR

    addi	$t1, $t1, 1			# $t1 = $t1 + 1
    bge		$t1, $t2, CLEAR_ROW		# if $t1 >= $t2 then goto CLEAR_ROW
    j		LOOP_THROUGH_ROW_TO_CLEAR				# jump to LOOP_THROUGH_ROW_TO_CLEAR

CLEAR_ROW:
    # Update the score to reflect this row is cleared. We add 70 points
    lw $t6, score
    addi $t6, $t6, 42
    sw $t6, score

    # What column we are currently checking within the row
    li		$t1, 0		# $t1 = 0

CLEAR_ROW_LOOP:
    # Clear the row $t0
    mult	$t0, $t2			# $t0 * $t2 = Hi and Lo registers
    mflo	$t3					# copy Lo to $t3

    add		$t3, $t3, $t1		# $t3 = $t3 + $t1
    la		$t4, tetromino_grid		# $t4 = &tetromino_grid
    add		$t4, $t4, $t3		# $t4 = $t4 + $t3
    # Now $t4 is the address of the block in tetromino grid that we want to clear
    li		$t3, 0		# $t3 = 0
    sb		$t3, 0($t4)		# $t4 = 0

    addi    $t1, $t1, 1			# $t1 = $t1 + 1
    bge		$t1, $t2, DONE_CLEARING_NOW_SHIFT_DOWN		# if $t1 >= $t2 then goto DONE_CLEARING_NOW_SHIFT_DOWN
    j		CLEAR_ROW_LOOP		# jump to CLEAR_ROW_LOOP

DONE_CLEARING_NOW_SHIFT_DOWN:
    # Load arguments for shift_all_rows_down
    move	$a0, $t0		# $a0 = $t0

    # Save the return address on the stack
    addi	$sp, $sp, -4			# $sp = $sp -4
    sw		$ra, 0($sp)		# $sp[0] = $ra

    # Save the values inside the temporary registers
    addi    $sp, $sp, -24			# $sp = $sp -24
    sw		$t0, 0($sp)		# $sp[0] = $t0
    sw      $t1, 4($sp)		# $sp[4] = $t1
    sw      $t2, 8($sp)		# $sp[8] = $t2
    sw      $t3, 12($sp)		# $sp[12] = $t3
    sw      $t4, 16($sp)		# $sp[16] = $t4
    sw      $t5, 20($sp)		# $sp[20] = $t5

    jal        shift_all_rows_down		# jump to shift_all_rows_down

    # Restore the values inside the temporary registers
    lw		$t0, 0($sp)		# $t0 = $sp[0]
    lw      $t1, 4($sp)		# $t1 = $sp[4]
    lw      $t2, 8($sp)		# $t2 = $sp[8]
    lw      $t3, 12($sp)		# $t3 = $sp[12]
    lw      $t4, 16($sp)		# $t4 = $sp[16]
    lw      $t5, 20($sp)		# $t5 = $sp[20]
    addi    $sp, $sp, 24			# $sp = $sp + 24

    # Restore the return address from the stack
    lw		$ra, 0($sp)		# $ra = $sp[0]
    addi	$sp, $sp, 4			# $sp = $sp + 4

END_LOOP_THROUGH_ROW_TO_CLEAR:
    addi	$t0, $t0, 1			# $t0 = $t0 + 1
    bge		$t0, $t5, END_LOOP_THROUGH_ROWS_TO_CLEAR	# if $t0 >= $t5 then goto END_LOOP_THROUGH_ROWS_TO_CLEAR

    j       LOOP_THROUGH_ROWS_TO_CLEAR		# jump to LOOP_THROUGH_ROWS_TO_CLEAR

END_LOOP_THROUGH_ROWS_TO_CLEAR:
    jr		$ra		# return

# Shifts all rows above $a0 down by one.
# Arguments:
# a0 = row that was just cleared and everything above it needs to be shifted down.
# ra = return address
# Uses registers t0 to t7 and modifies arguments
shift_all_rows_down:
    li		$t0, PLAYING_AREA_WIDTH_IN_BLOCKS		# $t0 = PLAYING_AREA_WIDTH_IN_BLOCKS
    la		$t4, tetromino_grid		# $t4 = &tetromino_grid
    
LOOP_THROUGH_ROWS_TO_SHIFT:
    # What column we are currently checking within the row
    li		$t1, 0		# $t1 = 0

    # Calculate the offset to get to the row that we are shifting "into"
    mult	$a0, $t0			# $a0 * $t0 = Hi and Lo registers
    mflo    $t2					# copy Lo to $t2

    # Calculate the offset to get to the row that we are shifting "from"
    addi	$a0, $a0, -1			# $a0 = $a0 + -1
    mult	$a0, $t0			# $a0 * $t0 = Hi and Lo registers
    mflo    $t3					# copy Lo to $t3
    # Note that this decrements the register that keeps track of where we are shifting "into" so there is no need to decrement later.

LOOP_THROUGH_ROW_TO_SHIFT:
    add		$t5, $t2, $t1		# $t5 = $t2 + $t1
    add		$t5, $t4, $t5		# $t5 = $t4 + $t5
    # $t5 is the address of the block in tetromino grid that we want to shift "into"

    add		$t6, $t3, $t1		# $t6 = $t3 + $t1
    add		$t6, $t4, $t6		# $t6 = $t4 + $t6
    # $t6 is the address of the block in tetromino grid that we want to shift "from"

    # Shift the block from the row above into the row below
    lb		$t7, 0($t6)		# $t7 = tetromino_grid[t6]
    sb		$t7, 0($t5)		# tetromino_grid[t5] = $t7

    # Clear the block in the row above
    li		$t7, 0		# $t7 = 0
    sb		$t7, 0($t6)		# tetromino_grid[t6] = $t7

    # Move to the next column or break if we are done
    addi    $t1, $t1, 1			# $t1 = $t1 + 1
    bge		$t1, $t0, END_LOOP_THROUGH_ROW_TO_SHIFT		# if $t1 >= $t0 then goto END_LOOP_THROUGH_ROWS_TO_SHIFT
    j		LOOP_THROUGH_ROW_TO_SHIFT		# jump to LOOP_THROUGH_ROW_TO_SHIFT

END_LOOP_THROUGH_ROW_TO_SHIFT:
    # Recall that there is no need to decrement $a0 since we decremented it earlier
    beq    $a0, $zero, END_LOOP_THROUGH_ROWS_TO_SHIFT		# if $a0 == 0 then goto END_LOOP_THROUGH_ROWS_TO_SHIFT
    j       LOOP_THROUGH_ROWS_TO_SHIFT		# jump to LOOP_THROUGH_ROWS_TO_SHIFT

END_LOOP_THROUGH_ROWS_TO_SHIFT:
    jr		$ra		# return


# Resets the game to the initial state.
# uses registers ... 
reset_game: 
    # clear the tetromino_grid

    # t0 = tetromino grid ptr
    la $t0, tetromino_grid

    # t1 = word count of the tetromino grid
    li $t1, TETROMINO_GRID_LEN
    sra $t1, $t1, 2 # this can't be optimized by -4 as the tetromino board isn't divisible by 4
TETROMINO_CLEAR_LOOP: 
    sw $0, 0($t0) # clear the word
    # dec pointer and inc address
    addi $t1, $t1, -1
    addi $t0, $t0, 4
    bgtz $t1, TETROMINO_CLEAR_LOOP

    # clear the remaining half word
    sh $0, 0($t0)

    # reset the score
    sw $0, score

    # reset the game state
    sw $0, game_state

    # move ra onto stack.
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # draw over the score number(since on each frame the background rect only clears as much as needed)
    # start at (39, 1)
    # call it with arguments: 
    la $t0, frame_buffer # ptr to screen
    li $t1, 0x0 # black 
    li $a0, 39 # start x
    li $a1, 1 # start y
    li $a2, 25 # width (rest of screen)
    li $a3, 5 # height
    jal fill_rect

    # respawn a new tetromino.
    jal spawn_new_tetromino

    # retrieve ra from stack and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra # return
