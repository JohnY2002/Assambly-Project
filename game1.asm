##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: Name, Student Number, UTorID, official email 
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
# - Milestone 1/2/3 (choose the one the applies) 
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. (fill in the feature, if any) 
# 2. (fill in the feature, if any) 
# 3. (fill in the feature, if any) 
# ... (add more if necessary) 
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
.eqv   SINGLE_P          4
.eqv   WIDTH             512
.eqv   HEIGHT            256

.data
address_arr:   .space  24 # an array that store the pixel address of all the objects
# 1st is the address of the character, 2nd is the address of the 1st platform
# 3rd is the address of the 2nd platform, 4th is the address of the 3rd platform
# 5th is the address of the health, 6th is the address of the bomb
platform_type1:   .space  12 # store the width, height and the first pixel of platform type 1
platform_type2:   .space  12 # store the width, height and the first pixel of platform type 2
platform_type3:   .space  12 # store the width, height and the first pixel of platform type 3
health:           .space  12 # store the width, height and the first pixel of health
bomb:             .space  12 # store the width, height and the first pixel of bomb
character:        .space  12 # store the width, height and the first pixel of character
         
.text
.globl main
 
main: 
      # initialize the screen with all the objects
      la $s1, address_arr # $s1 is the base address of address_arr
      # creat a character 
      li $t0, BASE_ADDRESS
      li $t1, 20 # set the width 
      li $t2, 9 # set the height 
      li $t3, 1 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3
      addi $t0, $t0, 200 # set the starting pixel 
      la $t4, character # $t4 is the address 
      sw $t1, 0($t4) # save the width 
      sw $t2, 4($t4) # save the height
      sw $t0, 8($t4) # save the first pixel
      jal CREAT_CHARACTER
      # creat a platform1 
      li $t0, BASE_ADDRESS
      li $t1, 35 # set the width 
      li $t2, 2 # set the height 
      li $t3, 30 # set the starting height
      mul $t3, $t3, WIDTH
      add $t0, $t0, $t3 # set the starting pixel 
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
      li $t1, 30 # set the width 
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
main_loop:
      # read the input from the keyboard
      li $t9, 0xffff0000
      lw $t8, 0($t9)
      beq $t8, 1, keypress_happened
      la $t0, character
      lw $t1, 8($t0)
      # check collision
      move $t2, $t1
      li $t3, 20
      li $t5, 9
      mul $t5, $t5, WIDTH
      add $t2, $t2, $t5
loop_main_s:
      lw $t4, ($t2)
      bne $t4, BLACK, main_cont
      addi $t2, $t2, SINGLE_P
      subi $t3, $t3, 1
      bnez $t3, loop_main_s
      addi $t1, $t1, WIDTH
      sw $t1, 8($t0)
      # remove the character
      lw $t4, ($t0)
      move $a0, $t4
      lw $t3, 4($t0)
      move $a1, $t3
      subi $t1, $t1, WIDTH
      move $a2, $t1
      jal REMOVE
      jal CREAT_CHARACTER
main_cont:
      # sleep
      li $v0, 32
      li $a0, 200
      syscall
      j main_loop
            
      li $v0, 10
      syscall
keypress_happened:
      lw $t2, 4($t9)
      subi $sp, $sp, 4 # save the instruction
      sw $t2, ($sp)
      la $t0, character # load the address of the character
      lw $t1, 8($t0) # load the starting pixel
      # remove the character
      lw $t4, ($t0)
      move $a0, $t4
      lw $t3, 4($t0)
      move $a1, $t3
      move $a2, $t1
      jal REMOVE
      la $t0, character
      lw $t1, 8($t0) # load the starting pixel
      lw $t2, ($sp) # restore the instruction
      addi $sp, $sp, 4
      beq $t2, 0x61, respond_to_a
      beq $t2, 0x64, respond_to_d
      beq $t2, 0x77, respond_to_w
      beq $t2, 0x73, respond_to_s
back:
      sw $t1, 8($t0) # update it in the array
      # update the character  
      jal CREAT_CHARACTER
      j main_cont
respond_to_a:
      # check board
      move $t2, $t1
      subi $t2, $t2, BASE_ADDRESS
      li $t3, WIDTH
      div $t2, $t3
      mfhi $t2
      beqz $t2, back
      # check collision
      move $t2, $t1
      li $t3, 9
      subi $t2, $t2, 4
loop_a:
      lw $t4, ($t2)
      bne $t4, BLACK, back
      addi $t2, $t2, WIDTH
      subi $t3, $t3, 1
      bnez $t3, loop_a
      # move
      subi $t1, $t1, 4 # move left one pixel
      j back
