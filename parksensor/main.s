;I tried to make a well structured code, so my main function is short
;and i used lots of subroutines.
		AREA 		main,CODE,READONLY
		THUMB
		EXTERN		lcd_init			;Lcd screen initialization
		EXTERN		init_screen			;Sets initial display screen
		EXTERN		sw_inits			;SW1 & SW2 initializations
		EXTERN		SW1_detect			;Subroutine for checking SW1 interrupt flags and setting thre. adj. mode
		EXTERN		adc_init			;Analog to digital converter initialization for potentiometer
		EXTERN		dist_init			;HCSR-04 initialization
		EXTERN 		dist_tr				;Measures distance and stores it in memory
		EXTERN		comparison			;Compares measured distance and threshold value.Goes to breaking mode if necessary
		EXTERN 		motor_init			;Stepper motor initialization
		EXPORT		__main
			
__main
		BL			lcd_init
		BL			init_screen
		BL			adc_init
		BL			dist_init
		BL			sw_inits
		BL			motor_init
		CPSIE		I

;Continuously->     track distance  &  check for thre. adj. mode  &  compare distance and threshold
lp					
		BL			dist_init
		BL			dist_tr
		BL 			SW1_detect
		BL			comparison	
		B			lp

		END