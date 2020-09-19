/**********
 * ADPS-9960 Demo
 *
 * Try to cycle through each of the ADPS-9960 Operating modes
 *
 * IN-PROGRESS
 **********/

#include <msp430.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "fr2111_swi2c_master.h"


void main(void) {
	SWI2C_I2CTransaction adps9960;
	static uint8_t writeBuffer[2] = {0};
	static uint8_t readBuffer[4] = {0};
	bool status;

	WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

	SWI2C_initI2C();

	adps9960.address= 0x39;
	adps9960.writeBuffer = writeBuffer;
	adps9960.readBuffer = readBuffer;
	adps9960.numWriteBytes = 2;

	writeBuffer[0] = 0x80;
	writeBuffer[1] = BIT0 | BIT2;       // Enable PON and PEN
	status = SWI2C_performI2CTransaction(&adps9960);
	if (status == false) {
	    fprintf(stderr, "bad transaction");
	}
	else {
	    printf("good transaction");
	}


	while(1) {
	    printf("Hello, world!");
	    __delay_cycles(50000);

	}
}