respond_to_d:
      # check board
      move $t2, $t1
      subi $t2, $t2, BASE_ADDRESS
      subi $t2, $t2, 432
      li $t3, WIDTH
      div $t2, $t3
      mfhi $t2
      beqz $t2, back
      # check collision
      move $t2, $t1
      li $t3, 9
      addi $t2, $t2, 80
loop_d:
      lw $t4, ($t2)
      bne $t4, BLACK, back
      addi $t2, $t2, WIDTH
      subi $t3, $t3, 1
      bnez $t3, loop_d
      # move
      addi $t1, $t1, 4 # move right one pixel
      j back
respond_to_w:
      # check board
      move $t2, $t1
      subi $t2, $t2, BASE_ADDRESS
      ble $t2, 428, back
      # check collision
      move $t2, $t1
      li $t3, 20
      subi $t2, $t2, WIDTH
loop_w:
      lw $t4, ($t2)
      bne $t4, BLACK, back
      addi $t2, $t2, SINGLE_P
      subi $t3, $t3, 1
      bnez $t3, loop_w
      # move
      subi $t1, $t1, WIDTH # move up one pixel
      j back
respond_to_s:
      # check board
      move $t2, $t1
      li $t3, WIDTH
      mul $t3, $t3, 55
      addi $t3, $t3, BASE_ADDRESS
      sub $t2, $t2, $t3
      bgez $t2, back
      # check collision
      move $t2, $t1
      li $t3, 20
      li $t5, 9
      mul $t5, $t5, WIDTH
      add $t2, $t2, $t5
loop_s:
      lw $t4, ($t2)
      bne $t4, BLACK, back
      addi $t2, $t2, SINGLE_P
      subi $t3, $t3, 1
      bnez $t3, loop_s
      # move
      addi $t1, $t1, WIDTH # move down one pixel
      j back

      
CREAT_PLATFORM:
      subi $sp, $sp 4 # save the return address
      sw $ra, ($sp) 
      subi $sp, $sp, 4 # save the old fp
      sw $fp, ($sp)
      move $fp, $sp # set the new fp
      move $t6, $a0
      beq $t6, 1, type1
      beq $t6, 2, type2
      beq $t6, 3, type3
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
      lw $t4, 0($t2) # load the width
      subi $sp, $sp, 4 # save the width
      sw $t4, ($sp)
      lw $t3, 4($t2) # load the height
      subi $sp, $sp, 4 # save the height
      sw $t3, ($sp)
      lw $t0, 8($t2) # load the starting pixel
PLAT_LOOP:
      li $t1, GREY
      lw $t2, -4($fp) # load the width
      move $a0, $t2 # pass in the number of pixels to be painted
      move $a1, $t1 # pass in the colour to paint
      move $a2, $t0 # pass in the starting pixel
      jal PAINT
      move $t0, $v0 # get the return value
      lw $t1, -4($fp) # get the width
      mul $t1, $t1, SINGLE_P # go to the next row
      li $t2, WIDTH
      sub $t2, $t2, $t1
      add $t0, $t0, $t2 # set the next starting pixel
      lw $t3, -8($fp) # load the height
      subi $t3, $t3, 1 # height - 1
      sw $t3, -8($fp) # save the remaining height 
      bnez $t3, PLAT_LOOP
      
      move $sp, $fp # restore sp
      lw $fp, ($sp) # restore the old fp
      addi $sp, $sp, 4
      lw $ra, ($sp) #restore the return address
      addi $sp, $sp, 4
      jr $ra
      
CREAT_HEALTH:
      subi $sp, $sp 4 # save the return address
      sw $ra, ($sp) 
      la $t2, health # load the address
      lw $t3, 8($t2) # load the starting pixel
      li $t1, 2 # draw the first orange part in the 1st row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2
      mul $t1, $t1, SINGLE_P # skip to the next pixel need to be paint
      add $t3, $t3, $t1
      li $t1, 2 # draw the second orange part in the 1st row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the health
      li $t1, 6
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 2 # draw the first orange part in the 2nd row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2
      mul $t1, $t1, SINGLE_P # skip to the next pixel need to be paint
      add $t3, $t3, $t1
      li $t1, 2 # draw the second orange part in the 2nd row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the health
      li $t1, 6
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 6 # draw the orange part in the 3rd row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT 
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the health
      li $t1, 6
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 6 # draw the orange part in the 4th row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the health
      li $t1, 4
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 2 # draw the orange part in the 5th row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the health
      li $t1, 2
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 2 # draw the orange part in the 6th row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the health
      li $t1, 2
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 2 # draw the orange part in the 7th row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the health
      li $t1, 2
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 2 # draw the orange part in the 8th row
      li $t0, ORANGE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
      
