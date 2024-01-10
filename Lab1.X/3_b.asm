List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	dividend_l = 0xf8
	divisor_l = 0x03
	
	;shift macro
	Shift_m macro x_h,x_l,y_h,y_l,res_h,res_l
	    
	    MOVFF x_l, 0x08
	    
	    MOVFF y_l, 0x18

	    CLRF 0x27
	    CLRF 0x28
	    
	    RRCF 0x81
	    RLCF 0x82
	    
	    MOVFF x_h, 0x07
	    MOVFF y_h, 0x17

	    MOVFF y_l, WREG
	    SUBWF x_l, W
	    MOVWF res_l

	    MOVFF y_h, WREG
	    SUBWFB x_h, W
	    MOVWF res_h
	endm
		
        Division macro  x_h,x_l,y_h,y_l,q_h,q_l
	;Notice that it will not skip the whole macro
	    goto macro_not_skip
	    goto skip_macro
	    macro_not_skip:
		;ininialize
		CLRF q_h
		CLRF q_l
		MOVFF x_h, 0x54
		MOVFF x_l,  0x55
		MOVFF y_h, 0x64
		MOVFF y_l, 0x65
		;turn positive
		goto divide_loop; skip if unsigned
		BTFSC x_h, 7 ;skip if msb of Multiplicand is 0(positive)
		goto negate_x
		goto judge_negate_y
		negate_x:
		COMF 0x54
		NEGF 0x55
		BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
		INCF 0x54; ++
		judge_negate_y:
		BTFSC y_h, 7 ;skip if bit3 of Multiplier is 0(positive)
		goto negate_y
		goto end_negate
		negate_y:
		COMF 0x64
		NEGF 0x65
		BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
		INCF 0x64; ++
		end_negate:
		
	    divide_loop:
	    compare_high:
		MOVFF 0x64, WREG
		CPFSLT 0x54; skip if less than
		goto judge_high_equal_bigger
		goto skip_macro; end
	    judge_high_equal_bigger:
		MOVFF 0x64, WREG
		CPFSEQ 0x54; skip if equal
		goto minus_16bit
		goto compare_low
	    compare_low:
		MOVFF 0x65, WREG
		CPFSLT 0x55; skip if less than
		goto minus_16bit
		goto skip_macro; end
    
	    minus_16bit:
		Shift_m 0x54,0x55,0x64,0x65,0x54,0x55
		INCF q_l; q++
		BTFSC STATUS, 0; skip if carry flag == 0 (no carry)
		INCF q_h; ++
		goto divide_loop
		
		
	    skip_macro:
	
	endm
	dividend_h = 0x00
	divisor_h = 0x00
	
	CLRF 0x71
	;16bit signed division
	
	
	MOVLW dividend_h
	MOVWF 0x50
	MOVLW dividend_l
	MOVWF 0x51
	MOVLW divisor_h
	MOVWF 0x60
	MOVLW divisor_l
	MOVWF 0x61
	
	
	Division 0x50,0x51,0x60,0x61,0x70,0x71
	MOVFF 0x71, 0x00
	MOVFF 0x55, 0x01
	
	NOP
	
	
end





