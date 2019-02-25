# Who:  Jay Chen
# What: reverse_order.asm
# Why:  part 3 of project 1, prints all ints in reverse & w/ a variable number of line skips 
# When: due 3/1/19
# How:  List the uses of registers
#   $a0 - stores string or int to be printed to console
#   $v0 - stores command from load instruction
#   $t0 - stores starting address of array in memory
#   $t1 - stores size of array, holds upperbound addr of array 
#   $t2 - stores true/false values for loop, next int to be printed in output loop
#   $t3 - stores input/output prompts for printing to console, conditional for when to add newline
#   $t4 - stores number of ints to print per line
#   $t5 - stores counter var for when to change lines 

.data
    array:          .space      80      #reserve 80 bytes (4byte word)*20 int values in array
    arraysize:      .word       20
    prompt:         .asciiz     "Enter int value: "
    outprompt:      .asciiz     "Ints entered: \n"
    prompt_lines:   .asciiz     "\nEnter a number of ints to print per line (<=20): "


.text
.globl main


main:	# program entry
    la $t0, array                   #load array into t0
    la $t1, arraysize               #load address to arraysize into #t1
    lw $t1, 0($t1)                  #t1 now holds value at addr it stored prev
    sll $t1, $t1, 2                 #shift t1 left by 2 (multiply by 2^2 = 4, now t1 is the offset 80
    addu $t1, $t0, $t1              #t1 = upperbound arr starting $t0 
    la $t3, prompt                  #load address to prompt string to t3

    inputloop_rev:
        slt $t2, $t0, $t1           #set t2 true(1) if value at t0<t1, else t2 false(0)
        beq $t2, $0, endinputloop   #branch to endinputloop if t2 = 0, false

        #prompt for input
        move $a0, $t3               #add address of prompt string from t3 to a0 for print syscall
        li $v0, 4                   #load instruction into v0, code 4 to print string stored in a0
        syscall

        #get input
        li $v0, 5                   #read integer input, $v0 stores user input
        syscall

        sw $v0, 0($t0)              #store int accepted by $v0  into array at $t0 addr of array

        addiu $t0, $t0, 4           #add 4 bytes to t0, iterator moves to next space in array
        j inputloop_rev                 #jump back up to start of loop
    endinputloop: 

    #print output label
    la $t3, outprompt           
    move $a0, $t3
    li $v0, 4
    syscall

    la $t1, array                   #reset t1 to start address of array to countdown

    outputloop_rev:
        bge $t1, $t0, endoutputloop_rev     #branch if t0 is greater or equal to t1 (starting array address) 
        sub $t0, $t0, 4                     #decrement t0 to point to next array address up
        lw $t2, 0($t0)                      #load int value at current array pos into t2

        #print integer
        move $a0, $t2
        li $v0, 1
        syscall

        #print space after int
        li $a0, 32                  #ascii 32 for whitespace
        li $v0, 11                  #syscall code  for printing character
        syscall
        
        j outputloop_rev            #exit output loop
    endoutputloop_rev:

    #print prompt for number of ints
    la $t3, prompt_lines              
    move $a0, $t3
    li $v0, 4
    syscall

    #accept user input for number of lines
    li $v0, 5
    syscall
                  
    move $t4, $v0                   #store number of lines in t4

    #print output label
    la $t3, outprompt             
    move $a0, $t3
    li $v0, 4
    syscall

    la $t0, array                   #reset address to start of array 
    la $t1, arraysize               #reset address to arraysize 
    lw $t1, 0($t1)                  #t1 now holds value at addr it stored prev
    sll $t1, $t1, 2                 #shift t1 left by 2 (multiply by 2^2 = 4, now t1 is the offset 80
    addu $t1, $t0, $t1              #t1 = upperbound arr starting $t0 

    outputloop_lines:
        li $t5, 0                   #start/reset counter var t5 at 0
    # nested loop here
        printline:
            slt $t2, $t0, $t1                   #check while t0 less than t1, still array to traverse
            beq $t2, $0, endoutputloop_lines    #branch when reached end of array
            lw $t2, 0($t0)                      #load current array value into t2

            slt $t3, $t5, $t4                   #check if counter t5 less than t4, number of ints to print
            beq $t3, $0, endprintline           #branch if printed specified number of ints
    
            #print integer
            move $a0, $t2
            li $v0, 1
            syscall

            #print space after int
            li $a0, 32                  #ascii 32 for whitespace
            li $v0, 11                  #syscall code  for printing character
            syscall

            addi $t5, $t5, 1            #increment counter var t5
            addi $t0, $t0, 4            #increment t0 to point to next array value address
            j printline
        endprintline:

        #print newline after int
        li $a0, '\n'                #char for newline
        li $v0, 11                  #syscall code  for printing character
        syscall

        j outputloop_lines 
    endoutputloop_lines:

exit:
    li $v0, 10		                # terminate the program
    syscall
