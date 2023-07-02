#struct Student {
 #   char name[50];
 #   unsigned int registration;  16 bits 
 #   char course[30];          
 #   unsigned int birthday;     
 #   char hometown[25];    
    #struct Student *left, *right;
#};



.text

#struct Student {
lb $t1,0($t0)  #char name[50]
lh $t3,50($t0) # unsigned int registration; 
lb $t4,66($t0)  #char course[30]; 
lh $t5,96($t0) #unsigned int birthday;
lb $t6,112($t0) #char hometown[25];  

#falta escrever left e right

.data 

 registration: word 0 
 birthday: word 0 
 