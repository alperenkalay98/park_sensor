;GPIO PORTD registers
PD_OUT				EQU		0x4000703C
GPIO_PORTD_DIR		EQU		0x40007400
GPIO_PORTD_AFSEL	EQU		0x40007420
GPIO_PORTD_DEN		EQU		0x4000751C
SYSCTL_RCGCGPIO		EQU		0x400FE608
GPIO_PORTD_GPIODR8R EQU     0x40007508
;NVICs
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
;Timer registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU 0x40030048 ; Timer register
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control


HANDLER_CHECK		EQU	0x20000800	;motor handler will stop according to this location value!!
	
;STORED MEASURED VALUES AND THRESHOLD VALUE. SINCE I AM USING LOTS OF SUBROUTINES,  
;I STORE IT IN MEMORY FIRST, THEN IF REQUIRED, I USE THIS VALUES BY SIMPLY READING 	
;IN OTHER SUBROUTINES
THRESH_VAL			EQU	0x20000600
MEAS_VAL			EQU	0x20000700	
THRESH_UPD			EQU	0x20000400			
MEAS_UPD			EQU	0x20000500	


					AREA	ports,READONLY,CODE,ALIGN=2
					THUMB
						
					EXPORT  motor_init

motor_init			
					PUSH{R0,R1,R2,LR}
					LDR		R1,=SYSCTL_RCGCGPIO	;gpio clock on 
					LDR		R0,[R1]
					ORR		R0,R0,#0x08
					STR		R0,[R1]
					NOP
					NOP
					NOP
										
					LDR		R1,=GPIO_PORTD_DIR
					LDR		R0,[R1]
					ORR		R0,R0,#0x0F			;PD0,PD1,PD2,PD3 output
					BIC		R0,R0,#0xF0
					STR		R0,[R1]
					
					LDR		R1,=GPIO_PORTD_AFSEL	;no alt func
					LDR		R0,[R1]
					BIC		R0,#0xFF
					STR		R0,[R1]
					
					LDR		R1,=GPIO_PORTD_DEN		;all digital enabled
					LDR		R0,[R1]
					ORR		R0,#0xFF
					STR		R0,[R1]
							
					LDR		R0,=0x01				;first load of motor,it will change continuosly 
					LDR		R1,=PD_OUT				;which i arranged it below
					STR		R0,[R1]										
					
										
					LDR R1, =SYSCTL_RCGCTIMER ;Timer0 clock starts
					LDR R2, [R1]
					ORR R2, R2, #0x01
					STR R2, [R1]
					NOP                       
					NOP
					NOP
					LDR R1, =TIMER0_CTL       ; disable timer during setup 
					LDR R2, [R1]
					BIC R2, R2, #0x01
					STR R2, [R1]
					
					LDR R1,=TIMER0_TAPR
					MOV	R2,#0x0FFFF
					STR R2,[R1]
					
					LDR R1, =TIMER0_CFG      ; 16 bit
					MOV R2, #0x04
					STR R2, [R1]
					LDR R1, =TIMER0_TAMR
					MOV R2, #0x02           ; periodic, count down
					STR R2, [R1]
					
					
					
					LDR 	R1, =TIMER0_TAILR  
					LDR		R2,=0x800
					STR 	R2, [R1]
					
					LDR R1, =TIMER0_TAPR
					MOV R2, #15            	; divide clock by 16 to
					STR R2, [R1]           	; get 1us clocks
					LDR R1, =TIMER0_IMR    	; enable timeout interrupt
					MOV R2, #0x01
					STR R2, [R1]
					


					LDR R1, =NVIC_PRI4
					LDR R2, [R1]
					AND R2, R2, #0x00FFFFFF 	; clear interrupt 19 priority
					ORR R2, R2, #0x40000000 	; set interrupt 19 priority to 2
					STR R2, [R1]

					LDR R1, =NVIC_EN0
					MOVT R2, #0x08    	 	; set bit 19 to enable interrupt 19
					STR R2, [R1]

					LDR R1, =TIMER0_CTL
					LDR R2, [R1]
					ORR R2, R2, #0x03  		; set bit0 to enable
					STR R2, [R1] 	   		; and bit 1 to stall on debug
							
							
					POP{R0,R1,R2,LR}
					BX		LR
					
					
;************************************************************************
;I am dricing motor with this ISR. I added this part to startup.s also.  

					EXPORT 	My_Timer0A_Handler				
						
My_Timer0A_Handler	
					PUSH  	{R0-R3,LR}	
					
					LDR		R2,=HANDLER_CHECK		;checks if it is in breaking mode
					LDRB	R3,[R2]					;if it is, load 0x00 and stop motor 
					CMP		R3,#1					;then branch to end line
					BNE		cont					;if not, continue
					LDR		R3,=0x00
					STR		R3,[R1]
					B		fin
					
cont				LDR		R1, =PD_OUT				;read PD port
					LDR		R0,[R1]					;shift left and store it back
					LSL		R0,#1					;if it becomes 0x10
					CMP		R0,#0x10				;then change it with 0x01
					BNE		slide					;so it will 0001->0010->0100->1000->0001 ...
					LDR		R0,=0x01
					STR		R0,[R1]
					B		done
slide				STR		R0,[R1]
					B		done

;THIS PART IS FOR BONUS. I AM CHANGING MOTOR SPEED. FIRSTLY I DISABLED THE TIMER CHANGE TAILR VALUE
;AFTER CHANGING, I STARTED THE TIMER AGAIN. I CHANGED THE TAILR DEPENDING ON THE MEASURED DIFFERENCE
;WHICH IS AVAILABLE AT MEMORY LOCATION MEAS_UPD AND THRESH_UPD
done				
					LDR 	R1, =TIMER0_CTL       ; disable timer during setup 
					LDR 	R2, [R1]
					BIC 	R2, R2, #0x01
					STR 	R2, [R1]
					
					LDR		R1,=MEAS_UPD		
					LDRB	R0,[R1]
					LDR		R1,=THRESH_UPD
					LDRB	R2,[R1]
					SUB		R0,R0,R2			;i read and take difference of measured and thresh values
					ADD		R0,#10				;of distance. then i add 10 for safely avoiding having 
					MUL		R0,R0,R0			;negative values.Then take 4th power of this value.
					MUL		R0,R0,R0			;i chosed this 4th power because i SPLIT THE VALUES. IT GIVES
					LDR		R1,=0xF000000		;ME MORE TRACTABLE SPEED. IT CAN BE SEEN OBVIOSLY BUT NOT SO SHARP
					UDIV	R2,R1,R0			;Then i devide a high number with this value for basically
					LDR 	R1, =TIMER0_TAILR  	;having the reverse relationship between speed and timer value
					STR 	R2, [R1]
				
					LDR 	R1, =TIMER0_CTL
					LDR 	R2, [R1]
					ORR 	R2, R2,#0x01  		; set bit0 to enable
					STR 	R2, [R1] 	   		; and bit 1 to stall on debug
					
fin					LDR 	R1, =TIMER0_ICR
					MOV 	R0,#0x01			; clear interrupt
					STR 	R0,[R1]
					
					POP  	{R0-R3,LR}
					BX 	 	 LR 
					ENDP
;**********************************************************