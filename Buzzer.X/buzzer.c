// CONFIG1H
#pragma config OSC = INTIO67    // Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
#pragma config IESO = OFF       // Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

// CONFIG2L
#pragma config PWRT = OFF       // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = SBORDIS  // Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config BORV = 3         // Brown Out Reset Voltage bits (Minimum setting)

// CONFIG2H
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)

// CONFIG3H
#pragma config CCP2MX = PORTC   // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

// CONFIG4L
#pragma config STVREN = ON      // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config XINST = OFF      // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

// CONFIG5L
#pragma config CP0 = OFF        // Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
#pragma config CP1 = OFF        // Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
#pragma config CP2 = OFF        // Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
#pragma config CP3 = OFF        // Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

// CONFIG5H
#pragma config CPB = OFF        // Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
#pragma config CPD = OFF        // Data EEPROM Code Protection bit (Data EEPROM not code-protected)

// CONFIG6L
#pragma config WRT0 = OFF       // Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
#pragma config WRT1 = OFF       // Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
#pragma config WRT2 = OFF       // Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
#pragma config WRT3 = OFF       // Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

// CONFIG6H
#pragma config WRTC = OFF       // Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
#pragma config WRTB = OFF       // Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
#pragma config WRTD = OFF       // Data EEPROM Write Protection bit (Data EEPROM not write-protected)

// CONFIG7L
#pragma config EBTR0 = OFF      // Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR1 = OFF      // Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR2 = OFF      // Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
#pragma config EBTR3 = OFF      // Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

// CONFIG7H
#pragma config EBTRB = OFF      // Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#include <pic18f4520.h>


unsigned char CCP1_H, CCP1_L;
unsigned char tone; //0~7 for central C to higher C
unsigned char tone_list_H[] = {0x0e,0x0d,0x0b,0x0b,0x09,0x08,0x07,0x07};
unsigned char tone_list_L[] = {0xe9,0x49,0xd6,0x31,0xf7,0xe1,0xe8,0x74};

void __interrupt(high_priority) Hi_ISR(void)
{
    //press button
    if(INTCONbits.INT0IF){
        tone++;
        if(tone >= 8) tone = 0;
        CCP1_H = tone_list_H[tone];
        CCP1_L = tone_list_L[tone];
        if(LATCbits.LC3 == 0) LATCbits.LC3 = 1;
        else LATCbits.LC3 = 0;
        INTCONbits.INT0IF = 0; //clear flag
    }    
    return;
}

void main(void) {
    CCP1_H = tone_list_H[0];
    CCP1_L = tone_list_L[0];
    tone = 0; //central C
    
    OSCCON = 0x70;
    CCP1CON = 0x02;
    
    TRISBbits.RB0 = 1; //INT0 for input
    LATB = 0;
    TRISCbits.RC2 = 0;//RC2 for CCP1 output
    T3CON = 0x40;
    
    //light
    TRISCbits.RC3 = 0;
    LATCbits.LC3 = 1;
    
    //interrupt
    ADCON1 = 0x0f; //digital io
    RCONbits.IPEN = 0;      //enable Interrupt Priority mode
    //button, INT0
    INTCONbits.INT0IF = 0; //flag
    INTCONbits.INT0IE = 1; //enable
    INTCONbits.GIE = 1;
    
    
    while(1){
        CCPR1H = CCP1_H;
        CCPR1L = CCP1_L;
        TMR3H = 0;
        TMR3L = 0;
        PIR1bits.CCP1IF = 0;
        T3CONbits.TMR3ON = 1;
        while(PIR1bits.CCP1IF == 0);
        T3CONbits.TMR3ON = 0;
    }
    
    return;
}
/*
 * OSCCON = 0x70;
 * CCPR1 value:
 * central C = 0x0ee9
 * D = 0x0d49
 * E = 0x0bd6
 * F = 0x0b31
 * G = 0x09f7
 * A = 0x08e1
 * B = 0x07e8
 * C = 0x0774
 */
