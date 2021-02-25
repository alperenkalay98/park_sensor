GPIO_PORTA_DATA		EQU	0x400043FC
SSI0_SR				EQU	0x4000800C
	
	
;STORED MEASURED VALUES AND THRESHOLD VALUE. SINCE I AM USING LOTS OF SUBROUTINES,  
;I STORE IT IN MEMORY FIRST, THEN IF REQUIRED, I USE THIS VALUES BY SIMPLY READING 	
;IN OTHER SUBROUTINES
THRESH_UPD			EQU	0x20000400
MEAS_UPD			EQU	0x20000500		
THRESH_VAL			EQU	0x20000600
MEAS_VAL			EQU	0x20000700	


;FOR SELECTING X AXIS ADDRESS TO PLACE 'X' CHARACTER REPRESENTING THRESHOLD VALUE
btw0and99			EQU 0x9E
btw100and199		EQU 0xA3
btw200and299		EQU 0xA8
btw300and399		EQU 0xAD
btw400and499		EQU 0xB2
btw500and599		EQU 0xB7
btw600and699		EQU 0xBC
btw700and799		EQU 0xC1
btw800and899		EQU 0xC6
btw900and999		EQU 0xCB
	
					AREA		sdata,CODE,READONLY
					THUMB

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
					
obs			DCB	  0x00, 0x00, 0x7f, 0x00, 0x00 ;|

thr			DCB	  0x63, 0x14, 0x08, 0x14, 0x63 ;X
			
			
					AREA		subroutines,CODE,READONLY
					THUMB
					EXTERN		byte_send
					EXTERN		set_cursor2
					EXPORT		c0and999
					EXPORT		c100and999
					EXPORT		c200and999	
					EXPORT		c300and999		
					EXPORT		c400and999	
					EXPORT		c500and999	
					EXPORT		c600and999	
					EXPORT		c700and999	
					EXPORT		c800and999	
					EXPORT		c900and999
					EXPORT		thresh_cursor

;ALL OF THE BELOW BLOCKS HAVE THE SAME PURPOSE: CURSOR

;I DID NOT WANT TO IMPLEMENT A SELECTION ALGORITHM FOR BYTE SIZE AND X&Y VALUES INSIDE THE BLOCK
;BECAUSE SENDING BYTE TO SCREEN TAKES LONGER TIME. I TRIED TO MINIMIZE THIS TIME FOR QUICK RESPONSE
;I REPEATED BLOCKS FOR DIFFERENT X VALUES AND BYTE SIZES. FOR EXAMPLE:
;C0-999 MODIFIES 10 CHARACTERS OF BOTTOM LINE
;C100-999 MODIFIES 9 CHARACTERS..AND IT GOES ON

;THRESH_CURSOR IS RESPONSIBLE FROM PLACING 'X' CHARACTER AT THE BOTTOM LINE
;THRESH_CURSOR IS A BIT DIFFERENT, IT SELECTS THE X AXIS VALUE ACCORDING TO THRESH_VAL VALUE WHICH I USED FOR HOLDING
;THRESHOLD VALUE IN MEMORY.I USED THAT SELECTION ALGORITHM IN THIS BLOCK AND YOU CAN SEE HOW THE LENGTH OF THE
;CODE INCREASED. I ALSO WROTE REQUIRED X VALUES ABOVE, NAMED AS BTW0-99...


c0and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20						;  H=0
		BL		byte_send	
		MOV		R5,#0x45						; set Y address to bank4
		BL		byte_send
		MOV		R5,#0x9E						; set X address to 9E
		BL		byte_send	
wt_ready1		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready1
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#50							;50 bytes sending
		MOV		R1,R5					
one_by_one1	
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one1		
		POP		{R0-R4,LR}
		BX		LR

c100and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xA3				; set X address to A3
		BL		byte_send	
wt_ready2		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready2
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#45					;45 bytes sending
		MOV		R1,R5					
one_by_one2		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one2		
		POP		{R0-R4,LR}
		BX		LR

c200and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xA8				; set X address to A8
		BL		byte_send	
wt_ready3		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready3
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#40					;40 bytes sending
		MOV		R1,R5					
