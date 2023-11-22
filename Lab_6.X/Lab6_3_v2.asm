LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    CURR_STATE EQU 0x01
    GO_LOOP EQU 0x02 ; whether to initialize the light in each state
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

Judge_State macro
    ;read input
    ;rcall check_process
    ;judge state 00 01 10
    BTFSC CURR_STATE, 0; skip if flag[0] is 0
    goto state1_init; is 1 (01: state 1)
    BTFSC CURR_STATE, 1; skip if flag[1] is 0
    goto state2_init; is 1 (10: state 2)
    goto state0; is 0 (00: state 0)
endm
	
start:
init:
; let pin can receive digital signal 
MOVLW 0x0f
MOVWF ADCON1            ;set digital IO
CLRF PORTB
BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
CLRF LATA               ; clear latch A
CLRF TRISA            ;set RA0 as output TRISA = 0000 0000    
CLRF CURR_STATE
CLRF GO_LOOP; initial first
goto state0
    
; ckeck button
check_process:      
   BTFSC PORTB, 0; skip if input == 0(pressed)
   goto end_check
   INCF CURR_STATE; state++
   ;if state == 3(state: only 0~2), turn it to 0
    MOVLW 0x03; WREG = 3
    CPFSLT CURR_STATE; skip if CURR_STATE < 3
    CLRF CURR_STATE; CURR_STATE >= 3: set CURR_STATE = 0
    
    CLRF GO_LOOP; init first
end_check:
   RETURN
   
    
state0:
    CLRF LATA               ; clear latch A
    ;rcall check_process
    delay d'250', d'250' ; delay for 0.5s
    rcall check_process
    Judge_State

state1_init:
    BTFSC GO_LOOP, 0; skip if 0(init first)
    BRA state1
    CLRF LATA
    BSF LATA, 0 ;RA0
    BTG GO_LOOP, 0
    goto delay_routine_1
state1:
    ;change light
    RLNCF LATA; is 0: left rotate
    ;judge whether output = 10000 (overflow)
    BTFSS LATA, 4; skip if LATA[4] is 1
    goto delay_routine_1; is 0 (not overflow)
    RRNCF LATA; is 1: right rotate*4, become 0001(RA0)
    RRNCF LATA;
    RRNCF LATA;
    RRNCF LATA;
    delay_routine_1:
	;rcall check_process
	delay d'250', d'250' ; delay for 0.5s
	rcall check_process
	Judge_State
	
state2_init:
    BTFSC GO_LOOP, 0; skip if 0(init first)
    BRA state2
    CLRF LATA
    BSF LATA, 3; RA3
    BTG GO_LOOP, 0
    goto delay_routine_2
state2:
    ;change light
    RRNCF LATA; is 0: right rotate
    ;judge whether output = 10000000 (overflow)
    BTFSS LATA, 7; skip if LATA[7] is 1
    goto delay_routine_2; is 0 (not overflow)
    RLNCF LATA; is 1: left rotate*4, become 1000(RA3)
    RLNCF LATA;
    RLNCF LATA;
    RLNCF LATA;
    delay_routine_2:
	;rcall check_process
	delay d'250', d'250' ; delay for 0.5s
	rcall check_process
	Judge_State
    
end