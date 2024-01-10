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
    
    while(1) {
        strcpy(str, GetString()); // TODO : GetString() in uart.c
//        UART_Write('H');
//        UART_Write('e');
//        UART_Write('l');
//        UART_Write('l');
//        UART_Write('o');
//        if(str[0]=='h' && str[1]=='e'){ // Mode1
//            LATCbits.LC3 = 0;
//            ClearBuffer();
//            //delay
//            for(int i = 0; i < 10000; i++)for(int j = 0; j < 10000; j++);
//        }else{
//            LATCbits.LC3 = 1;
//            ClearBuffer();
//        }
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

}