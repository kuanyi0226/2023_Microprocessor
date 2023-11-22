List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	input_n = 0x05
	i_addr = 0x12
	flag = 0x13
	
	;init
	CLRF 0x10
	CLRF 0x13
	MOVLW input_n
	MOVWF 0x11
	MOVWF i_addr
	
	
	rcall Fib
	goto finish
	
    Fib:
	MOVLW 0x03
	CPFSGT i_addr; skip if i > 3
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
	
	BSF flag, 0
	DECF i_addr
	rcall Fib
	;DECF 0x00
	INCF i_addr
	INCF i_addr
	INCF i_addr
	return
	return_1:
	MOVLW 0x01
	CPFSEQ i_addr ; skip if == 1
	goto do_2
	INCF 0x10
	return
	do_2:
	MOVLW 0x02
	CPFSEQ i_addr ; skip if == 2
	goto do_3
	INCF 0x10
	INCF 0x10
	return
	do_3:
	INCF 0x10
	INCF 0x10
	INCF 0x10
	INCF 0x10
	return
	    
    finish:
	MOVFF 0x10, 0x00
	NOP
	
	end





