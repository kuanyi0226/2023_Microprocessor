List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	input = b'11111111'
	
	;Normal Binary to Gray Code
	
	;initialize
	MOVLW input
	MOVWF 0x00; [0x00] = input

	RRNCF 0x00, 0; WREG = [0x00] right rotate
	MOVWF 0x13; [0x13] =  [0x00] right rotate
	;BCF WREG, 7; reset WREG[7] => complete right shift
	MOVLW b'01111111'
	ANDWF 0x13, 0; WREG = [0x13] & b'01111111'
	MOVWF 0x10; [0x10] = input shift right
	
	;xor == a'b + ab' => a == input, b == input shift right
	COMF 0x00, 0
	MOVWF 0x01; [0x01] = WREG = a'
	ANDWF 0x10, 0
	MOVWF 0x02; [0x02] = WREG = a'b
	
	COMF 0x10, 0
	MOVWF 0x11; [0x11] = WREG = b'
	ANDWF 0x00, 0
	MOVWF 0x12; [0x02] = WREG = ab'
	
	IORWF 0x02, 0; WREG = WREG(ab') OR [0x02](a'b)
	MOVWF 0x01; store the result
	
	end

