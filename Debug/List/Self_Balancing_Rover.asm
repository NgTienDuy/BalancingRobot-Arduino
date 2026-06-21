
;CodeVisionAVR C Compiler V4.06a 
;(C) Copyright 1998-2025 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16.000000 MHz
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
	JMP  _timer2_compa_isr
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
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x4B,0x70,0x2A,0x31,0x30,0x3D,0x0,0x20
	.DB  0x4B,0x69,0x2A,0x31,0x30,0x3D,0x0,0x20
	.DB  0x4B,0x64,0x2A,0x31,0x30,0x3D,0x0,0x20
	.DB  0x53,0x70,0x2A,0x31,0x30,0x3D,0x0,0xD
	.DB  0xA,0x0,0xD,0xA,0x42,0x4F,0x4F,0x54
	.DB  0x2E,0x2E,0x2E,0xD,0xA,0x0,0x4D,0x50
	.DB  0x55,0x20,0x4F,0x4B,0x2C,0x20,0x57,0x48
	.DB  0x4F,0x5F,0x41,0x4D,0x5F,0x49,0x3D,0x30
	.DB  0x78,0x0,0x20,0x28,0x30,0x78,0x36,0x38
	.DB  0x3D,0x4D,0x50,0x55,0x36,0x30,0x35,0x30
	.DB  0x2C,0x20,0x31,0x31,0x32,0x3D,0x30,0x78
	.DB  0x37,0x30,0x3D,0x4D,0x50,0x55,0x36,0x35
	.DB  0x30,0x30,0x20,0x63,0x6C,0x6F,0x6E,0x65
	.DB  0x20,0x2D,0x20,0x64,0x65,0x75,0x20,0x4F
	.DB  0x4B,0x29,0xD,0xA,0x0,0x4D,0x50,0x55
	.DB  0x20,0x4E,0x4F,0x54,0x20,0x46,0x4F,0x55
	.DB  0x4E,0x44,0x20,0x2D,0x20,0x63,0x68,0x65
	.DB  0x63,0x6B,0x20,0x77,0x69,0x72,0x69,0x6E
	.DB  0x67,0x21,0xD,0xA,0x0,0x43,0x61,0x6C
	.DB  0x69,0x62,0x72,0x61,0x74,0x69,0x6E,0x67
	.DB  0x20,0x67,0x79,0x72,0x6F,0x20,0x2D,0x20
	.DB  0x47,0x49,0x55,0x20,0x58,0x45,0x20,0x59
	.DB  0x45,0x4E,0x20,0x7E,0x32,0x73,0x2E,0x2E
	.DB  0x2E,0xD,0xA,0x0,0x43,0x61,0x6C,0x69
	.DB  0x62,0x20,0x64,0x6F,0x6E,0x65,0xD,0xA
	.DB  0x0,0x42,0x4F,0x4F,0x54,0x20,0x4F,0x4B
	.DB  0xD,0xA,0x0,0x61,0x3D,0x0,0x20,0x6F
	.DB  0x3D,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _0x23
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x23+7
	.DW  _0x0*2+7

	.DW  0x08
	.DW  _0x23+15
	.DW  _0x0*2+15

	.DW  0x08
	.DW  _0x23+23
	.DW  _0x0*2+23

	.DW  0x03
	.DW  _0x23+31
	.DW  _0x0*2+31

	.DW  0x0C
	.DW  _0x27
	.DW  _0x0*2+34

	.DW  0x14
	.DW  _0x27+12
	.DW  _0x0*2+46

	.DW  0x33
	.DW  _0x27+32
	.DW  _0x0*2+66

	.DW  0x20
	.DW  _0x27+83
	.DW  _0x0*2+117

	.DW  0x27
	.DW  _0x27+115
	.DW  _0x0*2+149

	.DW  0x0D
	.DW  _0x27+154
	.DW  _0x0*2+188

	.DW  0x0A
	.DW  _0x27+167
	.DW  _0x0*2+201

	.DW  0x03
	.DW  _0x27+177
	.DW  _0x0*2+211

	.DW  0x04
	.DW  _0x27+180
	.DW  _0x0*2+214

	.DW  0x03
	.DW  _0x27+184
	.DW  _0x0*2+31

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
;static void timer2_init_100hz(void)
; 0000 0027 {

	.CSEG
_timer2_init_100hz_G000:
; .FSTART _timer2_init_100hz_G000
; 0000 0028 /* CTC mode (WGM21=1), prescaler 1024, OCR2A=155
; 0000 0029 f = F_CPU/(1024*(155+1)) = 100.16 Hz */
; 0000 002A TCCR2A = (1 << WGM21);
	LDI  R30,LOW(2)
	STS  176,R30
; 0000 002B TCCR2B = (1 << CS22) | (1 << CS21) | (1 << CS20);
	LDI  R30,LOW(7)
	STS  177,R30
; 0000 002C OCR2A  = 155;
	LDI  R30,LOW(155)
	STS  179,R30
; 0000 002D TIMSK2 = (1 << OCIE2A);
	LDI  R30,LOW(2)
	STS  112,R30
; 0000 002E }
	RET
; .FEND
;static void poll_uart_tuning(void)
; 0000 0032 {
_poll_uart_tuning_G000:
; .FSTART _poll_uart_tuning_G000
; 0000 0033 static char          line[16];
; 0000 0034 static unsigned char idx = 0;
; 0000 0035 char c;
; 0000 0036 
; 0000 0037 while (uart_available())
	ST   -Y,R17
;	c -> R17
_0x3:
	RCALL _uart_available
	CPI  R30,0
	BRNE PC+2
	RJMP _0x5
; 0000 0038 {
; 0000 0039 c = uart_get();
	RCALL _uart_get
	MOV  R17,R30
; 0000 003A if (c == '\r') continue;
	CPI  R17,13
	BREQ _0x3
; 0000 003B 
; 0000 003C if (c == '\n')
	CPI  R17,10
	BREQ PC+2
	RJMP _0x7
; 0000 003D {
; 0000 003E line[idx] = 0;
	LDS  R30,_idx_S0000001000
	LDI  R31,0
	SUBI R30,LOW(-_line_S0000001000)
	SBCI R31,HIGH(-_line_S0000001000)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 003F if (idx >= 1)
	LDS  R26,_idx_S0000001000
	CPI  R26,LOW(0x1)
	BRSH PC+2
	RJMP _0x8
; 0000 0040 {
; 0000 0041 char          cmd = line[0];
; 0000 0042 long          val = 0;
; 0000 0043 unsigned char i   = 1;
; 0000 0044 unsigned char neg = 0;
; 0000 0045 
; 0000 0046 while (line[i] == ' ') i++;
	SBIW R28,7
	LDI  R30,LOW(0)
	ST   Y,R30
	LDI  R30,LOW(1)
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
;	cmd -> Y+6
;	val -> Y+2
;	i -> Y+1
;	neg -> Y+0
	LDS  R30,_line_S0000001000
	STD  Y+6,R30
_0x9:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x20)
	BRNE _0xB
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x9
_0xB:
; 0000 0047 if (line[i] == '-') { neg = 1; i++; }
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x2D)
	BRNE _0xC
	LDI  R30,LOW(1)
	ST   Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
; 0000 0048 while (line[i] >= '0' && line[i] <= '9')
_0xC:
_0xD:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x30)
	BRLO _0x10
	LD   R26,Z
	CPI  R26,LOW(0x3A)
	BRLO _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 0049 { val = val * 10 + (line[i] - '0'); i++; }
	RCALL SUBOPT_0x1
	__GETD2N 0xA
	RCALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_line_S0000001000)
	SBCI R31,HIGH(-_line_S0000001000)
	LD   R30,Z
	LDI  R31,0
	SBIW R30,48
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0xD
_0xF:
; 0000 004A if (neg) val = -val;
	LD   R30,Y
	CPI  R30,0
	BREQ _0x12
	RCALL SUBOPT_0x1
	RCALL __ANEGD1
	RCALL SUBOPT_0x3
