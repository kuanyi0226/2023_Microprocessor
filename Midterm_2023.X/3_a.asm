List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;16 bit BCD adder
	x_h = 0x00
	x_l = 0x00
	y_h = 0x11
	y_l = 0x45
	z_h = 0x45
	z_l = 0x14
	
	;initialize
	MOVLW x_h
	MOVWF 0x00
	MOVLW x_l
	MOVWF 0x01
	MOVLW y_h
	MOVWF 0x10
	MOVLW y_l; WREG = y_l
	MOVWF 0x11
	MOVLW z_h
	MOVWF 0x40
	MOVLW z_l; WREG = y_l
	MOVWF 0x41
	
	subb:
	INCF 0x01
	BC add1
	DECF 0x00
	add1:
    INCF 0x00
	;low
	MOVFF 0x11, WREG
	SUBWF 0x01, W
	MOVWF 0x21
	
	MOVFF 0x10, WREG
	SUBWFB 0x00, W
	MOVWF 0x20
	
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
	
	MOVFF 0x20, WREG
	CPFSEQ 0x40
	goto subb
	MOVFF 0x21, WREG
	CPFSEQ 0x41
	goto subb
	finish:
    NOP
	
	
	end