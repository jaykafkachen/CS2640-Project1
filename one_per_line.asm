# Who:  Jay Chen
# What: one_per_line.asm
# Why:  part 1 of project 1, prints 1 int per line 
# When: due 3/1/19
# How:  List the uses of registers

.data
    array:      .space      80      #reserve 80 bytes (4byte word)*20 int values in array
    array_size: .word       80
    prompt:     .asciiz     "Enter int value: "
    out_prompt: .asciiz     "Ints entered: \n"

.text
.globl main


main:	# program entry



li $v0, 10		# terminate the program
syscall
