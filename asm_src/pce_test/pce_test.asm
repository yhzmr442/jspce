;VRAM
;0000-03FF	BG0	 1KWORD
;0400-07FF	BG1	 1KWORD
;0800-0FFF		 2KWORD	SPCHR SATB
;1000-1FFF	CHR	 4KWORD	0-255CHR
;2000-37FF	CHRBG0	 6KWORD	32*12CHR(256*192 2bpp)
;3800-4FFF	CHRBG1	 6KWORD	32*12CHR(256*192 2bpp)
;5000-7FFF


CHRBG0Addr		.equ	$20
CHRBG1Addr		.equ	$38

chardatBank		.equ	2
muldatBank		.equ	3
divdatBank		.equ	19

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
			clc
			lda	\1
			adc	\2
			sta	\1
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
			sec
			lda	\1
			sbc	\2
			sta	\1
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
		lda	\2
		sta	\1
		lda	\2+1
		sta	\1+1
		lda	\2+2
		sta	\1+2
		lda	\2+3
		sta	\1+3
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

;---------------------
mul16a
div16a			.ds	2
mul16b
div16b			.ds	2
mul16c
div16c			.ds	2
mul16d
div16d			.ds	2
div16ans		.ds	2
div16work		.ds	2

mulbank			.ds	1
muladdr			.ds	2

udiv32_2Work		.ds	2

;---------------------
;LDRU SsBA
padlast			.ds	1
padnow			.ds	1
padstate		.ds	1

;---------------------
puthexaddr		.ds	2
puthexdata		.ds	1

;---------------------
randomseed		.ds	2

;---------------------
clearBGWork		.ds	2

CH0			.ds	1
CH1			.ds	1
getVramChrAddr		.ds	2
setVramChrAddr		.ds	2

CH0Data			.ds	1
CH1Data			.ds	1
CHMask			.ds	1
CHNegMask		.ds	1

;---------------------
edgeX0			.ds	1
edgeY0			.ds	1
edgeX1			.ds	1
edgeY1			.ds	1

edgeSlopeX		.ds	2
edgeSlopeY		.ds	2

edgeSigneX		.ds	1

edgeSlopeTemp		.ds	2

;---------------------
lineX0			.ds	2
lineY0			.ds	2
lineX1			.ds	2
lineY1			.ds	2

clip2DFlag		.ds	1

;---------------------
wireBGAddr		.ds	1

wirePixelX		.ds	1
wirePixelY		.ds	1

wireLineX0		.ds	1
wireLineX1		.ds	1
wireLineY		.ds	1

wireLineLeftAddr	.ds	2
wireLineRightAddr	.ds	2

wireLineLeftData	.ds	1
wireLineLeftMask	.ds	1

wireLineRightData	.ds	1
wireLineRightMask	.ds	1

wireLineCount		.ds	1

;---------------------
vertexCount		.ds	1
vertexCountWork		.ds	1
vertex0Addr		.ds	2
vertex1Addr		.ds	2
vertexWork		.ds	4

translationX		.ds	2
translationY		.ds	2
translationZ		.ds	2

centerX			.ds	2
centerY			.ds	2

;---------------------
modelAddr		.ds	2
modelAddrWork		.ds	2
modelWireCount		.ds	1

;---------------------
rotationX		.ds	1
rotationY		.ds	1
rotationZ		.ds	1

;---------------------
frontClipFlag		.ds	1
drawModelData0		.ds	1
drawModelData1		.ds	1
clipFrontX		.ds	2
clipFrontY		.ds	2

;---------------------
rotationSelect		.ds	1

;---------------------
drawFlag		.ds	1

;---------------------
clearVramDmaAddr	.ds	1
clearVramCount		.ds	1
clearVramFlag		.ds	1

;---------------------
eyeTranslationX		.ds	2
eyeTranslationY		.ds	2
eyeTranslationZ		.ds	2

eyeRotationX		.ds	1
eyeRotationY		.ds	1
eyeRotationZ		.ds	1

eyeRotationSelect	.ds	1

;---------------------
vdcStatus		.ds	1

;---------------------
lineColor		.ds	1
lineBufferCount		.ds	1
lineBufferAddr		.ds	2


		.bss
;**********************************
		.org 	$2100
;**********************************
		.org 	$2200
;---------------------
matrix0			.ds	2*3*3
matrix1			.ds	2*3*3
matrix2			.ds	2*3*3

;---------------------
eyeMatrix		.ds	2*3*3

;---------------------
transform2DWork0	.ds	256
transform2DWork1	.ds	256

;---------------------
shipTranslationX	.ds	2
shipTranslationY	.ds	2
shipTranslationZ	.ds	2

shipRotationX		.ds	1
shipRotationY		.ds	1
shipRotationZ		.ds	1

;---------------------
ringDatas		.ds	8*8
setRingCount		.ds	1
ringRandomData		.ds	2

ringGetCount		.ds	1
hitCheckRingWork	.ds	4

ringSwitchColor		.ds	1

;---------------------
lineBuffer		.ds	1024


;//////////////////////////////////
		.code
		.bank	0
;**********************************
		.org	$E000

;+++++++++++++++++++++++++++++++++++++++++
main:
;Initialize VDP
		jsr	initializeVdp

;On Screen
		jsr	onScreen

;Initialize random
		jsr	initRandom

;set wire proc bank
		lda	#$01
		tam	#$06

;clearBG
		jsr	clearBG

;initialize wire proc
		jsr	initWire

;set screen center
		mov	<centerX, #128
		mov	<centerY, #96

;initialize switch color
		jsr	initSwitchColor

;set eye position
		stzw	<eyeTranslationX
		stzw	<eyeTranslationY
		movw	<eyeTranslationZ, #$FF00

;set eye angle
		stz	<eyeRotationX
		stz	<eyeRotationY
		stz	<eyeRotationZ

;set eye rotation order
		mov	<eyeRotationSelect, #$3F

;initialize ship position
		stzw	shipTranslationX
		stzw	shipTranslationY
		stzw	shipTranslationZ

;initialize ship angle
		stz	shipRotationX
		stz	shipRotationY
		stz	shipRotationZ

		jsr	initRing

		cli
.mainloop:
		jsr	checkPad

		jsr	moveEye

		jsr	moveRing

		jsr	hitCheckRing

		jsr	setRing

		jsr	initLineBuffer

		jsr	drawRing
		jsr	drawShip

		jsr	clearVram
		jsr	putLineBuffer

		lda	ringGetCount
		ldx	#2
		ldy	#24
		jsr	puthex

.mainLoopEnd:
		jsr	switchColor

		jsr	switchBG

		jmp	.mainloop


;----------------------------
moveEye:
;
		movw	<eyeTranslationX, shipTranslationX

		lda	<eyeTranslationX+1
		asl	a
		ror	<eyeTranslationX+1
		ror	<eyeTranslationX

		cmpw	<eyeTranslationX, #$FF81
		bpl	.eyeJump0	; >= -127

		addw	<eyeTranslationX, shipTranslationX, #$007F

.eyeJump0:
		cmpw	<eyeTranslationX, #$0080
		bmi	.eyeJump1	; < 128

		subw	<eyeTranslationX, shipTranslationX, #$007F

.eyeJump1:
		movw	<eyeTranslationY, shipTranslationY

		lda	<eyeTranslationY+1
		asl	a
		ror	<eyeTranslationY+1
		ror	<eyeTranslationY

		cmpw	<eyeTranslationY, #$FF81
		bpl	.eyeJump2	; >= -127

		addw	<eyeTranslationY, shipTranslationY, #$007F

.eyeJump2:
		cmpw	<eyeTranslationY, #$0080
		bmi	.eyeJump3	; < 128

		subw	<eyeTranslationY, shipTranslationY, #$007F

.eyeJump3:
		rts


;----------------------------
hitCheckRing:
;
		clx

.hitCheckRingLoop:
		lda	ringDatas,x
		jmi	.hitCheckRingJump0

.hitCheckRingJump1:
		lda	ringDatas+6,x
		ora	ringDatas+7,x
		jne	.hitCheckRingJump0

.hitCheckRingJump2:
		sec
		lda	ringDatas+2,x
		sbc	shipTranslationX
		sta	<mul16a
		sta	<mul16b
		lda	ringDatas+3,x
		sbc	shipTranslationX+1
		sta	<mul16a+1
		sta	<mul16b+1

		jsr	smul16

		movq	hitCheckRingWork, <mul16c

		sec
		lda	ringDatas+4,x
		sbc	shipTranslationY
		sta	<mul16a
		sta	<mul16b
		lda	ringDatas+5,x
		sbc	shipTranslationY+1
		sta	<mul16a+1
		sta	<mul16b+1

		jsr	smul16

		addq	hitCheckRingWork, <mul16c

		cmpq	hitCheckRingWork, #$0000, #$4000 ;$00004000 = 128 * 128

		bpl	.hitCheckRingJump0

		lda	#$FF
		sta	ringDatas,x

		inc	ringGetCount

.hitCheckRingJump0:
		clc
		txa
		adc	#8
		tax
		cpx	#64
		jne	.hitCheckRingLoop

.hitCheckRingJump3:
		rts


;----------------------------
initRing:
;
		stz	ringGetCount
		stz	setRingCount

		clx

.initRingLoop:
		lda	#$FF
		sta	ringDatas,x

		clc
		txa
		adc	#8
		tax
		cpx	#64
		bne	.initRingLoop

		rts


;----------------------------
setRing:
;
		lda	setRingCount
		inc	a
		and	#$1F
		sta	setRingCount
		bne	.setRingEnd

		clx

.setRingLoop:
		lda	ringDatas,x
		bpl	.setRingJump0

		lda	#$00
		sta	ringDatas,x

		lda	#$00
		sta	ringDatas+1,x

		jsr	getRingRandom
		lda	ringRandomData
		sta	ringDatas+2,x
		lda	ringRandomData+1
		sta	ringDatas+3,x

		jsr	getRingRandom
		lda	ringRandomData
		sta	ringDatas+4,x
		lda	ringRandomData+1
		sta	ringDatas+5,x

		lda	#$00
		sta	ringDatas+6,x
		lda	#$0C
		sta	ringDatas+7,x

		bra	.setRingEnd

.setRingJump0:
		clc
		txa
		adc	#8
		tax
		cpx	#64
		bne	.setRingLoop

.setRingEnd:
		rts


;----------------------------
getRingRandom:
;
		jsr	getRandom
		sta	ringRandomData
		jsr	getRandom
		and	#$01
		sta	ringRandomData+1

		subw	ringRandomData, #$0100

		rts


;----------------------------
moveRing:
;
		clx

.moveRingLoop:
		lda	ringDatas,x
		bmi	.moveRingJump0

		inc	ringDatas+1,x
		inc	ringDatas+1,x
		inc	ringDatas+1,x
		inc	ringDatas+1,x

		sec
		lda	ringDatas+6,x
		sbc	#$20
		sta	ringDatas+6,x
		lda	ringDatas+7,x
		sbc	#$00
		sta	ringDatas+7,x

		sec
		lda	ringDatas+6,x
		sbc	#$00
		lda	ringDatas+7,x
		sbc	#$FF

		bpl	.moveRingJump0

		lda	#$FF
		sta	ringDatas,x

.moveRingJump0:
		clc
		txa
		adc	#8
		tax
		cpx	#64
		bne	.moveRingLoop

		rts