CREAT_BOMB:
      subi $sp, $sp 4 # save the return address
      sw $ra, ($sp) 
      la $t2, bomb # load the address
      lw $t3, 8($t2) # load the starting pixel
      li $t4, 3
      mul $t4, $t4, SINGLE_P
      add $t3, $t3, $t4
      li $t1, 2 # draw the red part in the 1st row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, WIDTH # go to the next row of the bomb
      li $t2, 2
      mul $t2, $t2, SINGLE_P
      sub $t1, $t1, $t2
      add $t3, $t3, $t1
      li $t0, RED
      sw $t0, ($t3) # paint the pixel
      li $t2, WIDTH # go to the next row of the bomb
      sub $t2, $t2, SINGLE_P
      add $t3, $t3, $t2
      li $t1, 3 # draw the purple part in the 3rd row of the bomb
      li $t0, PURPLE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the bomb
      li $t1, 4
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 5 # draw the purple part in the 4th row of the car
      li $t0, PURPLE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the bomb
      li $t1, 6
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 7 # draw the purple part in the 5th row of the car
      li $t0, PURPLE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the bomb
      li $t1, 7
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 7 # draw the purple part in the 6th row of the car
      li $t0, PURPLE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the bomb
      li $t1, 7
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 7 # draw the purple part in the 7th row of the car
      li $t0, PURPLE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the bomb
      li $t1, 6
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 5 # draw the purple part in the 8th row of the car
      li $t0, PURPLE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the bomb
      li $t1, 4
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 3 # draw the purple part in the 9th row of the car
      li $t0, PURPLE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra
      
CREAT_CHARACTER:
      subi $sp, $sp 4 # save the return address
      sw $ra, ($sp) 
      la $t2, character
      lw $t3, 8($t2) # load the starting pixel
      li $t4, 4
      mul $t4, $t4, SINGLE_P
      add $t3, $t3, $t4
      li $t1, 3 # draw the first red part in the first row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 4 # draw the brown part in the first row of the car
      li $t0, BROWN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 3 # draw the second red part in the first row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the car
      li $t1, 11
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 4 # draw the first red part in the second row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t0, BROWN # paint the brown part
      sw $t0, ($t3)
      addi $t3, $t3, SINGLE_P 
      li $t1, 3 # draw the grey part in the second row of the car
      li $t0, GREY
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t0, BROWN # paint the brown part
      sw $t0, ($t3)
      addi $t3, $t3, SINGLE_P 
      li $t1, 4 # draw the second red part in the second row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t2, WIDTH # go to the next row of the car
      li $t1, 14
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2
      li $t1, 5 # draw the first red part in the thrid row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t0, BROWN # paint the brown part
      sw $t0, ($t3)
      addi $t3, $t3, SINGLE_P
      li $t1, 4 # draw the grey part in the third row of the car
      li $t0, GREY
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t0, BROWN # paint the brown part
      sw $t0, ($t3)
      addi $t3, $t3, SINGLE_P
      li $t1, 4 # draw the second red part in the third row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, WIDTH # go to the next row of the car
      li $t4, 16
      mul $t4, $t4, SINGLE_P
      sub $t1, $t1, $t4
      add $t3, $t3, $t1
      li $t1, 6 # draw the first red part in the forth row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 6 # draw the brown part in the forth row of the car
      li $t0, BROWN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 5 # draw the second red part in the forth row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, WIDTH # go to the next row of the car
      li $t4, 17
      mul $t4, $t4, SINGLE_P
      sub $t1, $t1, $t4
      add $t3, $t3, $t1
      li $t1, 2 # draw the first red part in the fifth row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 3 # draw the first dark green part in the fifth row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 8 # draw the second red part in the fifth row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 3 # draw the second dark green part in the fifth row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the third red part in the fifth row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, WIDTH # go to the next row of the car
      li $t4, 18
      mul $t4, $t4, SINGLE_P
      sub $t1, $t1, $t4
      add $t3, $t3, $t1
      li $t1, 1 # draw the first red part in the 6th row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the first dark green part in the 6th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the first white part in the 6th row of the car
      li $t0, WHITE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the second dark green part in the 6th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 6 # draw the second red part in the 6th row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the third dark green part in the 6th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the second white part in the 6th row of the car
      li $t0, WHITE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the forth dark green part in the 6th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the third red part in the 6th row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, WIDTH # go to the next row of the car
      li $t4, 19
      mul $t4, $t4, SINGLE_P
      sub $t1, $t1, $t4
      add $t3, $t3, $t1
      li $t1, 1 # draw the first red part in the 7th row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the first dark green part in the 7th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 3 # draw the first white part in the 7th row of the car
      li $t0, WHITE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the second dark green part in the 7th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 6 # draw the second red part in the 7th row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the third dark green part in the 7th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 3 # draw the second white part in the 7th row of the car
      li $t0, WHITE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the forth dark green part in the 7th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the third red part in the 7th row of the car
      li $t0, RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, WIDTH # go to the next row of the car
      li $t4, 20
      mul $t4, $t4, SINGLE_P
      sub $t1, $t1, $t4
      add $t3, $t3, $t1
      li $t1, 2 # draw the first dark red part in the 8th row of the car
      li $t0, DARK_RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the first dark green part in the 8th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the first white part in the 8th row of the car
      li $t0, WHITE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the second dark green part in the 8th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 6 # draw the second dark red part in the 8th row of the car
      li $t0, DARK_RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the third dark green part in the 8th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 1 # draw the second white part in the 8th row of the car
      li $t0, WHITE
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the forth dark green part in the 8th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 2 # draw the third red part in the 8th row of the car
      li $t0, DARK_RED
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, WIDTH # go to the next row of the car
      li $t4, 17
      mul $t4, $t4, SINGLE_P
      sub $t1, $t1, $t4
      add $t3, $t3, $t1
      li $t1, 3 # draw the first dark green part in the 9th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      move $t3, $v0 # get the return pixel
      li $t1, 8 # skip to the next pixel need to be painted
      mul $t1, $t1, SINGLE_P
      add $t3, $t3, $t1
      li $t1, 3 # draw the second dark green part in the 9th row of the car
      li $t0, DARK_GREEN
      move $a0, $t1 # pass in the width
      move $a1, $t0 # pass in the colour
      move $a2, $t3 # pass in the start pixel
      jal PAINT
      
      lw $ra, ($sp) # restore ra
      addi $sp, $sp, 4
      jr $ra       
      
