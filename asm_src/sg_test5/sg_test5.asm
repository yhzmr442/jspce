;----------------------------
;world coordinate
;         TOP
;         +Y
; LEFT -X  | +Z BACK
;        \ | /
;         \|/
;         /|\
;        / | \
;FRONT -Z  | +X RIGHT
;         -Y
;        BOTTOM

;----------------------------
;direction of rotation
;counterclockwise(A to B)
;+Y
; |  
; | B/--
; |  \  \
; |      \
; |       |
; |       |
; |       A
; |
;-|-------+X
;
;+Y
; |  
; | B/--
; |  \  \
; |      \
; |       |
; |       |
; |       A
; |
;-|-------+Z
;
;+Z
; |  
; | B/--
; |  \  \
; |      \
; |       |
; |       |
; |       A
; |
;-|-------+X


;memory map
;CPU
;$0000-$1FFF	I/O
;$2000-$3FFF	RAM
;$4000-$5FFF	mul data, transform div data, polygon function
;$6000-$7FFF
;$8000-$9FFF
;$A000-$BFFF
;$C000-$DFFF	polygon function
;$E000-$FFFF	main

;VRAM
;$0000-$03FF	BAT
;$0400-$04FF	SATB
;$0500-$0FFF	CHAR
;$1000-$1FFF	CHAR
;$2000-$4FFF	BUFFER
;$5000-$7FFF	VRAM CLEAR DATA


;//////////////////////////////////
;----------------------------
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

TIMER_CONTROL_REG	.equ	$0C00
TIMER_COUNTER_REG	.equ	$0C01

INTERRUPT_DISABLE_REG	.equ	$1402

IO_REG			.equ	$1000

;----------------------------
chardatBank		.equ	3
muldatBank		.equ	4
divdatBank		.equ	20
polygonProcBank		.equ	32
spdatBank		.equ	33

;//////////////////////////////////
;----------------------------
edgeSigneXPlus0m	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		inx

		pha
		setEdgeBuffer0m
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneXMinus0m	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		dex

		pha
		setEdgeBuffer0m
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneYPlus0m	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		iny

.jp_\@:
		pha
		setEdgeBuffer0m
		pla

		.endm


;----------------------------
edgeSigneYMinus0m	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		dey

.jp_\@:
		pha
		setEdgeBuffer0m
		pla

		.endm


;----------------------------
edgeSigneXPlusm	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		inx

		pha
		setEdgeBufferm
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneXMinusm	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		dex

		pha
		setEdgeBufferm
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneYPlusm	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		iny

.jp_\@:
		pha
		setEdgeBufferm
		pla

		.endm


;----------------------------
edgeSigneYMinusm	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		dey

.jp_\@:
		pha
		setEdgeBufferm
		pla

		.endm


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
setEdgeBuffer0m	.macro
;
		tya
		sta	edgeLeft,x
		inc	edgeCount,x
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
stzw		.macro
;\1 = 0
		stz	\1
		stz	\1+1
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
cmpw		.macro
;\1 - \2
		.if	(\?2 = 2);Immediate
			lda	\1+1
			cmp	#HIGH(\2)
			bne	.jp0\@
			lda	\1
			cmp	#LOW(\2)
		.else
			lda	\1+1
			cmp	\2+1
			bne	.jp0\@
			lda	\1
			cmp	\2
		.endif
		beq	.jp0\@
		lda	#$01
		bcs	.jp0\@
		lda	#$80
.jp0\@
		.endm


;----------------------------
cmpw2		.macro
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
cmpq2		.macro
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
st012		.macro
;
		st0	#\1
		st1	#LOW(\2)
		st2	#HIGH(\2)
		.endm


;//////////////////////////////////
		.zp
;**********************************
		.org	$2000
;---------------------
;start of system usage block
;---------------------
;---------------------
mul16a
div16a			.ds	2
mul16b
div16b			.ds	2
mul16c
div16c			.ds	2
mul16d
div16d			.ds	2

mulAddr			.ds	2

;---------------------
padLast			.ds	1
padNow			.ds	1
padState		.ds	1

;---------------------
vsyncFlag		.ds	1
vdpStatus		.ds	1
vdp1Status		.ds	1
vdp2Status		.ds	1
selectVdc		.ds	1

;---------------------
vertexCount		.ds	1
vertexCountWork		.ds	1
vertex0Addr		.ds	2

;---------------------
clip2D0Count		.ds	1
clip2D1Count		.ds	1
clip2DFlag		.ds	1

;---------------------
clipFrontX		;.ds	2
polyLineLeftAddr	;.ds	2
circleX			;.ds	2
edgeX0			.ds	1
edgeY0			.ds	1

clipFrontY		;.ds	2
polyLineRightAddr	;.ds	2
circleY			;.ds	2
edgeX1			.ds	1
edgeY1			.ds	1

polyLineYAddr		;.ds	2
circleD			;.ds	2
frontClipFlag		;.ds	1
edgeSlopeX		.ds	1
frontClipCount		;.ds	1
edgeSlopeY		.ds	1

work8a			;.ds	8
circleDH		;.ds	2
frontClipData0		;.ds	1
edgeSigneX		.ds	1
frontClipData1		;.ds	1
polyLineColorDataWork	.ds	1

circleDD		;.ds	2
calcEdgeLastAddr	;.ds	1
polyLineX0		.ds	1
polyLineX1		.ds	1

circleRadius		;.ds	2
polyLineY		.ds	1
polyLineCount		.ds	1

circleCenterX		;.ds	2
polyLineLeftData	.ds	1
polyLineLeftMask	.ds	1

work8b			;.ds	8
circleCenterY		;.ds	2
polyLineRightData	.ds	1
polyLineRightMask	.ds	1

circleYTop		;.ds	2
circleXLeft		;.ds	2
polyLineColorDataWork0	.ds	1
polyLineColorDataWork1	.ds	1

circleYBottom		;.ds	2
circleXRight		;.ds	2
polyLineColorDataWork2	.ds	1
polyLineColorDataWork3	.ds	1

circleYWork		;.ds	2
polyLineDataLow		.ds	1
polyLineDataHigh	.ds	1

frontClipDataWork	;.ds	1
circleTmp		.ds	1

;---------------------
polyLineTopAddr		.ds	2

;---------------------
minEdgeY		.ds	1

;---------------------
polyLineColorIndex	.ds	1
polyAttribute		.ds	1

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

;---------------------
angleX0			;.ds	2
argw0			;.ds	2
arg0			.ds	1
arg1			.ds	1

angleX1			;.ds	2
argw1			;.ds	2
arg2			.ds	1
arg3			.ds	1

angleY0			;.ds	2
argw2			;.ds	2
arg4			.ds	1
arg5			.ds	1

angleY1			;.ds	2
argw3			;.ds	2
arg6			.ds	1
arg7			.ds	1

angleZ0			.ds	2
angleZ1			.ds	2

ansAngleX		.ds	1
ansAngleY		.ds	1

;---------------------
polyBufferAddr		.ds	2
polyBufferZ0Work0	.ds	2
polyBufferZ0Work1	.ds	2

polyBufferNow		.ds	2
polyBufferNext		.ds	2

;---------------------
modelAddr		.ds	2
modelAddrWork		.ds	2
modelPolygonCount	.ds	1
setModelCount		.ds	1
setModelFrontColor	.ds	1
setModelBackColor	.ds	1
setModelAttr		.ds	1
model2DClipIndexWork	.ds	1

;---------------------
edgeLoopCount		.ds	1
edgeLoopAddr		.ds	2

;---------------------
satbBufferAddr		.ds	2

;---------------------
;end of system usage block
;---------------------


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

;---------------------
shotMAX			.equ	4
shotState		.ds	2*shotMAX
shotX			.ds	2*shotMAX
shotY			.ds	2*shotMAX
shotZ			.ds	2*shotMAX

;---------------------
enemyShotMAX		.equ	16
enemyShotState		.ds	4*enemyShotMAX
enemyShotX		.ds	4*enemyShotMAX
enemyShotY		.ds	4*enemyShotMAX
enemyShotZ		.ds	4*enemyShotMAX
enemyShotMoveX		.ds	4*enemyShotMAX
enemyShotMoveY		.ds	4*enemyShotMAX
enemyShotMoveZ		.ds	4*enemyShotMAX

;---------------------
enemyMAX		.equ	4
enemyState		.ds	2*enemyMAX
enemyX			.ds	2*enemyMAX
enemyY			.ds	2*enemyMAX
enemyZ			.ds	2*enemyMAX
enemyTimer		.ds	1

;---------------------
objectMAX		.equ	4
objectState		.ds	2*objectMAX
objectX			.ds	2*objectMAX
objectY			.ds	2*objectMAX
objectZ			.ds	2*objectMAX
objectTimer		.ds	1

;---------------------
starMAX			.equ	12
starState		.ds	2*starMAX
starX			.ds	2*starMAX
starY			.ds	2*starMAX
starZ			.ds	2*starMAX
starMovementZ		.ds	2*starMAX

;---------------------
checkHitWork		.ds	2


;---------------------
;start of system usage block
;---------------------
;---------------------
randomSeed		.ds	2

;---------------------
putCharAddr		.ds	2
putCharData		.ds	2
putCharAttr		.ds	1

;---------------------
setBatWork		.ds	2

;---------------------
saveMPR2Data		.ds	1

;---------------------
transform2DWork0	.ds	256
transform2DWork1	.ds	256

;---------------------
clip2D0			.ds	(8+1)*4
clip2D1			.ds	(8+1)*4

;---------------------
polyLineColorWork_H_P0	.ds	1
polyLineColorWork_H_P1	.ds	1
polyLineColorWork_H_P2	.ds	1
polyLineColorWork_H_P3	.ds	1

polyLineColorWork_L_P0	.ds	1
polyLineColorWork_L_P1	.ds	1
polyLineColorWork_L_P2	.ds	1
polyLineColorWork_L_P3	.ds	1

;---------------------
polyLineColorP0		.ds	64
polyLineColorP1		.ds	64
polyLineColorP2		.ds	64
polyLineColorP3		.ds	64

;---------------------

SATB_BUFFER_ADDR	.equ	$3000
;**********************************
		.org	SATB_BUFFER_ADDR-(192*3+2)
;---------------------
edgeLeft		.ds	192
edgeRight		.ds	192
edgeCount		.ds	192
			.ds	2

;**********************************
		.org 	SATB_BUFFER_ADDR
			.rsset	0
SATB_Y			.rs	2
SATB_X			.rs	2
SATB_PATTERN		.rs	2
SATB_ATTRIBUTE		.rs	2
SATB_SIZE		.rs	0
satbBuffer		.ds	SATB_SIZE*64

;**********************************
		.org 	SATB_BUFFER_ADDR+SATB_SIZE*64
;NEXT ADDR 2Byte
;SAMPLE Z 2Byte
;COLOR 1Byte COLOR:(0-63), CIRCLE:+$80, line skip:+$40
;VERTEX COUNT 1Byte COUNT:(3-9) or CIRCLE:$FF or DATA END:$00
;X0 1Byte, Y0 1Byte or CIRCLE CENTER X 2Byte
;X1 1Byte, Y1 1Byte or CIRCLE CENTER Y 2Byte
;X2 1Byte, Y2 1Byte or CIRCLE RADIUS 2Byte (1-8192)
;X3 1Byte, Y3 1Byte
;X4 1Byte, Y4 1Byte
;X5 1Byte, Y5 1Byte
;X6 1Byte, Y6 1Byte
;X7 1Byte, Y7 1Byte
;X8 1Byte, Y8 1Byte
polyBufferStart		.ds	6
polyBufferEnd		.ds	6
polyBuffer		.ds	1	;end address $3FFF
;---------------------
;end of system usage block
;---------------------


		.code
;**********************************
;//////////////////////////////////
		.bank	0
		.org	$E000

;----------------------------
main:
;
;set polygon function bank
		lda	#$01
		tam	#$05

;initialize VDC
		jsr	initializeVdc

;initialize VPC
		jsr	initializeVpc

;initialize SATB
		jsr	initializeSatb

;initialize pad
		jsr	initializePad

