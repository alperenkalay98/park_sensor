TIMER1_RIS		EQU 		0x4003101C
GPIO_PORTB_DATA EQU 		0x400053FC	
TIMER1_TAR		EQU			0x40031048
TIMER1_ICR		EQU		 	0x40031024				

;This is nearly same of my lab 4 work.				
				AREA		subroutines,CODE,READONLY
				THUMB
				EXTERN		measur_chng
				EXTERN		new_conv2
				EXPORT		dist_tr
dist_tr
				PUSH{R1-R7,LR}	;it is a nested subr. It is important to push lr
				
				LDR			R1,=TIMER1_RIS			;i will use r1 to detect edge
				LDR			R2,=TIMER1_ICR			;i will clear CAERIS bit using r2
				LDR			R3,=TIMER1_TAR			;i will read timer value from r3
				LDR			R5,=GPIO_PORTB_DATA		;i will read input value from r11
				
first_edge		LDR			R0,[R1]					
				ANDS		R0,R0,#0x04				;interrupt occurs?
				BEQ			first_edge				
				LDR			R0,[R5]					
				SUBS		R0,R0,#0x10				;input is high?
				BNE			first_edge				;								 _____
				LDR			R6,[R3]					;record first time			____|
				ORR			R0,#0x04				
				STR			R0,[R2]					;clear interrupt
				
second_edge		LDR			R0,[R1]
				ANDS		R0,R0,#0x04				;interrupt occurs?
				BEQ			second_edge				;								  _____
				LDR			R7,[R3]					;record second time			_____|	   |___
				ORR			R0,#0x04				
				STR			R0,[R2]					;clear interrupt
				
				
				MOV 		R0,#0x10      			;16 clock makes 1us
				SUB 		R4,R6,R7  				;pulse width (2.edge - 1.edge)
				
				MOV		 	R9,#83
				MUL		 	R4,R4,R9
				MOV		 	R9,#100
				UDIV	 	R4,R4,R9				;0.83 is for error. I explained it in lab work
				UDIV 	 	R4,R4,R0				;(in lab 4)
				MOV			R9,#10
				MUL			R4,R4,R9
				MOV		 	R9,#48					;for converting mm 
				UDIV		R4,R4,R9					
				LDR			R1,=0xABA00
delay	 		NOP
				SUBS		R1,R1,#1
				BNE			delay
				LDR			R9,=0x3E7
				CMP			R9,R4
				BPL			gos
				MOV			R4,R9				

;I ADDED THIS PART ONLY. 
gos				BL		 	new_conv2 	;CONVERTS THIS VALUE TO ASCII CHARS AND STORES IT IN 0x20000500 
				BL			measur_chng	;CHANGES MEASUREMENT VALUES WITH CURSORS ON THE NOKIA SCREEN. THIS LINE
										;IS CRITICAL TO HAVE CONTINUOSLY CHANGING MEASUREMENT VALUES
				POP{R1-R7,LR}
				BX	LR