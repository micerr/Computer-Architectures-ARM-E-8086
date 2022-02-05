;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00002000

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF

				AREA myPoles, DATA, READWRITE
pole1	SPACE 100
stackPole1
pole2	SPACE 100
stackPole2
pole3	SPACE 100
stackPole3

                AREA    |.text|, CODE, READONLY
constants DCD 9, 6, 3, 2, 1, 8, 7, 0, 5, 4, 0

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                LDR r0, =constants
				LDR r1, =stackPole1
				LDR r2, =stackPole2
				LDR r3, =stackPole3
				; pole 1
				PUSH {r1}
				PUSH {r0}
				BL fillStack
				POP {r0}
				POP {r1}
				; pole 2
				PUSH {r2}
				PUSH {r0}
				BL fillStack
				POP {r0}
				POP {r2}
				; pole 3
				PUSH {r3}
				PUSH {r0}
				BL fillStack
				POP {r0}
				POP {r3}
				; move from 1 to 2
;				PUSH {r1}
;				PUSH {r2}
;				PUSH {r0}
;				BL mov1
;				POP {r0}
;				POP {r2}
;				POP {r1}
				; move n disks
				MOV r0, #3
				PUSH {r1}
				PUSH {r3}
				PUSH {r2}
				PUSH {r0}
				BL movN
				POP {r0}
				POP {r2}
				POP {r3}
				POP {r1}
				
				MOV r0, #5
				PUSH {r3}
				PUSH {r1}
				PUSH {r2}
				PUSH {r0}
				BL movN
				POP {r0}
				POP {r2}
				POP {r1}
				POP {r3}
				
				MOV r0, #6
				PUSH {r1}
				PUSH {r2}
				PUSH {r3}
				PUSH {r0}
				BL movN
				POP {r0}
				POP {r3}
				POP {r2}
				POP {r1}
				
				MOV r0, #8
				PUSH {r2}
				PUSH {r1}
				PUSH {r3}
				PUSH {r0}
				BL movN
				POP {r0}
				POP {r3}
				POP {r1}
				POP {r2}
				
loop			B	loop
                ENDP
					
fillStack		PROC
				PUSH {r9, LR}
				MOV r9, SP
				PUSH {r0-r3}
				LDR r0, [r9, #12] 	; stack pointer
				LDR r1, [r9, #8]	; area sequence of constants
				MOV r2, #0xFF	;	prec
cycleFillStack	LDR r3, [r1]	; new disk
				CMP r3, r2
				BHI endFillStack
				ADD r1, #4	; go to next
				CMP r3, #0
				BEQ endFillStack
				STMFD r0!, {r3}
				MOV r2, r3	; update prec
				B cycleFillStack
endFillStack	STR r0, [r9, #12]	; return new stack pointer
				STR r1, [r9, #8]	; updated constants address
				POP {r0-r3}
				POP	{r9, PC}
				ENDP
					
mov1 			PROC
				PUSH {r9, LR}
				MOV r9, SP
				PUSH {r0-r4}
				LDR r0, [r9, #16]	; src pole
				LDR r1, [r9, #12]	; dest pole
				EOR r2, r2			; return value
				LDR r3, [r0]		; disk to move
				LDR r4, [r1]		; last disk in dest
				CMP r4, #0
				BEQ move
				CMP r3, r4
				BHI noMov
move			LDMFD r0!, {r3}		; pop the src disk
				STMFD r1!, {r3}		; push in the new pole
				ADD r2, #1			; return value to 1
noMov			STR r0, [r9, #16]
				STR r1, [r9, #12]
				STR r2, [r9, #8]
				POP	{r0-r4}
				POP {r9, PC}
				ENDP
					
movN			PROC
				PUSH {r9, LR}
				MOV r9, SP
				PUSH {r0-r5}
				LDR r0, [r9, #20]	; src stack (X)
				LDR r1, [r9, #16]	; dst stack (Y)
				LDR r2, [r9, #12]	; ausiliar stack (Z)
				LDR r3, [r9, #8]	; number of disks
				EOR r4, r4			; movements (M)
				EOR r5, r5			; returns	(a/b/c)
				CMP r3, #1
				BNE	movNdisks
					; move a single disk
					PUSH {r0}
					PUSH {r1}
					PUSH {r5}
					BL mov1
					POP {r5}
					POP {r1}
					POP {r0}
					ADD r4, r5	; M=M+a
					B endMovN
movNdisks		SUB r3, #1	; N= N-1
				PUSH {r0}
				PUSH {r2}
				PUSH {r1}
				PUSH {r3}
				BL movN
				POP {r5}
				POP {r1}
				POP {r2}
				POP {r0}
				ADD r4, r5	; M=M+b
				PUSH {r0}
				PUSH {r1}
				PUSH {r5}
				BL mov1
				POP {r5}
				POP {r1}
				POP {r0}
				CMP r5,#0
				BEQ endMovN
				ADD r4, r5
				PUSH {r2}
				PUSH {r1}
				PUSH {r0}
				PUSH {r3}
				BL movN
				POP {r5}
				POP {r0}
				POP {r1}
				POP {r2}
				ADD r4, r5	; M=M+b
endMovN			STR r0, [r9,#20]
				STR r1, [r9,#16]
				STR r2, [r9,#12]
				STR r4, [r9,#8]
				POP {r0-r5}
				POP	{r9, PC}
				ENDP


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
