# is_prime.s
# Tells if a number is prime

.data
	intarray: 
		.word 7
		.word 16
		.word 23
		.word 40
		.word 11
		.word 39
		.word 37
		.word 10
		.word 2
		.word 18
	size: .word 10
	arrayPrime: .space 20 	# 20 btyes = 5 prime numbers
	arrayComposite: .space 20 	# 20 btyes = 5 composite numbers
	np_space: .asciiz "  -->  This is not prime\n"
	p_space: .asciiz " -->  This is prime\n"
.text
lui $sp 0x8000 # initialize the stack pointer


main:

	addiu $sp,$sp,-4 # stack grows by XX bytes
	sw $ra, 0($sp) # save return address into stack
	la $s1, intarray # get array address
	lw $s2, size
	add	$s0, $zero,	$zero # set loop counter
	addi $s5, $zero, 0	# set counter for prime array
	addi $s6, $zero, 0	# set counter for composite array

print_loop:

	beq $s0, $s2, print_loop_end # check for array end


	lw $t0, ($s1)
	add	$a0, $t0, $zero	 #a0	get	the	value	of	i
	jal	is_prime

	beq $v0, 1, yes_prime
	#beq $v0, $zero, not_prime
	#beq $v0, 1, yes_prime

not_prime:
	sw $a0, arrayComposite($s6)
	li $v0, 1				# a 4 in $v0 indicates to print a string
	syscall	
	li $v0, 4				# a 4 in $v0 indicates to print a string
	la $a0, np_space 				# load address into $a0 for printing carriage return
	syscall	
	#j $ra
	addi $s0, $s0, 1 # advance loop counter
	addi $s1, $s1, 4 # advance array pointer
	addi $s6, $s6, 4	# set counter for composite array
	j print_loop # repeat the loop

yes_prime:
	sw $a0, arrayComposite($s5)
	li $v0, 1				# a 4 in $v0 indicates to print a string
	syscall	
	li $v0, 4				# a 4 in $v0 indicates to print a string
	la $a0, p_space 				# load address into $a0 for printing carriage return
	syscall	
	#j $ra
	addi $s0, $s0, 1 # advance loop counter
	addi $s1, $s1, 4 # advance array pointer
	addi $s5, $s5, 4	# counter for prime array
	j print_loop # repeat the loop	

print_loop_end:
	la $s1, arrayComposite # get array address
	#li	$v0, 1
	lw $a0, 16($s1)
	li	$v0, 1
	syscall
	li	$v0, 10				# exit the program
	syscall	



is_prime:
	addi	$t0, $zero, 2				# int x = 2
	
is_prime_test:
	slt	$t1, $t0, $a0				# if (x > num)
	bne	$t1, $zero, is_prime_loop		
	addi	$v0, $zero, 1				# It's prime!
	jr	$ra						# return 1

is_prime_loop:						# else
	div	$a0, $t0					
	mfhi	$t3						# c = (num % x)
	slti	$t4, $t3, 1				
	beq	$t4, $zero, is_prime_loop_continue	# if (c == 0)
	add	$v0, $zero, $zero				# its not a prime
	jr	$ra							# return 0

is_prime_loop_continue:		
	addi $t0, $t0, 1				# x++
	j	is_prime_test				# continue the loop