GPIO_PORTA_DATA			EQU	0x400043FC
SSI0_SR					EQU	0x4000800C
THRESH_UPD				EQU	0x20000400
MEAS_UPD				EQU	0x20000500


;required 5 bytes to display mentioned numbers
			AREA	sdata,CODE,READONLY
			THUMB
num0		DCB		0x3e, 0x51, 0x49, 0x45, 0x3e
num1		DCB		0x00, 0x42, 0x7f, 0x40, 0x00
num2		DCB		0x42, 0x61, 0x51, 0x49, 0x46
num3		DCB		0x21, 0x41, 0x45, 0x4b, 0x31
num4		DCB		0x18, 0x14, 0x12, 0x7f, 0x10
num5		DCB		0x27, 0x45, 0x45, 0x45, 0x39
num6		DCB		0x3c, 0x4a, 0x49, 0x49, 0x30
num7		DCB		0x01, 0x71, 0x09, 0x05, 0x03
num8		DCB		0x36, 0x49, 0x49, 0x49, 0x36
num9		DCB		0x06, 0x49, 0x49, 0x29, 0x1e 					
					
					
			AREA		subroutines,CODE,READONLY
			THUMB
			EXTERN	m_digit1_chng		;changes digit 1 of meas. value
			EXTERN	m_digit2_chng		;changes digit 2 of meas. value
			EXTERN	m_digit3_chng		;changes digit 3 of meas. value
			EXTERN	t_digit1_chng		;changes digit 1 of thre. value
			EXTERN	t_digit2_chng		;changes digit 2 of thre. value
			EXTERN	t_digit3_chng		;changes digit 3 of thre. value
			EXPORT	measur_chng
			EXPORT	thre_chng
				
