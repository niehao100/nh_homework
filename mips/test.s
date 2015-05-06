	.text
main:
	li $a2,0
	li $a3,0	#Initialize status: no queen.
	li $s6,0	#Solution counter
	li $s7,0	#Number of queens which have been put

check_legal:
	jal is_legal
	beqz $v0,check_movable
	bne $s7,8,add_queen
	addi $s6,$s6,1
check_movable:
	jal is_movable
	beqz $v0,not_movable
	jal move_queen
	j check_legal
not_movable:
	jal remove_queen
	beqz $s7,finish
	j check_movable

finish:
	move $a0,$s6
	li $v0,1
	syscall

	li $v0,10
	syscall

is_legal:	#Return v0=1 if legal
	move $s5,$ra

	li $a1,0
loop_cols:	#Check each row
	li $s0,0	#Stores number of queens in a row
	li $a0,0
loop_col:
	jal getqueen
	add $s0,$s0,$v0
	slti $t0,$s0,2	#Check if s0<2
	beqz $t0,return_illegal	#Return 0 if not
	addi $a0,$a0,1
	slti $t0,$a0,8	#Check if a1<8
	bnez $t0,loop_col	#Go on looping if so
#End of loop_col:
	addi $a1,$a1,1
	slti $t0,$a1,8	#Check if a0<8
	bnez $t0,loop_cols	#Go on looping if so
#End of loop_cols:

diag1:
	li $s1,0
loop_diag1_1_out:
	li $s0,0
	li $a0,0
	add $a1,$a0,$s1
loop_diag1_1:
	jal getqueen
	add $s0,$s0,$v0
	slti $t1,$s0,2
	beqz $t1,return_illegal
	addi $a0,$a0,1
	addi $a1,$a1,1
	slti $t1,$a1,8
	bnez $t1,loop_diag1_1
	addi $s1,$s1,1
	slti $t1,$s1,7
	bnez $t1,loop_diag1_1_out

	li $s1,1
loop_diag1_2_out:
	li $s0,0
	li $a1,0
	add $a0,$a1,$s1
loop_diag1_2:
	jal getqueen
	add $s0,$s0,$v0
	slti $t1,$s0,2
	beqz $t1,return_illegal
	addi $a1,$a1,1
	addi $a0,$a0,1
	slti $t1,$a0,8
	bnez $t1,loop_diag1_2
	addi $s1,$s1,1
	slti $t1,$s1,7
	bnez $t1,loop_diag1_2_out
diag2:
	li $s1,1
loop_diag2_1_out:
	li $s0,0
	li $a0,0
	sub $a1,$s1,$a0
loop_diag2_1:
	jal getqueen
	add $s0,$s0,$v0
	slti $t1,$s0,2
	beqz $t1,return_illegal
	addi $a0,$a0,1
	addi $a1,$a1,-1
	slti $t1,$a1,0
	beqz $t1,loop_diag2_1
	addi $s1,$s1,1
	slti $t1,$s1,8
	bnez $t1,loop_diag2_1_out

loop_diag2_2_out:
	li $s0,0
	li $a1,7
	sub $a0,$s1,$a1
loop_diag2_2:
	jal getqueen
	add $s0,$s0,$v0
	slti $t1,$s0,2
	beqz $t1,return_illegal
	addi $a1,$a1,-1
	addi $a0,$a0,1
	slti $t1,$a0,8
	bnez $t1,loop_diag2_2
	addi $s1,$s1,1
	slti $t1,$s1,14
	bnez $t1,loop_diag2_2_out

	move $ra,$s5
	li $v0,1
	jr $ra
return_illegal:
	move $ra,$s5
	li $v0,0
	jr $ra
#End of is_legal
	

getqueen:	#Return $v0=1 if there is a queen at row $a0 col $a1, $v0=0 if not
	slti $t0,$a0,4
	beqz $t0,down	#Last 4 rows
