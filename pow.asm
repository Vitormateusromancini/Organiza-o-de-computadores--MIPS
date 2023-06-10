#   int pow (int base, unsigned int exp) {    
#       int result = 1;    
#
#       while (exp > 0) {        
#           if (exp & 1)            
#               result *= base;        
#           exp >>= 1;  // exp divided by 2    
#           base *= base;    
#       }    
#       return result;
#}

.text

    # a0: base
    li $a0, 5
    
    # a1: exp
    li $a1, 3

Pow:
    # v0: result
    li $v0,1    

    # while (exp > 0) 
while:
    slt $t0, $zero, $a1         # 0 < exp ?
    beq $t0, $zero, end_while   # Break the loop if exp <= 0
    
    # if (exp & 1)
    #     result *= base;
    
    # (exp & 1) == 1 ?
    andi $t1, $a1, 1            # exp & 1
    beq $t1, $zero, continue    # jump if (exp & 1) == 0
    mult $v0, $a0               # result * base
    mflo $v0                    # result = result * base
    
    # exp >>= 1;   
    # base *= base;
continue:
    srl $a1, $a1, 1             # exp >>= 1
    mult $a0, $a0               # base * base
    mflo $a0                    # base = base * base 
    
    j while
    
end_while:

    # Print result
    add $a0, $v0, $zero
    li $v0, 1                   # Print integer          
    syscall
    
    # Terminate execution
    li $v0, 10
    syscall
    