;initialize BAT
		jsr	setBat

;set VRAM Address for polygon
		movw	<polyLineTopAddr, #$2000

;set palette
		stzw	VCE_2
		tia	paletteData, VCE_4, $20*32

;set polygon colors
		tii	polyLineColor0, polyLineColorP0, 64
		tii	polyLineColor1, polyLineColorP1, 64
		tii	polyLineColor2, polyLineColorP2, 64
		tii	polyLineColor3, polyLineColorP3, 64

;set bg char data
		lda	#chardatBank
		tam	#$02

		mov	VDC1_0, #$00
		movw	VDC1_2, #$1000
		mov	VDC1_0, #$02
		tia	$4000, VDC1_2, $2000

		mov	VDC2_0, #$00
		movw	VDC2_2, #$1000
		mov	VDC2_0, #$02
		tia	$4000, VDC2_2, $2000

;set sp char data
		lda	#spdatBank
		tam	#$02

		mov	VDC1_0, #$00
		movw	VDC1_2, #$0500
		mov	VDC1_0, #$02
		tia	$4A00, VDC1_2, $1600

		mov	VDC2_0, #$00
		movw	VDC2_2, #$0500
		mov	VDC2_0, #$02
		tia	$4A00, VDC2_2, $1600

;set VRAM clear buffer
		mov	VDC1_0, #$00
		movw	VDC1_2, #$5000
		mov	VDC1_0, #$02

		mov	VDC2_0, #$00
		movw	VDC2_2, #$5000
		mov	VDC2_0, #$02

		ldy	#3
.vramClearLoop0:
		clx
.vramClearLoop1:
		tia	vramClearData, VDC1_2, 32
		tia	vramClearData, VDC2_2, 32
		inx
		bne	.vramClearLoop1
		dey
		bne	.vramClearLoop0

;initialize datas
		lda	#128
		sta	<centerX
		lda	#96
		sta	<centerY

		jsr	initScreenVsync

		lda	#60
		sta	frameCount
		stz	drawCount
		stz	drawCountWork

		stzw	shipX
		stzw	shipY
		stzw	shipZ

		jsr	initRandom

		jsr	getRandom
		and	#$07
		ora	#$08
		sta	enemyTimer

		jsr	getRandom
		and	#$07
		ora	#$08
		sta	objectTimer

		jsr	initializeEnemy
		jsr	initializeEnemyShot
		jsr	initializeShot
		jsr	initializeObject

		clx
.setStarLoop:
		jsr	setStar
		inx
		inx
		cpx	#2*starMAX
		bne	.setStarLoop

;initialize Vsync, auto-Increment
		jsr	initScreenVsync

;vsync interrupt start
		cli

.mainLoop:
;polygon and sprite initialize processing
;initialize buffer
		jsr	initializePolygonBuffer

;clear satb buffer
		jsr	clearSatbBuffer

;game process
;don't let interruptions be blocked for a long time.

;check pad
;pad up
		bbr4	<padNow, .checkPadDown
		clc
		lda	shipY
		adc	#$80
		sta	shipY
		lda	shipY+1
		adc	#$00
		sta	shipY+1

.checkPadDown:
;pad down
		bbr6	<padNow, .checkPadLeft
		sec
		lda	shipY
		sbc	#$80
		sta	shipY
		lda	shipY+1
		sbc	#$00
		sta	shipY+1

.checkPadLeft:
;pad left
		bbr7	<padNow, .checkPadRight
		sec
		lda	shipX
		sbc	#$80
		sta	shipX
		lda	shipX+1
		sbc	#$00
		sta	shipX+1

.checkPadRight:
;pad right
		bbr5	<padNow, .checkPadEnd
		clc
		lda	shipX
		adc	#$80
		sta	shipX
		lda	shipX+1
		adc	#$00
		sta	shipX+1

.checkPadEnd:

;set world data
		movw	<eyeTranslationX, shipX
		movw	<eyeTranslationY, shipY
		movw	<eyeTranslationZ, shipZ

		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #$12

;sprite process
		movw	<argw0, #64+96-8	;Y
		movw	<argw1, #32+128-16	;X
		movw	<argw2, #$0028		;char code
		movw	<argw3, #$0180		;attribute
		jsr	setSatbBuffer

;etc
		jsr	moveEnemy
		jsr	moveEnemyShot
		jsr	moveShot
		jsr	moveObject

		dec	enemyTimer
		bne	.setEnemyJp
		jsr	setEnemy
		jsr	getRandom
		and	#$0F
		ora	#$10
		sta	enemyTimer
.setEnemyJp:

		bbr0	<padNow, .checkShotEnd
		jsr	setShot

.checkShotEnd:
		dec	objectTimer
		bne	.setObjectJp
		jsr	setObject
		jsr	getRandom
		and	#$07
		ora	#$08
		sta	objectTimer

.setObjectJp:
		jsr	checkHitShotEnemy

;set polygon color index
		stz	<polyLineColorIndex

		jsr	setEnemyModel
		jsr	setEnemyShotModel
		jsr	setShotModel
		jsr	setObjectModel

		jsr	moveStar

;polygon and sprite output processing
;wait vsync
		jsr	waitScreenVsync

;set SATB DMA
		jsr	setSatbDma

;put polygon
		jsr	putPolygonBuffer

;VRAM access operation process
		inc	drawCountWork
		mov	putCharAttr, #$00
		ldx	#0
		ldy	#24
		lda	drawCount
		jsr	putHex

;set vsync flag
		jsr	setVsyncFlag

;jump mainloop
		jmp	.mainLoop


;----------------------------
moveStar:
;
		clx

.moveStarLoop:
		sec
		lda	starZ, x
		sbc	starMovementZ, x
		sta	starZ, x

		lda	starZ+1, x
		sbc	starMovementZ+1, x
		sta	starZ+1, x

		sec
		lda	starZ, x
		sbc	#$80
		lda	starZ+1, x
		sbc	#$00
		bpl	.starJp0

		jsr	setStar
.starJp0:

		sec
		lda	starX, x
		sbc	shipX
		sta	<mul16c

		lda	starX+1, x
		sbc	shipX+1
		sta	<mul16c+1

		lda	starZ, x
		sta	<mul16a
		lda	starZ+1, x
		sta	<mul16a+1

		jsr	transform2DProc

		addw	<mul16a, #128+32
		cmpw2	<mul16a, #32
		jmi	.nextStar
		cmpw2	<mul16a, #256+32
		bpl	.nextStar

		movw	<argw1, <mul16a

;--------
		sec
		lda	starY, x
		sbc	shipY
		sta	<mul16c

		lda	starY+1, x
		sbc	shipY+1
		sta	<mul16c+1

		lda	starZ, x
		sta	<mul16a
		lda	starZ+1, x
		sta	<mul16a+1

		jsr	transform2DProc

		sec
		cla
		sbc	<mul16a
		sta	<mul16a
		cla
		sbc	<mul16a+1
		sta	<mul16a+1

		addw	<mul16a, #96+64
		cmpw2	<mul16a, #64
		bmi	.nextStar
		cmpw2	<mul16a, #192+64
		bpl	.nextStar

		movw	<argw0, <mul16a
		movw	<argw2, #$002C
		movw	<argw3, #$0000

		jsr	setSatbBuffer

.nextStar:
		inx
		inx
		cpx	#2*starMAX
		jne	.moveStarLoop

		rts


;----------------------------
setStar
;
		jsr	getRandom
		bmi	.jpXmi

		and	#$0F
		sta	starX+1, x
		lda	#$00
		sta	starX, x

		bra	.jpX

.jpXmi:
		ora	#$F0
		sta	starX+1, x
		lda	#$FF
		sta	starX, x

.jpX:
		clc
		lda	starX, x
		adc	shipX
		sta	starX, x

		lda	starX+1, x
		adc	shipX+1
		sta	starX+1, x

;--------
		jsr	getRandom
		sta	starY+1, x
		bmi	.jpYmi

		and	#$0F
		sta	starY+1, x
		lda	#$00
		sta	starY, x

		bra	.jpY

.jpYmi:
		ora	#$F0
		sta	starY+1, x
		lda	#$FF
		sta	starY, x

.jpY:
		clc
		lda	starY, x
		adc	shipY
		sta	starY, x

		lda	starY+1, x
		adc	shipY+1
		sta	starY+1, x

;--------
		lda	#$00
		sta	starZ, x
		lda	#$20
		sta	starZ+1, x

		jsr	getRandom
		ora	#$80
		sta	starMovementZ, x
		lda	#$00
		sta	starMovementZ+1, x

		rts


;----------------------------
checkHitShotEnemy:
;
		clx
.loop0:		lda	shotState, x
		jmi	.nextShot

		cly
.loop1:		lda	enemyState, y
		jmi	.nextEnemy
		jne	.nextEnemy

		sec
		lda	enemyX, y
		sbc	shotX, x
		sta	checkHitWork
		lda	enemyX+1, y
		sbc	shotX+1, x
		sta	checkHitWork+1

		cmpw2	checkHitWork, #-256-128
		jmi	.nextEnemy

		cmpw2	checkHitWork, #256+128
		bpl	.nextEnemy

		sec
		lda	enemyY, y
		sbc	shotY, x
		sta	checkHitWork
		lda	enemyY+1, y
		sbc	shotY+1, x
		sta	checkHitWork+1

		cmpw2	checkHitWork, #-256-128
		bmi	.nextEnemy

		cmpw2	checkHitWork, #256+128
		bpl	.nextEnemy

		sec
		lda	enemyZ, y
		sbc	shotZ, x
		sta	checkHitWork
		lda	enemyZ+1, y
		sbc	shotZ+1, x
		sta	checkHitWork+1

		cmpw2	checkHitWork, #-256-128
		bmi	.nextEnemy

		cmpw2	checkHitWork, #256+128
		bpl	.nextEnemy

		lda	#$FF
		sta	shotState, x
		lda	#$10
		sta	enemyState, y
		sta	enemyState+1, y
		bra	.nextShot

.nextEnemy:
		iny
		iny
		cpy	#enemyMAX*2
		jne	.loop1

.nextShot:	inx
		inx
		cpx	#shotMAX*2
		jne	.loop0
		rts


;----------------------------
initializeEnemyShot:
;
		clx

.loop:		lda	#$FF
		sta	enemyShotState, x

		lda	intTable+4, x
		tax
		cpx	#enemyShotMAX*4
		bne	.loop

		rts


;----------------------------
setEnemyShot:
;
		cly

.loop:		lda	enemyShotState, y
		jpl	.jp0

		lda	#$00
		sta	enemyShotState, y


		lda	enemyX, x
		sta	angleX0
		lda	enemyX+1, x
		sta	angleX0+1

		lda	enemyY, x
		sta	angleY0
		lda	enemyY+1, x
		sta	angleY0+1

		lda	enemyZ, x
		sta	angleZ0
		lda	enemyZ+1, x
		sta	angleZ0+1

		movw	angleX1, shipX
		movw	angleY1, shipY
		movw	angleZ1, shipZ

		jsr	getAngle

		phx
		movw	transform2DWork0, #$0000
		movw	transform2DWork0+2, #$0000
		movw	transform2DWork0+4, #$0100
		mov	vertexCount, #1
		ldx	ansAngleX
		jsr	vertexRotationX
		mov	vertexCount, #1
		ldx	ansAngleY
		jsr	vertexRotationY
		plx

		lda	#$00
		sta	enemyShotX, y
		lda	#$00
		sta	enemyShotX+1, y
		lda	enemyX, x
		sta	enemyShotX+2, y
		lda	enemyX+1, x
		sta	enemyShotX+3, y

		lda	#$00
		sta	enemyShotY, y
		lda	#$00
		sta	enemyShotY+1, y
		lda	enemyY, x
		sta	enemyShotY+2, y
		lda	enemyY+1, x
		sta	enemyShotY+3, y

		lda	#$00
		sta	enemyShotZ, y
		lda	#$00
		sta	enemyShotZ+1, y
		lda	enemyZ, x
		sta	enemyShotZ+2, y
		lda	enemyZ+1, x
		sta	enemyShotZ+3, y

		lda	#$00
		sta	enemyShotMoveX, y
		lda	#$00
		sta	enemyShotMoveX+1, y
		lda	transform2DWork0
		sta	enemyShotMoveX+2, y
		lda	transform2DWork0+1
		sta	enemyShotMoveX+3, y

		lda	#$00
		sta	enemyShotMoveY, y
		lda	#$00
		sta	enemyShotMoveY+1, y
		lda	transform2DWork0+2
		sta	enemyShotMoveY+2, y
		lda	transform2DWork0+3
		sta	enemyShotMoveY+3, y

		lda	#$00
		sta	enemyShotMoveZ, y
		lda	#$00
		sta	enemyShotMoveZ+1, y
		lda	transform2DWork0+4
		sta	enemyShotMoveZ+2, y
		lda	transform2DWork0+5
		sta	enemyShotMoveZ+3, y

		bra	.jp1

.jp0:		lda	intTable+4, y
		tay
		cpy	#enemyShotMAX*4
		jne	.loop

.jp1:
		rts


;----------------------------
moveEnemyShot:
;
		clx

.loop:		lda	enemyShotState, x
		bmi	.jp0

		clc
		lda	enemyShotX, x
		adc	enemyShotMoveX, x
		sta	enemyShotX, x

		lda	enemyShotX+1, x
		adc	enemyShotMoveX+1, x
		sta	enemyShotX+1, x

		lda	enemyShotX+2, x
		adc	enemyShotMoveX+2, x
		sta	enemyShotX+2, x

		lda	enemyShotX+3, x
		adc	enemyShotMoveX+3, x
		sta	enemyShotX+3, x

		clc
		lda	enemyShotY, x
		adc	enemyShotMoveY, x
		sta	enemyShotY, x

		lda	enemyShotY+1, x
		adc	enemyShotMoveY+1, x
		sta	enemyShotY+1, x

		lda	enemyShotY+2, x
		adc	enemyShotMoveY+2, x
		sta	enemyShotY+2, x

		lda	enemyShotY+3, x
		adc	enemyShotMoveY+3, x
		sta	enemyShotY+3, x

		clc
		lda	enemyShotZ, x
		adc	enemyShotMoveZ, x
		sta	enemyShotZ, x

		lda	enemyShotZ+1, x
		adc	enemyShotMoveZ+1, x
		sta	enemyShotZ+1, x

		lda	enemyShotZ+2, x
		adc	enemyShotMoveZ+2, x
		sta	enemyShotZ+2, x

		lda	enemyShotZ+3, x
		adc	enemyShotMoveZ+3, x
		sta	enemyShotZ+3, x

		bpl	.jp0

		lda	#$FF
		sta	enemyShotState, x

.jp0:
		lda	intTable+4, x
		tax
		cpx	#enemyShotMAX*4
		jne	.loop

		rts


;----------------------------
setEnemyShotModel:
;
		clx

.loop:		lda	enemyShotState, x
		jmi	.jp0

		lda	enemyShotX+2, x
		sta	<translationX
		lda	enemyShotX+3, x
		sta	<translationX+1

		lda	enemyShotY+2, x
		sta	<translationY
		lda	enemyShotY+3, x
		sta	<translationY+1

		lda	enemyShotZ+2, x
		sta	<translationZ
		lda	enemyShotZ+3, x
		sta	<translationZ+1

		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0
		mov	<rotationSelect, #$12

		movw	<modelAddr, #modelData003

		jsr	setModel2

.jp0:
		lda	intTable+4, x
		tax
		cpx	#enemyShotMAX*4
		jne	.loop

		rts


;----------------------------
initializeEnemy:
;
		lda	#$FF

		clx

.loop:		sta	enemyState, x

		inx
		inx
		cpx	#enemyMAX*2
		bne	.loop

		rts


;----------------------------
setEnemy:
;
		clx

.loop:		lda	enemyState, x
		bpl	.jp0
		stz	enemyState, x
		stz	enemyState+1, x

		jsr	getRandom
		sta	enemyX, x
		jsr	getRandom
		bmi	.jpXmi
		and	#$03
		bra	.jpX
.jpXmi:
		ora	#$FC
.jpX:
		sta	enemyX+1, x

		clc
		lda	enemyX, x
		adc	shipX
		sta	enemyX, x
		lda	enemyX+1, x
		adc	shipX+1
		sta	enemyX+1, x

		jsr	getRandom
		sta	enemyY, x
		jsr	getRandom
		bmi	.jpYmi
		and	#$03
		bra	.jpY
.jpYmi:
		ora	#$FC
.jpY:
		sta	enemyY+1, x

		clc
		lda	enemyY, x
		adc	shipY
		sta	enemyY, x
		lda	enemyY+1, x
		adc	shipY+1
		sta	enemyY+1, x

		lda	#$00
		sta	enemyZ, x
		lda	#$20
		sta	enemyZ+1, x

		sec
		bra	.jp1

.jp0:		inx
		inx
		cpx	#enemyMAX*2
		bne	.loop
.jp1:
		rts


;----------------------------
moveEnemy:
;
		clx

.loop:		dec	enemyState+1, x

		lda	enemyState, x
		bmi	.jp0
		bne	.jp1

		sec
		lda	enemyZ, x
		sbc	#$40
		sta	enemyZ, x
		lda	enemyZ+1, x
		sbc	#$00
		sta	enemyZ+1, x

		bpl	.jp2

		lda	#$FF
		sta	enemyState, x

		bra	.jp0

.jp2:
		lda	enemyState+1, x
		and	#$0F
		bne	.jp0

		sec
		lda	enemyZ, x
		sbc	#$00
		lda	enemyZ+1, x
		sbc	#$10
		bmi	.jp0

		jsr	setEnemyShot
		bra	.jp0

.jp1:
		lda	enemyState+1, x
		bne	.jp0
		lda	#$FF
		sta	enemyState, x

.jp0:		inx
		inx
		cpx	#enemyMAX*2
		bne	.loop

		rts


;----------------------------
setEnemyModel:
;
		clx

.loop:		lda	enemyState, x
		jmi	.jp0

		lda	enemyX, x
		sta	<translationX
		lda	enemyX+1, x
		sta	<translationX+1

		lda	enemyY, x
		sta	<translationY
		lda	enemyY+1, x
		sta	<translationY+1

		lda	enemyZ, x
		sta	<translationZ
		lda	enemyZ+1, x
		sta	<translationZ+1

		mov	<rotationX, #0
		mov	<rotationY, #128
		mov	<rotationZ, #0
		mov	<rotationSelect, #$12

		lda	enemyState, x
		bne	.jp01

		movw	<modelAddr, #modelData001
		bra	.jp99
.jp01:
		lda	enemyState+1, x
		cmp	#8
		bcc	.jp02
		movw	<modelAddr, #modelData004
		bra	.jp99
.jp02:
		cmp	#4
		bcc	.jp03
		movw	<modelAddr, #modelData005
		bra	.jp99
.jp03:
		movw	<modelAddr, #modelData006

.jp99:
		jsr	setModel2

.jp0:		inx
		inx
		cpx	#enemyMAX*2
		jne	.loop

		rts


;----------------------------
initializeObject:
;
		lda	#$FF

		clx

.loop:		sta	objectState, x

		inx
		inx
		cpx	#objectMAX*2
		bne	.loop

		rts


;----------------------------
setObject:
;
		clx

.loop:		lda	objectState, x
		bpl	.jp0
		stz	objectState, x

		jsr	getRandom
		sta	objectX, x
		jsr	getRandom
		bmi	.jpXmi
		and	#$03
		bra	.jpX
.jpXmi:
		ora	#$FC
.jpX:
		sta	objectX+1, x

		clc
		lda	objectX, x
		adc	shipX
		sta	objectX, x
		lda	objectX+1, x
		adc	shipX+1
		sta	objectX+1, x


		jsr	getRandom
		sta	objectY, x
		jsr	getRandom
		bmi	.jpYmi
		and	#$03
		bra	.jpY
.jpYmi:
		ora	#$FC
.jpY:
		sta	objectY+1, x

		clc
		lda	objectY, x
		adc	shipY
		sta	objectY, x
		lda	objectY+1, x
		adc	shipY+1
		sta	objectY+1, x

		lda	#$00
		sta	objectZ, x
		lda	#$20
		sta	objectZ+1, x

		sec
		bra	.jp1

.jp0:		inx
		inx
		cpx	#objectMAX*2
		bne	.loop
.jp1:
		rts


;----------------------------
moveObject:
;
		clx

.loop:		lda	objectState, x
		bmi	.jp0

		sec
		lda	objectZ, x
		sbc	#$80
		sta	objectZ, x
		lda	objectZ+1, x
		sbc	#$00
		sta	objectZ+1, x

		bpl	.jp0

		lda	#$FF
		sta	objectState, x

.jp0:		inx
		inx
		cpx	#objectMAX*2
		bne	.loop

		rts


;----------------------------
setObjectModel:
;
		clx

.loop:		lda	objectState, x
		bmi	.jp0

		lda	objectX, x
		sta	<translationX
		lda	objectX+1, x
		sta	<translationX+1

		lda	objectY, x
		sta	<translationY
		lda	objectY+1, x
		sta	<translationY+1

		lda	objectZ, x
		sta	<translationZ
		lda	objectZ+1, x
		sta	<translationZ+1

		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0
		mov	<rotationSelect, #$12

		movw	<modelAddr, #modelData002

		jsr	setModel2

.jp0:		inx
		inx
		cpx	#objectMAX*2
		bne	.loop

		rts


;----------------------------
initializeShot:
;
		lda	#$FF

		clx

.loop:		sta	shotState, x

		inx
		inx
		cpx	#shotMAX*2
		bne	.loop

		rts


;----------------------------
setShot:
;
		clx

.loop:		lda	shotState, x
		bpl	.jp0
		stz	shotState, x

		lda	shipX
		sta	shotX, x
		lda	shipX+1
		sta	shotX+1, x

		lda	shipY
		sta	shotY, x
		lda	shipY+1
		sta	shotY+1, x

		lda	shipZ
		sta	shotZ, x
		lda	shipZ+1
		sta	shotZ+1, x

		bra	.jp1

.jp0:		inx
		inx
		cpx	#shotMAX*2
		bne	.loop
.jp1:
		rts


;----------------------------
moveShot:
;
		clx

.loop:		lda	shotState, x
		bmi	.jp0

		clc
		lda	shotZ+1, x
		adc	#4
		sta	shotZ+1, x

		cmp	#$20
		bmi	.jp0

		lda	#$FF
		sta	shotState, x

.jp0:		inx
		inx
		cpx	#shotMAX*2
		bne	.loop

		rts


;----------------------------
setShotModel:
;
		clx

.loop:		lda	shotState, x
		bmi	.jp0

		lda	shotX, x
		sta	<translationX
		lda	shotX+1, x
		sta	<translationX+1

		lda	shotY, x
		sta	<translationY
		lda	shotY+1, x
		sta	<translationY+1

		lda	shotZ, x
		sta	<translationZ
		lda	shotZ+1, x
		sta	<translationZ+1

		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0
		mov	<rotationSelect, #$12

		movw	<modelAddr, #modelData000

		jsr	setModel2

.jp0:		inx
		inx
		cpx	#shotMAX*2
		bne	.loop

		rts


;----------------------------
vsyncFunction:
;The process here should be completed in a short time.
		jsr	getPadData

		dec	frameCount
		bne	.irqEnd

		lda	#60
		sta	frameCount

		lda	drawCountWork
		sta	drawCount
		stz	drawCountWork
.irqEnd:
		rts


;----------------------------
_irq1:
;IRQ1 interrupt process
;ACK interrupt
		pha
		phx
		phy

		cld

		jsr	irq1PolygonFunction

		ply
		plx
		pla
		rti


;----------------------------
_reset:
;reset process
		sei

		csh

		cld

		ldx	#$FF
		txs

		lda	#$FF
		tam	#$00

		lda	#$F8
		tam	#$01

		stz	$2000
		tii	$2000, $2001, $1FFF

		stz	TIMER_CONTROL_REG