; 0000 004B 
; 0000 004C switch (cmd)
_0x12:
	LDD  R30,Y+6
	LDI  R31,0
; 0000 004D {
; 0000 004E case 'P': case 'p': pid.Kp = val / 10.0f; break;
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BREQ _0x17
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x18
_0x17:
	RCALL SUBOPT_0x4
	STS  _pid,R30
	STS  _pid+1,R31
	STS  _pid+2,R22
	STS  _pid+3,R23
	RJMP _0x15
; 0000 004F case 'I': case 'i': pid.Ki = val / 10.0f; break;
_0x18:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BREQ _0x1A
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x1B
_0x1A:
	RCALL SUBOPT_0x4
	__PUTD1MN _pid,4
	RJMP _0x15
; 0000 0050 case 'D': case 'd': pid.Kd = val / 10.0f; break;
_0x1B:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BREQ _0x1D
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x1E
_0x1D:
	RCALL SUBOPT_0x4
	__PUTD1MN _pid,8
	RJMP _0x15
; 0000 0051 case 'S': case 's': pid.setpoint = val / 10.0f; break;
_0x1E:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BREQ _0x20
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x21
_0x20:
	RCALL SUBOPT_0x4
	__PUTD1MN _pid,12
	RJMP _0x15
; 0000 0052 case '?':
_0x21:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0x24
; 0000 0053 uart_puts("Kp*10="); uart_put_int((long)(pid.Kp * 10));
	__POINTW2MN _0x23,0
	RCALL _uart_puts
	LDS  R26,_pid
	LDS  R27,_pid+1
	LDS  R24,_pid+2
	LDS  R25,_pid+3
	RCALL SUBOPT_0x5
; 0000 0054 uart_puts(" Ki*10="); uart_put_int((long)(pid.Ki * 10));
	__POINTW2MN _0x23,7
	RCALL _uart_puts
	__GETD2MN _pid,4
	RCALL SUBOPT_0x5
; 0000 0055 uart_puts(" Kd*10="); uart_put_int((long)(pid.Kd * 10));
	__POINTW2MN _0x23,15
	RCALL _uart_puts
	__GETD2MN _pid,8
	RCALL SUBOPT_0x5
; 0000 0056 uart_puts(" Sp*10="); uart_put_int((long)(pid.setpoint * 10));
	__POINTW2MN _0x23,23
	RCALL _uart_puts
	__GETD2MN _pid,12
	RCALL SUBOPT_0x5
; 0000 0057 uart_puts("\r\n");
	__POINTW2MN _0x23,31
	RCALL _uart_puts
; 0000 0058 break;
; 0000 0059 default: break;
_0x24:
; 0000 005A }
_0x15:
; 0000 005B }
	ADIW R28,7
; 0000 005C idx = 0;
_0x8:
	LDI  R30,LOW(0)
	STS  _idx_S0000001000,R30
; 0000 005D }
; 0000 005E else if (idx < sizeof(line) - 1)
	RJMP _0x25
_0x7:
	LDS  R26,_idx_S0000001000
	CPI  R26,LOW(0xF)
	BRSH _0x26
; 0000 005F {
; 0000 0060 line[idx++] = c;
	LDS  R30,_idx_S0000001000
	SUBI R30,-LOW(1)
	STS  _idx_S0000001000,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_line_S0000001000)
	SBCI R31,HIGH(-_line_S0000001000)
	ST   Z,R17
; 0000 0061 }
; 0000 0062 }
_0x26:
_0x25:
	RJMP _0x3
_0x5:
; 0000 0063 }
	JMP  _0x2080005
; .FEND

	.DSEG
_0x23:
	.BYTE 0x22
