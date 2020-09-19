//***************************************************************************************
//  MSP430 Shift Register Test 1.0
//
//  Description; Display each pseudorandom byte on a shift register controlled LED vector.
//
//
//  Alex Kim
//
//***************************************************************************************

#include <msp430.h>
#include <stdlib.h>

#define SER BIT2
#define SRCLK BIT3
#define LATCH BIT4

void main(void) {
    srand(1242);

    WDTCTL = WDTPW | WDTHOLD;               // Stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5;                   // Disable the GPIO power-on default high-impedance mode
                                            // to activate previously configured port settings

    PBDIR = 0xFFFF;                           // Initialize PORTB as output 0 for power saving.
    PBOUT = 0x0000;

    PADIR |= 0xFFFF;            // Initialize P1DIR to output direction
    PAOUT &= 0x0000;            // Initialize P1OUT to 0

    for(;;) {
        if ((rand() & 1) == 0) {
            P1OUT ^= SER;                      // Toggle serial out
        }
        P1OUT |= SRCLK;                     // Trigger clock rising edge
        P1OUT &= ~(SRCLK);                    // Return clock to 0
        P1OUT |= LATCH;                     // Trigger latch high
        P1OUT &= ~(LATCH);                    // Return latch to 0

        __delay_cycles(500000);
    }


}