up:
	li $t1,31	#To get shift value: 31-8*a0-a1
	sll $t2,$a0,3	#t2=8*a0
	sub $t1,$t1,$t2	#t1=t1-t2
	sub $t1,$t1,$a1	#t1=t1-a1
	srlv $v0,$a2,$t1	#Get target bit
	andi $v0,1	#Mask it with 0x00000001
	jr $ra
down:
	li $t1,63	#To get shift value: 63-8*a0-a1
	sll $t2,$a0,3	#t2=8*a0
	sub $t1,$t1,$t2	#t1=t1-t2
	sub $t1,$t1,$a1	#t1=t1-a1
	srlv $v0,$a3,$t1	#Get target bit
	andi $v0,1	#Mask it with 0x00000001
	jr $ra
#End of getqueen

add_queen:	#Add another queen. All shifts here are from right to left.
	slti $t0,$s7,4
	beqz $t0,add_queen_down
	sll $t0,$s7,3	#Get 8*s7
	li $t1,31
	sub $t0,$t1,$t0	#Shift value=31-8*s7
	li $t1,1
	sllv $t0,$t1,$t0
	or $a2,$a2,$t0
	addi $s7,$s7,1
	j check_legal
add_queen_down:
	sll $t0,$s7,3	#Get 8*s7
	li $t1,63
	sub $t0,$t1,$t0	#Shift value=63-8*s7
	li $t1,1
	sllv $t0,$t1,$t0
	or $a3,$a3,$t0
	addi $s7,$s7,1
	j check_legal
#End of add_queen

move_queen:	#Put the last queen to next place
	li $t0,0	#Initial shift value
	bnez $a3,search_down	#Find the last queen first
search_up:
	srlv $t1,$a2,$t0	#Get shifted 
	andi $t1,1	#Mask
	beqz $t1,continue_up	#No queen then continue
	beqz $t0,move_special	#Special move skill if t0=0 :)
	li $t1,1	#Prepare mask
	sllv $t1,$t1,$t0
	xor $a2,$a2,$t1	#Remove the current queen
	srl $t1,$t1,1
	or $a2,$a2,$t1	#Mask the next queen
	jr $ra
continue_up:
	addi $t0,$t0,1
	slti $t1,$t0,32
	bnez $t1,search_up
search_down:
	srlv $t1,$a3,$t0
	andi $t1,1
	beqz $t1,continue_down
	li $t1,1	#Prepare mask
	sllv $t1,$t1,$t0
	xor $a3,$a3,$t1	#Remove the current queen
	srl $t1,$t1,1
	or $a3,$a3,$t1	#Mask the next queen
	jr $ra
continue_down:
	addi $t0,$t0,1
	slti $t1,$t0,32
	bnez $t1,search_down
move_special:
	xori $a2,$a2,1	#Remove the current queen
	li $a3,1
	sll $a3,$a3,31	#Mask the next queen
	jr $ra
#End of move_queen
	
is_movable:
	bnez $a3,movable_down
	
	li $t1,4
	sub $t1,$t1,$s7
	sll $t1,$t1,3
	srlv $t0,$a2,$t1
	andi $v0,$t0,1
	xori $v0,1
	jr $ra
movable_down:
	li $t1,8
	sub $t1,$t1,$s7
	sll $t1,$t1,3
	srlv $t0,$a3,$t1
	andi $v0,$t0,1
	xori $v0,1
	jr $ra
#End of is_movable

remove_queen:	#Remove the last queen
	li $t0,255
	bnez $a3,remove_down
	
	li $t1,4
	sub $t1,$t1,$s7
	sll $t1,$t1,3
	sllv $t0,$t0,$t1
	not $t0,$t0
	and $a2,$a2,$t0
	addi $s7,$s7,-1
	jr $ra
remove_down:
	li $t1,8
	sub $t1,$t1,$s7
	sll $t1,$t1,3
	sllv $t0,$t0,$t1
	not $t0,$t0
	and $a3,$a3,$t0
	addi $s7,$s7,-1
	jr $ra
#End of remove_queen

