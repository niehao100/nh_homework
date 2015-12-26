lui $s5,16384
addi $t1,$zero, 0
sw $t1,8($s5)#禁用中断
addi $a1,$zero, 256
addi $t1,$zero, 4
sw $t1,32($s5)
Loop1:lw $v0,28($s5)
beq $v0,$zero, Loop1
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t1,$zero, 0
sw $t1,32($s5)
add $s1,$zero, $v0#读取第一个数
sw $v0,12($s5)
addi $t3,$zero, 1
addi $t2,$zero, 400
L2:sub $t2,$t2, $t3
bne $t2,$zero, L2
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t1,$zero, 4
sw $t1,32($s5)
Loop2:lw $v1,28($s5)
beq $v1,$zero, Loop2
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t1,$zero, 0
sw $t1,32($s5)
add $s2,$zero, $v1#读取第二个数
sw $v1,12($s5)
addi $t2,$zero, 10000
L4:sub $t2,$t2, $t3
bne $t2,$zero, L4
sll $zero,$zero, 0
sll $zero,$zero, 0
sll $v0,$v0, 8
add $v1,$v0, $v1
beq $s1,$s2, output
sll $zero,$zero, 0
sll $zero,$zero, 0
judge:sub $t1,$s2, $s1
blez $t1,loop3
sll $zero,$zero, 0
sll $zero,$zero, 0
bigger:addi $t1,$s2, 0
addi $s2,$s1, 0
addi $s1,$t1, 0
loop3:sub $s3,$s1, $s2
addi $s1,$s3, 0
bne $s1,$s2, judge
sll $zero,$zero, 0
sll $zero,$zero, 0
output:addi $t1,$zero, 1
sw $s1,24($s5)
sw $s1,12($s5)
sub  $t2,$zero, $t1#0xffffffff
sw $t2,4($s5)
addi $t4,$zero, 100 
sub $t3,$t2, $t4 
sw $t3,0($s5)
addi $t2,$zero, 3
addi $v0,$zero, 1
sw $t2,8($s5)
add $a0,$zero, $t4
LOOP4:addi $s2,$zero, 0 
j LOOP4
sll $zero,$zero, 0
sll $zero,$zero, 0
INT2
DECODE:addi $t3,$zero, 128
addi $t5,$v1, 0
SHIFTL:beq $t3,$v0, SHIFTR
sll $zero,$zero, 0
sll $zero,$zero, 0
sll $t5,$t5, 4
srl $t3,$t3, 1
j SHIFTL
sll $zero,$zero, 0
sll $zero,$zero, 0
SHIFTR:srl $t5,$t5, 28
sll $t3,$t3, 8
addi $t6,$zero, 0
beq $t6,$t5, ZERO
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, ONE
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, TWO
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, THREE
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, FOUR
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, FIVE
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, SIX
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, SEVEN
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, EIGHT
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, NIGHT
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, A
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, B
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, C
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, D
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, E
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $t6,$t6, 1
beq $t6,$t5, F
sll $zero,$zero, 0
sll $zero,$zero, 0
ZERO:addi $t5,$zero, 64
j DE
ONE:addi $t5,$zero, 121
j DE
TWO:addi $t5,$zero, 36
j DE
THREE:addi $t5,$zero, 48
j DE
FOUR:addi $t5,$zero, 25
j DE
FIVE:addi $t5,$zero, 18
j DE
SIX:addi $t5,$zero, 2
j DE
SEVEN:addi $t5,$zero, 120
j DE
EIGHT:addi $t5,$zero, 0
j DE
NIGHT:addi $t5,$zero, 16
j DE
A:addi $t5,$zero, 8
j DE
B:addi $t5,$zero, 3
j DE
C:addi $t5,$zero, 70
j DE
D:addi $t5,$zero, 33
j DE
E:addi $t5,$zero, 6
j DE
F:addi $t5,$zero, 14
j DE
DE:add $t5,$t3, $t5
sw $t5,20($s5)
sll $zero,$zero, 0
sll $zero,$zero, 0
sll $v0,$v0, 1
addi $t3,$zero, 16
addi $t1,$zero, 3
sw $t1,8($s5)
sll $zero,$zero, 0
sll $zero,$zero, 0
bne $v0,$t3, JUMP
sll $zero,$zero, 0
sll $zero,$zero, 0
addi $v0,$zero, 1
sll $zero,$zero, 0
sll $zero,$zero, 0
JUMP:jr $a1
sll $zero,$zero, 0
sll $zero,$zero, 0
sll $zero,$zero, 0
END2
INT1
addi $t1,$zero, 1
sw $t1,8($s5)
jal DECODE
sll $zero,$zero, 0
sll $zero,$zero, 0
sll $zero,$zero, 0
END1
