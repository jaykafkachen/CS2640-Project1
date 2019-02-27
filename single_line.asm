# Who:  Jay Chen
# What: single_line.asm
# Why:  part 2 of project 1, prints all ints on 1 line 
# When: due 3/1/19
# How:  List the uses of registers
#   $t0 - stores starting address of array in memory
#   $t1 - stores size of array, holds upperbound addr of array 
#   $t2 - stores true/false values for loop, input/output prompts for printing to console,next int to be printed in output loop

.data
    array:      .space      80      #reserve 80 bytes (4byte word)*20 int values in array
    arraysize:  .word       20
    prompt:     .asciiz     "Enter int value: "
    outprompt:  .asciiz     "Ints entered: "

.text
.globl main


main:	# program entry
    la $t0, array
    la $t1, arraysize               #load address to arraysize into #t1
    lw $t1, 0($t1)                  #t1 now holds value at addr it stored prev
    sll $t1, $t1, 2                 #shift t1 left by 2 (multiply by 2^2 = 4, now t1 is the offset 80
    addu $t1, $t0, $t1              #t1 = upperbound arr starting $t0 
    

    inputloop:
        slt $t2, $t0, $t1           #set t2 true(1) if value at t0<t1, else t2 false(0)
        beq $t2, $0, endinputloop   #branch to endinputloop if t2 = 0, false

        #prompt for input
        la $t2, prompt              #load address to prompt string to t2
        move $a0, $t2               #add address of prompt string from t3 to a0 for print syscall
        li $v0, 4                   #load instruction into v0, code 4 to print string stored in a0
        syscall

        #get input
        li $v0, 5                   #read integer input, $v0 stores user input
        syscall

        sw $v0, 0($t0)              #store int accepted by $v0  into array at $t0 addr of array

        addiu $t0, $t0, 4           #add 4 bytes to t0, iterator moves to next space in array
        j inputloop                 #jump back up to start of loop
    endinputloop: 

    la $t0, array                   #reset t0 to starting array address
    la $t1, arraysize               #load address to arraysize into #t1
    lw $t1, 0($t1)                  #t1 now holds value at addr it stored prev
    sll $t1, $t1, 2                 #shift t1 left by 2 (multiply by 2^2 = 4, now t1 is the offset 80
    addu $t1, $t0, $t1              #t1 = upperbound arr starting $t0 
    
    
    #print output label
    la $t2, outprompt              
    move $a0, $t2
    li $v0, 4
    syscall

    outputloop:
        slt $t2, $t0, $t1
        beq $t2, $0, endoutputloop

        lw $t2, 0($t0)

        #print integer
        move $a0, $t2
        li $v0, 1
        syscall

        #print space after int
        li $a0, 32                   #ascii 32 for whitespace
        li $v0, 11                   #syscall code  for printing character
        syscall
        
        addi $t0, $t0, 4
        j outputloop 
    endoutputloop:

exit:
    li $v0, 10		                # terminate the program
    syscall
