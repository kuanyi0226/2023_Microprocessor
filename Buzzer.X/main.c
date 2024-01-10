#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include <pic18f4520.h>
#include "stdio.h"
#include "string.h"
// using namespace std;

unsigned char CCP1_H, CCP1_L;
unsigned char tone; //0~7 for central C to higher C
unsigned char curr_char;
//D3~C6
unsigned char tone_list_H[] = {0x0d,0x0b,0x0b,0x09,0x08,0x07,0x07,0x06,0x05,0x05,0x04,0x04,0x03,0x03,0x03,0x02,0x02,0x02,0x02,0x01,0x01};
unsigned char tone_list_L[] = {0x4d,0xda,0x30,0xf7,0xe1,0xe9,0x77,0xa7,0xed,0x98,0xfc,0x70,0xf4,0xbc,0x53,0xf6,0xcc,0x7e,0x38,0xfa,0xde};
unsigned char tone_time;
unsigned char light_pattern;
char str[20];

void MatchTone();
int ValidTone(char tone); //valid char or not


void __interrupt(high_priority) Hi_ISR(void)
{
//    //press button
//    if(INTCONbits.INT0IF){
//        tone++;
//        if(tone >= 21) tone = 0;
//        CCP1_H = tone_list_H[tone];
//        CCP1_L = tone_list_L[tone];
//        if(LATCbits.LC3 == 0) LATCbits.LC3 = 1;
//        else LATCbits.LC3 = 0;
//        INTCONbits.INT0IF = 0; //clear flag
//    }   
//    if(PIR1bits.CCP1IF = 1){
//        //turn off the lights
//        
//    }
    return;
}

void main(void) {
    SYSTEM_Initialize() ;
    
    tone = 0;
    tone_time = 0;
    light_pattern = 0;
    curr_char = '\0';
    CCP1_H = tone_list_H[tone];
    CCP1_L = tone_list_L[tone];
    
    while(1){
        strcpy(str, GetString());
        MatchTone();
        CCPR1H = CCP1_H;
        CCPR1L = CCP1_L;
        TMR3H = 0;
        TMR3L = 0;
        PIR1bits.CCP1IF = 0;
        if(tone_time > 0 && ValidTone(curr_char)){ //making sounds
            tone_time--;
            LATA = light_pattern;
            T3CONbits.TMR3ON = 1;
            while(PIR1bits.CCP1IF == 0);
            T3CONbits.TMR3ON = 0;      
        }else{
            LATA = 0;
        }       
    }
    
    return;
}

int ValidTone(char tone){
    //no sound
    if(tone == 'q' || tone == 'Q' || tone == 'w' || tone == 'W' || tone == 'e' || tone == 'E' || tone == 'r' || tone == 'R' || tone == 't' || tone == 'T' || 
            tone == 'y' || tone == 'Y' || tone == 'd' || tone == 'D'|| tone == 'f'|| tone == 'F'|| tone == 'g'|| tone == 'G'|| tone == 'h'|| tone == 'H'|| tone == 'j'
            || tone == 'J'|| tone == 'k'|| tone == 'K'|| tone == 'l'|| tone == 'L'|| tone == 'z'|| tone == 'Z'|| tone == 'x'|| tone == 'X'|| tone == 'c'|| tone == 'C'
            || tone == 'v'|| tone == 'V'|| tone == 'b'|| tone == 'B'|| tone == 'n'|| tone == 'N'|| tone == 'm'|| tone == 'M'|| tone == ',') 
        return 1;
    //has sound
    else return 0;
}

void MatchTone(){
    if(str[0] != '\0'){
        tone_time = 200;//reset the sound counter
        if(str[0] != curr_char){
            curr_char = str[0];
            switch(str[0]){
                case 'q':
                case 'Q':
                    CCP1_H = tone_list_H[0];
                    CCP1_L = tone_list_L[0];
                    light_pattern = 0b0000010;
                    break;
                case 'w':
                case 'W':
                    CCP1_H = tone_list_H[1];
                    CCP1_L = tone_list_L[1];
                    light_pattern = 0b0000100;
                    break;
                case 'e':
                case 'E':
                    CCP1_H = tone_list_H[2];
                    CCP1_L = tone_list_L[2];
                    light_pattern = 0b0001000;
                    break;
                case 'r':
                case 'R':
                    CCP1_H = tone_list_H[3];
                    CCP1_L = tone_list_L[3];
                    light_pattern = 0b0010000;
                    break;
                case 't':
                case 'T':
                    CCP1_H = tone_list_H[4];
                    CCP1_L = tone_list_L[4];
                    light_pattern = 0b0100000;
                    break;
                case 'y':
                case 'Y':
                    CCP1_H = tone_list_H[5];
                    CCP1_L = tone_list_L[5];
                    light_pattern = 0b1000000;
                    break;
                case 'd':
                case 'D':
                    CCP1_H = tone_list_H[6];
                    CCP1_L = tone_list_L[6];
                    light_pattern = 0b0000001;
                    break;
                case 'f':
                case 'F':
                    CCP1_H = tone_list_H[7];
                    CCP1_L = tone_list_L[7];
                    light_pattern = 0b0000010;
                    break;
                case 'g':
                case 'G':
                    CCP1_H = tone_list_H[8];
                    CCP1_L = tone_list_L[8];
                    light_pattern = 0b0000100;
                    break;
                case 'h':
                case 'H':
                    CCP1_H = tone_list_H[9];
                    CCP1_L = tone_list_L[9];
                    light_pattern = 0b0001000;
                    break;
                case 'j':
                case 'J':
                    CCP1_H = tone_list_H[10];
                    CCP1_L = tone_list_L[10];
                    light_pattern = 0b0010000;
                    break;
                case 'k':
                case 'K':
                    CCP1_H = tone_list_H[11];
                    CCP1_L = tone_list_L[11];
                    light_pattern = 0b0100000;
                    break;
                case 'l':
                case 'L':
                    CCP1_H = tone_list_H[12];
                    CCP1_L = tone_list_L[12];
                    light_pattern = 0b1000000;
                    break;
                case 'z':
                case 'Z':
                    CCP1_H = tone_list_H[13];
                    CCP1_L = tone_list_L[13];
                    light_pattern = 0b0000001;
                    break;
                case 'x':
                case 'X':
                    CCP1_H = tone_list_H[14];
                    CCP1_L = tone_list_L[14];
                    light_pattern = 0b0000010;
                    break;
                case 'c':
                case 'C':
                    CCP1_H = tone_list_H[15];
                    CCP1_L = tone_list_L[15];
                    light_pattern = 0b0000100;
                    break;
                case 'v':
                case 'V':
                    CCP1_H = tone_list_H[16];
                    CCP1_L = tone_list_L[16];
                    light_pattern = 0b0001000;
                    break;
                case 'b':
                case 'B':
                    CCP1_H = tone_list_H[17];
                    CCP1_L = tone_list_L[17];
                    light_pattern = 0b0010000;
                    break;
                case 'n':
                case 'N':
                    CCP1_H = tone_list_H[18];
                    CCP1_L = tone_list_L[18];
                    light_pattern = 0b0100000;
                    break;
                case 'm':
                case 'M':
                    CCP1_H = tone_list_H[19];
                    CCP1_L = tone_list_L[19];
                    light_pattern = 0b1000000;
                    break;
                case ',':
                    CCP1_H = tone_list_H[20];
                    CCP1_L = tone_list_L[20];
                    light_pattern = 0b0000001;
                    break;
            }
        }
        
        ClearBuffer(); 
    }
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