;disable interrupts TIQD       IRQ2D
		lda	#$05
		sta	INTERRUPT_DISABLE_REG

;jump main
		jmp	main


;----------------------------
_irq2:
_timer:
_nmi:
;IRQ2 TIMER NMI interrupt process
		rti


;----------------------------
;Circle Enemy Shot
modelData003
		.dw	modelData003Polygon
		.db	1	;polygon count
		.dw	modelData003Vertex
		.db	1	;vertex count

modelData003Polygon
		;	attribute: circle($80 = circlre) + line skip($40 = skip) + front clip($04 = cancel) + back check($02 = cancel) + back draw($01 = not draw : front side = counterclockwise) 
		;	front color(0-63)
		;	back color(0-63) or circle radius(1-8192) low byte
		;	vertex count: count(3-4) or circle radius(1-8192) high byte
		;	vertex index 0,
		;	vertex index 1,
		;	vertex index 2,
		;	vertex index 3
		.db	%10000000, $03, $80, $00, 0*6, 0*6, 0*6, 0*6

modelData003Vertex
		.dw	   0,    0,   0


;----------------------------
;Circle blast
modelData004
		.dw	modelData004Polygon
		.db	1
		.dw	modelData004Vertex
		.db	1

modelData004Polygon
		.db	%11000000, $11, $00, $01, 0*6, 0*6, 0*6, 0*6

modelData004Vertex
		.dw	   0,    0,   0


;----------------------------
;Circle blast
modelData005
		.dw	modelData005Polygon
		.db	1
		.dw	modelData005Vertex
		.db	1

modelData005Polygon
		.db	%11000000, $11, $80, $00, 0*6, 0*6, 0*6, 0*6

modelData005Vertex
		.dw	   0,    0,   0


;----------------------------
;Circle blast
modelData006
		.dw	modelData006Polygon
		.db	1
		.dw	modelData006Vertex
		.db	1

modelData006Polygon
		.db	%11000000, $11, $40, $00, 0*6, 0*6, 0*6, 0*6

modelData006Vertex
		.dw	   0,    0,   0


;----------------------------
;Shot
modelData000
		.dw	modelData000Polygon
		.db	2
		.dw	modelData000Vertex
		.db	6

modelData000Polygon
		.db	%00000010, $0C, $00, $03, 0*6, 2*6, 1*6, 0*6
		.db	%00000010, $0C, $00, $03, 3*6, 5*6, 4*6, 0*6

modelData000Vertex
		.dw	-128, -32,   0
		.dw	-128,   0, 256
		.dw	-128,  32,   0
		.dw	 128, -32,   0
		.dw	 128,   0, 256
		.dw	 128,  32,   0


;----------------------------
;Enemy
modelData001
		.dw	modelData001Polygon
		.db	6
		.dw	modelData001Vertex
		.db	10

modelData001Polygon
		.db	%00000001, $19, $00, $03, 0*6, 2*6, 1*6, 0*6
		.db	%00000001, $1A, $00, $03, 0*6, 1*6, 3*6, 0*6
		.db	%00000001, $1B, $00, $03, 0*6, 3*6, 2*6, 0*6
		.db	%00000001, $1C, $00, $03, 3*6, 1*6, 2*6, 0*6
		.db	%00000010, $02, $00, $03, 4*6, 6*6, 5*6, 0*6
		.db	%00000010, $02, $00, $03, 7*6, 9*6, 8*6, 0*6

modelData001Vertex
		.dw	   0,   0,  128
		.dw	-128,   0,    0
		.dw	 128,   0,    0
		.dw	   0, 128,    0

		.dw	-128,   0,  256
		.dw	-128, 128, -256
		.dw	-128,-128, -256

		.dw	 128,   0,  256
		.dw	 128,-128, -256
		.dw	 128, 128, -256


;----------------------------
;Rock
modelData002
		.dw	modelData002Polygon
		.db	4
		.dw	modelData002Vertex
		.db	5

modelData002Polygon
		.db	%00000001, $1A, $00, $03, 0*6, 4*6, 1*6, 0*6
		.db	%00000001, $19, $00, $03, 1*6, 4*6, 2*6, 0*6
		.db	%00000001, $1B, $00, $03, 2*6, 4*6, 3*6, 0*6
		.db	%00000001, $1C, $00, $03, 3*6, 4*6, 0*6, 0*6

modelData002Vertex
		.dw	 -96, 192,    0
		.dw	 212, 144,    0
		.dw	   0,-240,    0
		.dw	-384, -96,    0

		.dw	  48, -48, -192


;----------------------------
vramClearData:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
polyLineColor0:
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF


;----------------------------
polyLineColor1:
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF


;----------------------------
polyLineColor2:
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF


;----------------------------
polyLineColor3:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $AA, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $FF, $FF, $FF, $FF


;----------------------------
paletteData:
;0000000G GGRRRBBB
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
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
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
		.org	$A000

;----------------------------
signExt:
;a(sign extension) = a
		cmp	#$00
		bpl	.convPositive
		lda	#$FF
		rts
.convPositive:
		cla
		rts


;----------------------------
sdiv32:
;div16d:div16c / div16a = div16a div16b
;push x
		phx
;push y
		phy

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
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1

		cla
		sbc	<mul16d
		sta	<mul16d

		cla
		sbc	<mul16d+1
		sta	<mul16d+1

.sdiv16jp00:
;a sign
		bbr7	<div16a+1, .sdiv16jp01

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.sdiv16jp01:

		jsr	udiv32

;anser sign
		pla
		bpl	.sdiv16jp02

;anser neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16a

		cla
		sbc	<mul16c+1
		sta	<mul16a+1

		bra	.sdiv16jp04

.sdiv16jp02:
		lda	<div16c
		sta	<div16a
		lda	<div16c+1
		sta	<div16a+1

.sdiv16jp04:
;remainder sign
		pla
		bpl	.sdiv16jp03

;remainder neg
		sec
		cla
		sbc	<mul16b
		sta	<mul16b

		cla
		sbc	<mul16b+1
		sta	<mul16b+1

.sdiv16jp03:
;pull y
		ply
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

;a eor b sign
		lda	<mul16a+1
		eor	<mul16b+1
		pha

;a sign
		bbr7	<mul16a+1, .smul16jp00

;a neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

.smul16jp00:
;b sign
		bbr7	<mul16b+1, .smul16jp01

;b neg
		sec
		cla
		sbc	<mul16b
		sta	<mul16b

		cla
		sbc	<mul16b+1
		sta	<mul16b+1


.smul16jp01:
		jsr	umul16

;anser sign
		pla
		bpl	.smul16jp02

;anser neg
		sec
		cla
		sbc	<mul16c
		sta	<mul16c

		cla
		sbc	<mul16c+1
		sta	<mul16c+1

		cla
		sbc	<mul16d
		sta	<mul16d

		cla
		sbc	<mul16d+1
		sta	<mul16d+1

.smul16jp02:
		rts


;----------------------------
umul16:
;mul16d:mul16c = mul16a * mul16b
;push y
		phy

