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
       
.text 
 
main: 
      li $s2, BASE_ADDRESS
LOOP_MAIN:
      #remove the character
      move $s1, $s2
      li $t0, 9
      li $t1, 20
      subi $sp, $sp, 4
      sw $t0, ($sp)
      subi $sp, $sp, 4
      sw $t1, ($sp)
      jal REMOVE
      # creat the first platform
      li $s1, BASE_ADDRESS
      li $t0, 30 # load the width of the platform
      li $t1, 2 # load the height of the platform
      li $t2, 30 # starting height
      mul $t2, $t2, WIDTH
      add $s1, $s1, $t2 # set the starting pixel for the platform
      jal CREAT_PLATFORM
      # creat the second platform 
      li $s1, BASE_ADDRESS
      li $t0, 15 # load the width of the platform
      li $t1, 2 # load the height of the platform
      li $t2, 20 # starting height
      mul $t2, $t2, WIDTH
      addi $t2, $t2, 200 # starting width
      add $s1, $s1, $t2 # set the starting pixel for the platform
      jal CREAT_PLATFORM
      # creat the third platform
      li $s1, BASE_ADDRESS
      li $t0, 25 # load the width of the platform
      li $t1, 2 # load the height of the platform
      li $t2, 40 # starting height
      mul $t2, $t2, WIDTH
      addi $t2, $t2, 320 # starting width
      add $s1, $s1, $t2 # set the starting pixel for the platform
      jal CREAT_PLATFORM 
      # creat the character
      addi $s2, $s2, SINGLE_P
      move $s1, $s2
      jal CREAT_CHARACTER
      # creat health
      li $s1, BASE_ADDRESS
      addi $s1, $s1, 700 # set the starting pixel for the health
      jal CREAT_HEALTH 
      # creat bomb
      li $s1, BASE_ADDRESS
      addi $s1, $s1, 760 # set the staring pixel for the health
      jal CREAT_BOMB
      
      li $v0, 32
      li $a0, 40
      syscall
      j LOOP_MAIN
      
      li $v0, 10
      syscall

CREAT_PLATFORM:
      li $t3, GREY
      move $s0, $ra # save the return address
LOOP:
      subi $sp, $sp, 4 # push the number of pixels to be painted
      sw $t0, ($sp)
      subi $sp, $sp, 4 # push the colour to paint
      sw $t3, ($sp)
      jal PAINT
      subi $t1, $t1, 1 # go to the next loop
      li $t4, WIDTH # go to next row
      mul $t5, $t0, SINGLE_P
      sub $t4, $t4, $t5
      add $s1, $s1, $t4
      bnez $t1, LOOP
      move $ra, $s0 # restore the return address
      jr $ra
      
CREAT_HEALTH:
      move $s0, $ra
      li $t0, ORANGE
      li $t1, 2 # draw the first orange part in the 1st row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      mul $t1, $t1, SINGLE_P # skip to the next pixel need to be paint
      add $s1, $s1, $t1
      li $t1, 2 # draw the second orange part in the 1st row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the health
      li $t3, 6
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 2 # draw the first orange part in the 2nd row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      mul $t1, $t1, SINGLE_P # skip to the next pixel need to be paint
      add $s1, $s1, $t1
      li $t1, 2 # draw the second orange part in the 2nd row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the health
      li $t3, 6
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 6 # draw the orange part in the 3rd row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the health
      li $t3, 6
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 6 # draw the orange part in the 4th row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the health
      li $t3, 4
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 2 # draw the orange part in the 5th row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the health
      li $t3, 2
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 2 # draw the orange part in the 6th row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the health
      li $t3, 2
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 2 # draw the orange part in the 7th row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the health
      li $t3, 2
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 2 # draw the orange part in the 8th row
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      
      move $ra, $s0
      jr $ra
      
CREAT_BOMB:
      move $s0, $ra
      li $t3, 3
      mul $t3, $t3, SINGLE_P
      add $s1, $s1, $t3
      li $t1, 2 # draw the red part in the 1st row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 2
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t0, RED
      sw $t0, ($s1) # paint the pixel
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 1
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 3 # draw the purple part in the 3rd row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, PURPLE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 4
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 5 # draw the purple part in the 4th row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, PURPLE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 6
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 7 # draw the purple part in the 5th row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, PURPLE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 7
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 7 # draw the purple part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, PURPLE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 7
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 7 # draw the purple part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, PURPLE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 6
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 5 # draw the purple part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, PURPLE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t2, WIDTH # go to the next row of the bomb
      li $t3, 4
      mul $t3, $t3, SINGLE_P
      sub $t2, $t2, $t3
      add $s1, $s1, $t2
      li $t1, 3 # draw the purple part in the 9th row of the car
      subi $sp, $sp, 4 
      sw $t1, ($sp)
      li $t0, PURPLE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      
      move $ra, $s0
      jr $ra
      
CREAT_CHARACTER:
      move $s0, $ra
      li $t3, 4
      mul $t3, $t3, SINGLE_P
      add $s1, $s1, $t3
      li $t3, 3 # draw the first red part in the first row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 4 # draw the brown part in the first row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, BROWN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 3 # draw the second red part in the first row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 11
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 4 # draw the first red part in the second row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t0, BROWN # paint the brown part
      sw $t0, ($s1)
      addi $s1, $s1, SINGLE_P 
      li $t3, 3 # draw the grey part in the second row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, GREY
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t0, BROWN # paint the brown part
      sw $t0, ($s1)
      addi $s1, $s1, SINGLE_P 
      li $t3, 4 # draw the second red part in the second row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 14
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 5 # draw the first red part in the thrid row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t0, BROWN # paint the brown part
      sw $t0, ($s1)
      addi $s1, $s1, SINGLE_P
      li $t3, 4 # draw the grey part in the third row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, GREY
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t0, BROWN # paint the brown part
      sw $t0, ($s1)
      addi $s1, $s1, SINGLE_P
      li $t3, 4 # draw the second red part in the third row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 16
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 6 # draw the first red part in the forth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 6 # draw the brown part in the forth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, BROWN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 5 # draw the second red part in the forth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 17
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 2 # draw the first red part in the fifth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 3 # draw the first dark green part in the fifth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 8 # draw the second red part in the fifth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 3 # draw the second dark green part in the fifth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the third red part in the fifth row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 18
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 1 # draw the first red part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the first dark green part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the first white part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, WHITE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the second dark green part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 6 # draw the second red part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the third dark green part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the second white part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, WHITE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the forth dark green part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the third red part in the 6th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 19
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 1 # draw the first red part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the first dark green part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 3 # draw the first white part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, WHITE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the second dark green part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 6 # draw the second red part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the third dark green part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 3 # draw the second white part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, WHITE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the forth dark green part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the third red part in the 7th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 20
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 2 # draw the first dark red part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the first dark green part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the first white part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, WHITE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the second dark green part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 6 # draw the second dark red part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the third dark green part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 1 # draw the second white part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, WHITE
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the forth dark green part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 2 # draw the third red part in the 8th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_RED
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, WIDTH # go to the next row of the car
      li $t4, 17
      mul $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      li $t3, 3 # draw the first dark green part in the 9th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      li $t3, 8 # skip to the next pixel need to be painted
      mul $t3, $t3, SINGLE_P
      add $s1, $s1, $t3
      li $t3, 3 # draw the second dark green part in the 9th row of the car
      subi $sp, $sp, 4 
      sw $t3, ($sp)
      li $t0, DARK_GREEN
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      
      move $ra, $s0
      jr $ra
      
PAINT:
      lw $t4, ($sp) # pop off the colour needed
      addi $sp, $sp, 4
      lw $t5, ($sp) # pop off the number of pixels
      addi $sp, $sp, 4
LOOP_PAINT:
      sw $t4, ($s1) # paint the pixel
      addi $s1, $s1, SINGLE_P # go to the next pixel
      subi $t5, $t5, 1 # go to the next loop
      bnez $t5, LOOP_PAINT
      jr $ra
      
REMOVE:
      move $s0, $ra
      li $t0, BLACK
      lw $t1, ($sp) # pop off the width
      addi $sp, $sp, 4
      lw $t2, ($sp) # pop off the height
      addi $sp, $sp, 4
LOOP_REMOVE:
      subi $sp, $sp, 4
      sw $t1, ($sp)
      subi $sp, $sp, 4
      sw $t0, ($sp)
      jal PAINT
      subi $t2, $t2, 1
      li $t3, WIDTH
      mul $t4, $t1, SINGLE_P
      #subi $t4, $t4, SINGLE_P
      sub $t3, $t3, $t4
      add $s1, $s1, $t3
      bnez $t2, LOOP_REMOVE
      
      move $ra, $s0
      jr $ra
