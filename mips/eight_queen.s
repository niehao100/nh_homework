    .text
main:
    lui $s6,0x1000
    addiu $s5,$s6,4
    lw $s0,0($s6)
    slt $s2,$0,$s0
    beqz $s2,else
    move $s1,$s0
    j done
else:
    sub $s1,$0,$s0
done:
    sw $s1,0($s5)
    jr $ra
    .data 0x10000000
    .word 6,0

