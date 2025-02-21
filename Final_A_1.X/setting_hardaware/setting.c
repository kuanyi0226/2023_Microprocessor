// CONFIG1H
#pragma config OSC = INTIO67      // Oscillator Selection bits (HS oscillator)
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
#pragma config IESO = ON       // Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

// CONFIG2L
#pragma config PWRT = OFF       // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = SBORDIS  // Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config BORV = 3         // Brown Out Reset Voltage bits (Minimum setting)

// CONFIG2H
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 1        // Watchdog Timer Postscale Select bits (1:1)

// CONFIG3H
#pragma config CCP2MX = PORTC   // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

// CONFIG4L
#pragma config STVREN = ON      // Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
#pragma config LVP = OFF         // Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
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



#include "setting.h"

void SYSTEM_Initialize(void)
{

    // PIN_MANAGER_Initialize();
    OSCILLATOR_Initialize(); //default 1Mhz
//    TMR2_Initialize();
//    TMR1_Initialize();
//    TMR0_Initialize();
    //INTERRUPT_Initialize();
    UART_Initialize();
//    CCP1_Initialize();
//    ADC_Initialize();
     TRISC = 0; //output
    LATC = 0xf;
    
    RCONbits.IPEN = 1;
    
    //to use TIMER2: TMR2IF,TMR2IE,TMR2IP
    PIR1bits.TMR2IF = 0;
    IPR1bits.TMR2IP = 1;
    PIE1bits.TMR2IE = 1;    
    
    
    
    
    //1s
    T2CON = 0xff; //?Prescale?Postscale???1:16.TIMER2+1/per 256 cycles //???TIMER?????????/4????????
    PR2 = 244;//???256 * 4 = 1024 cycles???TIMER2 + 1 //250khz: expecting Delay 0.5s, 125000cycles to occur one Interrupt
    //??PR2 should be 125000 / 1024 = 122.0703125? around 122
    
    TRISAbits.RA0 = 1;       //analog input port

    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0: analog input, others: digital
    ADCON0bits.CHS = 0b0000;  //AN0 is analog input
    ADCON2bits.ADCS = 0b100;  //by table: 100(4Mhz < 5.71Mhz)
    ADCON2bits.ACQT = 0b110;  //Tad = ? us acquisition time?2Tad = ? > 2.4
    ADCON0bits.ADON = 1; //enable ADC functioon
    ADCON2bits.ADFM = 1;    //right justified 
    
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;

    //step2

    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
    
    //step3
    ADCON0bits.GO = 1;
}

void OSCILLATOR_Initialize(void)
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b110; //4MHz; 100:1MHz

    // RCON = 0x0000;
}