;save MPR2 data
		tma	#$02
		sta	saveMPR2Data

		lda	<mul16b
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#muldatBank
		tam	#$02

		lda	<mul16b
		and	#$0F
		asl	a
		clc
		adc	#$40
		stz	<mulAddr
		sta	<mulAddr+1

		ldy	<mul16a
		lda	[mulAddr], y
		sta	<mul16c

		ldy	<mul16a+1
		lda	[mulAddr], y
		sta	<mul16c+1

		inc	<mulAddr+1

		clc
		ldy	<mul16a
		lda	[mulAddr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[mulAddr], y
		adc	#0
		sta	<mul16d

		lda	<mul16b+1
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#muldatBank
		tam	#$02

		lda	<mul16b+1
		and	#$0F
		asl	a
		clc
		adc	#$40
		sta	<mulAddr+1

		ldy	<mul16a
		lda	[mulAddr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[mulAddr], y
		adc	<mul16d
		sta	<mul16d

		cla
		adc	#0
		sta	<mul16d+1

		inc	<mulAddr+1

		ldy	<mul16a
		lda	[mulAddr], y
		adc	<mul16d
		sta	<mul16d

		ldy	<mul16a+1
		lda	[mulAddr], y
		adc	<mul16d+1
		sta	<mul16d+1

;set MPR2 data
		lda	saveMPR2Data
		tam	#$02

;pull y
		ply
		rts


;----------------------------
initializePad:
;
		stz	<padLast
		stz	<padNow
		stz	<padState
		rts


;----------------------------
getPadData:
;
		lda	<padNow
		sta	<padLast

		lda	#$01
		sta	IO_REG
		lda	#$03
		sta	IO_REG

		lda	#$01
		sta	IO_REG

		pha
		pla
		nop

		lda	IO_REG
		asl	a
		asl	a
		asl	a
		asl	a
		sta	<padNow

		lda	#$00
		sta	IO_REG
		lda	IO_REG
		and	#$0F
		ora	<padNow
		eor	#$FF
		sta	<padNow

		lda	<padLast
		eor	#$FF
		and	<padNow
		sta	<padState

;get pad data end
		rts


;----------------------------
selectVertexRotation:
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
;x=xcosA-ysinA	y=xsinA+ycosA	z=z
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		jeq	.vertexRotationZEnd

		lda	<vertexCount
		jeq	.vertexRotationZEnd

		lda	sinDataLow,x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh,x
		sta	<vertexRotationSin+1

		txa
		clc
		adc	#64
		tax
		lda	sinDataLow,x			;cos
		sta	<vertexRotationCos
		lda	sinDataHigh,x
		sta	<vertexRotationCos+1

		ldx	<vertexCount

		cly

.vertexRotationZLoop:
;----------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;xcosA

		movq	<work8a, <mul16c

		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;ysinA

		subq	<mul16c, <work8a, <mul16c	;xcosA-ysinA

		lda	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	a
		asl	<mul16c+1
		rol	<mul16d
		rol	a

		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;xsinA

		movq	<work8a, <mul16c

		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;ycosA

		addq	<mul16c, <work8a, <mul16c	;xsinA+ycosA

		lda	<mul16d
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1

		sta	transform2DWork0+2, y
		lda	<mul16d+1
		sta	transform2DWork0+3, y


;----------------
		pla
		sta	transform2DWork0, y
		pla
		sta	transform2DWork0+1, y

;----------------
		lda	intTable+6, y
		tay

		dex
		jne	.vertexRotationZLoop

.vertexRotationZEnd:
		ply
		plx

		rts


;----------------------------
vertexRotationY:
;x=xcosA-zsinA	y=y		z=xsinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		jeq	.vertexRotationYEnd

		lda	<vertexCount
		jeq	.vertexRotationYEnd

		lda	sinDataLow,x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh,x
		sta	<vertexRotationSin+1

		txa
		clc
		adc	#64
		tax
		lda	sinDataLow,x			;cos
		sta	<vertexRotationCos
		lda	sinDataHigh,x
		sta	<vertexRotationCos+1

		ldx	<vertexCount

		cly

.vertexRotationYLoop:
;----------------
		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;zsinA

		movq	<work8a, <mul16c

		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;xcosA

		subq	<mul16c, <mul16c, <work8a	;xcosA-zsinA

		lda	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	a
		asl	<mul16c+1
		rol	<mul16d
		rol	a

		pha
		lda	<mul16d
		pha

;----------------------------
		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;zcosA

		movq	<work8a, <mul16c

		lda	transform2DWork0, y		;X0
		sta	<mul16a
		lda	transform2DWork0+1, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;xsinA

		addq	<mul16c, <work8a, <mul16c	;zcosA+xsinA

		lda	<mul16d
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1

		sta	transform2DWork0+4, y
		lda	<mul16d+1
		sta	transform2DWork0+5, y

;----------------
		pla
		sta	transform2DWork0, y
		pla
		sta	transform2DWork0+1, y

;----------------
		lda	intTable+6, y
		tay

		dex
		jne	.vertexRotationYLoop

.vertexRotationYEnd:
		ply
		plx

		rts


;----------------------------
vertexRotationX:
;x=x		y=ycosA+zsinA	z=-ysinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		phx
		phy

		cpx	#0
		jeq	.vertexRotationXEnd

		lda	<vertexCount
		jeq	.vertexRotationXEnd

		lda	sinDataLow,x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh,x
		sta	<vertexRotationSin+1

		txa
		clc
		adc	#64
		tax
		lda	sinDataLow,x			;cos
		sta	<vertexRotationCos
		lda	sinDataHigh,x
		sta	<vertexRotationCos+1

		ldx	<vertexCount

		cly

.vertexRotationXLoop:
;----------------
		lda	transform2DWork0+2, y		;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;ycosA

		movq	<work8a, <mul16c

		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;zsinA

		addq	<mul16c, <work8a, <mul16c	;ycosA+zsinA

		lda	<mul16d+1
		asl	<mul16c+1
		rol	<mul16d
		rol	a
		asl	<mul16c+1
		rol	<mul16d
		rol	a

		pha
		lda	<mul16d
		pha

;----------------
		lda	transform2DWork0+2, y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationSin	;sin

		jsr	smul16				;ysinA

		movq	<work8a, <mul16c

		lda	transform2DWork0+4, y		;Z0
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

		movw	<mul16b, <vertexRotationCos	;cos

		jsr	smul16				;zcosA

		subq	<mul16c, <mul16c, <work8a 	;-ysinA+zcosA

		lda	<mul16d
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1
		asl	<mul16c+1
		rol	a
		rol	<mul16d+1

		sta	transform2DWork0+4, y
		lda	<mul16d+1
		sta	transform2DWork0+5, y

;----------------
		pla
		sta	transform2DWork0+2, y
		pla
		sta	transform2DWork0+3, y

;----------------
		lda	intTable+6, y
		tay

		dex
		jne	.vertexRotationXLoop

.vertexRotationXEnd:
		ply
		plx

		rts


;----------------------------
vertexTranslation2:
;
		phy

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

		lda	intTable+6, y
		tay

		dec	<vertexCountWork
		bne	.vertexTranslation2Loop

.vertexTranslation2End:
		ply

		rts


;----------------------------
transform2D2:
;
		phx
		phy

;save MPR2 data
		tma	#$02
		sta	saveMPR2Data

		ldx	<vertexCount
		cly

.transform2D2Loop0:
;Z0 < 128 check
		sec
		lda	transform2DWork0+4, y	;Z0
		sta	transform2DWork1+4, y
		sbc	#128
		lda	transform2DWork0+5, y
		sta	transform2DWork1+5, y
		sbc	#00

		bpl	.transform2D2Jump05
		jmp	.transform2D2Jump00

.transform2D2Jump05:
;X0 to mul16c
		lda	transform2DWork0, y
		sta	transform2DWork1, y
		sta	<mul16c
		lda	transform2DWork0+1, y
		sta	transform2DWork1+1, y
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
		sta	transform2DWork1+2, y
		sta	<mul16c
		lda	transform2DWork0+3, y
		sta	transform2DWork1+3, y
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4, y
		sta	<mul16a
		lda	transform2DWork0+5, y
		sta	<mul16a+1

;Y0*128/Z0
		jsr	transform2DProc

;centerY-Y0*128/Z0
;centerY-mul16a to Y0
		sec
		lda	<centerY
		sbc	<mul16a
		sta	transform2DWork0+2, y	;Y0
		lda	<centerY+1
		sbc	<mul16a+1
		sta	transform2DWork0+3, y

		jmp	.transform2D2Jump01

.transform2D2Jump00:
		lda	transform2DWork0, y
		sta	transform2DWork1, y
		lda	transform2DWork0+1, y
		sta	transform2DWork1+1, y

		lda	transform2DWork0+2, y
		sta	transform2DWork1+2, y
		lda	transform2DWork0+3, y
		sta	transform2DWork1+3, y

;Z0<128 flag set
		lda	#$00
		sta	transform2DWork0+4, y
		lda	#$80
		sta	transform2DWork0+5, y

.transform2D2Jump01:
		lda	intTable+6, y
		tay

		dex
		jne	.transform2D2Loop0

;set MPR2 data
		lda	saveMPR2Data
		tam	#$02

		ply
		plx

		rts


;----------------------------
transform2DProc:
;mul16a(rough value) = (mul16c(-32768_32767) * 128 / mul16a(1_32767))
;push x
		phx
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

;get div data
		lda	<div16a+1
		tay
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#divdatBank
		tax
		tam	#$02

		tya
		and	#$1F
		clc
		adc	#$40
		sta	<mulAddr+1

		ldy	<div16a
		lda	[mulAddr], y
		sta	<work8a

		clc
		txa
		adc	#4		;carry clear
		tam	#$02

		lda	[mulAddr], y
		sta	<work8a+1

		txa
		adc	#8		;carry clear
		tam	#$02

		lda	[mulAddr], y
		sta	<work8a+2

;mul mul16c low byte
		lda	<mul16c
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#muldatBank
		tam	#$02

		lda	<mul16c
		and	#$0F
		asl	a
		clc
		adc	#$40
		stz	<mulAddr
		sta	<mulAddr+1

		ldy	<work8a
		lda	[mulAddr], y
		sta	<work8b

		ldy	<work8a+1
		lda	[mulAddr], y
		sta	<work8b+1

		ldy	<work8a+2
		lda	[mulAddr], y
		sta	<work8b+2

		inc	<mulAddr+1

		ldx	#LOW(work8b)+1
		ldy	<work8a
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+1
		set
		adc	[mulAddr], y

		ldy	<work8a+2
		lda	[mulAddr], y
		adc	#0		;carry clear
		sta	<work8b+3

;mul mul16c high byte
		lda	<mul16c+1
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#muldatBank
		tam	#$02

		lda	<mul16c+1
		and	#$0F
		asl	a
		clc
		adc	#$40
		sta	<mulAddr+1

		ldx	#LOW(work8b)+1
		ldy	<work8a
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+1
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+2
		set
		adc	[mulAddr], y

		inc	<mulAddr+1

		ldx	#LOW(work8b)+2
		ldy	<work8a
		clc
		set
		adc	[mulAddr], y

		inx
		ldy	<work8a+1
		set
		adc	[mulAddr], y

		movw	<mul16a, <work8b+2

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
;pull x
		plx

		rts


;----------------------------
moveToTransform2DWork0:
;vertex0Addr to Transform2DWork0

		phy

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
		ply

		rts


;----------------------------
putPolygonBuffer:
;
		phx
		phy

;save MPR2 data
		tma	#$02
		sta	saveMPR2Data

;set polygon procedure bank
		lda	#polygonProcBank
		tam	#$02

;+32 vsync
		st012	#$05, #$0808

		movw	<polyBufferAddr, polyBufferStart

.putPolyBufferLoop0:
		ldy	#4
		lda	[polyBufferAddr], y	;COLOR

		pha
		sta	<polyAttribute
		and	#$3F
		clc
		adc	<polyLineColorIndex

		tax
		lda	polyLineColorP0, x
		sta	polyLineColorWork_H_P0
		sta	polyLineColorWork_L_P0
		rol	a
		rol	polyLineColorWork_L_P0

		lda	polyLineColorP1, x
		sta	polyLineColorWork_H_P1
		sta	polyLineColorWork_L_P1
		rol	a
		rol	polyLineColorWork_L_P1

		lda	polyLineColorP2, x
		sta	polyLineColorWork_H_P2
		sta	polyLineColorWork_L_P2
		rol	a
		rol	polyLineColorWork_L_P2

		lda	polyLineColorP3, x
		sta	polyLineColorWork_H_P3
		sta	polyLineColorWork_L_P3
		rol	a
		rol	polyLineColorWork_L_P3

		pla
		bpl	.polygonProc

;circle process
		ldy	#6
		lda	[polyBufferAddr], y	;X
		sta	<circleCenterX

		iny
		lda	[polyBufferAddr], y
		sta	<circleCenterX+1

		iny
		lda	[polyBufferAddr], y	;Y
		sta	<circleCenterY

		iny
		lda	[polyBufferAddr], y
		sta	<circleCenterY+1

		iny
		lda	[polyBufferAddr], y	;RADIUS
		sta	<circleRadius

		iny
		lda	[polyBufferAddr], y
		sta	<circleRadius+1

		jsr	initCalcEdge
		jsr	calcCircle
		jsr	putPolyLine

		bra	.nextData

.polygonProc:
		ldy	#5
		lda	[polyBufferAddr], y	;COUNT
		beq	.putPolyBufferEnd

		sta	<clip2D0Count
		pha
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

.nextData:
		ldy	#0
		lda	[polyBufferAddr], y
		tax
		iny
		lda	[polyBufferAddr], y
		sta	<polyBufferAddr+1
		stx	<polyBufferAddr+0

		jmp	.putPolyBufferLoop0

.putPolyBufferEnd:
;+1 vsync
		st012	#$05, #$0008


;set MPR2 data
		lda	saveMPR2Data
		tam	#$02

		ply
		plx

		rts


;----------------------------
setModel2:
;
		phx
		phy
;rotation
		ldy	#$03
		lda	[modelAddr], y		;vertex data address
		sta	<vertex0Addr
		iny
		lda	[modelAddr], y
		sta	<vertex0Addr+1

		iny
		lda	[modelAddr], y		;vertex count
		sta	<vertexCount

		jsr	moveToTransform2DWork0

		lda	<rotationSelect
		and	#3
		jsr	selectVertexRotation

		lda	<rotationSelect
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation

		lda	<rotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation

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
		jsr	selectVertexRotation

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation

		lda	<eyeRotationSelect
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		and	#3
		jsr	selectVertexRotation

;transform2D
		jsr	transform2D2

		jsr	setModelProc2

		ply
		plx

		rts


;----------------------------
setModelProc2:
;
		cly
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

		lda	[modelAddrWork], y	;ModelData Attribute
		sta	<setModelAttr

		iny
		lda	[modelAddrWork], y	;ModelData Front Color
		sta	<setModelFrontColor

		iny
		lda	[modelAddrWork], y	;ModelData Back Color
		sta	<setModelBackColor

		iny
		lda	[modelAddrWork], y	;ModelData Count
		sta	<setModelCount

		bbr7	<setModelAttr, .polygonProc

;circle process
		iny
		lda	[modelAddrWork], y
		tax
		lda	transform2DWork0+5, x	;Z0<128 flag
		jmi	.setModelJump0

;SAMPLE Z
		ldy	#2
		lda	transform2DWork0+4, x
		sta	[polyBufferAddr], y
		sta	<mul16a

		iny
		lda	transform2DWork0+5, x
		sta	[polyBufferAddr], y
		sta	<mul16a+1

		lda	<setModelBackColor
		sta	<mul16c
		lda	<setModelCount
		sta	<mul16c+1

		jsr	transform2DProc

		lda	<mul16a
		jeq	.setModelJump0

		sta	clip2D0+8		;RADIUS
		mov	clip2D0+10, <mul16a+1

		ldy	#5
		lda	#$FF
		sta	[polyBufferAddr], y	;COUNT

		ldy	#4
		lda	<setModelFrontColor
		ora	#$80
		bbr6	<setModelAttr, .circleJp0
		ora	#$40
.circleJp0:
		sta	[polyBufferAddr], y	;COLOR

		lda	transform2DWork0+0, x	;X
		sta	clip2D0
		lda	transform2DWork0+1, x
		sta	clip2D0+2

		lda	transform2DWork0+2, x	;Y
		sta	clip2D0+4
		lda	transform2DWork0+3, x
		sta	clip2D0+6

		mov	<clip2D0Count, #3

		jmp	.setBuffer

.polygonProc:
		lda	<setModelCount

;push setModelCount for initialize front clip calculation
		pha

		iny
		lda	[modelAddrWork], y
		sta	<frontClipDataWork

		stz	<model2DClipIndexWork

		stz	<frontClipCount

		stz	<polyBufferZ0Work0
		stz	<polyBufferZ0Work0+1

;push ModelData index for initialize front clip calculation
		phy

;check front clip
.setModelLoop5:
		lda	[modelAddrWork], y
		tax
		lda	transform2DWork0+5, x	;Z0<128 flag
		bmi	.setModelJump7

		phy

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

;check Z sample
		sec
		lda	<polyBufferZ0Work0
		sbc	transform2DWork0+4, x
		lda	<polyBufferZ0Work0+1
		sbc	transform2DWork0+5, x

		bpl	.setModelJump9

		lda	transform2DWork0+4, x
		sta	<polyBufferZ0Work0
		lda	transform2DWork0+5, x
		sta	<polyBufferZ0Work0+1

.setModelJump9:
		sty	<model2DClipIndexWork

		ply

		iny

		dec	<setModelCount
		bne	.setModelLoop5

		ply
		pla

		bra	.setModelJump8

;initialize front clip calculation
.setModelJump7:
		ply
		pla
		dec	a
		sta	<setModelCount

		stz	<model2DClipIndexWork

		stz	<polyBufferZ0Work0
		stz	<polyBufferZ0Work0+1

;cancel front clip calculation
		bbr2	<setModelAttr, .setModelLoop4
		jmp	.setModelJump0

;front clip calculation
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

.setModelJump8:
		sta	<clip2D0Count
		jsr	clip2D
		jeq	.setModelJump0

;cancel back side check
		bbs1	<setModelAttr, .setModelJump2

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

		movq	<work8a, <mul16c

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

		cmpq2	<work8a, <mul16c
		bmi	.setModelJump2

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
		bbr6	<setModelAttr, .setModelJump10
		ora	#$40

.setModelJump10:
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
.setBuffer:
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
		plx
		ldy	intTable+8, x

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

;centerY-mul16a
		subw	<clipFrontY, <centerY, <mul16a


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
		cmpw2	<polyBufferZ0Work0, <polyBufferZ0Work1

		bpl	.clipFrontJump9

		movw	<polyBufferZ0Work0, <polyBufferZ0Work1

.clipFrontJump9:
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

		lda	intTable+4, x
		tax

		dey
		bne	.loop0

		clx
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
		ldx	#$FF
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

		lda	intTable+4, y
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

		lda	intTable+8, y
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

		lda	intTable+4, y
		tay

.clip2DX255Jump03:
;X0>255 X1>255
		lda	intTable+4, x
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

		lda	intTable+4, y
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

		lda	intTable+8, y
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

		lda	intTable+4, y
		tay

.clip2DX0Jump03:
;X0<0 X1<0
		lda	intTable+4, x
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

		lda	intTable+4, y
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

		lda	intTable+8, y
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

		lda	intTable+4, y
		tay

.clip2DY255Jump03:
;Y0>191 Y1>191
		lda	intTable+4, x
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

		lda	intTable+4, y
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

		lda	intTable+8, y
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

		lda	intTable+4, y
		tay

.clip2DY0Jump03:
;Y0<0 Y1<0
		lda	intTable+4, x
		tax

		dec	<clip2D0Count
		jne	.clip2DY0Loop0

		rts


;----------------------------
getAngle:
;
		phx
		phy

		subw	<mul16a, <angleZ1, <angleZ0
		subw	<mul16b, <angleX1, <angleX0
		jsr	atan

		tax
		eor	#$FF
		inc	a
		sta	<ansAngleY

		subw	transform2DWork0, <angleX1, <angleX0
		subw	transform2DWork0+2, <angleY1, <angleY0
		subw	transform2DWork0+4, <angleZ1, <angleZ0
		mov	vertexCount, #1
		jsr	vertexRotationY

		movw	<mul16a, transform2DWork0+4
		movw	<mul16b, transform2DWork0+2
		jsr	atan
		sta	<ansAngleX

		ply
		plx
		rts


;----------------------------
atan:
;mul16a = x(-32768_32767), mul16b = y(-32768_32767)
;A(0_255) = atan(y/x)
		phx

		lda	<mul16b+1
		pha
		bpl	.atanJump0

		sec
		lda	<mul16b
		eor	#$FF
		adc	#0
		sta	<mul16b

		lda	<mul16b+1
		eor	#$FF
		adc	#0
		sta	<mul16b+1

.atanJump0:
		lda	<mul16a+1
		pha
		bpl	.atanJump1

		sec
		lda	<mul16a
		eor	#$FF
		adc	#0
		sta	<mul16a

		lda	<mul16a+1
		eor	#$FF
		adc	#0
		sta	<mul16a+1

.atanJump1:
		jsr	_atan

		plx
		bpl	.atanJump2

		eor	#$FF
		inc	a
		eor	#$80

.atanJump2:
		plx
		bpl	.atanJump3

		eor	#$FF
		inc	a

.atanJump3:
		plx
		rts


;----------------------------
_atan:
;mul16a = x(0_65535), mul16b = y(0_65535)
;A(0_63) = atan(y/x)
		phx

		lda	<mul16a
		ora	<mul16a+1
		beq	.atanJump0

		stz	<mul16c

		lda	<mul16b
		sta	<mul16c+1

		lda	<mul16b+1
		sta	<mul16d

		stz	<mul16d+1

		asl	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		sec
		lda	<mul16d
		sbc	<mul16a
		lda	<mul16d+1
		sbc	<mul16a+1
		bcs	.atanJump0

		jsr	udiv32

		clx
.atanLoop:
		sec
		lda	atanDataLow, x
		sbc	<div16a
		lda	atanDataHigh, x
		sbc	<div16a+1
		bcs	.atanJump1

		inx
		cpx	#64
		bne	.atanLoop

.atanJump1:
		txa
		bra	.atanEnd

.atanJump0:
		lda	#64

.atanEnd:
		plx
		rts


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
.vdcdataloop:	lda	vdcData, y
		cmp	#$FF
		beq	.vdcdataend
		sta	VDC1_0
		sta	VDC2_0
		iny

		lda	vdcData, y
		sta	VDC1_2
		sta	VDC2_2
		iny

		lda	vdcData, y
		sta	VDC1_3
		sta	VDC2_3
		iny
		bra	.vdcdataloop
.vdcdataend:

;262Line  VCE Clock 5MHz
		movw	VCE_0, #$0004

;vsync
;+1
		mov	VDC1_0, #$05
		movw	VDC1_2, #$0008

.resetWait:
		tst	#$20, VDC1_0
		beq	.resetWait

		rts


;----------------------------
setBat:
;set BAT
		mov	VDC1_0, #$00
		movw	VDC1_2, #$0000
		mov	VDC1_0, #$02

		mov	VDC2_0, #$00
		movw	VDC2_2, #$0000
		mov	VDC2_0, #$02

		movw	setBatWork, #$0200
.clearbatloop0:
		movw	VDC1_2, setBatWork

		movw	VDC2_2, setBatWork

		addw	setBatWork, #$0002
		cmpw2	setBatWork, #$0200+$0300
		bcc	.clearbatloop0

		movw	setBatWork, #$0201
.clearbatloop1:
		movw	VDC1_2, setBatWork

		movw	VDC2_2, setBatWork

		addw	setBatWork, #$0002
		cmpw2	setBatWork, #$0201+$0300
		bcc	.clearbatloop1

		clx
.clearbatloop2:
		movw	VDC1_2, #$0100

		movw	VDC2_2, #$0100

		inx
		bne	.clearbatloop2

		rts


;----------------------------
irq1PolygonFunction:
;
		lda	VDC1_0
		sta	<vdp1Status
		lda	VDC2_0
		sta	<vdp2Status

		ora	<vdp1Status
		sta	<vdpStatus

.vramDmaCheck:
		bbr4	<vdpStatus, .satbDmaCheck

;clear vsyncFlag
		stz	<vsyncFlag

		jmp	.vsyncProcEnd

.satbDmaCheck:
		bbr3	<vdpStatus, .vsyncCheck
		smb6	<vsyncFlag

.vsyncCheck:
;vsync flag check
		lda	<vsyncFlag
		cmp	#$C0
		jne	.vsyncProcEnd

.vsyncProc:
		lda	<selectVdc
		cmp	#VDC2
		beq	.vdc2Jp

;display VDC1, hide VDC2
;VDC1 on, VDC2 off
		lda	#$11
		sta	VPC_0
		sta	VPC_1

;VDC1
;+1 bg sp
		st012	#$05, #$00C0

;set VDC2 to VPC_6
		mov	VPC_6, #$01

;VDC2
;+1 vsync
		st012	#$05, #$0008

;clear VRAM
;VDC2 VRAM_VRAM DMA
		st012	#$10, #$5000		;set DMA src
		st012	#$11, #$2000		;set DMA dist
		st012	#$12, #$3000		;set DMA count

;change selectVdc
		mov 	<selectVdc, #VDC2

		bra	.vsyncProcEnd

.vdc2Jp:
;hide VDC1, display VDC2
;VDC1 off, VDC2 on
		lda	#$22
		sta	VPC_0
		sta	VPC_1

;VDC2
;+1 bg sp
		st012	#$05, #$00C0

;set VDC1 to VPC_6
		stz	VPC_6

;VDC1
;+1 vsync
		st012	#$05, #$0008

;clear VRAM
;VDC1 VRAM_VRAM DMA
		st012	#$10, #$5000		;set DMA src
		st012	#$11, #$2000		;set DMA dist
		st012	#$12, #$3000		;set DMA count

;change selectVdc
		mov	<selectVdc, #VDC1

.vsyncProcEnd:
		bbr5	<vdpStatus, .procEnd

;call vsync function
		jsr	vsyncFunction

.procEnd:
		rts


;----------------------------
clearSatbBuffer:
;don't block interruptions.
		clx
.loop0:
		stz	satbBuffer, x
		stz	satbBuffer+1, x
		stz	satbBuffer+2, x
		stz	satbBuffer+3, x
		stz	satbBuffer+4, x
		stz	satbBuffer+5, x
		stz	satbBuffer+6, x
		stz	satbBuffer+7, x

		stz	satbBuffer+256, x
		stz	satbBuffer+256+1, x
		stz	satbBuffer+256+2, x
		stz	satbBuffer+256+3, x
		stz	satbBuffer+256+4, x
		stz	satbBuffer+256+5, x
		stz	satbBuffer+256+6, x
		stz	satbBuffer+256+7, x

		lda	intTable+8, x
		tax
		bne	.loop0

		movw	satbBufferAddr, #satbBuffer

		rts


;----------------------------
setSatbBuffer:
;
;argw0:Y, argw1:X, argw2:address, argw3:attribute
		phy

		cmpw2	satbBufferAddr, #satbBuffer+512
		bcs	.setEnd

		cly
.loop:
		lda	argw0, y
		sta	[satbBufferAddr], y

		iny
		cpy	#8
		bne	.loop

		addw	satbBufferAddr, #8

.setEnd:
		ply

		rts


;----------------------------
initializeSatb:
;initialize SATB
		mov	VDC1_0, #$00
		movw	VDC1_2, #$1000
		mov	VDC1_0, #$02

		mov	VDC2_0, #$00
		movw	VDC2_2, #$1000
		mov	VDC2_0, #$02

		clx
.spClear:
		stzw	VDC1_2
		stzw	VDC2_2
		inx
		bne	.spClear

;VDC1
;VRAM-SATB transfer interrupt enable
;VRAM-VRAM transfer interrupt enable
		mov	VDC1_0, #$0F
		movw	VDC1_2, #$0003

;VRAM ADDR
		mov	VDC1_0, #$13
		movw	VDC1_2, #$0400

;VDC2
;VRAM-SATB transfer interrupt enable
;VRAM-VRAM transfer interrupt enable
		mov	VDC2_0, #$0F
		movw	VDC2_2, #$0003

;VRAM ADDR
		mov	VDC2_0, #$13
		movw	VDC2_2, #$0400

		rts


;----------------------------
initializeVpc:
;initialize VPC
		lda	#$33
		sta	VPC_0
		sta	VPC_1

		stz	VPC_2
		stz	VPC_3
		stz	VPC_4
		stz	VPC_5

		stz	VPC_6

		rts


;----------------------------
initializePolygonBuffer:
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
initScreenVsync:
;initialize Vsync, auto-Increment
;display VDC1, hide VDC2
;VDC1 on, VDC2 off
		lda	#$11
		sta	VPC_0
		sta	VPC_1

;VDC1
;+1 bg sp
		mov	VDC1_0, #$05
		movw	VDC1_2, #$00C0

;set VDC2 to VPC_6
		mov	VPC_6, #$01

;VDC2
;+1  vsync
		mov	VDC2_0, #$05
		movw	VDC2_2, #$0008

		mov	<selectVdc, #VDC2

		stz	<vsyncFlag

		rts


;----------------------------
waitScreenVsync:
;Access to VRAM should be done after this function.
.waitloop0:
		bbs7	<vsyncFlag, .waitloop0

		rts


;----------------------------
setSatbDma:
;
		lda	<selectVdc
		cmp	#VDC2
		beq	.vdc2SatbDma

;VDC1
;set vram addr
		st012	#$00, #$0400

;transfer satb to VRAM
		st0	#$02
		tia	satbBuffer, VDC1_2, 512

;set VRAM_SATB DMA
		st012	#$13, #$0400

		bra	.satbDmaEnd

.vdc2SatbDma:
;VDC2
;set vram addr
		st012	#$00, #$0400

;transfer satb to VRAM
		st0	#$02
		tia	satbBuffer, VDC2_2, 512

;set VRAM_SATB DMA
		st012	#$13, #$0400

.satbDmaEnd:
		rts


;----------------------------
setVsyncFlag:
;
		smb7	<vsyncFlag
		rts


;----------------------------
initRandom:
;
		lda	#$C0
		sta	randomSeed
		sta	randomSeed+1
		rts


;----------------------------
getRandom:
;
		lda	randomSeed+1
		lsr	a
		rol	randomSeed
		bcc	.getrandomJump
		eor	#$B4
.getrandomJump:
		sta	randomSeed+1
		eor	randomSeed

		rts


;----------------------------
numToChar:
;in  A Register $0 to $F
;out A Register '0'-'9'($30-$39) 'A'-'Z'($41-$5A)
		sed
		clc
		adc	#$90
		adc	#$40
		cld

		rts


;----------------------------
_putChar:
;
		pha

		lda	<selectVdc
		cmp	#VDC2
		beq 	.vdc_2

.vdc_1:
		mov	VDC1_0, #$00
		movw	VDC1_2, putCharAddr

		mov	VDC1_0, #$02
		lda	putCharData
		sta	VDC1_2
		lda	putCharData+1
		ora	putCharAttr
		sta	VDC1_3

		bra	.putCharEnd

.vdc_2:
		mov	VDC2_0, #$00
		movw	VDC2_2, putCharAddr

		mov	VDC2_0, #$02
		lda	putCharData
		sta	VDC2_2
		lda	putCharData+1
		ora	putCharAttr
		sta	VDC2_3

.putCharEnd:
		pla

		rts


;----------------------------
_putCharAddr:
;
		pha

		stz	putCharAddr
		sty	putCharAddr+1

		lsr	putCharAddr+1
		ror	putCharAddr
		lsr	putCharAddr+1
		ror	putCharAddr
		lsr	putCharAddr+1
		ror	putCharAddr

		txa
		ora	putCharAddr
		sta	putCharAddr

		pla

		rts


;----------------------------
putChar:
;
		pha

		sta	putCharData
		lda	#$01
		ora	putCharAttr
		sta	putCharData+1

		jsr	_putCharAddr
		jsr	_putChar

		pla

		rts


;----------------------------
putHex:
;
		pha
		phx
		phy

		pha

		lsr	a
		lsr	a
		lsr	a
		lsr	a
		jsr	numToChar

		jsr	putChar

		pla

		and	#$0F
		jsr	numToChar

		inx
		jsr	putChar

		ply
		plx
		pla

		rts


;----------------------------
vdcData:
		.db	$05, $00, $00	;+1 bgoff spoff
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
intTable:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,\
			$10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F,\
			$20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F,\
			$30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F,\
			$40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F,\
			$50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F,\
			$60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F,\
			$70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $7C, $7D, $7E, $7F,\
			$80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F,\
			$90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F,\
			$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF,\
			$B0, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF,\
			$C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF,\
			$D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF,\
			$E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF,\
			$F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7, $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF

		.db	$00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,\
			$10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F


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
atanDataHigh:
;tan(a + 0.5) * 512
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $04, $04, $04,\
			$05, $05, $05, $06, $06, $07, $08, $09, $0A, $0C, $0E, $12, $17, $20, $36, $A2


;----------------------------
atanDataLow:
;tan(a + 0.5) * 512
		.db	$06, $13, $1F, $2C, $39, $46, $52, $5F, $6C, $7A, $87, $94, $A2, $B0, $BE, $CD,\
			$DB, $EB, $FA, $0A, $1A, $2A, $3B, $4D, $5F, $72, $86, $9A, $AF, $C5, $DC, $F4,\
			$0D, $27, $43, $60, $80, $A1, $C4, $EA, $13, $3F, $6E, $A2, $DB, $19, $5E, $AA,\
			$00, $61, $D0, $50, $E6, $97, $6C, $72, $BE, $6E, $BA, $09, $3A, $8E, $4D, $F7


;////////////////////////////
		.bank	2
		.org	$C000

;////////////////////////////
		.bank	3
		INCBIN	"char.dat"		;    8K  3    $03
		INCBIN	"mul.dat"		;  128K  4~19 $04~$13
		INCBIN	"div.dat"		;   96K 20~31 $14~$1F


;////////////////////////////
		.bank	32
		.org	$4000

;----------------------------
initCalcEdge:
;initialize calculation edge
		lda	#$FF
		sta	edgeCount
		tii	edgeCount, edgeCount+1, 193

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

;first process
		lda	clip2D0, x
		sta	<edgeX0
		lda	clip2D0+2, x
		sta	<edgeY0

		cmp	<minEdgeY
		jcs	.calcEdge_putPolyJump3
		sta	<minEdgeY

.calcEdge_putPolyJump3:
		lda	clip2D0+4, x
		sta	<edgeX1
		lda	clip2D0+6, x
		sta	<edgeY1

		phx
		jsr	calcEdge0
		ply
		ldx	intTable+4, y

		dec	<clip2D0Count

;next process
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
		ply
		ldx	intTable+4, y

		dec	<clip2D0Count
		bne	.calcEdge_putPolyLoop0

		jsr	putPolyLine
		rts


;----------------------------
calcCircle:
;
;top < 192
		sec
		lda	<circleCenterY
		sbc	<circleRadius
		sta	<circleYTop
		lda	<circleCenterY+1
		sbc	<circleRadius+1

		bmi	.jp11
		beq	.jp10
		jmp	.jpEnd

.jp10:
		lda	<circleYTop
		cmp	#192
		jcc	.jp11
		jmp	.jpEnd

.jp11:
;bottom >= 0
		clc
		lda	<circleCenterY
		adc	<circleRadius
		lda	<circleCenterY+1
		adc	<circleRadius+1

		bpl	.jp12
		jmp	.jpEnd

.jp12:
;left < 256
		sec
		lda	<circleCenterX
		sbc	<circleRadius
		lda	<circleCenterX+1
		sbc	<circleRadius+1

		bmi	.jp13
		beq	.jp13
		jmp	.jpEnd

.jp13:
;right >= 0
		clc
		lda	<circleCenterX
		adc	<circleRadius
		lda	<circleCenterX+1
		adc	<circleRadius+1

		bpl	.jp14
		jmp	.jpEnd

.jp14:
		mov	<minEdgeY, #$FF

		subw	<circleD, #1, <circleRadius

		movw	<circleDH, #3

		movw	<circleDD, <circleRadius
		asl	<circleDD
		rol	<circleDD+1

		sec
		lda	#5
		sbc	<circleDD
		sta	<circleDD
		lda	#0
		sbc	<circleDD+1
		sta	<circleDD+1

		movw	<circleX, <circleRadius

		stzw	<circleY

.loop0:
		sec
		lda	<circleY
		sbc	<circleX
		sta	<circleTmp

		lda	<circleY+1
		sbc	<circleX+1
		bmi	.jp00
		ora	<circleTmp
		beq	.jp00

		jmp	.jpEnd

.jp00:
		bbr7	<circleD+1, .jp01

		clc
		lda	<circleD
		adc	<circleDH
		sta	<circleD

		lda	<circleD+1
		adc	<circleDH+1
		sta	<circleD+1

		clc
		lda	<circleDH
		adc	#2
		sta	<circleDH

		lda	<circleDH+1
		adc	#0
		sta	<circleDH+1

		clc
		lda	<circleDD
		adc	#2
		sta	<circleDD

		lda	<circleDD+1
		adc	#0
		sta	<circleDD+1

		bra	.jp02

.jp01:
		clc
		lda	<circleD
		adc	<circleDD
		sta	<circleD
		lda	<circleD+1
		adc	<circleDD+1
		sta	<circleD+1

		clc
		lda	<circleDH
		adc	#2
		sta	<circleDH
		lda	<circleDH+1
		adc	#0
		sta	<circleDH+1

		clc
		lda	<circleDD
		adc	#4
		sta	<circleDD
		lda	<circleDD+1
		adc	#0
		sta	<circleDD+1

		sec
		lda	<circleX
		sbc	#1
		sta	<circleX
		lda	<circleX+1
		sbc	#0
		sta	<circleX+1

.jp02:
;----------------
		clc
		lda	<circleCenterX
		adc	<circleX
		sta	<circleXRight
		lda	<circleCenterX+1
		adc	<circleX+1
		sta	<circleXRight+1

		sec
		lda	<circleCenterX
		sbc	<circleX
		sta	<circleXLeft
		lda	<circleCenterX+1
		sbc	<circleX+1
		sta	<circleXLeft+1

		clc
		lda	<circleCenterY
		adc	<circleY
		sta	<circleYWork
		lda	<circleCenterY+1
		adc	<circleY+1
		sta	<circleYWork+1

		jsr	setCircleEdge

;----------------
		sec
		lda	<circleCenterY
		sbc	<circleY
		sta	<circleYWork
		lda	<circleCenterY+1
		sbc	<circleY+1
		sta	<circleYWork+1

		jsr	setCircleEdge

;----------------
		clc
		lda	<circleCenterX
		adc	<circleY
		sta	<circleXRight
		lda	<circleCenterX+1
		adc	<circleY+1
		sta	<circleXRight+1

		sec
		lda	<circleCenterX
		sbc	<circleY
		sta	<circleXLeft
		lda	<circleCenterX+1
		sbc	<circleY+1
		sta	<circleXLeft+1

		clc
		lda	<circleCenterY
		adc	<circleX
		sta	<circleYWork
		lda	<circleCenterY+1
		adc	<circleX+1
		sta	<circleYWork+1

		jsr	setCircleEdge

;----------------
		sec
		lda	<circleCenterY
		sbc	<circleX
		sta	<circleYWork
		lda	<circleCenterY+1
		sbc	<circleX+1
		sta	<circleYWork+1

		jsr	setCircleEdge

		clc
		lda	<circleY
		adc	#1
		sta	<circleY
		lda	<circleY+1
		adc	#0
		sta	<circleY+1

		jmp	.loop0

.jpEnd:
		rts


;----------------------------
setCircleEdge:
;
		lda	<circleYWork+1
		bne	.endSet

		ldy	<circleYWork
		cpy	#192
		bcs	.endSet

		lda	<circleXLeft+1
		beq	.jp00
		bpl	.endSet

		stz	<circleXLeft

.jp00:
		lda	<circleXRight+1
		bmi	.endSet
		beq	.jp01

		mov	<circleXRight, #$FF

.jp01:
		cpy	<minEdgeY
		jcs	.jp02

		sty	<minEdgeY

.jp02:
		lda	#2
		sta	edgeCount, y

		lda	<circleXLeft
		sta	edgeLeft, y

		lda	<circleXRight
		sta	edgeRight, y

.endSet:
		rts


;----------------------------
calcEdge0:
;
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

		setEdgeBuffer0m
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
		jmp	edgeXEqual0

.edgeJump3:
;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		jcs	.edgeJump4

;edgeSlopeX > edgeSlopeY
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10

;++++++++++++++++++++++++++++
;edgeSigneX plus
		jmp	edgeSigneXPlus0

;++++++++++++++++++++++++++++
;edgeSigneX minus
.edgeJump10:
		jmp	edgeSigneXMinus0

.edgeJump4:
;edgeSlopeY >= edgeSlopeX
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop4

;++++++++++++++++++++++++++++
;edgeSigneY plus
		jmp	edgeSigneYPlus0

;++++++++++++++++++++++++++++
;edgeSigneY minus
.edgeYLoop4:
		jmp	edgeSigneYMinus0


;----------------------------
edgeXEqual0:
;
		sec
		lda	<edgeY1
		sbc	<edgeY0

		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

		ldy	<edgeX0
		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		setEdgeBuffer0m
		inx
.jp6:
		setEdgeBuffer0m
		inx
.jp5:
		setEdgeBuffer0m
		inx
.jp4:
		setEdgeBuffer0m
		inx
.jp3:
		setEdgeBuffer0m
		inx
.jp2:
		setEdgeBuffer0m
		inx
.jp1:
		setEdgeBuffer0m
		inx
.jp0:
		setEdgeBuffer0m
		inx

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneXPlus0:
;
		ldy	<edgeX0
		ldx	<edgeY0

		setEdgeBufferm

		sec
		lda	<edgeX1
		sbc	<edgeX0
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneXPlus0m
.jp6:
		edgeSigneXPlus0m
.jp5:
		edgeSigneXPlus0m
.jp4:
		edgeSigneXPlus0m
.jp3:
		edgeSigneXPlus0m
.jp2:
		edgeSigneXPlus0m
.jp1:
		edgeSigneXPlus0m
.jp0:
		edgeSigneXPlus0m

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneXMinus0:
;
		ldy	<edgeX1
		ldx	<edgeY1

		setEdgeBufferm

		sec
		lda	<edgeX0
		sbc	<edgeX1
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldx	<edgeY1

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneXMinus0m
.jp6:
		edgeSigneXMinus0m
.jp5:
		edgeSigneXMinus0m
.jp4:
		edgeSigneXMinus0m
.jp3:
		edgeSigneXMinus0m
.jp2:
		edgeSigneXMinus0m
.jp1:
		edgeSigneXMinus0m
.jp0:
		edgeSigneXMinus0m

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneYPlus0:
;
		ldy	<edgeX0
		ldx	<edgeY0

		setEdgeBufferm

		sec
		lda	<edgeY1
		sbc	<edgeY0
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

;edgeSlope initialize
		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneYPlus0m
.jp6:
		edgeSigneYPlus0m
.jp5:
		edgeSigneYPlus0m
.jp4:
		edgeSigneYPlus0m
.jp3:
		edgeSigneYPlus0m
.jp2:
		edgeSigneYPlus0m
.jp1:
		edgeSigneYPlus0m
.jp0:
		edgeSigneYPlus0m

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneYMinus0:
;
		ldy	<edgeX0
		ldx	<edgeY0

		setEdgeBufferm

		sec
		lda	<edgeY1
		sbc	<edgeY0
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

;edgeSlope initialize
		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneYMinus0m
.jp6:
		edgeSigneYMinus0m
.jp5:
		edgeSigneYMinus0m
.jp4:
		edgeSigneYMinus0m
.jp3:
		edgeSigneYMinus0m
.jp2:
		edgeSigneYMinus0m
.jp1:
		edgeSigneYMinus0m
.jp0:
		edgeSigneYMinus0m

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
calcEdge:
;
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
		jmp	edgeXEqual

.edgeJump3:
;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		jcs	.edgeJump4

;edgeSlopeX > edgeSlopeY
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10

;++++++++++++++++++++++++++++
;edgeSigneX plus
		jmp	edgeSigneXPlus

;++++++++++++++++++++++++++++
;edgeSigneX minus
.edgeJump10:
		jmp	edgeSigneXMinus

.edgeJump4:
;edgeSlopeY >= edgeSlopeX
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop4

;++++++++++++++++++++++++++++
;edgeSigneY plus
		jmp	edgeSigneYPlus

;++++++++++++++++++++++++++++
;edgeSigneY minus
.edgeYLoop4:
		jmp	edgeSigneYMinus


;----------------------------
edgeXEqual:
;
		sec
		lda	<edgeY1
		sbc	<edgeY0

		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

		ldy	<edgeX0
		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		setEdgeBufferm
		inx
.jp6:
		setEdgeBufferm
		inx
.jp5:
		setEdgeBufferm
		inx
.jp4:
		setEdgeBufferm
		inx
.jp3:
		setEdgeBufferm
		inx
.jp2:
		setEdgeBufferm
		inx
.jp1:
		setEdgeBufferm
		inx
.jp0:
		setEdgeBufferm
		inx

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneXPlus:
;
		ldy	<edgeX0
		ldx	<edgeY0

		setEdgeBufferm

		sec
		lda	<edgeX1
		sbc	<edgeX0
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount


;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneXPlusm
.jp6:
		edgeSigneXPlusm
.jp5:
		edgeSigneXPlusm
.jp4:
		edgeSigneXPlusm
.jp3:
		edgeSigneXPlusm
.jp2:
		edgeSigneXPlusm
.jp1:
		edgeSigneXPlusm
.jp0:
		edgeSigneXPlusm

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneXMinus:
;
		ldy	<edgeX1
		ldx	<edgeY1

		setEdgeBufferm

		sec
		lda	<edgeX0
		sbc	<edgeX1
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldx	<edgeY1

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneXMinusm
.jp6:
		edgeSigneXMinusm
.jp5:
		edgeSigneXMinusm
.jp4:
		edgeSigneXMinusm
.jp3:
		edgeSigneXMinusm
.jp2:
		edgeSigneXMinusm
.jp1:
		edgeSigneXMinusm
.jp0:
		edgeSigneXMinusm

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneYPlus:
;
		ldy	<edgeX0
		ldx	<edgeY0

		setEdgeBufferm

		sec
		lda	<edgeY1
		sbc	<edgeY0
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

;edgeSlope initialize
		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneYPlusm
.jp6:
		edgeSigneYPlusm
.jp5:
		edgeSigneYPlusm
.jp4:
		edgeSigneYPlusm
.jp3:
		edgeSigneYPlusm
.jp2:
		edgeSigneYPlusm
.jp1:
		edgeSigneYPlusm
.jp0:
		edgeSigneYPlusm

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
edgeSigneYMinus:
;
		ldy	<edgeX0
		ldx	<edgeY0

		setEdgeBufferm

		sec
		lda	<edgeY1
		sbc	<edgeY0
		bne	.jpInit
		rts

.jpInit:
		dec	a
		pha
		and	#$07
		tax
		lda	.jpTableLow, x
		sta	<edgeLoopAddr
		lda	.jpTableHigh, x
		sta	<edgeLoopAddr+1

		pla
		lsr	a
		lsr	a
		lsr	a
		sta	<edgeLoopCount

;edgeSlope initialize
		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldx	<edgeY0

		jmp	[edgeLoopAddr]

.loop0:
.jp7:
		edgeSigneYMinusm
.jp6:
		edgeSigneYMinusm
.jp5:
		edgeSigneYMinusm
.jp4:
		edgeSigneYMinusm
.jp3:
		edgeSigneYMinusm
.jp2:
		edgeSigneYMinusm
.jp1:
		edgeSigneYMinusm
.jp0:
		edgeSigneYMinusm

		dec	<edgeLoopCount
		jpl	.loop0

.jpEnd:
		rts

.jpTableLow:
		.db	LOW(.jp0)
		.db	LOW(.jp1)
		.db	LOW(.jp2)
		.db	LOW(.jp3)
		.db	LOW(.jp4)
		.db	LOW(.jp5)
		.db	LOW(.jp6)
		.db	LOW(.jp7)

.jpTableHigh:
		.db	HIGH(.jp0)
		.db	HIGH(.jp1)
		.db	HIGH(.jp2)
		.db	HIGH(.jp3)
		.db	HIGH(.jp4)
		.db	HIGH(.jp5)
		.db	HIGH(.jp6)
		.db	HIGH(.jp7)


;----------------------------
putPolyLine:
;put poly line
		mov	<polyLineColorDataWork0, polyLineColorWork_H_P0
		mov	<polyLineColorDataWork1, polyLineColorWork_H_P1
		mov	<polyLineColorDataWork2, polyLineColorWork_H_P2
		mov	<polyLineColorDataWork3, polyLineColorWork_H_P3

		lda	<minEdgeY
		inc	a
		and	#$FE
		tay
		jsr	putPolyLineProc

		bbs6	<polyAttribute, .functionEnd

		mov	<polyLineColorDataWork0, polyLineColorWork_L_P0
		mov	<polyLineColorDataWork1, polyLineColorWork_L_P1
		mov	<polyLineColorDataWork2, polyLineColorWork_L_P2
		mov	<polyLineColorDataWork3, polyLineColorWork_L_P3


		lda	<minEdgeY
		and	#$FE
		inc	a
		tay
		jsr	putPolyLineProc

.functionEnd:
		rts


;----------------------------
putPolyLineProc:
;put poly line
		bra	.loopStart
;loop
.loop0:
		iny
		iny

.loopStart:	lda	edgeCount, y
		bpl	.putPolyProc
		rts

.putPolyProc:
;set poly color
;calation vram address
;left
;left address
		ldx	edgeLeft, y
		txa
		and	#$38
		asl	a
		asl	a
		ora	polyLineAddrConvYLow0, y
		sta	<polyLineLeftAddr

		txa
		lsr	a
		lsr	a
		lsr	a
		sta	<polyLineCount

		lsr	a
		lsr	a
		lsr	a
		ora	polyLineAddrConvYHigh0, y
		sta	<polyLineLeftAddr+1

		addw	<polyLineLeftAddr, <polyLineTopAddr

		txa
		and	#$07
		tax
		lda	polyLineLeftDatas, x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;right
		ldx	edgeRight,y

;calation counts
		txa
		lsr	a
		lsr	a
		lsr	a
		sec
		sbc	<polyLineCount

;count 0
		jeq	.polyLineJump03

		sta	<polyLineCount

;right address
		txa
		and	#$38
		asl	a
		asl	a
		ora	polyLineAddrConvYLow0, y
		sta	<polyLineRightAddr

		txa
		rol	a
		rol	a
		rol	a
		and	#$03
		ora	polyLineAddrConvYHigh0, y
		sta	<polyLineRightAddr+1

		addw	<polyLineRightAddr, <polyLineTopAddr

		txa
		and	#$07
		tax
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
		txa
		and	#$07
		tax
		lda	polyLineRightDatas, x
		and	<polyLineLeftData
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
polyLineAddrConvYHigh0:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $04, $04, $04, $04,\
			$08, $08, $08, $08, $08, $08, $08, $08, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C,\
			$10, $10, $10, $10, $10, $10, $10, $10, $14, $14, $14, $14, $14, $14, $14, $14,\
			$18, $18, $18, $18, $18, $18, $18, $18, $1C, $1C, $1C, $1C, $1C, $1C, $1C, $1C,\
			$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C,\
			$00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $04, $04, $04, $04,\
			$08, $08, $08, $08, $08, $08, $08, $08, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C,\
			$10, $10, $10, $10, $10, $10, $10, $10, $14, $14, $14, $14, $14, $14, $14, $14,\
			$18, $18, $18, $18, $18, $18, $18, $18, $1C, $1C, $1C, $1C, $1C, $1C, $1C, $1C,\
			$20, $20, $20, $20, $20, $20, $20, $20, $24, $24, $24, $24, $24, $24, $24, $24,\
			$28, $28, $28, $28, $28, $28, $28, $28, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C


;----------------------------
polyLineAddrConvYLow0:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
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
			$10, $11, $12, $13, $14, $15, $16, $17, $10, $11, $12, $13, $14, $15, $16, $17


;----------------------------
polyLineLeftDatas:
		.db	$FF, $7F, $3F, $1F, $0F, $07, $03, $01


;----------------------------
polyLineRightDatas:
		.db	$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF


;////////////////////////////
		.bank	33
		INCBIN	"sp_char.dat"		;    8K  33   $21