;void main(void)
; 0000 0066 {

	.CSEG
_main:
; .FSTART _main
; 0000 0067 float         angle;
; 0000 0068 int           out;
; 0000 0069 unsigned char fallen = 0;
; 0000 006A unsigned char tel    = 0;
; 0000 006B 
; 0000 006C DDRB |= (1 << 5);          /* LED */
	SBIW R28,4
;	angle -> Y+0
;	out -> R16,R17
;	fallen -> R19
;	tel -> R18
	LDI  R19,0
	LDI  R18,0
	SBI  0x4,5
; 0000 006D uart_init();
	RCALL _uart_init
; 0000 006E Motor_Init();
	RCALL _Motor_Init
; 0000 006F Motor_Stop();
	RCALL _Motor_Stop
; 0000 0070 
; 0000 0071 uart_puts("\r\nBOOT...\r\n");
	__POINTW2MN _0x27,0
	RCALL _uart_puts
; 0000 0072 
; 0000 0073 if (MPU6050_Init())
	RCALL _MPU6050_Init
	CPI  R30,0
	BREQ _0x28
; 0000 0074 {
; 0000 0075 uart_puts("MPU OK, WHO_AM_I=0x");
	__POINTW2MN _0x27,12
	RCALL _uart_puts
; 0000 0076 uart_put_int((long)MPU6050_WhoAmI());   /* in dang decimal cho gon  */
	RCALL _MPU6050_WhoAmI
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RCALL _uart_put_int
; 0000 0077 uart_puts(" (0x68=MPU6050, 112=0x70=MPU6500 clone - deu OK)\r\n");
	__POINTW2MN _0x27,32
	RCALL _uart_puts
; 0000 0078 }
; 0000 0079 else
	RJMP _0x29
_0x28:
; 0000 007A {
; 0000 007B uart_puts("MPU NOT FOUND - check wiring!\r\n");
	__POINTW2MN _0x27,83
	RCALL _uart_puts
; 0000 007C while (1) { LED_TGL(); delay_ms(120); }    /* nhay nhanh = loi sensor */
_0x2A:
	RCALL SUBOPT_0x6
	LDI  R26,LOW(120)
	LDI  R27,0
	RCALL _delay_ms
	RJMP _0x2A
; 0000 007D }
_0x29:
; 0000 007E 
; 0000 007F uart_puts("Calibrating gyro - GIU XE YEN ~2s...\r\n");
	__POINTW2MN _0x27,115
	RCALL _uart_puts
; 0000 0080 LED_ON();
	SBI  0x5,5
; 0000 0081 MPU6050_CalibrateGyro();
	RCALL _MPU6050_CalibrateGyro
; 0000 0082 LED_OFF();
	CBI  0x5,5
; 0000 0083 uart_puts("Calib done\r\n");
	__POINTW2MN _0x27,154
	RCALL _uart_puts
; 0000 0084 
; 0000 0085 Filter_Init(&filt, COMP_ALPHA);
	RCALL SUBOPT_0x7
	__GETD2N 0x3F7AE148
	RCALL _Filter_Init
; 0000 0086 PID_Init(&pid, PID_KP_INIT, PID_KI_INIT, PID_KD_INIT,
; 0000 0087 PID_I_LIMIT, PID_OUT_LIMIT, PID_SETPOINT_INIT);
	RCALL SUBOPT_0x8
	__GETD1N 0x41700000
	RCALL __PUTPARD1
	RCALL SUBOPT_0x9
	RCALL __PUTPARD1
	__GETD1N 0x3F19999A
	RCALL __PUTPARD1
	__GETD1N 0x43160000
	RCALL __PUTPARD1
	__GETD1N 0x437F0000
	RCALL __PUTPARD1
	__GETD2N 0x0
	RCALL _PID_Init
; 0000 0088 
; 0000 0089 timer2_init_100hz();
	RCALL _timer2_init_100hz_G000
; 0000 008A #asm("sei")
	SEI
; 0000 008B 
; 0000 008C uart_puts("BOOT OK\r\n");
	__POINTW2MN _0x27,167
	RCALL _uart_puts
; 0000 008D 
; 0000 008E #if DEBUG_SENSOR_CHECK
; 0000 008F /* ---- Che do kiem tra cam bien: stream raw, MOTOR TAT ---- */
; 0000 0090 while (1)
; 0000 0091 {
; 0000 0092 if (g_tick)
; 0000 0093 {
; 0000 0094 g_tick = 0;
; 0000 0095 MPU6050_Read(&imu);
; 0000 0096 uart_puts("ax=");  uart_put_int(imu.ax);
; 0000 0097 uart_puts(" ay="); uart_put_int(imu.ay);
; 0000 0098 uart_puts(" az="); uart_put_int(imu.az);
; 0000 0099 uart_puts(" gx="); uart_put_int(imu.gx);
; 0000 009A uart_puts(" gy="); uart_put_int(imu.gy);
; 0000 009B uart_puts(" gz="); uart_put_int(imu.gz);
; 0000 009C uart_puts(" ang*10="); uart_put_int((long)(imu.angle_acc * 10));
; 0000 009D uart_puts("\r\n");
; 0000 009E LED_TGL();
; 0000 009F }
; 0000 00A0 }
; 0000 00A1 #else
; 0000 00A2 /* ---- Firmware can bang ---- */
; 0000 00A3 while (1)
_0x2D:
; 0000 00A4 {
; 0000 00A5 poll_uart_tuning();
	RCALL _poll_uart_tuning_G000
; 0000 00A6 
; 0000 00A7 if (g_tick)
	LDS  R30,_g_tick
	CPI  R30,0
	BRNE PC+2
	RJMP _0x30
; 0000 00A8 {
; 0000 00A9 g_tick = 0;
	LDI  R30,LOW(0)
	STS  _g_tick,R30
; 0000 00AA out = 0;
	__GETWRN 16,17,0
; 0000 00AB 
; 0000 00AC MPU6050_Read(&imu);
	LDI  R26,LOW(_imu)
	LDI  R27,HIGH(_imu)
	RCALL _MPU6050_Read
; 0000 00AD angle = Filter_Update(&filt, imu.angle_acc, imu.gyro_rate, SAMPLE_DT);
	RCALL SUBOPT_0x7
	__GETD1MN _imu,12
	RCALL __PUTPARD1
	__GETD1MN _imu,16
	RCALL SUBOPT_0xA
	RCALL _Filter_Update
	RCALL SUBOPT_0xB
; 0000 00AE 
; 0000 00AF if (angle > FALL_ANGLE || angle < -FALL_ANGLE)
	RCALL SUBOPT_0xC
	__GETD1N 0x42200000
	RCALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x32
	RCALL SUBOPT_0xC
	__GETD1N 0xC2200000
	RCALL __CMPF12
	BRSH _0x31
_0x32:
; 0000 00B0 {
; 0000 00B1 if (!fallen) { Motor_Stop(); PID_Reset(&pid); fallen = 1; }
	CPI  R19,0
	BRNE _0x34
	RCALL _Motor_Stop
	LDI  R26,LOW(_pid)
	LDI  R27,HIGH(_pid)
	RCALL _PID_Reset
	LDI  R19,LOW(1)
; 0000 00B2 LED_ON();                              /* sang lien = da nga */
_0x34:
	SBI  0x5,5
; 0000 00B3 }
; 0000 00B4 else
	RJMP _0x35
_0x31:
; 0000 00B5 {
; 0000 00B6 fallen = 0;
	LDI  R19,LOW(0)
; 0000 00B7 out = (int)(OUTPUT_SIGN * PID_Compute(&pid, angle, SAMPLE_DT));
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xA
	RCALL _PID_Compute
	RCALL SUBOPT_0xD
	RCALL __MULF12
	RCALL __CFD1
	MOVW R16,R30
; 0000 00B8 Motor_SetDuty(out, out);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R16
	RCALL _Motor_SetDuty
; 0000 00B9 }
_0x35:
; 0000 00BA 
; 0000 00BB /* telemetry ~20Hz de khong nghen UART */
; 0000 00BC if (++tel >= 5)
	SUBI R18,-LOW(1)
	CPI  R18,5
	BRLO _0x36
; 0000 00BD {
; 0000 00BE tel = 0;
	LDI  R18,LOW(0)
; 0000 00BF LED_TGL();
	RCALL SUBOPT_0x6
; 0000 00C0 uart_puts("a="); uart_put_int((long)(angle * 10));   /* deg*10 */
	__POINTW2MN _0x27,177
	RCALL _uart_puts
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x5
; 0000 00C1 uart_puts(" o="); uart_put_int(out);
	__POINTW2MN _0x27,180
	RCALL _uart_puts
	RCALL SUBOPT_0xE
	RCALL _uart_put_int
; 0000 00C2 uart_puts("\r\n");
	__POINTW2MN _0x27,184
	RCALL _uart_puts
; 0000 00C3 }
; 0000 00C4 }
_0x36:
; 0000 00C5 }
_0x30:
	RJMP _0x2D
; 0000 00C6 #endif
; 0000 00C7 }
_0x37:
	RJMP _0x37
; .FEND

	.DSEG
_0x27:
	.BYTE 0xBB
;interrupt [8] void timer2_compa_isr(void)
; 0000 00CA {

	.CSEG
_timer2_compa_isr:
; .FSTART _timer2_compa_isr
	ST   -Y,R30
; 0000 00CB g_tick = 1;
	LDI  R30,LOW(1)
	STS  _g_tick,R30
; 0000 00CC }
	LD   R30,Y+
	RETI
; .FEND
;void Filter_Init(CompFilter *f, float alpha)
; 0001 0008 {

	.CSEG
_Filter_Init:
; .FSTART _Filter_Init
; 0001 0009 f->angle = 0.0f;
	RCALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
	__GETWRS 16,17,6
;	*f -> R16,R17
;	alpha -> Y+2
	MOVW R26,R16
	RCALL SUBOPT_0xF
; 0001 000A f->alpha = alpha;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x10
; 0001 000B f->init  = 0;
	MOVW R26,R16
	ADIW R26,8
	RCALL SUBOPT_0x11
; 0001 000C }
	JMP  _0x2080003
