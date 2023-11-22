List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	input_n = 0x09
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
	    
    finish:
	l1:
	CLRF 0x10
	CLRF 0x13
	MOVLW 0x01
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x01
	MOVLW 0x01
	CPFSEQ 0x11 ;skip if == 1
	goto l2
	goto d_finish
	
    l2:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x02;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x02;
	MOVLW 0x02;
	CPFSEQ 0x11 ;skip if == 2
	goto l3 ;
	goto d_finish
    l3:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x03;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x03;
	MOVLW 0x03;
	CPFSEQ 0x11 ;skip if == 2
	goto l4 ;
	goto d_finish
    l4:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x04;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x04;
	MOVLW 0x04;
	CPFSEQ 0x11 ;skip if == 2
	goto l5 ;
	goto d_finish
    l5:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x05;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x05;
	MOVLW 0x05;
	CPFSEQ 0x11 ;skip if == 2
	goto l6 ;
	goto d_finish
    l6:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x06;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x06;
	MOVLW 0x06;
	CPFSEQ 0x11 ;skip if == 2
	goto l7 ;
	goto d_finish
    l7:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x07;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x07;
	MOVLW 0x07;
	CPFSEQ 0x11 ;skip if == 2
	goto l8 ;
	goto d_finish
    l8:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x08;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x08;
	MOVLW 0x08;
	CPFSEQ 0x11 ;skip if == 2
	goto l9 ;
	goto d_finish
    l9:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x09;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x09;
	MOVLW 0x09;
	CPFSEQ 0x11 ;skip if == 2
	goto l10 ;
	goto d_finish
    l10:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x0a;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x0a;
	MOVLW 0x0a;
	CPFSEQ 0x11 ;skip if == 2
	goto l11 ;
	goto d_finish
    l11:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x0b;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x0b;
	MOVLW 0x0b;
	CPFSEQ 0x11 ;skip if == 2
	goto l12 ;
	goto d_finish
    l12:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x0c;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x0c;
	MOVLW 0x0c;
	CPFSEQ 0x11 ;skip if == 2
	goto l13 ;
	goto d_finish
    l13:
    CLRF 0x10
	CLRF 0x13
	MOVLW 0x0d;
	MOVWF i_addr
	rcall Fib
	MOVFF 0x10, 0x0d;
	MOVLW 0x0d;
    d_finish:
	NOP
	
	end


