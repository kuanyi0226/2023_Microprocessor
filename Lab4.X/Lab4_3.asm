List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	input_n = 0x0a
	input_k = 0x05
	;address parameter
	n_addr = 0x02
	k_addr = 0x03
	right_flag_addr = 0x04; left = 0, right = 1
	done_flag_addr = 0x05; returned upward and done a combination(no = 0, yes = 1)
	
    initial: ;prepare parameter
	MOVLW input_n; WREG = n
	MOVWF n_addr; [0x02] = n
	MOVLW input_k; WREG = k
	MOVWF k_addr; [0x03] = k
		
	CLRF 0x00; result
	CLRF right_flag_addr
	CLRF done_flag_addr
	
	rcall Fact
	goto finish
	
    Set_Done_Flag macro 
	MOVLW 0x01; right_flag = 1
	MOVWF done_flag_addr; done one C(?,?)
	endm
    Reset_Done_Flag macro 
	MOVLW 0x00; right_flag = 0
	MOVWF done_flag_addr; havent done one C(?,?)
	endm
    
    ; by Pascal C(n,k) = C(n-1,k)"left" + C(n-1,k-1)"right"
    Fact:
	; k == 0?
	MOVF k_addr, WREG ; WREG = k, also calculate Z
	BZ return_back ; Z == 0
	
	; k == n?
	MOVFF k_addr, WREG ; WREG = k
	CPFSEQ n_addr; skip if k == n 
	goto recursive ; k != n
	goto return_back; k == n
	
	
	
	return_back:
	    INCF 0x00; result++
	    ;restore n and k
	    INCF n_addr; n++
	    BTFSC right_flag_addr, 0; skip if right_flag == 0(left: k remain the same)
	    INCF k_addr; k++
	    RETURN
	recursive:
	    
	    ;1. left
	    ;reset the flag first
	    Reset_Done_Flag; reset the flag, havent done C(?,?)
	    ;do left routine
	    DECF n_addr; n--
	    MOVLW 0x00; right_flag = 0
	    MOVWF right_flag_addr; left subroutine
	    rcall Fact 
		    
	    ;2. right
	    ;important to judge: whehter the last step returns from the left
	    ; done_flag == 0?
	    MOVF done_flag_addr, WREG ; WREG = done_flag_addr, also calculate Z
	    BZ is_zero ; Z == 0, dont have to restore k
	    restore_k:
	    DECF k_addr; k-- (very important!! Cuz when is returns upward from left, k shouldnt change, so we restore it)
	    Reset_Done_Flag; reset the flag
	    is_zero:
	    ;do right subroutine
	    DECF n_addr; n--
	    DECF k_addr; k--
	    MOVLW 0x01; right_flag = 1
	    MOVWF right_flag_addr; right subroutine
	    rcall Fact
	    
	    ;3. finish right, done one combination C(?,?)
	    Set_Done_Flag; macro
	    INCF n_addr; n++ 
	    INCF k_addr; k++ default returns from right
	    RETURN
	    
	    ;Debug note:
	    ;Done_Flag is for: when we calculate C(5,3)
	    ;when it finished C(4,3), it returns to C(5,4) instead of C(5,3)
	    ;this is becuz it returned from left(default is right)
	    ;so if the next step is do right subroutine(which means the situation above happens,
	    ;we should minus k by 1, before we do right subroutine
    finish:
	
	end