; .FEND
;float Filter_Update(CompFilter *f, float acc_angle, float gyro_rate, float dt)
; 0001 000F {
_Filter_Update:
; .FSTART _Filter_Update
; 0001 0010 if (!f->init)
	RCALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
	__GETWRS 16,17,14
;	*f -> R16,R17
;	acc_angle -> Y+10
;	gyro_rate -> Y+6
;	dt -> Y+2
	MOVW R30,R16
	LDD  R30,Z+8
	CPI  R30,0
	BRNE _0x20003
; 0001 0011 {
; 0001 0012 f->angle = acc_angle;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
; 0001 0013 f->init  = 1;
	MOVW R26,R16
	ADIW R26,8
	LDI  R30,LOW(1)
	ST   X,R30
; 0001 0014 return f->angle;
	RJMP _0x2080008
; 0001 0015 }
; 0001 0016 
; 0001 0017 f->angle = f->alpha * (f->angle + gyro_rate * dt) +
_0x20003:
; 0001 0018 (1.0f - f->alpha) * acc_angle;
	RCALL SUBOPT_0x14
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0x15
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1
	__GETD2S 6
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R16
	ADIW R26,4
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0xD
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x17
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	RCALL SUBOPT_0x13
; 0001 0019 return f->angle;
_0x2080008:
	MOVW R26,R16
	RCALL SUBOPT_0x16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,16
	RET
; 0001 001A }
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
;static unsigned int clamp_duty(int d)
; 0002 0012 {

	.CSEG
_clamp_duty_G002:
; .FSTART _clamp_duty_G002
; 0002 0013 if (d < 0) d = -d;
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	d -> R16,R17
	TST  R17
	BRPL _0x40003
	MOVW R30,R16
	RCALL __ANEGW1
	MOVW R16,R30
; 0002 0014 if (d > MOTOR_MAX_DUTY) d = MOTOR_MAX_DUTY;
_0x40003:
	__CPWRN 16,17,256
	BRLT _0x40004
	__GETWRN 16,17,255
; 0002 0015 if (d != 0 && d < MOTOR_DEADBAND) d = MOTOR_DEADBAND;
_0x40004:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BREQ _0x40006
	__CPWRN 16,17,30
	BRLT _0x40007
_0x40006:
	RJMP _0x40005
_0x40007:
	__GETWRN 16,17,30
; 0002 0016 return (unsigned int)d;
_0x40005:
	MOVW R30,R16
	JMP  _0x2080006
; 0002 0017 }
; .FEND
;void Motor_Init(void)
; 0002 001A {
_Motor_Init:
; .FSTART _Motor_Init
; 0002 001B /* IN1=PD2, IN2=PD4, IN3=PD7 = output */
; 0002 001C DDRD |= (1 << 2) | (1 << 4) | (1 << 7);
	IN   R30,0xA
	ORI  R30,LOW(0x94)
	OUT  0xA,R30
; 0002 001D /* IN4=PB0, ENA=PB1(OC1A), ENB=PB2(OC1B) = output */
; 0002 001E DDRB |= (1 << 0) | (1 << 1) | (1 << 2);
	IN   R30,0x4
	ORI  R30,LOW(0x7)
	OUT  0x4,R30
; 0002 001F 
; 0002 0020 /* Fast PWM mode 14: WGM13:12:11:10 = 1110, TOP=ICR1, non-inverting */
; 0002 0021 TCCR1A = (1 << COM1A1) | (1 << COM1B1) | (1 << WGM11);
	LDI  R30,LOW(162)
	STS  128,R30
; 0002 0022 TCCR1B = (1 << WGM13)  | (1 << WGM12)  | (1 << CS10);   /* prescaler 1 */
	LDI  R30,LOW(25)
	STS  129,R30
; 0002 0023 
; 0002 0024 /* TOP = ICR1 = PWM_TOP (ghi HIGH truoc, LOW sau) */
; 0002 0025 ICR1H = (unsigned char)(PWM_TOP >> 8);
	LDI  R30,LOW(0)
	STS  135,R30
; 0002 0026 ICR1L = (unsigned char)(PWM_TOP & 0xFF);
	LDI  R30,LOW(255)
	STS  134,R30
; 0002 0027 
; 0002 0028 OCR1AH = 0; OCR1AL = 0;
	RCALL SUBOPT_0x18
; 0002 0029 OCR1BH = 0; OCR1BL = 0;
; 0002 002A }
	RET
; .FEND
;static void set_left(int speed)
; 0002 002E {
_set_left_G002:
; .FSTART _set_left_G002
; 0002 002F unsigned int duty = clamp_duty(speed);
; 0002 0030 if (speed >= 0) { PORTD.2 = 1; PORTD.4 = 0; }
	RCALL SUBOPT_0x19
;	speed -> Y+2
;	duty -> R16,R17
	BRMI _0x40008
	SBI  0xB,2
	CBI  0xB,4
; 0002 0031 else            { PORTD.2 = 0; PORTD.4 = 1; }
	RJMP _0x4000D
_0x40008:
	CBI  0xB,2
	SBI  0xB,4
_0x4000D:
; 0002 0032 OCR1AH = (unsigned char)(duty >> 8);
	STS  137,R17
; 0002 0033 OCR1AL = (unsigned char)(duty & 0xFF);
	MOV  R30,R16
	STS  136,R30
; 0002 0034 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2080002
; .FEND
;static void set_right(int speed)
; 0002 0038 {
_set_right_G002:
; .FSTART _set_right_G002
; 0002 0039 unsigned int duty = clamp_duty(speed);
; 0002 003A if (speed >= 0) { PORTD.7 = 1; PORTB.0 = 0; }
	RCALL SUBOPT_0x19
;	speed -> Y+2
;	duty -> R16,R17
	BRMI _0x40012
	SBI  0xB,7
	CBI  0x5,0
; 0002 003B else            { PORTD.7 = 0; PORTB.0 = 1; }
	RJMP _0x40017
_0x40012:
	CBI  0xB,7
	SBI  0x5,0
_0x40017:
; 0002 003C OCR1BH = (unsigned char)(duty >> 8);
	STS  139,R17
; 0002 003D OCR1BL = (unsigned char)(duty & 0xFF);
	MOV  R30,R16
	STS  138,R30
; 0002 003E }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2080002
; .FEND
;void Motor_SetDuty(int left, int right)
; 0002 0041 {
_Motor_SetDuty:
; .FSTART _Motor_SetDuty
; 0002 0042 /* can chinh toc do 2 dong co (xem MOTOR_L_SCALE / MOTOR_R_SCALE) */
; 0002 0043 set_left ((int)((long)left  * MOTOR_L_SCALE / 100));
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
;	left -> R18,R19
;	right -> R16,R17
	MOVW R26,R18
	__CWD2
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	RCALL _set_left_G002
; 0002 0044 set_right((int)((long)right * MOTOR_R_SCALE / 100));
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	RCALL _set_right_G002
; 0002 0045 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;void Motor_Stop(void)
; 0002 0048 {
_Motor_Stop:
; .FSTART _Motor_Stop
; 0002 0049 OCR1AH = 0; OCR1AL = 0;
	RCALL SUBOPT_0x18
; 0002 004A OCR1BH = 0; OCR1BL = 0;
; 0002 004B PORTD.2 = 0; PORTD.4 = 0; PORTD.7 = 0; PORTB.0 = 0;
	CBI  0xB,2
	CBI  0xB,4
	CBI  0xB,7
	CBI  0x5,0
; 0002 004C }
	RET
; .FEND
; 0003 000B float i_limit, float out_limit, float setpoint)
;float i_limit, float out_limit, float setpoint)
; 0003 000C {

	.CSEG
_PID_Init:
; .FSTART _PID_Init
; 0003 000D p->Kp = Kp; p->Ki = Ki; p->Kd = Kd;
	RCALL __PUTPARD2
	ST   -Y,R17
	ST   -Y,R16
	__GETWRS 16,17,26
;	*p -> R16,R17
;	Kp -> Y+22
;	Ki -> Y+18
;	Kd -> Y+14
;	i_limit -> Y+10
;	out_limit -> Y+6
;	setpoint -> Y+2
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x1E
	__PUTD1RNS 16,8
; 0003 000E p->setpoint   = setpoint;
	RCALL SUBOPT_0x1
	__PUTD1RNS 16,12
; 0003 000F p->integral   = 0.0f;
	MOVW R26,R16
	ADIW R26,16
	RCALL SUBOPT_0xF
; 0003 0010 p->prev_meas  = 0.0f;
	MOVW R26,R16
	ADIW R26,20
	RCALL SUBOPT_0xF
; 0003 0011 p->deriv_filt = 0.0f;
	MOVW R26,R16
	ADIW R26,24
	RCALL SUBOPT_0xF
; 0003 0012 p->i_limit    = i_limit;
	RCALL SUBOPT_0x12
	__PUTD1RNS 16,28
; 0003 0013 p->out_limit  = out_limit;
	RCALL SUBOPT_0x1F
	__PUTD1RNS 16,32
; 0003 0014 p->init       = 0;
	MOVW R26,R16
	ADIW R26,36
	RCALL SUBOPT_0x11
; 0003 0015 }
	ADIW R28,28
	RET
