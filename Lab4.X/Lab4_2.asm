List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	a1 = 0x01
	a2 = 0x00
	a3 = 0x00
	a4 = 0x01
	b1 = 0x03
	b2 = 0x03
	b3 = 0x01
	b4 = 0x04
	
    initial:
	MOVLW a1
	MOVWF 0x10
	MOVLW a2
	MOVWF 0x11
	MOVLW a3
	MOVWF 0x20
	MOVLW a4
	MOVWF 0x21
	MOVLW b1
	MOVWF 0x12
	MOVLW b2
	MOVWF 0x13
	MOVLW b3
	MOVWF 0x22
	MOVLW b4
	MOVWF 0x23
	;clear matrix C
	CLRF 0x00 ; c1
	CLRF 0x01 ; c1
	CLRF 0x02 ; c3
	CLRF 0x03 ; c4
	rcall multiply; do subroutine
	goto finish
	
    Multiply_single_element macro c_1, a_1, a_2, b_1, b_2; each two elements from A & B
	MOVFF a_1, WREG ; WREG = [a_1]
	MULWF b_1 ; PRODH,PRODL = a_1*b_1
	MOVFF PRODL, WREG ; WREG = PRODL
	ADDWF c_1, 1 ; [c_1] = [c_1] + PRODL
	
	MOVFF a_2, WREG ; WREG = [a_2]
	MULWF b_2 ; PRODH,PRODL = a_2*b_2
	MOVFF PRODL, WREG ; WREG = PRODL
	ADDWF c_1, 1 ; [c_1] = [c_1] + PRODL
	endm
    
    multiply: 
	Multiply_single_element 0x00,0x10,0x11,0x12,0x22 ;c1
	Multiply_single_element 0x01,0x10,0x11,0x13,0x23 ;c2
	Multiply_single_element 0x02,0x20,0x21,0x12,0x22 ;c3
	Multiply_single_element 0x03,0x20,0x21,0x13,0x23 ;c4
	RETURN
	  
    finish:
	end


