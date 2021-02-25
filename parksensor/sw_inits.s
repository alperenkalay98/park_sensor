;Nested Vector Interrupt Controller registers
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 30 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI7			EQU 0xE000E41C ; IRQ 28 to 31 Priority Register
;GPIO registers for PORTF
GPIO_PORTF_DATA		EQU  0x40025000
GPIO_PORTF_IM       EQU  0x40025410
GPIO_PORTF_DIR      EQU  0x40025400
GPIO_PORTF_AFSEL    EQU  0x40025420
GPIO_PORTF_DEN      EQU  0x4002551C
GPIO_PORTF_AMSEL    EQU  0x40025528
GPIO_PORTF_PCTL     EQU  0x4002552C
GPIO_PORTF_LOCK     EQU  0x40025520
GPIO_PORTF_CR       EQU  0x40025524
GPIO_PORTF_IS       EQU  0x40025404
GPIO_PORTF_IBE      EQU  0x40025408
GPIO_PORTF_IEV      EQU  0x4002540C
GPIO_PORTF_ICR      EQU  0x4002541C
GPIO_PORTF_RIS		EQU	 0x40025414
GPIO_PORTF_PUR		EQU	 0x40025510
SYSCTL_RCGPIO       EQU  0x400FE608

			AREA		subrouintes,CODE,READONLY
			THUMB
			EXPORT		sw_inits
sw_inits
			PUSH{R0-R5,LR}
			
			LDR		R1,=SYSCTL_RCGPIO			;clock on for portf
			LDR		R0,[R1]
			ORR		R0,R0,#0x20
			STR		R0,[R1]
			NOP
			NOP
			NOP
			
			LDR		R1,=GPIO_PORTF_LOCK			;unlocking 
			LDR		R0,=0x4C4F434B
			STR		R0,[R1]
			LDR		R1,=GPIO_PORTF_CR
			MOV		R0,#0xFF
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_DIR			;pf0 and pf4 output
			LDR		R0,[R1]
			BIC		R0,R0,#0x11
			STR		R0,[R1]
			
			LDR 	R1, =GPIO_PORTF_AFSEL 		;no alt func
			LDR 	R0, [R1]
			BIC 	R0, R0, #0x11
			STR 	R0, [R1]
			
			LDR		R1,=GPIO_PORTF_DEN			;all digital enabled
			LDR		R0,[R1]
			MOV		R0,#0xFF
			STR		R0,[R1]
			LDR		R1,=GPIO_PORTF_AMSEL		;no analog
			MOV		R0,#0x00
			STR		R0,[R1]
			
			LDR 	R1, =GPIO_PORTF_PUR			;pull ups on pins 0 and 4 of PORT F
			MOV 	R0, #0x11 					
			STR 	R0, [R1]

			LDR 	R1, =GPIO_PORTF_IS
			LDR 	R2, =GPIO_PORTF_IBE 
			LDR 	R3, =GPIO_PORTF_IEV 
			LDR 	R4, =GPIO_PORTF_IM 
			LDR 	R5, =GPIO_PORTF_ICR 
				
			MOV 	R0, #0x00 
			STR 	R0, [R1]  					;edge-sensitive 
			STR 	R0, [R2]  					;not both edges 
			MOV 	R0, #0x11 	
			STR 	R0, [R3] 
			STR 	R0, [R4]  					;enable interrupt for PF4&PF0
			STR 	R0, [R5]  					;clear interrupt flag for PF4&PF0

			
			POP	{R0-R5,LR}
			BX		LR