; .FEND
;void PID_Reset(PID_Controller *p)
; 0003 0018 {
_PID_Reset:
; .FSTART _PID_Reset
; 0003 0019 p->integral   = 0.0f;
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*p -> R16,R17
	ADIW R26,16
	RCALL SUBOPT_0xF
; 0003 001A p->deriv_filt = 0.0f;
	MOVW R26,R16
	ADIW R26,24
	RCALL SUBOPT_0xF
; 0003 001B p->init       = 0;
	MOVW R26,R16
	ADIW R26,36
	LDI  R30,LOW(0)
	ST   X,R30
; 0003 001C }
	JMP  _0x2080006
; .FEND
;float PID_Compute(PID_Controller *p, float measurement, float dt)
; 0003 001F {
_PID_Compute:
; .FSTART _PID_Compute
; 0003 0020 float error = p->setpoint - measurement;
; 0003 0021 float deriv, out;
; 0003 0022 
; 0003 0023 /* I + anti-windup */
; 0003 0024 p->integral += error * dt;
	RCALL __PUTPARD2
	SBIW R28,12
	ST   -Y,R17
	ST   -Y,R16
	__GETWRS 16,17,22
;	*p -> R16,R17
;	measurement -> Y+18
;	dt -> Y+14
;	error -> Y+10
;	deriv -> Y+6
;	out -> Y+2
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 12
	RCALL SUBOPT_0x1D
	RCALL __SWAPD12
	RCALL __SUBF12
	__PUTD1S 10
	MOVW R30,R16
	ADIW R30,16
	PUSH R31
	PUSH R30
	MOVW R26,R30
	RCALL SUBOPT_0x16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x17
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	POP  R26
	POP  R27
	__PUTDP1
; 0003 0025 if (p->integral >  p->i_limit) p->integral =  p->i_limit;
	RCALL SUBOPT_0x20
	MOVW R26,R0
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x60003
	MOVW R26,R16
	ADIW R26,28
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x21
; 0003 0026 if (p->integral < -p->i_limit) p->integral = -p->i_limit;
_0x60003:
	RCALL SUBOPT_0x20
	RCALL __ANEGF1
	MOVW R26,R0
	RCALL __CMPF12
	BRSH _0x60004
	MOVW R26,R16
	ADIW R26,28
	RCALL SUBOPT_0x16
	RCALL __ANEGF1
	RCALL SUBOPT_0x21
; 0003 0027 
; 0003 0028 /* D tren measurement (setpoint coi nhu hang) + low-pass */
; 0003 0029 if (!p->init) { p->prev_meas = measurement; p->init = 1; }
_0x60004:
	MOVW R30,R16
	LDD  R30,Z+36
	CPI  R30,0
	BRNE _0x60005
	RCALL SUBOPT_0x22
	MOVW R26,R16
	ADIW R26,36
	LDI  R30,LOW(1)
	ST   X,R30
; 0003 002A deriv = -(measurement - p->prev_meas) / dt;
_0x60005:
	MOVW R26,R16
	ADIW R26,20
	RCALL SUBOPT_0x16
	__GETD2S 18
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x1E
	RCALL __DIVF21
	__PUTD1S 6
; 0003 002B p->deriv_filt = D_LPF * p->deriv_filt + (1.0f - D_LPF) * deriv;
	MOVW R26,R16
	ADIW R26,24
	RCALL SUBOPT_0x16
	__GETD2N 0x3F333333
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1F
	__GETD2N 0x3E99999A
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	__PUTD1RNS 16,24
; 0003 002C p->prev_meas  = measurement;
	RCALL SUBOPT_0x22
; 0003 002D 
; 0003 002E out = p->Kp * error + p->Ki * p->integral + p->Kd * p->deriv_filt;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x17
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x14
	MOVW R0,R26
	MOVW R26,R16
	ADIW R26,16
	RCALL SUBOPT_0x16
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
	ADIW R26,24
	RCALL SUBOPT_0x16
	MOVW R26,R0
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	RCALL SUBOPT_0x3
; 0003 002F 
; 0003 0030 if (out >  p->out_limit) out =  p->out_limit;
	MOVW R26,R16
	ADIW R26,32
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x23
	BREQ PC+2
	BRCC PC+2
	RJMP _0x60006
	MOVW R26,R16
	ADIW R26,32
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x3
; 0003 0031 if (out < -p->out_limit) out = -p->out_limit;
_0x60006:
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x23
	BRSH _0x60007
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x3
; 0003 0032 return out;
_0x60007:
	RCALL SUBOPT_0x1
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,24
	RET
; 0003 0033 }
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
;void uart_init(void)
; 0004 0009 {

	.CSEG
_uart_init:
; .FSTART _uart_init
; 0004 000A UBRR0H = (unsigned char)(UART_UBRR >> 8);
	LDI  R30,LOW(0)
	STS  197,R30
; 0004 000B UBRR0L = (unsigned char)(UART_UBRR);
	LDI  R30,LOW(25)
	STS  196,R30
; 0004 000C UCSR0A = 0x00;                                  /* U2X0 = 0 */
	LDI  R30,LOW(0)
	STS  192,R30
; 0004 000D UCSR0B = (1 << RXEN0) | (1 << TXEN0);           /* bat RX + TX */
	LDI  R30,LOW(24)
	STS  193,R30
; 0004 000E UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);         /* 8 data, 1 stop, no parity */
	LDI  R30,LOW(6)
	STS  194,R30
; 0004 000F }
	RET
; .FEND
;void uart_tx(char c)
; 0004 0012 {
_uart_tx:
; .FSTART _uart_tx
; 0004 0013 while (!(UCSR0A & (1 << UDRE0)));
	ST   -Y,R17
	MOV  R17,R26
;	c -> R17
_0x80003:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x80003
; 0004 0014 UDR0 = c;
	STS  198,R17
; 0004 0015 }
	JMP  _0x2080005
; .FEND
;void uart_puts(char *s)
; 0004 0018 {
_uart_puts:
; .FSTART _uart_puts
; 0004 0019 while (*s) uart_tx(*s++);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*s -> R16,R17
_0x80006:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x80008
	__ADDWRN 16,17,1
	LD   R26,X
	RCALL _uart_tx
	RJMP _0x80006
_0x80008:
; 0004 001A }
	JMP  _0x2080006
