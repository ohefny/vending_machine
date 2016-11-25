
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _inputChar=R5
	.DEF _price=R4
	.DEF _enableAdminButton=R7
	.DEF __lcd_x=R6
	.DEF __lcd_y=R9
	.DEF __lcd_maxx=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _on_interrupt
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
	JMP  0x00

_0x3:
	.DB  0x31,0x32,0x33
_0x0:
	.DB  0x43,0x68,0x6F,0x6F,0x73,0x65,0x20,0x49
	.DB  0x74,0x65,0x6D,0x3A,0x3A,0x0,0x70,0x72
	.DB  0x69,0x63,0x65,0x20,0x3A,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x43,0x6F,0x69,0x6E
	.DB  0x73,0x20,0x3A,0x3A,0x0,0x50,0x69,0x63
	.DB  0x6B,0x20,0x75,0x70,0x20,0x79,0x6F,0x75
	.DB  0x72,0x20,0x49,0x74,0x65,0x6D,0x0,0x4E
	.DB  0x65,0x77,0x20,0x50,0x72,0x69,0x63,0x65
	.DB  0x3A,0x3A,0x20,0x0,0x57,0x72,0x6F,0x6E
	.DB  0x67,0x20,0x53,0x79,0x6D,0x62,0x6F,0x6C
	.DB  0x2E,0x2E,0x0,0x50,0x72,0x69,0x63,0x65
	.DB  0x20,0x55,0x70,0x64,0x61,0x74,0x65,0x64
	.DB  0x2E,0x2E,0x2E,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x49,0x74,0x65,0x6D,0x3A,0x3A
	.DB  0x20,0x0,0x57,0x65,0x6C,0x63,0x6F,0x6D
	.DB  0x65,0x20,0x41,0x64,0x6D,0x69,0x6E,0x2E
	.DB  0x2E,0x2E,0x0,0x41,0x64,0x6D,0x69,0x6E
	.DB  0x20,0x50,0x61,0x73,0x73,0x77,0x6F,0x72
	.DB  0x64,0x3A,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  _password
	.DW  _0x3*2

	.DW  0x0E
	.DW  _0xD
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x34
	.DW  _0x0*2+14

	.DW  0x0F
	.DW  _0x34+8
	.DW  _0x0*2+22

	.DW  0x12
	.DW  _0x37
	.DW  _0x0*2+37

	.DW  0x0D
	.DW  _0x50
	.DW  _0x0*2+55

	.DW  0x0F
	.DW  _0x50+13
	.DW  _0x0*2+68

	.DW  0x0D
	.DW  _0x50+28
	.DW  _0x0*2+55

	.DW  0x11
	.DW  _0x50+41
	.DW  _0x0*2+83

	.DW  0x11
	.DW  _0x50+58
	.DW  _0x0*2+83

	.DW  0x0F
	.DW  _0x50+75
	.DW  _0x0*2+68

	.DW  0x0D
	.DW  _0x50+90
	.DW  _0x0*2+55

	.DW  0x0E
	.DW  _0x5B
	.DW  _0x0*2+100

	.DW  0x0E
	.DW  _0x5B+14
	.DW  _0x0*2+100

	.DW  0x0E
	.DW  _0x5B+28
	.DW  _0x0*2+100

	.DW  0x11
	.DW  _0x64
	.DW  _0x0*2+114

	.DW  0x10
	.DW  _0x65
	.DW  _0x0*2+131

	.DW  0x10
	.DW  _0x65+16
	.DW  _0x0*2+131

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
	OUT  GICR,R31
	OUT  GICR,R30
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
	LDI  R26,__SRAM_START
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
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*
;* Door Lock.c
;*
;* Created: 11/19/2016 3:53:37 PM
;* Author: Be The Change
;*/
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <mega16.h>
;#include <delay.h>
;#include <alcd.h>
;#include <string.h>
;#include <stdlib.h>
;#define InputCol PINA>>4
;#define Keypad   PORTA
;#define Keypad_dir DDRA
;#define Coin_Input PINB.0
;#define Green_Led  PORTB.4
;unsigned char  password[]={'1','2','3','\0'};

	.DSEG