;----------------------------
drawRing:
;
		clx

.drawRingLoop:
		lda	ringDatas,x
		bmi	.drawRingJump0

		lda	ringDatas+2,x
		sta	<translationX
		lda	ringDatas+3,x
		sta	<translationX+1
		lda	ringDatas+4,x
		sta	<translationY
		lda	ringDatas+5,x
		sta	<translationY+1
		lda	ringDatas+6,x
		sta	<translationZ
		lda	ringDatas+7,x
		sta	<translationZ+1

		bmi	.drawRingJump3
		beq	.drawRingJump1

		lda	#2
		bra	.drawRingJump2
.drawRingJump1:
		lda	#2
		ora	ringSwitchColor
		bra	.drawRingJump2
.drawRingJump3:
		lda	#3
.drawRingJump2:
		jsr	setLineColor

		stz	<rotationX
		stz	<rotationY
		lda	ringDatas+1,x
		sta	<rotationZ

		mov	<rotationSelect, #$21

		movw	<modelAddr, #modelRingData

		jsr	drawModel2

.drawRingJump0:
		clc
		txa
		adc	#8
		tax
		cpx	#64
		bne	.drawRingLoop

		rts


;----------------------------
drawShip:
;
		movw	<translationX, shipTranslationX
		movw	<translationY, shipTranslationY
		movw	<translationZ, shipTranslationZ

		mov	<rotationX, shipRotationX
		mov	<rotationY, shipRotationY
		mov	<rotationZ, shipRotationZ

		lda	#1
		jsr	setLineColor

		lda	#$21
		sta	<rotationSelect

		movw	<modelAddr, #modelArwingData

		jsr	drawModel2

		rts


;----------------------------
initSwitchColor:
;
		stz	ringSwitchColor
		rts


;----------------------------
switchColor:
;
		lda	ringSwitchColor
		eor	#$01
		sta	ringSwitchColor
		rts


;----------------------------
checkPad2:
;check pad
.checkPadUp:
		bbr4	<padnow, .checkPadDown
		inc	shipRotationX

.checkPadDown:
		bbr6	<padnow, .checkPadLeft
		dec	shipRotationX

.checkPadLeft:
		bbr7	<padnow, .checkPadRight
		dec	shipRotationY

.checkPadRight:
		bbr5	<padnow, .checkPadA
		inc	shipRotationY

.checkPadA:
		bbr0	<padnow, .checkPadB
		inc	shipRotationZ

.checkPadB:
		bbr1	<padnow, .checkPadEnd
		dec	shipRotationZ

.checkPadEnd:
		rts


;----------------------------
checkPad:
;check pad
.checkPadUp:
		bbr4	<padnow, .checkPadDown
		subw	shipTranslationY, #16

.checkPadDown:
		bbr6	<padnow, .checkPadLeft
		addw	shipTranslationY, #16

.checkPadLeft:
		bbr7	<padnow, .checkPadRight
		subw	shipTranslationX, #16

.checkPadRight:
		bbr5	<padnow, .checkPadEnd
		addw	shipTranslationX, #16

.checkPadEnd:
		rts


;----------------------------
sdiv32:
;div16d:div16c / div16a = div16a div16b
;push x
		phx

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
		plx
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
initRandom:
;
		lda	#$C0
		sta	randomseed
		sta	randomseed+1
		rts


;----------------------------
getRandom:
;
		lda	randomseed+1
		lsr	a
		rol	randomseed
		bcc	.getrandomJump
		eor	#$B4
.getrandomJump:
		sta	randomseed+1
		eor	randomseed

		rts


;----------------------------
numtochar:
;in  A Register $0 to $F
;out A Register '0'-'9'($30-$39) 'A'-'Z'($41-$5A)
		cmp	#10
		bcs	.numtochar000
		ora	#$30
		rts
.numtochar000:
		adc	#$41-10-1
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

;set palette
		stz	VCE_2
		stz	VCE_3
		tia	palettedata, VCE_4, $80

;CHAR set to vram
		lda	#chardatBank
		tam	#$06

;vram address $1000
		st0	#$00
		st1	#$00
		st2	#$10

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
		sta	<vdcStatus

		jsr	wireIrqProc
		bcs	.irqEnd

		jsr	getPadData

.irqEnd:
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
modelArwingData
		.dw	modelArwingDataWire
		.db	30	;wire count
		.dw	modelArwingDataVertex
		.db	16	;vertex count

modelArwingDataWire
		.db	 0*6, 1*6	;0 Front Bottom Right
		.db	 0*6, 2*6	;1 Front Bottom Left
		.db	 1*6, 2*6	;2 Front Bottom Back

		.db	 0*6, 3*6	;3 Front Right Top
		.db	 1*6, 3*6	;4 Front Right Back

		.db	 2*6, 3*6	;5 Front Left Back

		.db	 1*6, 4*6	;6 Middle Outer Right Top
		.db	 3*6, 4*6	;7 Middle Outer Right Back

		.db	 2*6, 4*6	;8 Middle Outer Left Back

		.db	 1*6, 5*6	;9 Middle Inner Right
		.db	 2*6, 5*6	;10 Middle Inner Left

		.db	 4*6, 5*6	;11 Middle Inner Top

		.db	 7*6, 6*6	;12 Right Wing Right
		.db	 6*6, 1*6	;13 Right Wing Top
		.db	 7*6, 1*6	;14 Right Wing Left

		.db	 6*6, 8*6	;15 Right Wing Right Top
		.db	 7*6, 8*6	;16 Right Wing Right Bottom
		.db	 1*6, 8*6	;17 Right Wing Left Top

		.db	 2*6, 9*6	;18 Left Wing Top
		.db	 9*6,10*6	;19 Left Wing Left
		.db	 2*6,10*6	;20 Left Wing Right

		.db	 9*6,11*6	;21 Left Wing Left Top
		.db	10*6,11*6	;22 Left Wing Left Bottom
		.db	 2*6,11*6	;23 Left Wing Right Top

		.db	 1*6,13*6	;24 Right Wing
		.db	13*6,12*6	;25 Right Wing
		.db	 1*6,12*6	;26 Right Wing

		.db	 2*6,14*6	;27 Left Wing
		.db	14*6,15*6	;28 Left Wing
		.db	 2*6,15*6	;29 Left Wing

modelArwingDataVertex
		.dw	   0,  10, 100;0 Front
		.dw	  20,  10,   0;1 Front Bottom Right
		.dw	 -20,  10,   0;2 Front Bottom Left

		.dw	   0, -10,   0;3 Front Middle Top

		.dw	   0,   0, -20;4 Front Middle Back

		.dw	   0,   0,   0;5 Front Middle Inner

		.dw	  40,  10,   0;6 Right Wing Right
		.dw	  30,  20,   0;7 Right Wing Bottom
		.dw	  70,  30, -50;8 Right Wing Back

		.dw	 -40,  10,   0;9 Left Wing Left
		.dw	 -30,  20,   0;10 Left Wing Bottom
		.dw	 -70,  30, -50;11 Left Wing Back

		.dw	  30,  20,  30;12 Right Wing Front
		.dw	  40, -40, -30;13 Right Wing Top

		.dw	 -30,  20,  30;14 Left Wing Front
		.dw	 -40, -40, -30;15 Left Wing Top


;----------------------------
modelRingData
		.dw	modelRingDataWire
		.db	8	;wire count
		.dw	modelRingDataVertex
		.db	8	;vertex count

modelRingDataWire
		.db	 0*6, 1*6
		.db	 1*6, 2*6
		.db	 2*6, 3*6
		.db	 3*6, 4*6
		.db	 4*6, 5*6
		.db	 5*6, 6*6
		.db	 6*6, 7*6
		.db	 7*6, 0*6

modelRingDataVertex
		.dw	   0,-127,   0
		.dw	  90, -90,   0
		.dw	 127,   0,   0
		.dw	  90,  90,   0

		.dw	   0, 127,   0
		.dw	 -90,  90,   0
		.dw	-127,   0,   0
		.dw	 -90, -90,   0


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
		.db	$09, $40, $00	;32x64
		.db	$FF		;end


;----------------------------
palettedata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0000, $0020, $0100, $0004, $0000, $0020, $0100, $0004,\
			$0000, $0020, $0100, $0004, $0000, $0020, $0100, $0004

		.dw	$0000, $0000, $0000, $0000, $0020, $0020, $0020, $0020,\
			$0100, $0100, $0100, $0100, $0004, $0004, $0004, $0004


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
setLineColorData:
;reg A color no
		phx

		tax

		lda	wireLineColorData0,x
		sta	<CH0Data

		lda	wireLineColorData1,x
		sta	<CH1Data

		plx
		rts


;----------------------------
initWire:
;
		lda	#CHRBG0Addr
		sta	<wireBGAddr
		sta	<clearVramDmaAddr
		stz	<clearVramFlag
		smb7	<drawFlag

		rts


;----------------------------
switchBG:
;
		lda	<wireBGAddr
		cmp	#CHRBG0Addr
		bne	.switchBGJump0

		lda	#CHRBG1Addr
		bra	.switchBGJump1

.switchBGJump0:
		lda	#CHRBG0Addr
.switchBGJump1:
		sta	<wireBGAddr

		stz	<clearVramFlag

		smb7	<drawFlag

		rts


;----------------------------
wireIrqProc:
;
;check DMA completion
		lda	<vdcStatus
		and	#$10
		bne	.wireIrqJump3

		bbr7	<drawFlag, .wireIrqEnd

.wireIrqJump2:
		rmb7	<drawFlag

		lda	#2
		sta	<clearVramCount

		lda	<wireBGAddr
		sta	<clearVramDmaAddr

		cmp	#CHRBG0Addr
		bne	.wireIrqJump

		st0	#$08
		st1	#$00
		st2	#$01

		bra	.wireIrqEnd

.wireIrqJump:
		st0	#$08
		st1	#$00
		st2	#$00

.wireIrqEnd:
		jsr	clearVramDma

		clc
		rts

;DMA completion
.wireIrqJump3:
		lda	<clearVramCount
		bne	.wireIrqJump4
		smb7	<clearVramFlag
.wireIrqJump4:
		sec
		rts


;----------------------------
clearVramDma:
;
		lda	<clearVramCount
		beq	.clearVramDmaEnd

		dec	<clearVramCount

		st0	#$00
		st1	#$00
		mov	VDC_3, <clearVramDmaAddr

		st0	#$02
		st1	#$00
		st2	#$00

		st0	#$0F
		st1	#$02	;inc dst, inc src, VRAM-VRAM interrupt
		st2	#$00

		st0	#$10
		st1	#$00
		mov	VDC_3, <clearVramDmaAddr

		st0	#$11
		st1	#$01
		mov	VDC_3, <clearVramDmaAddr

		st0	#$12
		st1	#$FF
		st2	#$0B

		add	<clearVramDmaAddr, #$0C

.clearVramDmaEnd:
		rts


;----------------------------
clearVram:
;
.clearVramJump:
		bbr7	<clearVramFlag, .clearVramJump
		rts


;----------------------------
drawModel:
;
		phx
		phy

;rotation
		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		ldy	#$03
		lda	[modelAddr],y		;vertex data address
		sta	<vertex0Addr
		ldy	#$04
		lda	[modelAddr],y
		sta	<vertex0Addr+1

		movw	<vertex1Addr, #transform2DWork0

		jsr	vertexMultiply

