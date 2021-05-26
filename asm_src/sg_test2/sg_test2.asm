VDC_0			.equ	$0000
VDC_1			.equ	$0001
VDC_2			.equ	$0002
VDC_3			.equ	$0003

VDC1			.equ	1
VDC1_0			.equ	VDC_0
VDC1_1			.equ	VDC_1
VDC1_2			.equ	VDC_2
VDC1_3			.equ	VDC_3

VDC2			.equ	2
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

chardatBank		.equ	3
muldatBank		.equ	4
divdatBank		.equ	20


;//////////////////////////////////
;----------------------------
putPolyLineV1m	.macro
		sta	VDC1_2
		sty	VDC1_3
		.endm


;----------------------------
putPolyLineV2m	.macro
		sta	VDC2_2
		sty	VDC2_3
		.endm


;----------------------------
putPolyLineV1lm	.macro
		putPolyLineV1m		;30

		putPolyLineV1m		;29
		putPolyLineV1m		;28
		putPolyLineV1m		;27
		putPolyLineV1m		;26
		putPolyLineV1m		;25
		putPolyLineV1m		;24
		putPolyLineV1m		;23
		putPolyLineV1m		;22
		putPolyLineV1m		;21

		putPolyLineV1m		;20
		putPolyLineV1m		;19
		putPolyLineV1m		;18
		putPolyLineV1m		;17
		putPolyLineV1m		;16
		putPolyLineV1m		;15
		putPolyLineV1m		;14
		putPolyLineV1m		;13
		putPolyLineV1m		;12
		putPolyLineV1m		;11

		putPolyLineV1m		;10
		putPolyLineV1m		;9
		putPolyLineV1m		;8
		putPolyLineV1m		;7
		putPolyLineV1m		;6
		putPolyLineV1m		;5
		putPolyLineV1m		;4
		putPolyLineV1m		;3
		putPolyLineV1m		;2
		putPolyLineV1m		;1
		.endm


;----------------------------
putPolyLineV2lm	.macro
		putPolyLineV2m		;30

		putPolyLineV2m		;29
		putPolyLineV2m		;28
		putPolyLineV2m		;27
		putPolyLineV2m		;26
		putPolyLineV2m		;25
		putPolyLineV2m		;24
		putPolyLineV2m		;23
		putPolyLineV2m		;22
		putPolyLineV2m		;21

		putPolyLineV2m		;20
		putPolyLineV2m		;19
		putPolyLineV2m		;18
		putPolyLineV2m		;17
		putPolyLineV2m		;16
		putPolyLineV2m		;15
		putPolyLineV2m		;14
		putPolyLineV2m		;13
		putPolyLineV2m		;12
		putPolyLineV2m		;11

		putPolyLineV2m		;10
		putPolyLineV2m		;9
		putPolyLineV2m		;8
		putPolyLineV2m		;7
		putPolyLineV2m		;6
		putPolyLineV2m		;5
		putPolyLineV2m		;4
		putPolyLineV2m		;3
		putPolyLineV2m		;2
		putPolyLineV2m		;1
		.endm


;----------------------------
setEdgeBufferm	.macro
;set edge buffer
		lda	edgeCount,x

		beq	.jpCount1_\@			;count 1
		bpl	.jpCount2_\@			;count 2

;count 0
.jpCount0_\@:
		tya
		sta	edgeLeft,x
		inc	edgeCount,x
		bra	.jp2_\@

;count 1
.jpCount1_\@:
		tya
		cmp	edgeLeft,x
		bcs	.jp4_\@			;a >= edgeLeft,x

		lda	edgeLeft,x
		sta	edgeRight,x
		tya
		sta	edgeLeft,x

		inc	edgeCount,x
		bra	.jp2_\@

.jp4_\@:
		sta	edgeRight,x
		inc	edgeCount,x
		bra	.jp2_\@

;count 2
.jpCount2_\@:
		tya
		cmp	edgeLeft,x
		bcs	.jp3_\@			;a >= edgeLeft,x
		sta	edgeLeft,x
		bra	.jp2_\@

.jp3_\@:
		cmp	edgeRight,x
		bcc	.jp2_\@			;a < edgeRight,x
		sta	edgeRight,x

