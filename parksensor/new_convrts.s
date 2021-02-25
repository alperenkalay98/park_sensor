;BELOW CODES ARE NEARLY SAME. IT IS NEARLY SAME AS CONVRT SUBROUTINE
;I CHANGED IT A BIT. IT STORES THE CONVERTED ASCII CHARS TO REQUIRED MEMORY LOCATIONS
;IT IS THRESH_UPD(0x20000400) FOR NEW_CONV, MEAS_UPD(0x20000500) FOR NEW_CONV2
			AREA			routines,CODE,READONLY
			THUMB
			EXPORT 			new_conv
			EXPORT			new_conv2
				
new_conv	PROC
			PUSH			{R0-R4,LR}			
			LDR				R5,=0x20000400		;ADRESS OF MEAS_UPD

			
			mov				r0,#10			
			udiv			r1,r4,r0
			mul				r1,r1,r0
			sub				r1,r4,r1
			add				r1,r1,'0'
			push			{r1}				;push last digit
			
			mov				r0,#100
			udiv			r1,r4,r0
			mul				r1,r1,r0
			sub				r1,r4,r1
			mov				r0,#10
			udiv			r1,r1,r0
			add				r1,r1,'0'
			push			{r1}			    ;push middle digit
			
			
			mov				r0,#100
			udiv			r1,r4,r0
			add				r1,r1,'0'
			push			{r1}				;push first digit 
			
			LDR				R1,=0x20000400		;ADRESS OF THRESH_UPD
			POP				{R2}
			STRB			R2,[R1],#1
			POP				{R2}
			STRB			R2,[R1],#1
			POP				{R2}
			STRB			R2,[R1]
			


			POP			{R0-R4,LR}
			BX 				LR
			
				
new_conv2	PROC
			PUSH			{R0-R4,LR}			
			LDR				R5,=0x20000500		;ADRESS OF MEAS_UPD

			
			mov				r0,#10			
			udiv			r1,r4,r0
			mul				r1,r1,r0
			sub				r1,r4,r1
			add				r1,r1,#'0'
			push			{r1}				;push last digit
			
			mov				r0,#100
			udiv			r1,r4,r0
			mul				r1,r1,r0
			sub				r1,r4,r1
			mov				r0,#10
			udiv			r1,r1,r0
			add				r1,r1,#'0'
			push			{r1}			    ;push mid
			
			
			mov				r0,#100
			udiv			r1,r4,r0
			add				r1,r1,#'0'
			push			{r1}				;push first
			
			
			LDR				R1,=0x20000500		;ADRESS OF MEAS_UPD
			POP				{R2}
			STRB			R2,[R1],#1
			POP				{R2}
			STRB			R2,[R1],#1
			POP				{R2}
			STRB			R2,[R1]
			


			POP			{R0-R4,LR}
			BX 				LR