one_by_one3		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one3		
		POP		{R0-R4,LR}
		BX		LR

c300and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xAD				; set X address to AD
		BL		byte_send	
wt_ready4		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready4
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#35				; 35 bytes sending
		MOV		R1,R5					
one_by_one4		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one4		
		POP		{R0-R4,LR}
		BX		LR

c400and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xB2				; set X address to B2
		BL		byte_send	
wt_ready5		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready5
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#30					;30 bytes sending
		MOV		R1,R5					
one_by_one5		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one5		
		POP		{R0-R4,LR}
		BX		LR

c500and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xB7				; set X address to B7
		BL		byte_send	
wt_ready6		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready6
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#25					;25 bytes sending
		MOV		R1,R5					
one_by_one6		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one6		
		POP		{R0-R4,LR}
		BX		LR

c600and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xBC				; set X address to BC
		BL		byte_send	
wt_ready7		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready7
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#20					;20 bytes sending
		MOV		R1,R5					
one_by_one7		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one7		
		POP		{R0-R4,LR}
		BX		LR
		
c700and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xC1				; set X address to C1
		BL		byte_send	
wt_ready8		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready8
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#15					;15 bytes sending
		MOV		R1,R5					
one_by_one8		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one8		
		POP		{R0-R4,LR}
		BX		LR
		
c800and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xC6				; set X address to C6
		BL		byte_send	
wt_ready9		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready9
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#10					;10 bytes sending
		MOV		R1,R5					
one_by_one9		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one9		
		POP		{R0-R4,LR}
		BX		LR
		
c900and999
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		MOV		R5,#0xCB				; set X address to CB
		BL		byte_send	
wt_ready10		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wt_ready10
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5					;5 bytes sending
		MOV		R1,R5					
one_by_one10		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		one_by_one10		
		POP		{R0-R4,LR}
		BX		LR
		
		
thresh_cursor
		PUSH	{R0-R4,LR}
		PUSH	{R5}					
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		BIC		R0,#0x40
		STR		R0,[R1]
		MOV		R5,#0x20				;  H=0
		BL		byte_send	
		MOV		R5,#0x45				; set Y address to bank4
		BL		byte_send
		LDR		R5,=THRESH_VAL
		LDRB	R0,[R5,#2]
		SUB		R0,R0,#'0'
		
		CMP		R0,#0					;SELECTION FOR X ADDRESS
		BEQ		go0
		CMP		R0,#1
		BEQ		go1
		CMP		R0,#2
		BEQ		go2
		CMP		R0,#3
		BEQ		go3
		CMP		R0,#4
		BEQ		go4
		CMP		R0,#5
		BEQ		go5
		CMP		R0,#6
		BEQ		go6
		CMP		R0,#7
		BEQ		go7
		CMP		R0,#8
		BEQ		go8
		B		go9
		
go0		LDR		R5,=btw0and99
		B		cont
go1		LDR		R5,=btw100and199
		B		cont
go2		LDR		R5,=btw200and299
		B		cont
go3		LDR		R5,=btw300and399
		B		cont
go4		LDR		R5,=btw400and499
		B		cont
go5		LDR		R5,=btw500and599
		B		cont
go6		LDR		R5,=btw600and699
		B		cont
go7		LDR		R5,=btw700and799
		B		cont
go8		LDR		R5,=btw800and899
		B		cont
go9		LDR		R5,=btw900and999
		B		cont

cont	BL		byte_send	
wtrdy		
		LDR		R1,=SSI0_SR				
		LDR		R0,[R1]
		ANDS	R0,R0,#0x10
		BNE		wtrdy
		LDR		R1,=GPIO_PORTA_DATA		
		LDR		R0,[R1]
		ORR		R0,#0x40
		STR		R0,[R1]	
		POP		{R5}
		MOV		R0,#5				; 5 byte send
		MOV		R1,R5					
onebyeone		
		LDRB	R5,[R1],#1		
		BL		byte_send
		SUBS	R0,#1
		BNE		onebyeone		
		POP		{R0-R4,LR}
		BX		LR