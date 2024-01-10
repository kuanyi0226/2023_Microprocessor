#include <xc.h>

void INTERRUPT_Initialize (void)
{
//    //button, INT0
//    INTCONbits.INT0IF = 0; //flag
//    INTCONbits.INT0IE = 1; //enable
    
    //PIE1bits.CCP1IE = 1;
    
    RCONbits.IPEN = 1;      //enable Interrupt Priority mode
    INTCONbits.GIEH = 1;    //enable high priority interrupt
    INTCONbits.GIEL = 1;     //disable low priority interrupt
          
    
    
}

