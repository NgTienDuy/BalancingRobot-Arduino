
;CodeVisionAVR C Compiler V4.07 Evaluation
;(C) Copyright 1998-2026 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x40011:
	.DB  0x8F,0xC2,0x75,0x3F
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _g_alpha_G002
	.DW  _0x40011*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void Init_System(void)
; 0000 0011 {

	.CSEG
_Init_System:
; .FSTART _Init_System
; 0000 0012 // Configure Timer0 for a fixed 10 ms sampling tick.
; 0000 0013 TCCR0B = (1 << CS02) | (1 << CS00);   // prescaler 1024
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 0014 TCNT0 = 0;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0015 TIMSK0 = (1 << TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0016 
; 0000 0017 // Enable global interrupts
; 0000 0018 #asm("sei")
	SEI
; 0000 0019 
; 0000 001A // Initialize modules
; 0000 001B MPU6050_Init();
	RCALL _MPU6050_Init
; 0000 001C Motor_Init();
	RCALL _Motor_Init
; 0000 001D 
; 0000 001E // Default PID parameters (start values only - tune on real hardware)
; 0000 001F // These are safe initial values for a small rover platform.
; 0000 0020 PID_Init(&g_pid, 18.0f, 0.0f, 4.0f, 0.0f, 255.0f, 255.0f);
	RCALL SUBOPT_0x0
	__GETD1N 0x41900000
	RCALL SUBOPT_0x1
	__GETD1N 0x40800000
	RCALL SUBOPT_0x1
	__GETD1N 0x437F0000
	RCALL __PUTPARD1
	__GETD2N 0x437F0000
	RCALL _PID_Init
; 0000 0021 g_pid.Setpoint = 0.0f;
	RCALL SUBOPT_0x2
	__PUTD1MN _g_pid,28
; 0000 0022 }
	RET
; .FEND
;void main(void)
; 0000 0025 {
_main:
; .FSTART _main
; 0000 0026 MPU6050_Data imu;
; 0000 0027 float pitch = 0.0f;
; 0000 0028 int output = 0;
; 0000 0029 
; 0000 002A Init_System();
	SBIW R28,28
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	imu -> Y+4
;	pitch -> Y+0
;	output -> R16,R17
	__GETWRN 16,17,0
	RCALL _Init_System
; 0000 002B 
; 0000 002C while (1)
_0x3:
; 0000 002D {
; 0000 002E if (g_flag_compute)
	LDS  R30,_g_flag_compute
	CPI  R30,0
	BREQ _0x6
; 0000 002F {
; 0000 0030 g_flag_compute = 0;
	LDI  R30,LOW(0)
	STS  _g_flag_compute,R30
; 0000 0031 
; 0000 0032 MPU6050_Read_Raw(&imu, SAMPLE_DT);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x3
	RCALL _MPU6050_Read_Raw
; 0000 0033 
; 0000 0034 // Simple complementary-filter style estimate
; 0000 0035 // (The actual angle filter is implemented in mpu6050.c for reuse)
; 0000 0036 pitch = imu.angle_filtered;
	__GETD1S 24
	RCALL SUBOPT_0x4
; 0000 0037 
; 0000 0038 output = (int)PID_Compute(&g_pid, pitch, SAMPLE_DT);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x5
	RCALL __PUTPARD1
	RCALL SUBOPT_0x3
	RCALL _PID_Compute
	RCALL __CFD1
	MOVW R16,R30
; 0000 0039 Motor_Control(output, output);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R16
	RCALL _Motor_Control
; 0000 003A }
; 0000 003B }
_0x6:
	RJMP _0x3
; 0000 003C }
_0x7:
	RJMP _0x7
; .FEND
;interrupt [17] void timer0_ovf_isr(void)
; 0000 003F {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0040 static unsigned char counter = 0;
; 0000 0041 
; 0000 0042 TCNT0 = 0;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0043 counter++;
	LDS  R30,_counter_S0000002000
	SUBI R30,-LOW(1)
	STS  _counter_S0000002000,R30
; 0000 0044 
; 0000 0045 if (counter >= 1)
	LDS  R26,_counter_S0000002000
	CPI  R26,LOW(0x1)
	BRLO _0x8
; 0000 0046 {
; 0000 0047 counter = 0;
	LDI  R30,LOW(0)
	STS  _counter_S0000002000,R30
; 0000 0048 g_flag_compute = 1;
	LDI  R30,LOW(1)
	STS  _g_flag_compute,R30
; 0000 0049 }
; 0000 004A }
_0x8:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;static unsigned int Motor_PwmValue(int speed)
; 0001 0005 {

	.CSEG
_Motor_PwmValue_G001:
; .FSTART _Motor_PwmValue_G001
; 0001 0006 if (speed < 0)
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	speed -> R16,R17
	TST  R17
	BRPL _0x20003
; 0001 0007 speed = -speed;
	MOVW R30,R16
	RCALL __ANEGW1
	MOVW R16,R30
; 0001 0008 if (speed > 255)
_0x20003:
	__CPWRN 16,17,256
	BRLT _0x20004
; 0001 0009 speed = 255;
	__GETWRN 16,17,255
; 0001 000A return (unsigned int)speed;
_0x20004:
	MOVW R30,R16
	RJMP _0x2080003
; 0001 000B }
; .FEND
;static void Set_Left_Speed(int speed)
; 0001 000E {
_Set_Left_Speed_G001:
; .FSTART _Set_Left_Speed_G001
; 0001 000F unsigned int duty = Motor_PwmValue(speed);
; 0001 0010 
; 0001 0011 if (speed >= 0)
	RCALL SUBOPT_0x6
;	speed -> Y+2
;	duty -> R16,R17
	BRMI _0x20005
; 0001 0012 {
; 0001 0013 PORTD.2 = 1;
	SBI  0xB,2
; 0001 0014 PORTD.3 = 0;
	CBI  0xB,3
; 0001 0015 }
; 0001 0016 else
	RJMP _0x2000A
_0x20005:
; 0001 0017 {
; 0001 0018 PORTD.2 = 0;
	CBI  0xB,2
; 0001 0019 PORTD.3 = 1;
	SBI  0xB,3
; 0001 001A }
_0x2000A:
; 0001 001B 
; 0001 001C OCR1AL = (unsigned char)duty;
	STS  136,R16
; 0001 001D OCR1AH = (unsigned char)(duty >> 8);
	STS  137,R17
; 0001 001E }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080002
; .FEND
;static void Set_Right_Speed(int speed)
; 0001 0021 {
_Set_Right_Speed_G001:
; .FSTART _Set_Right_Speed_G001
; 0001 0022 unsigned int duty = Motor_PwmValue(speed);
; 0001 0023 
; 0001 0024 if (speed >= 0)
	RCALL SUBOPT_0x6
;	speed -> Y+2
;	duty -> R16,R17
	BRMI _0x2000F
; 0001 0025 {
; 0001 0026 PORTD.4 = 1;
	SBI  0xB,4
; 0001 0027 PORTD.5 = 0;
	CBI  0xB,5
; 0001 0028 }
; 0001 0029 else
	RJMP _0x20014
_0x2000F:
; 0001 002A {
; 0001 002B PORTD.4 = 0;
	CBI  0xB,4
; 0001 002C PORTD.5 = 1;
	SBI  0xB,5
; 0001 002D }
_0x20014:
; 0001 002E 
; 0001 002F OCR1BL = (unsigned char)duty;
	STS  138,R16
; 0001 0030 OCR1BH = (unsigned char)(duty >> 8);
	STS  139,R17
; 0001 0031 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080002
; .FEND
;void Motor_Init(void)
; 0001 0034 {
_Motor_Init:
; .FSTART _Motor_Init
; 0001 0035 DDRD.2 = 1;
	SBI  0xA,2
; 0001 0036 DDRD.3 = 1;
	SBI  0xA,3
; 0001 0037 DDRD.4 = 1;
	SBI  0xA,4
; 0001 0038 DDRD.5 = 1;
	SBI  0xA,5
; 0001 0039 DDRB.1 = 1;
	SBI  0x4,1
; 0001 003A DDRB.2 = 1;
	SBI  0x4,2
; 0001 003B 
; 0001 003C TCCR1A = (1 << COM1A1) | (1 << COM1B1) | (1 << WGM10);
	LDI  R30,LOW(161)
	STS  128,R30
; 0001 003D TCCR1B = (1 << CS10) | (1 << WGM12);
	LDI  R30,LOW(9)
	STS  129,R30
; 0001 003E OCR1AL = 0;
	LDI  R30,LOW(0)
	STS  136,R30
; 0001 003F OCR1AH = 0;
	STS  137,R30
; 0001 0040 OCR1BL = 0;
	STS  138,R30
; 0001 0041 OCR1BH = 0;
	STS  139,R30
; 0001 0042 }
	RET
; .FEND
;void Motor_Control(int speed_left, int speed_right)
; 0001 0045 {
_Motor_Control:
; .FSTART _Motor_Control
; 0001 0046 if (speed_left > 255) speed_left = 255;
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
;	speed_left -> R18,R19
;	speed_right -> R16,R17
	__CPWRN 18,19,256
	BRLT _0x20025
	__GETWRN 18,19,255
; 0001 0047 if (speed_left < -255) speed_left = -255;
_0x20025:
	__CPWRN 18,19,65281
	BRGE _0x20026
	__GETWRN 18,19,65281
; 0001 0048 if (speed_right > 255) speed_right = 255;
_0x20026:
	__CPWRN 16,17,256
	BRLT _0x20027
	__GETWRN 16,17,255
; 0001 0049 if (speed_right < -255) speed_right = -255;
_0x20027:
	__CPWRN 16,17,65281
	BRGE _0x20028
	__GETWRN 16,17,65281
; 0001 004A 
; 0001 004B Set_Left_Speed(speed_left);
_0x20028:
	MOVW R26,R18
	RCALL _Set_Left_Speed_G001
; 0001 004C Set_Right_Speed(speed_right);
	MOVW R26,R16
	RCALL _Set_Right_Speed_G001
; 0001 004D }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;static void i2c_delay(void)
; 0002 0016 {

	.CSEG
_i2c_delay_G002:
; .FSTART _i2c_delay_G002
; 0002 0017 // ~5 us at 8 MHz (rough tuning for 100 kHz I2C)
; 0002 0018 unsigned char i;
; 0002 0019 for (i = 0; i < 3; i++) {
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x40004:
	CPI  R17,3
	BRSH _0x40005
; 0002 001A #asm("nop");
	NOP
; 0002 001B }
	SUBI R17,-1
	RJMP _0x40004
_0x40005:
; 0002 001C }
	LD   R17,Y+
	RET
; .FEND
;static void i2c_init(void)
; 0002 001F {
_i2c_init_G002:
; .FSTART _i2c_init_G002
; 0002 0020 SDA_HIGH();
	CBI  0x7,4
; 0002 0021 SCL_HIGH();
	CBI  0x7,5
; 0002 0022 }
	RET
; .FEND
;static unsigned char i2c_start(void)
; 0002 0025 {
_i2c_start_G002:
; .FSTART _i2c_start_G002
; 0002 0026 SDA_HIGH();
	CBI  0x7,4
; 0002 0027 SCL_HIGH();
	CBI  0x7,5
; 0002 0028 i2c_delay();
	RCALL _i2c_delay_G002
; 0002 0029 SDA_LOW();
	SBI  0x7,4
; 0002 002A i2c_delay();
	RCALL _i2c_delay_G002
; 0002 002B SCL_LOW();
	SBI  0x7,5
; 0002 002C i2c_delay();
	RCALL _i2c_delay_G002
; 0002 002D return 1; // success
	LDI  R30,LOW(1)
	RET
; 0002 002E }
; .FEND
;static void i2c_stop(void)
; 0002 0031 {
_i2c_stop_G002:
; .FSTART _i2c_stop_G002
; 0002 0032 SDA_LOW();
	SBI  0x7,4
; 0002 0033 SCL_HIGH();
	CBI  0x7,5
; 0002 0034 i2c_delay();
	RCALL _i2c_delay_G002
; 0002 0035 SDA_HIGH();
	CBI  0x7,4
; 0002 0036 i2c_delay();
	RCALL _i2c_delay_G002
; 0002 0037 }
	RET
; .FEND
;static unsigned char i2c_write(unsigned char data)
; 0002 003A {
_i2c_write_G002:
; .FSTART _i2c_write_G002
; 0002 003B unsigned char i;
; 0002 003C for (i = 0; i < 8; i++)
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	data -> R16
;	i -> R17
	LDI  R17,LOW(0)
_0x40007:
	CPI  R17,8
	BRSH _0x40008
; 0002 003D {
; 0002 003E if (data & 0x80)
	SBRS R16,7
	RJMP _0x40009
; 0002 003F SDA_HIGH();
	CBI  0x7,4
; 0002 0040 else
	RJMP _0x4000A
_0x40009:
; 0002 0041 SDA_LOW();
	SBI  0x7,4
; 0002 0042 data <<= 1;
_0x4000A:
	LSL  R16
; 0002 0043 i2c_delay();
	RCALL SUBOPT_0x7
; 0002 0044 SCL_HIGH();
; 0002 0045 i2c_delay();
; 0002 0046 SCL_LOW();
; 0002 0047 i2c_delay();
; 0002 0048 }
	SUBI R17,-1
	RJMP _0x40007
_0x40008:
; 0002 0049 // Release SDA for ACK, read ACK bit
; 0002 004A SDA_HIGH();
	CBI  0x7,4
; 0002 004B i2c_delay();
	RCALL _i2c_delay_G002
; 0002 004C SCL_HIGH();
	CBI  0x7,5
; 0002 004D i2c_delay();
	RCALL _i2c_delay_G002
; 0002 004E {
; 0002 004F unsigned char ack = SDA_IN() == 0;
; 0002 0050 SCL_LOW();
	SBIW R28,1
;	ack -> Y+0
	IN   R30,0x6
	ANDI R30,LOW(0x10)
	LDI  R26,LOW(0)
	__EQB12
	ST   Y,R30
	SBI  0x7,5
; 0002 0051 i2c_delay();
	RCALL _i2c_delay_G002
; 0002 0052 return ack;
	LD   R30,Y
	ADIW R28,1
_0x2080003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0002 0053 }
	ADIW R28,1
; 0002 0054 }
; .FEND
;static unsigned char i2c_read(unsigned char ack)
; 0002 0057 {
_i2c_read_G002:
; .FSTART _i2c_read_G002
; 0002 0058 unsigned char i, data = 0;
; 0002 0059 SDA_HIGH();
	RCALL __SAVELOCR4
	MOV  R19,R26
;	ack -> R19
;	i -> R17
;	data -> R16
	LDI  R16,0
	CBI  0x7,4
; 0002 005A for (i = 0; i < 8; i++)
	LDI  R17,LOW(0)
_0x4000C:
	CPI  R17,8
	BRSH _0x4000D
; 0002 005B {
; 0002 005C data <<= 1;
	LSL  R16
; 0002 005D SCL_HIGH();
	CBI  0x7,5
; 0002 005E i2c_delay();
	RCALL _i2c_delay_G002
; 0002 005F if (SDA_IN())
	SBIC 0x6,4
; 0002 0060 data |= 1;
	ORI  R16,LOW(1)
; 0002 0061 SCL_LOW();
	SBI  0x7,5
; 0002 0062 i2c_delay();
	RCALL _i2c_delay_G002
; 0002 0063 }
	SUBI R17,-1
	RJMP _0x4000C
_0x4000D:
; 0002 0064 // Send ACK/NACK
; 0002 0065 if (ack)
	CPI  R19,0
	BREQ _0x4000F
; 0002 0066 SDA_LOW();
	SBI  0x7,4
; 0002 0067 else
	RJMP _0x40010
_0x4000F:
; 0002 0068 SDA_HIGH();
	CBI  0x7,4
; 0002 0069 i2c_delay();
_0x40010:
	RCALL SUBOPT_0x7
; 0002 006A SCL_HIGH();
; 0002 006B i2c_delay();
; 0002 006C SCL_LOW();
; 0002 006D i2c_delay();
; 0002 006E SDA_HIGH();
	CBI  0x7,4
; 0002 006F return data;
	MOV  R30,R16
	RCALL __LOADLOCR4
	RJMP _0x2080002
; 0002 0070 }
; .FEND

	.DSEG
;void MPU6050_Init(void)
; 0002 0079 {

	.CSEG
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0002 007A i2c_init();
	RCALL _i2c_init_G002
; 0002 007B i2c_start();
	RCALL _i2c_start_G002
; 0002 007C i2c_stop();
	RCALL SUBOPT_0x8
; 0002 007D 
; 0002 007E // Wake up sensor
; 0002 007F i2c_start();
; 0002 0080 i2c_write(MPU6050_I2C_ADDR << 1);
; 0002 0081 i2c_write(MPU6050_RA_PWR_MGMT_1);
	LDI  R26,LOW(107)
	RCALL SUBOPT_0x9
; 0002 0082 i2c_write(0x00);
; 0002 0083 i2c_stop();
; 0002 0084 
; 0002 0085 // DLPF off
; 0002 0086 i2c_start();
; 0002 0087 i2c_write(MPU6050_I2C_ADDR << 1);
; 0002 0088 i2c_write(MPU6050_RA_CONFIG);
	LDI  R26,LOW(26)
	RCALL SUBOPT_0x9
; 0002 0089 i2c_write(0x00);
; 0002 008A i2c_stop();
; 0002 008B 
; 0002 008C // Gyro config: +/-250 deg/s
; 0002 008D i2c_start();
; 0002 008E i2c_write(MPU6050_I2C_ADDR << 1);
; 0002 008F i2c_write(MPU6050_RA_GYRO_CONFIG);
	LDI  R26,LOW(27)
	RCALL SUBOPT_0x9
; 0002 0090 i2c_write(0x00);
; 0002 0091 i2c_stop();
; 0002 0092 
; 0002 0093 // Accel config: +/-2g
; 0002 0094 i2c_start();
; 0002 0095 i2c_write(MPU6050_I2C_ADDR << 1);
; 0002 0096 i2c_write(MPU6050_RA_ACCEL_CONFIG);
	LDI  R26,LOW(28)
	RCALL _i2c_write_G002
; 0002 0097 i2c_write(0x00);
	LDI  R26,LOW(0)
	RCALL _i2c_write_G002
; 0002 0098 i2c_stop();
	RCALL _i2c_stop_G002
; 0002 0099 }
	RET
; .FEND
;void MPU6050_Read_Raw(MPU6050_Data* data, float dt)
; 0002 009C {
_MPU6050_Read_Raw:
; .FSTART _MPU6050_Read_Raw
; 0002 009D unsigned char buf[14];
; 0002 009E int16_t ax, ay, az, gx, gy, gz;
; 0002 009F 
; 0002 00A0 i2c_start();
	RCALL __PUTPARD2
	SBIW R28,20
	RCALL __SAVELOCR6
;	*data -> Y+30
;	dt -> Y+26
;	buf -> Y+12
;	ax -> R16,R17
;	ay -> R18,R19
;	az -> R20,R21
;	gx -> Y+10
;	gy -> Y+8
;	gz -> Y+6
	RCALL _i2c_start_G002
; 0002 00A1 i2c_write(MPU6050_I2C_ADDR << 1);
	LDI  R26,LOW(208)
	RCALL _i2c_write_G002
; 0002 00A2 i2c_write(MPU6050_RA_ACCEL_XOUT_H);
	LDI  R26,LOW(59)
	RCALL _i2c_write_G002
; 0002 00A3 i2c_start();
	RCALL _i2c_start_G002
; 0002 00A4 i2c_write((MPU6050_I2C_ADDR << 1) | 1);
	LDI  R26,LOW(209)
	RCALL _i2c_write_G002
; 0002 00A5 
; 0002 00A6 buf[0] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+12,R30
; 0002 00A7 buf[1] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+13,R30
; 0002 00A8 buf[2] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+14,R30
; 0002 00A9 buf[3] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+15,R30
; 0002 00AA buf[4] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+16,R30
; 0002 00AB buf[5] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+17,R30
; 0002 00AC buf[6] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+18,R30
; 0002 00AD buf[7] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+19,R30
; 0002 00AE buf[8] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+20,R30
; 0002 00AF buf[9] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+21,R30
; 0002 00B0 buf[10] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+22,R30
; 0002 00B1 buf[11] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+23,R30
; 0002 00B2 buf[12] = i2c_read(1);
	LDI  R26,LOW(1)
	RCALL _i2c_read_G002
	STD  Y+24,R30
; 0002 00B3 buf[13] = i2c_read(0);
	LDI  R26,LOW(0)
	RCALL _i2c_read_G002
	STD  Y+25,R30
; 0002 00B4 
; 0002 00B5 i2c_stop();
	RCALL _i2c_stop_G002
; 0002 00B6 
; 0002 00B7 ax = (int16_t)((buf[0] << 8) | buf[1]);
	LDI  R30,0
	LDD  R31,Y+12
	MOVW R26,R30
	LDD  R30,Y+13
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R16,R30
; 0002 00B8 ay = (int16_t)((buf[2] << 8) | buf[3]);
	LDI  R30,0
	LDD  R31,Y+14
	MOVW R26,R30
	LDD  R30,Y+15
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R18,R30
; 0002 00B9 az = (int16_t)((buf[4] << 8) | buf[5]);
	LDI  R30,0
	LDD  R31,Y+16
	MOVW R26,R30
	LDD  R30,Y+17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R20,R30
; 0002 00BA gx = (int16_t)((buf[8] << 8) | buf[9]);
	LDI  R30,0
	LDD  R31,Y+20
	MOVW R26,R30
	LDD  R30,Y+21
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0002 00BB gy = (int16_t)((buf[10] << 8) | buf[11]);
	LDI  R30,0
	LDD  R31,Y+22
	MOVW R26,R30
	LDD  R30,Y+23
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0002 00BC gz = (int16_t)((buf[12] << 8) | buf[13]);
	LDI  R30,0
	LDD  R31,Y+24
	MOVW R26,R30
	LDD  R30,Y+25
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0002 00BD 
; 0002 00BE data->accel_x = ax;
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	ST   X+,R16
	ST   X,R17
; 0002 00BF data->accel_y = ay;
	MOVW R30,R18
	__PUTW1SNS 30,2
; 0002 00C0 data->accel_z = az;
	MOVW R30,R20
	__PUTW1SNS 30,4
; 0002 00C1 data->gyro_x = gx;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	__PUTW1SNS 30,6
; 0002 00C2 data->gyro_y = gy;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__PUTW1SNS 30,8
; 0002 00C3 data->gyro_z = gz;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTW1SNS 30,10
; 0002 00C4 
; 0002 00C5 // Convert raw sensor data to physical units.
; 0002 00C6 // Accel range: +/-2g  => 16384 LSB/g
; 0002 00C7 // Gyro range: +/-250 deg/s => 131 LSB/(deg/s)
; 0002 00C8 data->angle_acc = atan2((float)ay, (float)az) * 57.29578f;
	MOVW R30,R18
	RCALL SUBOPT_0xA
	RCALL __PUTPARD1
	MOVW R30,R20
	RCALL SUBOPT_0xA
	MOVW R26,R30
	MOVW R24,R22
	RCALL _atan2
	__GETD2N 0x42652EE1
	RCALL __MULF12
	__PUTD1SNS 30,12
; 0002 00C9 data->angle_gyro = (float)gy / 131.0f;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0xA
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43030000
	RCALL __DIVF21
	__PUTD1SNS 30,16
; 0002 00CA 
; 0002 00CB if (data->angle_filtered == 0.0f)
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	ADIW R26,20
	RCALL __GETD1P
	__CPD10
	BRNE _0x40012
; 0002 00CC {
; 0002 00CD data->angle_filtered = data->angle_acc;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0002 00CE }
; 0002 00CF 
; 0002 00D0 // Complementary filter: fuse gyro integration with accelerometer angle.
; 0002 00D1 // dt must be fixed by a timer interrupt (recommended 5 ms to 10 ms).
; 0002 00D2 data->angle_filtered = g_alpha * (data->angle_filtered + data->angle_gyro * dt) +
_0x40012:
; 0002 00D3 (1.0f - g_alpha) * data->angle_acc;
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	__GETD2Z 20
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0xD
	__GETD1S 26
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	RCALL SUBOPT_0xE
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	__GETD1N 0x3F800000
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	RCALL SUBOPT_0xC
; 0002 00D4 }
	RCALL __LOADLOCR6
	ADIW R28,32
	RET
; .FEND
; 0003 0004 float integral_limit, float output_limit, float setpoint)
;float integral_limit, float output_limit, float setpoint)
; 0003 0005 {

	.CSEG
_PID_Init:
; .FSTART _PID_Init
; 0003 0006 pid->Kp = Kp;
	RCALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
	__GETWRS 16,17,26
;	*pid -> R16,R17
;	Kp -> Y+22
;	Ki -> Y+18
;	Kd -> Y+14
;	integral_limit -> Y+10
;	output_limit -> Y+6
;	setpoint -> Y+2
	__GETD1S 22
	MOVW R26,R16
	RCALL SUBOPT_0xF
; 0003 0007 pid->Ki = Ki;
	__GETD1S 18
	__PUTD1RNS 16,4
; 0003 0008 pid->Kd = Kd;
	__GETD1S 14
	__PUTD1RNS 16,8
; 0003 0009 pid->Integral = 0.0f;
	MOVW R26,R16
	ADIW R26,16
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
; 0003 000A pid->Derivative = 0.0f;
	MOVW R26,R16
	ADIW R26,20
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
; 0003 000B pid->Error = 0.0f;
	MOVW R26,R16
	ADIW R26,12
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
; 0003 000C pid->Last_Error = 0.0f;
	MOVW R26,R16
	ADIW R26,24
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
; 0003 000D pid->Setpoint = setpoint;
	RCALL SUBOPT_0x5
	__PUTD1RNS 16,28
; 0003 000E pid->Integral_Limit = integral_limit;
	__GETD1S 10
	__PUTD1RNS 16,36
; 0003 000F pid->Output_Limit = output_limit;
	RCALL SUBOPT_0x10
	__PUTD1RNS 16,40
; 0003 0010 pid->Output = 0.0f;
	MOVW R26,R16
	ADIW R26,32
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
; 0003 0011 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,28
	RET
; .FEND
;float PID_Compute(PID_Controller* pid, float current_angle, float dt)
; 0003 0014 {
_PID_Compute:
; .FSTART _PID_Compute
; 0003 0015 pid->Error = pid->Setpoint - current_angle;
	RCALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
	__GETWRS 16,17,10
;	*pid -> R16,R17
;	current_angle -> Y+6
;	dt -> Y+2
	MOVW R30,R16
	__GETD2Z 28
	RCALL SUBOPT_0x10
	RCALL __SWAPD12
	RCALL __SUBF12
	__PUTD1RNS 16,12
; 0003 0016 pid->Integral += pid->Error * dt;
	MOVW R30,R16
	ADIW R30,16
	PUSH R31
	PUSH R30
	MOVW R26,R30
	RCALL SUBOPT_0x11
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x5
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	POP  R26
	POP  R27
	RCALL SUBOPT_0xF
; 0003 0017 
; 0003 0018 if (pid->Integral > pid->Integral_Limit) pid->Integral = pid->Integral_Limit;
	RCALL SUBOPT_0x13
	MOVW R26,R0
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x60003
	MOVW R26,R16
	ADIW R26,36
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x14
; 0003 0019 if (pid->Integral < -pid->Integral_Limit) pid->Integral = -pid->Integral_Limit;
_0x60003:
	RCALL SUBOPT_0x13
	RCALL __ANEGF1
	MOVW R26,R0
	RCALL __CMPF12
	BRSH _0x60004
	MOVW R26,R16
	ADIW R26,36
	RCALL SUBOPT_0x11
	RCALL __ANEGF1
	RCALL SUBOPT_0x14
; 0003 001A 
; 0003 001B pid->Derivative = (pid->Error - pid->Last_Error) / dt;
_0x60004:
	RCALL SUBOPT_0x12
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	MOVW R30,R16
	__GETD2Z 24
	POP  R30
	POP  R31
	POP  R22
	POP  R23
	RCALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x5
	RCALL __DIVF21
	__PUTD1RNS 16,20
; 0003 001C pid->Output = pid->Kp * pid->Error + pid->Ki * pid->Integral + pid->Kd * pid->Derivative;
	MOVW R26,R16
	RCALL SUBOPT_0x11
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R16
	ADIW R26,12
	RCALL SUBOPT_0x11
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	__GETD2Z 4
	MOVW R0,R26
	MOVW R26,R16
	ADIW R26,16
	RCALL SUBOPT_0x11
	MOVW R26,R0
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	__GETD2Z 8
	MOVW R0,R26
	MOVW R26,R16
	ADIW R26,20
	RCALL SUBOPT_0x11
	MOVW R26,R0
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	RCALL SUBOPT_0x15
; 0003 001D 
; 0003 001E if (pid->Output > pid->Output_Limit) pid->Output = pid->Output_Limit;
	RCALL SUBOPT_0x16
	MOVW R26,R0
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x60005
	MOVW R26,R16
	ADIW R26,40
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x15
; 0003 001F if (pid->Output < -pid->Output_Limit) pid->Output = -pid->Output_Limit;
_0x60005:
	RCALL SUBOPT_0x16
	RCALL __ANEGF1
	MOVW R26,R0
	RCALL __CMPF12
	BRSH _0x60006
	MOVW R26,R16
	ADIW R26,40
	RCALL SUBOPT_0x11
	RCALL __ANEGF1
	RCALL SUBOPT_0x15
; 0003 0020 
; 0003 0021 pid->Last_Error = pid->Error;
_0x60006:
	MOVW R26,R16
	ADIW R26,12
	RCALL SUBOPT_0x11
	__PUTD1RNS 16,24
; 0003 0022 return pid->Output;
	MOVW R26,R16
	ADIW R26,32
	RCALL SUBOPT_0x11
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080001
; 0003 0023 }
; .FEND

	.CSEG
_xatan:
; .FSTART _xatan
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x19
	__GETD2N 0x40CBD065
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x19
	__GETD2N 0x41296D00
	RCALL __ADDF12
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	RCALL __PUTPARD2
	RCALL SUBOPT_0x1B
	__GETD1N 0x3ED413CD
	RCALL __CMPF12
	BRSH _0x2000020
	RCALL SUBOPT_0x1B
	RCALL _xatan
	RJMP _0x2080002
_0x2000020:
	RCALL SUBOPT_0x1B
	__GETD1N 0x401A827A
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	__GETD2N 0x3FC90FDB
	RCALL __SWAPD12
	RCALL __SUBF12
	RJMP _0x2080002
_0x2000021:
	RCALL SUBOPT_0x1C
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1C
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x1D
	__GETD2N 0x3F490FDB
	RCALL __ADDF12
_0x2080002:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	RCALL SUBOPT_0x17
	__CPD10
	BRNE _0x200002D
	__GETD1S 8
	__CPD10
	BRNE _0x200002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x2080001
_0x200002E:
	RCALL SUBOPT_0x1E
	RCALL __CPD02
	BRGE _0x200002F
	__GETD1N 0x3FC90FDB
	RJMP _0x2080001
_0x200002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x2080001
_0x200002D:
	__GETD1S 4
	RCALL SUBOPT_0x1E
	RCALL __DIVF21
	RCALL SUBOPT_0x4
	__GETD2S 4
	RCALL __CPD02
	BRGE _0x2000030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000031
	RCALL SUBOPT_0x1B
	RCALL _yatan
	RJMP _0x2080001
_0x2000031:
	RCALL SUBOPT_0x1F
	RCALL __ANEGF1
	RJMP _0x2080001
_0x2000030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000032
	RCALL SUBOPT_0x1F
	__GETD2N 0x40490FDB
	RCALL __SWAPD12
	RCALL __SUBF12
	RJMP _0x2080001
_0x2000032:
	RCALL SUBOPT_0x1B
	RCALL _yatan
	__GETD2N 0xC0490FDB
	RCALL __ADDF12
_0x2080001:
	ADIW R28,12
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_g_flag_compute:
	.BYTE 0x1
_g_pid:
	.BYTE 0x2C
_counter_S0000002000:
	.BYTE 0x1
_g_alpha_G002:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_g_pid)
	LDI  R31,HIGH(_g_pid)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	RCALL __PUTPARD1
	__GETD1N 0x0
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETD2N 0x3C23D70A
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _Motor_PwmValue_G001
	MOVW R16,R30
	LDD  R26,Y+3
	TST  R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	RCALL _i2c_delay_G002
	CBI  0x7,5
	RCALL _i2c_delay_G002
	SBI  0x7,5
	RJMP _i2c_delay_G002

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	RCALL _i2c_stop_G002
	RCALL _i2c_start_G002
	LDI  R26,LOW(208)
	RJMP _i2c_write_G002

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	RCALL _i2c_write_G002
	LDI  R26,LOW(0)
	RCALL _i2c_write_G002
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	__CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	ADIW R26,12
	__GETD1P_INC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	__PUTD1SNS 30,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	__GETD2Z 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDS  R26,_g_alpha_G002
	LDS  R27,_g_alpha_G002+1
	LDS  R24,_g_alpha_G002+2
	LDS  R25,_g_alpha_G002+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xF:
	__PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x11:
	__GETD1P_INC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOVW R30,R16
	__GETD2Z 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	MOVW R30,R16
	RCALL SUBOPT_0xD
	MOVW R0,R26
	MOVW R26,R16
	ADIW R26,36
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	__PUTD1RNS 16,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	__PUTD1RNS 16,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	MOVW R30,R16
	__GETD2Z 32
	MOVW R0,R26
	MOVW R26,R16
	ADIW R26,40
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	RCALL __PUTPARD2
	SBIW R28,4
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	__GETD2S 4
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x19:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	RCALL __MULF12
	__GETD2N 0x414A8F4E
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x19
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	RCALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RJMP _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x19
	RCALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RJMP _yatan

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	MOVW R20,R18
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

;END OF CODE MARKER
__END_OF_CODE:
