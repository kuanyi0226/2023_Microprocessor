List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	input = b'11110000'
	;11010111
	;11110000
	
	;1. initialize
	MOVLW input; WREG = input data
	MOVWF TRISA; TRISA = WREG(input data)
	
	;2. arithmetic right shift
	RRNCF TRISA, 1; right rotate TRISA(store back to f
	
	BTFSS WREG, 7; skip if MSB of input(original) is set
	BCF TRISA, 7; clear TRISA MSB
	BSF TRISA, 7; set TRISA MSB
	
	;3. logical right shift
	RRNCF TRISA, 1; right rotate TRISA
	BCF TRISA, 7; clear TRISA MSB
	
	end






