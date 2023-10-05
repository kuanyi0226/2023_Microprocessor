List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	input1 = 0x08; multiplicand ;08 03
	input2 = 0x0B; multiplier   ;0B 0F
	
	;simple multiplier
	
	;initialize
	MOVLW input1
	MOVWF TRISA; TRISA = input1
	MOVLW input2
	MOVWF TRISB; TRISB = input2
	CLRF TRISC; clear TRISC
	
	;operation
	;1st round
	MOVFF TRISA, WREG; WREG = TRISA
	BTFSC TRISB, 0; skip if lsb is clear(zero)
	ADDWF TRISC; TRISC = TRISC + WREG
	
	RLNCF TRISA; TRISA shift left
	BCF TRISA, 0; clear LSB of TRISA
	RRNCF TRISB; TRISB shift right
	BCF TRISB, 7; clear MSB of TRISA
	
	;2nd round
	MOVFF TRISA, WREG; WREG = TRISA
	BTFSC TRISB, 0; skip if lsb is clear(zero)
	ADDWF TRISC; TRISC = TRISC + WREG
	
	RLNCF TRISA; TRISA shift left
	BCF TRISA, 0; clear LSB of TRISA
	RRNCF TRISB; TRISB shift right
	BCF TRISB, 7; clear LSB of TRISA
	
	;3rd round
	MOVFF TRISA, WREG; WREG = TRISA
	BTFSC TRISB, 0; skip if lsb is clear(zero)
	ADDWF TRISC; TRISC = TRISC + WREG
	
	RLNCF TRISA; TRISA shift left
	BCF TRISA, 0; clear LSB of TRISA
	RRNCF TRISB; TRISB shift right
	BCF TRISB, 7; clear LSB of TRISA
	
	;4th round
	MOVFF TRISA, WREG; WREG = TRISA
	BTFSC TRISB, 0; skip if lsb is clear(zero)
	ADDWF TRISC; TRISC = TRISC + WREG
	
	RLNCF TRISA; TRISA shift left
	BCF TRISA, 0; clear LSB of TRISA
	RRNCF TRISB; TRISB shift right
	BCF TRISB, 7; clear LSB of TRISA
	
	;recover TRISA, TRISB
	MOVLW input1
	MOVWF TRISA; TRISA = input1
	MOVLW input2
	MOVWF TRISB; TRISB = input2
	
	end









