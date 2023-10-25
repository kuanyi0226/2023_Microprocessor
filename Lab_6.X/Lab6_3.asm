LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF
    
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
	
;Start of the program
    L1	EQU 0x14
    L2	EQU 0x15
    Direction_Flag EQU 0x00; 0: right, 1: left, 2: no lights
    button_ISR_No_Conflict EQU 0x01; 0: skip ISR, 1: do ISR
    In_Checking EQU 0x02; currenly the pc is in check_process or not 
    org 0x00
    goto initial
    
ISR_0:
    org 0x08;    nonmaskable
    ;skip the ISR if we press button in initial state
    MOVF button_ISR_No_Conflict, 1 ; F = F: find itself is zero?
    BZ end_ISR; skip ISR
    
    INCF Direction_Flag; change state
    ;if state == 3(state: only 0~2), turn it to 0
    MOVLW 0x03; WREG = 3
    CPFSLT Direction_Flag; skip if flag < 3
    CLRF Direction_Flag; flag >= 3: set flag = 0
    
    ;initialize the light of state0, state2
    ;judge direction: 00 01 10
    CLRF LATA; default 10: state 0, no light
    BTFSC Direction_Flag, 0; skip if flag[0] is 0
    BSF LATA, 3; is 1 (01: state 2, RA3)
    
    end_ISR:
    BSF button_ISR_No_Conflict, 0; is 00 or 01: pull the flag = 1(Do ISR as usual)
    BTFSC Direction_Flag, 1; skip if flag[1] is 0(is not 10)
    CLRF button_ISR_No_Conflict; flag = 0, is 10: when it goes back to initial state(00)later, dont do ISR
    
    ;in check_process, 
    BTFSC In_Checking, 0; skip if flag is 0(not in checking process)
    BSF button_ISR_No_Conflict, 0;pull the flag = 1(Break the check_process, to do state_1)
    
    BCF INTCON, INT0IF; clear the interrupt flag in interuppt control reg before return(or it comes back to interrupt agsin
    RETFIE
    

initial:
; let pin can receive digital signal 
MOVLW 0x0f
MOVWF ADCON1            ;set digital IO
CLRF PORTB ; it's also the port of INT0
BSF TRISB, 0   ;set RB0 as input TRISB = 0000 0001         
CLRF TRISA            ;set RA0 as output TRISA = 0000 0000    
    
    
BSF RCON,IPEN ;Enable priority levels on interrupts
MOVLW B'11010000'
MOVWF INTCON
MOVLW B'01110001'
MOVWF INTCON2 
    
CLRF Direction_Flag
BSF Direction_Flag, 1; direction flag = 10
CLRF button_ISR_No_Conflict; dont do ISR
CLRF In_Checking
BSF In_Checking, 0; set the flag to 1(in check_process currently)
    
; ckeck button
check_process:    
   BSF In_Checking, 0; set the flag to 1(in check_process currently)
   CLRF LATA               ; clear latch A(no lights)
   
   BTFSS button_ISR_No_Conflict, 0; skip if 1(have been to ISR)
   BRA check_process ; ==0
   ; == 1
   
state_1:
    CLRF check_process
    BSF button_ISR_No_Conflict, 0; set 1: let ISR work
    CLRF LATA
    BSF LATA, 0 ;RA0 
    CLRF Direction_Flag; flag = 00
    goto delay_routine_1
;rightward
state_1_loop:
    ;judge direction: 00 01 10
    BTFSC Direction_Flag, 0; skip if flag[0] is 0
    goto state_2_loop; is 1 (01: state 2)
    BTFSC Direction_Flag, 1; skip if flag[1] is 0
    goto check_process; is 1 (10: state 0)
    ; is 0 (00: state 1)
    
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
	delay d'250', d'250' ; delay for 0.5s
	BRA state_1_loop
	
;leftward    
state_2_loop:
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
	delay d'250', d'250' ; delay for 0.5s
	BRA state_1_loop
end











