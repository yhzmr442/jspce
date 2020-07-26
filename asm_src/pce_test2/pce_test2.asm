;VRAM
;0000-03FF	BG0	 1KWORD
;1000-1FFF	CHR	 4KWORD	0-255CHR
;2000-2FFF	SP	 4KWORD	0-64CHR
;3000-3100	SATB
;4000-7BFF	CHRBG0	16KWORD	32*32CHR(256*256) 7C00-7FFF 1KWORD(not using)


chardatBank		.equ	2
spdatBank		.equ	3
muldatBank		.equ	4
mapdatBank		.equ	20


VDC_0			.equ	$0000
VDC_1			.equ	$0001
VDC_2			.equ	$0002
VDC_3			.equ	$0003

VDC1_0			.equ	VDC_0
VDC1_1			.equ	VDC_1
VDC1_2			.equ	VDC_2
VDC1_3			.equ	VDC_3

VDC2_0			.equ	$0010
VDC2_1			.equ	$0011
VDC2_2			.equ	$0012
VDC2_3			.equ	$0013

VPC_0			.equ	$0008
VPC_1			.equ	$0009
VPC_2			.equ	$000A
VPC_3			.equ	$000B
VPC_4			.equ	$000C
VPC_5			.equ	$000D
VPC_6			.equ	$000E
VPC_7			.equ	$000F

VCE_0			.equ	$0400
VCE_1			.equ	$0401
VCE_2			.equ	$0402
VCE_3			.equ	$0403
VCE_4			.equ	$0404
VCE_5			.equ	$0405
VCE_6			.equ	$0406
VCE_7			.equ	$0407

INT_DIS_REG		.equ	$1402

IO_PAD			.equ	$1000


;----------------------------
jcc		.macro
		bcs	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jcs		.macro
		bcc	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jeq		.macro
		bne	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jne		.macro
		beq	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jpl		.macro
		bmi	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
jmi		.macro
		bpl	.jp\@
		jmp	\1
.jp\@
		.endm


