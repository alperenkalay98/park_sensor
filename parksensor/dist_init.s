;GPIO registers
GPIO_PORTB_DATA 	EQU 	0x400053FC 
GPIO_PORTB_DIR 		EQU 	0x40005400 
GPIO_PORTB_AFSEL 	EQU 	0x40005420 
GPIO_PORTB_DEN 		EQU 	0x4000551C
GPIO_PORTB_AMSEL 	EQU 	0x40005528 
GPIO_PORTB_PCTL 	EQU 	0x4000552C 
;Timer registers
TIMER1_CFG			EQU 	0x40031000
TIMER1_TAMR			EQU 	0x40031004
TIMER1_CTL			EQU 	0x4003100C
TIMER1_IMR			EQU 	0x40031018
TIMER1_RIS			EQU 	0x4003101C 
TIMER1_ICR			EQU 	0x40031024 
TIMER1_TAILR		EQU 	0x40031028 
TIMER1_TAPR			EQU 	0x40031038
TIMER1_TAR			EQU		0x40031048 
;Clocks
SYSCTL_RCGCGPIO 	EQU 	0x400FE608 
SYSCTL_RCGCTIMER 	EQU 	0x400FE604 

					AREA 	routines, CODE, READONLY
					THUMB
					EXPORT 	dist_init

dist_init	
					PUSH{R0-R2,LR}					
					LDR 	R1,=SYSCTL_RCGCGPIO	 	;GPIO clock starts
					LDR 	R0,[R1]
					ORR 	R0,R0, #0x02 		
					STR 	R0,[R1]
					NOP 				
					NOP
					NOP
			
					LDR 	R1,=GPIO_PORTB_DIR	 	
					LDR 	R0,[R1]
					MOV 	R0,#0x08 				;set PB4 for input,PB3 for output
					STR 	R0,[R1]
			
					LDR 	R1,=GPIO_PORTB_AFSEL   ; alternate function
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x10
					STR 	R0,[R1]
			
					LDR 	R1,=GPIO_PORTB_PCTL 	;set alternate function to timer
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x00070000
					STR 	R0,[R1]
			
					LDR 	R1,=GPIO_PORTB_AMSEL  	;disable analog
					MOV 	R0,#0
					STR 	R0,[R1]
				
					LDR 	R1,=GPIO_PORTB_DEN     	;enable digital port
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x18
					STR 	R0,[R1]
			
					LDR		R1,=GPIO_PORTB_DATA		;trigger pulse for HC-SR04
					MOV		R0,#0x08
					STR		R0,[R1]
					LDR		R2,=0xA0
delay				NOP								;high with delay
					SUBS	R2,#1
					BNE		delay					
					MOV		R0,#0x00				;low for rest
					STR		R0,[R1]	
					
					
					LDR 	R1,=SYSCTL_RCGCTIMER  	;starts clock for timer1
					LDR 	R2,[R1]
					ORR 	R2,R2,#0x02
					STR 	R2,[R1]
					NOP 							
					NOP
					NOP
			
					LDR 	R1,=TIMER1_CTL 			;disable timer during setup 
					LDR 	R2,[R1]
					BIC 	R2,R2,#0x01
					STR 	R2,[R1]    
			
					LDR 	R1,=TIMER1_CFG
					MOV 	R2,#0x04				;16 bit timer
					STR 	R2,[R1]			
				
					LDR 	R1,=TIMER1_TAMR
					MOV 	R2,#0x07 				;edge time,capture mode
					STR 	R2,[R1]
			
					LDR 	R1,=TIMER1_CTL  		;edge detection,both edges
					LDR		R2,[R1]
					ORR 	R2,R2,#0x0C
					STR 	R2,[R1]
			
					LDR 	R1,=TIMER1_TAILR		;max value for counting down
					LDR 	R0,=0xFFFFFFFF
					STR 	R0,[R1]
					
					LDR 	R1,=TIMER1_TAPR			;4 bit for prescale
					MOV 	R0,#0x0F
					STR 	R0,[R1]
			
					LDR 	R1,=TIMER1_CTL
					LDR 	R2,[R1]
					ORR 	R2,R2,#0x03 			;set bit0 to enable timer
					STR 	R2,[R1] 				;and bit 1 to stall on debug
		
					POP{R0-R2,LR}
					BX 		LR