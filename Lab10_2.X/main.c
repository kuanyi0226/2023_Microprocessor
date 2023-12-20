#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;

char str[20];
void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}
void main(void) 
{
    
    SYSTEM_Initialize() ;
    UART_Write('0'); //print 0 on screen
    UART_Write(' '); //print space
    while(1) {
        strcpy(str, GetString()); // TODO : GetString() in uart.c
//        if(str[0]=='m' && str[1]=='1'){ // Mode1
//            Mode1();
//            ClearBuffer();
//        }
//        else if(str[0]=='m' && str[1]=='2'){ // Mode2
//            Mode2();
//            ClearBuffer();  
//        }
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{
    //press button
    if(INTCONbits.INT0IF){
        LATC ++;
        if(LATC == 16) LATC = 0;
        if(LATC < 10){
            UART_Write(LATC +48); //print ascii number on screen
        }
        else{ //>=10
            UART_Write('1'); //tens space
            UART_Write((LATC-10) +48); //ones space
        }     
        UART_Write(' '); //print space
    }
    INTCONbits.INT0IF = 0; //clear flag
    return;
}