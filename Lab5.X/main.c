#include <xc.h>

extern unsigned int add(unsigned int a, unsigned int b);
extern unsigned int is_square(unsigned int a);
extern unsigned int multi_signed(unsigned char a, unsigned char b);
extern unsigned int lcm(unsigned int a, unsigned int b);

void main(void) {
    //example:
    //volatile unsigned int add_result = add(12,34);
    
    //basic:
    //volatile unsigned int ans = is_square(120);
    
    //advanced:
    //volatile unsigned int res = multi_signed(-50,6);
    
    //bonus:
    volatile unsigned int lcm_ans = lcm(140,3);
    
    while(1);
    return;
}
