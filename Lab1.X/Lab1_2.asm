List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	num1 = b'00001010'
	num2 = 0x10
	
	initialize:
	MOVLW num1
	MOVWF 0x00
	MOVLW num2
	MOVWF 0x02
	
	start:
	phase1:
	BTFSS 0x00, 0; test multiple of 2: skip if lsb of [0x00] is 1
	GOTO else_label
	if_label: ;//not 2's multiple
	DECF 0x02; [0x02]--
	GOTO phase2
	else_label:;//is 2's multiple
	INCF 0x02; [0x02]++
    
    
	phase2:
        ;//rightward rotate
	RRNCF 0x00; 
	;//Compare
	MOVLW num1
	CPFSEQ 0x00
	GOTO start
	
	
	end