;translation
		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		movw	<vertex0Addr, #transform2DWork0

		movw	<vertex1Addr, #transform2DWork1

		subw	<translationX, <eyeTranslationX

		subw	<translationY, <eyeTranslationY

		subw	<translationZ, <eyeTranslationZ

		jsr	vertexTranslation

;eye rotation
		jsr	moveEyeMatrixToMatrix2

		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		movw	<vertex0Addr, #transform2DWork1

		movw	<vertex1Addr, #transform2DWork0

		jsr	vertexMultiply

;move transform2DWork0 to transform2DWork1
		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		jsr	copy2DWork0To2DWork1

;transform2D
		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		movw	<vertex0Addr, #transform2DWork1

		movw	<vertex1Addr, #transform2DWork0

		jsr	transform2D

		jsr	drawModelProc

		ply
		plx

		rts


;----------------------------
drawModel2:
;
		phx
		phy

;rotation
		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		ldy	#$03
		lda	[modelAddr],y		;vertex data address
		sta	<vertex0Addr
		ldy	#$04
		lda	[modelAddr],y
		sta	<vertex0Addr+1

		jsr	moveToTransform2DWork0

		lda	<rotationSelect
		and	#3
		jsr	vertexRotationSelect

		lda	<rotationSelect
		lsr	a
		lsr	a
		and	#3
		jsr	vertexRotationSelect

		lda	<rotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		and	#3
		jsr	vertexRotationSelect

;translation
		subw	<translationX, <eyeTranslationX

		subw	<translationY, <eyeTranslationY

		subw	<translationZ, <eyeTranslationZ

		jsr	vertexTranslation2

;eye rotation
		mov	<rotationX, <eyeRotationX
		mov	<rotationY, <eyeRotationY
		mov	<rotationZ, <eyeRotationZ

		lda	<eyeRotationSelect
		and	#3
		jsr	vertexRotationSelect

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		and	#3
		jsr	vertexRotationSelect

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		and	#3
		jsr	vertexRotationSelect

;transform2D
		jsr	transform2D2

		jsr	drawModelProc

		ply
		plx

		rts

;----------------------------
drawModelProc:
;
		ldy	#$00
		lda	[modelAddr],y
		sta	<modelAddrWork		;ModelData Wire Addr
		iny
		lda	[modelAddr],y
		sta	<modelAddrWork+1

		ldy	#$02
		lda	[modelAddr],y		;Wire Count
		sta	<modelWireCount

		cly
.drawModelLoop0:
		stz	<frontClipFlag

		lda	[modelAddrWork], y
		sta	<drawModelData0
		tax

		iny

		lda	transform2DWork0,x
		sta	<lineX0

		lda	transform2DWork0+1,x
		sta	<lineX0+1

		lda	transform2DWork0+2,x
		sta	<lineY0

		lda	transform2DWork0+3,x
		sta	<lineY0+1

		lda	transform2DWork0+5,x
		bpl	.drawModelJump1

		smb0	<frontClipFlag

.drawModelJump1:
		lda	[modelAddrWork], y
		sta	<drawModelData1
		tax

		iny

		lda	transform2DWork0,x
		sta	<lineX1

		lda	transform2DWork0+1,x
		sta	<lineX1+1

		lda	transform2DWork0+2,x
		sta	<lineY1

		lda	transform2DWork0+3,x
		sta	<lineY1+1

		lda	transform2DWork0+5,x
		bpl	.drawModelJump2

		smb1	<frontClipFlag

.drawModelJump2:
		lda	<frontClipFlag
		beq	.drawModelJump3
		cmp	#3
		beq	.drawModelJump0

;clip front
		jsr	clipFront

		bbr0	<frontClipFlag, .drawModelJump4

		lda	<clipFrontX
		sta	<lineX0

		lda	<clipFrontX+1
		sta	<lineX0+1

		lda	<clipFrontY
		sta	<lineY0

		lda	<clipFrontY+1
		sta	<lineY0+1

		bra	.drawModelJump3

.drawModelJump4:
		lda	<clipFrontX
		sta	<lineX1

		lda	<clipFrontX+1
		sta	<lineX1+1

		lda	<clipFrontY
		sta	<lineY1

		lda	<clipFrontY+1
		sta	<lineY1+1

.drawModelJump3:
		jsr	drawLineClip2D

.drawModelJump0:
		dec	<modelWireCount
		bne	.drawModelLoop0

		rts


;----------------------------
clipFront:
;clip front
		phx
		phy

		ldx	<drawModelData0
		ldy	<drawModelData1

;(128-Z0) to mul16a
		sec
		lda	#128
		sbc	transform2DWork1+4,x
		sta	<mul16a
		lda	#0
		sbc	transform2DWork1+5,x
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	transform2DWork1+0,y
		sbc	transform2DWork1+0,x
		sta	<mul16b
		lda	transform2DWork1+1,y
		sbc	transform2DWork1+1,x
		sta	<mul16b+1

;(128-Z0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Z1-Z0) to mul16a
		sec
		lda	transform2DWork1+4,y
		sbc	transform2DWork1+4,x
		sta	<mul16a
		lda	transform2DWork1+5,y
		sbc	transform2DWork1+5,x
		sta	<mul16a+1

;(128-Z0)*(X1-X0)/(Z1-Z0)
		jsr	sdiv32

;(128-Z0)*(X1-X0)/(Z1-Z0)+X0
		clc
		lda	<mul16a
		adc	transform2DWork1+0,x
		sta	<mul16a
		lda	<mul16a+1
		adc	transform2DWork1+1,x
		sta	<mul16a+1

;mul16a+centerX
		addw	<clipFrontX, <mul16a, <centerX

;(128-Z0) to mul16a
		sec
		lda	#128
		sbc	transform2DWork1+4,x
		sta	<mul16a
		lda	#0
		sbc	transform2DWork1+5,x
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	transform2DWork1+2,y
		sbc	transform2DWork1+2,x
		sta	<mul16b
		lda	transform2DWork1+3,y
		sbc	transform2DWork1+3,x
		sta	<mul16b+1

