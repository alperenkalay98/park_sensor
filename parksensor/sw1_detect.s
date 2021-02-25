GPIO_PORTF_DATA		EQU  0x40025000
GPIO_PORTF_RIS		EQU	 0x40025414
GPIO_PORTF_ICR      EQU  0x4002541C
ADC0_RIS 			EQU 0x40038004
ADC0_SSFIFO3 		EQU 0x400380A8
ADC0_PSSI 			EQU 0x40038028
ADC0_ISC 			EQU 0x4003800C	

			AREA	sdata,CODE,READONLY
			THUMB
;this is the screen that i want to display on nokia screen in thre.adj. mode.
;5 bytes is enough for char to display, so divided whole screen to 5 byte parts
thres_scr	DCB	  0x00, 0x00, 0x00, 0x00, 0x00
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00
			DCB	  0x7f, 0x02, 0x0c, 0x02, 0x7f ;M
			DCB	  0x38, 0x54, 0x54, 0x54, 0x18 ;e
			DCB	  0x20, 0x54, 0x54, 0x54, 0x78 ;a
			DCB	  0x48, 0x54, 0x54, 0x54, 0x20 ;s
			DCB	  0x00, 0x36, 0x36, 0x00, 0x00 ;:
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x7c, 0x04, 0x18, 0x04, 0x78 ;m
			DCB	  0x7c, 0x04, 0x18, 0x04, 0x78 ;m 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00	
			DCB	  0x01, 0x01, 0x7f, 0x01, 0x01 ;T
			DCB	  0x7f, 0x08, 0x04, 0x04, 0x78 ;h
			DCB	  0x7c, 0x08, 0x04, 0x04, 0x08 ;r
			DCB	  0x38, 0x54, 0x54, 0x54, 0x18 ;e
			DCB	  0x00, 0x36, 0x36, 0x00, 0x00 ;:
			DCB	  0x40, 0x40, 0x40, 0x40, 0x40 ;_
			DCB	  0x40, 0x40, 0x40, 0x40, 0x40 ;_
			DCB	  0x40, 0x40, 0x40, 0x40, 0x40 ;_
			DCB	  0x7c, 0x04, 0x18, 0x04, 0x78 ;m
			DCB	  0x7c, 0x04, 0x18, 0x04, 0x78 ;m
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00
			DCB	  0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00
			DCB	  0x00, 0x00, 0x00, 0x00
			DCB	  0x08, 0x08, 0x08, 0x08, 0x08 ;-
			DCB	  0x00, 0x41, 0x22, 0x14, 0x08 ;>
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;
			DCB	  0x01, 0x01, 0x7f, 0x01, 0x01 ;T 
			DCB	  0x7f, 0x08, 0x04, 0x04, 0x78 ;h 
			DCB	  0x7c, 0x08, 0x04, 0x04, 0x08 ;r 
			DCB	  0x38, 0x54, 0x54, 0x54, 0x18 ;e 
			DCB	  0x00, 0x60, 0x60, 0x00, 0x00 ;. 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 ;
			DCB	  0x7e, 0x11, 0x11, 0x11, 0x7e ;A
			DCB	  0x38, 0x44, 0x44, 0x48, 0x7f ;d 
			DCB	  0x20, 0x40, 0x44, 0x3d, 0x00 ;j 
			DCB	  0x00, 0x60, 0x60, 0x00, 0x00 ;.
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00, 0x00 
			DCB	  0x00, 0x00, 0x00, 0x00
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;*
			DCB	  0x14, 0x08, 0x3e, 0x08, 0x14 ;* 
			DCB	  0x00, 0x00, 0x00, 0x00
			

			AREA		subroutines,CODE,READONLY
			THUMB
			EXTERN		send48x48
			EXTERN		thre_chng
			EXTERN		new_conv
			EXTERN		delayer
			EXPORT		SW1_detect

SW1_detect
			PUSH{R0-R4,LR}
			
			LDR			R1,=GPIO_PORTF_RIS		;reading interrupt flag, if no int occurs go to end line
			LDR			R0,[R1]
			ANDS		R0,R0,#0x10
			BEQ			return_noth
		
			LDR			R1,=GPIO_PORTF_ICR		;clear int flag
			MOV			R0,#0x10
			STR			R0,[R1]
			
			LDR			R5,=thres_scr			;load r5 to uppermentioned screen
			BL			send48x48				;display it with cursors
			
			
loop		LDR 		R1,=ADC0_PSSI
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x08
			STR 		R0,[R1] 				;initiated sampling
			
check		LDR 		R1,=ADC0_RIS
			LDR 		R0,[R1]
			ANDS		R0,#0x08
			BEQ 		check 					;check interrupt status
			
			LDR 		R1,=ADC0_SSFIFO3
			LDR 		R3,[R1] 				;if data can be read,store it in R3
			
			LDR 		R1,=ADC0_ISC
			MOV 		R0,#8
			STR 		R0,[R1] 				;clear interrupt
			
			MOV 		R0,#0x3E7 				
			MUL 		R3,R3,R0 				;multiply pot. value with 999
			MOV 		R0,#0x0FFF
			UDIV		R3,R3,R0				;then divide it to 4095(because 12 bit precision)
												;so i basically defined my 0-999 range
inner_loop	LDR 		R1,=ADC0_PSSI
			LDR 		R0,[R1]
			ORR 		R0,R0,#0x08
			STR 		R0,[R1] 				;initiated sampling
			
check2		LDR 		R1,=ADC0_RIS
			LDR 		R0,[R1]
			ANDS		R0,#0x08
			BEQ 	    check2 					;check interrupt status
			
			LDR 		R1,=ADC0_SSFIFO3
			LDR 		R4,[R1] 				;if data can be read,store it in R4
			
			LDR 		R1,=ADC0_ISC
			MOV 		R0,#8
			STR 		R0,[R1] 				;clear interrupt
				
			LDR			R1,=GPIO_PORTF_RIS		;if sw1 button is pressed again,go to end line
			LDR			R0,[R1]					;quit from loop
			ANDS		R0,R0,#0x10
			BEQ			cont	
			BL			delayer					;for debouncing i delayed and read it again
			LDR			R0,[R1]					;if it is same again, quit
			ANDS		R0,R0,#0x10				
			BNE			return
			
cont		MOV 		R0,#0x3E7
			MUL 		R4,R4,R0
			MOV 		R0,#0x0FFF
			UDIV		R4,R4,R0
			SUB 		R0,R3,R4
			SUBS		R0,#20
			BPL 		go 						
		
			SUB 		R0,R4,R3
			SUBS 		R0,#20
			BPL 		go 						;controls if difference between new and old values is larger than 20
												;i did this to display a trackable values on screen.
												;otherwise numbers would flow so fast
			
			
			B 			inner_loop 				;if both are not satisfied,search again
	


go			BL			new_conv				;converts threshold value to ascii chars and stores it at loc. 0x20000400
			BL			thre_chng				;changes the threshold digits in every iteration
			
			B 			loop
			


return		LDR			R1,=GPIO_PORTF_ICR		;comes here if sw1 is pressed again.
			MOV			R0,#0x10				;clear interrupt and return from this subroutine
			STR			R0,[R1]

			
return_noth	
			POP{R0-R4,LR}
			BX	LR