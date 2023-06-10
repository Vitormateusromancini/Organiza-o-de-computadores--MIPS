#   int isPrime(int n){
#       int x, i;
#
#       if (n == 2)
#           return 1;
#
#       for (i = 0; i < 10; i++){
#           x = i % n;
#           if (x < 2)
#               x++;
#           if (powMod(x, n - 1, n) != 1)
#               return 0;
#       }
#       return 1;
#   }

.text

    # a0: n
    li $a0, 89

isPrime:
    # t9: n
    add $t9, $a0, $zero         # $t9 = $a0 (Salva $a0, pois será sobreescrito na chamada de powMod())
    
    # if (n == 2)
    #     return 1; 
    li $s0, 2
    beq $t9, $s0, return1
    
    # for (i = 0; i < 10; i++)
    add $s1, $zero, $zero       # s1: i = 0
for:
    slti $s0, $s1, 10           # i < 10 ?
    beq $s0, $zero, return1     # Break the loop if i >= 10
    
    # x = i % n
    # s2: x
    div $s1, $t9                # i % n
    mfhi $s2                    # x = i % n
    
    # if (x < 2)
    #   x++;
    slti $s0, $s2, 2            # x < 2 ?
    beq $s0, $zero, if2         # Branch to label if2 if x >= 2
    addi $s2, $s2, 1            # x++
    
    # if (powMod(x , n - 1, n) != 1)
    #   return 0;
if2:
    add $a0, $s2, $zero         # a0 <- x
    addi $a1, $t9, -1           # a1 = n - 1             
    add $a2, $t9, $zero         # a2 = n
    jal PowMod                  # powMod(x, n - 1, n)
    li $s0, 1
    beq $v0, $s0, inc_i         # Branch to label inc_i if powMod(x, n - 1, n) == 1
    li $v0, 0                   # return 0
    j isPrime_end
    
inc_i:
    addi $s1, $s1, 1            # i++
    j for
    
return1:
    li $v0,1

isPrime_end:
    # Print result
    add $a0, $v0, $zero
    li $v0, 1                   # Print integer          
    syscall
    
    # Terminate execution
    li $v0, 10
    syscall
    
    


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
    #     result = (result*base) % m;
    
    # (exp & 1) == 1 ?
    andi $t1, $a1, 1            # exp & 1
    beq $t1, $zero, continue    # jump if (exp & 1) == 0
    mult $v0, $a0               # result * base
    mflo $t0                    # t0 = result * base
    div $t0, $a2                # (result*base) % m
    mfhi $v0                    # result = (result*base) % m
    
    # exp >>= 1;   
    # base = (base*base) % m;
continue:
    srl $a1, $a1, 1             # exp >>= 1
    mult $a0, $a0               # base * base
    mflo $t0                    # t0 = base * base
    div $t0,$a2                 # (result*base) % m
    mfhi $a0                    # base = (base*base) % m
    
    j while
    
end_while:
    jr $ra
