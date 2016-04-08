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




