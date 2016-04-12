#*********************************************************************************************************
# FILE: Fraction.s
#
# DESCRIPTION
# Prompts the user to enter two fractions, computes the quotient of dividing the two fractions, and prints
# the results.
#
# PSEUDOCODE
# Function main() Returns Nothing
#     int num1, den1, num2, den2, quot_num, quot_den
#     num1, den1 = read_fraction()
#     num2, den2 = read_fraction()
#     quot_num, quot_den = div_fraction(num1, den1, num2, den2)
#     print_fraction(num1, den1)
#     SysPrintStr(" / ")
#     print_fraction(num2, den2)
#     SysPrintStr(" = ");
#     print_fraction(quot_num, quot_den)
#     SysPrintChar('\n')
#     SysExit
# End Function main
#
# Function div_fraction(num1, den1, num2, den2) Returns quot_num, quot_den
#     int inv_num, inv_den, quot_num, quot_den
#     inv_num, inv_den = invert_fraction(num2, den2)
#     quot_num, quot_den = mult_fraction(num1, den1, inv_num, inv_den)
#     Return quot_num, quot_den
# End Function div_fraction
#
# Function invert_fraction(num, den) Returns inv_num, inv_den
#     int inv_num, inv_den
#     inv_num = den
#     inv_den = num
#     If (inv_den < 0) Then
#         inv_num = -inv_num
#         inv_den = -inv_den
#     End If
#     Return inv_num, inv_den
# End Function invert_fraction
#
# Function mult_fraction(num1, den1, num2, den2) Returns prod_num, prod_den
#     int prod_num, prod_den
#     prod_num = num1 * num2
#     prod_den = den1 * den2
#     Return prod_num, prod_den
# End Function mult_fraction
#
# Function print_fraction(num, den)
#     SysPrintInt(num)
#     SysPrintChar('/')
#     SysPrintInt(den)
# End Function print_fraction
#
# Function read_fraction() Returns num, den
#     int num, den
#     SysPrintStr("Enter numerator? ")
#     num = SysReadInt()
#     SysPrintStr("Enter denomerator? ")
#     den = SysReadInt()
#     Return num, den
# End Function read_fraction
#
# AUTHOR
# Kevin Burger (burgerk@asu.edu)
# Computer Science & Engineering
# Arizona State University
#*********************************************************************************************************

#=========================================================================================================
# System Call Equivalents
#=========================================================================================================
.eqv SYS_EXIT        10
.eqv SYS_PRINT_CHAR  11
.eqv SYS_PRINT_INT    1
.eqv SYS_PRINT_STR    4
.eqv SYS_READ_INT     5
.eqv SYS_READ_STR     8

#=========================================================================================================
# DATA SECTION
#=========================================================================================================
.data
s_num_prompt:  .asciiz  "Enter numerator? "
s_den_prompt:  .asciiz  "Enter denominator? "
s_slash:       .asciiz  " / "
s_equal:       .asciiz  " = "

#=========================================================================================================
# TEXT SECTION
#=========================================================================================================
.text

#---------------------------------------------------------------------------------------------------------
# PROCEDURE: main()
#
# STACK
# We allocate 6 words: num1, den1, num2, den2, quot_num, quot_den.
#
# Note: we do not need to save $ra because main() does not return. 
#
# +------------------+
# | local num1       | $sp + 20
# +------------------+
# | local den1       | $sp + 16
# +------------------+
# | local num2       | $sp + 12
# +------------------+
# | local den2       | $sp + 8
# +------------------+
# | local quot_num   | $sp + 4
# +------------------+
# | local quot_den   | $sp
# +------------------+
#---------------------------------------------------------------------------------------------------------
main:
# Create stack frame and allocate 6 words for locals num1, den1, num2, den2, quot_prod, quot_den.
    addi    $sp, $sp, -24              # Allocate 6 words in stack frame

# num1, den1 = read_fraction()
    jal     read_fraction              # Call read_fraction()
    sw      $v0, 20($sp)               # Save num1
    sw      $v1, 16($sp)               # Save den1

# num2, den2 = read_fraction()
    jal     read_fraction              # Call read_fraction()
    sw      $v0, 12($sp)               # Save num2
    sw      $v1, 8($sp)                # Save den2

# quot_num, quot_den = div_fraction(num1, den1, num2, den2)
    lw      $a0, 20($sp)               # $a0 = num1
    lw      $a1, 16($sp)               # $a1 = den1
    lw      $a2, 12($sp)               # $a2 = num2
    lw      $a3, 8($sp)                # $a3 = den2
    jal     div_fraction               # Call div_fraction(num1, den1, num2, den2)
    sw      $v0, 4($sp)                # Save quot_num
    sw      $v1, 0($sp)                # Save quot_den

# print_fraction(num1, den1)
    lw      $a0, 20($sp)               # $a0 = num1
    lw      $a1, 16($sp)               # $a1 = den1
    jal     print_fraction             # Call print_fraction(num1, den1)

# SysPrintStr(" / ")
    addi    $v0, $zero, SYS_PRINT_STR  # $v0 = SysPrintStr service code
    la      $a0, s_slash               # $a0 = addr-of " / "
    syscall                            # SysPrintStr(" / ")

