List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	x_high = 0x04
	x_low =  0x02
	y_high = 0x0a
	y_low = 0x04
	
	;Macro
	Add_Mul macro  xh, xl, yh, yl
	    ;1. Sum
	    MOVLW xh
	    MOVWF 0x20
	    MOVLW xl
	    MOVWF 0x21
	    MOVLW yh
	    MOVWF 0x30
	    MOVLW yl; WREG = yl
	    MOVWF 0x31
	    ;operation
	    ;low
	    MOVFF 0x21, 0x01; [0x01] = [0x11]
	    ADDWF 0x01, 1; [0x01] = WREG(0x21) + [0x01]
	    ;carry
	    CLRF 0x00; clear 0x00
	    BNC no_carry; C = 0, goto no_carry
	    has_carry:
	    INCF 0x00; [0x00]++
	    no_carry:
	    ;high
	    MOVFF 0x20, WREG; WREG = [0x10]
	    ADDWF 0x00, 1; [0x00] = [0x00](no value) + WREG
	    MOVFF 0x30, WREG; WREG = [0x20]
	    ADDWF 0x00, 1; [0x00] = [0x00] + WREG(0x20)
	    
	    
	    ;multiply: signed 8-bit multiplication
	    step1: ; multiply two operands disregarding their signs
	    MOVF 0x00, W; WREG = [0x00] = op1
	    MULWF 0x01, W; WREG = WREG*[0x01]    (op1*op2)
	    
	    step2: ; if op1 is negative, then subtract op2 from the upper byte of the product(PRODH)
	    MOVF 0x01, W; WREG = op2
	    BTFSC 0x00, 7; skip if op1 is not negative
		SUBWF PRODH; PRODH = PRODH - op2
		
	    step3: ; if op2 is negative, then subtract op1 from the upper byte of the product
	    MOVF 0x00, W; WREG = op1
	    BTFSC 0x01, 7; skip if op2 is not negative
		SUBWF PRODH; PRODH = PRODH - op1
	    final:
	    MOVFF PRODH, 0x10
	    MOVFF PRODL, 0x11
 
	    endm
	
	;Use Macro
	Add_Mul x_high, x_low, y_high, y_low
	
	
	end


