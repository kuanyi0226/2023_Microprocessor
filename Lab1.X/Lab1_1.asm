List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	x1 = 0x07
	x2 = 0x08
	y1 = 0x0D
	y2 = 0x0C
	
	;//x1
	MOVLW x1; WREG = x1
	MOVWF 0x00; [0x00] = WREG
	;//x2
	MOVLW x2
	MOVWF 0x01
	;//x1 + x2
	ADDWF 0x00, 0; WREG = WREG + [0x00]
	MOVWF 0x10; [0x10] = WREG
	
	;//y1
	MOVLW y1; 
	MOVWF 0x02;
	;//y2
	MOVLW y2
	MOVWF 0x03
	;//y1 - y2
	SUBWF 0x02, 0; WREG = [0x02] - WREG
	MOVWF 0x11; [0x11] = WREG
	
	;//judge same value
	MOVF 0x10, 0;WREG = [0x01] = x1 + x2
	CPFSEQ 0x11; Compare with y1 -y2 //skip if WREG == [0x11]
	GOTO else_label ;Notice: can not use 'end' as label(jump if not the same)
	MOVLW 0xFF; the same
	MOVWF 0x20
	GOTO end_program
	else_label:
	MOVLW 0x01; not the same
	MOVWF 0x20
	
	end_program:
	
	
	end


