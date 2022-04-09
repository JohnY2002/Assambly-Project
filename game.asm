##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: John Yuan, 1006833848, yuanyij2, yijun.yuan@mail.utoronto.ca
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4 (update this as needed) 
# - Unit height in pixels: 4 (update this as needed) 
# - Display width in pixels: 512 (update this as needed) 
# - Display height in pixels: 256 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 1/2/3 (choose the one the applies) 
# Milestone 3
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. Health/score (heart at the lower left conner and score at the lower right conner)
# 2. Fail condition (lose all the hearts or fell on the blue water)
# 3. Win condition (reach 800 score)
# 4. Moving objects (the health fixer and bomb will move along with the platform
# in level 2 and level 3, the missile with fell off from the top in level 3)
# 5. Moving platforms (the platforms will keep moving from left to right, once
# reach the left board, will regenerate from the right board)
# 6. Different levels (Level 1 from score 0 to 200 with only platforms, Level 2 from 
# 200 to 500 with health fixer and bomb on platforms, Level 3 from 500 to 800 with 
# missile falling from top)
# 7. Enemies shoot back! (missile will be aimed at the player)
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes / no / yes, and please share this project github link as well! 
# 
# Any additional information that the TA needs to know: 
# - (write here, if any) 
# 
#####################################################################

.eqv   BASE_ADDRESS      0x10008000
.eqv   GREY              0xc4c4c4
.eqv   RED               0xd50000
.eqv   DARK_RED          0x4a0000
.eqv   LIGHT_GREY        0x9e9e9e
.eqv   BROWN             0x795548
.eqv   DARK_GREEN        0x263238
.eqv   WHITE             0xffffff
.eqv   ORANGE            0xff9800
.eqv   PURPLE            0x7b1fa2
.eqv   BLACK             0x000000
.eqv   BLUE              0x2196f3
.eqv   SINGLE_P          4
.eqv   WIDTH             512
.eqv   HEIGHT            256

.data
platform_type1:   .space  12 # store the width, height and the first pixel of platform type 1
platform_type2:   .space  12 # store the width, height and the first pixel of platform type 2
platform_type3:   .space  12 # store the width, height and the first pixel of platform type 3
health:           .space  16 # store the width, height, the first pixel of health and wheather is displayed
bomb:             .space  16 # store the width, height, the first pixel of bomb and wheather is displayed
character:        .space  12 # store the width, height and the first pixel of character
total_health:     .space  16 # store the total health, starting pixel for hearts
score:            .space  32 # store the starting pixel of numbers and numbers itself
gameover:         .space  32 # store the starting pixel for GAMEOVER
missile:          .space  8  # store the starting pixel of missile
won:              .space  12 # store the starting pixel for WON
         
.text
.globl main
 
main: 
      # clear the screen
      li $a0, 512
      li $a1, 61
      li $a2, BASE_ADDRESS
      jal REMOVE
      # initialize the screen with all the objects
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t1, 18 # set the width 
      li $t2, 9 # set the height 
      li $t3, 20 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3 # set the starting pixel
      addi $t0, $t0, 40
      la $t4, character # $t4 is the address 
      sw $t1, 0($t4) # save the width 
      sw $t2, 4($t4) # save the height
      sw $t0, 8($t4) # save the first pixel
      jal CREAT_CHARACTER
      # creat a platform1 
      li $t0, BASE_ADDRESS
      li $t1, 25 # set the width 
      li $t2, 2 # set the height 
      li $t3, 30 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3 # set the starting pixel
      addi $t0, $t0, 28
      la $t4, platform_type1 # $t4 is the address 
      sw $t1, 0($t4) # save the width 
      sw $t2, 4($t4) # save the height
      sw $t0, 8($t4) # save the first pixel
      li $a0, 1
      jal CREAT_PLATFORM
      # creat a platform2 
      li $t0, BASE_ADDRESS
      li $t1, 25 # set the width 
      li $t2, 2 # set the height 
      li $t3, 24 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 200 # set the starting pixel 
      la $t4, platform_type2 # $t4 is the address 
      sw $t1, 0($t4) # save the width 
      sw $t2, 4($t4) # save the height
      sw $t0, 8($t4) # save the first pixel
      li $a0, 2
      jal CREAT_PLATFORM
      # creat a platform3
      li $t0, BASE_ADDRESS
      li $t1, 25 # set the width 
      li $t2, 2 # set the height 
      li $t3, 40 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 340 # set the starting pixel 
      la $t4, platform_type3 # $t4 is the address 
      sw $t1, 0($t4) # save the width 
      sw $t2, 4($t4) # save the height
      sw $t0, 8($t4) # save the first pixel
      li $a0, 3
      jal CREAT_PLATFORM
      # set a health
      li $t0, BASE_ADDRESS
      li $t1, 3 # set the width 
      li $t2, 7 # set the height 
      addi $t0, $t0, 4 # set the starting pixel 
      la $t4, health # $t4 is the address 
      sw $t1, 0($t4) # save the width 
      sw $t2, 4($t4) # save the height
      sw $t0, 8($t4) # save the first pixel
      li $t0, 0
      sw $t0, 12($t4) # display
      # set a bomb
      li $t0, BASE_ADDRESS
      li $t1, 5 # set the width 
      li $t2, 7 # set the height
      addi $t0, $t0, 4 # set the starting pixel 
      la $t4, bomb # $t4 is the address 
      sw $t1, 0($t4) # save the width 
      sw $t2, 4($t4) # save the height
      sw $t0, 8($t4) # save the first pixel
      li $t0, 0
      sw $t0, 12($t4) # display
      # set a missile
      li $t0, BASE_ADDRESS
      la $t1, missile
      sw $t0, 0($t1)
      li $t2, 0
      sw $t2, 4($t1)
      # draw water
      jal DRAW_WATER
      # set the total health
      la $t0, total_health
      li $t1, 3
      sw $t1, 0($t0)
      li $t1, BASE_ADDRESS
      li $t2, 57
      mul $t2, $t2, WIDTH
      add $t1, $t1, $t2
      sw $t1, 4($t0)
      addi $t1, $t1, 40
      sw $t1, 8($t0)
      addi $t1, $t1, 40
      sw $t1, 12($t0) 
      move $a0, $t1
      jal DRAW_HEART
      la $t0, total_health
      lw $t1, 4($t0)
      move $a0, $t1
      jal DRAW_HEART
      la $t0, total_health
      lw $t1, 8($t0)
      move $a0, $t1
      jal DRAW_HEART
      # set the score
      li $t0, BASE_ADDRESS
      li $t3, 57 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3 # set the starting pixel
      addi $t0, $t0, 428
      la $t1, score
      sw $t0, 0($t1)
      addi $t0, $t0, 20
      sw $t0, 4($t1)
      addi $t0, $t0, 20
      sw $t0, 8($t1)
      addi $t0, $t0, 20
      sw $t0, 12($t1)
      sw $zero, 16($t1)
      sw $zero, 20($t1)
      sw $zero, 24($t1)
      sw $zero, 28($t1)
      jal DISPLAY_SCORE
