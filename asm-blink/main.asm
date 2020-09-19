;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
; Author: Alex Kim
;
; Toggle an LED using timer interrupt
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
; Setup
;-------------------------------------------------------------------------------

			bis.b	#1,&P1DIR				; P1.0 init output

			nop
			bis.w	#GIE, SR
			nop								; Avoid errata

			bis		#TASSEL_1,&TA0CTL		; TASSEL == 0b01 select ACLK
			bis		#ID_0,&TA0CTL			; ID == 0b00 select /1
			bis		#TAIDEX_0,&TA0EX0		; IDEX == 0b000, select /1
			bis		#TACLR,&TA0CTL
			bis		#TAIE,&TA0CTL
			bis		#MC_2,&TA0CTL

			bic.w	#LOCKLPM5,&PM5CTL0		; Unlock I/O



;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
MainLoop:	jmp		MainLoop
			nop


;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
TA0_ISR:	bic		#TAIFG,&TA0CTL

			xor.b	#1,&P1OUT

			reti


;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
            .sect	".int44"				; TA0 Vector
            .short	TA0_ISR

