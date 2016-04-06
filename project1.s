 # DESCRIPTION 
# Asks the user to enter three integer coefficients c2, c1, and c0 of a 2nd
# degree polynomial and a value for x. Evaluates the polynomial at x and prints 
# the result. 
# 
# AUTHOR INFO 
# Kandhan Sekar (ksekar1@asu.edu) 

# System Call Equivalents
.eqv SYS_PRINT_INT   1
.eqv SYS_EXIT       10
.eqv SYS_PRINT_STR  4
.eqv SYS_READ_INT    5
.eqv SYS_READ_STR    8


#DATA SECTION
 .data
 
 c2:	.word	0					# int c2=0
 c0:	.word	0					# int c0=0
 c1:	.word	0					# int c1=0
 x:	.word	0					# int x=0
 p_of_x: .word	0					# int p_of_x
 e_c2:	.asciiz "Enter c2? "				# char *e_c2="Enter c2? "
 e_c1:	.asciiz "Enter c1? "				# char *e_c1="Enter c1? "
 e_c0:	.asciiz "Enter c0? "				# char *e_c0="Enter c0? "
 e_x:	.asciiz "Enter x? "				# char *e_x="Enter x? "
 e_ans:	.asciiz "p(x) = "				# char *e_x="p(x) = "
 
 
 #TEXT SECTION
 	
 .text
 
 main:
 
 # SysPrintStr("Enter c2? ")
 	addi	$v0,$zero,SYS_PRINT_STR			# $v0 = SysPrintStr service code
 	la	$a0,e_c2				# $a0=addr of string
 	syscall						# Call SysPrintStr()
 
 # c2=SysReadInt()
 	addi 	$v0,$zero,SYS_READ_INT			# $v0 = SysReadInt() code
 	syscall						# Call SysReadInt(), $v0 contains data
 	la 	$t2,c2					# $t0=addr of c2
 	sw	$v0,0($t2)				# c2=SysReadInt()
 
# SysPrintStr("Enter c1? ")
 	addi	$v0,$zero,SYS_PRINT_STR			# $v0 = SysPrintStr service code
 	la	$a0,e_c1				# $a0=addr of string
 	syscall						# Call SysPrintStr()
 
 # c1=SysReadInt()
 	addi 	$v0,$zero,SYS_READ_INT			# $v0 = SysReadInt() code
 	syscall						# Call SysReadInt()
 	la 	$t1,c1					# $t0=addr of c1
 	sw	$v0,0($t1)				# c1=SysReadInt()
# SysPrintStr("Enter c0? ")
 	addi	$v0,$zero,SYS_PRINT_STR			# $v0 = SysPrintStr service code
 	la	$a0,e_c0				# $a0=addr of string
 	syscall						# Call SysPrintStr()
 
 # c0=SysReadInt()
 	addi 	$v0,$zero,SYS_READ_INT			# $v0 = SysReadInt() code
 	syscall						# Call SysReadInt()
 	la 	$t0,c0					# $t0=addr of c0
 	sw	$v0,0($t0)				# c0=SysReadInt()
# SysPrintStr("Enter x? ")
 	addi	$v0,$zero,SYS_PRINT_STR			# $v0 = SysPrintStr service code
 	la	$a0,e_x					# $a0=addr of string
 	syscall						# Call SysPrintStr()
 
 # x=SysReadInt()
 	addi 	$v0,$zero,SYS_READ_INT			# $v0 = SysReadInt() code
 	syscall						# Call SysReadInt()
 	la 	$t3,x					# $t0=addr of x
 	sw	$v0,0($t3)				# x=SysReadInt()
 	
 	
# SysPrintStr("p(x) = ")
 	addi	$v0,$zero,SYS_PRINT_STR			# $v0 = SysPrintStr service code
 	la	$a0,e_ans				# $a0=addr of string
 	syscall						# Call SysPrintStr()
 	
 	
 	
 	
 	#sum=n+m;
 	la	$s0,n		# $s0=addr n
 	lw 	$t0,0(s0)	#$t0=n		
 	add $t0,$t1,$t2
 	la $s2,sum
 	la	$s2,sum
 	sw	$t2,0($s2)
 	
 	# print int
 	
 	addi $v0,$zero,SYS_PRINT_STR
 	la	$a0,s_result					#a0=addr of sum
 	syscall
 	
 	
 	#hard way
 	
 	la	$s2,sum				#s2=addr of sum
 	addi	$v0,$zero,SYS_PRINTI+_INT
 	lw	$a0,sum				
 	
 	
 	
 	
# p_of_x = c2(x2) + c1(x) + c0 
	mul $t7,$t3,$t3					# t7 <- x * x
	mul $t6,$t7,$t2					# t6 <- t7 * c2
	mul $t5,$t1,$t3					# t5 <- c1*x
	add $t7,$t6,$t5					# t7 <- t5 + t6
	add $t7,$t7,$t0					# t7 <- t7 + c0
	la  $t0,p_of_x
	sw  $t7,0($t0)					# storing the value of the answer
	
 	
# SysPrintInt(p_of_x)
	#lw      $t0,p_of_x
	#addi    $v0, $zero, SYS_PRINT_INT     # $v0 = SysPrintInt service code
    	#move    $a0, $t0                      # $a0 = i
    	#syscall                               # SysPrintInt(i)
	addi    $v0, $zero, SYS_PRINT_INT
	move $a0,$t7
	syscall
	
	
 #SysExit()
 exit:
 	addi	$v0, $zero,SYS_EXIT			# $v0 = SysExit() service code
 	syscall						# Call SysExit()
