#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;

char str[20];
unsigned char counter; //8-bit counter
int state;
int t;
int print_count;
int print_count_ten;
void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}
void main(void) 
{
    state = 1;
    t = 3;
    print_count = 1;
    print_count_ten = 0;
    counter = 0;
    
    SYSTEM_Initialize() ;
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
    if(PIR1bits.TMR2IF == 1) {
        //AD
        if(PIR1bits.ADIF == 1){
        //    //step4
        unsigned char AD_Low = ADRESL; //8 bits
        unsigned char AD_High = ADRESH; //2 bits
        unsigned int AD_total = ADRESH * 256 + ADRESL;

        //student id
        if(AD_total < 341){
            t = 3;
            state = 1;
        }
        else if(AD_total < 690) {
            t = 6;
            state = 2;
        }
        else{
            state = 3;
            t = 12;
        } 

        //step5 & go back step3
        PIR1bits.ADIF = 0;
        //delay at least 2tad
        ADCON0bits.GO = 1;
        }
        
        //Timer
        counter++;
        
        if(counter >= t){
            if(LATC == 0xf) LATC = 0;
            else LATC = 0xf;
            counter = 0;
            //write
            UART_Write('S');
            UART_Write('t');
            UART_Write('a');
            UART_Write('t');
            UART_Write('e');
            UART_Write('_');
            UART_Write(state +48);
            UART_Write(' ');
            UART_Write('c');
            UART_Write('o');
            UART_Write('u');
            UART_Write('n');
            UART_Write('t');
            UART_Write(' ');
            UART_Write('=');
            UART_Write(' ');
            if(print_count_ten > 0){
                UART_Write(print_count_ten +48);
            }
            UART_Write(print_count +48);
            UART_Write('\r');
            UART_Write('\n');
            
            if(print_count == 9){
            print_count = 0;
            print_count_ten ++;
        }else{
            print_count ++;
        }
        }
        PIR1bits.TMR2IF = 0;
        
    }
    return;
}