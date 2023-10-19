#include"xc.inc"
GLOBAL _lcm
    
PSECT mytext, local, class=CODE, reloc=1
; notice: int: 16 bit, char: 8 bit
; input: two 8-bit unsigned int 
 
a_h	equ 0x10; input1's higher 8 bits address
a_l	equ 0x11
b_h	equ 0x12
b_l	equ 0x13
a_times equ 0x21; current times of a
b_times equ 0x23
little_flag equ 0x30; [little_flag] = 0: a is greater; [little_flag] = 1:b is greater
 
compare_16bit macro 
    ;judge higher 8 bits is same or not
    MOVFF a_h, WREG;
    CPFSEQ b_h; skip if a_h == b_h
    goto compare_high
    compare_low:
    MOVFF b_l, WREG
    CLRF little_flag; little flag = 0
    CPFSGT a_l; skip if a_l > b_l(greater flag set 0)
    INCF little_flag; little flag set 1
    goto end_compare
    compare_high:
    MOVFF b_h, WREG
    CLRF little_flag; little flag = 0
    CPFSGT a_h; skip if a_h > b_h(greater flag set 0)
    INCF little_flag; little flag set 1  
    end_compare:
    endm
    
_lcm:
    MOVLF macro addr, literal
	MOVLW literal
	MOVWF addr
	endm
    
initial:
    MOVFF 0x01, a_l
    MOVFF 0x03, b_l
    MOVLF a_times, 0x01
    MOVLF b_times, 0x01
loop:   
same: ; judge whether a is same as b
    ;low
    MOVFF a_l, WREG
    CPFSEQ b_l; skip if a_low == b_low(go to check higher bits)
    goto times_a_or_b
    ;high
    MOVFF a_h, WREG
    CPFSEQ b_h; skip if a_high == b_high(found ans!!)
    goto times_a_or_b
    goto finish
    
times_a_or_b:
    ;find a or b who is little
    compare_16bit; do macro
    
    ;increase the times of little one
    BTFSS little_flag, 0; skip if flag == 1(a is litter)
    goto change_b
change_a:
    INCF a_times; ++
    MOVFF 0x01, WREG; WREG = original_a
    MULWF a_times; PROD = original_a * a_times
    ;update a's value
    MOVFF PRODH, a_h
    MOVFF PRODL, a_l
    goto loop; judge again
change_b:
    INCF b_times; ++
    MOVFF 0x03, WREG; WREG = original_b
    MULWF b_times; PROD = original_b * b_times
    ;update a's value
    MOVFF PRODH, b_h
    MOVFF PRODL, b_l
    goto loop; judge again
    
    
finish: 
    ;write back result to .c
    MOVFF 0x11, 0x01; low bits
    MOVFF 0x10, 0x02; high bits
    RETURN