;unsigned char inputChar,price,enableAdminButton;
;void eeprom_write(unsigned int uiAddress,unsigned char ucData)
; 0000 0016 {

	.CSEG
_eeprom_write:
; .FSTART _eeprom_write
; 0000 0017     while( EECR & 0b00000010); //wait until EEPE==0
	ST   -Y,R26
;	uiAddress -> Y+1
;	ucData -> Y+0
_0x4:
	SBIC 0x1C,1
	RJMP _0x4
; 0000 0018 
; 0000 0019     EEAR=uiAddress;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 001A     EEDR=ucData;
	LD   R30,Y
	OUT  0x1D,R30
; 0000 001B     EECR |=0b00000100; //write EEMPE=1
	SBI  0x1C,2
; 0000 001C     EECR |=0b00000010; //write EEWE=1
	SBI  0x1C,1
; 0000 001D }
	JMP  _0x20A0002
; .FEND
;unsigned char eeprom_read(unsigned int uiAddress)
; 0000 001F {
_eeprom_read:
; .FSTART _eeprom_read
; 0000 0020     while(EECR & 0b00000010); //wait until EEWE==0
	ST   -Y,R27
	ST   -Y,R26
;	uiAddress -> Y+0
_0x7:
	SBIC 0x1C,1
	RJMP _0x7
; 0000 0021 
; 0000 0022     EEAR=uiAddress;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 0023     EECR|=0b00000001; //write EERE=1
	SBI  0x1C,0
; 0000 0024     return EEDR;
	IN   R30,0x1D
	JMP  _0x20A0003
; 0000 0025 }
; .FEND
;void wait(){
; 0000 0026 void wait(){
_wait:
; .FSTART _wait
; 0000 0027     while((PINA>>4) > 0);
_0xA:
	CALL SUBOPT_0x0
	CALL __CPW01
	BRLT _0xA
; 0000 0028 }
	RET
; .FEND
;void resetScreen(){
; 0000 0029 void resetScreen(){
_resetScreen:
; .FSTART _resetScreen
; 0000 002A     lcd_clear();
	CALL SUBOPT_0x1
; 0000 002B     lcd_gotoxy(0,0);
; 0000 002C     lcd_puts("Choose Item::");
	__POINTW2MN _0xD,0
	CALL SUBOPT_0x2
; 0000 002D     lcd_gotoxy(0,15);
	LDI  R26,LOW(15)
	CALL _lcd_gotoxy
; 0000 002E     price=0;
	CLR  R4
; 0000 002F     inputChar=0;
	CLR  R5
; 0000 0030 }
	RET
; .FEND

	.DSEG
_0xD:
	.BYTE 0xE
;unsigned char getKey(){
; 0000 0031 unsigned char getKey(){

	.CSEG
_getKey:
; .FSTART _getKey
; 0000 0032     unsigned char i;
; 0000 0033 
; 0000 0034 
; 0000 0035     for(i=1;i<=8;i=i<<1){
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(1)
_0xF:
	CPI  R17,9
	BRLO PC+2
	RJMP _0x10
; 0000 0036         PORTA = i;
	OUT  0x1B,R17
; 0000 0037         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0038 
; 0000 0039         if(Keypad == 1){
	IN   R30,0x1B
	CPI  R30,LOW(0x1)
	BRNE _0x11
; 0000 003A             switch(InputCol){
	CALL SUBOPT_0x0
; 0000 003B             case 1: return '1';
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x15
	LDI  R30,LOW(49)
	RJMP _0x20A0005
; 0000 003C             case 2: return '2';
_0x15:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x16
	LDI  R30,LOW(50)
	RJMP _0x20A0005
; 0000 003D             case 4: return '3';
_0x16:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x14
	LDI  R30,LOW(51)
	RJMP _0x20A0005
; 0000 003E             }
_0x14:
; 0000 003F         }
; 0000 0040 
; 0000 0041         else if(Keypad == 2){
	RJMP _0x18
_0x11:
	IN   R30,0x1B
	CPI  R30,LOW(0x2)
	BRNE _0x19
; 0000 0042             switch(InputCol){
	CALL SUBOPT_0x0
; 0000 0043             case 1: return '4';
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
	LDI  R30,LOW(52)
	RJMP _0x20A0005
; 0000 0044             case 2: return '5';
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E
	LDI  R30,LOW(53)
	RJMP _0x20A0005
; 0000 0045             case 4: return '6';
_0x1E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1C
	LDI  R30,LOW(54)
	RJMP _0x20A0005
; 0000 0046             }
_0x1C:
; 0000 0047         }
; 0000 0048 
; 0000 0049         else if(Keypad == 4){
	RJMP _0x20
_0x19:
	IN   R30,0x1B
	CPI  R30,LOW(0x4)
	BRNE _0x21
; 0000 004A             switch(InputCol){
	CALL SUBOPT_0x0
; 0000 004B             case 1: return '7';
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x25
	LDI  R30,LOW(55)
	RJMP _0x20A0005
; 0000 004C             case 2: return '8';
_0x25:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x26
	LDI  R30,LOW(56)
	RJMP _0x20A0005
; 0000 004D             case 4: return '9';
_0x26:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x24
	LDI  R30,LOW(57)
	RJMP _0x20A0005
; 0000 004E             }
_0x24:
; 0000 004F         }
; 0000 0050 
; 0000 0051         else {
	RJMP _0x28
_0x21:
; 0000 0052             switch(InputCol){
	CALL SUBOPT_0x0
; 0000 0053             case 1: return '*';
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2C
	LDI  R30,LOW(42)
	RJMP _0x20A0005
; 0000 0054             case 2: return '0';
_0x2C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D
	LDI  R30,LOW(48)
	RJMP _0x20A0005
; 0000 0055             case 4: return '#';
_0x2D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2B
	LDI  R30,LOW(35)
	RJMP _0x20A0005
; 0000 0056             }
_0x2B:
; 0000 0057         }
_0x28:
_0x20:
_0x18:
; 0000 0058     }
	LSL  R17
	RJMP _0xF
_0x10:
; 0000 0059 
; 0000 005A }
	RJMP _0x20A0005
; .FEND
;int waitForConfirm(){
; 0000 005B int waitForConfirm(){
_waitForConfirm:
; .FSTART _waitForConfirm
; 0000 005C     unsigned char key=0;
; 0000 005D     wait();
	ST   -Y,R17
;	key -> R17
	LDI  R17,0
	RCALL _wait
; 0000 005E     while (1)
_0x2F:
; 0000 005F     {
; 0000 0060         key=getKey();
	CALL SUBOPT_0x3
; 0000 0061         //wait();
; 0000 0062         if (key != 0){
	BREQ _0x32
; 0000 0063             if(key!='*'){
	CPI  R17,42
	BREQ _0x33
; 0000 0064 
; 0000 0065                 return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0005
; 0000 0066             }
; 0000 0067             lcd_putchar(key);
_0x33:
	MOV  R26,R17
	CALL _lcd_putchar
; 0000 0068             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20A0005
; 0000 0069         }
; 0000 006A 
; 0000 006B 
; 0000 006C     }
_0x32:
	RJMP _0x2F
; 0000 006D }
; .FEND
;void showPrice(void){
; 0000 006E void showPrice(void){
_showPrice:
; .FSTART _showPrice
; 0000 006F     //price=inputChar-'0';
; 0000 0070     price=eeprom_read(inputChar-'0')-'0';
	MOV  R30,R5
	LDI  R31,0
	SBIW R30,48
	MOVW R26,R30
	RCALL _eeprom_read
	SUBI R30,LOW(48)
	MOV  R4,R30
; 0000 0071     lcd_clear();
	CALL SUBOPT_0x1
; 0000 0072     lcd_gotoxy(0,0);
; 0000 0073     lcd_puts("price :");
	__POINTW2MN _0x34,0
	CALL SUBOPT_0x2
; 0000 0074     lcd_gotoxy(0,8);
	LDI  R26,LOW(8)
	CALL _lcd_gotoxy
; 0000 0075 
; 0000 0076     lcd_putchar(price+'0');
	MOV  R26,R4
	SUBI R26,-LOW(48)
	CALL SUBOPT_0x4
; 0000 0077     delay_ms(100);
; 0000 0078     lcd_clear();
	CALL SUBOPT_0x1
; 0000 0079     lcd_gotoxy(0,0);
; 0000 007A     lcd_puts("Enter Coins ::");
	__POINTW2MN _0x34,8
	CALL SUBOPT_0x2
; 0000 007B     lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 007C     lcd_putchar('0');
	LDI  R26,LOW(48)
	CALL SUBOPT_0x4
; 0000 007D     delay_ms(100) ;
; 0000 007E }
	RET
; .FEND

	.DSEG
_0x34:
	.BYTE 0x17
;void pickUpItem(){
; 0000 007F void pickUpItem(){

	.CSEG
_pickUpItem:
; .FSTART _pickUpItem
; 0000 0080     lcd_clear();
	CALL SUBOPT_0x1
; 0000 0081     lcd_gotoxy(0,0);
; 0000 0082     Green_Led=1;
	SBI  0x18,4
; 0000 0083     lcd_puts("Pick up your Item");
	__POINTW2MN _0x37,0
	CALL _lcd_puts
; 0000 0084     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 0085     Green_Led=0;
	CBI  0x18,4
; 0000 0086    // PORTD.4=0;
; 0000 0087 
; 0000 0088 }
	RET
; .FEND

	.DSEG
_0x37:
	.BYTE 0x12
;void waitForCoins(){
; 0000 0089 void waitForCoins(){

	.CSEG
_waitForCoins:
; .FSTART _waitForCoins
; 0000 008A     unsigned char count=0;
; 0000 008B     while(Coin_Input);
	ST   -Y,R17
;	count -> R17
	LDI  R17,0
_0x3A:
	SBIC 0x16,0
	RJMP _0x3A
; 0000 008C     while(1){
_0x3D:
; 0000 008D         if(Coin_Input){
	SBIS 0x16,0
	RJMP _0x40
; 0000 008E             count++;
	SUBI R17,-1
; 0000 008F             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0090             lcd_putchar(count+'0');
	MOV  R26,R17
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
; 0000 0091             while(Coin_Input&&count!=price);
_0x41:
	SBIS 0x16,0
	RJMP _0x44
	CP   R4,R17
	BRNE _0x45
_0x44:
	RJMP _0x43
_0x45:
	RJMP _0x41
_0x43:
; 0000 0092 
; 0000 0093         }
; 0000 0094         if(price==count){
_0x40:
	CP   R17,R4
	BRNE _0x46
; 0000 0095             pickUpItem();
	RCALL _pickUpItem
; 0000 0096             resetScreen();
	RCALL _resetScreen
; 0000 0097             return;
	RJMP _0x20A0005
; 0000 0098         }
; 0000 0099     }
_0x46:
	RJMP _0x3D
; 0000 009A 
; 0000 009B }
; .FEND
;void mainScreen(){
; 0000 009C void mainScreen(){
_mainScreen:
; .FSTART _mainScreen
; 0000 009D     resetScreen();
	RCALL _resetScreen
; 0000 009E     while (1){
_0x47:
; 0000 009F         lcd_gotoxy(0,15);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(15)
	CALL _lcd_gotoxy
; 0000 00A0         inputChar = getKey();
	RCALL _getKey
	MOV  R5,R30
; 0000 00A1         if (inputChar != 0){
	TST  R5
	BREQ _0x4A
; 0000 00A2             if(inputChar<='0'||inputChar>'9'){
	LDI  R30,LOW(48)
	CP   R30,R5
	BRSH _0x4C
	LDI  R30,LOW(57)
	CP   R30,R5
	BRSH _0x4B
_0x4C:
; 0000 00A3                 resetScreen();
	RCALL _resetScreen
; 0000 00A4                 continue;
	RJMP _0x47
; 0000 00A5             }
; 0000 00A6 
; 0000 00A7             lcd_putchar(inputChar);
_0x4B:
	MOV  R26,R5
	CALL _lcd_putchar
; 0000 00A8 
; 0000 00A9             if(waitForConfirm()){
	RCALL _waitForConfirm
	SBIW R30,0
	BREQ _0x4E
; 0000 00AA                 showPrice();
	RCALL _showPrice
; 0000 00AB                 waitForCoins();
	RCALL _waitForCoins
; 0000 00AC             }
; 0000 00AD             else{
	RJMP _0x4F
_0x4E:
; 0000 00AE                 resetScreen();
	RCALL _resetScreen
; 0000 00AF             }
_0x4F:
; 0000 00B0 
; 0000 00B1             wait();
	RCALL _wait
; 0000 00B2         }
; 0000 00B3     }
_0x4A:
	RJMP _0x47
; 0000 00B4 
; 0000 00B5 }
; .FEND
;void showMsg(char* msg,char*reset,int x,int y,int waiting){
; 0000 00B6 void showMsg(char* msg,char*reset,int x,int y,int waiting){
_showMsg:
; .FSTART _showMsg
; 0000 00B7     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	*msg -> Y+8
;	*reset -> Y+6
;	x -> Y+4
;	y -> Y+2
;	waiting -> Y+0
	CALL SUBOPT_0x1
; 0000 00B8     lcd_gotoxy(0,0);
; 0000 00B9     lcd_puts(msg);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL _lcd_puts
; 0000 00BA     delay_ms(waiting);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _delay_ms
; 0000 00BB     lcd_clear();
	CALL SUBOPT_0x1
; 0000 00BC     lcd_gotoxy(0,0);
; 0000 00BD     lcd_puts(reset);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _lcd_puts
; 0000 00BE     lcd_gotoxy(x,y);
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _lcd_gotoxy
; 0000 00BF 
; 0000 00C0 }
	ADIW R28,10
	RET
; .FEND
;void editPrice(unsigned char key){
; 0000 00C1 void editPrice(unsigned char key){
_editPrice:
; .FSTART _editPrice
; 0000 00C2 
; 0000 00C3     unsigned char price=0;
; 0000 00C4     wait();
	ST   -Y,R26
	ST   -Y,R17
;	key -> Y+1
;	price -> R17
	LDI  R17,0
	RCALL _wait
; 0000 00C5     lcd_clear();
	CALL SUBOPT_0x1
; 0000 00C6     lcd_gotoxy(0,0);
; 0000 00C7     lcd_puts("New Price:: ");
	__POINTW2MN _0x50,0
	RCALL _lcd_puts
; 0000 00C8     lcd_gotoxy(14,0);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 00C9     while(1){
_0x51:
; 0000 00CA         price = getKey();
	CALL SUBOPT_0x3
; 0000 00CB         if(price!=0){
	BREQ _0x54
; 0000 00CC             if(price=='#'){
	CPI  R17,35
	BRNE _0x55
; 0000 00CD                 lcd_putchar('#');
	LDI  R26,LOW(35)
	RCALL _lcd_putchar
; 0000 00CE                 return ;
	LDD  R17,Y+0
	RJMP _0x20A0003
; 0000 00CF             }
; 0000 00D0             if(price<='0'||price>'9'){
_0x55:
	CPI  R17,49
	BRLO _0x57
	CPI  R17,58
	BRLO _0x56
_0x57:
; 0000 00D1                 showMsg("Wrong Symbol..","New Price:: ",14,0,50);
	__POINTW1MN _0x50,13
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x50,28
	CALL SUBOPT_0x5
; 0000 00D2                 continue;
	RJMP _0x51
; 0000 00D3             }
; 0000 00D4             lcd_putchar(price);
_0x56:
	MOV  R26,R17
	RCALL _lcd_putchar
; 0000 00D5             if(waitForConfirm()){
	RCALL _waitForConfirm
	SBIW R30,0
	BREQ _0x59
; 0000 00D6                 eeprom_write(key-'0',price);
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,48
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	RCALL _eeprom_write
; 0000 00D7                 showMsg("Price Updated...","Price Updated...",0,0,20);
	__POINTW1MN _0x50,41
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x50,58
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _showMsg
; 0000 00D8                 return;
	LDD  R17,Y+0
	RJMP _0x20A0003
; 0000 00D9 
; 0000 00DA             }
; 0000 00DB             else{
_0x59:
; 0000 00DC                 showMsg("Wrong Symbol..","New Price:: ",14,0,50);
	__POINTW1MN _0x50,75
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x50,90
	CALL SUBOPT_0x5
; 0000 00DD                 continue;
	RJMP _0x51
; 0000 00DE             }
; 0000 00DF         }
; 0000 00E0         wait();
_0x54:
	RCALL _wait
; 0000 00E1 
; 0000 00E2     }
	RJMP _0x51
; 0000 00E3 
; 0000 00E4 
; 0000 00E5 }
; .FEND

	.DSEG
_0x50:
	.BYTE 0x67
;void editItems(){
; 0000 00E6 void editItems(){

	.CSEG
_editItems:
; .FSTART _editItems
; 0000 00E7     unsigned char key=0;
; 0000 00E8     lcd_clear();
	ST   -Y,R17
;	key -> R17
	LDI  R17,0
	CALL SUBOPT_0x1
; 0000 00E9     lcd_gotoxy(0,0);
; 0000 00EA     lcd_puts("Enter Item:: ");
	__POINTW2MN _0x5B,0
	RCALL _lcd_puts
; 0000 00EB 
; 0000 00EC     while(1){
_0x5C:
; 0000 00ED         key = getKey();
	CALL SUBOPT_0x3
; 0000 00EE         if(key!=0){
	BREQ _0x5F
; 0000 00EF             if(key=='#'){
	CPI  R17,35
	BRNE _0x60
; 0000 00F0                 lcd_putchar('#');
	LDI  R26,LOW(35)
	RCALL _lcd_putchar
; 0000 00F1                 return ;
	RJMP _0x20A0005
; 0000 00F2             }
; 0000 00F3             if(key<'0'||key>'9'){
_0x60:
	CPI  R17,48
	BRLO _0x62
	CPI  R17,58
	BRLO _0x61
_0x62:
; 0000 00F4                 lcd_clear();
	CALL SUBOPT_0x1
; 0000 00F5                 lcd_gotoxy(0,0);
; 0000 00F6                 lcd_puts("Enter Item:: ");
	__POINTW2MN _0x5B,14
	RCALL _lcd_puts
; 0000 00F7                 continue;
	RJMP _0x5C
; 0000 00F8             }
; 0000 00F9             lcd_gotoxy(13,0);
_0x61:
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 00FA             lcd_putchar(key);
	MOV  R26,R17
	RCALL _lcd_putchar
; 0000 00FB             delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 00FC             editPrice(key);
	MOV  R26,R17
	RCALL _editPrice
; 0000 00FD             lcd_clear();
	CALL SUBOPT_0x1
; 0000 00FE             lcd_gotoxy(0,0);
; 0000 00FF             lcd_puts("Enter Item:: ");
	__POINTW2MN _0x5B,28
	RCALL _lcd_puts
; 0000 0100 
; 0000 0101         }
; 0000 0102         wait();
_0x5F:
	RCALL _wait
; 0000 0103 
; 0000 0104     }
	RJMP _0x5C
; 0000 0105 
; 0000 0106 }
_0x20A0005:
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x5B:
	.BYTE 0x2A
;void adminPanel(){
; 0000 0107 void adminPanel(){

	.CSEG
_adminPanel:
; .FSTART _adminPanel
; 0000 0108     lcd_clear();
	CALL SUBOPT_0x1
; 0000 0109     lcd_gotoxy(0,0);
; 0000 010A     lcd_puts("Welcome Admin...");
	__POINTW2MN _0x64,0
	RCALL _lcd_puts
; 0000 010B     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 010C     editItems();
	RCALL _editItems
; 0000 010D 
; 0000 010E }
	RET
; .FEND

	.DSEG
_0x64:
	.BYTE 0x11
;unsigned char enterAdminPassword(){
; 0000 010F unsigned char enterAdminPassword(){

	.CSEG
_enterAdminPassword:
; .FSTART _enterAdminPassword
; 0000 0110     unsigned char tries=0;
; 0000 0111     unsigned char key=0;
; 0000 0112     unsigned char input[4];
; 0000 0113     unsigned char i=0;
; 0000 0114     lcd_clear();
	SBIW R28,4
	CALL __SAVELOCR4
;	tries -> R17
;	key -> R16
;	input -> Y+4
;	i -> R19
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	CALL SUBOPT_0x1
; 0000 0115     lcd_gotoxy(0,0);
; 0000 0116     lcd_puts("Admin Password:");
	__POINTW2MN _0x65,0
	CALL SUBOPT_0x2
; 0000 0117     lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0118 
; 0000 0119     while(1){
_0x66:
; 0000 011A         key = getKey();
	RCALL _getKey
	MOV  R16,R30
; 0000 011B         if(key!=0){
	CPI  R16,0
	BREQ _0x69
; 0000 011C             if(key=='#'){
	CPI  R16,35
	BRNE _0x6A
; 0000 011D                 lcd_putchar('#');
	LDI  R26,LOW(35)
	RCALL _lcd_putchar
; 0000 011E                 return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A0004
; 0000 011F             }
; 0000 0120             input[i++]=key;
_0x6A:
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 0121             lcd_putchar(key);
	MOV  R26,R16
	RCALL _lcd_putchar
; 0000 0122 
; 0000 0123         }
; 0000 0124         wait();
_0x69:
	RCALL _wait
; 0000 0125 
; 0000 0126         if(i==3){
	CPI  R19,3
	BRNE _0x6B
; 0000 0127             input[3]='\0';
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0000 0128             if(strcmp(password,input)==0)
	LDI  R30,LOW(_password)
	LDI  R31,HIGH(_password)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	CALL _strcmp
	CPI  R30,0
	BRNE _0x6C
; 0000 0129                 return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A0004
; 0000 012A             else{
_0x6C:
; 0000 012B                 i=0;
	LDI  R19,LOW(0)
; 0000 012C                 lcd_clear();
	CALL SUBOPT_0x1
; 0000 012D                 lcd_gotoxy(0,0);
; 0000 012E                 lcd_puts("Admin Password:");
	__POINTW2MN _0x65,16
	CALL SUBOPT_0x2
; 0000 012F                 lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0130                 tries++;
	SUBI R17,-1
; 0000 0131             }
; 0000 0132 
; 0000 0133         }
; 0000 0134         if(tries==3){
_0x6B:
	CPI  R17,3
	BRNE _0x6E
; 0000 0135          //enableAdminButton=0;
; 0000 0136          return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A0004
; 0000 0137         }
; 0000 0138 
; 0000 0139 
; 0000 013A 
; 0000 013B     }
_0x6E:
	RJMP _0x66
; 0000 013C 
; 0000 013D 
; 0000 013E 
; 0000 013F 
; 0000 0140 
; 0000 0141 }
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND

	.DSEG
_0x65:
	.BYTE 0x20
;interrupt [EXT_INT0] void on_interrupt(){
; 0000 0142 interrupt [2] void on_interrupt(){

	.CSEG
_on_interrupt:
; .FSTART _on_interrupt
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0143     if(enableAdminButton==0)
	TST  R7
	BREQ _0x75
; 0000 0144         return;
; 0000 0145     while(PIND.2);
_0x70:
	SBIC 0x10,2
	RJMP _0x70
; 0000 0146 
; 0000 0147     if(enterAdminPassword())
	RCALL _enterAdminPassword
	CPI  R30,0
	BREQ _0x73
; 0000 0148         adminPanel();
	RCALL _adminPanel
; 0000 0149     mainScreen();
_0x73:
	RCALL _mainScreen
; 0000 014A 
; 0000 014B }
_0x75:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void init(void){
; 0000 014D void init(void){
_init:
; .FSTART _init
; 0000 014E     int i;
; 0000 014F 
; 0000 0150     Keypad = 0X0F;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(15)
	OUT  0x1B,R30
; 0000 0151     Keypad_dir = 0X0F;
	OUT  0x1A,R30
; 0000 0152     PORTC = 0X00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0153     DDRC = 0XFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0154     DDRB= 0XF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0155     PORTB=0X00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0156 
; 0000 0157     //-----------------
; 0000 0158     DDRD=0X00;
	OUT  0x11,R30
; 0000 0159     PORTD=0X00;
	OUT  0x12,R30
; 0000 015A 
; 0000 015B     #asm("SEI");
	SEI
; 0000 015C     GICR|=0X40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 015D     MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 015E     MCUCSR=0X00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 015F     GIFR=0X40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 0160 
; 0000 0161 
; 0000 0162     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0163 
; 0000 0164 
; 0000 0165 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void main(void){
; 0000 0166 void main(void){
_main:
; .FSTART _main
; 0000 0167 
; 0000 0168     init();
	RCALL _init
; 0000 0169     enableAdminButton=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 016A     mainScreen();
	RCALL _mainScreen
; 0000 016B }
_0x74:
	RJMP _0x74
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LDD  R9,Y+0
_0x20A0003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x6
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	MOV  R9,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R6,R8
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R9
	MOV  R26,R9
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20A0001
_0x2000007:
_0x2000004:
	INC  R6
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
_0x20A0002:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R8,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_password:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	IN   R30,0x19
	LDI  R31,0
	CALL __ASRW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x1:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CALL _getKey
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL _lcd_putchar
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _showMsg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

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

;END OF CODE MARKER
__END_OF_CODE:
