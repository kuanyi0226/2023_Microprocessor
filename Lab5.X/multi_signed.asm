#include"xc.inc"
GLOBAL _multi_signed
    
PSECT mytext, local, class=CODE, reloc=2
; notice: int: 16 bit, char: 8 bit
 
Multiplicand_exceed_addr equ 0x10 ;(bit 8 ~ 15 of Multiplicand)
Multiplicand_addr        equ 0x11
Multiplier_addr          equ 0x12
Counter_addr             equ 0x20
Sign_bit_addr            equ 0x30
Output_0_7_addr          equ 0x01
Output_8_15_addr         equ 0x02
      
MOVLF macro addr, literal
 MOVLW literal
 MOVWF addr
 endm
 
Adder_16bit macro  output_h, output_l, Multiplicand_exceed, Multiplicand ;addr  
	    ;Notice that it will not skip the whole macro
	    goto macro_not_skip
	    goto skip_macro

	macro_not_skip:
	    ;low
	    MOVFF Multiplicand, WREG; WREG = Multiplicand
	    ADDWF output_l, 1; output_l += Multiplicand
	    ;carry
	    BNC no_carry; C = 0, goto no_carry
	    has_carry:
	    INCF output_h; dest_h++
	    no_carry:
	    ;high
	    MOVFF Multiplicand_exceed, WREG; WREG = Multiplicand_exceed
	    ADDWF output_h, 1; output_h += Multiplicand_exceed
	skip_macro:
	    endm
      
_multi_signed:
    
initial: ; multiplicand(8 bit) stores in WREG, multiplier(4 bit)stores in 0x01
    MOVWF Multiplicand_addr; [0x10] = multiplicand
    MOVFF 0x01, Multiplier_addr; [0x11] = multiplier
    MOVLF Counter_addr, 0x04; counter = 4
    
    ;final sign bit calculate
    CLRF Sign_bit_addr; clear
    ;xor 
    MOVFF Multiplicand_addr, WREG; WREG = Multiplicand
    XORWF Multiplier_addr, 0; WREG = Multiplicand xor Multiplier
    BTFSC WREG, 7; skip if msb of WREG is 0(sign bit = 0)
    INCF Sign_bit_addr; sign bit = 1
    
    ;turn multiplicand & multiplier to positive
    BTFSC Multiplicand_addr, 7 ;skip if msb of Multiplicand is 0(positive)
    NEGF Multiplicand_addr; negative -> positive
    BTFSC Multiplier_addr, 3 ;skip if bit3 of Multiplier is 0(positive)
    NEGF Multiplier_addr; negative -> positive
    
    ;unsigned multiplication(8 bit * 4 bit)
    CLRF Output_0_7_addr; clear
    CLRF Output_8_15_addr  
loop: ; do four rounds of add
    ;add multiplicand to output or not
    ;Notice: it will not skip the whole macro
    BTFSC Multiplier_addr, 0; skip if lsb is clear(zero)
    Adder_16bit Output_8_15_addr,Output_0_7_addr,Multiplicand_exceed_addr,Multiplicand_addr; macro: add multiplicand to result
    
    ;shift Multiplicand(notice that is has 8 bit) & Multiplier
    RLNCF Multiplicand_exceed_addr; Multiplicand_exceed shift left
    BCF Multiplicand_exceed_addr, 0; clear LSB of Multiplicand_exceed
    
    RLCF Multiplicand_addr; Multiplicand shift left, if has carry, extend it to Multiplicand_exceed(bit8~15 of Multiplicand)
    BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
    INCF Multiplicand_exceed_addr; set lsb == 1 (has carry)
    BCF Multiplicand_addr, 0; clear LSB of Multiplicand
    
    RRNCF Multiplier_addr; Multiplier shift right
    BCF Multiplier_addr, 7; clear MSB of Multiplier
    
    ;next turn or not
    DECF Counter_addr; counter--
    BNZ loop; zero flag is not zero, go for another round
    
    
    ;put on the final sign bit
    MOVLW 0x01; WREG = 1
    CPFSEQ Sign_bit_addr; skip if final sign bit is 1(should be negavtive)
    goto finish; is 0
two_complement:
    ;do two's complement for output(16 bit)
    ;high 8 bits: 1's complement
    COMF Output_8_15_addr
    ;high 8 bits: 2's complement
    NEGF Output_0_7_addr
    ;judge carry
    BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
    INCF Output_0_7_addr; ++
    
finish:
    RETURN



