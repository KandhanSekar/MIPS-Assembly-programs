.eqv SYS_EXIT 10
.eqv SYS_PRINT_CHAR 11
.eqv SYS_PRINT_INT 1
.eqv SYS_PRINT_STR 4
.eqv SYS_READ_INT 5
.eqv SYS_READ_STR 8

.data

 e_c2:	.asciiz "Enter c2? "			# char *e_c2="Enter c2? "
 e_c1:	.asciiz "Enter c1? "			# char *e_c1="Enter c1? "
 e_c0:	.asciiz "Enter c0? "			# char *e_c0="Enter c0? "
 e_x:	.asciiz "Enter x? "			# char *e_x="Enter x? "
 e_ans:	.asciiz "p(x) = "			# char *e_x="p(x) = "
 
 .text
  main:
  	addi, $sp, $sp, -24			# Allocating 6 words including $ra
  	#sw $ra, 20($sp)				# Save $ra
  	# c2 = getint("Enter c2? ")
	la $a0, e_c2				# $a0 = "Enter c2? "
	jal getint				# Call 	getint()
	sw $v0, 8($sp)				# Save c2
	
	# c1 = getint("Enter c1? ")
	la $a0, e_c1				# $a0 = "Enter c1? "
	jal getint				# Call 	getint()
	sw $v0, 4($sp)				# Save c1
	
	# c0 = getint("Enter c0? ")
	la $a0, e_c0				# $a0 = "Enter c0? "
	jal getint				# Call 	getint()
	sw $v0, 0($sp)				# Save c0
	
	# x = getint("Enter x? ")
	la $a0, e_x				# $a0 = "Enter x? "
	jal getint				# Call 	getint()
	sw $v0, 16($sp)				# Save x
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 16($sp)
	# p_of_x = evalpoly(c0, c1, c2, x)
	jal evalpoly				# Call evalpoly()
	sw $v0, 12($sp)				# p_of_x = evalpoly(c0, c1, c2, x)
	lw $a1, 12($sp)				# $a1 = p_of_x
	la $a0, e_ans				# $a0 = "p(x) = "
	
	# Calling print()
	jal print				# Call print()
	
	#SysExit()
 	exit:
 	addi	$v0, $zero,SYS_EXIT			# $v0 = SysExit() service code
 	syscall						# Call SysExit()
	
getint:

# Create stack frame
	addi $sp,$sp,-12
	#sw $ra, 8($sp)		
# Stroing addr of prompt in stack
	sw	$a0,4($sp)
	
# SysPrintStr(prompt)
	addi	$v0,$zero,SYS_PRINT_STR		#$v0=SysPrintStr service code
	lw	$a0,4($sp)
	# la	$a0,prompt			#$a0=addr of prompt
	syscall					#Syscall

# n = SysReadInt()
	addi	$v0,$zero,SYS_READ_INT		# $v0 = SysReadInt service code
	syscall
	sw	$v0,0($sp)			# store n in stack
	

# Destroy Stack
	#lw $ra, 8($sp)
	lw	$v0,0($sp)
	#sw $zero, 4($sp) 
	addi	$sp,$sp,8
				#Destroy stack frame
	jr	$ra
	
evalpoly:
addi $sp, $sp, -20	# Allocate 5 words in stack frame

sw $a0, 4($sp)		# Save 1st arg in param c0			 
sw $a1, 8($sp) 		# Save 2nd arg in param c1
sw $a2, 12($sp)		# Save 3rd arg in param c2
sw $a3, 16($sp)		# Save 4th arg in param x

lw $t0, 16($sp)		# $t0 = x
mul $t0, $t0, $t0	# $t0 = x * x
lw $t1, 12($sp)		# $t1 = c2
mul $t0, $t0, $t1	# $t0 = c2 * x * x
lw $t1, 8($sp)		# $t1 = c1
lw $t2, 16($sp)		# $t2 = x
mul $t1, $t1, $t2	# $t1 = c1 * x
add $t1, $t1, $t0	# $t1 = c2 * x * x + c1 * x
lw $t2, 4($sp)		# $t2 = c0
add $t1, $t1, $t2	# $t1 = c2 * x * x + c1 * x + c0

sw $t1, 0($sp)		# result = c2 * x * x + c1 * x + c0 

lw $v0, 0($sp)		# $v0 = result
addi $sp, $sp, 20	# Deallocate 5 words
jr $ra

print:

#SysPrintStr(msg)

addi $v0, $zero,SYS_PRINT_STR
syscall


#SysPrintInt(n)

addi	$v0, $zero, SYS_PRINT_INT
add	$a0,$zero, $a1

syscall

# Return
jr	$ra
	
						