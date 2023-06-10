#   int PowMod(int base, unsigned int exp, int m) {
#       int result = 1;      
# 
#       base = base % m;  
# 
#       while (exp > 0) {
#           if (exp & 1)
#               result = (result * base) % m;
# 
#           exp = exp >> 1; // exp = exp / 2
#           base = (base * base) % m;  
#       }
#       return result;
#}

.text

    # a0: base
    li $a0, 6
    
    # a1: exp
    li $a1, 15
    
    # a3: m
    li $a2, 251

PowMod:
    # v0: result
    li $v0,1    
    
    # base = base % m
    div $a0, $a2                # base % m
    mfhi $a0                    # base = base % m

    # while (exp > 0) 
while:
    slt $t0, $zero, $a1         # 0 < exp ?
    beq $t0, $zero, end_while   # Break the loop if exp <= 0
    
    # if (exp & 1)
    #     result = (result * base) % m;
    
    # (exp & 1) == 1 ?
    andi $t1, $a1, 1            # exp & 1
    beq $t1, $zero, continue    # jump if (exp & 1) == 0
    mult $v0, $a0               # result * base
    mflo $t0                    # t0 = result * base
    div $t0, $a2                # (result*base) % m
    mfhi $v0                    # result = (result*base) % m
    
    # exp >>= 1;   
    # base = (base * base) % m;
continue:
    srl $a1, $a1, 1             # exp >>= 1
    mult $a0, $a0               # base * base
    mflo $t0                    # t0 = base * base
    div $t0,$a2                 # (result * base) % m
    mfhi $a0                    # base = (base * base) % m
    
    j while
    
end_while:

    # Print result
    add $a0, $v0, $zero
    li $v0, 1                   # Print integer          
    syscall

    # Terminate execution
    li $v0, 10
    syscall
    