; .FEND
;void uart_put_int(long v)
; 0004 001D {
_uart_put_int:
; .FSTART _uart_put_int
; 0004 001E char buf[12];
; 0004 001F unsigned char i = 0;
; 0004 0020 unsigned long u;
; 0004 0021 
; 0004 0022 if (v < 0) { uart_tx('-'); u = (unsigned long)(-v); }
	RCALL __PUTPARD2
	SBIW R28,16
	ST   -Y,R17
;	v -> Y+17
;	buf -> Y+5
;	i -> R17
;	u -> Y+1
	LDI  R17,0
	LDD  R26,Y+20
	TST  R26
	BRPL _0x80009
	LDI  R26,LOW(45)
	RCALL _uart_tx
	RCALL SUBOPT_0x25
	RCALL __ANEGD1
	RJMP _0x80018
; 0004 0023 else         u = (unsigned long)v;
_0x80009:
	RCALL SUBOPT_0x25
_0x80018:
	__PUTD1S 1
; 0004 0024 
; 0004 0025 if (u == 0) { uart_tx('0'); return; }
	RCALL SUBOPT_0x26
	BRNE _0x8000B
	LDI  R26,LOW(48)
	RCALL _uart_tx
	RJMP _0x2080007
; 0004 0026 
; 0004 0027 while (u) { buf[i++] = (char)('0' + (u % 10)); u /= 10; }
_0x8000B:
_0x8000C:
	RCALL SUBOPT_0x26
	BREQ _0x8000E
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x27
	RCALL __MODD21U
	SUBI R30,-LOW(48)
	POP  R26
	POP  R27
	ST   X,R30
	RCALL SUBOPT_0x27
	RCALL __DIVD21U
	__PUTD1S 1
	RJMP _0x8000C
_0x8000E:
; 0004 0028 while (i)   uart_tx(buf[--i]);
_0x8000F:
	CPI  R17,0
	BREQ _0x80011
	SUBI R17,LOW(1)
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _uart_tx
	RJMP _0x8000F
_0x80011:
; 0004 0029 }
_0x2080007:
	LDD  R17,Y+0
	ADIW R28,21
	RET
