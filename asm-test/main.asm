;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
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

			bis.b	#1,&PADIR_L				; P1.0 init output
			bic.w	#LOCKLPM5,&PM5CTL0		; Unlock I/O

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
MainLoop:	bis.b	#1,&PAOUT_L				; P1.0 high

			mov		#50000,r4				; 50k cycle delay
DelayOn:	sub		#1,r4
			cmp		#0,r4
			jnz		DelayOn

			bic.b	#1,&PAOUT_L				; P1.0 low

			mov		#50000,r4				; 50k cycle delay
DelayOff:	sub		#1,r4
			cmp		#0,r4
			jnz		DelayOff

			jmp		MainLoop
			nop


                                            

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
            
