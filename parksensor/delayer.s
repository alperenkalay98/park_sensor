			AREA		subroutines,CODE,READONLY
			THUMB
			EXPORT		delayer
delayer
			PUSH{R0,LR}
			
			LDR		R0,=0x640
loop		NOP
			SUBS	R0,R0,#1
			BNE		loop
			
			POP{R0,LR}
			BX	LR