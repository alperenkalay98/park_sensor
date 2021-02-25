
GPIO_PORTF_RIS		EQU	 0x40025414
GPIO_PORTF_ICR      EQU  0x4002541C

HANDLER_CHECK		EQU	0x20000800	;motor handler will stop according to this location value
	
			
			AREA		subroutines,CODE,READONLY
			THUMB

			EXPORT		SW2_detect

SW2_detect
			PUSH{R0,R1,LR}
			
			LDR			R1,=GPIO_PORTF_RIS	
loop		LDR			R0,[R1]
			ANDS		R0,R0,#0x01
			BEQ			loop

			LDR			R1,=HANDLER_CHECK
			MOV			R0,#0
			STRB		R0,[R1]
			
			LDR			R1,=GPIO_PORTF_ICR
			MOV			R0,#0x01
			STR			R0,[R1]
			
			POP{R0,R1,LR}
			BX	LR