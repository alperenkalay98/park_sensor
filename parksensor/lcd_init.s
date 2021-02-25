;GPIO Registers
GPIO_PORTA_DATA			EQU	0x400043FC	
GPIO_PORTA_IM      		EQU 0x40004010	
GPIO_PORTA_DIR   		EQU 0x40004400	
GPIO_PORTA_AFSEL 		EQU 0x40004420	
GPIO_PORTA_DEN   		EQU 0x4000451C	
GPIO_PORTA_AMSEL 		EQU 0x40004528	
GPIO_PORTA_PCTL  		EQU 0x4000452C	

GPIO_PORTB_DATA			EQU	0x400053FC	
GPIO_PORTB_IM      		EQU 0x40005010	
GPIO_PORTB_DIR   		EQU 0x40005400	
GPIO_PORTB_AFSEL 		EQU 0x40005420	
GPIO_PORTB_DEN   		EQU 0x4000551C	
GPIO_PORTB_AMSEL 		EQU 0x40005528	
GPIO_PORTB_PCTL  		EQU 0x4000552C	
	
;SSI Registers
SSI0_CR0				EQU	0x40008000
SSI0_CR1				EQU	0x40008004
SSI0_DR					EQU	0x40008008
SSI0_SR					EQU	0x4000800C
SSI0_CPSR				EQU	0x40008010
SSI0_CC					EQU	0x40008FC8
	
;System Registers
SYSCTL_RCGCGPIO  		EQU 0x400FE608	
SYSCTL_RCGCSSI			EQU	0x400FE61C	
	
	    AREA    subroutines, CODE, READONLY
        THUMB

		EXPORT	lcd_init				;initializes lcd 
		EXPORT	byte_send				;to send 1 byte
		EXPORT	send48x48				;display an image for full screen
		EXPORT	clear_screen			;clearing screeen
		EXPORT	m_digit1_chng			;cursor for digit1 of measurement
		EXPORT	m_digit2_chng			;cursor for digit2 of measurement
		EXPORT	m_digit3_chng			;cursor for digit3 of measurement
		EXPORT	t_digit1_chng			;cursor for digit1 of threshold value
		EXPORT	t_digit2_chng			;cursor for digit2 of threshold value
		EXPORT	t_digit3_chng			;cursor for digit3 of threshold value
					
		
; Initializes 5510 display
lcd_init
		PUSH	{LR}

		LDR 	R1, =SYSCTL_RCGCGPIO	; start GPIO clock
		LDR 	R0, [R1]                   
		ORR 	R0, #0x01				
		STR 	R0, [R1]                   
		NOP								
		NOP
		NOP								
		LDR		R1,=GPIO_PORTA_DIR		; make PA2,3,5,6,7 output	PA4 input
		MOV 	R0, #0xEC				
		STR		R0,[R1]
		LDR		R1,=GPIO_PORTA_AFSEL	; PA2,3,4,5 has alt funcs
		MOV 	R0, #0x3C				
		STR		R0,[R1]
		LDR		R1,=GPIO_PORTA_DEN		; digital PA2,3,4,5,6,7
		MOV 	R0, #0xFC				
		STR		R0,[R1]					
		LDR		R1,=GPIO_PORTA_PCTL 	; PA2,3,4,5 as SSI
		LDR 	R0, =0x00222200					
		STR		R0,[R1]
		LDR		R1,=GPIO_PORTA_AMSEL	; disable analog 
		LDR		R0, [R1]
		BIC 	R0, #0xFC				
		STR		R0,[R1]
		

		LDR 	R1,=SYSCTL_RCGCSSI		; start SSI clock
		LDR 	R0,[R1]                   
		ORR 	R0, #0x01				; set bit 0 for SSI0
		STR 	R0,[R1]                
		
		MOV		R0,#0x0F
delssi								
		SUBS	R0,R0,#0x01
		BNE		delssi

		LDR		R1,=SSI0_CR1			; disable SSI during setup and also set to Master
		MOV		R0, #0x00				
		STR		R0,[R1]
		
; br piosc=16MHz,baud=2MHz,CPSDVSR=4,SCR=1
		LDR		R1,=SSI0_CC				; use PIOSC (16MHz)		
		MOV		R0,#0x05				; set bits 3:0 of the SSICC to 0x5 
		STR		R0,[R1]
		LDR		R1,=SSI0_CR0			
		LDR		R0,[R1]
		ORR		R0, #0x0100				
		STR		R0,[R1]
		LDR		R1,=SSI0_CPSR			; prescale 0x04
		MOV 	R0, #0x04				
		STR		R0,[R1]
		LDR		R1,=SSI0_CR0			; clear SPH,SPO
		LDR		R0,[R1]					; Freescale
		BIC		R0, #0x3F				; clear bits 5:4 	
		ORR		R0, #0x07				; 8-bit data 
		STR		R0,[R1]
		LDR		R1,=SSI0_CR1			; enable SSI
		LDR		R0,[R1]
		ORR 	R0, #0x02				
		STR		R0,[R1]
	

		LDR		R1,=GPIO_PORTA_DATA	
		LDR		R0, [R1]
		BIC 	R0, #0x80					; clear reset(PA7) 	
		STR		R0,[R1]
	
		MOV		R0,#10
delres		
		SUBS	R0,R0,#1
		BNE		delres
		
		LDR		R1,=GPIO_PORTA_DATA		 
		ORR 	R0, #0x80				; set reset(PA7)
		STR		R0,[R1]					
		

		LDR		R1,=GPIO_PORTA_DATA		; set PA6 low for Command
		LDR		R0,[R1]
		BIC 	R0, #0x40				
		STR		R0,[R1]
		
;PD=0 ,	V=0 , H=1
		MOV		R5,#0x21
		BL		byte_send	
;contrast
		MOV		R5,#0xB8
		BL		byte_send
;temp coef
		MOV		R5,#0x04
		BL		byte_send
;bias 
		MOV		R5,#0x14
		BL		byte_send
;change H=0
		MOV		R5,#0x20
		BL		byte_send
;control normal
		MOV		R5,#0x0C
		BL		byte_send
; clear screen
		BL		clear_screen
		
lp		
		LDR		R1,=SSI0_SR				; SSI wait
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		lp
		
		POP{LR}
		BX		LR
	


byte_send
		PUSH	{R0,R1}
lp1									;waits ssi0_sr and store r5 value 
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x02
		BEQ		lp1
		LDR		R1,=SSI0_DR
		STRB	R5,[R1]
		POP		{R0,R1}
		BX		LR


;Sends full image to lcd screen. take img address, set H=0, X & Y adress to 0,0.
;When it is ready, load 504 byte image one by one with branching function above
send48x48		
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x40				
		BL		byte_send
		MOV		R5,#0x80				
		BL		byte_send	
lp2		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		lp2
		LDR		R1,=GPIO_PORTA_DATA		;PA6 high for Data
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#504				
		MOV		R1,R5					
onebyone		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		onebyone		
		POP		{R0-R4,LR}
		BX		LR


; same mechanism with above function but it is all zeros to send
clear_screen
		PUSH	{R0-R5,LR}
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x40				
		BL		byte_send
		MOV		R5,#0x80				
		BL		byte_send	
lp3		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		lp3
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		MOV		R0,#504					
		MOV		R5,#0x00				
lp4		
		BL		byte_send
		SUBS	R0,#1
		BNE		lp4
lpp		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		lpp
		POP		{R0-R5,LR}
		BX		LR


;Nearly same with upper funcs, cursor locations are different
m_digit1_chng
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x40				 
		BL		byte_send
		MOV		R5,#0xB2				; X address is different
		BL		byte_send	
lp11		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		lp11
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5					;5 bytes for one character
		MOV		R1,R5					
wt		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		wt		
		POP		{R0-R4,LR}
		BX		LR
		
		
;Nearly same with upper funcs, cursor locations are different		
m_digit2_chng
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x40				
		BL		byte_send
		MOV		R5,#0xAD				; X address is different
		BL		byte_send	
wt1		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt1
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5				; 5 bytes for one char
		MOV		R1,R5					
del12		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		del12	
		POP		{R0-R4,LR}
		BX		LR		
		
		
;Nearly same with upper funcs, cursor locations are different		
m_digit3_chng
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x40				
		BL		byte_send
		MOV		R5,#0xA8				; X address is different
		BL		byte_send	
wt33		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt33
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5				; 5 bytes for one char
		MOV		R1,R5					
lpss		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		lpss		
		POP		{R0-R4,LR}
		BX		LR		
	
	
;Nearly same with upper funcs, cursor locations are different
t_digit1_chng
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x41				
		BL		byte_send
		MOV		R5,#0xB2				; X address is different
		BL		byte_send	
delay33
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		delay33
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5				; 5 bytes for one char
		MOV		R1,R5					
delay44		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		delay44	
		POP		{R0-R4,LR}
		BX		LR
		
		
;Nearly same with upper funcs, cursor locations are different		
t_digit2_chng
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x41				
		BL		byte_send
		MOV		R5,#0xAD				; X address is different
		BL		byte_send	
delays11	
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		delays11
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5				; 5 bytes for one char
		MOV		R1,R5					
delayk	
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		delayk		
		POP		{R0-R4,LR}
		BX		LR		
		
		
;Nearly same with upper funcs, cursor locations are different
t_digit3_chng
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				
		BL		byte_send	
		MOV		R5,#0x41				
		BL		byte_send
		MOV		R5,#0xA8				; X address is different
		BL		byte_send	
delaym	
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		delaym
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5				; 5 bytes for one char
		MOV		R1,R5					
delayw		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		delayw		
		POP		{R0-R4,LR}
		BX		LR