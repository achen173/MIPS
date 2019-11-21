# Alan Chen
# ECE 331 Project 1
# 10/14/2019

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
	arrayPrime: .space 20 	# 20 btyes = 5 prime numbers
	arrayComposite: .space 20 	# 20 btyes = 5 composite numbers
	size: .word 10
	np_space: .asciiz "  -->  This is not prime\n"
	p_space: .asciiz " -->  This is prime\n"
	PrimeInit: .asciiz "PrimeArray = {  "
	CompInit: .asciiz "CompositeArray = {  "
	Spacing: .asciiz "  "
	ClosingPara: .asciiz "} \n"
	NewLine: .asciiz "\n"
.text
lui $sp 0x8000 # initialize the stack pointer

main:

	addiu $sp,$sp,-4 						# stack grows by XX bytes
	sw $ra, 0($sp) 							# save return address into stack
	la $s1, intarray 						# get array address
	lw $s2, size 							# loads size into s2 for counter
	add	$s0, $zero,	$zero 					# set loop counter
	addi $s5, $zero, 0						# set counter for prime array
	addi $s6, $zero, 0						# set counter for composite array

print_loop:

	beq $s0, $s2, print_prime_helper 		# check for array end
	lw $a0, ($s1) 							# set value of s1 into arguement
	jal	is_prime 							# return 0 if composite, 1 if prime
	beq $v0, 1, yes_prime					# if it is 1 than go to yes prime

not_prime:
	sw $a0, arrayComposite($s6)				# saves word (isComposite Int) into Composite Array
	li $v0, 1								# a 1 in $v0 indicates to print a string
	syscall									# prints the number in the arrayComposite
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, Spacing 						# load address into $a0 for printing carriage return
	syscall									# prints spacing so two numbers aren't next to each other
	addi $s0, $s0, 1 						# advance loop counter
	addi $s1, $s1, 4 						# advance array pointer
	addi $s6, $s6, 4						# set counter for composite array
	j print_loop 							# repeat the loop for all numbers in ArrayA

yes_prime:
	sw $a0, arrayPrime($s5)					# saves word (isPrime Int) into Prime Array
	li $v0, 1								# a 1 in $v0 indicates to print a integer
	syscall									# prints the number in the arrayPrime
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, Spacing 						# load address into $a0 for printing carriage return
	syscall									# prints spacing so two numbers aren't next to each other
	addi $s0, $s0, 1 						# advance loop counter
	addi $s1, $s1, 4 						# advance array pointer
	addi $s5, $s5, 4						# counter for prime array offset by word (4 bytes)
	j print_loop 							# repeat the loop for all numbers in ArrayA

print_prime_helper:
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, NewLine 						# load address into $a0 for printing carriage return
	syscall									# print out newline (stored in a0)
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, PrimeInit 						# load address into $a0 for printing carriage return
	syscall									# print out "Prime Array = "
	la $s1, arrayPrime 						# get prime array address
	addi $s7, $zero, 0						# set prime array index counter

print_Prime_Array:
	beq $s7, 5, print_comp_helper			# if it is at the end of the loop then print Composite Array
	lw $a0, ($s1)							# load integers in Prime array into a0
	li	$v0, 1								# a 1 in $v0 indicates to print a integer
	syscall									# print out integer (stored in a0)
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, Spacing 						# load address into $a0 for printing carriage return
	syscall									# prints spacing so two numbers aren't next to each other 
	addi $s7, $s7, 1						# increment prime array index counter
	addi $s1, $s1, 4						# increment offset by 4 to get the next int in the prime array
	j print_Prime_Array						# loops back since there is more int in the prime array

print_comp_helper:
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, ClosingPara 					# load address into $a0 for printing carriage return
	syscall									# print out closing parathesis at the end of the prime array	
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, CompInit 						# load address into $a0 for printing carriage return
	syscall									# print out "Composite Array = "
	la $s1, arrayComposite 					# get composite array address
	addi $s7, $zero, 0						# set composite array index counter

print_comp_Array:
	beq $s7, 5, Ending						# if it is at the end of the loop then go to Ending
	lw $a0, ($s1)							# load integers in composite array into a0
	li	$v0, 1								# a 1 in $v0 indicates to print a integer
	syscall									# print out integer (stored in a0)
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, Spacing 						# load address into $a0 for printing carriage return
	syscall									# prints spacing so two numbers aren't next to each other
	addi $s7, $s7, 1						# increment composite array index counter
	addi $s1, $s1, 4						# increment offset by 4 to get the next int in the composite array
	j print_comp_Array						# loops back since there is more int in the composite array

Ending:
	li $v0, 4								# a 4 in $v0 indicates to print a string
	la $a0, ClosingPara 					# load address into $a0 for printing carriage return
	syscall									# print out closing parathesis at the end of the prime array
	la $s1, intarray 						# get array address				(showing for homework)
	la $s2, arrayPrime 						# get prime array address		(showing for homework)
	la $s3, arrayComposite 					# get prime array address		(showing for homework)
	li	$v0, 10								# exit the program
	syscall	

is_prime:
	addi	$t0, $zero, 2					# int x = 2 (prime checking starts at 2)

is_prime_test:
	slt	$t1, $t0, $a0						# if (x > num)
	bne	$t1, $zero, is_prime_loop			# if it is not 0 then check if it is prime
	addi $v0, $zero, 1						# If it is 0 then it's prime!
	jr	$ra									# return 1

is_prime_loop:
	div	$a0, $t0							# divides a0 by t0
	mfhi	$t3								# c = (num % x)
	slti	$t4, $t3, 1						# (t3 < 1) = t4			
	beq	$t4, $zero, is_prime_loop_continue	# if (c == 0)
	add	$v0, $zero, $zero					# its not a prime
	jr	$ra									# return 0

is_prime_loop_continue:		
	addi $t0, $t0, 1						# x++
	j	is_prime_test						# continue the loop