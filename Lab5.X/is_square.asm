#include"xc.inc"
GLOBAL _is_square
    
PSECT mytext, local, class=CODE, reloc=1
; notice: int: 16 bit, char: 8 bit
 
_is_square:
    COUNTER_ADDR equ 0x10
    ;test whether the input is 1,4,9,... step by step
    
initial:
    MOVLW 0x01; W = 1
    MOVWF COUNTER_ADDR; counter = 1
    
loop:
    ;judge whether is counter is 16 = 0x10
    MOVLW 0x10
    CPFSEQ COUNTER_ADDR; skip if counter == WREG(16)
    goto judge
    goto square_no
    
judge:
    ;counter square
    MOVFF COUNTER_ADDR, WREG; WREG = counter
    MULWF COUNTER_ADDR; PRODH:PRODL = WREG*counter = counter^2(WREG == counter)
    INCF COUNTER_ADDR; counter++
    ;compare 
    MOVFF PRODL, WREG; WREG = PRODL(square)
    CPFSEQ 0x01; skip if input == WREG(square)
    goto loop
    goto square_yes

square_no:
    ;set [0x01] = 0xff
    MOVLW 0xff
    MOVWF 0x01
    goto finish
     
square_yes:
    ;set [0x01] = 0x01
    MOVLW 0x01
    MOVWF 0x01
    
finish:
    RETURN