; .FEND
;unsigned char uart_available(void)
; 0004 002C {
_uart_available:
; .FSTART _uart_available
; 0004 002D return (UCSR0A & (1 << RXC0)) ? 1 : 0;
	LDS  R30,192
	ANDI R30,LOW(0x80)
	BREQ _0x80012
	LDI  R30,LOW(1)
	RJMP _0x80013
_0x80012:
	LDI  R30,LOW(0)
_0x80013:
	RET
; 0004 002E }
; .FEND
;char uart_get(void)
; 0004 0031 {
_uart_get:
; .FSTART _uart_get
; 0004 0032 while (!(UCSR0A & (1 << RXC0)));
_0x80015:
	LDS  R30,192
	ANDI R30,LOW(0x80)
	BREQ _0x80015
; 0004 0033 return UDR0;
	LDS  R30,198
	RET
; 0004 0034 }
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
;static void mpu_write_reg(unsigned char reg, unsigned char val)
; 0005 0011 {

	.CSEG
_mpu_write_reg_G005:
; .FSTART _mpu_write_reg_G005
; 0005 0012 i2c_start(MPU6050_ADDR_W);
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
;	reg -> R16
;	val -> R17
	RCALL SUBOPT_0x28
; 0005 0013 i2c_write(reg);
; 0005 0014 i2c_write(val);
	MOV  R26,R17
	RCALL _i2c_write
; 0005 0015 i2c_stop();
	RCALL _i2c_stop
; 0005 0016 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
;static unsigned char mpu_read_reg(unsigned char reg)
; 0005 0019 {
_mpu_read_reg_G005:
; .FSTART _mpu_read_reg_G005
; 0005 001A unsigned char v;
; 0005 001B i2c_start(MPU6050_ADDR_W);
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	reg -> R16
;	v -> R17
	RCALL SUBOPT_0x28
; 0005 001C i2c_write(reg);
; 0005 001D i2c_start(MPU6050_ADDR_R);          /* repeated start */
	LDI  R26,LOW(209)
	RCALL _i2c_start
; 0005 001E v = i2c_read_nack();
	RCALL _i2c_read_nack
	MOV  R17,R30
; 0005 001F i2c_stop();
	RCALL _i2c_stop
; 0005 0020 return v;
	MOV  R30,R17
	RJMP _0x2080006
; 0005 0021 }
; .FEND
;unsigned char MPU6050_WhoAmI(void) { return who_id; }
; 0005 0023 unsigned char MPU6050_WhoAmI(void) { return who_id; }
_MPU6050_WhoAmI:
; .FSTART _MPU6050_WhoAmI
	LDS  R30,_who_id_G005
	RET
; .FEND
;unsigned char MPU6050_Init(void)
; 0005 0026 {
_MPU6050_Init:
; .FSTART _MPU6050_Init
; 0005 0027 i2c_init();
	RCALL _i2c_init
; 0005 0028 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0005 0029 
; 0005 002A mpu_write_reg(MPU6050_RA_PWR_MGMT_1,  0x00);  /* wake up                 */
	LDI  R30,LOW(107)
	RCALL SUBOPT_0x29
; 0005 002B delay_ms(10);
; 0005 002C mpu_write_reg(MPU6050_RA_SMPLRT_DIV,  0x09);  /* 1kHz/(1+9) = 100 Hz     */
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RCALL _mpu_write_reg_G005
; 0005 002D mpu_write_reg(MPU6050_RA_CONFIG,      0x03);  /* DLPF ~44Hz (loc nhieu)  */
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _mpu_write_reg_G005
; 0005 002E mpu_write_reg(MPU6050_RA_GYRO_CONFIG, 0x00);  /* +/-250 dps              */
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _mpu_write_reg_G005
; 0005 002F mpu_write_reg(MPU6050_RA_ACCEL_CONFIG,0x00);  /* +/-2g                   */
	LDI  R30,LOW(28)
	RCALL SUBOPT_0x29
; 0005 0030 delay_ms(10);
; 0005 0031 
; 0005 0032 who_id = mpu_read_reg(MPU6050_RA_WHO_AM_I);
	LDI  R26,LOW(117)
	RCALL _mpu_read_reg_G005
	STS  _who_id_G005,R30
; 0005 0033 /* Chap nhan MPU6050(0x68) lan clone MPU6500(0x70)/9250(0x71)...
; 0005 0034 Chi coi la loi khi khong co phan hoi (0x00 hoac 0xFF).               */
; 0005 0035 return (who_id != 0x00 && who_id != 0xFF) ? 1 : 0;
	LDS  R26,_who_id_G005
	CPI  R26,LOW(0x0)
	BREQ _0xA0003
	CPI  R26,LOW(0xFF)
	BRNE _0xA0004
_0xA0003:
	RJMP _0xA0005
_0xA0004:
	LDI  R30,LOW(1)
	RJMP _0xA0006
_0xA0005:
	LDI  R30,LOW(0)
_0xA0006:
	RET
; 0005 0036 }
; .FEND
;void MPU6050_Read(MPU6050_Data *d)
; 0005 0039 {
_MPU6050_Read:
; .FSTART _MPU6050_Read
; 0005 003A unsigned char b[14];
; 0005 003B unsigned char i;
; 0005 003C 
; 0005 003D i2c_start(MPU6050_ADDR_W);
	SBIW R28,14
	RCALL __SAVELOCR4
	MOVW R18,R26
;	*d -> R18,R19
;	b -> Y+4
;	i -> R17
	LDI  R26,LOW(208)
	RCALL _i2c_start
; 0005 003E i2c_write(MPU6050_RA_ACCEL_XOUT_H);
	LDI  R26,LOW(59)
	RCALL _i2c_write
; 0005 003F i2c_start(MPU6050_ADDR_R);
	LDI  R26,LOW(209)
	RCALL _i2c_start
; 0005 0040 for (i = 0; i < 13; i++) b[i] = i2c_read_ack();
	LDI  R17,LOW(0)
_0xA0009:
	CPI  R17,13
	BRSH _0xA000A
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _i2c_read_ack
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0xA0009
_0xA000A:
; 0005 0041 b[13] = i2c_read_nack();
	RCALL _i2c_read_nack
	STD  Y+17,R30
; 0005 0042 i2c_stop();
	RCALL _i2c_stop
; 0005 0043 
; 0005 0044 d->ax = (int16_t)((b[0]  << 8) | b[1]);
	LDI  R30,0
	LDD  R31,Y+4
	MOVW R26,R30
	LDD  R30,Y+5
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R18
	ST   X+,R30
	ST   X,R31
; 0005 0045 d->ay = (int16_t)((b[2]  << 8) | b[3]);
	LDI  R30,0
	LDD  R31,Y+6
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1RNS 18,2
; 0005 0046 d->az = (int16_t)((b[4]  << 8) | b[5]);
	LDI  R30,0
	LDD  R31,Y+8
	MOVW R26,R30
	LDD  R30,Y+9
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1RNS 18,4
; 0005 0047 /* b[6],b[7] = TEMP (bo qua) */
; 0005 0048 d->gx = (int16_t)((b[8]  << 8) | b[9]);
	LDI  R30,0
	LDD  R31,Y+12
	MOVW R26,R30
	LDD  R30,Y+13
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1RNS 18,6
; 0005 0049 d->gy = (int16_t)((b[10] << 8) | b[11]);
	LDI  R30,0
	LDD  R31,Y+14
	MOVW R26,R30
	LDD  R30,Y+15
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1RNS 18,8
; 0005 004A d->gz = (int16_t)((b[12] << 8) | b[13]);
	LDI  R30,0
	LDD  R31,Y+16
	MOVW R26,R30
	LDD  R30,Y+17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1RNS 18,10
; 0005 004B 
; 0005 004C #if TILT_USES_X_ACCEL
; 0005 004D d->angle_acc = ACC_ANGLE_SIGN *
; 0005 004E atan2((float)d->ax, ACC_Z_SIGN * (float)d->az) * RAD2DEG;
	MOVW R26,R18
	RCALL SUBOPT_0x2A
	RCALL __PUTPARD1
	MOVW R26,R18
	ADIW R26,4
	RCALL SUBOPT_0x2A
	__GETD2N 0xBF800000
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _atan2
	RCALL SUBOPT_0xD
	RCALL __MULF12
	__GETD2N 0x42652EE1
	RCALL __MULF12
	__PUTD1RNS 18,12
; 0005 004F d->gyro_rate = GYRO_RATE_SIGN * (((float)d->gy - gyro_bias) / GYRO_SENS);
	MOVW R26,R18
	ADIW R26,8
	RCALL SUBOPT_0x2A
	LDS  R26,_gyro_bias_G005
	LDS  R27,_gyro_bias_G005+1
	LDS  R24,_gyro_bias_G005+2
	LDS  R25,_gyro_bias_G005+3
	RCALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43030000
	RCALL __DIVF21
	RCALL SUBOPT_0xD
	RCALL __MULF12
	__PUTD1RNS 18,16
; 0005 0050 #else
; 0005 0051 d->angle_acc = ACC_ANGLE_SIGN *
; 0005 0052 atan2((float)d->ay, ACC_Z_SIGN * (float)d->az) * RAD2DEG;
; 0005 0053 d->gyro_rate = GYRO_RATE_SIGN * (((float)d->gx - gyro_bias) / GYRO_SENS);
; 0005 0054 #endif
; 0005 0055 }
	RCALL __LOADLOCR4
	ADIW R28,18
	RET
; .FEND
;void MPU6050_CalibrateGyro(void)
; 0005 0058 {
_MPU6050_CalibrateGyro:
; .FSTART _MPU6050_CalibrateGyro
; 0005 0059 unsigned int n;
; 0005 005A long sum = 0;
; 0005 005B MPU6050_Data d;
; 0005 005C 
; 0005 005D gyro_bias = 0.0f;
	SBIW R28,24
	LDI  R30,LOW(0)
	STD  Y+20,R30
	STD  Y+21,R30
	STD  Y+22,R30
	STD  Y+23,R30
	ST   -Y,R17
	ST   -Y,R16
;	n -> R16,R17
;	sum -> Y+22
;	d -> Y+2
	STS  _gyro_bias_G005,R30
	STS  _gyro_bias_G005+1,R30
	STS  _gyro_bias_G005+2,R30
	STS  _gyro_bias_G005+3,R30
; 0005 005E for (n = 0; n < 1000; n++)
	__GETWRN 16,17,0
_0xA000C:
	__CPWRN 16,17,1000
	BRSH _0xA000D
; 0005 005F {
; 0005 0060 MPU6050_Read(&d);
	MOVW R26,R28
	ADIW R26,2
	RCALL _MPU6050_Read
; 0005 0061 #if TILT_USES_X_ACCEL
; 0005 0062 sum += d.gy;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	__GETD2S 22
	RCALL SUBOPT_0x2
	__PUTD1S 22
; 0005 0063 #else
; 0005 0064 sum += d.gx;
; 0005 0065 #endif
; 0005 0066 delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
; 0005 0067 }
	__ADDWRN 16,17,1
	RJMP _0xA000C
_0xA000D:
; 0005 0068 gyro_bias = (float)sum / 1000.0f;
	RCALL SUBOPT_0x1C
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447A0000
	RCALL __DIVF21
	STS  _gyro_bias_G005,R30
	STS  _gyro_bias_G005+1,R31
	STS  _gyro_bias_G005+2,R22
	STS  _gyro_bias_G005+3,R23
; 0005 0069 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,26
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
;static void twi_wait(void)
; 0006 0011 {

	.CSEG
_twi_wait_G006:
; .FSTART _twi_wait_G006
; 0006 0012 while (!(TWCR & (1 << TWINT)));
_0xC0003:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0xC0003
; 0006 0013 }
	RET
; .FEND
;void i2c_init(void)
; 0006 0016 {
_i2c_init:
; .FSTART _i2c_init
; 0006 0017 TWSR = 0x00;            /* prescaler = 1 */
	LDI  R30,LOW(0)
	STS  185,R30
; 0006 0018 TWBR = TWI_TWBR_VAL;
	LDI  R30,LOW(72)
	STS  184,R30
; 0006 0019 TWCR = (1 << TWEN);
	LDI  R30,LOW(4)
	STS  188,R30
; 0006 001A }
	RET
; .FEND
;unsigned char i2c_start(unsigned char addr)
; 0006 001D {
_i2c_start:
; .FSTART _i2c_start
; 0006 001E unsigned char st;
; 0006 001F 
; 0006 0020 TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);   /* START */
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
;	addr -> R16
;	st -> R17
	LDI  R30,LOW(164)
	STS  188,R30
; 0006 0021 twi_wait();
	RCALL _twi_wait_G006
; 0006 0022 
; 0006 0023 TWDR = addr;                                        /* SLA + R/W */
	STS  187,R16
; 0006 0024 TWCR = (1 << TWINT) | (1 << TWEN);
	RCALL SUBOPT_0x2B
; 0006 0025 twi_wait();
; 0006 0026 
; 0006 0027 st = TWSR & 0xF8;
	MOV  R17,R30
; 0006 0028 return (st == TW_MT_SLA_ACK || st == TW_MR_SLA_ACK) ? 1 : 0;
	CPI  R17,24
	BREQ _0xC0006
	CPI  R17,64
	BRNE _0xC0008
_0xC0006:
	LDI  R30,LOW(1)
	RJMP _0xC0009
_0xC0008:
	LDI  R30,LOW(0)
_0xC0009:
_0x2080006:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0006 0029 }
; .FEND
;void i2c_stop(void)
; 0006 002C {
_i2c_stop:
; .FSTART _i2c_stop
; 0006 002D TWCR = (1 << TWINT) | (1 << TWSTO) | (1 << TWEN);
	LDI  R30,LOW(148)
	STS  188,R30
; 0006 002E while (TWCR & (1 << TWSTO));
_0xC000B:
	LDS  R30,188
	ANDI R30,LOW(0x10)
	BRNE _0xC000B
; 0006 002F }
	RET
; .FEND
;unsigned char i2c_write(unsigned char data)
; 0006 0032 {
_i2c_write:
; .FSTART _i2c_write
; 0006 0033 TWDR = data;
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
	STS  187,R17
; 0006 0034 TWCR = (1 << TWINT) | (1 << TWEN);
	RCALL SUBOPT_0x2B
; 0006 0035 twi_wait();
; 0006 0036 return ((TWSR & 0xF8) == TW_MT_DATA_ACK) ? 1 : 0;
	CPI  R30,LOW(0x28)
	BRNE _0xC000E
	LDI  R30,LOW(1)
	RJMP _0xC000F
_0xC000E:
	LDI  R30,LOW(0)
_0xC000F:
_0x2080005:
	LD   R17,Y+
	RET
; 0006 0037 }
; .FEND
;unsigned char i2c_read_ack(void)
; 0006 003A {
_i2c_read_ack:
; .FSTART _i2c_read_ack
; 0006 003B TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWEA);
	LDI  R30,LOW(196)
	RJMP _0x2080004
; 0006 003C twi_wait();
; 0006 003D return TWDR;
; 0006 003E }
; .FEND
;unsigned char i2c_read_nack(void)
; 0006 0041 {
_i2c_read_nack:
; .FSTART _i2c_read_nack
; 0006 0042 TWCR = (1 << TWINT) | (1 << TWEN);
	LDI  R30,LOW(132)
_0x2080004:
	STS  188,R30
; 0006 0043 twi_wait();
	RCALL _twi_wait_G006
; 0006 0044 return TWDR;
	LDS  R30,187
	RET
; 0006 0045 }
; .FEND

	.CSEG