main_loop:
      # read the input from the keyboard
      li $t9, 0xffff0000
      lw $t8, 0($t9)
      la $t0, character # save the old starting pixel
      lw $t1, 8($t0)
      subi $sp, $sp, 4
      sw $t1, ($sp)
      beq $t8, 0, else_main # check if the any key is pressed
      move $a0, $t9
      jal KEYPRESSED
      la $t0, score
      lw $t1, 20($t0)
      bge $t1, 2, level2
main_back:
      jal UPDATE_SCORE
      jal DISPLAY_SCORE
      jal UPDATE_PLATFORM
      # remove the character
      la $t5, character
      lw $t5, 8($t5) 
      lw $t4, ($sp) # get the old staring pixel 
      addi $sp, $sp, 4
      beq $t5, $t4, sleep
      li $a0, 18
      li $a1, 9
      move $a2, $t4
      jal REMOVE
      jal CREAT_CHARACTER
sleep:
      li $v0, 32
      li $a0, 200
      syscall
      j main_loop
else_main: 
      jal CHECK_BOTTOM
      la $t0, score
      lw $t1, 20($t0)
      bge $t1, 2, level2
      j main_back
level2:
      la $t4, health
      lw $t4, 12($t4)
      beqz $t4, check_bomb
      jal UPDATE_HEALTH
check_bomb:      
      la $t4, bomb
      lw $t4, 12($t4)
      beqz $t4, check_level3
      jal UPDATE_BOMB
check_level3:
      la $t0, score
      lw $t1, 20($t0)
      bge $t1, 5, level3
      j main_back
level3:
      jal UPDATE_MISSILE
      la $t0, score
      lw $t1, 20($t0)
      bge $t1, 8, SUCCEED
      j main_back

KEYPRESSED:
      subi $sp, $sp, 4 # save ra
      sw $ra, ($sp)
      move $t9, $a0
      lw $t2, 4($t9) # get the instruction
      la $t0, character # load the address of the character
      lw $t1, 8($t0) # load the starting pixel
      beq $t2, 0x61, respond_to_a
      beq $t2, 0x64, respond_to_d
      beq $t2, 0x77, respond_to_w
      beq $t2, 0x73, respond_to_s
      beq $t2, 0x70, respond_to_p
back_key:
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
respond_to_a:
      jal CHECK_LEFT
      j back_key
respond_to_d:
      jal CHECK_RIGHT
      j back_key
respond_to_w:
      jal CHECK_TOP
      j back_key
respond_to_s:
      jal CHECK_BOTTOM
      j back_key
respond_to_p:
      jal RESTART
      

RESTART:
      # clear the screen
      li $a0, 512
      li $a1, 61
      li $a2, BASE_ADDRESS
      jal REMOVE
      # initialize the screen with all the words
      la $s0, gameover
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 12 # set the starting pixel 
      sw $t0, 0($s0) # save the starting pixel 
      jal PRINT_G
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 68 # set the starting pixel
      sw $t0, 4($s0) # save the starting pixel 
      jal PRINT_A
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 124 # set the starting pixel
      sw $t0, 8($s0) # save the starting pixel 
      jal PRINT_M
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 180 # set the starting pixel
      sw $t0, 12($s0) # save the starting pixel
      move $a0, $t0 
      jal PRINT_E
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 292 # set the starting pixel
      sw $t0, 16($s0) # save the starting pixel 
      move $a0, $t0
      jal PRINT_O
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 348 # set the starting pixel
      sw $t0, 20($s0) # save the starting pixel 
      jal PRINT_V
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 404 # set the starting pixel
      sw $t0, 24($s0) # save the starting pixel
      move $a0, $t0 
      jal PRINT_E
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 460 # set the starting pixel
      sw $t0, 28($s0) # save the starting pixel 
      jal PRINT_R
      jal DISPLAY_SCORE
      li $v0, 32
      li $a0, 3000
      syscall
      j main
      
      
SUCCEED:
      # clear the screen
      li $a0, 512
      li $a1, 61
      li $a2, BASE_ADDRESS
      jal REMOVE
      # initialize the screen with all the words
      la $s0, won
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 180 # set the starting pixel 
      sw $t0, 0($s0) # save the starting pixel 
      jal PRINT_W
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 236 # set the starting pixel
      sw $t0, 4($s0) # save the starting pixel
      move $a0, $t0 
      jal PRINT_O
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t3, 15 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 292 # set the starting pixel
      sw $t0, 8($s0) # save the starting pixel 
      jal PRINT_N
      li $v0, 32
      li $a0, 3000
      syscall
      j main
      

CHECK_LEFT:
      subi $sp, $sp, 4 # save ra
      sw $ra, ($sp)
      la $t0, character
      lw $t1, 8($t0)
      # check board
      move $t2, $t1
      subi $t2, $t2, BASE_ADDRESS
      li $t3, WIDTH
      div $t2, $t3
      mfhi $t2
      beqz $t2, end_left
      # check collision
      move $t2, $t1
      li $t3, 9
      subi $t2, $t2, 4
loop_left:
      lw $t4, ($t2)
      beq $t4, GREY, end_left
      beq $t4, ORANGE, left_health
      beq $t4, PURPLE, left_bomb
      addi $t2, $t2, WIDTH
      subi $t3, $t3, 1
      bnez $t3, loop_left
      subi $t1, $t1, 4 # move left one pixel
      sw $t1, 8($t0) # update it in the array
end_left: 
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
left_health:
      li $a0, 3
      li $a1, 7
      subi $t2, $t2, 8
      move $a2, $t2
      jal REMOVE
      la $t5, health
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_ORANGE
      jal GAIN_HEALTH
      j end_left
left_bomb:
      li $a0, 5
      li $a1, 7
      li $t4, 3
      mul $t4, $t4, WIDTH
      sub $t2, $t2, $t4
      subi $t2, $t2, 16
      move $a2, $t2
      jal REMOVE
      la $t5, bomb
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_PURPLE
      jal LOSE_HEALTH
      j end_left
      

CHECK_RIGHT:
      subi $sp, $sp, 4 # save ra
      sw $ra, ($sp)
      la $t0, character
      lw $t1, 8($t0)
      # check board
      move $t2, $t1
      subi $t2, $t2, BASE_ADDRESS
      subi $t2, $t2, 440
      li $t3, WIDTH
      div $t2, $t3
      mfhi $t2
      beqz $t2, end_right
      # check collision
      move $t2, $t1
      li $t3, 9
      addi $t2, $t2, 72
loop_right:
      lw $t4, ($t2)
      beq $t4, GREY, end_right
      beq $t4, ORANGE, right_health
      beq $t4, PURPLE, right_bomb
      addi $t2, $t2, WIDTH
      subi $t3, $t3, 1
      bnez $t3, loop_right
      addi $t1, $t1, 4 # move right one pixel
      sw $t1, 8($t0) # update it in the array
end_right:
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
right_health:
      li $a0, 3
      li $a1, 7
      la $t0, health
      lw $a2, 8($t0)
      jal REMOVE
      la $t5, health
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_ORANGE
      jal GAIN_HEALTH
      j end_right
right_bomb:
      li $a0, 5
      li $a1, 7
      la $t0, bomb
      lw $a2, 8($t0)
      jal REMOVE
      la $t5, bomb
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_PURPLE
      jal LOSE_HEALTH
      j end_right
      

CHECK_TOP:
      subi $sp, $sp, 4 # save ra
      sw $ra, ($sp)
      la $t0, character
      lw $t1, 8($t0)
      # check board
      move $t2, $t1
      subi $t2, $t2, BASE_ADDRESS
      subi $t2, $t2, WIDTH # move up one pixel
      ble $t2, 436, end_top
      # check collision
      move $t2, $t1
      li $t3, 18
      subi $t2, $t2, WIDTH
loop_top:
      lw $t4, ($t2)
      beq $t4, GREY, end_top
      beq $t4, ORANGE, top_health
      beq $t4, PURPLE, top_bomb
      addi $t2, $t2, SINGLE_P
      subi $t3, $t3, 1
      bnez $t3, loop_top
      # move
      subi $t1, $t1, WIDTH # move up one pixel
      subi $t1, $t1, WIDTH # move up one pixel
      sw $t1, 8($t0) # update it in the array
end_top:
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
top_health:
      li $a0, 3
      li $a1, 7
      li $t4, 6
      mul $t4, $t4, WIDTH
      sub $t2, $t2, $t4
      subi $t2,$t2, 4
      move $a2, $t2
      jal REMOVE
      la $t5, health
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_ORANGE
      jal GAIN_HEALTH
      j end_top
top_bomb:
      li $a0, 5
      li $a1, 7
      li $t4, 6
      mul $t4, $t4, WIDTH
      sub $t2, $t2, $t4
      subi $t2, $t2, SINGLE_P
      move $a2, $t2
      jal REMOVE
      la $t5, bomb
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_PURPLE
      jal LOSE_HEALTH
      j end_top
      
      
CHECK_BOTTOM:
      subi $sp, $sp, 4 # save ra
      sw $ra, ($sp)
      la $t0, character
      lw $t1, 8($t0)
      # check board
      move $t2, $t1
      li $t3, WIDTH
      mul $t3, $t3, 55
      addi $t3, $t3, BASE_ADDRESS
      sub $t2, $t2, $t3
      bgez $t2, end_bottom
      # check collision
      move $t2, $t1
      li $t3, 18
      li $t5, 9
      mul $t5, $t5, WIDTH
      add $t2, $t2, $t5
loop_bottom:
      lw $t4, ($t2)
      beq $t4, GREY, end_bottom
      beq $t4, ORANGE, bottom_health
      beq $t4, RED, bottom_bomb
      beq $t4, BLUE, bottom_ocean
      addi $t2, $t2, SINGLE_P
      subi $t3, $t3, 1
      bnez $t3, loop_bottom
      # move
      addi $t1, $t1, WIDTH # move down one pixel
      sw $t1, 8($t0) # update it in the array
end_bottom:
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
bottom_health:
      li $a0, 6
      li $a1, 7
      subi $t2, $t2, 8
      move $a2, $t2
      jal REMOVE
      la $t5, health
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_ORANGE
      jal GAIN_HEALTH
      j end_bottom
bottom_bomb:
      li $a0, 5
      li $a1, 7
      subi $t2, $t2, 8
      move $a2, $t2
      jal REMOVE
      la $t5, bomb
      li $t6, 0
      sw $t6, 12($t5)
      jal PAINT_PURPLE
      jal LOSE_HEALTH
      j end_bottom
bottom_ocean:
      j RESTART
      
      
GAIN_HEALTH:
      subi $sp, $sp, 4 # save ra
      sw $ra, 0($sp)
      la $t0, total_health
      lw $t1, 0($t0)
      addi $t1, $t1, 1
      beq $t1, 3, three_health
      beq $t1, 2, two_health
end_gain:
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra
three_health:
      sw $t1, 0($t0)
      lw $t2, 12($t0)
      move $a0, $t2
      jal DRAW_HEART
      j end_gain
two_health:
      sw $t1, 0($t0)
      lw $t2, 8($t0)
      move $a0, $t2
      jal DRAW_HEART
      j end_gain


LOSE_HEALTH:
      subi $sp, $sp, 4 # save ra
      sw $ra, 0($sp)
      la $t0, total_health
      lw $t1, 0($t0)
      subi $t1, $t1, 1
      beqz $t1, RESTART
      beq $t1, 1, one
      beq $t1, 2, two
one:  
      sw $t1, 0($t0)
      lw $t2, 8($t0)
      move $a2, $t2
      li $a0, 7
      li $a1, 7
      jal REMOVE
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra
two:  
      sw $t1, 0($t0)
      lw $t2, 12($t0)
      move $a2, $t2
      li $a0, 7
      li $a1, 7
      jal REMOVE
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra
      
      
UPDATE_PLATFORM:
      subi $sp, $sp, 4 # save ra
      sw $ra, 0($sp)
      # remove the old platform 1
      la $t0, platform_type1
      lw $t2, 0($t0) # get the width
      move $a0, $t2
      lw $t2, 4($t0) # get the height
      move $a1, $t2
      lw $t1, 8($t0)
      move $a2, $t1 
      jal REMOVE
      la $t0, platform_type1
      move $a0, $t0
      li $a1, 1
      jal CHECK_LEFT_PLATFORM
      # remove the old platform 2
      la $t0, platform_type2
      lw $t2, 0($t0) # get the width
      move $a0, $t2
      lw $t2, 4($t0) # get the height
      move $a1, $t2
      lw $t1, 8($t0)
      move $a2, $t1 
      jal REMOVE
      la $t0, platform_type2
      move $a0, $t0
      li $a1, 2
      jal CHECK_LEFT_PLATFORM
      la $t0, platform_type1
      # remove the old platform 3
      la $t0, platform_type3
      lw $t2, 0($t0) # get the width
      move $a0, $t2
      lw $t2, 4($t0) # get the height
      move $a1, $t2
      lw $t1, 8($t0)
      move $a2, $t1 
      jal REMOVE
      la $t0, platform_type3
      move $a0, $t0
      li $a1, 3
      jal CHECK_LEFT_PLATFORM
      
      lw $ra, 0($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
      

CHECK_LEFT_PLATFORM:
      subi $sp, $sp, 4 # save ra
      sw $ra, 0($sp)
      move $t8, $a0 # get the platform address
      move $t9, $a1 # get the platform type
      lw $t1, 8($t8)
      # check if anything is on the left of the platform
      subi $t1, $t1, SINGLE_P
      lw $t2, 0($t1)
      bne $t2, BLACK, stay
      addi $t1, $t1, WIDTH
      lw $t2, 0($t1)
      bne $t2, BLACK, stay
      # check if the left is the board
      lw $t1, 8($t8)
      move $t2, $t1
      subi $t2, $t2, BASE_ADDRESS
      li $t3, WIDTH
      div $t2, $t3
      mfhi $t2
      bnez $t2, move_left
      # left is the board
      li $t0, BASE_ADDRESS
      li $v0, 42
      li $a0, 0
      li $a1, 31
      syscall
      move $t3, $a0 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3 # set the starting pixel
      li $t2, WIDTH
      lw $t1, 0($t8)
      mul $t1, $t1, 4
      sub $t2, $t2, $t1
      add $t0, $t0, $t2
      add $t0, $t0, 10240
      sw $t0, 8($t8) # save the first pixel
      move $a0, $t9
      jal CREAT_PLATFORM
      beq $t9, 2, set_health
      beq $t9, 3, set_bomb
exit_left:
      lw $ra, 0($sp) #restore ra
      addi $sp, $sp, 4
      jr $ra
move_left:
      subi $t1, $t1, SINGLE_P
      sw $t1, 8($t8)
      move $a0, $t9
      jal CREAT_PLATFORM
      j  exit_left
set_health:
      la $t0, health
      lw $t3, 12($t0)
      bnez $t3, remove_old_health
      li $t1, 1
      sw $t1, 12($t0)
set_health_cont:
      la $t0, platform_type2
      lw $t1, 8($t0) # starting pixel
      li $t2, 7
      mul $t2, $t2, WIDTH
      sub $t1, $t1, $t2
      addi $t1, $t1, 40
      la $t3, health
      sw $t1, 8($t3) # store the new starting pixel
      j exit_left
set_bomb:
      la $t0, bomb
      lw $t3, 12($t0)
      bnez $t3, remove_old_bomb
      li $t1, 1
      sw $t1, 12($t0)
set_bomb_cont:
      la $t0, platform_type3
      lw $t1, 8($t0) # starting pixel
      li $t2, 7
      mul $t2, $t2, WIDTH
      sub $t1, $t1, $t2
      addi $t1, $t1, 40
      la $t3, bomb
      sw $t1, 8($t3) # store the new starting pixel
      j exit_left
stay:
      move $a0, $t9
      jal CREAT_PLATFORM
      j exit_left
remove_old_health:
      li $a0, 3
      li $a1, 7
      lw $t4, 8($t0)
      move $a2, $t4
      jal REMOVE
      j set_health_cont
remove_old_bomb:
      li $a0, 5
      li $a1, 7
      lw $t4, 8($t0)
      move $a2, $t4
      jal REMOVE
      j set_bomb_cont
      

UPDATE_HEALTH:
      subi $sp, $sp, 4 # save ra
      sw $ra, 0($sp)
      # remove old health
      la $t1, health
      lw $t2, 0($t1) # width
      lw $t3, 4($t1) # height
      lw $t4, 8($t1) # starting pixel
      move $a0, $t2
      move $a1, $t3
      move $a2, $t4
      jal REMOVE
      # check if anything is on the left
      la $t0, health
      lw $t1, 8($t0)
      subi $t1, $t1, SINGLE_P
      li $t2, 7
loop_update_health:
      lw $t3, 0($t1)
      beq $t3, WHITE, missile_health
      bne $t3, BLACK, remove_health
      addi $t1, $t1, WIDTH
      subi $t2, $t2, 1
      bnez $t2, loop_update_health
      # move the health
      la $t0, platform_type2
      lw $t1, 8($t0) # starting pixel
      li $t2, 7
      mul $t2, $t2, WIDTH
      sub $t1, $t1, $t2
      addi $t1, $t1, 40
      la $t3, health
      sw $t1, 8($t3) # store the new starting pixel
      jal CREAT_HEALTH
end_update_health:
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra
remove_health:
      li $t4, 0
      sw $t4, 12($t0)
      jal PAINT_ORANGE
      jal GAIN_HEALTH
      j end_update_health
missile_health:
      li $t4, 0
      sw $t4, 12($t0)
      j end_update_health
      
      
UPDATE_BOMB:
      subi $sp, $sp, 4 # save ra
      sw $ra, 0($sp)
      # remove old bomb
      la $t1, bomb
      lw $t2, 0($t1) # width
      lw $t3, 4($t1) # height
      lw $t4, 8($t1) # starting pixel
      move $a0, $t2
      move $a1, $t3
      move $a2, $t4
      jal REMOVE
      # check if anything is on the left
      la $t0, bomb
      lw $t1, 8($t0)
      subi $t1, $t1, SINGLE_P
      li $t2, 7
loop_update_bomb:
      lw $t3, 0($t1)
      beq $t3, WHITE, missile_bomb
      bne $t3, BLACK, remove_bomb
      addi $t1, $t1, WIDTH
      subi $t2, $t2, 1
      bnez $t2, loop_update_bomb
      # move the bomb
      la $t0, platform_type3
      lw $t1, 8($t0) # starting pixel
      li $t2, 7
      mul $t2, $t2, WIDTH
      sub $t1, $t1, $t2
      addi $t1, $t1, 40
      la $t3, bomb
      sw $t1, 8($t3) # store the new starting pixel
      jal CREAT_BOMB
end_update_bomb:
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra
remove_bomb:
      li $t4, 0
      sw $t4, 12($t0)
      jal PAINT_PURPLE
      jal LOSE_HEALTH
      j end_update_bomb
missile_bomb:
      li $t4, 0
      sw $t4, 12($t0)
      j end_update_bomb
      
      
UPDATE_MISSILE:
      subi $sp, $sp, 4
      sw $ra, 0($sp)
      # check if the missile is displayed
      la $t0, missile
      lw $t1, 4($t0)
      beqz $t1, creat_missile
      # remove the old missile
      li $a0, 5
      li $a1, 6
      lw $a2, 0($t0)
      jal REMOVE
      # check if anything is below missile
      la $t0, missile
      lw $t1, 0($t0)
      li $t2, 6
      mul $t2, $t2, WIDTH
      add $t1, $t1, $t2
      li $t2, 5
loop_missile:
      lw $t3, 0($t1)
      beq $t3, RED, hit_character
      beq $t3, BROWN, hit_character
      bne $t3, BLACK, remove_missile
      addi $t1, $t1, SINGLE_P
      subi $t2, $t2, 1
      bnez $t2, loop_missile
      lw $t1, 0($t0)
      addi $t1, $t1, WIDTH
      sw $t1, 0($t0)
      jal DRAW_MISSILE
exit_missile:
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra
creat_missile:
      la $t0, character
      lw $t1, 8($t0)
      subi $t1, $t1, BASE_ADDRESS
      li $t2, WIDTH
      div $t1, $t2
      mfhi $t1
      addi $t1, $t1, BASE_ADDRESS
      la $t0, missile
      sw $t1, 0($t0)
      li $t2, 1
      sw $t2, 4($t0)
      jal DRAW_MISSILE
      j exit_missile
remove_missile:
      la $t0, missile
      li $t1, 0
      sw $t1, 4($t0)
      j exit_missile
hit_character:
      jal PAINT_WHITE
      jal LOSE_HEALTH
      j remove_missile
      
CREAT_PLATFORM:
      beq $a0, 1, type1
      beq $a0, 2, type2
      beq $a0, 3, type3
type1:
      la $t2, platform_type1 # get the address
      j plat_cont
type2:
      la $t2, platform_type2 # get the address
      j plat_cont
type3:
      la $t2, platform_type3 # get the address
      j plat_cont
plat_cont:
      li $t1, GREY # t1 is grey colour
      lw $t4, 0($t2) # load the width
      move $t5, $t4
      lw $t3, 4($t2) # load the height
      lw $t0, 8($t2) # load the starting pixel
      move $t7, $t0
      li $t6, 0
plat_loop:
      sw $t1, ($t0) 
      addi $t0, $t0, 4 # go to the next pixel
      subi $t5, $t5, 1 # width counter -= 1
      bnez $t5, plat_loop
      addi $t6, $t6, 1 # height counter += 1
      addi $t7, $t7, WIDTH # move to the next row
      move $t0, $t7
      move $t5, $t4
      bne $t6, $t3, plat_loop
        
      jr $ra
      
      
UPDATE_SCORE:
      la $t0, score
      lw $t1, 28($t0) # get the last number
      addi $t1, $t1, 1 
      beq $t1, 10, overflow1
      sw $t1, 28($t0)
      j end_update_score
overflow1:
      sw $zero, 28($t0)
      lw $t2, 24($t0) # get the 3rd number
      addi $t2, $t2, 1
      beq $t2, 10, overflow2
      sw $t2, 24($t0)
      j end_update_score
overflow2:
      sw $zero, 24($t0)
      lw $t3, 20($t0)
      addi $t3, $t3, 1
      beq $t3, 10, overflow3
      sw $t3, 20($t0)
      j end_update_score
overflow3:
      sw $zero, 20($t0)
      lw $t4, 16($t0)
      addi $t4, $t4, 1
      sw $t4, 16($t0)
end_update_score:
      jr $ra


DISPLAY_SCORE:
      subi $sp, $sp, 4
      sw $ra, 0($sp)
      # remove old score
      la $t0, score
      li $a0, 19
      li $a1, 5
      lw $a2, 0($t0)
      jal REMOVE
      # display the first number
      la $t0, score
      lw $a0, 0($t0) # starting pixel
      lw $a1, 16($t0) # number
      jal DISPLAY_NUMBER
      # display the second number
      la $t0, score
      lw $a0, 4($t0) # starting pixel
      lw $a1, 20($t0) # number
      jal DISPLAY_NUMBER
      # display the third number
      la $t0, score
      lw $a0, 8($t0) # starting pixel
      lw $a1, 24($t0) # number
      jal DISPLAY_NUMBER
      # display the forth number
      la $t0, score
      lw $a0, 12($t0) # starting pixel
      lw $a1, 28($t0) # number
      jal DISPLAY_NUMBER
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra


DISPLAY_NUMBER:
      subi $sp, $sp, 4
      sw $ra, 0($sp)
      move $t1, $a1
      beq $t1, 0, number_0
      beq $t1, 1, number_1
      beq $t1, 2, number_2
      beq $t1, 3, number_3
      beq $t1, 4, number_4
      beq $t1, 5, number_5
      beq $t1, 6, number_6
      beq $t1, 7, number_7
      beq $t1, 8, number_8
      beq $t1, 9, number_9
end_display_number:
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      jr $ra
number_0:
      jal DRAW_0
      j end_display_number
number_1:
      jal DRAW_1
      j end_display_number
number_2:
      jal DRAW_2
      j end_display_number
number_3:
      jal DRAW_3
      j end_display_number
number_4:
      jal DRAW_4
      j end_display_number
number_5:
      jal DRAW_5
      j end_display_number
number_6:
      jal DRAW_6
      j end_display_number
number_7:
      jal DRAW_7
      j end_display_number
number_8:
      jal DRAW_8
      j end_display_number
number_9:
      jal DRAW_9
      j end_display_number


DRAW_0:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      jr $ra


DRAW_1:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      jr $ra


DRAW_2:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      jr $ra

    
DRAW_3:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      jr $ra
      

DRAW_4:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 8($t0)
      jr $ra 
      
      
DRAW_5:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      jr $ra
      
DRAW_6:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      jr $ra
      
      
DRAW_7:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 8($t0)
      jr $ra
      
DRAW_8:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      jr $ra
      
DRAW_9:
      move $t0, $a0
      li $t1, WHITE
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 0($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 12($t0)
      addi $t0, $t0, WIDTH # move to the next row
      sw $t1, 8($t0)
      jr $ra
      

DRAW_HEART:
      move $t0, $a0
      li $t1, RED
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 12($t0)
      
      jr $ra
      
      
CREAT_HEALTH:
      la $t0, health # load the address
      # lw $t1, 12($t0)
      # beqz $t1, end_health
      lw $t0, 8($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour
      sw $t1, 0($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 0($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
end_health:        
      jr $ra
      
CREAT_BOMB:
      la $t0, bomb # load the address
      # lw $t1, 12($t0)
      # beqz $t1, end_bomb
      lw $t0, 8($t0) # get the first index
      li $t1, RED # t1 is red colour
      li $t2, PURPLE # t2 is purple colour
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 8($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t2, 4($t0)
      sw $t2, 8($t0)
      sw $t2, 12($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t2, 0($t0)
      sw $t2, 4($t0)
      sw $t2, 8($t0)
      sw $t2, 12($t0)
      sw $t2, 16($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t2, 0($t0)
      sw $t2, 4($t0)
      sw $t2, 8($t0)
      sw $t2, 12($t0)
      sw $t2, 16($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t2, 0($t0)
      sw $t2, 4($t0)
      sw $t2, 8($t0)
      sw $t2, 12($t0)
      sw $t2, 16($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t2, 4($t0)
      sw $t2, 8($t0)
      sw $t2, 12($t0)
end_bomb:        
      jr $ra
      
CREAT_CHARACTER:
      la $t0, character # load the address
      lw $t0, 8($t0) # get the first index
      li $t1, RED # t1 is red colour
      li $t2, DARK_RED # t2 is dark red colour
      li $t3, BROWN # t3 is brown colour
      li $t4, WHITE # t4 is white colour
      li $t5, LIGHT_GREY # t5 is light grey colour
      li $t6, DARK_GREEN # t6 is dark green colour
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t3, 24($t0)
      sw $t3, 28($t0)
      sw $t3, 32($t0)
      sw $t3, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t3, 24($t0)
      sw $t5, 28($t0)
      sw $t5, 32($t0)
      sw $t5, 36($t0)
      sw $t3, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t3, 24($t0)
      sw $t5, 28($t0)
      sw $t5, 32($t0)
      sw $t5, 36($t0)
      sw $t5, 40($t0)
      sw $t3, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t3, 24($t0)
      sw $t3, 28($t0)
      sw $t3, 32($t0)
      sw $t3, 36($t0)
      sw $t3, 40($t0)
      sw $t3, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t6, 12($t0)
      sw $t6, 16($t0)
      sw $t6, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t6, 48($t0)
      sw $t6, 52($t0)
      sw $t6, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t6, 8($t0)
      sw $t6, 12($t0)
      sw $t4, 16($t0)
      sw $t6, 20($t0)
      sw $t6, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t6, 44($t0)
      sw $t6, 48($t0)
      sw $t4, 52($t0)
      sw $t6, 56($t0)
      sw $t6, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t6, 8($t0)
      sw $t4, 12($t0)
      sw $t4, 16($t0)
      sw $t4, 20($t0)
      sw $t6, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t6, 44($t0)
      sw $t4, 48($t0)
      sw $t4, 52($t0)
      sw $t4, 56($t0)
      sw $t6, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t2, 0($t0)
      sw $t2, 4($t0)
      sw $t6, 8($t0)
      sw $t6, 12($t0)
      sw $t4, 16($t0)
      sw $t6, 20($t0)
      sw $t6, 24($t0)
      sw $t2, 28($t0)
      sw $t2, 32($t0)
      sw $t2, 36($t0)
      sw $t2, 40($t0)
      sw $t6, 44($t0)
      sw $t6, 48($t0)
      sw $t4, 52($t0)
      sw $t6, 56($t0)
      sw $t6, 60($t0)
      sw $t2, 64($t0)
      sw $t2, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t6, 12($t0)
      sw $t6, 16($t0)
      sw $t6, 20($t0)
      sw $t6, 48($t0)
      sw $t6, 52($t0)
      sw $t6, 56($t0)
        
      jr $ra
      

PAINT_ORANGE:
      la $t0, character # load the address
      lw $t0, 8($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
        
      jr $ra
      
      
PAINT_WHITE:
      la $t0, character # load the address
      lw $t0, 8($t0) # get the first index
      li $t1, WHITE # t1 is white colour
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
        
      jr $ra           
      
      
PAINT_PURPLE:
      la $t0, character # load the address
      lw $t0, 8($t0) # get the first index
      li $t1, PURPLE # t1 is purple colour
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      sw $t1, 44($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
      sw $t1, 60($t0)
      sw $t1, 64($t0)
      sw $t1, 68($t0)
      addi $t0, $t0, WIDTH # go to the next row
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 48($t0)
      sw $t1, 52($t0)
      sw $t1, 56($t0)
        
      jr $ra
      

PRINT_G:
      la $t0, gameover # load the address
      lw $t0, 0($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      
      jr $ra
      
      
PRINT_A:
      la $t0, gameover # load the address
      lw $t0, 4($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      
      jr $ra
      
      
PRINT_M:
      la $t0, gameover # load the address
      lw $t0, 8($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour      
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      
      
      jr $ra
      
      
PRINT_E:
      move $t0, $a0 # load the address
      li $t1, ORANGE # t1 is orange colour
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)      
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
     
      jr $ra
      
      
PRINT_O:
      move $t0, $a0 # load the address
      li $t1, ORANGE # t1 is orange colour    
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      
      jr $ra
      
      
PRINT_V:
      la $t0, gameover # load the address
      lw $t0, 20($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH 
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH 
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH  
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH 
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH 
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH 
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      addi $t0, $t0, WIDTH 
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      addi $t0, $t0, WIDTH 
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      
      jr $ra     
      
      
PRINT_R:
      la $t0, gameover # load the address
      lw $t0, 28($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour      
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)     
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)     
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)     
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)     
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 12($t0)
      sw $t1, 16($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 20($t0)
      sw $t1, 24($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 36($t0)
      sw $t1, 40($t0)
      
      jr $ra
      
      
PRINT_W:
      la $t0, won # load the address
      lw $t0, 0($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour      
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      
      jr $ra
      

PRINT_N:
      la $t0, won # load the address
      lw $t0, 8($t0) # get the first index
      li $t1, ORANGE # t1 is orange colour      
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 8($t0)
      sw $t1, 12($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 16($t0)
      sw $t1, 20($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 24($t0)
      sw $t1, 28($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0)
      addi $t0, $t0, WIDTH
      sw $t1, 0($t0)
      sw $t1, 4($t0)
      sw $t1, 32($t0)
      sw $t1, 36($t0) 
      
      jr $ra
      

DRAW_WATER:
      li $t0, BLUE
      li $t1, BASE_ADDRESS
      li $t2, 53
      mul $t2, $t2, WIDTH
      add $t1, $t1, $t2
      addi $t1, $t1, 8
      li $t3, 32
loop1:
      sw $t0, 0($t1)
      addi $t1, $t1, 16
      subi $t3, $t3, 1
      bnez $t3, loop1
      subi $t1, $t1, 4
      li $t3, 31
loop2:
      sw $t0, 0($t1)
      sw $t0, 4($t1)
      sw $t0, 8($t1)
      addi $t1, $t1, 16
      subi $t3, $t3, 1
      bnez $t3, loop2
      sw $t0, 0($t1)
      sw $t0, 4($t1)
      sw $t0, 8($t1)
      addi $t1, $t1, 12
      li $t3, 128
loop3:
      sw $t0, 0($t1)
      addi $t1, $t1, 4
      subi $t3, $t3, 1
      bnez $t3, loop3
      
      jr $ra


DRAW_MISSILE:
      la $t0, missile
      lw $t1, 0($t0)
      li $t2, DARK_RED
      li $t3, WHITE
      sw $t2, 0($t1)
      sw $t3, 4($t1)
      sw $t3, 8($t1)
      sw $t3, 12($t1)
      sw $t2, 16($t1)
      addi $t1, $t1, WIDTH
      sw $t3, 4($t1)
      sw $t2, 8($t1)
      sw $t3, 12($t1)
      addi $t1, $t1, WIDTH
      sw $t3, 4($t1)
      sw $t2, 8($t1)
      sw $t3, 12($t1)
      addi $t1, $t1, WIDTH
      sw $t3, 4($t1)
      sw $t2, 8($t1)
      sw $t3, 12($t1)
      addi $t1, $t1, WIDTH
      sw $t3, 4($t1)
      sw $t2, 8($t1)
      sw $t3, 12($t1)
      addi $t1, $t1, WIDTH
      sw $t3, 8($t1)
      
      jr $ra
            
      
REMOVE:
      li $t0, BLACK
      move $t1, $a0 # pop off the width
      move $t5, $t1 # t5 is the width counter
      move $t2, $a1 # pop off the height
      move $t3, $a2 # pop off the starting pixel
      move $t4, $t3 # t4 is the starting pixel counter
      li $t6, 0 # t6 is the height counter
loop_remove:
      sw $t0, ($t4)
      addi $t4, $t4, 4 # go to the next pixel
      subi $t5, $t5, 1 # width counter -= 1
      bnez $t5, loop_remove
      addi $t6, $t6, 1 # height counter += 1
      addi $t3, $t3, WIDTH # move to the next row
      move $t4, $t3
      move $t5, $t1
      bne $t6, $t2, loop_remove
      
      jr $ra
     
