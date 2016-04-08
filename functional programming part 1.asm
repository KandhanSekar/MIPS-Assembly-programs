#FUNCTION: void print(string msg, int n)

# PARAMETERS
# $a0,msg
# $a1 n

print:

#SysPrintStr(msg)

addi	$v0,SYS_PRINT_STR
syscall


#SysPrintInt(n)

addi	$v0,SYS_PRINT_INT
move	$a0,$a1

syscall

# Return
jr	$ra
	