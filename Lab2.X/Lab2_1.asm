List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;initialize
	MOVLW 0x03; WREG = 0x03
	MOVLB 0x1; BSR = 1
	MOVWF 0x00, 1; use BSR select bank, [0x100] = 0x03
	
	MOVLW 0x08; WREG = 0x08
	MOVWF 0x01, 1; [0x101] = 0x08
	
	LFSR 0, 0x100; FSR0 point to 0x100
	LFSR 1, 0x101; FSR1 point to 0x101
	LFSR 2, 0x102; FSR2 point to 0x102
	;Notice that WREG only has 8 bits, cant read whole address
	MOVLW 0x02; WREG = 0x02
	MOVWF 0x00; [0x00] = 0x02 //counter: record the address of FSR2
	
    start_label:
	MOVLW 0x09; WREG = 0x09(ending  is 0x109)
	CPFSEQ 0x00; skip if FSR2 == 0x109 by checking counter
	GOTO operate; if: FSR2 != 0x109
	GOTO end_label; else: FSR2 == 0x109(end of program)
    operate:
	;FSR1 - FSR0 = FSR2
	;()-(WREG) = ()
	MOVF POSTINC0, WREG; WREG = [FSR0], then FSR0++
	BTFSS 0x00, 0; test odd: skip if lsb of INDF2 is odd(lsb == 1) by checking counter
	GOTO else_label
	if_label: ; odd: do substracting
	SUBWF POSTINC1, 0; WREG = [FSR1] - WREG, then FSR1++
	GOTO end_operate
	else_label: ;even: do summing
	ADDWF POSTINC1, 0; WREG = [FSR1] + WREG, then FSR1++
	
    end_operate:
	MOVWF POSTINC2; FSR2 = WREG (store the result), then FSR2++
	INCF 0x00; counter++
	GOTO start_label; go to next point
	
    end_label:
	
	end



