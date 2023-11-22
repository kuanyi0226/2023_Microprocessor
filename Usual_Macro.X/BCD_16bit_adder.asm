List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;16 bit BCD adder
	x_h = 0x12
	x_l = 0x34
	y_h = 0x12
	y_l = 0x88
	
	;initialize
	MOVLW x_h
	MOVWF 0x00
	MOVLW x_l
	MOVWF 0x01
	MOVLW y_h
	MOVWF 0x10
	MOVLW y_l; WREG = y_l
	MOVWF 0x11
	
	;operation
	;low
	MOVFF 0x01, 0x21; [0x21] = [0x01]
	ADDWF 0x21, 1; [0x21] = WREG(0x11) + [0x21]
	
	;carry
	CLRF 0x20; clear 0x20
	BNC no_carry; C = 0, goto no_carry
	has_carry:
	INCF 0x20; [0x20]++
	no_carry:
    
	;high
	MOVFF 0x00, WREG; WREG = [0x00]
	ADDWF 0x20, 1; [0x20] = [0x20](no value) + WREG
	MOVFF 0x10, WREG; WREG = [0x10]
	ADDWF 0x20, 1; [0x20] = [0x20] + WREG(0x10)
	
	;turn to BDC
	MOVFF 0x21, WREG
	DAW
	MOVWF 0x21
	;carry
	BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
	INCF 0x20
	
	MOVFF 0x20, WREG
	DAW
	MOVWF 0x20
	
	
	end

	List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;16 bit BCD adder
	x_h = 0x45
	x_l = 0x14
	y_h = 0x11
	y_l = 0x45
	
	;initialize
	MOVLW x_h
	MOVWF 0x00
	MOVLW x_l
	MOVWF 0x01
	MOVLW y_h
	MOVWF 0x10
	MOVLW y_l; WREG = y_l
	MOVWF 0x11
	
	
	
	;operation
	CLRF 0x02
	;turn to BDC
	MOVFF 0x01, WREG
	DAW
	MOVWF 0x03
	;carry
	BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
	INCF 0x02
	
	MOVFF 0x00, WREG
	ADDWF 0x02, 1
	MOVFF 0x02, WREG
	DAW
	MOVWF 0x02
	
	;
	CLRF 0x12
	MOVFF 0x11, WREG
	DAW
	MOVWF 0x13
	;carry
	BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
	INCF 0x12
	
	MOVFF 0x10, WREG
	ADDWF 0x12, 1
	MOVFF 0x12, WREG
	DAW
	MOVWF 0x12
	
	;sub
	MOVFF 0x13, WREG
	SUBWF 0x03, W
	MOVWF 0x23
	
	;
	CLRF 0x22
	MOVFF 0x11, WREG
	DAW
	MOVWF 0x13
	;carry
	BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
	INCF 0x12
	
	MOVFF 0x10, WREG
	ADDWF 0x12, 1
	MOVFF 0x12, WREG
	DAW
	MOVWF 0x12
	
	
	
	end



