List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	input_1_h = 0x33
	input_1_l = 0x20
	input_2_h = 0x31
	input_2_l = 0x21
	
	
	MOVLW input_1_h
	MOVWF 0x00
	MOVLW input_1_l
	MOVWF 0x01
	MOVLW input_2_h
	MOVWF 0x10
	MOVLW input_2_l
	MOVWF 0x11
	
	CLRF 0x30
	CLRF 0x31
	
	MOVFF 0x11, WREG
	SUBWF 0x01, W
	MOVWF 0x21
	
	MOVFF 0x10, WREG
	SUBWFB 0x00, W
	MOVWF 0x20
	
	
	
	
	
	
	
end