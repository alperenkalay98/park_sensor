;ADC registers
RCGCADC			EQU		0x400FE638
ADC0_ACTSS		EQU		0x40038000
ADC0_RIS		EQU		0x40038004
ADC0_IM			EQU		0x40038008
ADC0_EMUX		EQU		0x40038014
ADC0_PSSI		EQU		0x40038028
ADC0_SSMUX3		EQU		0x400380A0
ADC0_SSCTL3		EQU		0x400380A4
ADC0_SSFIFO3	EQU		0x400380A8
ADC0_PC			EQU		0x40038FC4
;GPIO registers	
SYSCTL_RCGCGPIO		EQU		0x400FE608
GPIO_PORTE_DIR		EQU		0x40024400
GPIO_PORTE_AFSEL	EQU		0x40024420
GPIO_PORTE_DEN		EQU		0x4002451C
GPIO_PORTE_AMSEL	EQU		0x40024528
GPIO_PORTE_PCTL		EQU		0x4002452C
	
				
			AREA	routines,CODE,READONLY,ALIGN=2
			THUMB
				
				
			EXPORT	adc_init
adc_init	PROC
			PUSH{R0,R1,LR}
			
			LDR		R1,=RCGCADC			
			LDR		R0,[R1]
			ORR		R0,R0,#0x01
			STR		R0,[R1]				;ADC clock on
			NOP
			NOP
			NOP
			
			LDR		R1,=SYSCTL_RCGCGPIO
			LDR		R0,[R1]
			ORR		R0,R0,#0x10
			STR		R0,[R1]				;GPIO clock on
			NOP
			NOP
			NOP
			
			LDR		R1,=GPIO_PORTE_DIR		
			LDR		R0,[R1]
			BIC		R0,R0,#0x08	
			STR		R0,[R1]					;E3input
			
			LDR		R1,=GPIO_PORTE_AFSEL
			LDR		R0,[R1]
			ORR		R0,R0,#0x08
			STR		R0,[R1]					;alt func enable
											;ADC0 in automatically selected 
			LDR		R1,=GPIO_PORTE_DEN
			LDR		R0,[R1]
			BIC		R0,R0,#0x08
			STR		R0,[R1]					;disable digital on E3
			
			LDR		R1,=GPIO_PORTE_AMSEL
			LDR		R0,[R1]
			ORR		R0,R0,#0x08
			STR		R0,[R1]					;enable analog on E3
			
			LDR		R1,=ADC0_ACTSS
			LDR		R0,[R1]
			BIC		R0,R0,#0x08
			STR		R0,[R1]					;disable seq3
			
			LDR		R1,=ADC0_EMUX
			LDR		R0,[R1]
			BIC		R0,R0,#0xF000
			STR		R0,[R1]					;software trigger
			
			LDR		R1,=ADC0_SSMUX3
			LDR		R0,[R1]
			BIC		R0,R0,#0x000F
			STR		R0,[R1]					;select AIN0
			
			LDR		R1,=ADC0_SSCTL3
			LDR		R0,[R1]
			ORR		R0,R0,#0x06
			STR		R0,[R1]					;set IEN and END0 to 1
			
			LDR		R1,=ADC0_PC
			LDR		R0,[R1]
			ORR		R0,R0,#0x01
			STR		R0,[R1]					;125k sps 
			
			LDR		R1,=ADC0_ACTSS
			LDR		R0,[R1]
			ORR 	R0,R0,#0x08
			STR		R0,[R1]					;enable seq3
			
			POP{R0,R1,LR}
			BX	LR
			ENDP