_xatan:
; .FSTART _xatan
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x2E
	__GETD2N 0x40CBD065
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x2D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x2E
	__GETD2N 0x41296D00
	RCALL __ADDF12
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x2F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
_0x2080003:
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	RCALL __PUTPARD2
	RCALL SUBOPT_0xC
	__GETD1N 0x3ED413CD
	RCALL __CMPF12
	BRSH _0x2000020
	RCALL SUBOPT_0xC
	RCALL _xatan
	RJMP _0x2080002
_0x2000020:
	RCALL SUBOPT_0xC
	__GETD1N 0x401A827A
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x30
	__GETD2N 0x3FC90FDB
	RCALL __SWAPD12
	RCALL __SUBF12
	RJMP _0x2080002
_0x2000021:
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0xD
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0xD
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x30
	__GETD2N 0x3F490FDB
	RCALL __ADDF12
_0x2080002:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	RCALL SUBOPT_0x2C
	__CPD10
	BRNE _0x200002D
	__GETD1S 8
	__CPD10
	BRNE _0x200002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x2080001
_0x200002E:
	RCALL SUBOPT_0x31
	RCALL __CPD02
	BRGE _0x200002F
	__GETD1N 0x3FC90FDB
	RJMP _0x2080001
_0x200002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x2080001
_0x200002D:
	__GETD1S 4
	RCALL SUBOPT_0x31
	RCALL __DIVF21
	RCALL SUBOPT_0xB
	__GETD2S 4
	RCALL __CPD02
	BRGE _0x2000030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000031
	RCALL SUBOPT_0xC
	RCALL _yatan
	RJMP _0x2080001
_0x2000031:
	RCALL SUBOPT_0x32
	RCALL __ANEGF1
	RJMP _0x2080001
_0x2000030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2000032
	RCALL SUBOPT_0x32
	__GETD2N 0x40490FDB
	RCALL __SWAPD12
	RCALL __SUBF12
	RJMP _0x2080001
_0x2000032:
	RCALL SUBOPT_0xC
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
_g_tick:
	.BYTE 0x1
_imu:
	.BYTE 0x14
_filt:
	.BYTE 0x9
_pid:
	.BYTE 0x25
_line_S0000001000:
	.BYTE 0x10
_idx_S0000001000:
	.BYTE 0x1
_gyro_bias_G005:
	.BYTE 0x4
_who_id_G005:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_line_S0000001000)
	SBCI R31,HIGH(-_line_S0000001000)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	__CWD1
	__ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x1
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x5:
	__GETD1N 0x41200000
	RCALL __MULF12
	RCALL __CFD1
	MOVW R26,R30
	MOVW R24,R22
	RJMP _uart_put_int

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	IN   R30,0x5
	LDI  R26,LOW(32)
	EOR  R30,R26
	OUT  0x5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_filt)
	LDI  R31,HIGH(_filt)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_pid)
	LDI  R31,HIGH(_pid)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x9:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	RCALL __PUTPARD1
	__GETD2N 0x3C23D70A
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xC:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xD:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	MOVW R26,R16
	__CWD2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x9
	__PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	__PUTD1RNS 16,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	MOVW R26,R16
	__PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	MOVW R30,R16
	__GETD2Z 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	MOVW R26,R16
	__GETD1P_INC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x16:
	__GETD1P_INC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	__GETD2S 10
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	STS  137,R30
	STS  136,R30
	STS  139,R30
	STS  138,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _clamp_duty_G002
	MOVW R16,R30
	LDD  R26,Y+3
	TST  R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	__GETD1N 0x64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	RCALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x1A
	RCALL __DIVD21
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__GETD1S 22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	__GETD1S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	__GETD1S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	MOVW R30,R16
	__GETD2Z 16
	MOVW R0,R26
	MOVW R26,R16
	ADIW R26,28
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	__PUTD1RNS 16,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0x1D
	__PUTD1RNS 16,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	__GETD2S 2
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R26,R16
	ADIW R26,32
	RCALL SUBOPT_0x16
	RCALL __ANEGF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD1S 17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	__GETD1S 1
	__CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	__GETD2S 1
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(208)
	RCALL _i2c_start
	MOV  R26,R16
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _mpu_write_reg_G005
	LDI  R26,LOW(10)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2A:
	LD   R30,X+
	LD   R31,X+
	__CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(132)
	STS  188,R30
	RCALL _twi_wait_G006
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	RCALL __PUTPARD2
	SBIW R28,4
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	__GETD2S 4
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2E:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	RCALL __MULF12
	__GETD2N 0x414A8F4E
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	RCALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RJMP _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x2E
	RCALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RJMP _yatan

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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

__ANEGD2:
	COM  R27
	COM  R24
	COM  R25
	NEG  R26
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	RET

__MULD12:
__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	MOVW R20,R0
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	RCALL __ANEGD2
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
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

	.equ __i2c_dir_scl=__i2c_port-1
	.equ __i2c_pin_scl=__i2c_port-2
	.equ __i2c_dir_sda=__i2c_port-1
	.equ __i2c_pin_sda=__i2c_port-2

_i2c_init:
	cbi  __i2c_port_scl,__scl_bit
	cbi  __i2c_port_sda,__sda_bit
	sbi  __i2c_dir_scl,__scl_bit
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_delay2

_i2c_start:
	cbi  __i2c_dir_sda,__sda_bit
	cbi  __i2c_dir_scl,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin_sda,__sda_bit
	ret
	sbis __i2c_pin_scl,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir_sda,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir_scl,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,10
	rjmp __i2c_delay2l

_i2c_stop:
	sbi  __i2c_dir_sda,__sda_bit
	sbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir_sda,__sda_bit
__i2c_delay2:
	ldi  r22,20
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret

_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin_scl,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin_sda,__sda_bit
	sec
	sbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	tst  r26
	brne __i2c_read1
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir_sda,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir_sda,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin_scl,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir_scl,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir_sda,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin_sda,__sda_bit
	clr  r30
	sbi  __i2c_dir_scl,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
