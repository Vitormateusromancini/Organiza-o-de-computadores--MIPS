#   void main() {  
#  
#       int a = 32, b = 24, gcd;  
#  
#       while (b != 0) {  
#           gcd = b;  
#           b = a % b;  
#           a = gcd;  
#       }  
#   }  

.text
    
    # Carga dos endereços das variaveis
    la $t0, a                   # t0 <- &a
    la $t1, b                   # t1 <- &b
    la $t2, gcd                 # t2 <- &gcd
    
    # Carga dos conteúdos das variaveis
    lw $s0, 0($t0)              # s0 <- a
    lw $s1, 0($t1)              # s1 <- b

 
    # while (b != 0) 
while:
    beq $s1, $zero, while_end   # Sai do laço while quando b = 0
     
    add $s2, $s1, $zero         # gcd = b
    
    # b = a % b
    div $s0, $s1                # a % b
    mfhi $s1                    # b = a % b
    
    add $s0, $s2, $zero         # a = gcd   
    
    j while
    
while_end:

    # Atualização das variaveis em memória
    sw $s0, 0($t0)              # a <- s0
    sw $s1, 0($t1)              # b <- s1
    sw $s2, 0($t2)              # gcd <- s2
    
    # Print gcd
    li $v0, 1                   # Print integer
    add $a0, $s2, $zero         
    syscall
    
    # Terminate execution
    li $v0, 10
    syscall

    
    # int a = 32, b = 24, gcd;
.data
    a:      .word   32
    b:      .word   24
    gcd:    .word