;----------------------------
add		.macro
;\1 = \2 + \3
;\1 = \1 + \2
		.if	(\# = 3)
			clc
			lda	\2
			adc	\3
			sta	\1
		.else
			.if	(\# = 2)
				clc
				lda	\1
				adc	\2
				sta	\1
			.else
				clc
				adc	\1
			.endif
		.endif
		.endm


;----------------------------
sub		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 3)
			sec
			lda	\2
			sbc	\3
			sta	\1
		.else
			.if	(\# = 2)
				sec
				lda	\1
				sbc	\2
				sta	\1
			.else
				sec
				sbc	\1
			.endif
		.endif
		.endm


;----------------------------
addw		.macro
;\1 = \2 + \3
;\1 = \1 + \2
		.if	(\# = 3)
			.if	(\?3 = 2);Immediate
				clc
				lda	\2
				adc	#LOW(\3)
				sta	\1

				lda	\2+1
				adc	#HIGH(\3)
				sta	\1+1
			.else
				clc
				lda	\2
				adc	\3
				sta	\1

				lda	\2+1
				adc	\3+1
				sta	\1+1
			.endif
		.else
			.if	(\?2 = 2);Immediate
				clc
				lda	\1
				adc	#LOW(\2)
				sta	\1

				lda	\1+1
				adc	#HIGH(\2)
				sta	\1+1
			.else
				clc
				lda	\1
				adc	\2
				sta	\1

				lda	\1+1
				adc	\2+1
				sta	\1+1
			.endif
		.endif
		.endm


;----------------------------
subw		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 3)
			.if	(\?3 = 2);Immediate
				sec
				lda	\2
				sbc	#LOW(\3)
				sta	\1

				lda	\2+1
				sbc	#HIGH(\3)
				sta	\1+1
			.else
				.if	(\?2 = 2);Immediate
					sec
					lda	#LOW(\2)
					sbc	\3
					sta	\1

					lda	#HIGH(\2)
					sbc	\3+1
					sta	\1+1
				.else
					sec
					lda	\2
					sbc	\3
					sta	\1

					lda	\2+1
					sbc	\3+1
					sta	\1+1
				.endif
			.endif
		.else
			.if	(\?2 = 2);Immediate
				sec
				lda	\1
				sbc	#LOW(\2)
				sta	\1

				lda	\1+1
				sbc	#HIGH(\2)
				sta	\1+1
			.else
				sec
				lda	\1
				sbc	\2
				sta	\1

				lda	\1+1
				sbc	\2+1
				sta	\1+1
			.endif
		.endif
		.endm


;----------------------------
addq		.macro
;\1 = \2 + \3
;\1 = \1 + \2
;\1 = \2 + \3:\4(Immediate)
		.if	(\# = 4)
				clc
				lda	\2
				adc	#LOW(\4)
				sta	\1

				lda	\2+1
				adc	#HIGH(\4)
				sta	\1+1

				lda	\2+2
				adc	#LOW(\3)
				sta	\1+2

				lda	\2+3
				adc	#HIGH(\3)
				sta	\1+3
		.else
			.if	(\# = 3)
				clc
				lda	\2
				adc	\3
				sta	\1

				lda	\2+1
				adc	\3+1
				sta	\1+1

				lda	\2+2
				adc	\3+2
				sta	\1+2

				lda	\2+3
				adc	\3+3
				sta	\1+3
			.else
				clc
				lda	\1
				adc	\2
				sta	\1

				lda	\1+1
				adc	\2+1
				sta	\1+1

				lda	\1+2
				adc	\2+2
				sta	\1+2

				lda	\1+3
				adc	\2+3
				sta	\1+3
			.endif
		.endif
		.endm


;----------------------------
subq		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 3)
			sec
			lda	\2
			sbc	\3
			sta	\1

			lda	\2+1
			sbc	\3+1
			sta	\1+1

			lda	\2+2
			sbc	\3+2
			sta	\1+2

			lda	\2+3
			sbc	\3+3
			sta	\1+3
		.else
			sec
			lda	\1
			sbc	\2
			sta	\1

			lda	\1+1
			sbc	\2+1
			sta	\1+1

			lda	\1+2
			sbc	\2+2
			sta	\1+2

			lda	\1+3
			sbc	\2+3
			sta	\1+3
		.endif
		.endm


;----------------------------
neg		.macro
		lda	\1
		eor	#$FF
		inc	a
		sta	\1
		.endm


;----------------------------
negw		.macro
		sec
		lda	\1
		eor	#$FF
		adc	#0
		sta	\1

		lda	\1+1
		eor	#$FF
		adc	#0
		sta	\1+1
		.endm


;----------------------------
negq		.macro
		sec
		lda	\1
		eor	#$FF
		adc	#0
		sta	\1

		lda	\1+1
		eor	#$FF
		adc	#0
		sta	\1+1

		lda	\1+2
		eor	#$FF
		adc	#0
		sta	\1+2

		lda	\1+3
		eor	#$FF
		adc	#0
		sta	\1+3
		.endm


;----------------------------
mov		.macro
;\1 = \2
		lda	\2
		sta	\1
		.endm


;----------------------------
movw		.macro
;\1 = \2
		.if	(\?2 = 2);Immediate
			lda	#LOW(\2)
			sta	\1
			lda	#HIGH(\2)
			sta	\1+1
		.else
			lda	\2
			sta	\1
			lda	\2+1
			sta	\1+1
		.endif
		.endm


;----------------------------
movq		.macro
;\1 = \2
;\1 = \2:\3
		.if	(\?2 = 2);Immediate
			lda	#LOW(\3)
			sta	\1
			lda	#HIGH(\3)
			sta	\1+1
			lda	#LOW(\2)
			sta	\1+2
			lda	#HIGH(\2)
			sta	\1+3
		.else
			lda	\2
			sta	\1
			lda	\2+1
			sta	\1+1
			lda	\2+2
			sta	\1+2
			lda	\2+3
			sta	\1+3
		.endif
		.endm


;----------------------------
stzw		.macro
;\1 = 0
		stz	\1
		stz	\1+1
		.endm


;----------------------------
stzq		.macro
;\1 = 0
		stz	\1
		stz	\1+1
		stz	\1+2
		stz	\1+3
		.endm


;----------------------------
cmpw		.macro
;\1 - \2
		.if	(\?2 = 2);Immediate
			sec
			lda	\1
			sbc	#LOW(\2)
			lda	\1+1
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			lda	\1+1
			sbc	\2+1
		.endif
		.endm


;----------------------------
cmpq		.macro
;\1 - \2
;\1 - \2:\3
		.if	(\?2 = 2);Immediate
			sec
			lda	\1
			sbc	#LOW(\3)
			lda	\1+1
			sbc	#HIGH(\3)
			lda	\1+2
			sbc	#LOW(\2)
			lda	\1+3
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			lda	\1+1
			sbc	\2+1
			lda	\1+2
			sbc	\2+2
			lda	\1+3
			sbc	\2+3
		.endif
		.endm


;//////////////////////////////////
		.zp
;**********************************
		.org	$2000

;++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++
lineAddr		.ds	2
lineBgAddr		.ds	2
lineBgAddrWork		.ds	2

lineDataX		.ds	4
lineDataY		.ds	4

lineDataXX		.ds	4
lineDataXY		.ds	4

lineDataYX		.ds	4
lineDataYY		.ds	4

lineX0			.ds	4
lineY0			.ds	4

lineX1			.ds	4
lineY1			.ds	4

lineX2			.ds	4
lineY2			.ds	4

lineX3			.ds	4
lineY3			.ds	4

lineLoopX		.ds	1
lineLoopY		.ds	1
lineLoopXWork		.ds	1

lineBgData		.ds	32

lineDataWork		.ds	1
;++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++
;---------------------
mul16a
div16a			.ds	2
mul16b
div16b			.ds	2
mul16c
div16c			.ds	2
mul16d
div16d			.ds	2

mul48work
div16ans		.ds	2
div16work		.ds	2
			.ds	4

mulbank			.ds	1
muladdr			.ds	2

;---------------------
;LDRU SsBA
padlast			.ds	1
padnow			.ds	1
padstate		.ds	1

;---------------------
rotationAngle		.ds	1
bgMultiply		.ds	2
multmp			.ds	6


		.bss
;**********************************
		.org 	$2100
;**********************************
		.org 	$2200
;---------------------
shipX			.ds	2
shipY			.ds	2

;---------------------
clearBGWork		.ds	2

;---------------------
paramMultiply		.ds	2
paramBgAddr		.ds	2
paramX0			.ds	2
paramY0			.ds	2
paramCountX		.ds	1
paramCountY		.ds	1

;---------------------
clearChar		.ds	32

;---------------------
spriteWork		.ds	8 * 64

;**********************************
		.org 	$3600
rotationProc		.ds	1


;//////////////////////////////////
		.code
		.bank	0
;**********************************
		.org	$E000

main:
;Initialize VDP
		jsr	initializeVdp

;On Screen
		jsr	onScreen

;set proc bank
		lda	#1
		tam	#$06

;set rotation routine
		tii	procData, rotationProc, $0A00

;clearBG
		jsr	clearBG

;clear Sprite Work
		jsr	clearSpriteWork

;initialize Rotation Proc
		jsr	initRotationProc

;set paramMultiply $8000
		movw	paramMultiply, #$8000

		movw	shipX, #128-32
		movw	shipY, #144

		stz	<rotationAngle

.rotationLoop:
		jsr	getPramIndex

		lda	paramBgAddrDataLow, x
		sta	paramBgAddr
		lda	paramBgAddrDataHigh, x
		sta	paramBgAddr+1

		lda	paramX0Data, x
		sta	paramX0
		mov	paramX0+1, #$FF

		lda	paramY0Data, x
		sta	paramY0
		mov	paramY0+1, #$FF

		lda	paramCountXData, x
		sta	paramCountX

		lda	paramCountYData, x
		sta	paramCountY


;x = xcosA - ysinA
;xcosA
		lda	rotationAngle
		add	#64
		tax

		lda	sinData0,x
		sta	<mul16c
		lda	sinData1,x
		sta	<mul16c+1
		lda	sinData2,x
		sta	<mul16d
		lda	sinData3,x
		sta	<mul16d+1

		movw	<mul16a, paramX0

		jsr	smul48

		lda	<mul16b
		sta	<multmp
		lda	<mul16b+1
		sta	<multmp+1

		lda	<mul16c
		sta	<multmp+2
		lda	<mul16c+1
		sta	<multmp+3

		lda	<mul16d
		sta	<multmp+4
		lda	<mul16d+1
		sta	<multmp+5

;ysinA
		ldx	rotationAngle

		lda	sinData0,x
		sta	<mul16c
		lda	sinData1,x
		sta	<mul16c+1
		lda	sinData2,x
		sta	<mul16d
		lda	sinData3,x
		sta	<mul16d+1

		movw	<mul16a, paramY0

		jsr	smul48

;x = xcosA - ysinA
		subq	<lineDataX, <multmp, <mul16b

		movq	<mul16c, <lineDataX

		movw	<mul16a, paramMultiply

		jsr	smul48

		movq	<lineDataX, <mul16b+1

		addq	<lineDataX, <lineDataX, #$0080, #$0000

;y = xsinA + ycosA
;xsinA
		ldx	rotationAngle

		lda	sinData0,x
		sta	<mul16c
		lda	sinData1,x
		sta	<mul16c+1
		lda	sinData2,x
		sta	<mul16d
		lda	sinData3,x
		sta	<mul16d+1

		movw	<mul16a, paramX0

		jsr	smul48

		lda	<mul16b
		sta	<multmp
		lda	<mul16b+1
		sta	<multmp+1

		lda	<mul16c
		sta	<multmp+2
		lda	<mul16c+1
		sta	<multmp+3

		lda	<mul16d
		sta	<multmp+4
		lda	<mul16d+1
		sta	<multmp+5

;ycosA
		lda	rotationAngle
		add	#64
		tax

		lda	sinData0,x
		sta	<mul16c
		lda	sinData1,x
		sta	<mul16c+1
		lda	sinData2,x
		sta	<mul16d
		lda	sinData3,x
		sta	<mul16d+1

		movw	<mul16a, #$FFC4;-60

		movw	<mul16a, paramY0

		jsr	smul48

;y = xsinA + ycosA
		addq	<lineDataY, <multmp, <mul16b

		movq	<mul16c, <lineDataY

		movw	<mul16a, paramMultiply

		jsr	smul48

		movq	<lineDataY, <mul16b+1

		addq	<lineDataY, <lineDataY, #$0080, #$0000


;set line data
		ldx	rotationAngle

		movw	<mul16a, paramMultiply

		jsr	getMultiplySin

		lda	<mul16b+1
		sta	<lineDataXY
		lda	<mul16c
		sta	<lineDataXY+1
		lda	<mul16c+1
		sta	<lineDataXY+2
		lda	<mul16d
		sta	<lineDataXY+3


		txa
		add	#64
		tax

		jsr	getMultiplySin

		lda	<mul16b+1
		sta	<lineDataXX
		lda	<mul16c
		sta	<lineDataXX+1
		lda	<mul16c+1
		sta	<lineDataXX+2
		lda	<mul16d
		sta	<lineDataXX+3

		lda	<mul16b+1
		sta	<lineDataYY
		lda	<mul16c
		sta	<lineDataYY+1
		lda	<mul16c+1
		sta	<lineDataYY+2
		lda	<mul16d
		sta	<lineDataYY+3


		txa
		add	#64
		tax

		jsr	getMultiplySin

		lda	<mul16b+1
		sta	<lineDataYX
		lda	<mul16c
		sta	<lineDataYX+1
		lda	<mul16c+1
		sta	<lineDataYX+2
		lda	<mul16d
		sta	<lineDataYX+3


		movw	<lineBgAddr, paramBgAddr
		mov	<lineLoopX, paramCountX
		mov	<lineLoopY, paramCountY

		jsr	setMap

		jsr	rotationProc

		inc	<rotationAngle

		subw	paramMultiply, #16
		lda	paramMultiply
		ora	paramMultiply+1
		bne	.mainJump01
		jsr	clearCHAR
		movw	paramMultiply, #$8000
.mainJump01:
		jmp	.rotationLoop


;----------------------------
sdiv32:
;div16d:div16c / div16a = div16a div16b
;push x
;		phx

;d sign
		lda	<div16d+1
		pha

;d eor a sign
		eor	<div16a+1
		pha

;d sign
		bbr7	<div16d+1, .sdiv16jp00

;d neg
		sec
		lda	<mul16c
		eor	#$FF
		adc	#0
		sta	<mul16c

		lda	<mul16c+1
		eor	#$FF
		adc	#0
		sta	<mul16c+1

		lda	<mul16d
		eor	#$FF
		adc	#0
		sta	<mul16d

		lda	<mul16d+1
		eor	#$FF
		adc	#0
		sta	<mul16d+1

.sdiv16jp00:
;a sign
		bbr7	<div16a+1, .sdiv16jp01

;a neg
		sec
		lda	<mul16a
		eor	#$FF
		adc	#0
		sta	<mul16a

		lda	<mul16a+1
		eor	#$FF
		adc	#0
		sta	<mul16a+1

.sdiv16jp01:
		jsr	udiv32

;anser sign
		pla
		bpl	.sdiv16jp02

;anser neg
		sec
		lda	<mul16a
		eor	#$FF
		adc	#0
		sta	<mul16a

		lda	<mul16a+1
		eor	#$FF
		adc	#0
		sta	<mul16a+1

.sdiv16jp02:
;remainder sign
		pla
		bpl	.sdiv16jp03

;remainder neg
		sec
		lda	<mul16b
		eor	#$FF
		adc	#0
		sta	<mul16b

		lda	<mul16b+1
		eor	#$FF
		adc	#0
		sta	<mul16b+1

.sdiv16jp03:
;pull x
;		plx
		rts


;----------------------------
udiv32:
;div16d:div16c / div16a = div16a div16b
;push x y
		phx
		phy

;div16a to div16b
		lda	<div16a
		sta	<div16b

		lda	<div16a+1
		sta	<div16b+1

;set zero div16a
		stz	<div16a
		stz	<div16a+1

;set zero div16ans
		stz	<div16ans
		stz	<div16ans+1

;set count
		ldx	#16

.udivloop:
;right shift div16b:div16a
		lsr	<div16b+1
		ror	<div16b
		ror	<div16a+1
		ror	<div16a

;div16d:div16c - div16b:div16a = a:y:div16work
		sec
		lda	<div16c
		sbc	<div16a
		sta	<div16work

		lda	<div16c+1
		sbc	<div16a+1
		sta	<div16work+1

		lda	<div16d
		sbc	<div16b
		tay

		lda	<div16d+1
		sbc	<div16b+1

;check div16d:div16c >= div16b:div16a
		bcc	.udivjump

		rol	<div16ans
		rol	<div16ans+1

;div16d:div16c = a:y:div16work
		sty	<div16d

		sta	<div16d+1

		lda	<div16work
		sta	<div16c

		lda	<div16work+1
		sta	<div16c+1

		dex
		bne	.udivloop
		bra	.udivjump01

.udivjump:
		rol	<div16ans
		rol	<div16ans+1
;decrement x
		dex
		bne	.udivloop

.udivjump01:
;div16ans to div16a
		lda	<div16ans
		sta	<div16a

		lda	<div16ans+1
		sta	<div16a+1

;div16c to div16b
		lda	<div16c
		sta	<div16b

		lda	<div16c+1
		sta	<div16b+1

;pull y x
		ply
		plx
		rts


;----------------------------
smul16:
;mul16d:mul16c = mul16a * mul16b
;push x
		;phx

;a eor b sign
		lda	<mul16a+1
		eor	<mul16b+1
		pha

;a sign
		bbr7	<mul16a+1, .smul16jp00

;a neg
		sec
		lda	<mul16a
		eor	#$FF
		adc	#0
		sta	<mul16a

		lda	<mul16a+1
		eor	#$FF
		adc	#0
		sta	<mul16a+1

.smul16jp00:
;b sign
		bbr7	<mul16b+1, .smul16jp01

;b neg
		sec
		lda	<mul16b
		eor	#$FF
		adc	#0
		sta	<mul16b

		lda	<mul16b+1
		eor	#$FF
		adc	#0
		sta	<mul16b+1

.smul16jp01:
		jsr	umul16

;anser sign
		pla
		bpl	.smul16jp02

;anser neg
		sec
		lda	<mul16c
		eor	#$FF
		adc	#0
		sta	<mul16c

		lda	<mul16c+1
		eor	#$FF
		adc	#0
		sta	<mul16c+1

		lda	<mul16d
		eor	#$FF
		adc	#0
		sta	<mul16d

		lda	<mul16d+1
		eor	#$FF
		adc	#0
		sta	<mul16d+1

.smul16jp02:
;pull x
		;plx
		rts


;----------------------------
umul16:
;mul16d:mul16c = mul16a * mul16b
;push x y
		phx
		phy

		lda	<mul16b
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a

		clc
		adc	#muldatBank
		sta	<mulbank
		tam	#$02

		lda	<mul16b
		and	#$1F
		ora	#$40
		stz	<muladdr
		sta	<muladdr+1

		ldy	<mul16a
		lda	[muladdr],y
		sta	<mul16c

		ldy	<mul16a+1
		lda	[muladdr],y
		sta	<mul16c+1


		lda	<mulbank
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<mul16a
		lda	[muladdr],y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[muladdr],y
		adc	#0
		sta	<mul16d


		lda	<mul16b+1
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a

		clc
		adc	#muldatBank
		sta	<mulbank
		tam	#$02

		lda	<mul16b+1
		and	#$1F
		ora	#$40
		stz	<muladdr
		sta	<muladdr+1

		clc
		ldy	<mul16a
		lda	[muladdr],y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[muladdr],y
		adc	<mul16d
		sta	<mul16d

		cla
		adc	#0
		sta	<mul16d+1

		lda	<mulbank
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<mul16a
		lda	[muladdr],y
		adc	<mul16d
		sta	<mul16d

		ldy	<mul16a+1
		lda	[muladdr],y
		adc	<mul16d+1
		sta	<mul16d+1

;pull y x
.end000:
		ply
		plx
		rts


;----------------------------
getPadData:
;
		lda	<padnow
		sta	<padlast

		lda	#$01
		sta	IO_PAD
		lda	#$03
		sta	IO_PAD

		lda	#$01
		sta	IO_PAD
		lda	IO_PAD
		asl	a
		asl	a
		asl	a
		asl	a
		sta	<padnow

		lda	#$00
		sta	IO_PAD
		lda	IO_PAD
		and	#$0F
		ora	<padnow
		eor	#$FF
		sta	<padnow

		lda	<padlast
		eor	#$FF
		and	<padnow
		sta	<padstate

		rts


;----------------------------
initializeVdp:
;
;reset wait
		cly
.resetWaitloop0:
		clx
.resetWaitloop1:
		dex
		bne	.resetWaitloop1
		dey
		bne	.resetWaitloop0

;set vdp
vdpdataloop:	lda	vdpdata, y
		cmp	#$FF
		beq	vdpdataend
		sta	VDC_0
		iny

		lda	vdpdata, y
		sta	VDC_2
		iny

		lda	vdpdata, y
		sta	VDC_3
		iny
		bra	vdpdataloop
vdpdataend:

;disable interrupts TIQD       IRQ2D
		lda	#$05
		sta	INT_DIS_REG

;262Line  VCE Clock 5MHz
		lda	#$04
		sta	VCE_0
		stz	VCE_1

;CHAR set palette
		stz	VCE_2
		stz	VCE_3
		tia	palettedata, VCE_4, $20

;CHAR set to vram
		lda	#chardatBank
		tam	#$06

;vram address $1000
		st0	#$00
		st1	#$00
		st2	#$10

		st0	#$02
		tia	$C000, VDC_2, $1000

;SP set palette
		stz	VCE_2
		lda	#$01
		sta	VCE_3
		tia	palettedata, VCE_4, $20

;SP set to vram
		lda	#spdatBank
		tam	#$06

;vram address $1000
		st0	#$00
		st1	#$00
		st2	#$20

		st0	#$02
		tia	$C000, VDC_2, $1000

;clear zeropage
		stz	$2000
		tii	$2000, $2001, $00FF

		rts


;----------------------------
onScreen:
;on screen
;bg sp       vsync
;+1
		st0	#$05
		st1	#$C8
		st2	#$00
		rts


;----------------------------
_irq1:
;IRQ1 interrupt process
		pha
		phx
		phy

;ACK interrupt
		lda	VDC_0

		jsr	getPadData

		bbr7	<padnow, .padJump0	;LEFT
		subw	shipX, #2
.padJump0:

		bbr5	<padnow, .padJump1	;RIGHT
		addw	shipX, #2
.padJump1:

		bbr4	<padnow, .padJump2	;UP
		subw	shipY, #2
.padJump2:

		bbr6	<padnow, .padJump3	;DOWN
		addw	shipY, #2
.padJump3:


;ship sprite locate
		addw	spriteWork, shipY, #64
		addw	spriteWork+2, shipX, #32
		movw	spriteWork+4, #$0100
		movw	spriteWork+6, #$1180

		addw	spriteWork+8, shipY, #64
		addw	spriteWork+10, shipX, #32+32
		movw	spriteWork+12, #$0108
		movw	spriteWork+14, #$1180


;set sprite
		st0	#$00
		st1	#$00
		st2	#$30

		st0	#$02
		tia	spriteWork, VDC_2, 8 * 64

;SATB DMA set
		st0	#$13
		st1	#$00
		st2	#$30


		ply
		plx
		pla
		rti


;----------------------------
_reset:
;reset process
;disable interrupts
		sei
;select the 7.16 MHz clock
		csh
;clear the decimal flag
		cld
;initialize the stack pointer
		ldx	#$FF
		txs
;I/O page0
		lda	#$FF
		tam	#$00
;RAM page1
		lda	#$F8
		tam	#$01

;jump main
		jmp	main


;----------------------------
_irq2:
_timer:
_nmi:
;IRQ2 TIMER NMI interrupt process
		rti


;----------------------------
vdpdata:
		.db	$05, $00, $00	;screen off +1
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $0D	;VSW $02 VDS $0D
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $03, $00	;VCR $03
		.db	$0F, $00, $00	;DMA INC INC
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $00, $00	;32x32
		.db	$FF		;end


;----------------------------
palettedata:
		.dw	$0007, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
;interrupt vectors
		.org	$FFF6

		.dw	_irq2
		.dw	_irq1
		.dw	_timer
		.dw	_nmi
		.dw	_reset


;////////////////////////////
		.bank	1

		.org	$C000

;----------------------------
clearCHAR:
		movw	clearBGWork, #$4000

		ldy	#30
.loopY:
		ldx	#32
.loopX:
		sei
		st0	#$00
		movw	VDC_2, clearBGWork
		st0	#$02
		tia	clearChar, VDC_2, 32
		cli

		addw	clearBGWork, #16

		dex
		bne	.loopX

		dey
		bne	.loopY

		rts


;----------------------------
clearSpriteWork:
		stz	spriteWork
		tii	spriteWork, spriteWork+1, 8 * 64 - 1
		rts


;----------------------------
clearBG:
;clear BG0 BAT
		movw	clearBGWork, #$0400

		st0	#$00
		st1	#$00
		st2	#$00

		st0	#$02
		ldy	#32
.clearbatloop0:
		ldx	#32
.clearbatloop1:
		movw	VDC_2, clearBGWork

		addw	clearBGWork, #1

		dex
		bne	.clearbatloop1
		dey
		bne	.clearbatloop0

		rts


;----------------------------
initRotationProc:
		stz	<lineBgData+16
		tii	lineBgData+16, lineBgData+17, 15

		stz	clearChar
		tii	clearChar, clearChar+1, 31

		rts


;----------------------------
setMap:
		lda	#mapdatBank
		tam	#$02
		inc	a
		tam	#$03
		inc	a
		tam	#$04
		inc	a
		tam	#$05

		rts


;----------------------------
getMultiplySin
;reg x angle
;mul16a multiplier
		lda	sinData0, x
		sta	<mul16c
		lda	sinData1, x
		sta	<mul16c+1
		lda	sinData2, x
		sta	<mul16d
		lda	sinData3, x
		sta	<mul16d+1

		jsr	smul48

		rts


;----------------------------
smul48:
;mul16d:mul16c:mul16b = mul16d:mul16c * mul16a

;a eor d sign
		lda	<mul16a+1
		eor	<mul16d+1
		pha

;a sign
		bbr7	<mul16a+1, .smul48jp00

;a neg
		sec
		lda	<mul16a
		eor	#$FF
		adc	#0
		sta	<mul16a

		lda	<mul16a+1
		eor	#$FF
		adc	#0
		sta	<mul16a+1

.smul48jp00:
;d sign
		bbr7	<mul16d+1, .smul48jp01

;d neg
		sec
		lda	<mul16c
		eor	#$FF
		adc	#0
		sta	<mul16c

		lda	<mul16c+1
		eor	#$FF
		adc	#0
		sta	<mul16c+1

		lda	<mul16d
		eor	#$FF
		adc	#0
		sta	<mul16d

		lda	<mul16d+1
		eor	#$FF
		adc	#0
		sta	<mul16d+1

.smul48jp01:
		jsr	umul48

;anser sign
		pla
		bpl	.smul48jp02

;anser neg
		sec
		lda	<mul16b
		eor	#$FF
		adc	#0
		sta	<mul16b

		lda	<mul16b+1
		eor	#$FF
		adc	#0
		sta	<mul16b+1

		lda	<mul16c
		eor	#$FF
		adc	#0
		sta	<mul16c

		lda	<mul16c+1
		eor	#$FF
		adc	#0
		sta	<mul16c+1

		lda	<mul16d
		eor	#$FF
		adc	#0
		sta	<mul16d

		lda	<mul16d+1
		eor	#$FF
		adc	#0
		sta	<mul16d+1

.smul48jp02:
		rts


;----------------------------
umul48:
;mul16d:mul16c:mul16b = mul16d:mul16c * mul16a

;mul48work+6 = mul16d
		movw	<mul48work+6, <mul16d

;mul16c * mul16a
		movw	<mul16b, <mul16c
		jsr	umul16

;mul48work+2:mul48work = mul16d:mul16c
		movq	<mul48work, <mul16c

;mul16d * mul16a
		movw	<mul16b, <mul48work+6
		jsr	umul16

;mul48work+4:mul48work+2 + mul16d:mul16c
		stzw	<mul48work+4
		addq	<mul48work+2, <mul16c

;mul16d:mul16c:mul16b = mul48work+4:mul48work+2:mul48work
		movq	<mul16b, <mul48work
		movw	<mul16d, <mul48work+4

		rts


;---------------------
getPramIndex:
		lda	paramMultiply+1

		cmp	#$17
		bcc	.j0	;<$17
		ldx	#$0F
		bra	.end

.j0:
		cmp	#$0F
		bcc	.j1	;<$0F
		ldx	#$0E
		bra	.end

.j1:
		cmp	#$04
		bcc	.j2	;<$04
		tax
		dex
		bra	.end

.j2:
		cmp	#$03
		bcc	.j3	;<$03
		lda	paramMultiply
		cmp	#$40
		bcc	.j3	;<$40
		ldx	#$02
		bra	.end

.j3:
		clx

.end:
		rts


;---------------------
paramBgAddrDataLow
		.db	$00, $00, $20, $40, $60, $80, $80, $A0, $A0, $A0, $A0, $C0, $C0, $C0, $C0, $E0


;---------------------
paramBgAddrDataHigh
		.db	$40, $40, $42, $46, $4A, $4E, $4E, $52, $52, $52, $52, $56, $56, $56, $56, $5A


;---------------------
paramX0Data
		.db	$C0, $C0, $C8, $D0, $D8, $E0, $E0, $E8, $E8, $E8, $E8, $F0, $F0, $F0, $F0, $F8


;---------------------
paramY0Data
		.db	$C4, $C4, $C8, $D0, $D8, $E0, $E0, $E8, $E8, $E8, $E8, $F0, $F0, $F0, $F0, $F8


;---------------------
paramCountXData
		.db	32, 32, 28, 24, 20, 16, 16, 12, 12, 12, 12,  8,  8,  8,  8,  4


;---------------------
paramCountYData
		.db	30, 30, 28, 24, 20, 16, 16, 12, 12, 12, 12,  8,  8,  8,  8,  4


;---------------------

		INCLUDE	"proc.txt"


;---------------------
sinData3
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;---------------------
sinData2
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;---------------------
sinData1
		.db	$00, $06, $0C, $12, $19, $1F, $25, $2B, $31, $38, $3E, $44, $4A, $50, $56, $5C,\
			$61, $67, $6D, $73, $78, $7E, $83, $88, $8E, $93, $98, $9D, $A2, $A7, $AB, $B0,\
			$B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1, $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA,\
			$EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9, $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF,\
			$00, $FF, $FF, $FF, $FE, $FE, $FD, $FC, $FB, $F9, $F8, $F6, $F4, $F3, $F1, $EE,\
			$EC, $EA, $E7, $E4, $E1, $DE, $DB, $D8, $D4, $D1, $CD, $C9, $C5, $C1, $BD, $B9,\
			$B5, $B0, $AB, $A7, $A2, $9D, $98, $93, $8E, $88, $83, $7E, $78, $73, $6D, $67,\
			$61, $5C, $56, $50, $4A, $44, $3E, $38, $31, $2B, $25, $1F, $19, $12, $0C, $06,\
			$00, $F9, $F3, $ED, $E6, $E0, $DA, $D4, $CE, $C7, $C1, $BB, $B5, $AF, $A9, $A3,\
			$9E, $98, $92, $8C, $87, $81, $7C, $77, $71, $6C, $67, $62, $5D, $58, $54, $4F,\
			$4A, $46, $42, $3E, $3A, $36, $32, $2E, $2B, $27, $24, $21, $1E, $1B, $18, $15,\
			$13, $11, $0E, $0C, $0B, $09, $07, $06, $04, $03, $02, $01, $01, $00, $00, $00,\
			$00, $00, $00, $00, $01, $01, $02, $03, $04, $06, $07, $09, $0B, $0C, $0E, $11,\
			$13, $15, $18, $1B, $1E, $21, $24, $27, $2B, $2E, $32, $36, $3A, $3E, $42, $46,\
			$4A, $4F, $54, $58, $5D, $62, $67, $6C, $71, $77, $7C, $81, $87, $8C, $92, $98,\
			$9E, $A3, $A9, $AF, $B5, $BB, $C1, $C7, $CE, $D4, $DA, $E0, $E6, $ED, $F3, $F9



;---------------------
sinData0
		.db	$00, $48, $90, $D5, $18, $56, $90, $C4, $F1, $17, $34, $47, $50, $4D, $3E, $22,\
			$F8, $BE, $74, $1A, $AD, $2F, $9C, $F6, $3A, $68, $80, $80, $68, $36, $EB, $86,\
			$05, $68, $AF, $D8, $E4, $D1, $9F, $4D, $DB, $48, $94, $BE, $C6, $AA, $6C, $0A,\
			$83, $D9, $09, $14, $FA, $BA, $54, $C8, $15, $3B, $3B, $13, $C4, $4E, $B1, $EC,\
			$00, $EC, $B1, $4E, $C4, $13, $3B, $3B, $15, $C8, $54, $BA, $FA, $14, $09, $D9,\
			$83, $0A, $6C, $AA, $C6, $BE, $94, $48, $DB, $4D, $9F, $D1, $E4, $D8, $AF, $68,\
			$05, $86, $EB, $36, $68, $80, $80, $68, $3A, $F6, $9C, $2F, $AD, $1A, $74, $BE,\
			$F8, $22, $3E, $4D, $50, $47, $34, $17, $F1, $C4, $90, $56, $18, $D5, $90, $48,\
			$00, $B8, $70, $2B, $E8, $AA, $70, $3C, $0F, $E9, $CC, $B9, $B0, $B3, $C2, $DE,\
			$08, $42, $8C, $E6, $53, $D1, $64, $0A, $C6, $98, $80, $80, $98, $CA, $15, $7A,\
			$FB, $98, $51, $28, $1C, $2F, $61, $B3, $25, $B8, $6C, $42, $3A, $56, $94, $F6,\
			$7D, $27, $F7, $EC, $06, $46, $AC, $38, $EB, $C5, $C5, $ED, $3C, $B2, $4F, $14,\
			$00, $14, $4F, $B2, $3C, $ED, $C5, $C5, $EB, $38, $AC, $46, $06, $EC, $F7, $27,\
			$7D, $F6, $94, $56, $3A, $42, $6C, $B8, $25, $B3, $61, $2F, $1C, $28, $51, $98,\
			$FB, $7A, $15, $CA, $98, $80, $80, $98, $C6, $0A, $64, $D1, $53, $E6, $8C, $42,\
			$08, $DE, $C2, $B3, $B0, $B9, $CC, $E9, $0F, $3C, $70, $AA, $E8, $2B, $70, $B8


;++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++
		.org	$D700

;---------------------
bgDataAddr
		.db	$40, $40, $41, $41, $42, $42, $43, $43, $44, $44, $45, $45, $46, $46, $47, $47,\
			$48, $48, $49, $49, $4A, $4A, $4B, $4B, $4C, $4C, $4D, $4D, $4E, $4E, $4F, $4F,\
			$50, $50, $51, $51, $52, $52, $53, $53, $54, $54, $55, $55, $56, $56, $57, $57,\
			$58, $58, $59, $59, $5A, $5A, $5B, $5B, $5C, $5C, $5D, $5D, $5E, $5E, $5F, $5F,\
			$60, $60, $61, $61, $62, $62, $63, $63, $64, $64, $65, $65, $66, $66, $67, $67,\
			$68, $68, $69, $69, $6A, $6A, $6B, $6B, $6C, $6C, $6D, $6D, $6E, $6E, $6F, $6F,\
			$70, $70, $71, $71, $72, $72, $73, $73, $74, $74, $75, $75, $76, $76, $77, $77,\
			$78, $78, $79, $79, $7A, $7A, $7B, $7B, $7C, $7C, $7D, $7D, $7E, $7E, $7F, $7F,\
			$80, $80, $81, $81, $82, $82, $83, $83, $84, $84, $85, $85, $86, $86, $87, $87,\
			$88, $88, $89, $89, $8A, $8A, $8B, $8B, $8C, $8C, $8D, $8D, $8E, $8E, $8F, $8F,\
			$90, $90, $91, $91, $92, $92, $93, $93, $94, $94, $95, $95, $96, $96, $97, $97,\
			$98, $98, $99, $99, $9A, $9A, $9B, $9B, $9C, $9C, $9D, $9D, $9E, $9E, $9F, $9F,\
			$A0, $A0, $A1, $A1, $A2, $A2, $A3, $A3, $A4, $A4, $A5, $A5, $A6, $A6, $A7, $A7,\
			$A8, $A8, $A9, $A9, $AA, $AA, $AB, $AB, $AC, $AC, $AD, $AD, $AE, $AE, $AF, $AF,\
			$B0, $B0, $B1, $B1, $B2, $B2, $B3, $B3, $B4, $B4, $B5, $B5, $B6, $B6, $B7, $B7,\
			$B8, $B8, $B9, $B9, $BA, $BA, $BB, $BB, $BC, $BC, $BD, $BD, $BE, $BE, $BF, $BF

;---------------------
bgDataLow0
		.db	$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F,\
			$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F,\
			$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F,\
			$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F,\
			$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F,\
			$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F,\
			$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F,\
			$00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03,\
			$0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F, $0C, $0F

;---------------------
bgDataLow1
		.db	$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F,\
			$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F,\
			$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F,\
			$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03, $00, $00, $03, $03,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F,\
			$0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F, $0C, $0C, $0F, $0F


;---------------------
bgDataLow2
		.db	$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F,\
			$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $03, $03, $03, $03,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F


;---------------------
bgDataLow3
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F


;---------------------
bgDataHigh0
		.db	$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0,\
			$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0,\
			$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0,\
			$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0,\
			$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0,\
			$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0,\
			$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0,\
			$00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30, $00, $30,\
			$C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0, $C0, $F0


;---------------------
bgDataHigh1
		.db	$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0,\
			$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0,\
			$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0,\
			$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30, $00, $00, $30, $30,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0,\
			$C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0, $C0, $C0, $F0, $F0


;---------------------
bgDataHigh2
		.db	$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0,\
			$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $30, $30, $30, $30,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0


;---------------------
bgDataHigh3
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $30, $30, $30, $30,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0


;++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++


;////////////////////////////
		.bank	2
		INCBIN	"char.dat"		;    8K   2    $02
		INCBIN	"sp.dat"		;    8K   3    $03
		INCBIN	"mul.dat"		;  128K   4~19 $04~$13
		INCBIN	"map.dat"		;   32K  20~23 $14~$17
