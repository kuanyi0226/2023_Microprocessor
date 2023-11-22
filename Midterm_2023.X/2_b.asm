List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	input1 = 0x03
	input2 = 0x43
	input3 = 0x78
	input4 = 0x22
	input5 = 0x23
	input6 = 0x24
	input7 = 0x56
	input8 = 0x57
	input9 = 0x96
	
    initialize:
    ;origin
    movlw input1
    movwf 0x10
    movlw input2
    movwf 0x11
    movlw input3
    movwf 0x12
    movlw input4
    movwf 0x20
    movlw input5
    movwf 0x21
    movlw input6
    movwf 0x22
    
    movff 0x010, 0x103
    movff 0x011, 0x104
    movff 0x012, 0x105
    movff 0x020, 0x106
    movff 0x021, 0x107
    movff 0x022, 0x108
	MOVLB 0x1; BSR = 1
	MOVLW input7; WREG = input1	
	MOVWF 0x00, 1; use BSR select bank, [0x100] = input1
	MOVLW input8; WREG = input2	
	MOVWF 0x01, 1; use BSR select bank, [0x101] = input2
	MOVLW input9; WREG = input3	
	MOVWF 0x02, 1; use BSR select bank, [0x102] = input3
	
	; i: [0x00], left: [0x01] = 0, right: [0x02] = 5, temp: [0x03]
	MOVLW 0x00
	MOVWF 0x01;left
	MOVLW 0x08
	MOVWF 0x02;right
	
    while_label:
	MOVF 0x02, 0; WREG = [0x02](right)
	CPFSLT 0x01; skip if [0x01](left) < WREG(right)
	GOTO end_while; end of program
	
	MOVFF 0x01, 0x00; i = [0x01](left)
    for_label1:
	;if	
	MOVF 0x00, 0; WREG = i
	LFSR 0, 0x100; FSR0 point to 0x100
	LFSR 1, 0x101; FSR1 point to 0x101
	MOVFF PLUSW0, 0x03; temp = a[i]
	MOVF PLUSW1, 0; point 0x101 + i, WREG = [FSR0 + WREG](a[i+1])
	;Notice: FSR1 still point to 0x101(unchanged) after PLUSW1
	;Notice: PLUSWx can't do compare
	;CPFSGT PLUSW0; point 0x100 + i, skip if a[i] > a[i+1](WREG)	
	CPFSGT 0x03; point 0x100 + i, skip if a[i] > a[i+1](WREG)
	GOTO end_if1
	if_true1:
	    MOVF 0x00, 0; WREG = i
	    MOVFF PLUSW0, 0x03; temp = a[i]
	    MOVFF PLUSW1, PLUSW0; a[i] = a[i+1]
	    MOVFF 0x03, PLUSW1; a[i+1] = temp
	end_if1:
	INCF 0x00; i++
	;judge for
	MOVF 0x02, 0; WREG = [0x02](right)
	CPFSLT 0x00; skip if [0x00](i) < WREG(right)
	GOTO end_for1; i >= right
	GOTO for_label1; i < right
    end_for1:
	DECF 0x02; right--
	
	
	MOVFF 0x02, 0x00; i = [0x02](right)
    for_label2:
	;if
	MOVF 0x00, 0; WREG = i
	LFSR 0, 0x0FF; FSR0 point to 0x0FF
	LFSR 1, 0x100; FSR1 point to 0x100
	MOVFF PLUSW0, 0x03; temp = a[a-1]
	MOVF PLUSW1, 0; point 0x100 + i, WREG = [FSR0 + WREG](a[i])	
	;CPFSGT PLUSW0; point 0x0FF + i, skip if a[i-1] > a[i](WREG)
	CPFSGT 0x03; point 0x0FF + i, skip if a[i-1] > a[i](WREG)
	GOTO end_if2
	if_true2:
	    MOVF 0x00, 0; WREG = i
	    MOVFF PLUSW1, 0x03; temp = a[i]
	    MOVFF PLUSW0, PLUSW1; a[i] = a[i-1]
	    MOVFF 0x03, PLUSW0; a[i-1] = temp
	end_if2:
	DECF 0x00; i--
	;judge for
	MOVF 0x01, 0; WREG = [0x01](left)
	CPFSGT 0x00; skip if [0x00](i) > WREG(left)
	GOTO end_for2; i <= right
	GOTO for_label2; i > right
    end_for2:
	INCF 0x01; left++
	
        GOTO while_label
	
    end_while:
    ;move the results to the target
    MOVFF 0x100, 0x000
    MOVFF 0x101, 0x001
    MOVFF 0x102, 0x002
    MOVFF 0x103, 0x003
    MOVFF 0x104, 0x004
    MOVFF 0x105, 0x005
    MOVFF 0x106, 0x006
    MOVFF 0x107, 0x007
    MOVFF 0x108, 0x008
    
    NOP
	end