# print_fraction(num2, den2)
    lw      $a0, 12($sp)               # $a0 = num2
    lw      $a1, 8($sp)                # $a1 = den2
    jal     print_fraction             # Call print_fraction(num2, den2)

# SysPrintStr(" = ");
    addi    $v0, $zero, SYS_PRINT_STR  # $v0 = SysPrintStr service code
    la      $a0, s_equal               # $a0 = addr-of " = "
    syscall                            # SysPrintStr(" = ")

# print_fraction(quot_num, quot_den)
    lw      $a0, 4($sp)                # $a0 = quot_num
    lw      $a1, 0($sp)                # $a1 = quot_den
    jal     print_fraction             # Call print_fraction(quot_num, quot_den)

# SysPrintChar('\n')
    addi    $v0, $zero, SYS_PRINT_CHAR # $v0 = SysPrintChar service code
    addi    $a0, $zero, 10             # $a0 = ASCII value of linefeed character '\n'
    syscall                            # SysPrintChar('\n')

# SysExit()
    add     $sp, $sp, 24               # Deallocate 6 words
    addi    $v0, $zero, SYS_EXIT       # $v0 = SysExit service code
    syscall                            # Call SysExit()

#---------------------------------------------------------------------------------------------------------
# PROCEDURE: div_fraction()
#
# PARAMETERS
# $a0 - num1
# $a1 - den1
# $a2 - num2
# $a3 - den2
#
# STACK
# We allocate 7 words: $ra, $a0-$a3, inv_num, inv_den.
#
# Note we have to save $a0-$a3 (containing the input parameters) because when we call invert_fraction()
# we do not know if that function will alter those registers. It is the responsiblity of the caller to
# save $t registers, $a registers, and $v registers.
#
# +------------------+
# |   saved $ra      | $sp + 24
# +------------------+
# | saved $a0 (num1) | $sp + 20
# +------------------+
# | saved $a1 (den1) | $sp + 16
# +------------------+
# | saved $a2 (num2) | $sp + 12
# +------------------+
# | saved $a3 (den2) | $sp + 8
# +------------------+
# | local inv_num    | $sp + 4
# +------------------+
# | local inv_den    | $sp
# +------------------+
#
# RETURNS
# $v0 - quot_num
# $v1 - quot_den
#---------------------------------------------------------------------------------------------------------
div_fraction:
# Create stack frame and allocate 7 words. Save $ra and $a0-$a3.
    addi    $sp, $sp, -28              # Alloc 7 words
    sw      $ra, 24($sp)               # Save $ra
    sw      $a0, 20($sp)               # Save 1st arg in param num1
    sw      $a1, 16($sp)               # Save 2nd arg in param den1
    sw      $a2, 12($sp)               # Save 3rd arg in param num2
    sw      $a3, 8($sp)                # Save 4th arg in param den2

# inv_num, inv_den = invert_fraction(num2, den2)
    lw      $a0, 12($sp)               # $a0 = num2
    lw      $a1, 8($sp)                # $a1 = den2
    jal     invert_fraction            # Call invert_fraction(num2, den2)
    sw      $v0, 4($sp)                # Save returned numerator in inv_num
    sw      $v1, 0($sp)                # Save returned denominator in inv_den

# quot_num, quot_den = mult_fraction(num1, den1, inv_num, inv_den)
    lw      $a0, 20($sp)               # $a0 =  num1
    lw      $a1, 16($sp)               # $a1 =  den1
    lw      $a2, 4($sp)                # $a2 =  inv_num
    lw      $a3, 0($sp)                # $a3 =  inv_den
    jal     mult_fraction              # Call mult_fraction(num1, den1, inv_num, inv_den)

# Note that mult_fraction returns quot_num in $v0 and quot_den in $v1. This procedure simply returns
# those values in $v0 and $v1 as well.

# Return quot_num, quot_den
    lw      $ra, 24($sp)               # Restore $ra
    add     $sp, $sp, 28               # Deallocate 7 words
    jr      $ra                        # Return quot_num in $v0, quot_den in $v1

#---------------------------------------------------------------------------------------------------------
# PROCEDURE: invert_fraction()
#
# PARAMETERS
# $a0 - num
# $a1 - den
#
# STACK
# We allocate 2 words: inv_num, and inv_den.
#
# +------------------+
# | local inv_num    | $sp + 4
# +------------------+
# | local inv_den    | $sp
# +------------------+
#
# RETURNS
# $v0 - inv_num
# $v1 - inv_den
#---------------------------------------------------------------------------------------------------------
invert_fraction:
# Create stack frame and allocate 2 words.
    addi    $sp, $sp, -8               # Allocate 2 words in stack frame

# inv_num = den
    sw      $a1, 4($sp)                # inv_num = den

# inv_den = num
    sw      $a0, 0($sp)                # inv_den = num

# If (inv_den < 0) Then ...
    lw      $t0, 0($sp)                # $t0 = inv_den
    bge     $t0, $zero, end_if         # If inv_den >= 0 skip over true clause
    lw      $t1, 4($sp)                # $t1 = inv_num
    neg     $t1, $t1                   # $t1 = -inv_num
    sw      $t1, 4($sp)                # inv_num = -inv_num
    neg     $t0, $t0                   # $t0 = -inv_den
    sw      $t0, 0($sp)                # inv_den = -inv_den
end_if:

# Return inv_num, inv_den
    lw      $v0, 4($sp)                # $v0 = inv_num
    lw      $v1, 0($sp)                # $v1 = inv_den
    add     $sp, $sp, 8                # Deallocate 2 words
    jr      $ra                        # Return inv_num in $v0 and inv_den in $v1

#---------------------------------------------------------------------------------------------------------
# PROCEDURE: mult_fraction()
#
# PARAMETERS
# $a0 - num1
# $a1 - den1
# $a2 - num2
# $a3 - den2
#
# STACK
# We allocate 2 words: prod_num, prod_den.
#
# +------------------+
# | local prod_num   | $sp + 4
# +------------------+
# | local prod_den   | $sp
# +------------------+
#
# RETURNS
# $v0 - prod_num
# $v1 - prod_den
#---------------------------------------------------------------------------------------------------------
mult_fraction:
# Create stack frame and allocate 2 words.
    addi    $sp, $sp, -8               # Allocate 2 words in stack frame

# prod_num = num1 * num2
    mul     $t0, $a0, $a2              # $t0 = num1 * num2
    sw      $t0, 4($sp)                # prod_num = num1 * num2

# prod_den = den1 * den2
    mul     $t0, $a1, $a3              # $t0 = den1 * den2
    sw      $t0, 0($sp)                # prod_den = den1 * den2

# Return prod_num, prod_den
    lw      $v0, 4($sp)                # $v0 = prod_num
    lw      $v1, 0($sp)                # $v1 = prod_den
    add     $sp, $sp, 8                # Deallocate 2 words
    jr      $ra                        # Return prod_num in $v0 and prod_den in $v1

#---------------------------------------------------------------------------------------------------------
# PROCEDURE: print_fraction()
#
# PARAMETERS
# $a0 - num1
# $a1 - den1
#
# STACK
# print_fraction() is a leaf procedure and does not allocate any local variables so there is no need to
# create a stack frame.
#
# RETURNS
# Nothing
#---------------------------------------------------------------------------------------------------------
print_fraction:
# SysPrintInt(num)
    addi    $v0, $zero, SYS_PRINT_INT  # $v0 = SysPrintInt service code
    syscall                            # SysPrintInt(num)

# SysPrintChar('/')
    addi    $v0, $zero, SYS_PRINT_CHAR # $v0 = SysPrintChar service code
    addi    $a0, $zero, 47             # $a0 = ASCII value of '/'
    syscall                            # SysPrintChar('/')

# SysPrintInt(den)
    addi    $v0, $zero, SYS_PRINT_INT  # $v0 = SysPrintInt service code
    move    $a0, $a1                   # $a0 = den
    syscall                            # SysPrintInt(den)

# Return 
    jr      $ra                        # Return nothing

#---------------------------------------------------------------------------------------------------------
# PROCEDURE: read_fraction()
#
# PARAMETERS
# None
#
# STACK
# We allocate 3 words: $ra, num, den.
#
# +------------------+
# |   saved $ra      | $sp + 8
# +------------------+
# |   local num      | $sp + 4
# +------------------+
# |   local den      | $sp
# +------------------+
#
# RETURNS
# $v0 - num
# $v1 - den
#---------------------------------------------------------------------------------------------------------
read_fraction:
# Create stack frame and allocate 3 words.
    addi    $sp, $sp, -12              # Allocate 3 words in stack frame
    sw      $ra, 8($sp)                # Save $ra

# SysPrintStr("Enter numerator? ")
    addi    $v0, $zero, SYS_PRINT_STR  # $v0 = SysPrintStr service code
    la      $a0, s_num_prompt          # $a0 = addr-of "Enter numerator? "
    syscall                            # SysPrintStr("Enter numerator? ")

# num = SysReadInt()
    addi    $v0, $zero, SYS_READ_INT   # $v0 = SysReadInt service code
    syscall                            # $v0 = SysReadInt()
    sw      $v0, 4($sp)                # num = SysReadInt()

# SysPrintStr("Enter denomerator? ")
    addi    $v0, $zero, SYS_PRINT_STR  # $v0 = SysPrintStr service code
    la      $a0, s_den_prompt          # $a0 = addr-of "Enter denominator? "
    syscall                            # SysPrintStr("Enter denominator? ")

# den = SysReadInt()
    addi    $v0, $zero, SYS_READ_INT   # $v0 = SysReadInt service code
    syscall                            # $v0 = SysReadInt()
    sw      $v0, 0($sp)                # den = SysReadInt()

# Return num, den
    lw      $ra, 8($sp)                # Restore $ra
    lw      $v0, 4($sp)                # $v0 = num
    lw      $v1, 0($sp)                # $v1 = den
    add     $sp, $sp, 12               # Deallocate 3 words
    jr      $ra                        # Return num in $v0 and den in $v1
