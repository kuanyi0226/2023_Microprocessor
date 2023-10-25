LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
	
; Total_cycles = 2 + (2 + 8 * num1 + 2) * num2 cycles
; num1 = 250, num2 = 250, Total_cycles = 501002
; Total_delay ~= Total_cycles/1M = 0.5s
delay macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:
        NOP
	NOP                 ; 8 cycles
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1        ; 2 cycles
	BRA LOOP2
endm

	
start:
int:
; let pin can receive digital signal 
MOVLW 0x0f
MOVWF ADCON1            ;set digital IO
CLRF PORTB
BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
CLRF LATA               ; clear latch A
CLRF TRISA            ;set RA0 as output TRISA = 0000 0000    
    
; ckeck button
check_process:          
   BTFSC PORTB, 0
   BRA check_process
   BRA lightup
   
    
lightup:
    ;judge whether it si state 5(output = 1000)
    BTFSC LATA, 3; ; skip if [3] is 0
    goto do_state1 ; LATA[3] is 1
    goto judge_again ; LATA[3] is 0
    do_state1:
	CLRF LATA; LATA[3] is 1: set LATA = 0000
	delay d'250', d'250' ; delay for 0.5s
	goto check_process; wait for pressing button
    
    judge_again:
	;judge whether it is in state 1(output = 0000)
	TSTFSZ LATA; skip if zero
	goto do_state3to5; LATA is not zero(state2~5)
	goto do_state2; LATA is zero(state1)
    do_state3to5:
        RLNCF LATA; left rotate( not in state 1
	goto delay_routine
    do_state2:
        MOVLW 0x01; WREG = 0001
	MOVFF WREG, LATA; LATA = 0001(light up RA0)
    
    delay_routine:
	delay d'250', d'250' ; delay for 0.5s
	BRA lightup
end