.jp2_\@:
		.endm


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
		.if	(\# = 1)
			clc
			adc	\1
		.else
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
		.endif
		.endm


;----------------------------
sub		.macro
;\1 = \2 - \3
;\1 = \1 - \2
		.if	(\# = 1)
			sec
			sbc	\1
		.else
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
addwb		.macro
;\1(word) = \1(word) + \2(byte)
		clc
		lda	\1
		adc	\2
		sta	\1
		bcc	.jp0\@
		inc	\1+1
.jp0\@
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
andm		.macro
;\1 = \1 AND \2
		lda	\1
		and	\2
		sta	\1
		.endm


;----------------------------
andmw		.macro
;\1 = \1 AND \2
		.if	(\?2 = 2);Immediate
			lda	\1
			and	#LOW(\2)
			sta	\1

			lda	\1+1
			and	#HIGH(\2)
			sta	\1+1
		.else
			lda	\1
			and	\2
			sta	\1

			lda	\1+1
			and	\2+1
			sta	\1+1
		.endif
		.endm


;----------------------------
oram		.macro
;\1 = \1 OR \2
		lda	\1
		ora	\2
		sta	\1
		.endm


;----------------------------
oramw		.macro
;\1 = \1 OR \2
		.if	(\?2 = 2);Immediate
			lda	\1
			ora	#LOW(\2)
			sta	\1

			lda	\1+1
			ora	#HIGH(\2)
			sta	\1+1
		.else
			lda	\1
			ora	\2
			sta	\1

			lda	\1+1
			ora	\2+1
			sta	\1+1
		.endif
		.endm


;----------------------------
eorm		.macro
;\1 = \1 XOR \2
		lda	\1
		eor	\2
		sta	\1
		.endm


;----------------------------
eormw		.macro
;\1 = \1 XOR \2
		.if	(\?2 = 2);Immediate
			lda	\1
			eor	#LOW(\2)
			sta	\1

			lda	\1+1
			eor	#HIGH(\2)
			sta	\1+1
		.else
			lda	\1
			eor	\2
			sta	\1

			lda	\1+1
			eor	\2+1
			sta	\1+1
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
cmpzw		.macro
;\1 - \2
		phx
		tsx
		pha

		.if	(\?2 = 2);Immediate
			sec
			lda	\1
			sbc	#LOW(\2)
			sta	$2100, x
			lda	\1+1
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			sta	$2100, x
			lda	\1+1
			sbc	\2+1
		.endif

		php
		ora	$2100, x
		bne	.jp0\@

		pla
		ora	#$02
		bra	.jp1\@
.jp0\@
		pla
		and	#$FD
.jp1\@
		txs
		plx

		pha
		plp
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


;----------------------------
cmpzq		.macro
;\1 - \2
;\1 - \2:\3
		phx
		tsx
		pha

		.if	(\?2 = 2);Immediate
			sec
			lda	\1
			sbc	#LOW(\3)
			sta	$2100, x
			lda	\1+1
			sbc	#HIGH(\3)
			ora	$2100, x
			sta	$2100, x
			lda	\1+2
			sbc	#LOW(\2)
			ora	$2100, x
			sta	$2100, x
			lda	\1+3
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			sta	$2100, x
			lda	\1+1
			sbc	\2+1
			ora	$2100, x
			sta	$2100, x
			lda	\1+2
			sbc	\2+2
			ora	$2100, x
			sta	$2100, x
			lda	\1+3
			sbc	\2+3
		.endif

		php
		ora	$2100, x
		bne	.jp0\@

		pla
		ora	#$02
		bra	.jp1\@
.jp0\@
		pla
		and	#$FD
.jp1\@
		txs
		plx

		pha
		plp

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

muladdr			.ds	2

sqrt64a			.ds	8
sqrt64ans
sqrt64b			.ds	8

mulbank			.ds	1

;---------------------
;LDRU RSBA
padlast			.ds	1
padnow			.ds	1
padstate		.ds	1

;---------------------
puthexaddr		.ds	2
puthexdata		.ds	1

;---------------------
udiv32_2Work		.ds	2

;---------------------
vsyncFlag		.ds	1
vdp1Status		.ds	1
vdp2Status		.ds	1
selectVdc		.ds	1

;---------------------
vertexCount		.ds	1
vertexCountWork		.ds	1
vertex0Addr		.ds	2
vertex1Addr		.ds	2
vertexWork		.ds	4

;---------------------
clip2D0Count		.ds	1
clip2D1Count		.ds	1
clip2DFlag		.ds	1
clip2D0LastIndex	.ds	1

;---------------------
edgeX0			.ds	1
edgeY0			.ds	1
edgeX1			.ds	1
edgeY1			.ds	1

edgeSlopeX		.ds	1
edgeSlopeY		.ds	1
edgeSigneX		.ds	1

;---------------------
minEdgeY		.ds	1

;---------------------
polyLineX0		.ds	1
polyLineX1		.ds	1
polyLineY		.ds	1

polyLineLeftAddr	.ds	2

polyLineRightAddr	.ds	2

polyLineLeftData	.ds	1
polyLineLeftMask	.ds	1

polyLineRightData	.ds	1
polyLineRightMask	.ds	1

polyLineDataLow		.ds	1
polyLineDataHigh	.ds	1

polyLineColorNo		.ds	1
polyLineColorDataWork	.ds	1
polyLineColorDataWork0	.ds	1
polyLineColorDataWork1	.ds	1
polyLineColorDataWork2	.ds	1
polyLineColorDataWork3	.ds	1

polyLineYAddr		.ds	2
polyLineCount		.ds	1

;---------------------
polyBufferAddr		.ds	2
polyBufferZ0Work0	.ds	2
polyBufferZ0Work1	.ds	2

polyBufferNow		.ds	2
polyBufferNext		.ds	2

frontClipFlag		.ds	1
frontClipCount		.ds	1

frontClipData0		.ds	1
frontClipData1		.ds	1
frontClipDataWork	.ds	1

clipFrontX		.ds	2
clipFrontY		.ds	2

polyBufferAddrWork0	.ds	1
polyBufferAddrWork1	.ds	1
polyBufferAddrWork2	.ds	1

;---------------------
modelAddr		.ds	2
modelAddrWork		.ds	2
modelPolygonCount	.ds	1
setModelCount		.ds	1
setModelCountWork	.ds	1
setModelFrontColor	.ds	1
setModelBackColor	.ds	1
setModelColorY		.ds	1
setModelAttr		.ds	1
model2DClipIndexWork	.ds	1

;---------------------
setBatWork		.ds	2

;---------------------
centerX			.ds	2
centerY			.ds	2

;---------------------
translationX		.ds	2
translationY		.ds	2
translationZ		.ds	2

;---------------------
rotationX		.ds	1
rotationY		.ds	1
rotationZ		.ds	1

rotationSelect		.ds	1

vertexRotationSin	.ds	2
vertexRotationCos	.ds	2

;---------------------
eyeTranslationX		.ds	2
eyeTranslationY		.ds	2
eyeTranslationZ		.ds	2

eyeRotationX		.ds	1
eyeRotationY		.ds	1
eyeRotationZ		.ds	1

eyeRotationSelect	.ds	1


		.bss
;**********************************
		.org 	$2100
;**********************************
		.org 	$2200
;---------------------
frameCount		.ds	1
drawCount		.ds	1
drawCountWork		.ds	1

;---------------------
shipX			.ds	2
shipY			.ds	2
shipZ			.ds	2
shipRX			.ds	1
shipRY			.ds	1
shipRZ			.ds	1

;---------------------
ringX			.ds	2
ringY			.ds	2
ringZ			.ds	2
ringRX			.ds	1
ringRY			.ds	1
ringRZ			.ds	1

;---------------------
building1X		.ds	2
building1Y		.ds	2
building1Z		.ds	2
building1RX		.ds	1
building1RY		.ds	1
building1RZ		.ds	1

;---------------------
building2X		.ds	2
building2Y		.ds	2
building2Z		.ds	2
building2RX		.ds	1
building2RY		.ds	1
building2RZ		.ds	1

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
clip2D0			.ds	(8+1)*4
clip2D1			.ds	(8+1)*4

;---------------------
edgeLeft		.ds	192
edgeRight		.ds	192
edgeCount		.ds	192
			.ds	1

;---------------------
polyBufferStart		.ds	6
polyBufferEnd		.ds	6

polyBuffer		.ds	2048

;NEXT ADDR 2Byte
;SAMPLE Z 2Byte
;COLOR 1Byte
;COUNT 1Byte $00 DATA END
;X0 Y0 2Byte
;X1 Y1 2Byte
;X2 Y2 2Byte
;X3 Y3 2Byte
;X4 Y4 2Byte
;X5 Y5 2Byte
;X6 Y6 2Byte
;X7 Y7 2Byte
;X8 Y8 2Byte


;//////////////////////////////////
		.code
		.bank	0
;**********************************
		.org	$E000

main:
;initialize VDC
		jsr	initializeVdc

;initialize pad
		jsr	initializepad

;set poly proc bank
		lda	#$01
		tam	#$05

		lda	#$02
		tam	#$06

		jsr	setBAT

;initialize datas
		lda	#128
		sta	<centerX
		lda	#96
		sta	<centerY

;--------
		stz	shipRX
		stz	shipRY
		stz	shipRZ

		lda	#0
		sta	shipX
		lda	#0
		sta	shipX+1
		lda	#0
		sta	shipY
		lda	#0
		sta	shipY+1
		lda	#$C0
		sta	shipZ
		lda	#$00
		sta	shipZ+1

;--------
		lda	#0
		sta	ringX
		lda	#0
		sta	ringX+1
		lda	#0
		sta	ringY
		lda	#0
		sta	ringY+1
		lda	#$00
		sta	ringZ
		lda	#$08
		sta	ringZ+1

		lda	#0
		sta	ringRX
		lda	#0
		sta	ringRY
		lda	#0
		sta	ringRZ

;--------
		lda	#$80
		sta	building1X
		lda	#$00
		sta	building1X+1
		lda	#$80
		sta	building1Y
		lda	#$00
		sta	building1Y+1
		lda	#$00
		sta	building1Z
		lda	#$04
		sta	building1Z+1

		lda	#0
		sta	building1RX
		lda	#0
		sta	building1RY
		lda	#0
		sta	building1RZ

;--------
		lda	#$00
		sta	building2X
		lda	#$FF
		sta	building2X+1
		lda	#$80
		sta	building2Y
		lda	#$00
		sta	building2Y+1
		lda	#$00
		sta	building2Z
		lda	#$06
		sta	building2Z+1

		lda	#0
		sta	building2RX
		lda	#0
		sta	building2RY
		lda	#0
		sta	building2RZ

;--------
		lda	#60
		sta	frameCount
		stz	drawCount
		stz	drawCountWork

;VDC1
;bg sp       vsync
;+32
		mov	VDC1_0, #$05
		movw	VDC1_2, #$08C8

;VDC2
;bg sp
;+32
		mov	VDC2_0, #$05
		movw	VDC2_2, #$0800

		mov	<selectVdc, #VDC2

		rmb7	<vsyncFlag

;vsync interrupt start
		cli

;main loop
.mainLoop:
;wait vsync
		bbs7	<vsyncFlag, .mainLoop

		eorm	<selectVdc, #$03

;check pad
;pad up
		bbr4	<padnow, .checkPadDown
		sec
		lda	shipY
		sbc	#$04
		sta	shipY
		lda	shipY+1
		sbc	#$00
		sta	shipY+1

.checkPadDown:
;pad down
		bbr6	<padnow, .checkPadLeft
		clc
		lda	shipY
		adc	#$04
		sta	shipY
		lda	shipY+1
		adc	#$00
		sta	shipY+1

.checkPadLeft:
;pad left
		bbr7	<padnow, .checkPadRight
		sec
		lda	shipX
		sbc	#$04
		sta	shipX
		lda	shipX+1
		sbc	#$00
		sta	shipX+1

.checkPadRight:
;pad right
		bbr5	<padnow, .checkPadEnd
		clc
		lda	shipX
		adc	#$04
		sta	shipX
		lda	shipX+1
		adc	#$00
		sta	shipX+1

.checkPadEnd:

;set datas
		lda	shipX
		sta	<eyeTranslationX
		lda	shipX+1
		sta	<eyeTranslationX+1

		lda	<eyeTranslationX+1
		asl	a
		ror	<eyeTranslationX+1
		ror	<eyeTranslationX

		sec
		lda	<eyeTranslationX
		sbc	#$C1
		lda	<eyeTranslationX+1
		sbc	#$FF
		bpl	.eyeJump0	; >= -63

		clc
		lda	shipX
		adc	#$3F
		sta	<eyeTranslationX
		lda	shipX+1
		adc	#$00
		sta	<eyeTranslationX+1

.eyeJump0:
		sec
		lda	<eyeTranslationX
		sbc	#$40
		lda	<eyeTranslationX+1
		sbc	#$00
		bmi	.eyeJump1	; < 64

		sec
		lda	shipX
		sbc	#$3F
		sta	<eyeTranslationX
		lda	shipX+1
		sbc	#$00
		sta	<eyeTranslationX+1

.eyeJump1:
		lda	shipY
		sta	<eyeTranslationY
		lda	shipY+1
		sta	<eyeTranslationY+1

		lda	<eyeTranslationY+1
		asl	a
		ror	<eyeTranslationY+1
		ror	<eyeTranslationY

		sec
		lda	<eyeTranslationY
		sbc	#$C1
		lda	<eyeTranslationY+1
		sbc	#$FF
		bpl	.eyeJump2	; >= -63

		clc
		lda	shipY
		adc	#$3F
		sta	<eyeTranslationY
		lda	shipY+1
		adc	#$00
		sta	<eyeTranslationY+1

.eyeJump2:
		sec
		lda	<eyeTranslationY
		sbc	#$40
		lda	<eyeTranslationY+1
		sbc	#$00
		bmi	.eyeJump3	; < 64

		sec
		lda	shipY
		sbc	#$3F
		sta	<eyeTranslationY
		lda	shipY+1
		sbc	#$00
		sta	<eyeTranslationY+1

.eyeJump3:

		lda	#0
		sta	<eyeRotationX

		lda	#0
		sta	<eyeRotationY

		lda	#0
		sta	<eyeRotationZ

		lda	#$12
		sta	<eyeRotationSelect

;initialize buffer
		jsr	initializePolyBuffer

;set ship model
		lda	shipX
		sta	<translationX
		lda	shipX+1
		sta	<translationX+1

		lda	shipY
		sta	<translationY
		lda	shipY+1
		sta	<translationY+1

		lda	shipZ
		sta	<translationZ
		lda	shipZ+1
		sta	<translationZ+1

		lda	shipRX
		sta	<rotationX

		lda	shipRY
		sta	<rotationY

		lda	shipRZ
		sta	<rotationZ

		lda	#$12
		sta	<rotationSelect

		lda	#LOW(modelData0)
		sta	<modelAddr
		lda	#HIGH(modelData0)
		sta	<modelAddr+1

		jsr	setModel2

;set ring model
		lda	ringX
		sta	<translationX
		lda	ringX+1
		sta	<translationX+1

		lda	ringY
		sta	<translationY
		lda	ringY+1
		sta	<translationY+1

		lda	ringZ
		sta	<translationZ
		lda	ringZ+1
		sta	<translationZ+1

		lda	ringRX
		sta	<rotationX

		lda	ringRY
		sta	<rotationY

		lda	ringRZ
		sta	<rotationZ

		lda	#$12
		sta	<rotationSelect

		lda	#LOW(modelData1)
		sta	<modelAddr
		lda	#HIGH(modelData1)
		sta	<modelAddr+1

		jsr	setModel2

		sec
		lda	ringZ
		sbc	#$10
		sta	ringZ
		lda	ringZ+1
		sbc	#$00
		sta	ringZ+1
		bpl	.ringJump

		lda	#$00
		sta	ringZ
		lda	#$08
		sta	ringZ+1

.ringJump:
		inc	ringRZ
		inc	ringRZ

;set building1 model
		lda	building1X
		sta	<translationX
		lda	building1X+1
		sta	<translationX+1

		lda	building1Y
		sta	<translationY
		lda	building1Y+1
		sta	<translationY+1

		lda	building1Z
		sta	<translationZ
		lda	building1Z+1
		sta	<translationZ+1

		lda	building1RX
		sta	<rotationX

		lda	building1RY
		sta	<rotationY

		lda	building1RZ
		sta	<rotationZ

		lda	#$12
		sta	<rotationSelect

		lda	#LOW(modelData2)
		sta	<modelAddr
		lda	#HIGH(modelData2)
		sta	<modelAddr+1

		jsr	setModel2

		sec
		lda	building1Z
		sbc	#$10
		sta	building1Z
		lda	building1Z+1
		sbc	#$00
		sta	building1Z+1
		bpl	.building1Jump

		lda	#$00
		sta	building1Z
		lda	#$08
		sta	building1Z+1

.building1Jump:

;set building2 model
		lda	building2X
		sta	<translationX
		lda	building2X+1
		sta	<translationX+1

		lda	building2Y
		sta	<translationY
		lda	building2Y+1
		sta	<translationY+1

		lda	building2Z
		sta	<translationZ
		lda	building2Z+1
		sta	<translationZ+1

		lda	building2RX
		sta	<rotationX

		lda	building2RY
		sta	<rotationY

		lda	building2RZ
		sta	<rotationZ

		lda	#$12
		sta	<rotationSelect

		lda	#LOW(modelData2)
		sta	<modelAddr
		lda	#HIGH(modelData2)
		sta	<modelAddr+1

		jsr	setModel2

		sec
		lda	building2Z
		sbc	#$10
		sta	building2Z
		lda	building2Z+1
		sbc	#$00
		sta	building2Z+1
		bpl	.building2Jump

		lda	#$00
		sta	building2Z
		lda	#$08
		sta	building2Z+1

.building2Jump:

;put polygon
		jsr	putPolyBuffer

		inc	drawCountWork

		ldx	#0
		ldy	#24
		lda	drawCount
		sei
		jsr	puthex2
		cli

;set vsync flag
		smb7	<vsyncFlag

;jump mainloop
		jmp	.mainLoop


;----------------------------
initializeVdc:
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

;set vdc
vdcdataloop:	lda	vdcdata, y
		cmp	#$FF
		beq	vdcdataend
		sta	VDC1_0
		sta	VDC2_0
		iny

		lda	vdcdata, y
		sta	VDC1_2
		sta	VDC2_2
		iny

		lda	vdcdata, y
		sta	VDC1_3
		sta	VDC2_3
		iny
		bra	vdcdataloop
vdcdataend:

;disable interrupts TIQD       IRQ2D
		lda	#$05
		sta	$1402

;262Line  VCE Clock 5MHz
		lda	#$04
		sta	$0400
		stz	$0401

;set palette
		stz	$0402
		stz	$0403
		tia	palettedata, $0404, $20*32

;CHAR set to vram
		lda	#chardatBank
		tam	#$06

;vram address $1000
		mov	VDC1_0, #$00
		movw	VDC1_2, #$1000
		mov	VDC1_0, #$02
		tia	$C000, VDC1_2, $2000

		mov	VDC2_0, #$00
		movw	VDC2_2, #$1000
		mov	VDC2_0, #$02
		tia	$C000, VDC2_2, $2000

;clear BAT
		st0	#$00
		st1	#$00
		st2	#$00
		st0	#$02
		ldy	#32
.clearbatloop0:
		ldx	#32
.clearbatloop1:
		st1	#$20
		st2	#$01
		dex
		bne	.clearbatloop1
		dey
		bne	.clearbatloop0

;clear zeropage
		stz	$2000
		tii	$2000, $2001, $00FF

;screen on
;bg sp       vsync
;+1
		st0	#$05
		st1	#$C8
		st2	#$00

		rts


;----------------------------
puthex2:
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
		tay

		lda	<selectVdc
		cmp	#VDC2
		beq 	.vdc_2

		mov	VDC1_0, #$00
		movw	VDC1_2, <puthexaddr

		mov	VDC1_0, #$02
		stx	VDC1_2
		mov	VDC1_3, #$01

		addw	<puthexaddr, #1

		mov	VDC1_0, #$00
		movw	VDC1_2, <puthexaddr

		mov	VDC1_0, #$02
		sty	VDC1_2
		mov	VDC1_3, #$01

		bra	.puthexEnd

.vdc_2:
		mov	VDC2_0, #$00
		movw	VDC2_2, <puthexaddr

		mov	VDC2_0, #$02
		stx	VDC2_2
		mov	VDC2_3, #$01

		addw	<puthexaddr, #1

		mov	VDC2_0, #$00
		movw	VDC2_2, <puthexaddr

		mov	VDC2_0, #$02
		sty	VDC2_2
		mov	VDC2_3, #$01

.puthexEnd:
		ply
		plx
		pla

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
;div16a div16b = div16d:div16c / div16a
;push x
		phx

;dec div16a
		lda	<div16a
		bne	.jp00
		dec	<div16a+1
.jp00:
		dec	<div16a

		ldx	#$10
		asl	<div16c
		rol	<div16c+1

.jpPl00:
;div16d
		rol	<div16d
		rol	<div16d+1

		lda	<div16d
		sbc	<div16a
		sta	<div16d

		lda	<div16d+1
		sbc	<div16a+1
		sta	<div16d+1

		bcc	.jpMi01

.jpPl01:
		rol	<div16c
		rol	<div16c+1

		dex
		bne	.jpPl00

		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

		lda	<div16d
		sta	<div16b
		lda	<div16d+1
		sta	<div16b+1

;pull x
		plx
		rts

.jpMi00:
;div16d
		rol	<div16d
		rol	<div16d+1

		lda	<div16d
		adc	<div16a
		sta	<div16d

		lda	<div16d+1
		adc	<div16a+1
		sta	<div16d+1

		bcs	.jpPl01

.jpMi01:
		rol	<div16c
		rol	<div16c+1

		dex
		bne	.jpMi00

		sec
		lda	<div16d
		adc	<div16a
		sta	<div16b

		lda	<div16d+1
		adc	<div16a+1
		sta	<div16b+1

		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

;pull x
		plx
		rts


;----------------------------
smul16:
;mul16d:mul16c = mul16a * mul16b
;push x
		phx

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
		plx
		rts


;----------------------------
umul16:
;mul16d:mul16c = mul16a * mul16b
;push x y
		phx
		phy

		ldx	<mul16b
		lda	mulbankdata, x
		pha
		tam	#$02

		lda	muladdrdata, x
		stz	<muladdr
		sta	<muladdr+1

		ldy	<mul16a
		lda	[muladdr], y
		sta	<mul16c

		ldy	<mul16a+1
		lda	[muladdr], y
		sta	<mul16c+1

		pla
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<mul16a
		lda	[muladdr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[muladdr], y
		adc	#0
		sta	<mul16d

		ldx	<mul16b+1
		lda	mulbankdata, x
		pha
		tam	#$02

		lda	muladdrdata, x
		stz	<muladdr
		sta	<muladdr+1

		clc
		ldy	<mul16a
		lda	[muladdr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[muladdr], y
		adc	<mul16d
		sta	<mul16d

		cla
		adc	#0
		sta	<mul16d+1

		pla
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<mul16a
		lda	[muladdr], y
		adc	<mul16d
		sta	<mul16d

		ldy	<mul16a+1
		lda	[muladdr], y
		adc	<mul16d+1
		sta	<mul16d+1

;pull y x
		ply
		plx
		rts


;----------------------------
initializepad:
;
		stz	<padlast
		stz	<padnow
		stz	<padstate
		rts


;----------------------------
getpaddata:
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

;get pad data end
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
_irq1:
;IRQ1 interrupt process
;ACK interrupt
		pha
		phx
		phy

		lda	VDC1_0
		sta	<vdp1Status
		lda	VDC2_0
		sta	<vdp2Status

		bbs7	<vsyncFlag, .vsyncProc
		jmp	.vsyncProcEnd

.vsyncProc:
		lda	<selectVdc
		cmp	#VDC2
		beq	.vdc2Jp

;+32 bg sp vsync
		mov	VDC1_0, #$05
		movw	VDC1_2, #$08C8

;+32
		mov	VDC2_0, #$05
		movw	VDC2_2, #$0800

;VRAM Clear
		clx
		cly
.vramClearLoop2:
		mov	VDC2_0, #$00		;set VRAM addr
		sty	VDC2_2
		movw	VDC2_3, #$40
		iny

		mov	VDC2_0, #$02		;VRAM clear
		lda	vramClearData, x
		sta	VDC2_2
		inx
		lda	vramClearData, x
		sta	VDC2_3
		inx

		cpx	#$20
		bne	.vramClearLoop2

		mov	VDC2_0, #$10		;set DMA src
		movw	VDC2_2, #$4000

		mov	VDC2_0, #$11		;set DMA dist
		movw	VDC2_2, #$4010

		mov	VDC2_0, #$12		;set DMA count
		movw	VDC2_2, #$4000-$10

		bra	.vdcEnd
.vdc2Jp:
;+32 vsync
		mov	VDC1_0, #$05
		movw	VDC1_2, #$0808

;bg sp
;+32 bg sp
		mov	VDC2_0, #$05
		movw	VDC2_2, #$08C0

;VRAM Clear
		clx
		cly
.vramClearLoop1:
		mov	VDC1_0, #$00		;set VRAM addr
		sty	VDC1_2
		movw	VDC1_3, #$40
		iny

		mov	VDC1_0, #$02		;VRAM clear
		lda	vramClearData, x
		sta	VDC1_2
		inx
		lda	vramClearData, x
		sta	VDC1_3
		inx

		cpx	#$20
		bne	.vramClearLoop1

		mov	VDC1_0, #$10		;set DMA src
		movw	VDC1_2, #$4000

		mov	VDC1_0, #$11		;set DMA dist
		movw	VDC1_2, #$4010

		mov	VDC1_0, #$12		;set DMA count
		movw	VDC1_2, #$4000-$10
.vdcEnd:

		rmb7	<vsyncFlag

.vsyncProcEnd:

		jsr	getpaddata

		dec	frameCount
		bne	.irqEnd

		lda	#60
		sta	frameCount

		lda	drawCountWork
		sta	drawCount
		stz	drawCountWork
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
vramClearData
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00


;----------------------------
;Star Fox Arwing
modelData0
		.dw	modelData0Polygon
		.db	18	;polygon count
		.dw	modelData0Vertex
		.db	16	;vertex count
modelData0Polygon
		;	front color * 8 + vertex count(3 or 4), back color * 8 + back draw flag($01 = not draw : front side = clockwise)
		.db	$19*8+3, $00*8+$01, 0*6, 2*6, 1*6, 0*0;0 Front Bottom
		.db	$1C*8+3, $00*8+$01, 0*6, 1*6, 3*6, 0*0;1 Front Right
		.db	$1E*8+3, $00*8+$01, 0*6, 3*6, 2*6, 0*0;2 Front Left

		.db	$1A*8+3, $00*8+$01, 3*6, 1*6, 4*6, 0*0;3 Middle Outer Right
		.db	$1C*8+3, $00*8+$01, 3*6, 4*6, 2*6, 0*0;4 Middle Outer Left

		.db	$09*8+3, $00*8+$01, 5*6, 1*6, 2*6, 0*0;5 Middle Inner

		.db	$1A*8+3, $00*8+$01, 1*6, 5*6, 4*6, 0*0;6 Middle Inner Right
		.db	$1A*8+3, $00*8+$01, 4*6, 5*6, 2*6, 0*0;7 Middle Inner Left

		.db	$09*8+3, $00*8+$01, 7*6, 6*6, 1*6, 0*0;8 Right Wing Front
		.db	$1B*8+3, $00*8+$01, 6*6, 7*6, 8*6, 0*0;9 Right Wing Right
		.db	$1D*8+3, $00*8+$01, 1*6, 8*6, 7*6, 0*0;10 Right Wing Left
		.db	$1C*8+3, $00*8+$01, 1*6, 6*6, 8*6, 0*0;11 Right Wing Top

		.db	$09*8+3, $00*8+$01, 2*6, 9*6,10*6, 0*0;12 Left Wing Front
		.db	$1B*8+3, $00*8+$01, 2*6,10*6,11*6, 0*0;13 Left Wing Right
		.db	$1D*8+3, $00*8+$01, 9*6,11*6,10*6, 0*0;14 Left Wing Left
		.db	$1C*8+3, $00*8+$01, 9*6, 2*6,11*6, 0*0;15 Left Wing Top

		.db	$04*8+3, $0C*8+$00, 1*6,13*6,12*6, 0*0;16 Right Wing

		.db	$04*8+3, $0C*8+$00, 2*6,14*6,15*6, 0*0;17 Left Wing

modelData0Vertex
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
;Ring
modelData1
		.dw	modelData1Polygon
		.db	16	;polygon count
		.dw	modelData1Vertex
		.db	24	;vertex count

modelData1Polygon
		.db	$1A*8+4, $00*8+$01, 0*6, 3*6, 4*6, 1*6; 0
		.db	$19*8+4, $00*8+$01, 1*6, 4*6, 5*6, 2*6; 1

		.db	$1B*8+4, $00*8+$01, 3*6, 6*6, 7*6, 4*6; 2
		.db	$1A*8+4, $00*8+$01, 4*6, 7*6, 8*6, 5*6; 3

		.db	$1C*8+4, $00*8+$01, 6*6, 9*6,10*6, 7*6; 4
		.db	$1B*8+4, $00*8+$01, 7*6,10*6,11*6, 8*6; 5

		.db	$1E*8+4, $00*8+$01, 9*6,12*6,13*6,10*6; 6
		.db	$1D*8+4, $00*8+$01,10*6,13*6,14*6,11*6; 7

		.db	$1E*8+4, $00*8+$01,12*6,15*6,16*6,13*6; 8
		.db	$1D*8+4, $00*8+$01,13*6,16*6,17*6,14*6; 9

		.db	$1C*8+4, $00*8+$01,15*6,18*6,19*6,16*6;10
		.db	$1B*8+4, $00*8+$01,16*6,19*6,20*6,17*6;11

		.db	$1B*8+4, $00*8+$01,18*6,21*6,22*6,19*6;12
		.db	$1A*8+4, $00*8+$01,19*6,22*6,23*6,20*6;13

		.db	$1A*8+4, $00*8+$01,21*6, 0*6, 1*6,22*6;14
		.db	$19*8+4, $00*8+$01,22*6, 1*6, 2*6,23*6;15

modelData1Vertex
		.dw	   0,-159,   0; 0
		.dw	   0,-143, -15; 1
		.dw	   0,-127,   0; 2

		.dw	 112,-112,   0; 3
		.dw	 101,-101, -15; 4
		.dw	  90, -90,   0; 5

		.dw	 159,   0,   0; 6
		.dw	 143,   0, -15; 7
		.dw	 127,   0,   0; 8

		.dw	 112, 112,   0; 9
		.dw	 101, 101, -15;10
		.dw	  90,  90,   0;11

		.dw	   0, 159,   0;12
		.dw	   0, 143, -15;13
		.dw	   0, 127,   0;14

		.dw	-112, 112,   0;15
		.dw	-101, 101, -15;16
		.dw	 -90,  90,   0;17

		.dw	-159,   0,   0;18
		.dw	-143,   0, -15;19
		.dw	-127,   0,   0;20

		.dw	-112,-112,   0;21
		.dw	-101,-101, -15;22
		.dw	 -90, -90,   0;23


;----------------------------
;Building
modelData2
		.dw	modelData2Polygon
		.db	4	;polygon count
		.dw	modelData2Vertex
		.db	8	;vertex count

modelData2Polygon
		.db	$1D*8+4, $00*8+$01, 0*6, 1*6, 2*6, 3*6; 0
		.db	$1B*8+4, $00*8+$01, 3*6, 2*6, 6*6, 7*6; 1
		.db	$19*8+4, $00*8+$01, 2*6, 1*6, 5*6, 6*6; 2
		.db	$19*8+4, $00*8+$01, 0*6, 3*6, 7*6, 4*6; 3

modelData2Vertex
		.dw	 -50,-100,  50; 0
		.dw	  50,-100,  50; 1
		.dw	  50,-100, -50; 2
		.dw	 -50,-100, -50; 3

		.dw	 -50, 100,  50; 4
		.dw	  50, 100,  50; 5
		.dw	  50, 100, -50; 6
		.dw	 -50, 100, -50; 7


;----------------------------
vdcdata:
		.db	$05, $00, $00	;screen off +1
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $0D	;VSW $02 VDS $0D
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $03, $00	;VCR $03
		.db	$0F, $00, $00	;DMA +1 +1
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $00, $00	;32x32
		.db	$FF		;end


;----------------------------
palettedata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\;GRB
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
mulbankdata:
		.db	$04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04,\
			$04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04,\
			$05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05,\
			$05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05,\
			$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06,\
			$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06,\
			$07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07,\
			$07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09,\
			$09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09,\
			$0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A,\
			$0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A,\
			$0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B,\
			$0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B


;----------------------------
muladdrdata:
		.db	$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F


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

		.org	$A000

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
		rts

.rotationSelectJump11:
		ldx	<rotationY
		jsr	vertexRotationY
		rts

.rotationSelectJump12:
		ldx	<rotationZ
		jsr	vertexRotationZ

.rotationSelectJump2:
		rts


;----------------------------
vertexRotationZ:
;x=xcosA-ysinA y=xsinA+ycosA z=z
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		jeq	.vertexRotationZEnd

		lda	<vertexCount
		jeq	.vertexRotationZEnd
		sta	<vertexCountWork

		lda	sinDataLow,x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh,x
		sta	<vertexRotationSin+1

		lda	cosDataLow,x			;cos
		sta	<vertexRotationCos
		lda	cosDataHigh,x
		sta	<vertexRotationCos+1

		cly

.vertexRotationZLoop:
;----------------
		lda	transform2DWork0,y		;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;xcosA

		movq	<div16ans, <mul16c

		lda	transform2DWork0+2,y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;ysinA

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
		lda	transform2DWork0,y		;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;xsinA

		movq	<div16ans, <mul16c

		lda	transform2DWork0+2,y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;ycosA

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
;x=xcosA+zsinA y=y           z=-xsinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		jeq	.vertexRotationYEnd

		lda	<vertexCount
		jeq	.vertexRotationYEnd
		sta	<vertexCountWork

		lda	sinDataLow,x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh,x
		sta	<vertexRotationSin+1

		lda	cosDataLow,x			;cos
		sta	<vertexRotationCos
		lda	cosDataHigh,x
		sta	<vertexRotationCos+1

		cly

.vertexRotationYLoop:
;----------------
		lda	transform2DWork0+4,y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;zsinA

		movq	<div16ans, <mul16c

		lda	transform2DWork0,y		;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;xcosA

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
		lda	transform2DWork0+4,y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;zcosA

		movq	<div16ans, <mul16c

		lda	transform2DWork0,y		;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;xsinA

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
;x=x           y=ycosA-zsinA z= ysinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		jeq	.vertexRotationXEnd

		lda	<vertexCount
		jeq	.vertexRotationXEnd
		sta	<vertexCountWork

		lda	sinDataLow,x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh,x
		sta	<vertexRotationSin+1

		lda	cosDataLow,x			;cos
		sta	<vertexRotationCos
		lda	cosDataHigh,x
		sta	<vertexRotationCos+1

		cly

.vertexRotationXLoop:
;----------------
		lda	transform2DWork0+2,y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;ycosA

		movq	<div16ans, <mul16c

		lda	transform2DWork0+4,y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;zsinA

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
		lda	transform2DWork0+2,y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;ysinA


		movq	<div16ans, <mul16c

		lda	transform2DWork0+4,y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;zcosA

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
		lda	transform2DWork0, y
		sta	transform2DWork1, y
		lda	transform2DWork0+1, y
		sta	transform2DWork1+1, y

		lda	transform2DWork0+2, y
		sta	transform2DWork1+2, y
		lda	transform2DWork0+3, y
		sta	transform2DWork1+3, y

		lda	transform2DWork0+4, y
		sta	transform2DWork1+4, y
		lda	transform2DWork0+5, y
		sta	transform2DWork1+5, y

;Z0 < 128 check
		sec
		lda	transform2DWork0+4, y	;Z0
		sbc	#128
		lda	transform2DWork0+5, y
		sbc	#00

		bpl	.transform2D2Jump05
		jmp	.transform2D2Jump00

.transform2D2Jump05:
;X0 to mul16c
		lda	transform2DWork0, y
		sta	<mul16c
		lda	transform2DWork0+1, y
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4, y
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

;X0*128/Z0
		jsr	transform2DProc

;X0*128/Z0+centerX
;mul16a+centerX to X0
		clc
		lda	<mul16a
		adc	<centerX
		sta	transform2DWork0, y	;X0
		lda	<mul16a+1
		adc	<centerX+1
		sta	transform2DWork0+1, y

;Y0 to mul16c
		lda	transform2DWork0+2, y
		sta	<mul16c
		lda	transform2DWork0+3, y
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4, y
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

;Y0*128/Z0
		jsr	transform2DProc

;Y0*128/Z0+centerY
;mul16a+centerY to Y0
		clc
		lda	<mul16a
		adc	<centerY
		sta	transform2DWork0+2, y	;Y0
		lda	<mul16a+1
		adc	<centerY+1
		sta	transform2DWork0+3, y

		jmp	.transform2D2Jump01

.transform2D2Jump00:
;Z0<128 flag set
		lda	#$00
		sta	transform2DWork0+4, y
		lda	#$80
		sta	transform2DWork0+5, y

.transform2D2Jump01:
		clc
		tya
		adc	#6
		tay

		dex
		jne	.transform2D2Loop0

		rts


;----------------------------
moveToTransform2DWork0:
;vertex0Addr to Transform2DWork0
		lda	<vertexCount
		beq	.moveToTransform2DWork0End
		sta	<vertexCountWork

		cly

.moveToTransform2DWork0Loop:
		lda	[vertex0Addr], y
		sta	transform2DWork0, y
		iny
		lda	[vertex0Addr],y
		sta	transform2DWork0, y
		iny

		lda	[vertex0Addr],y
		sta	transform2DWork0, y
		iny
		lda	[vertex0Addr],y
		sta	transform2DWork0, y
		iny

		lda	[vertex0Addr],y
		sta	transform2DWork0, y
		iny
		lda	[vertex0Addr],y
		sta	transform2DWork0, y
		iny

		dec	<vertexCountWork
		bne	.moveToTransform2DWork0Loop

.moveToTransform2DWork0End:
		rts


;----------------------------
putPolyBuffer:
;
		movw	<polyBufferAddr, polyBufferStart

.putPolyBufferLoop0:
		ldy	#5
		lda	[polyBufferAddr], y	;COUNT
		beq	.putPolyBufferEnd
		sta	<clip2D0Count
		pha

		ldy	#4
		lda	[polyBufferAddr], y	;COLOR
		sta	<polyLineColorNo

		clx
		ldy	#6

.putPolyBufferLoop1:
		lda	[polyBufferAddr], y
		sta	clip2D0,x
		inx
		inx
		iny

		lda	[polyBufferAddr], y
		sta	clip2D0,x
		inx
		inx
		iny

		dec	<clip2D0Count
		bne	.putPolyBufferLoop1

		pla
		sta	<clip2D0Count

		jsr	calcEdge_putPoly

		ldy	#0
		lda	[polyBufferAddr], y
		tax
		iny
		lda	[polyBufferAddr], y
		sta	<polyBufferAddr+1
		txa
		sta	<polyBufferAddr+0

		bra	.putPolyBufferLoop0

.putPolyBufferEnd:
		rts


;----------------------------
setModel2:
;
;rotation
		ldy	#$05
		lda	[modelAddr], y		;vertex count
		sta	<vertexCount

		ldy	#$03
		lda	[modelAddr], y		;vertex data address
		sta	<vertex0Addr
		ldy	#$04
		lda	[modelAddr], y
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

		jsr	setModelProc2

		rts


;----------------------------
setModel:
;
;Rotation
		ldy	#$05
		lda	[modelAddr], y		;vertex count
		sta	<vertexCount

		ldy	#$03
		lda	[modelAddr], y		;vertex data address
		sta	<vertex0Addr
		ldy	#$04
		lda	[modelAddr], y
		sta	<vertex0Addr+1

		movw	<vertex1Addr, #transform2DWork0

		jsr	vertexMultiply

;translation
		ldy	#$05
		lda	[modelAddr], y		;vertex count
		sta	<vertexCount

		movw	<vertex0Addr, #transform2DWork0

		movw	<vertex1Addr, #transform2DWork1

		jsr	vertexTranslation

;transform2D
		ldy	#$05
		lda	[modelAddr], y		;vertex count
		sta	<vertexCount

		movw	<vertex0Addr, #transform2DWork1

		movw	<vertex1Addr, #transform2DWork0

		jsr	transform2D

		jsr	setModelProc

		rts


;----------------------------
setModelProc2:
;
		ldy	#$00
		lda	[modelAddr], y
		sta	<modelAddrWork		;ModelData Polygon Addr
		iny
		lda	[modelAddr], y
		sta	<modelAddrWork+1

		ldy	#$02
		lda	[modelAddr], y		;Polygon Count
		sta	<modelPolygonCount

		cly

.setModelLoop3:
		phy

		lda	[modelAddrWork], y	;ModelData Vertex Count, Front Color
		and	#$F8
		lsr	a
		lsr	a
		sta	<setModelFrontColor

		lda	[modelAddrWork], y	;ModelData Vertex Count, Front Color
		and	#$07
		dec	a
		sta	<setModelCount

		iny

		lda	[modelAddrWork], y	;ModelData Polygon Attr, Back Color
		sta	<setModelAttr
		and	#$F8
		lsr	a
		lsr	a
		sta	<setModelBackColor

		iny

		lda	[modelAddrWork], y
		sta	<frontClipDataWork

		stz	<model2DClipIndexWork

		stz	<frontClipCount

		stz	<polyBufferZ0Work0
		stz	<polyBufferZ0Work0+1

.setModelLoop4:
		lda	[modelAddrWork], y
		sta	<frontClipData0

		iny

		lda	[modelAddrWork], y
		sta	<frontClipData1

		phy
		jsr	clipFront
		ply

		dec	<setModelCount
		bne	.setModelLoop4

;--------
		lda	[modelAddrWork], y
		sta	<frontClipData0

		lda	<frontClipDataWork
		sta	<frontClipData1

		jsr	clipFront

		lda	<frontClipCount
		jeq	.setModelJump0

		sta	<clip2D0Count
		jsr	clip2D
		jeq	.setModelJump0

;back side check
		sec
		lda	clip2D0+8		;X2
		sbc	clip2D0+4		;X1
		sta	<mul16a
		cla
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0+2		;Y0
		sbc	clip2D0+6		;Y1
		sta	<mul16b
		cla
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		movq	<div16ans, <mul16c

		sec
		lda	clip2D0+10		;Y2
		sbc	clip2D0+6		;Y1
		sta	<mul16a
		cla
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0			;X0
		sbc	clip2D0+4		;X1
		sta	<mul16b
		cla
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		cmpq	<div16ans, <mul16c

		bpl	.setModelJump2

;Back Side
		bbr0	<setModelAttr, .setModelJump6
		jmp	.setModelJump0

.setModelJump6:
		lda	<setModelBackColor
		bra	.setModelJump5

.setModelJump2:
;Front Side
		lda	<setModelFrontColor

.setModelJump5:
		ldy	#4
		sta	[polyBufferAddr], y	;COLOR

		lda	<clip2D0Count
		ldy	#5
		sta	[polyBufferAddr], y	;COUNT

;SAMPLE Z
		ldy	#2
		lda	<polyBufferZ0Work0	;SAMPLE Z
		sta	[polyBufferAddr], y
		iny
		lda	<polyBufferZ0Work0+1
		sta	[polyBufferAddr], y

;set buffer
		movw	<polyBufferNow, #polyBufferStart

.setBufferLoop:
		ldy	#0			;NEXT ADDR
		lda	[polyBufferNow], y
		sta	<polyBufferNext
		iny
		lda	[polyBufferNow], y
		sta	<polyBufferNext+1

		ldy	#2			;NEXT SAMPLE Z
		lda	[polyBufferNext], y
		sta	<polyBufferZ0Work0
		iny
		lda	[polyBufferNext], y
		sta	<polyBufferZ0Work0+1

		ldy	#2			;SAMPLE Z
		sec
		lda	[polyBufferAddr], y
		sbc	<polyBufferZ0Work0
		iny
		lda	[polyBufferAddr], y
		sbc	<polyBufferZ0Work0+1

		bpl	.setBufferJump		;SAMPLE Z >= NEXT SAMPLE Z

		movw	<polyBufferNow, <polyBufferNext

		bra	.setBufferLoop

.setBufferJump:
		ldy	#0			;BUFFER -> NEXT
		lda	<polyBufferNext
		sta	[polyBufferAddr], y
		iny
		lda	<polyBufferNext+1
		sta	[polyBufferAddr], y

		ldy	#0			;NOW -> BUFFER
		lda	<polyBufferAddr
		sta	[polyBufferNow], y
		iny
		lda	<polyBufferAddr+1
		sta	[polyBufferNow], y

;set data
		clx
		ldy	#6
.setModelLoop2:
		lda	clip2D0,x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		lda	clip2D0,x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		dec	<clip2D0Count
		bne	.setModelLoop2

;next buffer addr
		clc
		tya
		adc	<polyBufferAddr
		sta	<polyBufferAddr
		bcc	.setModelJump0
		inc	<polyBufferAddr+1

.setModelJump0:
		clc
		pla
		adc	#6
		tay

		dec	<modelPolygonCount
		jne	.setModelLoop3

		rts


;----------------------------
clipFront:
		ldx	<frontClipData0
		ldy	<frontClipData1

		lda	transform2DWork0+5, x	;Z0<128 flag
		and	#$80
		lsr	a
		sta	<frontClipFlag
		lda	transform2DWork0+5, y	;Z0<128 flag
		and	#$80
		ora	<frontClipFlag
		sta	<frontClipFlag
		jeq	.clipFrontJump8

		cmp	#$C0
		jeq	.clipFrontJump9

;clip front
;(128-Z0) to mul16a
		sec
		lda	#128
		sbc	transform2DWork1+4, x
		sta	<mul16a
		lda	#0
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	transform2DWork1+0, y
		sbc	transform2DWork1+0, x
		sta	<mul16b
		lda	transform2DWork1+1, y
		sbc	transform2DWork1+1, x
		sta	<mul16b+1

;(128-Z0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Z1-Z0) to mul16a
		sec
		lda	transform2DWork1+4, y
		sbc	transform2DWork1+4, x
		sta	<mul16a
		lda	transform2DWork1+5, y
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(128-Z0)*(X1-X0)/(Z1-Z0)
		jsr	sdiv32

;(128-Z0)*(X1-X0)/(Z1-Z0)+X0
		clc
		lda	<mul16a
		adc	transform2DWork1+0, x
		sta	<mul16a
		lda	<mul16a+1
		adc	transform2DWork1+1, x
		sta	<mul16a+1

;mul16a+centerX
		addw	<clipFrontX, <mul16a, <centerX

;(128-Z0) to mul16a
		sec
		lda	#128
		sbc	transform2DWork1+4, x
		sta	<mul16a
		lda	#0
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	transform2DWork1+2, y
		sbc	transform2DWork1+2, x
		sta	<mul16b
		lda	transform2DWork1+3, y
		sbc	transform2DWork1+3, x
		sta	<mul16b+1

;(128-Z0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(Z1-Z0) to mul16a
		sec
		lda	transform2DWork1+4, y
		sbc	transform2DWork1+4, x
		sta	<mul16a
		lda	transform2DWork1+5, y
		sbc	transform2DWork1+5, x
		sta	<mul16a+1

;(128-Z0)*(Y1-Y0)/(Z1-Z0)
		jsr	sdiv32

;(128-Z0)*(Y1-Y0)/(Z1-Z0)+Y0
		clc
		lda	<mul16a
		adc	transform2DWork1+2, x
		sta	<mul16a
		lda	<mul16a+1
		adc	transform2DWork1+3, x
		sta	<mul16a+1

;mul16a+centerY
		addw	<clipFrontY, <mul16a, <centerY

		bbs7	<frontClipFlag, .clipFrontJump10

		ldy	<model2DClipIndexWork

		lda	<clipFrontX
		sta	clip2D0, y
		iny
		lda	<clipFrontX+1
		sta	clip2D0, y
		iny

		lda	<clipFrontY
		sta	clip2D0, y
		iny
		lda	<clipFrontY+1
		sta	clip2D0, y
		iny

		sty	<model2DClipIndexWork

		lda	#128
		sta	polyBufferZ0Work1
		stz	polyBufferZ0Work1+1

		inc	<frontClipCount

		bra	.clipFrontJump11

.clipFrontJump10:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+2, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+3, x
		sta	clip2D0, y
		iny

		lda	<clipFrontX
		sta	clip2D0, y
		iny
		lda	<clipFrontX+1
		sta	clip2D0, y
		iny

		lda	<clipFrontY
		sta	clip2D0, y
		iny
		lda	<clipFrontY+1
		sta	clip2D0, y
		iny

		sty	<model2DClipIndexWork

		lda	transform2DWork0+4, x
		sta	polyBufferZ0Work1
		lda	transform2DWork0+5, x
		sta	polyBufferZ0Work1+1

		inc	<frontClipCount
		inc	<frontClipCount

		bra	.clipFrontJump11

.clipFrontJump8:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+1, x
		sta	clip2D0, y
		iny

		lda	transform2DWork0+2, x
		sta	clip2D0, y
		iny
		lda	transform2DWork0+3, x
		sta	clip2D0, y
		iny

		sty	<model2DClipIndexWork

		lda	transform2DWork0+4, x
		sta	polyBufferZ0Work1
		lda	transform2DWork0+5, x
		sta	polyBufferZ0Work1+1

		inc	<frontClipCount

.clipFrontJump11:
;check Z sample
		cmpw	<polyBufferZ0Work0, <polyBufferZ0Work1

		bpl	.clipFrontJump9

		movw	<polyBufferZ0Work0, <polyBufferZ0Work1

.clipFrontJump9:
		rts


;----------------------------
setModelProc:
;
		ldy	#$00
		lda	[modelAddr], y
		sta	<modelAddrWork		;ModelData Polygon Addr
		iny
		lda	[modelAddr], y
		sta	<modelAddrWork+1

		ldy	#$02
		lda	[modelAddr], y		;Polygon Count
		sta	<modelPolygonCount

		stz	<polyBufferAddrWork0	;ModelData Polygon

.setModelLoop0:
		ldy	<polyBufferAddrWork0

		lda	[modelAddrWork], y	;ModelData Vertex Count, Front Color
		and	#$F8
		lsr	a
		lsr	a
		sta	<setModelFrontColor

		lda	[modelAddrWork], y	;ModelData Vertex Count, Front Color
		and	#$07
		sta	<setModelCountWork
		sta	<setModelCount

		iny

		lda	[modelAddrWork], y	;ModelData Polygon Attr, Back Color
		sta	<setModelAttr
		and	#$F8
		lsr	a
		lsr	a
		sta	<setModelBackColor

		iny
		sty	<polyBufferAddrWork0

		stz	<polyBufferAddrWork1	;clip2D

		stz	<polyBufferZ0Work0
		stz	<polyBufferZ0Work0+1

.setModelLoop1:
		ldy	<polyBufferAddrWork0	;ModelData Polygon
		lda	[modelAddrWork], y
		tax

		ldy	<polyBufferAddrWork1

;move to clip2D0
		lda	transform2DWork0, x	;2D X0
		sta	clip2D0, y
		inx
		iny

		lda	transform2DWork0, x
		sta	clip2D0, y
		inx
		iny

		lda	transform2DWork0, x	;2D Y0
		sta	clip2D0, y
		inx
		iny

		lda	transform2DWork0, x
		sta	clip2D0, y
		inx
		iny

		sty	<polyBufferAddrWork1

		sec
		lda	transform2DWork0, x	;3D Z0
		sbc	<polyBufferZ0Work0
		inx
		lda	transform2DWork0, x

		bpl	.setModelJump4		;Z0<128 flag check

;next polygon data index
		add	<polyBufferAddrWork0, <setModelCount
		jmp	.setModelJump0

.setModelJump4:
		sbc	<polyBufferZ0Work0+1
		bmi	.setModelJump1		;3D Z0 < polyBufferZ0Work0
		dex
		lda	transform2DWork0,x	;3D Z0
		sta	<polyBufferZ0Work0
		inx
		lda	transform2DWork0,x	;3D Z0
		sta	<polyBufferZ0Work0+1

.setModelJump1:
		inc	<polyBufferAddrWork0
		dec	<setModelCount
		bne	.setModelLoop1

;call clip2D
		mov	<clip2D0Count, <setModelCountWork
		jsr	clip2D
;.setModelJump3:
		jeq	.setModelJump0

;back side check
		sec
		lda	clip2D0+8		;X2
		sbc	clip2D0+4		;X1
		sta	<mul16a
		cla
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0+2		;Y0
		sbc	clip2D0+6		;Y1
		sta	<mul16b
		cla
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		movq	<div16ans, <mul16c

		sec
		lda	clip2D0+10		;Y2
		sbc	clip2D0+6		;Y1
		sta	<mul16a
		cla
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0			;X0
		sbc	clip2D0+4		;X1
		sta	<mul16b
		cla
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		cmpq	<div16ans, <mul16c

		bpl	.setModelJump2

;back side
		bbr0	<setModelAttr, .setModelJump6
		jmp	.setModelJump0

.setModelJump6:
		lda	<setModelBackColor
		bra	.setModelJump5

.setModelJump2:
;front side
		lda	<setModelFrontColor

.setModelJump5:
		ldy	#4
		sta	[polyBufferAddr], y	;COLOR

		lda	<clip2D0Count
		ldy	#5
		sta	[polyBufferAddr], y	;COUNT

		clx
		ldy	#6
.setModelLoop2:
		lda	clip2D0, x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		lda	clip2D0, x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		dec	<clip2D0Count
		bne	.setModelLoop2

		sty	<polyBufferAddrWork2

;SAMPLE Z
		ldy	#2
		lda	<polyBufferZ0Work0	;SAMPLE Z
		sta	[polyBufferAddr], y
		iny
		lda	<polyBufferZ0Work0+1
		sta	[polyBufferAddr], y

;set buffer
		movw	<polyBufferNow, #polyBufferStart

.setBufferLoop:
		ldy	#0			;NEXT ADDR
		lda	[polyBufferNow], y
		sta	<polyBufferNext
		iny
		lda	[polyBufferNow], y
		sta	<polyBufferNext+1

		ldy	#2			;NEXT SAMPLE Z
		lda	[polyBufferNext], y
		sta	<polyBufferZ0Work0
		iny
		lda	[polyBufferNext], y
		sta	<polyBufferZ0Work0+1

		ldy	#2			;SAMPLE Z
		sec
		lda	[polyBufferAddr], y
		sbc	<polyBufferZ0Work0
		iny
		lda	[polyBufferAddr], y
		sbc	<polyBufferZ0Work0+1

		bpl	.setBufferJump		;SAMPLE Z >= NEXT SAMPLE Z

		movw	<polyBufferNow, <polyBufferNext

		bra	.setBufferLoop

.setBufferJump:
		ldy	#0			;BUFFER -> NEXT
		lda	<polyBufferNext
		sta	[polyBufferAddr], y
		iny
		lda	<polyBufferNext+1
		sta	[polyBufferAddr], y

		ldy	#0			;NOW -> BUFFER
		lda	<polyBufferAddr
		sta	[polyBufferNow], y
		iny
		lda	<polyBufferAddr+1
		sta	[polyBufferNow], y

;next buffer addr
		clc
		lda	<polyBufferAddr
		adc	<polyBufferAddrWork2
		sta	<polyBufferAddr
		bcc	.setModelJump0
		inc	<polyBufferAddr+1

;unset polygon
.setModelJump0:
;check triangle
		bbs2	<setModelCountWork, .setModelJump7
;triangle
		inc	<polyBufferAddrWork0

.setModelJump7:
		dec	<modelPolygonCount
		jne	.setModelLoop0
		rts


;----------------------------
initializePolyBuffer:
;
;initialize polyBufferAddr = polyBuffer
		movw	<polyBufferAddr, #polyBuffer

;polyBufferStart NEXT ADDR = polyBufferEnd
		movw	polyBufferStart, #polyBufferEnd

;polyBufferStart SAMPLE Z = $7FFF
		movw	polyBufferStart+2, #$7FFF

;polyBufferEnd SAMPLE Z = $0000
		stzw	polyBufferEnd+2

;polyBufferEnd COLOR = $00
		stz	polyBufferEnd+4

;polyBufferEnd COUNT = $00
		stz	polyBufferEnd+5

		rts


;----------------------------
moveMatrix1ToMatrix0:
;
		tii	matrix1, matrix0, 18
		rts


;----------------------------
moveMatrix1ToMatrix2:
;
		tii	matrix1, matrix2, 18
		rts


;----------------------------
moveMatrix2ToMatrix0:
;
		tii	matrix2, matrix0, 18
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

		lda	cosDataLow, x
		sta	matrix1+6+2
		lda	cosDataHigh, x
		sta	matrix1+6+3

		clc
		lda	sinDataLow, x
		eor	#$FF
		adc	#$01
		sta	matrix1+6+4
		lda	sinDataHigh, x
		eor	#$FF
		adc	#$00
		sta	matrix1+6+5

		stz	matrix1+12+0
		stz	matrix1+12+1

		lda	sinDataLow,x
		sta	matrix1+12+2
		lda	sinDataHigh, x
		sta	matrix1+12+3

		lda	cosDataLow,x
		sta	matrix1+12+4
		lda	cosDataHigh, x
		sta	matrix1+12+5

		rts


;----------------------------
setMatrix1RotationY:
;
		lda	cosDataLow, x
		sta	matrix1+0+0
		lda	cosDataHigh, x
		sta	matrix1+0+1

		stz	matrix1+0+2
		stz	matrix1+0+3

		lda	sinDataLow, x
		sta	matrix1+0+4
		lda	sinDataHigh, x
		sta	matrix1+0+5

		stz	matrix1+6+0
		stz	matrix1+6+1

		stz	matrix1+6+2
		lda	#$40
		sta	matrix1+6+3

		stz	matrix1+6+4
		stz	matrix1+6+5

		clc
		lda	sinDataLow, x
		eor	#$FF
		adc	#$01
		sta	matrix1+12+0
		lda	sinDataHigh, x
		eor	#$FF
		adc	#$00
		sta	matrix1+12+1

		stz	matrix1+12+2
		stz	matrix1+12+3

		lda	cosDataLow, x
		sta	matrix1+12+4
		lda	cosDataHigh, x
		sta	matrix1+12+5

		rts


;----------------------------
setMatrix1RotationZ:
;
		lda	cosDataLow, x
		sta	matrix1+0+0
		lda	cosDataHigh, x
		sta	matrix1+0+1

		clc
		lda	sinDataLow, x
		eor	#$FF
		adc	#$01
		sta	matrix1+0+2
		lda	sinDataHigh, x
		eor	#$FF
		adc	#$00
		sta	matrix1+0+3

		stz	matrix1+0+4
		stz	matrix1+0+5

		lda	sinDataLow, x
		sta	matrix1+6+0
		lda	sinDataHigh, x
		sta	matrix1+6+1

		lda	cosDataLow, x
		sta	matrix1+6+2
		lda	cosDataHigh, x
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

		clc
		lda	<vertex0Addr
		adc	#$06
		sta	<vertex0Addr
		bcc	.vertexTranslationJump00
		inc	<vertex0Addr+1
.vertexTranslationJump00:

		clc
		lda	<vertex1Addr
		adc	#$06
		sta	<vertex1Addr
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
		stz	<vertexWork
		stz	<vertexWork+1
		stz	<vertexWork+2
		stz	<vertexWork+3

		cly

.vertexMultiplyLoop0:
		lda	[vertex0Addr], y
		sta	<mul16a
		iny
		lda	[vertex0Addr], y
		sta	<mul16a+1
		iny

		lda	matrix2, x
		sta	<mul16b
		inx
		lda	matrix2, x
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

		clc
		lda	<vertex0Addr
		adc	#$06
		sta	<vertex0Addr
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

		lda	matrix0, x
		sta	<mul16a
		lda	matrix0+1, x
		sta	<mul16a+1

		lda	matrix1, y
		sta	<mul16b
		lda	matrix1+1, y
		sta	<mul16b+1

		jsr	smul16

		movq	<vertexWork, <mul16c

;----------------
		lda	matrix0+6, x
		sta	<mul16a
		lda	matrix0+7, x
		sta	<mul16a+1

		lda	matrix1+2, y
		sta	<mul16b
		lda	matrix1+3, y
		sta	<mul16b+1

		jsr	smul16

		addq	<vertexWork, <mul16c, <vertexWork

;----------------
		lda	matrix0+12, x
		sta	<mul16a
		lda	matrix0+13, x
		sta	<mul16a+1

		lda	matrix1+4, y
		sta	<mul16b
		lda	matrix1+5, y
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
		sta	matrix2, x
		inx
		lda	<vertexWork+3
		sta	matrix2, x
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
		lda	[vertex0Addr], y
		sbc	#128
		iny
		lda	[vertex0Addr], y
		sbc	#00

		jmi	.transform2DJump00

;X0 to mul16c
		ldy	#$00
		lda	[vertex0Addr], y
		sta	<mul16c
		iny
		lda	[vertex0Addr], y
		sta	<mul16c+1

;Z0 to mul16a
		ldy	#$04
		lda	[vertex0Addr], y
		sta	<mul16a
		iny
		lda	[vertex0Addr], y
		sta	<mul16a+1

;X0*128/Z0
		jsr	transform2DProc

;X0*128/Z0+centerX
;mul16a+centerX to vertex1Addr X0

		ldy	#$00
		clc
		lda	<mul16a
		adc	<centerX
		sta	[vertex1Addr], y
		iny
		lda	<mul16a+1
		adc	<centerX+1
		sta	[vertex1Addr], y

;Y0 to mul16c
		ldy	#$02
		lda	[vertex0Addr], y
		sta	<mul16c
		iny
		lda	[vertex0Addr], y
		sta	<mul16c+1

;Z0 to mul16a
		ldy	#$04
		lda	[vertex0Addr], y
		sta	<mul16a
		iny
		lda	[vertex0Addr], y
		sta	<mul16a+1

;Y0*128/Z0
		jsr	transform2DProc

;Y0*128/Z0+centerY
;mul16a+centerY to vertex1Addr Y0

		ldy	#$02
		clc
		lda	<mul16a
		adc	<centerY
		sta	[vertex1Addr], y
		iny
		lda	<mul16a+1
		adc	<centerY+1
		sta	[vertex1Addr], y

;Z0>=128 flag set
;Z0 set
		iny
		lda	[vertex0Addr], y
		sta	[vertex1Addr], y
		iny
		lda	[vertex0Addr], y
		sta	[vertex1Addr], y

		jmp	.transform2DJump01

.transform2DJump00:
;Z0<128 flag set
		ldy	#$04
		lda	#$00
		sta	[vertex1Addr], y
		iny
		lda	#$80
		sta	[vertex1Addr], y

.transform2DJump01:
		addwb	<vertex0Addr, #$06

		addwb	<vertex1Addr, #$06

		dec	<vertexCount
		jne	.transform2DLoop0

		rts


;----------------------------
transform2DProc:
;mul16a(rough value) = (mul16c(-32768_32767) * 128 / mul16a(1_32767))
;push y
		phy
;c sign
		lda	<mul16c+1
		pha
		bpl	.jp00
;c neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1
.jp00:
		stz	<muladdr

;get div data
		ldy	<div16a+1
		clc
		lda	mulbankdata, y
		adc	#divdatBank-muldatBank	;carry clear
		sta	<mulbank
		tam	#$02

		lda	muladdrdata, y
		sta	<muladdr+1

		ldy	<div16a

		lda	[muladdr], y
		sta	<sqrt64a

		lda	<mulbank
		adc	#4		;carry clear
		tam	#$02

		lda	[muladdr], y
		sta	<sqrt64a+1

		lda	<mulbank
		adc	#8		;carry clear
		tam	#$02

		lda	[muladdr], y
		sta	<sqrt64a+2

;mul mul16c low byte
		ldy	<mul16c
		lda	mulbankdata, y

		sta	<mulbank
		tam	#$02

		lda	muladdrdata, y
		sta	<muladdr+1

		ldy	<sqrt64a
		lda	[muladdr], y
		sta	<sqrt64b

		ldy	<sqrt64a+1
		lda	[muladdr], y
		sta	<sqrt64b+1

		ldy	<sqrt64a+2
		lda	[muladdr], y
		sta	<sqrt64b+2

		lda	<mulbank
		adc	#8		;carry clear
		tam	#$02

		ldy	<sqrt64a
		lda	[muladdr], y
		adc	<sqrt64b+1
		sta	<sqrt64b+1

		ldy	<sqrt64a+1
		lda	[muladdr], y
		adc	<sqrt64b+2
		sta	<sqrt64b+2

		ldy	<sqrt64a+2
		lda	[muladdr], y
		adc	#0		;carry clear
		sta	<sqrt64b+3

;mul mul16c high byte
		ldy	<mul16c+1
		lda	mulbankdata, y

		sta	<mulbank
		tam	#$02

		lda	muladdrdata, y
		sta	<muladdr+1

		ldy	<sqrt64a
		lda	[muladdr], y
		adc	<sqrt64b+1
		sta	<sqrt64b+1

		ldy	<sqrt64a+1
		lda	[muladdr], y
		adc	<sqrt64b+2
		sta	<sqrt64b+2

		ldy	<sqrt64a+2
		lda	[muladdr], y
		adc	<sqrt64b+3	;carry clear
		sta	<sqrt64b+3

		lda	<mulbank
		adc	#8		;carry clear
		tam	#$02

		ldy	<sqrt64a
		lda	[muladdr], y
		adc	<sqrt64b+2
		sta	<sqrt64b+2

		ldy	<sqrt64a+1
		lda	[muladdr], y
		adc	<sqrt64b+3
		sta	<sqrt64b+3

		movw	<mul16a, <sqrt64b+2

		pla
		bpl	.jp01
;ans neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1
.jp01:
;pull y
		ply
		rts


;----------------------------
clip2D:
;
		clx
		ldy	<clip2D0Count
.loop0:
		lda	clip2D0+1, x
		bne	.clipOut

		lda	clip2D0+3, x
		bne	.clipOut

		lda	clip2D0+2, x
		cmp	#192
		bcs	.clipOut

		inx
		inx
		inx
		inx

		dey
		bne	.loop0

		lda	<clip2D0Count
		rts

.clipOut:
		jsr	clip2DY0
		lda	<clip2D1Count
		beq	.clip2DEnd

		jsr	clip2DY255
		lda	<clip2D0Count
		beq	.clip2DEnd

		jsr	clip2DX0
		lda	<clip2D1Count
		beq	.clip2DEnd

		jsr	clip2DX255
		lda	<clip2D0Count

.clip2DEnd:
		rts


;----------------------------
clip2DX255:
;
		lda	<clip2D1Count
		asl	a
		asl	a
		tax

		lda	clip2D1		;X0
		sta	clip2D1, x	;last X
		lda	clip2D1+1
		sta	clip2D1+1, x

		lda	clip2D1+2	;Y0
		sta	clip2D1+2, x	;last Y
		lda	clip2D1+3
		sta	clip2D1+3, x

		clx
		cly
		stz	<clip2D0Count

.clip2DX255Loop0:
		stz	<clip2DFlag

		sec
		lda	clip2D1, x	;X0
		sbc	#$00
		lda	clip2D1+1, x
		sbc	#$01
		bmi	.clip2DX255Jump00
		smb0	<clip2DFlag
.clip2DX255Jump00:

		sec
		lda	clip2D1+4, x	;X1
		sbc	#$00
		lda	clip2D1+5, x
		sbc	#$01
		bmi	.clip2DX255Jump01
		smb1	<clip2DFlag
.clip2DX255Jump01:

		lda	<clip2DFlag
		jeq	.clip2DX255Jump02

		cmp	#$03
		jeq	.clip2DX255Jump03

;(255-X0) to mul16a
		sec
		lda	#255
		sbc	clip2D1, x	;X0
		sta	<mul16a
		lda	#0
		sbc	clip2D1+1, x
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D1+6, x	;Y1
		sbc	clip2D1+2, x	;Y0
		sta	<mul16b
		lda	clip2D1+7, x
		sbc	clip2D1+3, x
		sta	<mul16b+1

;(255-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D1+4, x	;X1
		sbc	clip2D1, x	;X0
		sta	<mul16a
		lda	clip2D1+5, x
		sbc	clip2D1+1, x
		sta	<mul16a+1

;(255-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(255-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D1+2, x	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+3, x
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DX255Jump04
;X0>255 X1<=255
		lda	#$FF
		sta	clip2D0, y	;X0
		lda	#$00
		sta	clip2D0+1, y

		lda	<mul16a
		sta	clip2D0+2, y	;Y0
		lda	<mul16a+1
		sta	clip2D0+3, y

		inc	<clip2D0Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DX255Jump03

.clip2DX255Jump04:
;X0<=255 X1>255
		lda	clip2D1, x	;X0
		sta	clip2D0, y	;X0
		lda	clip2D1+1, x
		sta	clip2D0+1, y

		lda	clip2D1+2, x	;Y0
		sta	clip2D0+2, y	;Y0
		lda	clip2D1+3, x
		sta	clip2D0+3, y

		lda	#$FF
		sta	clip2D0+4, y	;X1
		lda	#$00
		sta	clip2D0+5, y

		lda	<mul16a
		sta	clip2D0+6, y	;Y1
		lda	<mul16a+1
		sta	clip2D0+7, y

		add	<clip2D0Count, #$02

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DX255Jump03

.clip2DX255Jump02:
;X0<=255 X1<=255
		lda	clip2D1, x	;X0
		sta	clip2D0, y	;X0
		lda	clip2D1+1, x
		sta	clip2D0+1, y

		lda	clip2D1+2, x	;Y0
		sta	clip2D0+2, y	;Y0
		lda	clip2D1+3, x
		sta	clip2D0+3, y

		inc	<clip2D0Count

		clc
		tya
		adc	#$04
		tay

.clip2DX255Jump03:
;X0>255 X1>255
		clc
		txa
		adc	#$04
		tax

		dec	<clip2D1Count
		jne	.clip2DX255Loop0

		rts


;----------------------------
clip2DX0:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax

		lda	clip2D0		;X0
		sta	clip2D0, x	;last X
		lda	clip2D0+1
		sta	clip2D0+1, x

		lda	clip2D0+2	;Y0
		sta	clip2D0+2, x	;last Y
		lda	clip2D0+3
		sta	clip2D0+3, x

		clx
		cly
		stz	<clip2D1Count

.clip2DX0Loop0:
		stz	<clip2DFlag

		lda	clip2D0+1,x	;X0
		bpl	.clip2DX0Jump00
		smb0	<clip2DFlag
.clip2DX0Jump00:

		lda	clip2D0+5,x	;X1
		bpl	.clip2DX0Jump01
		smb1	<clip2DFlag
.clip2DX0Jump01:

		lda	<clip2DFlag
		jeq	.clip2DX0Jump02

		cmp	#$03
		jeq	.clip2DX0Jump03

;(0-X0) to mul16a
		sec
		lda	#0
		sbc	clip2D0, x	;X0
		sta	<mul16a
		lda	#0
		sbc	clip2D0+1, x
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D0+6, x	;Y1
		sbc	clip2D0+2, x	;Y0
		sta	<mul16b
		lda	clip2D0+7, x
		sbc	clip2D0+3, x
		sta	<mul16b+1

;(0-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D0+4, x	;X1
		sbc	clip2D0, x	;X0
		sta	<mul16a
		lda	clip2D0+5, x
		sbc	clip2D0+1, x
		sta	<mul16a+1

;(0-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(0-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D0+2, x	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+3, x
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DX0Jump04
;X0<0 X1>=0
		lda	#$00
		sta	clip2D1, y	;X0
		lda	#$00
		sta	clip2D1+1, y

		lda	<mul16a
		sta	clip2D1+2, y	;Y0
		lda	<mul16a+1
		sta	clip2D1+3, y

		inc	<clip2D1Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DX0Jump03

.clip2DX0Jump04:
;X0>=0 X1<0
		lda	clip2D0, x	;X0
		sta	clip2D1, y	;X0
		lda	clip2D0+1, x
		sta	clip2D1+1, y

		lda	clip2D0+2, x	;Y0
		sta	clip2D1+2, y	;Y0
		lda	clip2D0+3, x
		sta	clip2D1+3, y

		lda	#$00
		sta	clip2D1+4, y	;X1
		lda	#$00
		sta	clip2D1+5, y

		lda	<mul16a
		sta	clip2D1+6, y	;Y1
		lda	<mul16a+1
		sta	clip2D1+7, y

		add	<clip2D1Count, #$02

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DX0Jump03

.clip2DX0Jump02:
;X0>=0 X1>=0
		lda	clip2D0, x	;X0
		sta	clip2D1, y	;X0
		lda	clip2D0+1, x
		sta	clip2D1+1, y

		lda	clip2D0+2, x	;Y0
		sta	clip2D1+2, y	;Y0
		lda	clip2D0+3, x
		sta	clip2D1+3, y

		inc	<clip2D1Count

		clc
		tya
		adc	#$04
		tay

.clip2DX0Jump03:
;X0<0 X1<0
		clc
		txa
		adc	#$04
		tax

		dec	<clip2D0Count
		jne	.clip2DX0Loop0

		rts


;----------------------------
clip2DY255:
;
		lda	<clip2D1Count
		asl	a
		asl	a
		tax

		lda	clip2D1		;X0
		sta	clip2D1, x	;last X
		lda	clip2D1+1
		sta	clip2D1+1, x

		lda	clip2D1+2	;Y0
		sta	clip2D1+2, x	;last Y
		lda	clip2D1+3
		sta	clip2D1+3, x

		clx
		cly
		stz	<clip2D0Count

.clip2DY255Loop0:
		stz	<clip2DFlag

		sec
		lda	clip2D1+2, x	;Y0
		sbc	#192
		lda	clip2D1+3, x
		sbc	#0
		bmi	.clip2DY255Jump00
		smb0	<clip2DFlag
.clip2DY255Jump00:

		sec
		lda	clip2D1+6, x	;Y1
		sbc	#192
		lda	clip2D1+7, x
		sbc	#0
		bmi	.clip2DY255Jump01
		smb1	<clip2DFlag
.clip2DY255Jump01:

		lda	<clip2DFlag
		jeq	.clip2DY255Jump02

		cmp	#$03
		jeq	.clip2DY255Jump03
.
;(191-Y0) to mul16a
		sec
		lda	#191
		sbc	clip2D1+2, x	;Y0
		sta	<mul16a
		lda	#0
		sbc	clip2D1+3, x
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D1+4, x	;X1
		sbc	clip2D1, x	;X0
		sta	<mul16b
		lda	clip2D1+5, x
		sbc	clip2D1+1, x
		sta	<mul16b+1

;(191-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D1+6, x	;Y1
		sbc	clip2D1+2, x	;Y0
		sta	<mul16a
		lda	clip2D1+7, x
		sbc	clip2D1+3, x
		sta	<mul16a+1

;(191-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(191-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D1, x	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+1, x
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DY255Jump04
;Y0>191 Y1<=191
		lda	<mul16a
		sta	clip2D0, y	;X0
		lda	<mul16a+1
		sta	clip2D0+1, y

		lda	#191
		sta	clip2D0+2, y	;Y0
		lda	#0
		sta	clip2D0+3, y

		inc	<clip2D0Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DY255Jump03

.clip2DY255Jump04:
;Y0<=191 Y1>191
		lda	clip2D1, x	;X0
		sta	clip2D0, y	;X0
		lda	clip2D1+1, x
		sta	clip2D0+1, y

		lda	clip2D1+2, x	;Y0
		sta	clip2D0+2, y	;Y0
		lda	clip2D1+3, x
		sta	clip2D0+3, y

		lda	<mul16a
		sta	clip2D0+4, y	;X1
		lda	<mul16a+1
		sta	clip2D0+5, y

		lda	#191
		sta	clip2D0+6, y	;Y1
		lda	#0
		sta	clip2D0+7, y

		add	<clip2D0Count, #$02

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DY255Jump03

.clip2DY255Jump02:
;Y0<=191 Y1<=191
		lda	clip2D1, x	;X0
		sta	clip2D0, y	;X0
		lda	clip2D1+1, x
		sta	clip2D0+1, y

		lda	clip2D1+2, x	;Y0
		sta	clip2D0+2, y	;Y0
		lda	clip2D1+3, x
		sta	clip2D0+3, y

		inc	<clip2D0Count

		clc
		tya
		adc	#$04
		tay

.clip2DY255Jump03:
;Y0>191 Y1>191
		clc
		txa
		adc	#$04
		tax

		dec	<clip2D1Count
		jne	.clip2DY255Loop0

		rts


;----------------------------
clip2DY0:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax

		lda	clip2D0		;X0
		sta	clip2D0, x	;last X
		lda	clip2D0+1
		sta	clip2D0+1, x

		lda	clip2D0+2	;Y0
		sta	clip2D0+2, x	;last Y
		lda	clip2D0+3
		sta	clip2D0+3, x

		clx
		cly
		stz	<clip2D1Count

.clip2DY0Loop0:
		stz	<clip2DFlag

		lda	clip2D0+3, x	;Y0
		bpl	.clip2DY0Jump00
		smb0	<clip2DFlag
.clip2DY0Jump00:

		lda	clip2D0+7, x	;Y1
		bpl	.clip2DY0Jump01
		smb1	<clip2DFlag
.clip2DY0Jump01:

		lda	<clip2DFlag
		jeq	.clip2DY0Jump02

		cmp	#$03
		jeq	.clip2DY0Jump03
.
;(0-Y0) to mul16a
		sec
		lda	#0
		sbc	clip2D0+2, x	;Y0
		sta	<mul16a
		lda	#0
		sbc	clip2D0+3, x
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D0+4, x	;X1
		sbc	clip2D0, x	;X0
		sta	<mul16b
		lda	clip2D0+5, x
		sbc	clip2D0+1, x
		sta	<mul16b+1

;(0-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D0+6, x	;Y1
		sbc	clip2D0+2, x	;Y0
		sta	<mul16a
		lda	clip2D0+7, x
		sbc	clip2D0+3, x
		sta	<mul16a+1

;(0-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(0-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D0, x	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+1, x
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DY0Jump04
;Y0<0 Y1>=0
		lda	<mul16a
		sta	clip2D1, y	;X0
		lda	<mul16a+1
		sta	clip2D1+1, y

		lda	#$00
		sta	clip2D1+2, y	;Y0
		lda	#$00
		sta	clip2D1+3, y

		inc	<clip2D1Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DY0Jump03

.clip2DY0Jump04:
;Y0>=0 Y1<0
		lda	clip2D0, x	;X0
		sta	clip2D1, y	;X0
		lda	clip2D0+1, x
		sta	clip2D1+1, y

		lda	clip2D0+2, x	;Y0
		sta	clip2D1+2, y	;Y0
		lda	clip2D0+3, x
		sta	clip2D1+3, y

		lda	<mul16a
		sta	clip2D1+4, y	;X1
		lda	<mul16a+1
		sta	clip2D1+5, y

		lda	#$00
		sta	clip2D1+6, y	;Y1
		lda	#$00
		sta	clip2D1+7, y

		add	<clip2D1Count, #$02

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DY0Jump03

.clip2DY0Jump02:
;Y0>=0 Y1>=0
		lda	clip2D0, x	;X0
		sta	clip2D1, y	;X0
		lda	clip2D0+1, x
		sta	clip2D1+1, y

		lda	clip2D0+2, x	;Y0
		sta	clip2D1+2, y	;Y0
		lda	clip2D0+3, x
		sta	clip2D1+3, y

		inc	<clip2D1Count

		clc
		tya
		adc	#$04
		tay

.clip2DY0Jump03:
;Y0<0 Y1<0
		clc
		txa
		adc	#$04
		tax

		dec	<clip2D0Count
		jne	.clip2DY0Loop0

		rts


;----------------------------
calcEdge_putPoly:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax
		lda	clip2D0
		sta	clip2D0, x
		lda	clip2D0+2
		sta	clip2D0+2, x

		mov	<minEdgeY, #$FF

		jsr	initCalcEdge

		clx

.calcEdge_putPolyLoop0:
		lda	clip2D0, x
		sta	<edgeX0
		lda	clip2D0+2, x
		sta	<edgeY0

		cmp	<minEdgeY
		jcs	.calcEdge_putPolyJump2
		sta	<minEdgeY

.calcEdge_putPolyJump2:
		lda	clip2D0+4, x
		sta	<edgeX1
		lda	clip2D0+6, x
		sta	<edgeY1

		phx
		jsr	calcEdge
		plx

		inx
		inx
		inx
		inx

		dec	<clip2D0Count
		bne	.calcEdge_putPolyLoop0

		jsr	putPolyLine
		rts


;----------------------------
calcEdge:
;calculation edge Y
		sec
		lda	<edgeY1
		sbc	<edgeY0
		beq	.edgeJump6

		sta	<edgeSlopeY
		jcs	.edgeJump7

		eor	#$FF
		inc	a
		sta	<edgeSlopeY

;edgeY0 > edgeY1 exchange X0<->X1 Y0<->Y1
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
		ldy	<edgeX0
		ldx	<edgeY0

		setEdgeBufferm
		ldy	<edgeX1
		setEdgeBufferm
		rts

.edgeJump7:
;calculation edge X
		sec
		lda	<edgeX1
		sbc	<edgeX0
		beq	.edgeJump1

		sta	<edgeSlopeX
		stz	<edgeSigneX
		bcs	.edgeJump3

		eor	#$FF
		inc	a
		sta	<edgeSlopeX

		mov	<edgeSigneX, #$FF

		bra	.edgeJump3

.edgeJump1:
;edgeX0 = edgeX1
		ldy	<edgeX0
		ldx	<edgeY0
.edgeLoop0:
		setEdgeBufferm
		cpx	<edgeY1
		beq	.edgeJump9
		inx
		bra	.edgeLoop0
.edgeJump9:
		rts

.edgeJump3:
;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		jcs	.edgeJump4

;edgeSlopeX > edgeSlopeY
;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10

;edgeSigneX plus
		ldy	<edgeX0
		ldx	<edgeY0
.edgeXLoop0:
		pha
		setEdgeBufferm
		pla
.edgeXLoop1:
		cpy	<edgeX1
		beq	.edgeXLoop3

		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop1

		sbc	<edgeSlopeX
		inx
		bra	.edgeXLoop0
.edgeXLoop3:
		rts

;edgeSigneX minus
.edgeJump10:
		ldy	<edgeX1
		ldx	<edgeY1

.edgeXLoop4:
		pha
		setEdgeBufferm
		pla
.edgeXLoop5:
		cpy	<edgeX0
		beq	.edgeXLoop7

		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop5

		sbc	<edgeSlopeX
		dex
		bra	.edgeXLoop4
.edgeXLoop7:
		rts

.edgeJump4:
;edgeSlopeY >= edgeSlopeX
;edgeSlope initialize
		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldy	<edgeX0
		ldx	<edgeY0

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop4

;edgeSigneX plus
.edgeYLoop0:
		pha
		setEdgeBufferm
		pla
.edgeYLoop1:
		cpx	<edgeY1
		beq	.edgeYLoop3

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop0

		sbc	<edgeSlopeY
		iny
		bra	.edgeYLoop0
.edgeYLoop3:
		rts

;edgeSigneX minus
.edgeYLoop4:
		pha
		setEdgeBufferm
		pla
.edgeYLoop5:
		cpx	<edgeY1
		beq	.edgeYLoop7

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop4

		sbc	<edgeSlopeY
		dey
		bra	.edgeYLoop4
.edgeYLoop7:
		rts


;----------------------------
initCalcEdge:
;initialize calculation edge
		lda	#$FF
		sta	edgeCount
		tii	edgeCount, edgeCount+1, 192

		rts


;----------------------------
putPolyLine:
;put poly line
		ldy	<minEdgeY
		bra	.loopStart
;loop
.loop0:
		cli

		iny

.loopStart:	lda	edgeCount, y
		bpl	.putPolyProc
		rts

.putPolyProc:
		sei

;set poly color
		tya
		and	#$01
		ora	<polyLineColorNo
		tax

		lda	polyLineColorData0, x
		sta	<polyLineColorDataWork0

		lda	polyLineColorData1, x
		sta	<polyLineColorDataWork1

		lda	polyLineColorData2, x
		sta	<polyLineColorDataWork2

		lda	polyLineColorData3, x
		sta	<polyLineColorDataWork3

;calation vram address
;left
;left address
		ldx	edgeLeft,y
		lda	polyLineAddrConvYLow0, y
		ora	polyLineAddrConvXLow0, x
		sta	<polyLineLeftAddr

		lda	polyLineAddrConvYHigh0, y
		ora	polyLineAddrConvXHigh0, x
		sta	<polyLineLeftAddr+1

		lda	polyLineAddrConvX, x
		sta	<polyLineCount

		lda	polyLineLeftDatas, x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;right
		ldx	edgeRight,y

;calation counts
		sec
		lda	polyLineAddrConvX, x
		sbc	<polyLineCount

;count 0
		jeq	.polyLineJump03

		sta	<polyLineCount

;right address
		lda	polyLineAddrConvYLow0, y
		ora	polyLineAddrConvXLow0, x
		sta	<polyLineRightAddr

		lda	polyLineAddrConvYHigh0, y
		ora	polyLineAddrConvXHigh0, x
		sta	<polyLineRightAddr+1

		lda	polyLineRightDatas, x
		sta	<polyLineRightData
		eor	#$FF
		sta	<polyLineRightMask

;put line
		lda	<selectVdc
		cmp	#VDC2
		jeq	.vdc2Jp

;VDC1
.vdc1Jp:
		stz	VPC_6		;select VDC#1

;center jump index
		lda	<polyLineCount
		asl	a
		tax

		phy

;VDC1 left 0 1
		lda	<polyLineLeftAddr
		ldy	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC1_2
		sty	VDC1_3

		st0	#$01
		sta	VDC1_2
		sty	VDC1_3

		st0	#$02

		lda	VDC1_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC1_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC1_2

		lda	<polyLineColorDataWork1
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC1_3

;VDC1 center 0 1
		lda	<polyLineColorDataWork0
		ldy	<polyLineColorDataWork1

		jmp	[.centerVDC1_01Addr, x]
.centerVDC1_01:
		putPolyLineV1lm

;VDC1 right 0 1
		lda	<polyLineRightAddr
		ldy	<polyLineRightAddr+1
		st0	#$00
		sta	VDC1_2
		sty	VDC1_3

		st0	#$01
		sta	VDC1_2
		sty	VDC1_3

		st0	#$02

		lda	VDC1_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC1_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC1_2

		lda	<polyLineColorDataWork1
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC1_3

;VDC1 left 2 3
		lda	<polyLineLeftAddr
		ora	#$08
		ldy	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC1_2
		sty	VDC1_3

		st0	#$01
		sta	VDC1_2
		sty	VDC1_3

		st0	#$02

		lda	VDC1_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC1_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC1_2

		lda	<polyLineColorDataWork3
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC1_3

;VDC1 center 2 3
		lda	<polyLineColorDataWork2
		ldy	<polyLineColorDataWork3
		jmp	[.centerVDC1_02Addr, x]
.centerVDC1_02:
		putPolyLineV1lm

;VDC1 right 2 3
		lda	<polyLineRightAddr
		ora	#$08
		ldy	<polyLineRightAddr+1
		st0	#$00
		sta	VDC1_2
		sty	VDC1_3

		st0	#$01
		sta	VDC1_2
		sty	VDC1_3

		st0	#$02

		lda	VDC1_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC1_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC1_2

		lda	<polyLineColorDataWork3
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC1_3

		ply

;loop jump
		jmp	.loop0

;VDC2
.vdc2Jp:
		lda	#$01
		sta	VPC_6		;select VDC#2

		lda	<polyLineCount
		asl	a
		tax

		phy

;VDC2 left 0 1
		lda	<polyLineLeftAddr
		ldy	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC2_2
		sty	VDC2_3

		st0	#$01
		sta	VDC2_2
		sty	VDC2_3

		st0	#$02

		lda	VDC2_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC2_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC2_2

		lda	<polyLineColorDataWork1
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC2_3

;VDC2 center 0 1
		lda	<polyLineColorDataWork0
		ldy	<polyLineColorDataWork1
		jmp	[.centerVDC2_01Addr, x]
.centerVDC2_01:
		putPolyLineV2lm

;VDC2 right 0 1
		lda	<polyLineRightAddr
		ldy	<polyLineRightAddr+1
		st0	#$00
		sta	VDC2_2
		sty	VDC2_3

		st0	#$01
		sta	VDC2_2
		sty	VDC2_3

		st0	#$02

		lda	VDC2_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC2_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC2_2

		lda	<polyLineColorDataWork1
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC2_3

;VDC2 left 2 3
		lda	<polyLineLeftAddr
		ora	#$08
		ldy	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC2_2
		sty	VDC2_3

		st0	#$01
		sta	VDC2_2
		sty	VDC2_3

		st0	#$02

		lda	VDC2_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC2_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC2_2

		lda	<polyLineColorDataWork3
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC2_3

;VDC2 center 2 3
		lda	<polyLineColorDataWork2
		ldy	<polyLineColorDataWork3
		jmp	[.centerVDC2_02Addr, x]
.centerVDC2_02:
		putPolyLineV2lm

;VDC2 right 2 3
		lda	<polyLineRightAddr
		ora	#$08
		ldy	<polyLineRightAddr+1
		st0	#$00
		sta	VDC2_2
		sty	VDC2_3

		st0	#$01
		sta	VDC2_2
		sty	VDC2_3

		st0	#$02

		lda	VDC2_2
		and	<polyLineRightMask
		sta	<polyLineDataLow

		lda	VDC2_3
		and	<polyLineRightMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineRightData
		ora	<polyLineDataLow
		sta	VDC2_2

		lda	<polyLineColorDataWork3
		and	<polyLineRightData
		ora	<polyLineDataHigh
		sta	VDC2_3

		ply

;loop jump
		jmp	.loop0

;put line same address
.polyLineJump03:
		lda	<polyLineLeftData
		and	polyLineRightDatas,x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

		lda	<selectVdc
		cmp	#VDC2
		beq	.vdc2Jp2

;VDC1
.vdc1Jp2:
		stz	VPC_6		;select VDC#1

;VDC1 left 0 1
		lda	<polyLineLeftAddr
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC1_2
		stx	VDC1_3

		st0	#$01
		sta	VDC1_2
		stx	VDC1_3

		st0	#$02

		lda	VDC1_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC1_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC1_2

		lda	<polyLineColorDataWork1
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC1_3

;VDC1 left 2 3
		lda	<polyLineLeftAddr
		ora	#$08
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC1_2
		stx	VDC1_3

		st0	#$01
		sta	VDC1_2
		stx	VDC1_3

		st0	#$02

		lda	VDC1_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC1_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC1_2

		lda	<polyLineColorDataWork3
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC1_3

;loop jump
		jmp	.loop0

;VDC2
.vdc2Jp2:
		lda	#$01
		sta	VPC_6		;select VDC#2

;VDC2 left 0 1
		lda	<polyLineLeftAddr
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC2_2
		stx	VDC2_3

		st0	#$01
		sta	VDC2_2
		stx	VDC2_3

		st0	#$02

		lda	VDC2_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC2_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork0
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC2_2

		lda	<polyLineColorDataWork1
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC2_3

;VDC2 left 2 3
		lda	<polyLineLeftAddr
		ora	#$08
		ldx	<polyLineLeftAddr+1
		st0	#$00
		sta	VDC2_2
		stx	VDC2_3

		st0	#$01
		sta	VDC2_2
		stx	VDC2_3

		st0	#$02

		lda	VDC2_2
		and	<polyLineLeftMask
		sta	<polyLineDataLow

		lda	VDC2_3
		and	<polyLineLeftMask
		sta	<polyLineDataHigh

		lda	<polyLineColorDataWork2
		and	<polyLineLeftData
		ora	<polyLineDataLow
		sta	VDC2_2

		lda	<polyLineColorDataWork3
		and	<polyLineLeftData
		ora	<polyLineDataHigh
		sta	VDC2_3

;loop jump
		jmp	.loop0

;--------
.centerVDC1_01Addr:
			dw	.centerVDC1_01 +6*30	;-1
			dw	.centerVDC1_01 +6*30	;0

			dw	.centerVDC1_01 +6*29	;1
			dw	.centerVDC1_01 +6*28	;2
			dw	.centerVDC1_01 +6*27	;3
			dw	.centerVDC1_01 +6*26	;4
			dw	.centerVDC1_01 +6*25	;5
			dw	.centerVDC1_01 +6*24	;6
			dw	.centerVDC1_01 +6*23	;7
			dw	.centerVDC1_01 +6*22	;8
			dw	.centerVDC1_01 +6*21	;9

			dw	.centerVDC1_01 +6*20	;10
			dw	.centerVDC1_01 +6*19	;11
			dw	.centerVDC1_01 +6*18	;12
			dw	.centerVDC1_01 +6*17	;13
			dw	.centerVDC1_01 +6*16	;14
			dw	.centerVDC1_01 +6*15	;15
			dw	.centerVDC1_01 +6*14	;16
			dw	.centerVDC1_01 +6*13	;17
			dw	.centerVDC1_01 +6*12	;18
			dw	.centerVDC1_01 +6*11	;19

			dw	.centerVDC1_01 +6*10	;20
			dw	.centerVDC1_01 +6*9	;21
			dw	.centerVDC1_01 +6*8	;22
			dw	.centerVDC1_01 +6*7	;23
			dw	.centerVDC1_01 +6*6	;24
			dw	.centerVDC1_01 +6*5	;25
			dw	.centerVDC1_01 +6*4	;26
			dw	.centerVDC1_01 +6*3	;27
			dw	.centerVDC1_01 +6*2	;28
			dw	.centerVDC1_01 +6*1	;29

			dw	.centerVDC1_01 +6*0	;30

;--------
.centerVDC1_02Addr:
			dw	.centerVDC1_02 +6*30	;-1
			dw	.centerVDC1_02 +6*30	;0

			dw	.centerVDC1_02 +6*29	;1
			dw	.centerVDC1_02 +6*28	;2
			dw	.centerVDC1_02 +6*27	;3
			dw	.centerVDC1_02 +6*26	;4
			dw	.centerVDC1_02 +6*25	;5
			dw	.centerVDC1_02 +6*24	;6
			dw	.centerVDC1_02 +6*23	;7
			dw	.centerVDC1_02 +6*22	;8
			dw	.centerVDC1_02 +6*21	;9

			dw	.centerVDC1_02 +6*20	;10
			dw	.centerVDC1_02 +6*19	;11
			dw	.centerVDC1_02 +6*18	;12
			dw	.centerVDC1_02 +6*17	;13
			dw	.centerVDC1_02 +6*16	;14
			dw	.centerVDC1_02 +6*15	;15
			dw	.centerVDC1_02 +6*14	;16
			dw	.centerVDC1_02 +6*13	;17
			dw	.centerVDC1_02 +6*12	;18
			dw	.centerVDC1_02 +6*11	;19

			dw	.centerVDC1_02 +6*10	;20
			dw	.centerVDC1_02 +6*9	;21
			dw	.centerVDC1_02 +6*8	;22
			dw	.centerVDC1_02 +6*7	;23
			dw	.centerVDC1_02 +6*6	;24
			dw	.centerVDC1_02 +6*5	;25
			dw	.centerVDC1_02 +6*4	;26
			dw	.centerVDC1_02 +6*3	;27
			dw	.centerVDC1_02 +6*2	;28
			dw	.centerVDC1_02 +6*1	;29

			dw	.centerVDC1_02 +6*0	;30

;--------
.centerVDC2_01Addr:
			dw	.centerVDC2_01 +6*30	;-1
			dw	.centerVDC2_01 +6*30	;0

			dw	.centerVDC2_01 +6*29	;1
			dw	.centerVDC2_01 +6*28	;2
			dw	.centerVDC2_01 +6*27	;3
			dw	.centerVDC2_01 +6*26	;4
			dw	.centerVDC2_01 +6*25	;5
			dw	.centerVDC2_01 +6*24	;6
			dw	.centerVDC2_01 +6*23	;7
			dw	.centerVDC2_01 +6*22	;8
			dw	.centerVDC2_01 +6*21	;9

			dw	.centerVDC2_01 +6*20	;10
			dw	.centerVDC2_01 +6*19	;11
			dw	.centerVDC2_01 +6*18	;12
			dw	.centerVDC2_01 +6*17	;13
			dw	.centerVDC2_01 +6*16	;14
			dw	.centerVDC2_01 +6*15	;15
			dw	.centerVDC2_01 +6*14	;16
			dw	.centerVDC2_01 +6*13	;17
			dw	.centerVDC2_01 +6*12	;18
			dw	.centerVDC2_01 +6*11	;19

			dw	.centerVDC2_01 +6*10	;20
			dw	.centerVDC2_01 +6*9	;21
			dw	.centerVDC2_01 +6*8	;22
			dw	.centerVDC2_01 +6*7	;23
			dw	.centerVDC2_01 +6*6	;24
			dw	.centerVDC2_01 +6*5	;25
			dw	.centerVDC2_01 +6*4	;26
			dw	.centerVDC2_01 +6*3	;27
			dw	.centerVDC2_01 +6*2	;28
			dw	.centerVDC2_01 +6*1	;29

			dw	.centerVDC2_01 +6*0	;30

;--------
.centerVDC2_02Addr:
			dw	.centerVDC2_02 +6*30	;-1
			dw	.centerVDC2_02 +6*30	;0

			dw	.centerVDC2_02 +6*29	;1
			dw	.centerVDC2_02 +6*28	;2
			dw	.centerVDC2_02 +6*27	;3
			dw	.centerVDC2_02 +6*26	;4
			dw	.centerVDC2_02 +6*25	;5
			dw	.centerVDC2_02 +6*24	;6
			dw	.centerVDC2_02 +6*23	;7
			dw	.centerVDC2_02 +6*22	;8
			dw	.centerVDC2_02 +6*21	;9

			dw	.centerVDC2_02 +6*20	;10
			dw	.centerVDC2_02 +6*19	;11
			dw	.centerVDC2_02 +6*18	;12
			dw	.centerVDC2_02 +6*17	;13
			dw	.centerVDC2_02 +6*16	;14
			dw	.centerVDC2_02 +6*15	;15
			dw	.centerVDC2_02 +6*14	;16
			dw	.centerVDC2_02 +6*13	;17
			dw	.centerVDC2_02 +6*12	;18
			dw	.centerVDC2_02 +6*11	;19

			dw	.centerVDC2_02 +6*10	;20
			dw	.centerVDC2_02 +6*9	;21
			dw	.centerVDC2_02 +6*8	;22
			dw	.centerVDC2_02 +6*7	;23
			dw	.centerVDC2_02 +6*6	;24
			dw	.centerVDC2_02 +6*5	;25
			dw	.centerVDC2_02 +6*4	;26
			dw	.centerVDC2_02 +6*3	;27
			dw	.centerVDC2_02 +6*2	;28
			dw	.centerVDC2_02 +6*1	;29

			dw	.centerVDC2_02 +6*0	;30


;----------------------------
setBAT:
;set BAT

		mov	VDC1_0, #$00
		movw	VDC1_2, #$0000
		mov	VDC1_0, #$02

		mov	VDC2_0, #$00
		movw	VDC2_2, #$0000
		mov	VDC2_0, #$02

		movw	<setBatWork, #$0400
.clearbatloop0:
		movw	VDC1_2, <setBatWork

		movw	VDC2_2, <setBatWork

		addw	<setBatWork, #$0002
		cmpw	<setBatWork, #$0800
		bcc	.clearbatloop0

		movw	<setBatWork, #$0401
.clearbatloop1:
		movw	VDC1_2, <setBatWork

		movw	VDC2_2, <setBatWork

		addw	<setBatWork, #$0002
		cmpw	<setBatWork, #$0801
		bcc	.clearbatloop1

		rts


;////////////////////////////
		.bank	2

		.org	$C000

;----------------------------
polyLineAddrConvYHigh0:
		.db	$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C,\
			$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70, $74, $74, $74, $74, $74, $74, $74, $74,\
			$78, $78, $78, $78, $78, $78, $78, $78, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C,\
			$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C,\
			$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$60, $60, $60, $60, $60, $60, $60, $60, $64, $64, $64, $64, $64, $64, $64, $64,\
			$68, $68, $68, $68, $68, $68, $68, $68, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C,\
			$70, $70, $70, $70, $70, $70, $70, $70, $74, $74, $74, $74, $74, $74, $74, $74,\
			$78, $78, $78, $78, $78, $78, $78, $78, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C


;----------------------------
polyLineAddrConvYLow0:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17,\
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17


;----------------------------
polyLineAddrConvXHigh0:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\
			$03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03,\
			$03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03,\
			$03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03,\
			$03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03


;----------------------------
polyLineAddrConvXLow0:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $20, $20, $20, $20,\
			$40, $40, $40, $40, $40, $40, $40, $40, $60, $60, $60, $60, $60, $60, $60, $60,\
			$80, $80, $80, $80, $80, $80, $80, $80, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0,\
			$00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $20, $20, $20, $20,\
			$40, $40, $40, $40, $40, $40, $40, $40, $60, $60, $60, $60, $60, $60, $60, $60,\
			$80, $80, $80, $80, $80, $80, $80, $80, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0,\
			$00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $20, $20, $20, $20,\
			$40, $40, $40, $40, $40, $40, $40, $40, $60, $60, $60, $60, $60, $60, $60, $60,\
			$80, $80, $80, $80, $80, $80, $80, $80, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0,\
			$00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $20, $20, $20, $20,\
			$40, $40, $40, $40, $40, $40, $40, $40, $60, $60, $60, $60, $60, $60, $60, $60,\
			$80, $80, $80, $80, $80, $80, $80, $80, $A0, $A0, $A0, $A0, $A0, $A0, $A0, $A0,\
			$C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $E0, $E0, $E0, $E0, $E0, $E0, $E0, $E0


;----------------------------
polyLineAddrConvX:
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
polyLineLeftDatas:
		.db	$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01,\
			$FF, $7F, $3F, $1F, $0F, $07, $03, $01, $FF, $7F, $3F, $1F, $0F, $07, $03, $01


;----------------------------
polyLineRightDatas:
		.db	$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF,\
			$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF, $80, $C0, $E0, $F0, $F8, $FC, $FE, $FF


;----------------------------
polyLineColorData0:
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $55, $AA, $FF, $FF, $55, $AA, $00, $00, $AA, $55, $FF, $FF, $FF, $FF


;----------------------------
polyLineColorData1:
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $55, $AA, $FF, $FF, $55, $AA, $00, $00, $AA, $55, $FF, $FF, $FF, $FF


;----------------------------
polyLineColorData2:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $55, $AA, $FF, $FF, $55, $AA, $00, $00, $AA, $55, $FF, $FF, $FF, $FF


;----------------------------
polyLineColorData3:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $AA, $55, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


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
		.bank	3
		INCBIN	"char.dat"		;    8K  3    $03
		INCBIN	"mul.dat"		;  128K  4~19 $04~$13
		INCBIN	"div.dat"		;   96K 20~31 $14~$1F