PAINT:
      move $t0, $a0 # t0 is the width
      move $t1, $a1 # t1 is the colour
      move $t2, $a2 # t2 is the starting pixel
LOOP_PAINT:
      sw $t1, ($t2) # paint the pixel
      addi $t2, $t2, SINGLE_P # go to the next pixel
      subi $t0, $t0, 1 # go to the next loop
      bnez $t0, LOOP_PAINT
      move $v0, $t2 # return the ending pixel
      jr $ra
      
REMOVE:
      subi $sp, $sp, 4 # push the return address
      sw $ra, ($sp)
      move $t1, $a0 # pop off the width
      subi $sp, $sp, 4 # push the width
      sw $t1, ($sp)
      move $t2, $a1 # pop off the height
      subi $sp, $sp, 4 # save the height
      sw $t2, ($sp)
      move $t3, $a2 # pop off the starting pixel
LOOP_REMOVE:
      li $t0, BLACK
      lw $t1, 4($sp)
      move $a0, $t1 # push the width
      move $a1, $t0 # push the colour
      move $a2, $t3 # push the starting pixel
      jal PAINT
      move $t3, $v0 # get the return address
      lw $t1, 4($sp) # get the width
      li $t2, WIDTH
      mul $t1, $t1, SINGLE_P
      sub $t2, $t2, $t1
      add $t3, $t3, $t2 # go to the next row
      lw $t2, ($sp) # get the height
      subi $t2, $t2, 1
      sw $t2, ($sp) # update the height
      bnez $t2, LOOP_REMOVE
      
      lw $ra, 8($sp) # restore ra
      addi $sp, $sp, 12
      jr $ra
      
CLEAR_SCREEN:
      subi $sp, $sp, 4 # push the return address
      sw $ra, ($sp)
      li $t0, 0
      subi $sp, $sp, 4 # push the height
      sw $t0, ($sp)
CLEAR_LOOP:
      li $t1, BLACK
      li $a0, 128 # pass in the number of pixel
      move $a1, $t1 # pass in the color
      li $t2, BASE_ADDRESS
      li $t3, WIDTH
      mul $t3, $t3, $t0
      add $t2, $t2, $t3
      move $a2, $t2 # pass in the starting pixel
      jal PAINT
      lw $t0, ($sp)
      addi $t0, $t0, 1
      sw $t0, ($sp)
      bne $t0, 64, CLEAR_LOOP
      
      lw $ra, 4($sp) # restore ra
      addi $sp, $sp, 8
      jr $ra
      
      
