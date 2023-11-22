List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	input_n = 0x0c
	i_addr = 0x12
	flag = 0x13
	
	;init
	CLRF 0x10
	CLRF 0x13
	MOVLW input_n
	MOVWF 0x11
	MOVWF i_addr
	
	
	rcall Fib
	goto gray_code
	
    Fib:
	MOVLW 0x02
	CPFSGT i_addr; skip if i > 2 
	goto return_1
	goto recurr
	NOP
	recurr:
	BCF flag, 0
	DECF i_addr
	rcall Fib
	BSF flag, 0
	DECF i_addr
	rcall Fib
	;DECF 0x00
	INCF i_addr
	INCF i_addr
	return
	return_1:
	;BTFSC flag, 0 ; skip if flag == 0
	
	INCF 0x10
	return
	    
    gray_code:
	;Normal Binary to Gray Code
	
	;initialize
	MOVFF 0x10 ,0x20

	RRNCF 0x20, 0; WREG = [0x00] right rotate
	MOVWF 0x33; [0x13] =  [0x00] right rotate
	;BCF WREG, 7; reset WREG[7] => complete right shift
	MOVLW b'01111111'
	ANDWF 0x33, 0; WREG = [0x13] & b'01111111'
	MOVWF 0x30; [0x10] = input shift right
	
	;xor == a'b + ab' => a == input, b == input shift right
	COMF 0x20, 0
	MOVWF 0x21; [0x01] = WREG = a'
	ANDWF 0x30, 0
	MOVWF 0x22; [0x02] = WREG = a'b
	
	COMF 0x30, 0
	MOVWF 0x31; [0x11] = WREG = b'
	ANDWF 0x20, 0
	MOVWF 0x32; [0x02] = WREG = ab'
	
	IORWF 0x22, 0; WREG = WREG(ab') OR [0x02](a'b)
	MOVWF 0x00; store the result
	NOP
	
	
	end
