List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	;data
	input1_high = 0x76 ;74 76
	input1_low = 0x12  ;08 12
	input2_high = 0x44 ;40 44
	input2_low = 0x93  ;46 93
	
	;initialize
	MOVLW input1_high
	MOVWF 0x00
	MOVLW input1_low
	MOVWF 0x01
	MOVLW input2_high
	MOVWF 0x10
	MOVLW input2_low; WREG = input2_low
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
	
	
	
	end









