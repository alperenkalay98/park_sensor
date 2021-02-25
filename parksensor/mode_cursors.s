GPIO_PORTA_DATA			EQU	0x400043FC
SSI0_SR					EQU	0x4000800C
THRESH_UPD				EQU	0x20000400
MEAS_UPD				EQU	0x20000500	
										
				AREA		subroutines,CODE,READONLY
				THUMB
				EXTERN		init_screen
				EXTERN		thre_chng
				EXTERN		byte_send
				EXTERN		delayer
				EXTERN		modify_sim
				EXPORT		set_cursor
				EXPORT		set_cursor2

;setting cursors for mode and progress bar
;cursor1 is for mode 
;cursor2 for progress bar

;ONLY DIFFERENCE IN Y AXIS
;BECAUSE MODE WILL BE DISPLAYED ON BANK 3 IN LCD
;PROGRESS BAR WILL BE DISPLAYED ON BANK 5

set_cursor

		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				; H=0
		BL		byte_send	
		MOV		R5,#0x43				; set Y address to bank 3
		BL		byte_send
		MOV		R5,#0x8F				; set X address to 8F
		BL		byte_send	
wait11ImgReady		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wait11ImgReady
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#65					;65 bytes send 
		MOV		R1,R5					
send11NxtByteNokia		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		send11NxtByteNokia		
		POP		{R0-R4,LR}
		BX		LR

set_cursor2

		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank5 (not 3)
		BL		byte_send
		MOV		R5,#0x8F				; set X address to 8F
		BL		byte_send	
wait118ImgReady		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wait118ImgReady
		LDR		R1,=GPIO_PORTA_DATA		; ready: set PA6 high for Data
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#65					;65 bytes send
		MOV		R1,R5					
send181NxtByteNokia		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		send181NxtByteNokia		
		POP		{R0-R4,LR}
		BX		LR
