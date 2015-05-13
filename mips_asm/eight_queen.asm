       .data
array:    .word 0,0,0,0,0,0,0,0
s1:     .asciiz "Eight Queen problems, entering the number of queens:"
    
      .text
main:	#a0 n,a1 queens,a3 icount
#print     
    li $v0,4
    la $a0,s1
    syscall
#read integer
    li  $v0,5
    syscall
    add $s0,$v0,$0
#调用Queen
    subu $sp,$sp,32
    sw  $ra,20($sp)
    sw  $fp,16($sp)
    addiu $fp,$sp,28
    li $a0,0
    add $a1,$s0,$0
    li  $a2,0
    jal Queen
    lw  $ra,20($sp)
    lw  $fp,16($sp)
    addiu $sp,$sp,32
#输出
    add $a0,$v0,0
    li  $v0,1
    syscall
#返回
   li $v0,10
   syscall
  
       .text
Queen: #Queen函数
    subu $sp,$sp,32
    sw  $ra,20($sp)
    sw  $fp,16($sp)
    addiu   $fp,$sp,28
    beq $a0,$a1,L1
#循环体，s0对应i，s1对应数组,s2对应下标,s4为对应值
    li $s0,1
    li $s4,4
    lui $s1,0x1000
  Loop1:
    sle $t0,$s0,$a1
    beqz $t0,Revq
    mul $s3,$a0,$s4
    addu $s2,$s1,$s3
    sw $s0,0($s2)
#保存现场
    sw  $a0,24($sp)
    sw  $a1,28($sp)
    sw  $a2,8($sp)
    sw  $s0,12($sp)   
#a0没有变
    jal Valid
    beqz $v0,jump
    lw $ra,20($sp)
    lw $fp,16($sp) 
    addiu $a0,$a0,1
    jal Queen
    add $a2,$v0,$0
  jump:
    lw  $ra,20($sp)
    lw  $fp,16($sp)
    addiu $s0,$s0,1
    j Loop1
#返回
 L1:
   addiu   $v0,$a2,1
   add $a2,$v0,$0
   j Revq
Revq:
    lw  $ra,20($sp)
    lw  $fp,16($sp)
    addiu   $sp,$sp,32
    add $v0,$a2,$0
    lw  $a0,24($sp)
    lw  $a1,28($sp)
    lw  $a2,8($sp)
    lw  $s0,12($sp)
    jr  $ra

  
    .text#Vakid函数
Valid:
    add $t0,$0,$a0
    li $t1,0#循环体，t1对应i，t2对应数组,t4对应下标,t5为对应值
    li $s4,4
    lui $t2,0x1000
Loop2:
    sltu $t6,$t1,$t0
    beqz $t6,Rev1
    mul $t3,$t1,$s4
    addu $t4,$t2,$t3
    lw $t5,0($t4)
#site[i]
    mul $t3,$t0,$s4
    addu $t4,$t2,$t3
    lw $t6,0($t4)
#site[n]
    beq $t5,$t6,Rev0
    sub $t7,$t5,$t6
    abs $t7,$t7
    sub $s6,$t0,$t1
    beq $s6,$t7,Rev0
    addiu $t1,$t1,1
    j Loop2
Rev0:#返回0
    li $v0,0  
    jr $ra
Rev1:#返回1
    li $v0,1
    jr $ra
