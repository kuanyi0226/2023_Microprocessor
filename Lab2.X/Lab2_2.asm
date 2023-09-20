List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;initialize
	MOVLW 0x05; WREG = 0x05
	MOVLB 0x0; BSR = 0
	MOVWF 0x00, 1; use BSR select bank, [0x000] = 0x05
	
	MOVLW 0x02; WREG = 0x02
	MOVWF 0x18, 1; [0x018] = 0x02
	
	LFSR 0, 0x000; FSR0 point to 0x000
	LFSR 1, 0x018; FSR1 point to 0x018

	;Notice that WREG only has 8 bits, cant read whole address
	MOVLW 0x01; WREG = 0x01
	MOVWF 0x30; [0x30] = 0x01 //counter
	
    start_label:
	MOVLW 0x09; WREG = 0x09(ending  is 0x009)
	CPFSEQ 0x30; skip if counter == 0x09 
	GOTO operate; if: counter != 0x009
	GOTO end_label; else: counnter == 0x009(end of program)
    operate:
	MOVF POSTDEC1, WREG; WREG = [FSR1], then FSR1--
	MOVWF 0x31; store previous [FSR1] in 0x31
	;do substracting
	SUBWF INDF0, 0; WREG = FSR0 - WREG(previous [FSR1])
	MOVWF INDF1; stroe the substracting result
	;do summing
	MOVF POSTINC0, WREG; WREG = [FSR0], then FSR0++
	ADDWF 0x31, 0; WREG = FSR1 + WREG(previous [FSR0])
	MOVWF INDF0; stroe the substracting result
	
    end_operate:
	INCF 0x30; counter++
	GOTO start_label; go to next point
	
    end_label:
	end





