;STORED MEASURED VALUES AND THRESHOLD VALUE. SINCE I AM USING LOTS OF SUBROUTINES,  
;I STORE IT IN MEMORY FIRST, THEN IF REQUIRED, I USE THIS VALUES BY SIMPLY READING 	
;IN OTHER SUBROUTINES
THRESH_UPD				EQU	0x20000400
MEAS_UPD				EQU	0x20000500	
THRESH_VAL				EQU	0x20000600
MEAS_VAL				EQU	0x20000700	
	
HANDLER_CHECK			EQU	0x20000800	;motor handler will stop according to this location value
			
;some lcd display 5 byte representations			
			AREA		sdata,CODE,READONLY
			THUMB
brake_disp	DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x00, 0x41, 0x22, 0x14, 0x08 ;>
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;
			DCB	  0x7f, 0x49, 0x49, 0x49, 0x36 ;B
			DCB	  0x7f, 0x09, 0x19, 0x29, 0x46 ;R
			DCB	  0x7e, 0x11, 0x11, 0x11, 0x7e ;A
			DCB	  0x7f, 0x08, 0x14, 0x22, 0x41 ;K
			DCB	  0x7f, 0x49, 0x49, 0x49, 0x41 ;E
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;
			DCB	  0x3e, 0x41, 0x41, 0x41, 0x3e ;O
			DCB	  0x7f, 0x04, 0x08, 0x10, 0x7f ;N
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;

ret_norm	DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x00, 0x41, 0x22, 0x14, 0x08 ;>
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;
			DCB	  0x7f, 0x04, 0x08, 0x10, 0x7f ;N
			DCB	  0x38, 0x44, 0x44, 0x44, 0x38 ;o
			DCB	  0x7c, 0x08, 0x04, 0x04, 0x08 ;r
			DCB	  0x7c, 0x04, 0x18, 0x04, 0x78 ;m
			DCB	  0x20, 0x54, 0x54, 0x54, 0x78 ;a
			DCB	  0x00, 0x41, 0x7f, 0x40, 0x00 ;l
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;
			DCB	  0x3e, 0x41, 0x41, 0x41, 0x3e ;O
			DCB	  0x7c, 0x14, 0x14, 0x14, 0x08 ;p
			DCB	  0x00, 0x60, 0x60, 0x00, 0x00 ;.

disp_init	DCB	  0x3e, 0x41, 0x41, 0x41, 0x22 ;C
			DCB	  0x7e, 0x11, 0x11, 0x11, 0x7e ;A
			DCB	  0x7f, 0x09, 0x19, 0x29, 0x46 ;R
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			
			AREA		subroutines,CODE,READONLY
			THUMB
			EXTERN		set_cursor
			EXTERN		set_cursor2
			EXTERN		SW2_detect
			EXTERN		modify_sim
			EXTERN		delayer
			EXPORT		comparison
			EXPORT		normal_mode

comparison
			PUSH{R0-R5,LR}
			
			;early as i mentioned i stored thre. meas. values in reverse order
			;i change it and store it at thre_val,meas_val locations in correct order
			LDR			R5,=THRESH_UPD
			LDR			R3,=THRESH_VAL
			LDRB		R1,[R5,#2]
			STRB		R1,[R3]
			LDRB		R1,[R5,#1]
			STRB		R1,[R3,#1]
			LDRB		R1,[R5]
			STRB		R1,[R3,#2]
			
			LDR			R5,=MEAS_UPD
			LDR			R3,=MEAS_VAL
			LDRB		R1,[R5,#2]
			STRB		R1,[R3]
			LDRB		R1,[R5,#1]
			STRB		R1,[R3,#1]
			LDRB		R1,[R5]
			STRB		R1,[R3,#2]
			
			
			LDR			R5,=MEAS_VAL
			LDR			R0,[R5]
			LDR			R5,=THRESH_VAL
			LDR			R1,[R5]
			
			CMP			R0,R1					;compares meas and thre values
			BPL			cont
			BL			normal_mode				;if not,display normal mode for last time and
			LDR			R2,=HANDLER_CHECK		;set handler check memory location value to 1
			MOV			R0,#1					;it specifies that motor should stop. I will read this value in 
			STRB		R0,[R2]					;timer0a ISR
			LDR			R5,=brake_disp			;then display brake mode screen
			BL			set_cursor
			BL			delayer
			BL			SW2_detect				;go to sw2 detect subrouine. IT STAYS IN THERE UNTIL SW2 IS PRESSED
			B			ret						;if sw2 is pressed end this subroutine
			
			
cont		LDR			R2,=HANDLER_CHECK		;if meas>thre goes to normal mode subroutine,displays normal mode screen
			MOV			R0,#0					;and set handler check to 0. which implies motor should keep turning
			STRB		R0,[R2]
			BL			normal_mode	

ret			POP{R0-R5,LR}
			BX	LR
			
;******************************************************
normal_mode
			PUSH{R5,LR}
			LDR			R5,=ret_norm			;load r5 return_normal screen 
			BL			set_cursor				;display it
			BL 			delayer
			BL			delayer
			LDR			R5,=disp_init			;load r5 car-obstacle simulation screen
			BL			set_cursor2				;display it
			BL			delayer
			BL			delayer
			BL			modify_sim				;modify this simulation screen (for example: CAR-X----||||)
			BL			delayer
			BL			delayer
			POP{R5,LR}
			BX	LR