;(128-Z0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(Z1-Z0) to mul16a
		sec
		lda	transform2DWork1+4,y
		sbc	transform2DWork1+4,x
		sta	<mul16a
		lda	transform2DWork1+5,y
		sbc	transform2DWork1+5,x
		sta	<mul16a+1

;(128-Z0)*(Y1-Y0)/(Z1-Z0)
		jsr	sdiv32

;(128-Z0)*(Y1-Y0)/(Z1-Z0)+Y0
		clc
		lda	<mul16a
		adc	transform2DWork1+2,x
		sta	<mul16a
		lda	<mul16a+1
		adc	transform2DWork1+3,x
		sta	<mul16a+1

;mul16a+centerY
		addw	<clipFrontY, <mul16a, <centerY

		ply
		plx
		rts


;----------------------------
copy2DWork0To2DWork1:
;
		ldx	<vertexCount
		cly

.copy2DWork0To2DWork1Loop:
		lda	transform2DWork0,y
		sta	transform2DWork1,y
		iny

		lda	transform2DWork0,y
		sta	transform2DWork1,y
		iny

		lda	transform2DWork0,y
		sta	transform2DWork1,y
		iny

		lda	transform2DWork0,y
		sta	transform2DWork1,y
		iny

		lda	transform2DWork0,y
		sta	transform2DWork1,y
		iny

		lda	transform2DWork0,y
		sta	transform2DWork1,y
		iny

		dex
		bne	.copy2DWork0To2DWork1Loop

		rts


;----------------------------
vertexRotationSelect:
;
		and	#3
		cmp	#3
		beq	.rotationSelectJump2
		cmp	#1
		beq	.rotationSelectJump11
		bcs	.rotationSelectJump12

.rotationSelectJump10:
		ldx	<rotationX
		jsr	vertexRotationX
		jmp	.rotationSelectJump2

.rotationSelectJump11:
		ldx	<rotationY
		jsr	vertexRotationY
		jmp	.rotationSelectJump2

.rotationSelectJump12:
		ldx	<rotationZ
		jsr	vertexRotationZ

.rotationSelectJump2:
		rts


;----------------------------
vertexRotationZ:
;x=xcosA-ysinA	y=xsinA+ycosA	z=z
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		jeq	.vertexRotationZEnd

		lda	<vertexCount
		jeq	.vertexRotationZEnd
		sta	<vertexCountWork

		cly

.vertexRotationZLoop:
;----------------
		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xcosA

		movq	<div16ans, <mul16c

		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ysinA

		subq	<mul16c, <div16ans, <mul16c	;xcosA-ysinA

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		lda	<mul16d+1
		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xsinA

		movq	<div16ans, <mul16c

		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ycosA

		addq	<mul16c, <div16ans, <mul16c	;xsinA+ycosA

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		lda	<mul16d
		sta	transform2DWork0+2,y
		lda	<mul16d+1
		sta	transform2DWork0+3,y

;----------------
		pla
		sta	transform2DWork0,y
		pla
		sta	transform2DWork0+1,y

;----------------
		clc
		tya
		adc	#6
		tay

		dec	<vertexCountWork
		jne	.vertexRotationZLoop

.vertexRotationZEnd:
		rts


;----------------------------
vertexRotationY:
;x=xcosA+zsinA	y=y		z=-xsinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		jeq	.vertexRotationYEnd

		lda	<vertexCount
		jeq	.vertexRotationYEnd
.		sta	<vertexCountWork

		cly

.vertexRotationYLoop:
;----------------
		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zsinA

		movq	<div16ans, <mul16c

		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xcosA

		addq	<mul16c, <div16ans, <mul16c	;zsinA+xcosA

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		lda	<mul16d+1
		pha
		lda	<mul16d
		pha

;----------------------------
		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zcosA

		movq	<div16ans, <mul16c

		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xsinA

		subq	<mul16c, <div16ans, <mul16c	;zcosA-xsinA

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		lda	<mul16d
		sta	transform2DWork0+4,y
		lda	<mul16d+1
		sta	transform2DWork0+5,y

;----------------
		pla
		sta	transform2DWork0,y
		pla
		sta	transform2DWork0+1,y

;----------------
		clc
		tya
		adc	#6
		tay

		dec	<vertexCountWork
		jne	.vertexRotationYLoop

.vertexRotationYEnd:
		rts


;----------------------------
vertexRotationX:
;x=x		y=ycosA-zsinA	z=ysinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		jeq	.vertexRotationXEnd

		lda	<vertexCount
		jeq	.vertexRotationXEnd
		sta	<vertexCountWork

		cly

.vertexRotationXLoop:
;----------------
		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ycosA

		movq	<div16ans, <mul16c

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zsinA

		subq	<mul16c, <div16ans, <mul16c	;ycosA-zsinA

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		lda	<mul16d+1
		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ysinA

		movq	<div16ans, <mul16c

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zcosA

		addq	<mul16c, <div16ans, <mul16c	;ysinA+zcosA

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		lda	<mul16d
		sta	transform2DWork0+4,y
		lda	<mul16d+1
		sta	transform2DWork0+5,y

;----------------
		pla
		sta	transform2DWork0+2,y
		pla
		sta	transform2DWork0+3,y

;----------------
		clc
		tya
		adc	#6
		tay

		dec	<vertexCountWork
		jne	.vertexRotationXLoop

.vertexRotationXEnd:
		rts


;----------------------------
vertexTranslation2:
;
		lda	<vertexCount
		beq	.vertexTranslation2End
		sta	<vertexCountWork

		cly

.vertexTranslation2Loop:
		clc
		lda	transform2DWork0, y
		adc	<translationX
		sta	transform2DWork0, y
		lda	transform2DWork0+1, y
		adc	<translationX+1
		sta	transform2DWork0+1, y

		clc
		lda	transform2DWork0+2, y
		adc	<translationY
		sta	transform2DWork0+2, y
		lda	transform2DWork0+3, y
		adc	<translationY+1
		sta	transform2DWork0+3, y

		clc
		lda	transform2DWork0+4, y
		adc	<translationZ
		sta	transform2DWork0+4, y
		lda	transform2DWork0+5, y
		adc	<translationZ+1
		sta	transform2DWork0+5, y

		clc
		tya
		adc	#6
		tay

		dec	<vertexCountWork
		bne	.vertexTranslation2Loop

.vertexTranslation2End:
		rts


;----------------------------
transform2D2:
;
		ldx	<vertexCount
		cly

.transform2D2Loop0:
		lda	transform2DWork0,y
		sta	transform2DWork1,y

		lda	transform2DWork0+1,y
		sta	transform2DWork1+1,y

		lda	transform2DWork0+2,y
		sta	transform2DWork1+2,y

		lda	transform2DWork0+3,y
		sta	transform2DWork1+3,y

		lda	transform2DWork0+4,y
		sta	transform2DWork1+4,y

		lda	transform2DWork0+5,y
		sta	transform2DWork1+5,y

;Z0 < 128 check
		sec
		lda	transform2DWork0+4,y	;Z0
		sbc	#128
		lda	transform2DWork0+5,y
		sbc	#00

		bmi	.transform2D2Jump00

;X0*128/Z0
;screen z = 128
		lda	transform2DWork0,y	;X0
		sta	<mul16c
		lda	transform2DWork0+1,y
		sta	<mul16c+1

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

		jsr	transform2DProc

;X0*128/Z0+centerX
;mul16a+centerX to X0
		clc
		lda	<mul16a
		adc	<centerX
		sta	transform2DWork0,y	;X0
		lda	<mul16a+1
		adc	<centerX+1
		sta	transform2DWork0+1,y

;Y0*128/Z0
;screen z = 128
		lda	transform2DWork0+2,y	;Y0
		sta	<mul16c
		lda	transform2DWork0+3,y
		sta	<mul16c+1

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

		jsr	transform2DProc

;Y0*128/Z0+centerY
;mul16a+centerY to Y0
		clc
		lda	<mul16a
		adc	<centerY
		sta	transform2DWork0+2,y	;Y0
		lda	<mul16a+1
		adc	<centerY+1
		sta	transform2DWork0+3,y

		jmp	.transform2D2Jump01

.transform2D2Jump00:
;Z0<128 flag set
		lda	#$00
		sta	transform2DWork0+4,y
		lda	#$80
		sta	transform2DWork0+5,y

.transform2D2Jump01:
		clc
		tya
		adc	#6
		tay

		dex
		jne	.transform2D2Loop0

		rts


;----------------------------
transform2DProc:
;mul16c(-32768_32767) * 128 / mul16a(1_32767) = mul16a(rough value)
		phy

		lda	<mul16c+1
		sta	<mul16d

		lda	<mul16c
		sta	<mul16c+1

		stz	<mul16c
		stz	<mul16d+1

		bbr7	<mul16d,.transform2DPJump06

		lda	#$FF
		sta	<mul16d+1

.transform2DPJump06:
;get div data
		lda	<div16a+1
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a

		clc
		adc	#divdatBank
		sta	<mulbank
		tam	#$02

		lda	<div16a
		sta	<muladdr
		lda	<div16a+1
		and	#$1F
		ora	#$40
		sta	<muladdr+1

		lda	[muladdr]
		sta	<udiv32_2Work

		clc
		lda	<mulbank
		adc	#4
		tam	#$02

		lda	[muladdr]
		sta	<udiv32_2Work+1

;mul udiv32_2Work low byte
		lda	<udiv32_2Work
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a

		clc
		adc	#muldatBank
		sta	<mulbank
		tam	#$02

		lda	<udiv32_2Work
		and	#$1F
		ora	#$40
		stz	<muladdr
		sta	<muladdr+1

		stz	<div16ans

		ldy	<mul16c+1
		lda	[muladdr],y
		sta	<div16ans+1

		ldy	<mul16d
		lda	[muladdr],y
		sta	<div16work

		ldy	<mul16d+1
		lda	[muladdr],y
		sta	<div16work+1

		lda	<mulbank
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<mul16c+1
		lda	[muladdr],y
		adc	<div16work
		sta	<div16work

		ldy	<mul16d
		lda	[muladdr],y
		adc	<div16work+1
		sta	<div16work+1

;mul udiv32_2Work high byte
		lda	<udiv32_2Work+1
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a

		clc
		adc	#muldatBank
		sta	<mulbank
		tam	#$02

		lda	<udiv32_2Work+1
		and	#$1F
		ora	#$40
		stz	<muladdr
		sta	<muladdr+1

		clc
		ldy	<mul16c+1
		lda	[muladdr],y
		adc	<div16work
		sta	<div16work

		ldy	<mul16d
		lda	[muladdr],y
		adc	<div16work+1
		sta	<div16work+1

		lda	<mulbank
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<mul16c+1
		lda	[muladdr],y
		adc	<div16work+1
		sta	<div16work+1

		lda	<div16work
		sta	<div16a
		lda	<div16work+1
		sta	<div16a+1

		ply

		rts


;----------------------------
moveToTransform2DWork0:
;vertex0Addr to Transform2DWork0
		lda	<vertexCount
		beq	.moveToTransform2DWork0End
		sta	<vertexCountWork

		cly

.moveToTransform2DWork0Loop:
		lda	[vertex0Addr],y
		sta	transform2DWork0,y
		iny
		lda	[vertex0Addr],y
		sta	transform2DWork0,y
		iny

		lda	[vertex0Addr],y
		sta	transform2DWork0,y
		iny
		lda	[vertex0Addr],y
		sta	transform2DWork0,y
		iny

		lda	[vertex0Addr],y
		sta	transform2DWork0,y
		iny
		lda	[vertex0Addr],y
		sta	transform2DWork0,y
		iny

		dec	<vertexCountWork
		bne	.moveToTransform2DWork0Loop

.moveToTransform2DWork0End:
		rts


;----------------------------
moveMatrix1ToMatrix0:
;
		tii	matrix1,matrix0,18
		rts


;----------------------------
moveMatrix1ToMatrix2:
;
		tii	matrix1,matrix2,18
		rts


;----------------------------
moveMatrix2ToMatrix0:
;
		tii	matrix2,matrix0,18
		rts


;----------------------------
moveMatrix2ToEyeMatrix:
;
		tii	matrix2,eyeMatrix,18
		rts


;----------------------------
moveEyeMatrixToMatrix2:
;
		tii	eyeMatrix,matrix2,18
		rts


;----------------------------
setMatrix1RotationX:
;
		stz	matrix1+0+0
		lda	#$40
		sta	matrix1+0+1

		stz	matrix1+0+2
		stz	matrix1+0+3

		stz	matrix1+0+4
		stz	matrix1+0+5

		stz	matrix1+6+0
		stz	matrix1+6+1

		lda	cosDataLow,x
		sta	matrix1+6+2
		lda	cosDataHigh,x
		sta	matrix1+6+3

		clc
		lda	sinDataLow,x
		eor	#$FF
		adc	#$01
		sta	matrix1+6+4
		lda	sinDataHigh,x
		eor	#$FF
		adc	#$00
		sta	matrix1+6+5

		stz	matrix1+12+0
		stz	matrix1+12+1

		lda	sinDataLow,x
		sta	matrix1+12+2
		lda	sinDataHigh,x
		sta	matrix1+12+3

		lda	cosDataLow,x
		sta	matrix1+12+4
		lda	cosDataHigh,x
		sta	matrix1+12+5

		rts


;----------------------------
setMatrix1RotationY:
;
		lda	cosDataLow,x
		sta	matrix1+0+0
		lda	cosDataHigh,x
		sta	matrix1+0+1

		stz	matrix1+0+2
		stz	matrix1+0+3

		lda	sinDataLow,x
		sta	matrix1+0+4
		lda	sinDataHigh,x
		sta	matrix1+0+5

		stz	matrix1+6+0
		stz	matrix1+6+1

		stz	matrix1+6+2
		lda	#$40
		sta	matrix1+6+3

		stz	matrix1+6+4
		stz	matrix1+6+5

		clc
		lda	sinDataLow,x
		eor	#$FF
		adc	#$01
		sta	matrix1+12+0
		lda	sinDataHigh,x
		eor	#$FF
		adc	#$00
		sta	matrix1+12+1

		stz	matrix1+12+2
		stz	matrix1+12+3

		lda	cosDataLow,x
		sta	matrix1+12+4
		lda	cosDataHigh,x
		sta	matrix1+12+5

		rts


;----------------------------
setMatrix1RotationZ:
;
		lda	cosDataLow,x
		sta	matrix1+0+0
		lda	cosDataHigh,x
		sta	matrix1+0+1

		clc
		lda	sinDataLow,x
		eor	#$FF
		adc	#$01
		sta	matrix1+0+2
		lda	sinDataHigh,x
		eor	#$FF
		adc	#$00
		sta	matrix1+0+3

		stz	matrix1+0+4
		stz	matrix1+0+5

		lda	sinDataLow,x
		sta	matrix1+6+0
		lda	sinDataHigh,x
		sta	matrix1+6+1

		lda	cosDataLow,x
		sta	matrix1+6+2
		lda	cosDataHigh,x
		sta	matrix1+6+3

		stz	matrix1+6+4
		stz	matrix1+6+5

		stz	matrix1+12+0
		stz	matrix1+12+1

		stz	matrix1+12+2
		stz	matrix1+12+3

		stz	matrix1+12+4
		lda	#$40
		sta	matrix1+12+5

		rts


;----------------------------
vertexTranslation:
;
.vertexTranslationLoop:
		cly

		clc
		lda	[vertex0Addr], y
		adc	<translationX
		sta	[vertex1Addr], y
		iny
		lda	[vertex0Addr], y
		adc	<translationX+1
		sta	[vertex1Addr], y
		iny

		clc
		lda	[vertex0Addr], y
		adc	<translationY
		sta	[vertex1Addr], y
		iny
		lda	[vertex0Addr], y
		adc	<translationY+1
		sta	[vertex1Addr], y
		iny

		clc
		lda	[vertex0Addr], y
		adc	<translationZ
		sta	[vertex1Addr], y
		iny
		lda	[vertex0Addr], y
		adc	<translationZ+1
		sta	[vertex1Addr], y
		iny

		add	<vertex0Addr, #6
		bcc	.vertexTranslationJump00
		inc	<vertex0Addr+1

.vertexTranslationJump00:
		add	<vertex1Addr, #6
		bcc	.vertexTranslationJump01
		inc	<vertex1Addr+1

.vertexTranslationJump01:
		dec	<vertexCount
		bne	.vertexTranslationLoop

		rts


;----------------------------
vertexMultiply:
;
.vertexMultiplyLoop2:
		clx

.vertexMultiplyLoop1:
		stzq	<vertexWork

		cly

.vertexMultiplyLoop0:
		lda	[vertex0Addr], y
		sta	<mul16a
		iny
		lda	[vertex0Addr], y
		sta	<mul16a+1
		iny

		lda	matrix2,x
		sta	<mul16b
		inx
		lda	matrix2,x
		sta	<mul16b+1
		inx

		jsr	smul16

		addq	<vertexWork, <mul16c, <vertexWork

		cpy	#6
		bne	.vertexMultiplyLoop0

		lda	<vertexWork+2
		asl	<vertexWork+1
		rol	a
		rol	<vertexWork+3
		asl	<vertexWork+1
		rol	a
		rol	<vertexWork+3

		sta	[vertex1Addr]

		inc	<vertex1Addr
		bne	.vertexMultiplyJump00
		inc	<vertex1Addr+1
.vertexMultiplyJump00:

		lda	<vertexWork+3
		sta	[vertex1Addr]

		inc	<vertex1Addr
		bne	.vertexMultiplyJump01
		inc	<vertex1Addr+1
.vertexMultiplyJump01:

		cpx	#18
		bne	.vertexMultiplyLoop1

		add	<vertex0Addr, #6

		bcc	.vertexMultiplyJump02
		inc	<vertex0Addr+1
.vertexMultiplyJump02:

		dec	<vertexCount
		bne	.vertexMultiplyLoop2

		rts


;----------------------------
matrixMultiply:
;
		stz	vertex1Addr

		cly
		clx

.matrixMultiplyLoop0:

		lda	matrix0,x
		sta	<mul16a
		lda	matrix0+1,x
		sta	<mul16a+1

		lda	matrix1,y
		sta	<mul16b
		lda	matrix1+1,y
		sta	<mul16b+1

		jsr	smul16

		movq	<vertexWork, <mul16c

;----------------
		lda	matrix0+6,x
		sta	<mul16a
		lda	matrix0+7,x
		sta	<mul16a+1

		lda	matrix1+2,y
		sta	<mul16b
		lda	matrix1+3,y
		sta	<mul16b+1

		jsr	smul16

		addq	<vertexWork, <mul16c, <vertexWork

;----------------
		lda	matrix0+12,x
		sta	<mul16a
		lda	matrix0+13,x
		sta	<mul16a+1

		lda	matrix1+4,y
		sta	<mul16b
		lda	matrix1+5,y
		sta	<mul16b+1

		jsr	smul16

		addq	<vertexWork, <mul16c, <vertexWork

;----------------

		lda	<vertexWork+2
		asl	<vertexWork+1
		rol	a
		rol	<vertexWork+3
		asl	<vertexWork+1
		rol	a
		rol	<vertexWork+3

		phx
		ldx	<vertex1Addr
		sta	matrix2,x
		inx
		lda	<vertexWork+3
		sta	matrix2,x
		inx
		stx	<vertex1Addr
		plx

		inx
		inx
		cpx	#6
		jne	.matrixMultiplyLoop0

		clx

		clc
		tya
		adc	#6
		tay
		cpy	#18
		jne	.matrixMultiplyLoop0

		rts


;----------------------------
transform2D:
;
.transform2DLoop0:
;Z0 < 128 check
		ldy	#$04
		sec
		lda	[vertex0Addr],y
		sbc	#128
		iny
		lda	[vertex0Addr],y
		sbc	#00

		bmi	.transform2DJump00

;X0*128/Z0
;screen z = 128
.transform2DJump05:
		ldy	#$00
		lda	[vertex0Addr],y
		sta	<mul16c
		iny
		lda	[vertex0Addr],y
		sta	<mul16c+1

		ldy	#$04
		lda	[vertex0Addr],y
		sta	<mul16a
		iny
		lda	[vertex0Addr],y
		sta	<mul16a+1

		jsr	transform2DProc

;X0*128/Z0+centerX
;mul16a+centerX to vertex1Addr X0
		ldy	#$00
		clc
		lda	<mul16a
		adc	<centerX
		sta	[vertex1Addr],y
		iny
		lda	<mul16a+1
		adc	<centerX+1
		sta	[vertex1Addr],y

;Y0*128/Z0
;screen z = 128
		ldy	#$02
		lda	[vertex0Addr],y
		sta	<mul16c
		iny
		lda	[vertex0Addr],y
		sta	<mul16c+1

		ldy	#$04
		lda	[vertex0Addr],y
		sta	<mul16a
		iny
		lda	[vertex0Addr],y
		sta	<mul16a+1

		jsr	transform2DProc

;Y0*128/Z0+centerY
;mul16a+centerY to vertex1Addr Y0
		ldy	#$02
		clc
		lda	<mul16a
		adc	<centerY
		sta	[vertex1Addr],y
		iny
		lda	<mul16a+1
		adc	<centerY+1
		sta	[vertex1Addr],y

;;Z0>=128 flag set
;Z0 set
		iny
		lda	[vertex0Addr],y
		sta	[vertex1Addr],y
		iny
		lda	[vertex0Addr],y
		sta	[vertex1Addr],y

		jmp	.transform2DJump01

.transform2DJump00:
;Z0<128 flag set
;<-------
		ldy	#$04
		lda	#$00
		sta	[vertex1Addr],y
		iny
		lda	#$80
		sta	[vertex1Addr],y

.transform2DJump01:
		clc
		lda	<vertex0Addr
		adc	#$06
		sta	<vertex0Addr
		bcc	.transform2DJump03
		inc	<vertex0Addr+1
.transform2DJump03:

		clc
		lda	<vertex1Addr
		adc	#$06
		sta	<vertex1Addr
		bcc	.transform2DJump04
		inc	<vertex1Addr+1
.transform2DJump04:

		dec	<vertexCount
		jne	.transform2DLoop0

		rts


;----------------------------
setLineColor:
;
		sta	<lineColor
		rts


;----------------------------
initLineBuffer:
;
		stz	<lineBufferCount

		lda	#LOW(lineBuffer)
		sta	lineBufferAddr
		lda	#HIGH(lineBuffer)
		sta	lineBufferAddr+1

		rts


;----------------------------
putLineBuffer:
;
		lda	<lineBufferCount
		beq	.putLineBufferEnd

		lda	#LOW(lineBuffer)
		sta	lineBufferAddr
		lda	#HIGH(lineBuffer)
		sta	lineBufferAddr+1

.putLineBufferLoop:

		cly
		lda	[lineBufferAddr],y
		sta	<edgeX0

		iny
		lda	[lineBufferAddr],y
		sta	<edgeY0

		iny
		lda	[lineBufferAddr],y
		sta	<edgeX1

		iny
		lda	[lineBufferAddr],y
		sta	<edgeY1

		iny
		lda	[lineBufferAddr],y
		jsr	setLineColorData

		jsr	calcEdge

		clc
		lda	lineBufferAddr
		adc	#$05
		sta	lineBufferAddr
		lda	lineBufferAddr+1
		adc	#$00
		sta	lineBufferAddr+1

		dec	<lineBufferCount
		bne	.putLineBufferLoop

.putLineBufferEnd:
		rts


;----------------------------
setLineBuffer:
;
		cly

		lda	<lineX0
		sta	[lineBufferAddr],y

		iny
		lda	<lineY0
		sta	[lineBufferAddr],y

		iny
		lda	<lineX1
		sta	[lineBufferAddr],y

		iny
		lda	<lineY1
		sta	[lineBufferAddr],y

		iny
		lda	<lineColor
		sta	[lineBufferAddr],y

		clc
		lda	lineBufferAddr
		adc	#$05
		sta	lineBufferAddr
		lda	lineBufferAddr+1
		adc	#$00
		sta	lineBufferAddr+1

		inc	<lineBufferCount

		rts


;----------------------------
drawLineClip2D:
;
		phx
		phy

		jsr	clip2D
		bcs	.drawLineClip2DEnd

		jsr	setLineBuffer

.drawLineClip2DEnd:
		ply
		plx

		rts

;----------------------------
clip2D:
;
		jsr	clip2DX0
		bcs	.clip2DEnd

		jsr	clip2DX255
		bcs	.clip2DEnd

		jsr	clip2DY0
		bcs	.clip2DEnd

		jsr	clip2DY255
		bcs	.clip2DEnd

.clip2DEnd:
		rts

;----------------------------
clip2DX255:
;
		stz	<clip2DFlag

		cmpw	<lineX0, #$0100
		bmi	.clip2DX255Jump00
		smb0	<clip2DFlag

.clip2DX255Jump00:
		cmpw	<lineX1, #$0100
		bmi	.clip2DX255Jump01
		smb1	<clip2DFlag

.clip2DX255Jump01:
		lda	<clip2DFlag
		bne	.clip2DX255Jump05
		jmp	.clip2DX255Jump02
.clip2DX255Jump05:
		cmp	#$03
		bne	.clip2DX255Jump06
		jmp	.clip2DX255Jump03
.clip2DX255Jump06:

;(255-X0) to mul16a
		subw	<mul16a, #255, <lineX0

;(Y1-Y0) to mul16b
		subw	<mul16b, <lineY1, <lineY0

;(255-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		subw	<mul16a, <lineX1, <lineX0

;(255-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(255-X0)*(Y1-Y0)/(X1-X0)+Y0
		addw	<mul16a, <lineY0

		bbs1	<clip2DFlag, .clip2DX255Jump04
;X0>255 X1<=255
		movw	<lineX0, #$00FF

		movw	<lineY0, <mul16a

		bra	.clip2DX255Jump02

.clip2DX255Jump04:
;X0<=255 X1>255
		movw	<lineX1, #$00FF

		movw	<lineY1, <mul16a

.clip2DX255Jump02:
;X0<=255 X1<=255
		clc
		rts

.clip2DX255Jump03:
;X0>255 X1>255
		sec
		rts


;----------------------------
clip2DX0:
;
		stz	<clip2DFlag

		lda	<lineX0+1
		bpl	.clip2DX0Jump00
		smb0	<clip2DFlag

.clip2DX0Jump00:
		lda	<lineX1+1
		bpl	.clip2DX0Jump01
		smb1	<clip2DFlag

.clip2DX0Jump01:
		lda	<clip2DFlag
		bne	.clip2DX0Jump05
		jmp	.clip2DX0Jump02
.clip2DX0Jump05:
		cmp	#$03
		bne	.clip2DX0Jump06
		jmp	.clip2DX0Jump03
.clip2DX0Jump06:

;(0-X0) to mul16a
		subw	<mul16a, #0, <lineX0

;(Y1-Y0) to mul16b
		subw	<mul16b, <lineY1, <lineY0

;(0-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		subw	<mul16a, <lineX1, <lineX0

;(0-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(0-X0)*(Y1-Y0)/(X1-X0)+Y0
		addw	<mul16a, <lineY0

		bbs1	<clip2DFlag,.clip2DX0Jump04
;X0<0 X1>=0
		stzw	<lineX0

		movw	<lineY0, <mul16a

		bra	.clip2DX0Jump02

.clip2DX0Jump04:
;X0>=0 X1<0
		stzw	<lineX1

		movw	<lineY1, <mul16a

.clip2DX0Jump02:
;X0>=0 X1>=0
		clc
		rts

.clip2DX0Jump03:
;X0<0 X1<0
		sec
		rts


;----------------------------
clip2DY255:
;
		stz	<clip2DFlag

		cmpw	<lineY0, #192
		bmi	.clip2DY255Jump00
		smb0	<clip2DFlag

.clip2DY255Jump00:
		cmpw	<lineY1, #192
		bmi	.clip2DY255Jump01
		smb1	<clip2DFlag

.clip2DY255Jump01:
		lda	<clip2DFlag
		bne	.clip2DY255Jump05
		jmp	.clip2DY255Jump02
.clip2DY255Jump05:
		cmp	#$03
		bne	.clip2DY255Jump06
		jmp	.clip2DY255Jump03
.clip2DY255Jump06:

;(191-Y0) to mul16a
		subw	<mul16a, #191, <lineY0

;(X1-X0) to mul16b
		subw	<mul16b, <lineX1, <lineX0

;(191-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		subw	<mul16a, <lineY1, <lineY0

;(191-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(191-Y0)*(X1-X0)/(Y1-Y0)+X0
		addw	<mul16a, <lineX0

		bbs1	<clip2DFlag,.clip2DY255Jump04

;Y0>191 Y1<=191
		movw	<lineX0, <mul16a

		movw	<lineY0, #191

		bra	.clip2DY255Jump02

.clip2DY255Jump04:
;Y0<=191 Y1>191
		movw	<lineX1, <mul16a

		movw	<lineY1, #191

.clip2DY255Jump02:
;Y0<=191 Y1<=191
		clc
		rts

.clip2DY255Jump03:
;Y0>191 Y1>191
		sec
		rts


;----------------------------
clip2DY0:
;
		stz	<clip2DFlag

		lda	<lineY0+1
		bpl	.clip2DY0Jump00
		smb0	<clip2DFlag

.clip2DY0Jump00:
		lda	<lineY1+1
		bpl	.clip2DY0Jump01
		smb1	<clip2DFlag

.clip2DY0Jump01:
		lda	<clip2DFlag
		bne	.clip2DY0Jump05
		jmp	.clip2DY0Jump02
.clip2DY0Jump05:
		cmp	#$03
		bne	.clip2DY0Jump06
		jmp	.clip2DY0Jump03
.clip2DY0Jump06:

;(0-Y0) to mul16a
		subw	<mul16a, #0, <lineY0

;(X1-X0) to mul16b
		subw	<mul16b, <lineX1, <lineX0

;(0-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		subw	<mul16a, <lineY1, <lineY0

;(0-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(0-Y0)*(X1-X0)/(Y1-Y0)+X0
		addw	<mul16a, <lineX0

		bbs1	<clip2DFlag,.clip2DY0Jump04
;Y0<0 Y1>=0
		movw	<lineX0, <mul16a

		stzw	<lineY0

		bra	.clip2DY0Jump02

.clip2DY0Jump04:
;Y0>=0 Y1<0
		movw	<lineX1, <mul16a

		stzw	<lineY1

.clip2DY0Jump02:
;Y0>=0 Y1>=0
		clc
		rts

.clip2DY0Jump03:
;Y0<0 Y1<0
		sec
		rts


;----------------------------
;calculation edge
;
calcEdge:
;compare edgeY0 edgeY1
		lda	<edgeY1
		cmp	<edgeY0
		beq	.edgeJump6
		bcs	.edgeJump7

;edgeY0 > edgeY1 exchange X0 X1 Y0 Y1
		lda	<edgeX0
		ldx	<edgeX1
		sta	<edgeX1
		stx	<edgeX0

		lda	<edgeY0
		ldx	<edgeY1
		sta	<edgeY1
		stx	<edgeY0

		jmp	.edgeJump7

.edgeJump6:
;edgeY0 = edgeY1
		ldy	<edgeY0

		lda	<edgeX0
		cmp	<edgeX1
		bcs	.edgeJump10

		sta	<wireLineX0

		mov	<wireLineX1, <edgeX1

		jsr	putHorizontalLine
		rts
.edgeJump10:
		sta	<wireLineX1

		mov	<wireLineX0, <edgeX1

		jsr	putHorizontalLine
		rts

.edgeJump7:
;calculation edge X sign
		sec
		lda	<edgeX1
		sbc	<edgeX0

		bcs	.edgeJump0

		eor	#$FF
		inc	a
		sta	<edgeSlopeX
		stz	<edgeSlopeX+1

		mov	<edgeSigneX, #$FF

		bra	.edgeJump1

.edgeJump0:
		sta	<edgeSlopeX
		stz	<edgeSlopeX+1

		lda	#$01
		sta	<edgeSigneX
.edgeJump1:

;calculation edge Y sign
		sec
		lda	<edgeY1
		sbc	<edgeY0

		sta	<edgeSlopeY
		stz	<edgeSlopeY+1

.edgeJump3:

;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		bcs	.edgeJump4

;edgeSlopeX > edgeSlopeY
;edgeSlopeTemp initialize

		lda	<edgeSlopeX
		eor	#$FF
		inc	a

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeXLoop4Jump2

;edgeSigneX plus
		ldx	<edgeX0
		ldy	<edgeY0
		stx	<wireLineX0
.edgeXLoop0:
		cpx	<edgeX1
		beq	.edgeXLoop0Jump0

		adc	<edgeSlopeY
		bcs	.edgeXLoop0Jump1

		inx
		bra	.edgeXLoop0

.edgeXLoop0Jump1:
		sbc	<edgeSlopeX

		stx	<wireLineX1
		jsr	putHorizontalLine

		inx
		stx	<wireLineX0
		iny
		bra	.edgeXLoop0

.edgeXLoop0Jump0:
		stx	<wireLineX1
		jsr	putHorizontalLine

		rts

;edgeSigneX minus
.edgeXLoop4Jump2:
		ldx	<edgeX0
		ldy	<edgeY0
		stx	<wireLineX1
.edgeXLoop4:
		cpx	<edgeX1
		beq	.edgeXLoop4Jump0

		clc
		adc	<edgeSlopeY
		bcs	.edgeXLoop4Jump1

		dex
		bra	.edgeXLoop4

.edgeXLoop4Jump1:
		sbc	<edgeSlopeX

		stx	<wireLineX0
		jsr	putHorizontalLine

		dex
		stx	<wireLineX1
		iny
		bra	.edgeXLoop4

.edgeXLoop4Jump0:
		stx	<wireLineX0
		jsr	putHorizontalLine

		rts

;;;;--------------------------------
;;;;edgeSigneX minus
;;;.edgeXLoop4Jump2:
;;;;exchange X0 X1 Y0 Y1
;;;		ldy	<edgeY0
;;;		ldx	<edgeY1
;;;		sty	<edgeY1
;;;		stx	<edgeY0
;;;
;;;		ldy	<edgeX0
;;;		ldx	<edgeX1
;;;		sty	<edgeX1
;;;		stx	<edgeX0
;;;
;;;		ldy	<edgeY0
;;;		stx	<wireLineX0
;;;.edgeXLoop4:
;;;		cpx	<edgeX1
;;;		beq	.edgeXLoop4Jump0
;;;
;;;		adc	<edgeSlopeY
;;;		bcs	.edgeXLoop4Jump1
;;;
;;;		inx
;;;		bra	.edgeXLoop4
;;;
;;;.edgeXLoop4Jump1:
;;;		sbc	<edgeSlopeX
;;;
;;;		stx	<wireLineX1
;;;		jsr	putHorizontalLine
;;;
;;;		inx
;;;		stx	<wireLineX0
;;;		dey
;;;		bra	.edgeXLoop4
;;;
;;;.edgeXLoop4Jump0:
;;;		stx	<wireLineX1
;;;		jsr	putHorizontalLine
;;;
;;;		rts
;;;;--------------------------------

.edgeJump4:
;edgeSlopeY >= edgeSlopeX
;edgeSlopeTemp initialize

		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldx	<edgeX0
		ldy	<edgeY0

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop4Jump2

;edgeSigneX plus
		bra	.edgeYLoop0Jump1

.edgeYLoop0:
		jsr	putPixelEdge

		cpy	<edgeY1
		beq	.edgeYLoop0Jump0

		iny
		adc	<edgeSlopeX
		bcc	.edgeYLoop0

		sbc	<edgeSlopeY
		inx

.edgeYLoop0Jump1:
		pha

		phx
		txa
		and	#$07
		tax
		lda	wireLinePixelDatas,x
		sta	<CHMask
		lda	wireLinePixelMasks,x
		sta	<CHNegMask
		plx

		lda	<CH0Data
		and	<CHMask
		sta	<CH0

		lda	<CH1Data
		and	<CHMask
		sta	<CH1

		pla
		bra	.edgeYLoop0

.edgeYLoop0Jump0:
		rts

.edgeYLoop4Jump2:
;edgeSigneX minus
		bra	.edgeYLoop4Jump1
.edgeYLoop4:
		jsr	putPixelEdge

		cpy	<edgeY1
		beq	.edgeYLoop4Jump0

		iny
		adc	<edgeSlopeX
		bcc	.edgeYLoop4

		sbc	<edgeSlopeY
		dex

.edgeYLoop4Jump1:
		pha

		phx
		txa
		and	#$07
		tax
		lda	wireLinePixelDatas,x
		sta	<CHMask
		lda	wireLinePixelMasks,x
		sta	<CHNegMask
		plx

		lda	<CH0Data
		and	<CHMask
		sta	<CH0

		lda	<CH1Data
		and	<CHMask
		sta	<CH1

		pla
		bra	.edgeYLoop4

.edgeYLoop4Jump0:
		rts


;----------------------------
putPixelEdge:
;
		pha
		phx

		lda	wireLineAddrConvYLow0,y
		ora	wireLineAddrConvXLow0,x
		sta	<setVramChrAddr

		lda	wireLineAddrConvYHigh0,y
		ora	wireLineAddrConvXHigh0,x
		clc
		adc	<wireBGAddr
		sta	<setVramChrAddr+1

;put pixel
		sei

;first addr
		lda	<setVramChrAddr
		ldx	<setVramChrAddr+1

;set write first addr
		st0	#$00
		sta	VDC_2
		stx	VDC_3

;set read first addr
		st0	#$01
		sta	VDC_2
		stx	VDC_3

;read
		st0	#$02

		lda	VDC_2
		and	<CHNegMask
		ora	<CH0
		tax

		lda	VDC_3
		and	<CHNegMask
		ora	<CH1

;write
		stx	VDC_2
		sta	VDC_3

		cli

		plx
		pla
		rts


;----------------------------
putPixel:
;
		phx

		lda	wireLineAddrConvYLow0,y
		ora	wireLineAddrConvXLow0,x
		sta	<setVramChrAddr

		lda	wireLineAddrConvYHigh0,y
		ora	wireLineAddrConvXHigh0,x
		clc
		adc	<wireBGAddr
		sta	<setVramChrAddr+1

		txa
		and	#$07
		tax
		lda	wireLinePixelDatas,x
		sta	<CHMask
		lda	wireLinePixelMasks,x
		sta	<CHNegMask

;put pixel
		sei

;first addr
		lda	<setVramChrAddr
		ldx	<setVramChrAddr+1

;set write first addr
		st0	#$00
		sta	VDC_2
		stx	VDC_3

;set read first addr
		st0	#$01
		sta	VDC_2
		stx	VDC_3

;read
		st0	#$02

		lda	VDC_2
		and	<CHNegMask
		sta	<CH0

		lda	<CH0Data
		and	<CHMask
		ora	<CH0
		tax

		lda	VDC_3
		and	<CHNegMask
		sta	<CH1

		lda	<CH1Data
		and	<CHMask
		ora	<CH1

;write
		stx	VDC_2
		sta	VDC_3

		cli

		plx

		rts


;----------------------------
putHorizontalLine:
;
;calation vram address
		pha
		phx

;left
		ldx	<wireLineX0
		lda	wireLineAddrConvYLow0,y
		ora	wireLineAddrConvXLow0,x
		sta	<wireLineLeftAddr

		lda	wireLineAddrConvYHigh0,y
		ora	wireLineAddrConvXHigh0,x
		clc
		adc	<wireBGAddr
		sta	<wireLineLeftAddr+1

		lda	wireLineAddrConvX,x
		sta	<wireLineCount

		txa
		and	#$07
		tax
		lda	wireLineLeftDatas,x
		sta	<wireLineLeftData
		lda	wireLineLeftMasks,x
		sta	<wireLineLeftMask

;right
		ldx	<wireLineX1
		lda	wireLineAddrConvYLow0,y
		ora	wireLineAddrConvXLow0,x
		sta	<wireLineRightAddr

		lda	wireLineAddrConvYHigh0,y
		ora	wireLineAddrConvXHigh0,x
		clc
		adc	<wireBGAddr
		sta	<wireLineRightAddr+1

		sec
		lda	wireLineAddrConvX,x
		sbc	<wireLineCount
		sta	<wireLineCount

		txa
		and	#$07
		tax
		lda	wireLineRightDatas,x
		sta	<wireLineRightData
		lda	wireLineRightMasks,x
		sta	<wireLineRightMask

		lda	<wireLineCount
		beq	.wireLineJump03

		jsr	putHorizontalLine00
		jsr	putHorizontalLine01Left
		jsr	putHorizontalLine01Right

		bra	.wireLineJump04

.wireLineJump03:
		lda	<wireLineLeftData
		and	<wireLineRightData
		sta	<wireLineLeftData
		eor	#$FF
		sta	<wireLineLeftMask

		jsr	putHorizontalLine01Left

.wireLineJump04:
		plx
		pla

		rts


;----------------------------
;put left horizontal line
;
putHorizontalLine01Left:
		movw	<setVramChrAddr, <wireLineLeftAddr

		mov	<CHMask, <wireLineLeftData

		mov	<CHNegMask, <wireLineLeftMask

;put pixel
		sei

;first addr
		lda	<setVramChrAddr
		ldx	<setVramChrAddr+1

;set write first addr
		st0	#$00
		sta	VDC_2
		stx	VDC_3

;set read first addr
		st0	#$01
		sta	VDC_2
		stx	VDC_3

;read
		st0	#$02

		lda	VDC_2
		and	<CHNegMask
		sta	<CH0

		lda	<CH0Data
		and	<CHMask
		ora	<CH0
		tax

		lda	VDC_3
		and	<CHNegMask
		sta	<CH1

		lda	<CH1Data
		and	<CHMask
		ora	<CH1

;write
		stx	VDC_2
		sta	VDC_3

		cli

		rts


;----------------------------
;put right horizontal line
;
putHorizontalLine01Right:
		movw	<setVramChrAddr, <wireLineRightAddr

		mov	<CHMask, <wireLineRightData

		mov	<CHNegMask, <wireLineRightMask

;put pixel
		sei

;first addr
		lda	<setVramChrAddr
		ldx	<setVramChrAddr+1

;set write first addr
		st0	#$00
		sta	VDC_2
		stx	VDC_3

;set read first addr
		st0	#$01
		sta	VDC_2
		stx	VDC_3

;read
		st0	#$02

		lda	VDC_2
		and	<CHNegMask
		sta	<CH0

		lda	<CH0Data
		and	<CHMask
		ora	<CH0
		tax

		lda	VDC_3
		and	<CHNegMask
		sta	<CH1

		lda	<CH1Data
		and	<CHMask
		ora	<CH1

;write
		stx	VDC_2
		sta	VDC_3

		cli

		rts


;----------------------------
;put left to right horizontal line
;
putHorizontalLine00:
		add	<setVramChrAddr, <wireLineLeftAddr, #$10

		lda	<wireLineLeftAddr+1
		bcc	.putHorizontalLine00Jump0
		inc	a

.putHorizontalLine00Jump0:
		sta	<setVramChrAddr+1

		ldx	<wireLineCount

.putHorizontalLine00Loop:
		dex
		beq	.putHorizontalLine00Jump

;put pixel
		sei

		st0	#$00
		lda	<setVramChrAddr
		sta	VDC_2
		lda	<setVramChrAddr+1
		sta	VDC_3

		st0	#$02

		mov	VDC_2, <CH0Data
		mov	VDC_3, <CH1Data

		cli

		add	<setVramChrAddr, #$10

		bcc	.putHorizontalLine00Loop
		inc	<setVramChrAddr+1
		bra	.putHorizontalLine00Loop

.putHorizontalLine00Jump:
		rts


;----------------------------
clearBG:
;clear BG BAT
		st0	#$00
		st1	#$00
		st2	#$00

		st0	#$02
		ldy	#64
.clearbatloop8:
		ldx	#32
.clearbatloop9:
		st1	#$80
		st2	#$00

		dex
		bne	.clearbatloop9
		dey
		bne	.clearbatloop8

;clear BG0 BAT
		movw	<clearBGWork, #$2200

		st0	#$00
		st1	#$00
		st2	#$00

		st0	#$02
		ldy	#12
.clearbatloop0:
		ldx	#32
.clearbatloop1:
		movw	VDC_2, <clearBGWork

		addw	<clearBGWork, #1

		dex
		bne	.clearbatloop1
		dey
		bne	.clearbatloop0

		movw	<clearBGWork, #$3200

		st0	#$00
		st1	#$80
		st2	#$01

		st0	#$02
		ldy	#12
.clearbatloop0B:
		ldx	#32
.clearbatloop1B:
		movw	VDC_2, <clearBGWork

		addw	<clearBGWork, #1

		dex
		bne	.clearbatloop1B
		dey
		bne	.clearbatloop0B

;clear BG1 BAT
		movw	<clearBGWork, #$2380

		st0	#$00
		st1	#$00
		st2	#$04

		st0	#$02
		ldy	#12
.clearbatloop2:
		ldx	#32
.clearbatloop3:
		movw	VDC_2, <clearBGWork

		addw	<clearBGWork, #1

		dex
		bne	.clearbatloop3
		dey
		bne	.clearbatloop2

;clear BG1 BAT
		movw	<clearBGWork, #$3380

		st0	#$00
		st1	#$80
		st2	#$05

		st0	#$02
		ldy	#12
.clearbatloop2B:
		ldx	#32
.clearbatloop3B:
		movw	VDC_2, <clearBGWork

		addw	<clearBGWork, #1

		dex
		bne	.clearbatloop3B
		dey
		bne	.clearbatloop2B

		rts


;----------------------------
puthex:
;
		pha
		phx
		phy

		sta	<puthexdata

		stz	<puthexaddr
		sty	<puthexaddr+1

		lsr	<puthexaddr+1
		ror	<puthexaddr
		lsr	<puthexaddr+1
		ror	<puthexaddr
		lsr	<puthexaddr+1
		ror	<puthexaddr

		txa
		ora	<puthexaddr
		sta	<puthexaddr

		lda	<wireBGAddr
		cmp	#CHRBG1Addr
		bne	.putHexJump0

		clc
		lda	<puthexaddr+1
		adc	#$04
		sta	<puthexaddr+1
.putHexJump0:

		lda	<puthexdata
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		jsr	numtochar
		tax

		lda	<puthexdata
		and	#$0F
		jsr	numtochar

		stz	VDC_0
		ldy	<puthexaddr
		sty	VDC_2
		ldy	<puthexaddr+1
		sty	VDC_3

		ldy	#$02
		sty	VDC_0
		stx	VDC_2
		ldy	#$01
		sty	VDC_3

		sta	VDC_2
		sty	VDC_3

		ply
		plx
		pla

		rts


;----------------------------
wireLineAddrConvYLow0:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,\
			$08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,\
			$08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,\
			$08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,\
			$08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,\
			$08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F


;----------------------------
wireLineAddrConvYHigh0:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $02, $02, $02, $02, $02, $02,\
			$04, $04, $04, $04, $04, $04, $04, $04, $06, $06, $06, $06, $06, $06, $06, $06,\
			$08, $08, $08, $08, $08, $08, $08, $08, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E,\
			$10, $10, $10, $10, $10, $10, $10, $10, $12, $12, $12, $12, $12, $12, $12, $12,\
			$14, $14, $14, $14, $14, $14, $14, $14, $16, $16, $16, $16, $16, $16, $16, $16,\
			$00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $02, $02, $02, $02, $02, $02,\
			$04, $04, $04, $04, $04, $04, $04, $04, $06, $06, $06, $06, $06, $06, $06, $06,\
			$08, $08, $08, $08, $08, $08, $08, $08, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E,\
			$10, $10, $10, $10, $10, $10, $10, $10, $12, $12, $12, $12, $12, $12, $12, $12,\
			$14, $14, $14, $14, $14, $14, $14, $14, $16, $16, $16, $16, $16, $16, $16, $16



;----------------------------
wireLineAddrConvXLow0:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10,\
			$20, $20, $20, $20, $20, $20, $20, $20, $30, $30, $30, $30, $30, $30, $30, $30,\
			$40, $40, $40, $40, $40, $40, $40, $40, $50, $50, $50, $50, $50, $50, $50, $50,\
			$60, $60, $60, $60, $60, $60, $60, $60, $70, $70, $70, $70, $70, $70, $70, $70,\
			$80, $80, $80, $80, $80, $80, $80, $80, $90, $90, $90, $90, $90, $90, $90, $90,\
			$A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $D0, $D0, $D0, $D0, $D0, $D0, $D0, $D0,\
			$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,\
			$00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10,\
			$20, $20, $20, $20, $20, $20, $20, $20, $30, $30, $30, $30, $30, $30, $30, $30,\
			$40, $40, $40, $40, $40, $40, $40, $40, $50, $50, $50, $50, $50, $50, $50, $50,\
			$60, $60, $60, $60, $60, $60, $60, $60, $70, $70, $70, $70, $70, $70, $70, $70,\
			$80, $80, $80, $80, $80, $80, $80, $80, $90, $90, $90, $90, $90, $90, $90, $90,\
			$A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $D0, $D0, $D0, $D0, $D0, $D0, $D0, $D0,\
			$E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0


;----------------------------
wireLineAddrConvXHigh0:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01


;----------------------------
wireLineAddrConvX:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03,\
			$04, $04, $04, $04, $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05,\
			$06, $06, $06, $06, $06, $06, $06, $06, $07, $07, $07, $07, $07, $07, $07, $07,\
			$08, $08, $08, $08, $08, $08, $08, $08, $09, $09, $09, $09, $09, $09, $09, $09,\
			$0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D,\
			$0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,\
			$10, $10, $10, $10, $10, $10, $10, $10, $11, $11, $11, $11, $11, $11, $11, $11,\
			$12, $12, $12, $12, $12, $12, $12, $12, $13, $13, $13, $13, $13, $13, $13, $13,\
			$14, $14, $14, $14, $14, $14, $14, $14, $15, $15, $15, $15, $15, $15, $15, $15,\
			$16, $16, $16, $16, $16, $16, $16, $16, $17, $17, $17, $17, $17, $17, $17, $17,\
			$18, $18, $18, $18, $18, $18, $18, $18, $19, $19, $19, $19, $19, $19, $19, $19,\
			$1A, $1A, $1A, $1A, $1A, $1A, $1A, $1A, $1B, $1B, $1B, $1B, $1B, $1B, $1B, $1B,\
			$1C, $1C, $1C, $1C, $1C, $1C, $1C, $1C, $1D, $1D, $1D, $1D, $1D, $1D, $1D, $1D,\
			$1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F


;----------------------------
wireLinePixelDatas:
		.db	$80, $40, $20, $10, $08, $04, $02, $01


;----------------------------
wireLinePixelMasks:
		.db	$7F, $BF, $DF, $EF, $F7, $FB, $FD, $FE


;----------------------------
wireLineLeftDatas:
		.db	$FF, $7F, $3F, $1F, $0F, $07, $03, $01


;----------------------------
wireLineLeftMasks:
		.db	$00, $80, $C0, $E0, $F0, $F8, $FC, $FE


;----------------------------
wireLineRightDatas:
		.db	$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF


;----------------------------
wireLineRightMasks:
		.db	$7F, $3F, $1F, $0F, $07, $03, $01, $00


;----------------------------
wireLineColorNo:
		.db	$00, $01, $02, $03, $01, $01, $02, $01
		.db	$00, $01, $02, $03, $02, $03, $03, $02
		.db	$00, $01, $02, $03, $01, $01, $02, $01
		.db	$00, $01, $02, $03, $02, $03, $03, $03


;----------------------------
wireLineColorData0:
		.db	$00, $FF, $00, $FF


;----------------------------
wireLineColorData1:
		.db	$00, $00, $FF, $FF


;----------------------------
sinDataHigh:
		.db	$00, $01, $03, $04, $06, $07, $09, $0A, $0C, $0E, $0F, $11, $12, $14, $15, $17,\
			$18, $19, $1B, $1C, $1E, $1F, $20, $22, $23, $24, $26, $27, $28, $29, $2A, $2C,\
			$2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $36, $37, $38, $39, $39, $3A,\
			$3B, $3B, $3C, $3C, $3D, $3D, $3E, $3E, $3E, $3F, $3F, $3F, $3F, $3F, $3F, $3F,\
			$40, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3E, $3E, $3E, $3D, $3D, $3C, $3C, $3B,\
			$3B, $3A, $39, $39, $38, $37, $36, $36, $35, $34, $33, $32, $31, $30, $2F, $2E,\
			$2D, $2C, $2A, $29, $28, $27, $26, $24, $23, $22, $20, $1F, $1E, $1C, $1B, $19,\
			$18, $17, $15, $14, $12, $11, $0F, $0E, $0C, $0A, $09, $07, $06, $04, $03, $01,\
			$00, $FE, $FC, $FB, $F9, $F8, $F6, $F5, $F3, $F1, $F0, $EE, $ED, $EB, $EA, $E8,\
			$E7, $E6, $E4, $E3, $E1, $E0, $DF, $DD, $DC, $DB, $D9, $D8, $D7, $D6, $D5, $D3,\
			$D2, $D1, $D0, $CF, $CE, $CD, $CC, $CB, $CA, $C9, $C9, $C8, $C7, $C6, $C6, $C5,\
			$C4, $C4, $C3, $C3, $C2, $C2, $C1, $C1, $C1, $C0, $C0, $C0, $C0, $C0, $C0, $C0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C1, $C1, $C1, $C2, $C2, $C3, $C3, $C4,\
			$C4, $C5, $C6, $C6, $C7, $C8, $C9, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $D1,\
			$D2, $D3, $D5, $D6, $D7, $D8, $D9, $DB, $DC, $DD, $DF, $E0, $E1, $E3, $E4, $E6,\
			$E7, $E8, $EA, $EB, $ED, $EE, $F0, $F1, $F3, $F5, $F6, $F8, $F9, $FB, $FC, $FE


;----------------------------
sinDataLow:
		.db	$00, $92, $24, $B5, $46, $D6, $64, $F1, $7C, $06, $8D, $12, $94, $13, $90, $09,\
			$7E, $EF, $5D, $C6, $2B, $8C, $E7, $3D, $8E, $DA, $20, $60, $9A, $CE, $FB, $21,\
			$41, $5A, $6C, $76, $79, $74, $68, $53, $37, $12, $E5, $B0, $71, $2B, $DB, $82,\
			$21, $B6, $42, $C5, $3F, $AF, $15, $72, $C5, $0F, $4F, $85, $B1, $D4, $EC, $FB,\
			$00, $FB, $EC, $D4, $B1, $85, $4F, $0F, $C5, $72, $15, $AF, $3F, $C5, $42, $B6,\
			$21, $82, $DB, $2B, $71, $B0, $E5, $12, $37, $53, $68, $74, $79, $76, $6C, $5A,\
			$41, $21, $FB, $CE, $9A, $60, $20, $DA, $8E, $3D, $E7, $8C, $2B, $C6, $5D, $EF,\
			$7E, $09, $90, $13, $94, $12, $8D, $06, $7C, $F1, $64, $D6, $46, $B5, $24, $92,\
			$00, $6E, $DC, $4B, $BA, $2A, $9C, $0F, $84, $FA, $73, $EE, $6C, $ED, $70, $F7,\
			$82, $11, $A3, $3A, $D5, $74, $19, $C3, $72, $26, $E0, $A0, $66, $32, $05, $DF,\
			$BF, $A6, $94, $8A, $87, $8C, $98, $AD, $C9, $EE, $1B, $50, $8F, $D5, $25, $7E,\
			$DF, $4A, $BE, $3B, $C1, $51, $EB, $8E, $3B, $F1, $B1, $7B, $4F, $2C, $14, $05,\
			$00, $05, $14, $2C, $4F, $7B, $B1, $F1, $3B, $8E, $EB, $51, $C1, $3B, $BE, $4A,\
			$DF, $7E, $25, $D5, $8F, $50, $1B, $EE, $C9, $AD, $98, $8C, $87, $8A, $94, $A6,\
			$BF, $DF, $05, $32, $66, $A0, $E0, $26, $72, $C3, $19, $74, $D5, $3A, $A3, $11,\
			$82, $F7, $70, $ED, $6C, $EE, $73, $FA, $84, $0F, $9C, $2A, $BA, $4B, $DC, $6E


;----------------------------
cosDataHigh:
		.db	$40, $3F, $3F, $3F, $3F, $3F, $3F, $3F, $3E, $3E, $3E, $3D, $3D, $3C, $3C, $3B,\
			$3B, $3A, $39, $39, $38, $37, $36, $36, $35, $34, $33, $32, $31, $30, $2F, $2E,\
			$2D, $2C, $2A, $29, $28, $27, $26, $24, $23, $22, $20, $1F, $1E, $1C, $1B, $19,\
			$18, $17, $15, $14, $12, $11, $0F, $0E, $0C, $0A, $09, $07, $06, $04, $03, $01,\
			$00, $FE, $FC, $FB, $F9, $F8, $F6, $F5, $F3, $F1, $F0, $EE, $ED, $EB, $EA, $E8,\
			$E7, $E6, $E4, $E3, $E1, $E0, $DF, $DD, $DC, $DB, $D9, $D8, $D7, $D6, $D5, $D3,\
			$D2, $D1, $D0, $CF, $CE, $CD, $CC, $CB, $CA, $C9, $C9, $C8, $C7, $C6, $C6, $C5,\
			$C4, $C4, $C3, $C3, $C2, $C2, $C1, $C1, $C1, $C0, $C0, $C0, $C0, $C0, $C0, $C0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C1, $C1, $C1, $C2, $C2, $C3, $C3, $C4,\
			$C4, $C5, $C6, $C6, $C7, $C8, $C9, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $D1,\
			$D2, $D3, $D5, $D6, $D7, $D8, $D9, $DB, $DC, $DD, $DF, $E0, $E1, $E3, $E4, $E6,\
			$E7, $E8, $EA, $EB, $ED, $EE, $F0, $F1, $F3, $F5, $F6, $F8, $F9, $FB, $FC, $FE,\
			$00, $01, $03, $04, $06, $07, $09, $0A, $0C, $0E, $0F, $11, $12, $14, $15, $17,\
			$18, $19, $1B, $1C, $1E, $1F, $20, $22, $23, $24, $26, $27, $28, $29, $2A, $2C,\
			$2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $36, $37, $38, $39, $39, $3A,\
			$3B, $3B, $3C, $3C, $3D, $3D, $3E, $3E, $3E, $3F, $3F, $3F, $3F, $3F, $3F, $3F


;----------------------------
cosDataLow:
		.db	$00, $FB, $EC, $D4, $B1, $85, $4F, $0F, $C5, $72, $15, $AF, $3F, $C5, $42, $B6,\
			$21, $82, $DB, $2B, $71, $B0, $E5, $12, $37, $53, $68, $74, $79, $76, $6C, $5A,\
			$41, $21, $FB, $CE, $9A, $60, $20, $DA, $8E, $3D, $E7, $8C, $2B, $C6, $5D, $EF,\
			$7E, $09, $90, $13, $94, $12, $8D, $06, $7C, $F1, $64, $D6, $46, $B5, $24, $92,\
			$00, $6E, $DC, $4B, $BA, $2A, $9C, $0F, $84, $FA, $73, $EE, $6C, $ED, $70, $F7,\
			$82, $11, $A3, $3A, $D5, $74, $19, $C3, $72, $26, $E0, $A0, $66, $32, $05, $DF,\
			$BF, $A6, $94, $8A, $87, $8C, $98, $AD, $C9, $EE, $1B, $50, $8F, $D5, $25, $7E,\
			$DF, $4A, $BE, $3B, $C1, $51, $EB, $8E, $3B, $F1, $B1, $7B, $4F, $2C, $14, $05,\
			$00, $05, $14, $2C, $4F, $7B, $B1, $F1, $3B, $8E, $EB, $51, $C1, $3B, $BE, $4A,\
			$DF, $7E, $25, $D5, $8F, $50, $1B, $EE, $C9, $AD, $98, $8C, $87, $8A, $94, $A6,\
			$BF, $DF, $05, $32, $66, $A0, $E0, $26, $72, $C3, $19, $74, $D5, $3A, $A3, $11,\
			$82, $F7, $70, $ED, $6C, $EE, $73, $FA, $84, $0F, $9C, $2A, $BA, $4B, $DC, $6E,\
			$00, $92, $24, $B5, $46, $D6, $64, $F1, $7C, $06, $8D, $12, $94, $13, $90, $09,\
			$7E, $EF, $5D, $C6, $2B, $8C, $E7, $3D, $8E, $DA, $20, $60, $9A, $CE, $FB, $21,\
			$41, $5A, $6C, $76, $79, $74, $68, $53, $37, $12, $E5, $B0, $71, $2B, $DB, $82,\
			$21, $B6, $42, $C5, $3F, $AF, $15, $72, $C5, $0F, $4F, $85, $B1, $D4, $EC, $FB


;////////////////////////////
		.bank	2
		INCBIN	"char.dat"		;    8K  2    $02
		INCBIN	"mul.dat"		;  128K  3~18 $03~$12
		INCBIN	"div.dat"		;   64K 19~26 $13~$1A