measur_chng
		PUSH{R0,R5,LR}
		
		LDR			R5,=MEAS_UPD			;reads the saved measurement value from memory loc. 0x20000500
		LDRB		R0,[R5,#2]				;as i mentioned i stored it in reverse order, so i am reading
		SUBS		R0,#'0'					;according to this
		CMP			R0,#0
		BEQ			mchng1_to_zero			;checking for number match
		CMP			R0,#1
		BEQ			mchng1_to_one
		CMP			R0,#2
		BEQ			mchng1_to_two
		CMP			R0,#3
		BEQ			mchng1_to_three
		CMP			R0,#4
		BEQ			mchng1_to_four
		CMP			R0,#5
		BEQ			mchng1_to_five
		CMP			R0,#6
		BEQ			mchng1_to_six
		CMP			R0,#7
		BEQ			mchng1_to_seven
		CMP			R0,#8
		BEQ			mchng1_to_eight
		CMP			R0,#9
		BEQ			mchng1_to_nine
												;load r5 to matched 5byte number representation
mchng1_to_zero			
		LDR			R5,=num0
		B			mcont1
mchng1_to_one
		LDR			R5,=num1
		B			mcont1
mchng1_to_two
		LDR			R5,=num2
		B			mcont1
mchng1_to_three
		LDR			R5,=num3
		B			mcont1
mchng1_to_four
		LDR			R5,=num4
		B			mcont1
mchng1_to_five
		LDR			R5,=num5
		B			mcont1
mchng1_to_six
		LDR			R5,=num6
		B			mcont1
mchng1_to_seven
		LDR			R5,=num7
		B			mcont1
mchng1_to_eight
		LDR			R5,=num8
		B			mcont1
mchng1_to_nine
		LDR			R5,=num9
		B			mcont1

mcont1	
		BL			m_digit1_chng		;change number with m_digit1 cursor 
		ldr			r4,=0x10000
delay1m	nop
		subs		r4,r4,#1
		bne			delay1m
										;same procedure for digit 2 and 3
		LDR			R5,=MEAS_UPD
		LDRB		R0,[R5,#1]
		SUBS		R0,#'0'
		CMP			R0,#0
		BEQ			mchng2_to_zero
		CMP			R0,#1
		BEQ			mchng2_to_one
		CMP			R0,#2
		BEQ			mchng2_to_two
		CMP			R0,#3
		BEQ			mchng2_to_three
		CMP			R0,#4
		BEQ			mchng2_to_four
		CMP			R0,#5
		BEQ			mchng2_to_five
		CMP			R0,#6
		BEQ			mchng2_to_six
		CMP			R0,#7
		BEQ			mchng2_to_seven
		CMP			R0,#8
		BEQ			mchng2_to_eight
		CMP			R0,#9
		BEQ			mchng2_to_nine

mchng2_to_zero
		LDR			R5,=num0
		B			mcont2
mchng2_to_one
		LDR			R5,=num1
		B			mcont2
mchng2_to_two
		LDR			R5,=num2
		B			mcont2
mchng2_to_three
		LDR			R5,=num3
		B			mcont2
mchng2_to_four
		LDR			R5,=num4
		B			mcont2
mchng2_to_five
		LDR			R5,=num5
		B			mcont2
mchng2_to_six
		LDR			R5,=num6
		B			mcont2
mchng2_to_seven
		LDR			R5,=num7
		B			mcont2
mchng2_to_eight
		LDR			R5,=num8
		B			mcont2
mchng2_to_nine
		LDR			R5,=num9
		B			mcont2

mcont2	
		BL			m_digit2_chng
		ldr			r4,=0x10000
delay2m	nop
		subs		r4,r4,#1
		bne			delay2m
		
										;same again for digit 3
		LDR			R5,=MEAS_UPD
		LDRB		R0,[R5]
		SUBS		R0,#'0'
		CMP			R0,#0
		BEQ			mchng3_to_zero
		CMP			R0,#1
		BEQ			mchng3_to_one
		CMP			R0,#2
		BEQ			mchng3_to_two
		CMP			R0,#3
		BEQ			mchng3_to_three
		CMP			R0,#4
		BEQ			mchng3_to_four
		CMP			R0,#5
		BEQ			mchng3_to_five
		CMP			R0,#6
		BEQ			mchng3_to_six
		CMP			R0,#7
		BEQ			mchng3_to_seven
		CMP			R0,#8
		BEQ			mchng3_to_eight
		CMP			R0,#9
		BEQ			mchng3_to_nine

mchng3_to_zero
		LDR			R5,=num0
		B			mcont3
mchng3_to_one
		LDR			R5,=num1
		B			mcont3
mchng3_to_two
		LDR			R5,=num2
		B			mcont3
mchng3_to_three
		LDR			R5,=num3
		B			mcont3
mchng3_to_four
		LDR			R5,=num4
		B			mcont3
mchng3_to_five
		LDR			R5,=num5
		B			mcont3
mchng3_to_six
		LDR			R5,=num6
		B			mcont3
mchng3_to_seven
		LDR			R5,=num7
		B			mcont3
mchng3_to_eight
		LDR			R5,=num8
		B			mcont3
mchng3_to_nine
		LDR			R5,=num9
		B			mcont3

mcont3	
		BL			m_digit3_chng
		ldr			r4,=0x10000
delaym3	nop
		subs		r4,r4,#1
		bne			delaym3

		POP{R0,R5,LR}
		BX	LR


;****************************************************************************
;NEARLY ALL SAME MECHANISM. IT CHANGES THE DISPLAYED NUMBER BASED ON STORED THRESH_UPD VALUE.
;IT JUST HAVE DIFFERENT CURSORS TO CHANGE NUMBER. (THESE CURSORS HAVE Y VALUE OF BANK1 IN 5510 SCREEN)
thre_chng
		PUSH{R0,R5,LR}
		
		LDR			R5,=THRESH_UPD
		LDRB		R0,[R5,#2]
		SUBS		R0,#'0'
		CMP			R0,#0
		BEQ			chng1_to_zero
		CMP			R0,#1
		BEQ			chng1_to_one
		CMP			R0,#2
		BEQ			chng1_to_two
		CMP			R0,#3
		BEQ			chng1_to_three
		CMP			R0,#4
		BEQ			chng1_to_four
		CMP			R0,#5
		BEQ			chng1_to_five
		CMP			R0,#6
		BEQ			chng1_to_six
		CMP			R0,#7
		BEQ			chng1_to_seven
		CMP			R0,#8
		BEQ			chng1_to_eight
		CMP			R0,#9
		BEQ			chng1_to_nine

chng1_to_zero
		LDR			R5,=num0
		B			cont1
chng1_to_one
		LDR			R5,=num1
		B			cont1
chng1_to_two
		LDR			R5,=num2
		B			cont1
chng1_to_three
		LDR			R5,=num3
		B			cont1
chng1_to_four
		LDR			R5,=num4
		B			cont1
chng1_to_five
		LDR			R5,=num5
		B			cont1
chng1_to_six
		LDR			R5,=num6
		B			cont1
chng1_to_seven
		LDR			R5,=num7
		B			cont1
chng1_to_eight
		LDR			R5,=num8
		B			cont1
chng1_to_nine
		LDR			R5,=num9
		B			cont1

cont1	
		BL			t_digit1_chng
		ldr			r4,=0xaabb
delay11	nop
		subs		r4,r4,#1
		bne			delay11
		
		LDR			R5,=THRESH_UPD
		LDRB		R0,[R5,#1]
		SUBS		R0,#'0'
		CMP			R0,#0
		BEQ			chng2_to_zero
		CMP			R0,#1
		BEQ			chng2_to_one
		CMP			R0,#2
		BEQ			chng2_to_two
		CMP			R0,#3
		BEQ			chng2_to_three
		CMP			R0,#4
		BEQ			chng2_to_four
		CMP			R0,#5
		BEQ			chng2_to_five
		CMP			R0,#6
		BEQ			chng2_to_six
		CMP			R0,#7
		BEQ			chng2_to_seven
		CMP			R0,#8
		BEQ			chng2_to_eight
		CMP			R0,#9
		BEQ			chng2_to_nine

chng2_to_zero
		LDR			R5,=num0
		B			cont2
chng2_to_one
		LDR			R5,=num1
		B			cont2
chng2_to_two
		LDR			R5,=num2
		B			cont2
chng2_to_three
		LDR			R5,=num3
		B			cont2
chng2_to_four
		LDR			R5,=num4
		B			cont2
chng2_to_five
		LDR			R5,=num5
		B			cont2
chng2_to_six
		LDR			R5,=num6
		B			cont2
chng2_to_seven
		LDR			R5,=num7
		B			cont2
chng2_to_eight
		LDR			R5,=num8
		B			cont2
chng2_to_nine
		LDR			R5,=num9
		B			cont2

cont2	
		BL			t_digit2_chng
		ldr			r4,=0xaabb
delay12	nop
		subs		r4,r4,#1
		bne			delay12
		


		LDR			R5,=THRESH_UPD
		LDRB		R0,[R5]
		SUBS		R0,#'0'
		CMP			R0,#0
		BEQ			chng3_to_zero
		CMP			R0,#1
		BEQ			chng3_to_one
		CMP			R0,#2
		BEQ			chng3_to_two
		CMP			R0,#3
		BEQ			chng3_to_three
		CMP			R0,#4
		BEQ			chng3_to_four
		CMP			R0,#5
		BEQ			chng3_to_five
		CMP			R0,#6
		BEQ			chng3_to_six
		CMP			R0,#7
		BEQ			chng3_to_seven
		CMP			R0,#8
		BEQ			chng3_to_eight
		CMP			R0,#9
		BEQ			chng3_to_nine

chng3_to_zero
		LDR			R5,=num0
		B			cont3
chng3_to_one
		LDR			R5,=num1
		B			cont3
chng3_to_two
		LDR			R5,=num2
		B			cont3
chng3_to_three
		LDR			R5,=num3
		B			cont3
chng3_to_four
		LDR			R5,=num4
		B			cont3
chng3_to_five
		LDR			R5,=num5
		B			cont3
chng3_to_six
		LDR			R5,=num6
		B			cont3
chng3_to_seven
		LDR			R5,=num7
		B			cont3
chng3_to_eight
		LDR			R5,=num8
		B			cont3
chng3_to_nine
		LDR			R5,=num9
		B			cont3

cont3	
		BL			t_digit3_chng
		ldr			r4,=0xaabb
delay13	nop
		subs		r4,r4,#1
		bne			delay13

		POP{R0,R5,LR}
		BX	LR