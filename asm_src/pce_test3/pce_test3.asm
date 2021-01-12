;VRAM
;0000-03FF	BG0	 1KWORD
;0400-07FF	BG1	 1KWORD
;0800-0FFF		 2KWORD	SPCHR SATB
;1000-1FFF	CHR	 4KWORD	0-255CHR
;2000-4FFF	CHRBG	12KWORD	32*24CHR(256*192 2bpp*2)
;5000-7FFF

;MEMORY
;0000	I/O
;2000	RAM
;4000	mul data : div data
;6000
;8000
;A000	main
;C000	wireframe process
;E000	irq mul div


;//////////////////////////////////
CHRBG0Addr		.equ	$20
CHRBG1Addr		.equ	$38

chardatBank		.equ	3
muldatBank		.equ	4
divdatBank		.equ	20

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


;//////////////////////////////////
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
			sta	$2100,x
			lda	\1+1
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			sta	$2100,x
			lda	\1+1
			sbc	\2+1
		.endif

		php
		ora	$2100,x
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
			sta	$2100,x
			lda	\1+1
			sbc	#HIGH(\3)
			ora	$2100,x
			sta	$2100,x
			lda	\1+2
			sbc	#LOW(\2)
			ora	$2100,x
			sta	$2100,x
			lda	\1+3
			sbc	#HIGH(\2)
		.else
			sec
			lda	\1
			sbc	\2
			sta	$2100,x
			lda	\1+1
			sbc	\2+1
			ora	$2100,x
			sta	$2100,x
			lda	\1+2
			sbc	\2+2
			ora	$2100,x
			sta	$2100,x
			lda	\1+3
			sbc	\2+3
		.endif

		php
		ora	$2100,x
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
SCREENZ			.equ	128
ROTATIONXYZ		.equ	%00100100;ZYX
ROTATIONXZY		.equ	%00011000;YZX
ROTATIONYXZ		.equ	%00100001;ZXY
ROTATIONYZX		.equ	%00001001;XZY
ROTATIONZXY		.equ	%00010010;YXZ
ROTATIONZYX		.equ	%00000110;XYZ


;//////////////////////////////////
		.zp
;**********************************
		.org	$2000
;---------------------
div64ans
mul16a
div16a			.ds	2
mul16b
div16b			.ds	2

div64a
mul16c
div16c			.ds	2
mul16d
div16d			.ds	2
			.ds	4
div64b
mul32a
div32ans		.ds	2
div32work		.ds	2
mul32b			.ds	4

mul32work
div64work		.ds	8

sqrt64a			.ds	8
sqrt64ans
sqrt64b			.ds	8

muladdr			.ds	2
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

edgeSignX		.ds	1

;---------------------
lineX0			.ds	2
lineY0			.ds	2
lineX1			.ds	2
lineY1			.ds	2

clip2DFlag		.ds	1

;---------------------
wireBGAddr		.ds	1

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
lineColor		.ds	1
lineBufferCount		.ds	1
lineBufferAddr		.ds	2

;---------------------
drawFlag		.ds	1

;---------------------
vdcStatus		.ds	1

;=====================
;---------------------
objRegTable_AddrWork	.ds	2


;//////////////////////////////////
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
unitVectorX0		.ds	2
unitVectorY0		.ds	2
unitVectorZ0		.ds	2

unitVectorX
unitVectorX1		.ds	2
			.ds	2
unitVectorY
unitVectorY1		.ds	2
			.ds	2
unitVectorZ
unitVectorZ1		.ds	2
			.ds	2

unitVectorWork		.ds	4

;---------------------
transform2DWork0	.ds	256
transform2DWork1	.ds	256

;---------------------
lineBuffer		.ds	1024

;---------------------
;---------------------
shipTranslationX	.ds	2
shipTranslationY	.ds	2
shipTranslationZ	.ds	2

shipRotationX		.ds	1
shipRotationY		.ds	1
shipRotationZ		.ds	1

;---------------------
angleX0			.ds	2
angleX1			.ds	2
angleY0			.ds	2
angleY1			.ds	2
angleZ0			.ds	2
angleZ1			.ds	2

ansAngleX		.ds	1
ansAngleY		.ds	1

angleShift		.ds	2

;---------------------
			.rsset	$0
OBJ_NO			.rs	1
OBJ_COLOR		.rs	1
OBJ_X			.rs	4
OBJ_Y			.rs	4
OBJ_Z			.rs	4
OBJ_RX			.rs	1
OBJ_RY			.rs	1
OBJ_RZ			.rs	1
OBJ_STATE		.rs	1
OBJ_SIZE		.rs	0

;---------------------
			.rsset	OBJ_SIZE
ESHOT_SHIFTX		.rs	4
ESHOT_SHIFTY		.rs	4
ESHOT_SHIFTZ		.rs	4
ESHOT_SIZE		.rs	0

ESHOT_MAX		.equ	8
ESHOTTABLE_SIZE		.equ	ESHOT_SIZE*ESHOT_MAX

OBJ_NO_ESHOT		.equ	4
ESHOT_SHIFT		.equ	$0030

eshotTable		.ds	ESHOTTABLE_SIZE
eshot_X			.ds	2
eshot_Y			.ds	2
eshot_Z			.ds	2

;---------------------
			.rsset	OBJ_SIZE
SHOT_SIZE		.rs	0

SHOT_MAX		.equ	4
SHOTTABLE_SIZE		.equ	SHOT_SIZE*SHOT_MAX

SHOT_Z_SHIFT		.equ	$0100
SHOT_Z_MAX		.equ	$10
OBJ_NO_SHOT		.equ	2

shotTable		.ds	SHOTTABLE_SIZE

;---------------------
			.rsset	OBJ_SIZE
ENEMY_TIME		.rs	1
ENEMY_SIZE		.rs	0

ENEMY_MAX		.equ	8
ENEMYTABLE_SIZE		.equ	ENEMY_SIZE*ENEMY_MAX

OBJ_NO_ENEMY0		.equ	6
ENEMY0_Z_SHIFT		.equ	$FFF0

enemyTable		.ds	ENEMYTABLE_SIZE
enemy_X			.ds	2
enemy_Y			.ds	2
enemy_Z			.ds	2

;---------------------
			.rsset	OBJ_SIZE
EFFECT_TYPE		.rs	1
EFFECT_TIME		.rs	1
EFFECT_SIZE		.rs	0

EFFECT_MAX		.equ	8
EFFECTTABLE_SIZE	.equ	EFFECT_SIZE*EFFECT_MAX

OBJ_NO_EFFECT0		.equ	8
OBJ_NO_EFFECT1		.equ	24

EFFECT_TYPE_0		.equ	0
EFFECT_TYPE_1		.equ	1

effectTable		.ds	EFFECTTABLE_SIZE
effect_X		.ds	2
effect_Y		.ds	2
effect_Z		.ds	2
effect_Type		.ds	1

;---------------------
			.rsset	$0
OBJREG_ADDR		.rs	2
OBJREG_Z		.rs	2
OBJREG_SIZE		.rs	0

objRegTable		.ds	OBJREG_SIZE*64
objRegTable_index	.ds	1
objReg_AddrWork		.ds	2
objReg_ZWork		.ds	2

;---------------------
			.rsset	$0
STAR_X			.rs	2
STAR_Y			.rs	2
STAR_Z			.rs	4
STAR_Z_SHIFT		.rs	4
STAR_STRUCT_SIZE	.rs	0

STAR_MAX		.equ	8
STARTABLE_SIZE		.equ	STAR_STRUCT_SIZE*STAR_MAX

starTable		.ds	STARTABLE_SIZE
starShiftX		.ds	2
starShiftY		.ds	2

;---------------------
			.rsset	$0
SPRITE_Y		.rs	2
SPRITE_X		.rs	2
SPRITE_NO		.rs	2
SPRITE_ATTR		.rs	2
SPRITE_STRUCT_SIZE	.rs	0

SPRITE_STAR_SIZE	.equ	SPRITE_STRUCT_SIZE*STAR_MAX

spriteAttrTable
sprite0			.ds	SPRITE_STRUCT_SIZE
spriteStar		.ds	SPRITE_STAR_SIZE
			.ds	512-SPRITE_STRUCT_SIZE-SPRITE_STAR_SIZE

;---------------------
hitCheckX0		.ds	2
hitCheckY0		.ds	2
hitCheckZ0		.ds	2
hitCheckX1		.ds	2
hitCheckY1		.ds	2
hitCheckZ1		.ds	2

;---------------------
enemyTimer		.ds	1

;---------------------
frameCount		.ds	1
drawCount		.ds	1
drawCountWork		.ds	1


;//////////////////////////////////
		.code
;**********************************
		.bank	0
		.org	$E000
;----------------------------
sdiv32:
;div16d:div16c / div16a = div16a div16b
;d sign
		lda	<div16d+1
		pha

;d eor a sign
		eor	<div16a+1
		pha

;d sign
		bbr7	<div16d+1, .sdiv32jp00

;d neg
		sec
		lda	<div16c
		eor	#$FF
		adc	#0
		sta	<div16c

		lda	<div16c+1
		eor	#$FF
		adc	#0
		sta	<div16c+1

		lda	<div16d
		eor	#$FF
		adc	#0
		sta	<div16d

		lda	<div16d+1
		eor	#$FF
		adc	#0
		sta	<div16d+1

.sdiv32jp00:
;a sign
		bbr7	<div16a+1, .sdiv32jp01

;a neg
		sec
		lda	<div16a
		eor	#$FF
		adc	#0
		sta	<div16a

		lda	<div16a+1
		eor	#$FF
		adc	#0
		sta	<div16a+1

.sdiv32jp01:
		jsr	udiv32

;anser sign
		pla
		bpl	.sdiv32jp02

;anser neg
		sec
		lda	<div16a
		eor	#$FF
		adc	#0
		sta	<div16a

		lda	<div16a+1
		eor	#$FF
		adc	#0
		sta	<div16a+1

.sdiv32jp02:
;remainder sign
		pla
		bpl	.sdiv32jp03

;remainder neg
		sec
		lda	<div16b
		eor	#$FF
		adc	#0
		sta	<div16b

		lda	<div16b+1
		eor	#$FF
		adc	#0
		sta	<div16b+1

.sdiv32jp03:
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

;set count
		ldx	#16

.udivloop:
;right shift div16b:div16a
		lsr	<div16b+1
		ror	<div16b
		ror	<div16a+1
		ror	<div16a

;div16d:div16c - div16b:div16a = a:y:div32work
		sec
		lda	<div16c
		sbc	<div16a
		sta	<div32work

		lda	<div16c+1
		sbc	<div16a+1
		sta	<div32work+1

		lda	<div16d
		sbc	<div16b
		tay

		lda	<div16d+1
		sbc	<div16b+1

;check div16d:div16c >= div16b:div16a
		bcc	.udivjump

		rol	<div32ans
		rol	<div32ans+1

;div16d:div16c = a:y:div32work
		sty	<div16d

		sta	<div16d+1

		lda	<div32work
		sta	<div16c

		lda	<div32work+1
		sta	<div16c+1

		dex
		bne	.udivloop
		bra	.udivjump01

.udivjump:
		rol	<div32ans
		rol	<div32ans+1
;decrement x
		dex
		bne	.udivloop

.udivjump01:
;div32ans to div16a
		lda	<div32ans
		sta	<div16a

		lda	<div32ans+1
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
sqrt64:
;sqrt64ans = sqrt(sqrt64a)
;push x
		phx

		bbr7	<sqrt64a+7,.sqrtjump3

		lda	#$FF
		sta	<sqrt64b
		sta	<sqrt64b+1
		sta	<sqrt64b+2
		sta	<sqrt64b+3

		bra	.sqrtjump0

.sqrtjump3:
;sqrt64a to sqrt64b
		lda	<sqrt64a
		sta	<sqrt64b

		lda	<sqrt64a+1
		sta	<sqrt64b+1

		lda	<sqrt64a+2
		sta	<sqrt64b+2

		lda	<sqrt64a+3
		sta	<sqrt64b+3

		lda	<sqrt64a+4
		sta	<sqrt64b+4

		lda	<sqrt64a+5
		sta	<sqrt64b+5

		lda	<sqrt64a+6
		sta	<sqrt64b+6

		lda	<sqrt64a+7
		sta	<sqrt64b+7

.sqrtjump1:
;right shift sqrt64b
		lda	<sqrt64b+4
		ora	<sqrt64b+5
		ora	<sqrt64b+6
		ora	<sqrt64b+7
		beq	.sqrtjump0

		lsr	<sqrt64b+7
		ror	<sqrt64b+6
		ror	<sqrt64b+5
		ror	<sqrt64b+4
		ror	<sqrt64b+3
		ror	<sqrt64b+2
		ror	<sqrt64b+1
		ror	<sqrt64b

		bra	.sqrtjump1

.sqrtjump0:
;set loop counter
		ldx	#32

.sqrtloop:
;sqrt64a to div64a
		lda	<sqrt64a
		sta	<div64a

		lda	<sqrt64a+1
		sta	<div64a+1

		lda	<sqrt64a+2
		sta	<div64a+2

		lda	<sqrt64a+3
		sta	<div64a+3

		lda	<sqrt64a+4
		sta	<div64a+4

		lda	<sqrt64a+5
		sta	<div64a+5

		lda	<sqrt64a+6
		sta	<div64a+6

		lda	<sqrt64a+7
		sta	<div64a+7

;sqrt64b to div16b:div16a
		lda	<sqrt64b
		sta	<div16a

		lda	<sqrt64b+1
		sta	<div16a+1

		lda	<sqrt64b+2
		sta	<div16b

		lda	<sqrt64b+3
		sta	<div16b+1

		jsr	udiv64

;sqrt64b+4 = (sqrt64b + div16b:div16a) / 2
		clc
		lda	<sqrt64b
		adc	<div16a
		sta	<sqrt64b+4

		lda	<sqrt64b+1
		adc	<div16a+1
		sta	<sqrt64b+5

		lda	<sqrt64b+2
		adc	<div16b
		sta	<sqrt64b+6

		lda	<sqrt64b+3
		adc	<div16b+1
		sta	<sqrt64b+7

		ror	<sqrt64b+7
		ror	<sqrt64b+6
		ror	<sqrt64b+5
		ror	<sqrt64b+4

;compare sqrt64b and sqrt64b+4
		lda	<sqrt64b+3
		cmp	<sqrt64b+7
		bne	.sqrtjump2

		lda	<sqrt64b+2
		cmp	<sqrt64b+6
		bne	.sqrtjump2

		lda	<sqrt64b+1
		cmp	<sqrt64b+5
		bne	.sqrtjump2

		lda	<sqrt64b
		cmp	<sqrt64b+4
		beq	.sqrtend

.sqrtjump2:
;sqrt64b+4 to sqrt64b
		lda	<sqrt64b+4
		sta	<sqrt64b

		lda	<sqrt64b+5
		sta	<sqrt64b+1

		lda	<sqrt64b+6
		sta	<sqrt64b+2

		lda	<sqrt64b+7
		sta	<sqrt64b+3

;check loop counter
		dex
		bne	.sqrtloop

.sqrtend:
;pull x
		plx
		rts


;----------------------------
sdiv64:
;div64a / div16b:div16a = div16b:div16a div16d:div16c
;64a sign
		lda	<div64a+7
		pha

;64a eor b:a sign
		eor	<div16b+1
		pha

;64a sign
		bbr7	<div64a+7, .sdiv64jp00

;64a neg
		sec
		lda	<div64a
		eor	#$FF
		adc	#0
		sta	<div64a

		lda	<div64a+1
		eor	#$FF
		adc	#0
		sta	<div64a+1

		lda	<div64a+2
		eor	#$FF
		adc	#0
		sta	<div64a+2

		lda	<div64a+3
		eor	#$FF
		adc	#0
		sta	<div64a+3

		lda	<div64a+4
		eor	#$FF
		adc	#0
		sta	<div64a+4

		lda	<div64a+5
		eor	#$FF
		adc	#0
		sta	<div64a+5

		lda	<div64a+6
		eor	#$FF
		adc	#0
		sta	<div64a+6

		lda	<div64a+7
		eor	#$FF
		adc	#0
		sta	<div64a+7

.sdiv64jp00:
;b:a sign
		bbr7	<div16b+1, .sdiv64jp01

;b:a neg
		sec
		lda	<div16a
		eor	#$FF
		adc	#0
		sta	<div16a

		lda	<div16a+1
		eor	#$FF
		adc	#0
		sta	<div16a+1

		lda	<div16b
		eor	#$FF
		adc	#0
		sta	<div16b

		lda	<div16b+1
		eor	#$FF
		adc	#0
		sta	<div16b+1

.sdiv64jp01:
		jsr	udiv64

;anser sign
		pla
		bpl	.sdiv64jp02

;anser neg
		sec
		lda	<div16a
		eor	#$FF
		adc	#0
		sta	<div16a

		lda	<div16a+1
		eor	#$FF
		adc	#0
		sta	<div16a+1

		lda	<div16b
		eor	#$FF
		adc	#0
		sta	<div16b

		lda	<div16b+1
		eor	#$FF
		adc	#0
		sta	<div16b+1

.sdiv64jp02:
;remainder sign
		pla
		bpl	.sdiv64jp03

;remainder neg
		sec
		lda	<div16c
		eor	#$FF
		adc	#0
		sta	<div16c

		lda	<div16c+1
		eor	#$FF
		adc	#0
		sta	<div16c+1

		lda	<div16d
		eor	#$FF
		adc	#0
		sta	<div16d

		lda	<div16d+1
		eor	#$FF
		adc	#0
		sta	<div16d+1

.sdiv64jp03:
		rts


;----------------------------
udiv64:
;div64a / div16b:div16a = div16b:div16a div16d:div16c
;push x
		phx

;div16b:div16a to div64b+4
		lda	<div16a
		sta	<div64b+4

		lda	<div16a+1
		sta	<div64b+5

		lda	<div16b
		sta	<div64b+6

		lda	<div16b+1
		sta	<div64b+7

;set zero div64b
		stz	<div64b
		stz	<div64b+1
		stz	<div64b+2
		stz	<div64b+3

;set count
		ldx	#32

.udivloop:
;right shift div64b
		lsr	<div64b+7
		ror	<div64b+6
		ror	<div64b+5
		ror	<div64b+4
		ror	<div64b+3
		ror	<div64b+2
		ror	<div64b+1
		ror	<div64b

;div64a - div64b = div64work
		sec
		lda	<div64a
		sbc	<div64b
		sta	<div64work

		lda	<div64a+1
		sbc	<div64b+1
		sta	<div64work+1

		lda	<div64a+2
		sbc	<div64b+2
		sta	<div64work+2

		lda	<div64a+3
		sbc	<div64b+3
		sta	<div64work+3

		lda	<div64a+4
		sbc	<div64b+4
		sta	<div64work+4

		lda	<div64a+5
		sbc	<div64b+5
		sta	<div64work+5

		lda	<div64a+6
		sbc	<div64b+6
		sta	<div64work+6

		lda	<div64a+7
		sbc	<div64b+7
		sta	<div64work+7


;check div64a >= div64b
		bcc	.udivjump

		rol	<div64ans
		rol	<div64ans+1
		rol	<div64ans+2
		rol	<div64ans+3

;div64a = div64work
		lda	<div64work
		sta	<div64a

		lda	<div64work+1
		sta	<div64a+1

		lda	<div64work+2
		sta	<div64a+2

		lda	<div64work+3
		sta	<div64a+3

		lda	<div64work+4
		sta	<div64a+4

		lda	<div64work+5
		sta	<div64a+5

		lda	<div64work+6
		sta	<div64a+6

		lda	<div64work+7
		sta	<div64a+7

;decrement x
		dex
		bne	.udivloop
		bra	.udivjump01

.udivjump:
		rol	<div64ans
		rol	<div64ans+1
		rol	<div64ans+2
		rol	<div64ans+3

;decrement x
		dex
		bne	.udivloop

.udivjump01:
;div64ans to div16b:div16a
		lda	<div64ans
		sta	<div16a

		lda	<div64ans+1
		sta	<div16a+1

		lda	<div64ans+2
		sta	<div16b

		lda	<div64ans+3
		sta	<div16b+1

;div64a to div16d:div16c
		lda	<div64a
		sta	<div16c

		lda	<div64a+1
		sta	<div16c+1

		lda	<div64a+2
		sta	<div16d

		lda	<div64a+3
		sta	<div16d+1

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
smul32:
;mul16d:mul16c:mul16b:mul16a = mul16d:mul16c * mul16b:mul16a
;b eor d sign
		lda	<mul16b+1
		eor	<mul16d+1
		pha

;b sign
		bbr7	<mul16b+1, .smul32jp00

;b neg
		sec
		lda	<mul16a
		eor	#$FF
		adc	#0
		sta	<mul16a

		lda	<mul16a+1
		eor	#$FF
		adc	#0
		sta	<mul16a+1

		lda	<mul16b
		eor	#$FF
		adc	#0
		sta	<mul16b

		lda	<mul16b+1
		eor	#$FF
		adc	#0
		sta	<mul16b+1

.smul32jp00:
;d sign
		bbr7	<mul16d+1, .smul32jp01

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

.smul32jp01:
		jsr	umul32

;anser sign
		pla
		bpl	.smul32jp02

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

.smul32jp02:
		rts

;----------------------------
umul32:
;mul16d:mul16c:mul16b:mul16a = mul16d:mul16c * mul16b:mul16a
		lda	<mul16a
		sta	<mul32a

		lda	<mul16a+1
		sta	<mul32a+1

		lda	<mul16b
		sta	<mul32a+2

		lda	<mul16b+1
		sta	<mul32a+3

		lda	<mul16c
		sta	<mul32b

		lda	<mul16c+1
		sta	<mul32b+1

		lda	<mul16d
		sta	<mul32b+2

		lda	<mul16d+1
		sta	<mul32b+3

;mul16c * mul16a
		lda	<mul32a
		sta	<mul16a

		lda	<mul32a+1
		sta	<mul16a+1

		lda	<mul32b
		sta	<mul16b

		lda	<mul32b+1
		sta	<mul16b+1

		jsr	umul16

		lda	<mul16c
		sta	<mul32work

		lda	<mul16c+1
		sta	<mul32work+1

		lda	<mul16d
		sta	<mul32work+2

		lda	<mul16d+1
		sta	<mul32work+3

;mul16d * mul16a
		lda	<mul32a
		sta	<mul16a

		lda	<mul32a+1
		sta	<mul16a+1

		lda	<mul32b+2
		sta	<mul16b

		lda	<mul32b+3
		sta	<mul16b+1

		jsr	umul16

		clc
		lda	<mul16c
		adc	<mul32work+2
		sta	<mul32work+2

		lda	<mul16c+1
		adc	<mul32work+3
		sta	<mul32work+3

		lda	<mul16d
		adc	#$00
		sta	<mul32work+4

		lda	<mul16d+1
		adc	#$00
		sta	<mul32work+5


;mul16c * mul16b
		lda	<mul32a+2
		sta	<mul16a

		lda	<mul32a+3
		sta	<mul16a+1

		lda	<mul32b
		sta	<mul16b

		lda	<mul32b+1
		sta	<mul16b+1

		jsr	umul16

		clc
		lda	<mul16c
		adc	<mul32work+2
		sta	<mul32work+2

		lda	<mul16c+1
		adc	<mul32work+3
		sta	<mul32work+3

		lda	<mul16d
		adc	<mul32work+4
		sta	<mul32work+4

		lda	<mul16d+1
		adc	<mul32work+5
		sta	<mul32work+5

		cla
		adc	#$00
		sta	<mul32work+6

;mul16d * mul16b
		lda	<mul32a+2
		sta	<mul16a

		lda	<mul32a+3
		sta	<mul16a+1

		lda	<mul32b+2
		sta	<mul16b

		lda	<mul32b+3
		sta	<mul16b+1

		jsr	umul16

		lda	<mul32work
		sta	<mul16a

		lda	<mul32work+1
		sta	<mul16a+1

		lda	<mul32work+2
		sta	<mul16b

		lda	<mul32work+3
		sta	<mul16b+1

		clc
		lda	<mul16c
		adc	<mul32work+4
		sta	<mul16c

		lda	<mul16c+1
		adc	<mul32work+5
		sta	<mul16c+1

		lda	<mul16d
		adc	<mul32work+6
		sta	<mul16d

		lda	<mul16d+1
		adc	#$00
		sta	<mul16d+1

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

		jsr	mainIrqProc

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
		lda	#$01
		tam	#$05

		jmp	main


;----------------------------
_irq2:
_timer:
_nmi:
;IRQ2 TIMER NMI interrupt process
		rti


;----------------------------
;interrupt vectors
		.org	$FFF6

		.dw	_irq2
		.dw	_irq1
		.dw	_timer
		.dw	_nmi
		.dw	_reset


;**********************************
		.bank	1
		.org	$A000
;----------------------------
main:
		mov	frameCount,#60
		stz	drawCount
		stz	drawCountWork

;initialize VDP
		jsr	initializeVdp

;on Screen
		jsr	onScreen

;set sprite data
		st0	#$00
		st1	#$00
		st2	#$08

		st0	#$02
		tia	spriteSightsData,VDC_2,128
		tia	spriteStarData,VDC_2,128

;initialize sprite table
		stz	spriteAttrTable
		tii	spriteAttrTable,spriteAttrTable+1,511

		movw	spriteAttrTable,#96-8+64
		movw	spriteAttrTable+2,#128-8+32
		movw	spriteAttrTable+4,#$0040
		movw	spriteAttrTable+6,#$0000

;initialize random
		jsr	initRandom

;set wire proc bank
		lda	#$02
		tam	#$06

;clearBG
		jsr	clearBG

;initialize wire proc
		jsr	initWire

;set screen center
		movw	<centerX, #128
		movw	<centerY, #96

;set eye position
		stzw	<eyeTranslationX
		stzw	<eyeTranslationY
		movw	<eyeTranslationZ, #$FF00

;set eye angle
		stz	<eyeRotationX
		stz	<eyeRotationY
		stz	<eyeRotationZ

;set eye rotation order
		mov	<eyeRotationSelect, #ROTATIONXYZ

;set ship data
		stzw	shipTranslationX
		stzw	shipTranslationY
		stzw	shipTranslationZ

		stz	shipRotationX
		stz	shipRotationY
		stz	shipRotationZ

;initialize
		jsr	initShotTable

		jsr	initEnemyTable

		jsr	initEshotTable

		jsr	initEffectTable

		jsr	initStarTable

		stz	enemyTimer

;interrupt enable
		cli
.mainloop:
		jsr	initLineBuffer

		jsr	checkGamePad

		jsr	setEnemy

		jsr	moveShotTable

		jsr	moveEnemyTable

		jsr	moveEshotTable

		jsr	moveEffectTable

		jsr	checkShotEshot

		jsr	checkShotEnemy

		jsr	initObjRegTable

		jsr	regShotTable

		jsr	regEnemyTable

		jsr	regEshotTable

		jsr	regEffectTable

;set line buffer process
		movw	<eyeTranslationX,shipTranslationX
		movw	<eyeTranslationY,shipTranslationY
		movw	<eyeTranslationZ,shipTranslationZ

		mov	<eyeRotationX,shipRotationX
		mov	<eyeRotationY,shipRotationY
		mov	<eyeRotationZ,shipRotationZ

		jsr	drawObjRegTable

		jsr	moveStarTable

		jsr	setStarSprite

		jsr	clearVram

;draw process
		jsr	putLineBuffer

		jsr	setSpriteAttrTable

		lda	drawCountWork
		ldx	#2
		ldy	#24
		jsr	puthex

		jsr	switchBG

		inc	drawCount

		jmp	.mainloop

;----------------------------
checkGamePad:
;check pad
		movw	starShiftX, #$0000
		movw	starShiftY, #$0000
.checkPadUp00:
		bbr4	<padnow, .checkPadDown00
		addw	shipTranslationY, #$20
		movw	starShiftY, #$FFE0

.checkPadDown00:
		bbr6	<padnow, .checkPadLeft00
		subw	shipTranslationY, #$20
		movw	starShiftY, #$0020

.checkPadLeft00:
		bbr7	<padnow, .checkPadRight00
		subw	shipTranslationX, #$20
		movw	starShiftX, #$0020

.checkPadRight00:
		bbr5	<padnow, .checkPadRun00
		addw	shipTranslationX, #$20
		movw	starShiftX, #$FFE0

.checkPadRun00:
		bbr3	<padnow, .checkPadSelect00
.checkPadSelect00:
		bbr2	<padnow, .checkPadB00
.checkPadB00:
		bbr1	<padnow, .checkPadA00
.checkPadA00:
		bbr0	<padnow, .checkPadEnd00

		jsr	setShotTable
.checkPadEnd00:
		rts


;----------------------------
setSpriteAttrTable:
;
		sei

		st0	#$00
		st1	#$00
		st2	#$0F

		st0	#$02
		tia	spriteAttrTable,VDC_2,SPRITE_STRUCT_SIZE*(STAR_MAX+1)

		st0	#$13
		st1	#$00
		st2	#$0F

		cli
		rts


;----------------------------
setStarSprite
;
		phx
		phy

		clx
		cly

.loop:
		lda	starTable+STAR_X,x
		sta	<mul16c
		lda	starTable+STAR_X+1,x
		sta	<mul16c+1

		lda	starTable+STAR_Z+2,x
		sta	<mul16a
		lda	starTable+STAR_Z+3,x
		sta	<mul16a+1

		jsr	transform2DProc
		clc
		lda	<mul16a
		adc	<centerX
		sta	spriteStar+SPRITE_X,y
		lda	<mul16a+1
		adc	<centerX+1
		sta	spriteStar+SPRITE_X+1,y

		clc
		lda	spriteStar+SPRITE_X,y
		adc	#32-8
		sta	spriteStar+SPRITE_X,y
		lda	spriteStar+SPRITE_X+1,y
		adc	#0
		sta	spriteStar+SPRITE_X+1,y

		lda	starTable+STAR_Y,x
		sta	<mul16c
		lda	starTable+STAR_Y+1,x
		sta	<mul16c+1

		lda	starTable+STAR_Z+2,x
		sta	<mul16a
		lda	starTable+STAR_Z+3,x
		sta	<mul16a+1

		jsr	transform2DProc
		sec
		lda	<centerY
		sbc	<mul16a
		sta	spriteStar+SPRITE_Y,y
		lda	<centerY+1
		sbc	<mul16a+1
		sta	spriteStar+SPRITE_Y+1,y

		clc
		lda	spriteStar+SPRITE_Y,y
		adc	#64-8
		sta	spriteStar+SPRITE_Y,y
		lda	spriteStar+SPRITE_Y+1,y
		adc	#0
		sta	spriteStar+SPRITE_Y+1,y

		lda	#$42
		sta	spriteStar+SPRITE_NO,y
		lda	#$00
		sta	spriteStar+SPRITE_NO+1,y

		lda	#$00
		sta	spriteStar+SPRITE_ATTR,y
		lda	#$00
		sta	spriteStar+SPRITE_ATTR+1,y

		clc
		tya
		adc	#SPRITE_STRUCT_SIZE
		tay

		clc
		txa
		adc	#STAR_STRUCT_SIZE
		tax
		cpx	#STARTABLE_SIZE
		beq	.loopEnd
		jmp	.loop

.loopEnd
		ply
		plx
		rts


;----------------------------
moveStarTable:
;
		phx

		clx
.loop:
		clc
		lda	starTable+STAR_X,x
		adc	starShiftX
		sta	starTable+STAR_X,x

		lda	starTable+STAR_X+1,x
		adc	starShiftX+1
		sta	starTable+STAR_X+1,x

		clc
		lda	starTable+STAR_Y,x
		adc	starShiftY
		sta	starTable+STAR_Y,x

		lda	starTable+STAR_Y+1,x
		adc	starShiftY+1
		sta	starTable+STAR_Y+1,x

		sec
		lda	starTable+STAR_Z,x
		sbc	starTable+STAR_Z_SHIFT,x
		sta	starTable+STAR_Z,x

		lda	starTable+STAR_Z+1,x
		sbc	starTable+STAR_Z_SHIFT+1,x
		sta	starTable+STAR_Z+1,x

		lda	starTable+STAR_Z+2,x
		sbc	starTable+STAR_Z_SHIFT+2,x
		sta	starTable+STAR_Z+2,x

		lda	starTable+STAR_Z+3,x
		sbc	starTable+STAR_Z_SHIFT+3,x
		sta	starTable+STAR_Z+3,x

		bmi	.jp00
		bne	.jp01

		lda	starTable+STAR_Z+2,x
		cmp	#128
		bcs	.jp01

.jp00:
		jsr	setStarTable

.jp01:
		clc
		txa
		adc	#STAR_STRUCT_SIZE
		tax
		cpx	#STARTABLE_SIZE
		bne	.loop

		plx
		rts


;----------------------------
initStarTable:
;
		phx

		clx
.loop:
		jsr	setStarTable

		clc
		txa
		adc	#STAR_STRUCT_SIZE
		tax
		cpx	#STARTABLE_SIZE
		bne	.loop

		plx
		rts


;----------------------------
setStarTable:
;
		jsr	getRandom
		sta	starTable+STAR_X,x
		jsr	getRandom
		cmp	#$00
		bmi	.jp00
		and	#$03
		bra	.jp01
.jp00:
		ora	#$FC
.jp01:
		sta	starTable+STAR_X+1,x

		jsr	getRandom
		sta	starTable+STAR_Y,x
		jsr	getRandom
		cmp	#$00
		bmi	.jp02
		and	#$03
		bra	.jp03
.jp02:
		ora	#$FC
.jp03:
		sta	starTable+STAR_Y+1,x

		lda	#$00
		sta	starTable+STAR_Z,x
		lda	#$00
		sta	starTable+STAR_Z+1,x
		lda	#$00
		sta	starTable+STAR_Z+2,x
		lda	#$10
		sta	starTable+STAR_Z+3,x

		lda	#$00
		sta	starTable+STAR_Z_SHIFT,x
		lda	#$00
		sta	starTable+STAR_Z_SHIFT+1,x
		jsr	getRandom
		and	#$7F
		ora	#$20
		sta	starTable+STAR_Z_SHIFT+2,x
		lda	#$00
		sta	starTable+STAR_Z_SHIFT+3,x

		rts


;----------------------------
checkShotEnemy:
;
		phx
		phy

		clx
.shotLoop:
		lda	shotTable+OBJ_STATE,x
		bne	.shotJump1
		jmp	.shotJump0

.shotJump1:
		sec
		lda	shotTable+OBJ_X+2,x
		sbc	#200
		sta	hitCheckX0
		lda	shotTable+OBJ_X+3,x
		sbc	#0
		sta	hitCheckX0+1

		clc
		lda	shotTable+OBJ_X+2,x
		adc	#200
		sta	hitCheckX1
		lda	shotTable+OBJ_X+3,x
		adc	#0
		sta	hitCheckX1+1

		sec
		lda	shotTable+OBJ_Y+2,x
		sbc	#200
		sta	hitCheckY0
		lda	shotTable+OBJ_Y+3,x
		sbc	#0
		sta	hitCheckY0+1

		clc
		lda	shotTable+OBJ_Y+2,x
		adc	#200
		sta	hitCheckY1
		lda	shotTable+OBJ_Y+3,x
		adc	#0
		sta	hitCheckY1+1

		sec
		lda	shotTable+OBJ_Z+2,x
		sbc	#200
		sta	hitCheckZ0
		lda	shotTable+OBJ_Z+3,x
		sbc	#0
		sta	hitCheckZ0+1

		clc
		lda	shotTable+OBJ_Z+2,x
		adc	#200
		sta	hitCheckZ1
		lda	shotTable+OBJ_Z+3,x
		adc	#0
		sta	hitCheckZ1+1

		cly
.enemyLoop:
		lda	enemyTable+OBJ_STATE,y
		bne	.enemyJump1
		jmp	.enemyJump0

.enemyJump1:
		sec
		lda	hitCheckX0
		sbc	enemyTable+OBJ_X+2,y
		lda	hitCheckX0+1
		sbc	enemyTable+OBJ_X+3,y
		bmi	.enemyJump2
		jmp	.enemyJump0

.enemyJump2:
		sec
		lda	hitCheckX1
		sbc	enemyTable+OBJ_X+2,y
		lda	hitCheckX1+1
		sbc	enemyTable+OBJ_X+3,y
		bmi	.enemyJump0

		sec
		lda	hitCheckY0
		sbc	enemyTable+OBJ_Y+2,y
		lda	hitCheckY0+1
		sbc	enemyTable+OBJ_Y+3,y
		bpl	.enemyJump0

		sec
		lda	hitCheckY1
		sbc	enemyTable+OBJ_Y+2,y
		lda	hitCheckY1+1
		sbc	enemyTable+OBJ_Y+3,y
		bmi	.enemyJump0

		sec
		lda	hitCheckZ0
		sbc	enemyTable+OBJ_Z+2,y
		lda	hitCheckZ0+1
		sbc	enemyTable+OBJ_Z+3,y
		bpl	.enemyJump0

		sec
		lda	hitCheckZ1
		sbc	enemyTable+OBJ_Z+2,y
		lda	hitCheckZ1+1
		sbc	enemyTable+OBJ_Z+3,y
		bmi	.enemyJump0

		cla
		sta	shotTable+OBJ_STATE,x
		sta	enemyTable+OBJ_STATE,y

		lda	enemyTable+OBJ_X+2,y
		sta	effect_X
		lda	enemyTable+OBJ_X+3,y
		sta	effect_X+1

		lda	enemyTable+OBJ_Y+2,y
		sta	effect_Y
		lda	enemyTable+OBJ_Y+3,y
		sta	effect_Y+1

		lda	enemyTable+OBJ_Z+2,y
		sta	effect_Z
		lda	enemyTable+OBJ_Z+3,y
		sta	effect_Z+1

		lda	#EFFECT_TYPE_0
		sta	effect_Type

		jsr	setEffectTable

		bra	.shotJump0

.enemyJump0:
		clc
		tya
		adc	#ENEMY_SIZE
		tay
		cpy	#ENEMYTABLE_SIZE
		beq	.shotJump0
		jmp	.enemyLoop

.shotJump0:
		clc
		txa
		adc	#SHOT_SIZE
		tax
		cpx	#SHOTTABLE_SIZE
		beq	.shotLoopEnd
		jmp	.shotLoop

.shotLoopEnd:
		ply
		plx
		rts


;----------------------------
checkShotEshot:
;
		phx
		phy

		clx
.shotLoop:
		lda	shotTable+OBJ_STATE,x
		bne	.shotJump1
		jmp	.shotJump0

.shotJump1:
		sec
		lda	shotTable+OBJ_X+2,x
		sbc	#100
		sta	hitCheckX0
		lda	shotTable+OBJ_X+3,x
		sbc	#0
		sta	hitCheckX0+1

		clc
		lda	shotTable+OBJ_X+2,x
		adc	#100
		sta	hitCheckX1
		lda	shotTable+OBJ_X+3,x
		adc	#0
		sta	hitCheckX1+1

		sec
		lda	shotTable+OBJ_Y+2,x
		sbc	#100
		sta	hitCheckY0
		lda	shotTable+OBJ_Y+3,x
		sbc	#0
		sta	hitCheckY0+1

		clc
		lda	shotTable+OBJ_Y+2,x
		adc	#100
		sta	hitCheckY1
		lda	shotTable+OBJ_Y+3,x
		adc	#0
		sta	hitCheckY1+1

		sec
		lda	shotTable+OBJ_Z+2,x
		sbc	#100
		sta	hitCheckZ0
		lda	shotTable+OBJ_Z+3,x
		sbc	#0
		sta	hitCheckZ0+1

		clc
		lda	shotTable+OBJ_Z+2,x
		adc	#100
		sta	hitCheckZ1
		lda	shotTable+OBJ_Z+3,x
		adc	#0
		sta	hitCheckZ1+1

		cly
.eshotLoop:
		lda	eshotTable+OBJ_STATE,y
		bne	.eshotJump1
		jmp	.eshotJump0

.eshotJump1:
		sec
		lda	hitCheckX0
		sbc	eshotTable+OBJ_X+2,y
		lda	hitCheckX0+1
		sbc	eshotTable+OBJ_X+3,y
		bmi	.eshotJump2
		jmp	.eshotJump0

.eshotJump2:
		sec
		lda	hitCheckX1
		sbc	eshotTable+OBJ_X+2,y
		lda	hitCheckX1+1
		sbc	eshotTable+OBJ_X+3,y
		bmi	.eshotJump0

		sec
		lda	hitCheckY0
		sbc	eshotTable+OBJ_Y+2,y
		lda	hitCheckY0+1
		sbc	eshotTable+OBJ_Y+3,y
		bpl	.eshotJump0

		sec
		lda	hitCheckY1
		sbc	eshotTable+OBJ_Y+2,y
		lda	hitCheckY1+1
		sbc	eshotTable+OBJ_Y+3,y
		bmi	.eshotJump0

		sec
		lda	hitCheckZ0
		sbc	eshotTable+OBJ_Z+2,y
		lda	hitCheckZ0+1
		sbc	eshotTable+OBJ_Z+3,y
		bpl	.eshotJump0

		sec
		lda	hitCheckZ1
		sbc	eshotTable+OBJ_Z+2,y
		lda	hitCheckZ1+1
		sbc	eshotTable+OBJ_Z+3,y
		bmi	.eshotJump0

		cla
		sta	shotTable+OBJ_STATE,x
		sta	eshotTable+OBJ_STATE,y

		lda	eshotTable+OBJ_X+2,y
		sta	effect_X
		lda	eshotTable+OBJ_X+3,y
		sta	effect_X+1

		lda	eshotTable+OBJ_Y+2,y
		sta	effect_Y
		lda	eshotTable+OBJ_Y+3,y
		sta	effect_Y+1

		lda	eshotTable+OBJ_Z+2,y
		sta	effect_Z
		lda	eshotTable+OBJ_Z+3,y
		sta	effect_Z+1

		lda	#EFFECT_TYPE_1
		sta	effect_Type

		jsr	setEffectTable

		bra	.shotJump0

.eshotJump0:
		clc
		tya
		adc	#ESHOT_SIZE
		tay
		cpy	#ESHOTTABLE_SIZE
		beq	.shotJump0
		jmp	.eshotLoop

.shotJump0:
		clc
		txa
		adc	#SHOT_SIZE
		tax
		cpx	#SHOTTABLE_SIZE
		beq	.shotLoopEnd
		jmp	.shotLoop

.shotLoopEnd:
		ply
		plx
		rts


;----------------------------
setEnemy:
;
		lda	enemyTimer
		inc	a
		and	#$7F
		sta	enemyTimer
		bne	.setEnemyEnd

		jsr	getRandom
		sta	enemy_X
		jsr	signExt
		sta	enemy_X+1
		asl	enemy_X
		rol	enemy_X+1
		asl	enemy_X
		rol	enemy_X+1

		jsr	getRandom
		sta	enemy_Y
		jsr	signExt
		sta	enemy_Y+1
		asl	enemy_Y
		rol	enemy_Y+1
		asl	enemy_Y
		rol	enemy_Y+1

		movw	enemy_Z,#$1000
		jsr	setEnemyTable
.setEnemyEnd:
		rts


;----------------------------
initEnemyTable:
;
		phx

		clx
.initEnemyTableLoop:
		lda	#OBJ_NO_ENEMY0
		sta	enemyTable+OBJ_NO,x
		stz	enemyTable+OBJ_STATE,x
		clc
		txa
		adc	#ENEMY_SIZE
		tax
		cpx	#ENEMYTABLE_SIZE
		bne	.initEnemyTableLoop

		plx
		rts


;----------------------------
setEnemyTable:
;
		phx

		clx
.setEnemyTableLoop:
		lda	enemyTable+OBJ_STATE,x
		bne	.setEnemyTableJump0

		lda	#$01
		sta	enemyTable+OBJ_STATE,x

		lda	#$02
		sta	enemyTable+OBJ_COLOR,x

		stz	enemyTable+OBJ_X,x
		stz	enemyTable+OBJ_X+1,x
		lda	enemy_X
		sta	enemyTable+OBJ_X+2,x
		lda	enemy_X+1
		sta	enemyTable+OBJ_X+3,x

		stz	enemyTable+OBJ_Y,x
		stz	enemyTable+OBJ_Y+1,x
		lda	enemy_Y
		sta	enemyTable+OBJ_Y+2,x
		lda	enemy_Y+1
		sta	enemyTable+OBJ_Y+3,x

		stz	enemyTable+OBJ_Z,x
		stz	enemyTable+OBJ_Z+1,x
		lda	enemy_Z
		sta	enemyTable+OBJ_Z+2,x
		lda	enemy_Z+1
		sta	enemyTable+OBJ_Z+3,x

		stz	enemyTable+OBJ_RX,x
		stz	enemyTable+OBJ_RY,x
		stz	enemyTable+OBJ_RZ,x

		stz	enemyTable+ENEMY_TIME,x

		bra	.setEnemyTableEnd

.setEnemyTableJump0:
		clc
		txa
		adc	#ENEMY_SIZE
		tax
		cpx	#ENEMYTABLE_SIZE
		bne	.setEnemyTableLoop

.setEnemyTableEnd:
		plx
		rts


;----------------------------
moveEnemyTable:
;
		phx

		clx
.moveEnemyTableLoop:
		lda	enemyTable+OBJ_STATE,x
		beq	.moveEnemyTableJump0

		clc
		lda	enemyTable+OBJ_RY,x
		adc	#$04
		sta	enemyTable+OBJ_RY,x

		clc
		lda	enemyTable+OBJ_Z+2,x
		adc	#LOW(ENEMY0_Z_SHIFT)
		sta	enemyTable+OBJ_Z+2,x

		lda	enemyTable+OBJ_Z+3,x
		adc	#HIGH(ENEMY0_Z_SHIFT)
		sta	enemyTable+OBJ_Z+3,x
		bmi	.moveEnemyTableJump1
		beq	.moveEnemyTableJump0

		lda	enemyTable+ENEMY_TIME,x
		inc	a
		and	#$1F
		sta	enemyTable+ENEMY_TIME,x
		bne	.moveEnemyTableJump0

		lda	enemyTable+OBJ_X+2,x
		sta	eshot_X
		lda	enemyTable+OBJ_X+3,x
		sta	eshot_X+1

		lda	enemyTable+OBJ_Y+2,x
		sta	eshot_Y
		lda	enemyTable+OBJ_Y+3,x
		sta	eshot_Y+1

		lda	enemyTable+OBJ_Z+2,x
		sta	eshot_Z
		lda	enemyTable+OBJ_Z+3,x
		sta	eshot_Z+1

		jsr	setEshotTable

		bra	.moveEnemyTableJump0

.moveEnemyTableJump1:
		stz	enemyTable+OBJ_STATE,x

.moveEnemyTableJump0:
		clc
		txa
		adc	#ENEMY_SIZE
		tax
		cpx	#ENEMYTABLE_SIZE
		beq	.moveEnemyTableEnd
		jmp	.moveEnemyTableLoop

.moveEnemyTableEnd:
		plx
		rts


;----------------------------
regEnemyTable:
;
		phx

		clx
.regEnemyTableLoop:
		lda	enemyTable+OBJ_STATE,x
		beq	.regEnemyTableJump0

		clc
		txa
		adc	#LOW(enemyTable)
		sta	objReg_AddrWork
		cla
		adc	#HIGH(enemyTable)
		sta	objReg_AddrWork+1

		lda	enemyTable+OBJ_Z+2,x
		sta	objReg_ZWork
		lda	enemyTable+OBJ_Z+3,x
		sta	objReg_ZWork+1

		jsr	setObjRegTable

.regEnemyTableJump0:
		clc
		txa
		adc	#ENEMY_SIZE
		tax
		cpx	#ENEMYTABLE_SIZE
		bne	.regEnemyTableLoop

		plx
		rts


;----------------------------
initEffectTable:
;
		phx

		clx
.initEffectTableLoop:
		stz	effectTable+OBJ_NO,x
		stz	effectTable+OBJ_STATE,x
		clc
		txa
		adc	#EFFECT_SIZE
		tax
		cpx	#EFFECTTABLE_SIZE
		bne	.initEffectTableLoop

		plx
		rts


;----------------------------
setEffectTable:
;
		phx

		clx
.setEffectTableLoop:
		lda	effectTable+OBJ_STATE,x
		bne	.setEffectTableJump0

		lda	#$01
		sta	effectTable+OBJ_STATE,x

		stz	effectTable+OBJ_X,x
		stz	effectTable+OBJ_X+1,x
		lda	effect_X
		sta	effectTable+OBJ_X+2,x
		lda	effect_X+1
		sta	effectTable+OBJ_X+3,x

		stz	effectTable+OBJ_Y,x
		stz	effectTable+OBJ_Y+1,x
		lda	effect_Y
		sta	effectTable+OBJ_Y+2,x
		lda	effect_Y+1
		sta	effectTable+OBJ_Y+3,x

		stz	effectTable+OBJ_Z,x
		stz	effectTable+OBJ_Z+1,x
		lda	effect_Z
		sta	effectTable+OBJ_Z+2,x
		lda	effect_Z+1
		sta	effectTable+OBJ_Z+3,x

		lda	effect_Type
		sta	effectTable+EFFECT_TYPE,x

		stz	effectTable+EFFECT_TIME,x

		stz	effectTable+OBJ_RX,x
		stz	effectTable+OBJ_RY,x
		stz	effectTable+OBJ_RZ,x

		bra	.setEffectTableEnd

.setEffectTableJump0:
		clc
		txa
		adc	#EFFECT_SIZE
		tax
		cpx	#EFFECTTABLE_SIZE
		bne	.setEffectTableLoop

.setEffectTableEnd:
		plx
		rts


;----------------------------
moveEffectTable:
;
		phx

		clx
.moveEffectTableLoop:
		lda	effectTable+OBJ_STATE,x
		beq	.moveEffectTableJump0

		lda	effectTable+EFFECT_TYPE,x
		bne	.moveEffectTableJump2

;EFFECT_TYPE_0
		lda	effectTable+EFFECT_TIME,x
		cmp	#7
		bne	.moveEffectTableJump1

		stz	effectTable+OBJ_STATE,x
		bra	.moveEffectTableJump0

.moveEffectTableJump1:
		inc	a
		sta	effectTable+EFFECT_TIME,x
		bra	.moveEffectTableJump0

;EFFECT_TYPE_1
.moveEffectTableJump2:
		lda	effectTable+EFFECT_TIME,x
		cmp	#3
		bne	.moveEffectTableJump3

		stz	effectTable+OBJ_STATE,x
		bra	.moveEffectTableJump0

.moveEffectTableJump3:
		inc	a
		sta	effectTable+EFFECT_TIME,x

.moveEffectTableJump0:
		clc
		txa
		adc	#EFFECT_SIZE
		tax
		cpx	#EFFECTTABLE_SIZE
		beq	.moveEffectTableEnd
		jmp	.moveEffectTableLoop

.moveEffectTableEnd:
		plx
		rts


;----------------------------
regEffectTable:
;
		phx

		clx
.regEffectTableLoop:
		lda	effectTable+OBJ_STATE,x
		beq	.regEffectTableJump0

		clc
		txa
		adc	#LOW(effectTable)
		sta	objReg_AddrWork
		cla
		adc	#HIGH(effectTable)
		sta	objReg_AddrWork+1

		lda	effectTable+OBJ_Z+2,x
		sta	objReg_ZWork
		lda	effectTable+OBJ_Z+3,x
		sta	objReg_ZWork+1

		lda	effectTable+EFFECT_TIME,x
		and	#$01
		inc	a
		sta	effectTable+OBJ_COLOR,x


		lda	effectTable+EFFECT_TYPE,x
		bne	.regEffectTableJump1

;EFFECT_TYPE_0
		lda	effectTable+EFFECT_TIME,x
		asl	a
		clc
		adc	#OBJ_NO_EFFECT0
		sta	effectTable+OBJ_NO,x

		bra	.regEffectTableJump2

;EFFECT_TYPE_1
.regEffectTableJump1:
		lda	effectTable+EFFECT_TIME,x
		asl	a
		clc
		adc	#OBJ_NO_EFFECT1
		sta	effectTable+OBJ_NO,x

.regEffectTableJump2:
		jsr	setObjRegTable

.regEffectTableJump0:
		clc
		txa
		adc	#EFFECT_SIZE
		tax
		cpx	#EFFECTTABLE_SIZE
		bne	.regEffectTableLoop

		plx
		rts


;----------------------------
initShotTable:
;
		phx

		clx
.initShotTableLoop:
		lda	#OBJ_NO_SHOT
		sta	shotTable+OBJ_NO,x
		stz	shotTable+OBJ_STATE,x
		clc
		txa
		adc	#SHOT_SIZE
		tax
		cpx	#SHOTTABLE_SIZE
		bne	.initShotTableLoop

		plx
		rts


;----------------------------
setShotTable:
;
		phx

		clx
.setShotTableLoop:
		lda	shotTable+OBJ_STATE,x
		bne	.setShotTableJump0

		lda	#$01
		sta	shotTable+OBJ_STATE,x

		lda	#$03
		sta	shotTable+OBJ_COLOR,x

		stz	shotTable+OBJ_X,x
		stz	shotTable+OBJ_X+1,x
		lda	shipTranslationX
		sta	shotTable+OBJ_X+2,x
		lda	shipTranslationX+1
		sta	shotTable+OBJ_X+3,x

		stz	shotTable+OBJ_Y,x
		stz	shotTable+OBJ_Y+1,x
		lda	shipTranslationY
		sta	shotTable+OBJ_Y+2,x
		lda	shipTranslationY+1
		sta	shotTable+OBJ_Y+3,x

		stz	shotTable+OBJ_Z,x
		stz	shotTable+OBJ_Z+1,x
		stz	shotTable+OBJ_Z+2,x
		stz	shotTable+OBJ_Z+3,x

		stz	shotTable+OBJ_RX,x
		stz	shotTable+OBJ_RY,x
		stz	shotTable+OBJ_RZ,x

		bra	.setShotTableEnd

.setShotTableJump0:
		clc
		txa
		adc	#SHOT_SIZE
		tax
		cpx	#SHOTTABLE_SIZE
		bne	.setShotTableLoop

.setShotTableEnd:
		plx
		rts


;----------------------------
moveShotTable:
;
		phx

		clx
.moveShotTableLoop:
		lda	shotTable+OBJ_STATE,x
		beq	.moveShotTableJump0

		clc
		lda	shotTable+OBJ_RZ,x
		adc	#$08
		sta	shotTable+OBJ_RZ,x

		clc
		lda	shotTable+OBJ_Z+2,x
		adc	#LOW(SHOT_Z_SHIFT)
		sta	shotTable+OBJ_Z+2,x

		lda	shotTable+OBJ_Z+3,x
		adc	#HIGH(SHOT_Z_SHIFT)
		sta	shotTable+OBJ_Z+3,x

		cmp	#SHOT_Z_MAX
		bmi	.moveShotTableJump0

		stz	shotTable+OBJ_STATE,x

.moveShotTableJump0:
		clc
		txa
		adc	#SHOT_SIZE
		tax
		cpx	#SHOTTABLE_SIZE
		beq	.moveShotTableEnd
		jmp	.moveShotTableLoop

.moveShotTableEnd:
		plx
		rts


;----------------------------
regShotTable:
;
		phx

		clx
.regShotTableLoop:
		lda	shotTable+OBJ_STATE,x
		beq	.regShotTableJump0

		clc
		txa
		adc	#LOW(shotTable)
		sta	objReg_AddrWork
		cla
		adc	#HIGH(shotTable)
		sta	objReg_AddrWork+1

		lda	shotTable+OBJ_Z+2,x
		sta	objReg_ZWork
		lda	shotTable+OBJ_Z+3,x
		sta	objReg_ZWork+1

		jsr	setObjRegTable

.regShotTableJump0:
		clc
		txa
		adc	#SHOT_SIZE
		tax
		cpx	#SHOTTABLE_SIZE
		bne	.regShotTableLoop

		plx
		rts


;----------------------------
initEshotTable:
;
		phx

		clx
.initEshotTableLoop:
		lda	#OBJ_NO_ESHOT
		sta	eshotTable+OBJ_NO,x
		stz	eshotTable+OBJ_STATE,x
		clc
		txa
		adc	#ESHOT_SIZE
		tax
		cpx	#ESHOTTABLE_SIZE
		bne	.initEshotTableLoop

		plx
		rts


;----------------------------
setEshotTable:
;
		phx

		clx
.setEshotTableLoop:
		lda	eshotTable+OBJ_STATE,x
		beq	.setEshotTableJump1
		jmp	.setEshotTableJump0

.setEshotTableJump1:
		lda	#$01
		sta	eshotTable+OBJ_STATE,x

		lda	#$01
		sta	eshotTable+OBJ_COLOR,x

		stz	eshotTable+OBJ_X,x
		stz	eshotTable+OBJ_X+1,x
		lda	eshot_X
		sta	eshotTable+OBJ_X+2,x
		lda	eshot_X+1
		sta	eshotTable+OBJ_X+3,x

		stz	eshotTable+OBJ_Y,x
		stz	eshotTable+OBJ_Y+1,x
		lda	eshot_Y
		sta	eshotTable+OBJ_Y+2,x
		lda	eshot_Y+1
		sta	eshotTable+OBJ_Y+3,x

		stz	eshotTable+OBJ_Z,x
		stz	eshotTable+OBJ_Z+1,x
		lda	eshot_Z
		sta	eshotTable+OBJ_Z+2,x
		lda	eshot_Z+1
		sta	eshotTable+OBJ_Z+3,x

		stz	eshotTable+OBJ_RX,x
		stz	eshotTable+OBJ_RY,x
		stz	eshotTable+OBJ_RZ,x

		movw	angleX0,eshot_X
		movw	angleY0,eshot_Y
		movw	angleZ0,eshot_Z

		movw	angleX1,shipTranslationX
		movw	angleY1,shipTranslationY
		movw	angleZ1,shipTranslationZ

		movw	angleShift,#ESHOT_SHIFT

		jsr	getAngleShift

		lda	angleX0
		sta	eshotTable+ESHOT_SHIFTX,x
		lda	angleX0+1
		sta	eshotTable+ESHOT_SHIFTX+1,x
		lda	angleX0+2
		sta	eshotTable+ESHOT_SHIFTX+2,x
		lda	angleX0+3
		sta	eshotTable+ESHOT_SHIFTX+3,x

		lda	angleY0
		sta	eshotTable+ESHOT_SHIFTY,x
		lda	angleY0+1
		sta	eshotTable+ESHOT_SHIFTY+1,x
		lda	angleY0+2
		sta	eshotTable+ESHOT_SHIFTY+2,x
		lda	angleY0+3
		sta	eshotTable+ESHOT_SHIFTY+3,x

		lda	angleZ0
		sta	eshotTable+ESHOT_SHIFTZ,x
		lda	angleZ0+1
		sta	eshotTable+ESHOT_SHIFTZ+1,x
		lda	angleZ0+2
		sta	eshotTable+ESHOT_SHIFTZ+2,x
		lda	angleZ0+3
		sta	eshotTable+ESHOT_SHIFTZ+3,x

		bra	.setEshotTableEnd

.setEshotTableJump0:
		clc
		txa
		adc	#ESHOT_SIZE
		tax
		cpx	#ESHOTTABLE_SIZE
		beq	.setEshotTableEnd
		jmp	.setEshotTableLoop

.setEshotTableEnd:
		plx
		rts


;----------------------------
moveEshotTable:
;
		phx

		clx
.moveEshotTableLoop:
		lda	eshotTable+OBJ_STATE,x
		bne	.moveEshotTableJump1
		jmp	.moveEshotTableJump0

.moveEshotTableJump1:
		clc
		lda	eshotTable+OBJ_RX,x
		adc	#8
		sta	eshotTable+OBJ_RX,x

		clc
		lda	eshotTable+OBJ_RY,x
		adc	#8
		sta	eshotTable+OBJ_RY,x

		clc
		lda	eshotTable+OBJ_X,x
		adc	eshotTable+ESHOT_SHIFTX,x
		sta	eshotTable+OBJ_X,x

		lda	eshotTable+OBJ_X+1,x
		adc	eshotTable+ESHOT_SHIFTX+1,x
		sta	eshotTable+OBJ_X+1,x

		lda	eshotTable+OBJ_X+2,x
		adc	eshotTable+ESHOT_SHIFTX+2,x
		sta	eshotTable+OBJ_X+2,x

		lda	eshotTable+OBJ_X+3,x
		adc	eshotTable+ESHOT_SHIFTX+3,x
		sta	eshotTable+OBJ_X+3,x

		clc
		lda	eshotTable+OBJ_Y,x
		adc	eshotTable+ESHOT_SHIFTY,x
		sta	eshotTable+OBJ_Y,x

		lda	eshotTable+OBJ_Y+1,x
		adc	eshotTable+ESHOT_SHIFTY+1,x
		sta	eshotTable+OBJ_Y+1,x

		lda	eshotTable+OBJ_Y+2,x
		adc	eshotTable+ESHOT_SHIFTY+2,x
		sta	eshotTable+OBJ_Y+2,x

		lda	eshotTable+OBJ_Y+3,x
		adc	eshotTable+ESHOT_SHIFTY+3,x
		sta	eshotTable+OBJ_Y+3,x

		clc
		lda	eshotTable+OBJ_Z,x
		adc	eshotTable+ESHOT_SHIFTZ,x
		sta	eshotTable+OBJ_Z,x

		lda	eshotTable+OBJ_Z+1,x
		adc	eshotTable+ESHOT_SHIFTZ+1,x
		sta	eshotTable+OBJ_Z+1,x

		lda	eshotTable+OBJ_Z+2,x
		adc	eshotTable+ESHOT_SHIFTZ+2,x
		sta	eshotTable+OBJ_Z+2,x

		lda	eshotTable+OBJ_Z+3,x
		adc	eshotTable+ESHOT_SHIFTZ+3,x
		sta	eshotTable+OBJ_Z+3,x

		bpl	.moveEshotTableJump0

		stz	eshotTable+OBJ_STATE,x

.moveEshotTableJump0:
		clc
		txa
		adc	#ESHOT_SIZE
		tax
		cpx	#ESHOTTABLE_SIZE
		beq	.moveEshotTableEnd
		jmp	.moveEshotTableLoop

.moveEshotTableEnd:
		plx
		rts


;----------------------------
regEshotTable:
;
		phx

		clx
.regEshotTableLoop:
		lda	eshotTable+OBJ_STATE,x
		beq	.regEshotTableJump0

		clc
		txa
		adc	#LOW(eshotTable)
		sta	objReg_AddrWork
		cla
		adc	#HIGH(eshotTable)
		sta	objReg_AddrWork+1

		lda	eshotTable+OBJ_Z+2,x
		sta	objReg_ZWork
		lda	eshotTable+OBJ_Z+3,x
		sta	objReg_ZWork+1

		jsr	setObjRegTable

.regEshotTableJump0:
		clc
		txa
		adc	#ESHOT_SIZE
		tax
		cpx	#ESHOTTABLE_SIZE
		bne	.regEshotTableLoop

		plx
		rts


;----------------------------
initObjRegTable:
;
		movw	objRegTable+OBJREG_Z,#$4000
		mov	objRegTable_index,#OBJREG_SIZE
		rts


;----------------------------
setObjRegTable:
;
		phx

		ldx	objRegTable_index

		clc
		lda	objRegTable_index
		adc	#OBJREG_SIZE
		sta	objRegTable_index

		lda	objReg_AddrWork
		sta	objRegTable+OBJREG_ADDR,x
		lda	objReg_AddrWork+1
		sta	objRegTable+OBJREG_ADDR+1,x

		lda	objReg_ZWork
		sta	objRegTable+OBJREG_Z,x
		lda	objReg_ZWork+1
		sta	objRegTable+OBJREG_Z+1,x

.setObjRegTableLoop:
		sec
		lda	objRegTable-OBJREG_SIZE+OBJREG_Z,x
		sbc	objRegTable+OBJREG_Z,x
		lda	objRegTable-OBJREG_SIZE+OBJREG_Z+1,x
		sbc	objRegTable+OBJREG_Z+1,x

		bpl	.setObjRegTableEnd

		lda	objRegTable-OBJREG_SIZE+OBJREG_ADDR,x
		sta	objReg_AddrWork
		lda	objRegTable-OBJREG_SIZE+OBJREG_ADDR+1,x
		sta	objReg_AddrWork+1

		lda	objRegTable+OBJREG_ADDR,x
		sta	objRegTable-OBJREG_SIZE+OBJREG_ADDR,x
		lda	objRegTable+OBJREG_ADDR+1,x
		sta	objRegTable-OBJREG_SIZE+OBJREG_ADDR+1,x

		lda	objReg_AddrWork
		sta	objRegTable+OBJREG_ADDR,x
		lda	objReg_AddrWork+1
		sta	objRegTable+OBJREG_ADDR+1,x

		lda	objRegTable-OBJREG_SIZE+OBJREG_Z,x
		sta	objReg_ZWork
		lda	objRegTable-OBJREG_SIZE+OBJREG_Z+1,x
		sta	objReg_ZWork+1

		lda	objRegTable+OBJREG_Z,x
		sta	objRegTable-OBJREG_SIZE+OBJREG_Z,x
		lda	objRegTable+OBJREG_Z+1,x
		sta	objRegTable-OBJREG_SIZE+OBJREG_Z+1,x

		lda	objReg_ZWork
		sta	objRegTable+OBJREG_Z,x
		lda	objReg_ZWork+1
		sta	objRegTable+OBJREG_Z+1,x

		sec
		txa
		sbc	#OBJREG_SIZE
		tax

		bra	.setObjRegTableLoop

.setObjRegTableEnd:
		plx
		rts


;----------------------------
drawObjRegTable:
;
		phx

		ldx	#OBJREG_SIZE

.drawObjRegTableLoop:
		cpx	objRegTable_index
		beq	.drawObjRegTableEnd

		lda	objRegTable+OBJREG_ADDR,x
		sta	<objRegTable_AddrWork
		lda	objRegTable+OBJREG_ADDR+1,x
		sta	<objRegTable_AddrWork+1

		ldy	#OBJ_X+2
		lda	[objRegTable_AddrWork],y
		sta	<translationX
		iny
		lda	[objRegTable_AddrWork],y
		sta	<translationX+1

		ldy	#OBJ_Y+2
		lda	[objRegTable_AddrWork],y
		sta	<translationY
		iny
		lda	[objRegTable_AddrWork],y
		sta	<translationY+1

		ldy	#OBJ_Z+2
		lda	[objRegTable_AddrWork],y
		sta	<translationZ
		iny
		lda	[objRegTable_AddrWork],y
		sta	<translationZ+1

		ldy	#OBJ_RX
		lda	[objRegTable_AddrWork],y
		sta	<rotationX

		ldy	#OBJ_RY
		lda	[objRegTable_AddrWork],y
		sta	<rotationY

		ldy	#OBJ_RZ
		lda	[objRegTable_AddrWork],y
		sta	<rotationZ

		ldy	#OBJ_NO
		lda	[objRegTable_AddrWork],y
		tay
		lda	modelData,y
		sta	<modelAddr
		lda	modelData+1,y
		sta	<modelAddr+1

		ldy	#OBJ_COLOR
		lda	[objRegTable_AddrWork],y
		jsr	setLineColor

		lda	#ROTATIONZXY
		sta	<rotationSelect

		jsr	drawModel2

		clc
		txa
		adc	#OBJREG_SIZE
		tax

		bra	.drawObjRegTableLoop

.drawObjRegTableEnd:
		plx
		rts


;----------------------------
getAngleShift:
;
		phx
		phy

		jsr	getAngle

;x=x		y=zsinA+ycosA	z=zcosA-ysinA
		ldy	ansAngleX
		lda	sinDataLow,y
		sta	angleY0
		lda	sinDataHigh,y
		sta	angleY0+1

		ldy	ansAngleX
		lda	cosDataLow,y
		sta	angleZ0
		lda	cosDataHigh,y
		sta	angleZ0+1

;x=xcosA-zsinA	y=y		z=xsinA+zcosA
		ldy	ansAngleY
		clc
		lda	sinDataLow,y
		eor	#$FF
		adc	#$01
		sta	<mul16a
		lda	sinDataHigh,y
		eor	#$FF
		adc	#$00
		sta	<mul16a+1

		movw	<mul16b,angleZ0

		jsr	smul16

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		movw	angleX0,<mul16d

;--------------------------------
		ldy	ansAngleY
		lda	cosDataLow,y
		sta	<mul16a
		lda	cosDataHigh,y
		sta	<mul16a+1

		movw	<mul16b,angleZ0

		jsr	smul16

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		movw	angleZ0,<mul16d

;--------------------------------
		movw	<mul16a,angleX0
		movw	<mul16b,angleShift
		jsr	smul16

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		movq	angleX0,<mul16c

;--------------------------------
		movw	<mul16a,angleY0
		movw	<mul16b,angleShift
		jsr	smul16

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		movq	angleY0,<mul16c

;--------------------------------
		movw	<mul16a,angleZ0
		movw	<mul16b,angleShift
		jsr	smul16

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1

		movq	angleZ0,<mul16c

		ply
		plx
		rts


;----------------------------
getAngle:
		phx

		subw	<mul16a,angleZ1,angleZ0
		subw	<mul16b,angleX1,angleX0
		jsr	atan

		tax
		eor	#$FF
		inc	a
		sta	ansAngleY

		subw	transform2DWork0,  angleX1,angleX0
		subw	transform2DWork0+2,angleY1,angleY0
		subw	transform2DWork0+4,angleZ1,angleZ0
		mov	vertexCount,#1
		jsr	vertexRotationY

		movw	<mul16a,transform2DWork0+4
		movw	<mul16b,transform2DWork0+2
		jsr	atan
		sta	ansAngleX

		plx
		rts


;----------------------------
mainIrqProc:
		jsr	wireIrqProc
		bcs	.irqEnd

		jsr	getPadData

		dec	frameCount
		bne	.irqEnd
		mov	drawCountWork,drawCount
		mov	frameCount,#60
		stz	drawCount

.irqEnd:
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
		tia	palettebgdata, VCE_4, $80

		stz	VCE_2
		lda	#$01
		sta	VCE_3
		tia	palettebgdata, VCE_4, $80

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
modelData
		.dw	0			;0
		.dw	modelShotData		;2
		.dw	modelEshotData		;4
		.dw	modelEnemy0Data		;6

		.dw	modelEffect0_0Data	;8
		.dw	modelEffect0_1Data	;10
		.dw	modelEffect0_2Data	;12
		.dw	modelEffect0_3Data	;14
		.dw	modelEffect0_4Data	;16
		.dw	modelEffect0_5Data	;18
		.dw	modelEffect0_6Data	;20
		.dw	modelEffect0_7Data	;22

		.dw	modelEffect1_0Data	;24
		.dw	modelEffect1_1Data	;26
		.dw	modelEffect1_2Data	;28
		.dw	modelEffect1_3Data	;30

;----------------------------
modelEffect0_0Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_0DataVertex
		.db	16	;vertex count

modelEffect0_0DataWire
		.db	 0*6, 1*6	;0
		.db	 2*6, 3*6	;0
		.db	 4*6, 5*6	;0
		.db	 6*6, 7*6	;0
		.db	 8*6, 9*6	;0
		.db	10*6,11*6	;0
		.db	12*6,13*6	;0
		.db	14*6,15*6	;0

modelEffect0_0DataVertex
		.dw	  -43,  -25,   -7;0
		.dw	   43,   25,    7;1
		.dw	  -32,  -21,  -32;2
		.dw	   32,   21,   32;3
		.dw	  -48,   -8,  -10;4
		.dw	   48,    8,   10;5
		.dw	  -47,   15,   10;6
		.dw	   47,  -15,  -10;7
		.dw	  -43,  -25,   -6;8
		.dw	   43,   25,    6;9
		.dw	  -44,   24,    4;10
		.dw	   44,  -24,   -4;11
		.dw	  -48,   10,    8;12
		.dw	   48,  -10,   -8;13
		.dw	   -2,  -25,  -43;14
		.dw	    2,   25,   43;15


;----------------------------
modelEffect0_1Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_1DataVertex
		.db	16	;vertex count

modelEffect0_1DataVertex
		.dw	  -53,  -10,    3;0
		.dw	   33,   39,   16;1
		.dw	  -40,  -31,  -17;2
		.dw	   23,   12,   47;3
		.dw	  -52,  -12,   10;4
		.dw	   45,    5,   29;5
		.dw	  -41,   21,   28;6
		.dw	   53,   -9,    8;7
		.dw	  -53,  -10,    3;8
		.dw	   33,   40,   15;9
		.dw	  -34,   40,   11;10
		.dw	   53,   -7,    2;11
		.dw	  -45,   13,   27;12
		.dw	   52,   -6,   12;13
		.dw	  -12,  -40,  -34;14
		.dw	   -8,   10,   52;15


;----------------------------
modelEffect0_2Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_2DataVertex
		.db	16	;vertex count

modelEffect0_2DataVertex
		.dw	  -63,    4,   12;0
		.dw	   23,   54,   26;1
		.dw	  -49,  -41,   -2;2
		.dw	   15,    2,   62;3
		.dw	  -55,  -15,   29;4
		.dw	   42,    2,   49;5
		.dw	  -35,   27,   46;6
		.dw	   59,   -2,   26;7
		.dw	  -63,    6,   11;8
		.dw	   23,   55,   23;9
		.dw	  -25,   56,   18;10
		.dw	   63,    9,    9;11
		.dw	  -41,   17,   46;12
		.dw	   56,   -2,   31;13
		.dw	  -22,  -55,  -25;14
		.dw	  -18,   -5,   61;15


;----------------------------
modelEffect0_3Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_3DataVertex
		.db	16	;vertex count

modelEffect0_3DataVertex
		.dw	  -73,   18,   22;0
		.dw	   13,   68,   35;1
		.dw	  -58,  -51,   13;2
		.dw	    6,   -8,   77;3
		.dw	  -58,  -19,   48;4
		.dw	   38,   -2,   68;5
		.dw	  -29,   34,   64;6
		.dw	   64,    4,   44;7
		.dw	  -73,   21,   20;8
		.dw	   13,   70,   32;9
		.dw	  -16,   73,   24;10
		.dw	   72,   26,   16;11
		.dw	  -37,   21,   65;12
		.dw	   60,    2,   50;13
		.dw	  -32,  -69,  -16;14
		.dw	  -28,  -20,   70;15


;----------------------------
modelEffect0_4Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_4DataVertex
		.db	16	;vertex count

modelEffect0_4DataVertex
		.dw	 -83,   33,   31;0
		.dw	   3,   83,   45;1
		.dw	 -66,  -61,   29;2
		.dw	  -2,  -18,   93;3
		.dw	 -62,  -22,   68;4
		.dw	  35,   -5,   88;5
		.dw	 -23,   40,   82;6
		.dw	  70,   10,   62;7
		.dw	 -83,   36,   28;8
		.dw	   3,   85,   40;9
		.dw	  -6,   89,   31;10
		.dw	  82,   42,   22;11
		.dw	 -33,   25,   85;12
		.dw	  64,    6,   69;13
		.dw	 -42,  -84,   -7;14
		.dw	 -38,  -34,   79;15


;----------------------------
modelEffect0_5Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_5DataVertex
		.db	16	;vertex count

modelEffect0_5DataVertex
		.dw	 -93,   47,   41;0
		.dw	  -7,   97,   54;1
		.dw	 -75,  -71,   44;2
		.dw	 -11,  -28,  108;3
		.dw	 -65,  -26,   87;4
		.dw	  31,   -9,  107;5
		.dw	 -17,   46,  100;6
		.dw	  76,   16,   80;7
		.dw	 -92,   51,   37;8
		.dw	  -6,  100,   49;9
		.dw	   3,  105,   37;10
		.dw	  91,   58,   29;11
		.dw	 -29,   29,  104;12
		.dw	  68,   10,   88;13
		.dw	 -52,  -99,    2;14
		.dw	 -48,  -49,   88;15


;----------------------------
modelEffect0_6Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_6DataVertex
		.db	16	;vertex count

modelEffect0_6DataVertex
		.dw	-103,   62,   50;0
		.dw	 -17,  112,   64;1
		.dw	 -83,  -81,   59;2
		.dw	 -20,  -38,  123;3
		.dw	 -69,  -29,  107;4
		.dw	  28,  -12,  126;5
		.dw	 -11,   53,  118;6
		.dw	  82,   23,   98;7
		.dw	-102,   66,   45;8
		.dw	 -16,  116,   57;9
		.dw	  13,  122,   44;10
		.dw	 100,   75,   35;11
		.dw	 -26,   33,  123;12
		.dw	  71,   14,  108;13
		.dw	 -62, -114,   11;14
		.dw	 -58,  -64,   97;15


;----------------------------
modelEffect0_7Data
		.dw	modelEffect0_0DataWire
		.db	8	;wire count
		.dw	modelEffect0_7DataVertex
		.db	16	;vertex count

modelEffect0_7DataVertex
		.dw	-113,   76,   60;0
		.dw	 -27,  126,   73;1
		.dw	 -92,  -90,   74;2
		.dw	 -28,  -48,  138;3
		.dw	 -72,  -32,  126;4
		.dw	  25,  -16,  146;5
		.dw	  -5,   59,  136;6
		.dw	  88,   29,  116;7
		.dw	-112,   81,   54;8
		.dw	 -26,  131,   66;9
		.dw	  22,  138,   51;10
		.dw	 110,   91,   42;11
		.dw	 -22,   37,  142;12
		.dw	  75,   18,  127;13
		.dw	 -72, -129,   20;14
		.dw	 -67,  -79,  106;15


;----------------------------
modelEffect1_0Data
		.dw	modelEffect1_0DataWire
		.db	6	;wire count
		.dw	modelEffect1_0DataVertex
		.db	12	;vertex count

modelEffect1_0DataWire
		.db	 0*6, 1*6	;0
		.db	 2*6, 3*6	;1
		.db	 4*6, 5*6	;2
		.db	 6*6, 7*6	;3
		.db	 8*6, 9*6	;4
		.db	10*6,11*6	;5

modelEffect1_0DataVertex
		.dw	 -21,  -12,   -4;0
		.dw	  21,   12,    4;1
		.dw	 -22,   12,    3;2
		.dw	  22,  -12,   -3;3
		.dw	 -25,   -5,    0;4
		.dw	  25,    5,    0;5
		.dw	 -25,   -4,    0;6
		.dw	  25,    4,    0;7
		.dw	 -24,    4,    5;8
		.dw	  24,   -4,   -5;9
		.dw	  13,  -10,  -19;10
		.dw	 -13,   10,   19;11


;----------------------------
modelEffect1_1Data
		.dw	modelEffect1_0DataWire
		.db	6	;wire count
		.dw	modelEffect1_1DataVertex
		.db	12	;vertex count

modelEffect1_1DataVertex
		.dw	 -31,    2,    6;0
		.dw	  11,   27,   14;1
		.dw	 -12,   28,   10;2
		.dw	  31,    4,    5;3
		.dw	 -28,   15,    1;4
		.dw	  21,   24,    1;5
		.dw	 -28,   15,    1;6
		.dw	  21,   24,    1;7
		.dw	 -21,    1,   24;8
		.dw	  28,   -8,   14;9
		.dw	   5,  -28,  -15;10
		.dw	 -21,   -8,   23;11


;----------------------------
modelEffect1_2Data
		.dw	modelEffect1_0DataWire
		.db	6	;wire count
		.dw	modelEffect1_2DataVertex
		.db	12	;vertex count

modelEffect1_2DataVertex
		.dw	 -41,   16,   16;0
		.dw	   1,   41,   24;1
		.dw	  -2,   44,   18;2
		.dw	  41,   19,   13;3
		.dw	 -32,   34,    1;4
		.dw	  17,   44,    2;5
		.dw	 -31,   35,    1;6
		.dw	  18,   44,    1;7
		.dw	 -17,   -3,   44;8
		.dw	  31,  -11,   34;9
		.dw	  -3,  -46,  -11;10
		.dw	 -29,  -26,   27;11


;----------------------------
modelEffect1_3Data
		.dw	modelEffect1_0DataWire
		.db	6	;wire count
		.dw	modelEffect1_3DataVertex
		.db	12	;vertex count

modelEffect1_3DataVertex
		.dw	 -51,   30,   26;0
		.dw	  -9,   55,   34;1
		.dw	   7,   59,   25;2
		.dw	  51,   35,   20;3
		.dw	 -36,   54,    2;4
		.dw	  13,   64,    2;5
		.dw	 -35,   55,    2;6
		.dw	  15,   63,    2;7
		.dw	 -14,   -6,   63;8
		.dw	  34,  -14,   53;9
		.dw	 -11,  -64,   -7;10
		.dw	 -37,  -44,   31;11


;----------------------------
modelShotData
		.dw	modelShotDataWire
		.db	6	;wire count
		.dw	modelShotDataVertex
		.db	6	;vertex count

modelShotDataWire
		.db	 0*6, 1*6	;0
		.db	 1*6, 2*6	;1
		.db	 2*6, 0*6	;2
		.db	 3*6, 4*6	;3
		.db	 4*6, 5*6	;4
		.db	 5*6, 3*6	;5

modelShotDataVertex
		.dw	 -100,    0,  100;0
		.dw	 -100,   25, -100;1
		.dw	 -100,  -25, -100;2
		.dw	  100,    0,  100;3
		.dw	  100,   25, -100;4
		.dw	  100,  -25, -100;5


;----------------------------
modelEshotData
		.dw	modelEshotDataWire
		.db	6	;wire count
		.dw	modelEshotDataVertex
		.db	4	;vertex count

modelEshotDataWire
		.db	 0*6, 1*6	;0
		.db	 0*6, 2*6	;1
		.db	 0*6, 3*6	;2
		.db	 1*6, 2*6	;3
		.db	 2*6, 3*6	;4
		.db	 3*6, 1*6	;5

modelEshotDataVertex
		.dw	    0,   25,    0;0
		.dw	    0,  -25,   35;1
		.dw	   31,  -25,  -18;2
		.dw	  -31,  -25,  -18;3


;----------------------------
modelEnemy0Data
		.dw	modelEnemy0DataWire
		.db	15	;wire count
		.dw	modelEnemy0DataVertex
		.db	16	;vertex count

modelEnemy0DataWire
		.db	 0*6, 1*6	;0
		.db	 2*6, 3*6	;1
		.db	 3*6, 4*6	;2
		.db	 4*6, 5*6	;3
		.db	 5*6, 2*6	;4

		.db	 0*6, 6*6	;5
		.db	 7*6, 8*6	;6
		.db	 8*6, 9*6	;7
		.db	 9*6,10*6	;8
		.db	10*6, 7*6	;9

		.db	 0*6,11*6	;10
		.db	12*6,13*6	;11
		.db	13*6,14*6	;12
		.db	14*6,15*6	;13
		.db	15*6,12*6	;14

modelEnemy0DataVertex
		.dw	    0,   80,    0;0

		.dw	    0,    0,  100;1
		.dw	    0,   80,   80;2
		.dw	  -25,    0,  100;3
		.dw	    0, -150,   80;4
		.dw	   25,    0,  100;5

		.dw	  -87,    0,  -50;6
		.dw	  -69,   80,  -40;7
		.dw	  -74,    0,  -72;8
		.dw	  -69, -150,  -40;9
		.dw	  -99,    0,  -28;10

		.dw	   87,    0,  -50;11
		.dw	   69,   80,  -40;12
		.dw	   99,    0,  -28;13
		.dw	   69, -150,  -40;14
		.dw	   74,    0,  -72;15


;----------------------------
vdpdata:
		.db	$05, $00, $00	;screen off +1
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $0D	;VSW $02 VDS $0D
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $03, $00	;VCR $03
		.db	$0F, $00, $00	;DMA +1 +1
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $40, $00	;32x64
		.db	$FF		;end


;----------------------------
palettebgdata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF
		;------------------ wireframe line color-- ----------------
		.dw	$0000, $0020, $0100, $0004, $0000, $0020, $0100, $0004,\
			$0000, $0020, $0100, $0004, $0000, $0020, $0100, $0004

		.dw	$0000, $0000, $0000, $0000, $0020, $0020, $0020, $0020,\
			$0100, $0100, $0100, $0100, $0004, $0004, $0004, $0004
		;----------------------------------------------------------


;----------------------------
spriteStarData
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
spriteSightsData
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $17, $E8,\
			$00, $00, $1C, $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;**********************************
		.bank	2
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
		lda	#SCREENZ
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
		lda	#SCREENZ
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

;centerY-mul16a
		subw	<clipFrontY, <centerY, <mul16a

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

		movq	<div32ans, <mul16c

		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ysinA

		subq	<mul16c, <div32ans, <mul16c	;xcosA-ysinA

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

		movq	<div32ans, <mul16c

		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ycosA

		addq	<mul16c, <div32ans, <mul16c	;xsinA+ycosA

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
;x=xcosA-zsinA	y=y		z=xsinA+zcosA
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

		movq	<div32ans, <mul16c

		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xcosA

		subq	<mul16c, <mul16c, <div32ans	;xcosA-zsinA

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

		movq	<div32ans, <mul16c

		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xsinA

		addq	<mul16c, <div32ans, <mul16c	;zcosA+xsinA

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
;x=x		y=ycosA+zsinA	z=-ysinA+zcosA
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

		movq	<div32ans, <mul16c

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zsinA

		addq	<mul16c, <div32ans, <mul16c	;ycosA+zsinA

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

		movq	<div32ans, <mul16c

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zcosA

		subq	<mul16c, <mul16c, <div32ans 	;-ysinA+zcosA

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
		sbc	#SCREENZ
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
;centerY-mul16a to Y0
		sec
		lda	<centerY
		sbc	<mul16a
		sta	transform2DWork0+2,y	;Y0
		lda	<centerY+1
		sbc	<mul16a+1
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
;mul16a(rough value) = mul16c(-32768_32767) * 128 / mul16a(1_32767)

		phy
;c sign
		lda	<mul16c+1
		pha
		bpl	.jp00
;c neg
		sec
		lda	<mul16c
		eor	#$FF
		adc	#0
		sta	<mul16c

		lda	<mul16c+1
		eor	#$FF
		adc	#0
		sta	<mul16c+1

.jp00:
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
		sta	<sqrt64a

		clc
		lda	<mulbank
		adc	#4
		tam	#$02

		lda	[muladdr]
		sta	<sqrt64a+1

		clc
		lda	<mulbank
		adc	#8
		tam	#$02

		lda	[muladdr]
		sta	<sqrt64a+2

;mul mul16c low byte
		lda	<mul16c
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a

		clc
		adc	#muldatBank
		sta	<mulbank
		tam	#$02

		lda	<mul16c
		and	#$1F
		ora	#$40
		stz	<muladdr
		sta	<muladdr+1

		ldy	<sqrt64a
		lda	[muladdr],y
		sta	<sqrt64b

		ldy	<sqrt64a+1
		lda	[muladdr],y
		sta	<sqrt64b+1

		ldy	<sqrt64a+2
		lda	[muladdr],y
		sta	<sqrt64b+2

		lda	<mulbank
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<sqrt64a
		lda	[muladdr],y
		adc	<sqrt64b+1
		sta	<sqrt64b+1

		ldy	<sqrt64a+1
		lda	[muladdr],y
		adc	<sqrt64b+2
		sta	<sqrt64b+2

		ldy	<sqrt64a+2
		lda	[muladdr],y
		adc	#0
		sta	<sqrt64b+3

;mul mul16c high byte
		lda	<mul16c+1
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a

		clc
		adc	#muldatBank
		sta	<mulbank
		tam	#$02

		lda	<mul16c+1
		and	#$1F
		ora	#$40
		stz	<muladdr
		sta	<muladdr+1

		clc
		ldy	<sqrt64a
		lda	[muladdr],y
		adc	<sqrt64b+1
		sta	<sqrt64b+1

		ldy	<sqrt64a+1
		lda	[muladdr],y
		adc	<sqrt64b+2
		sta	<sqrt64b+2

		ldy	<sqrt64a+2
		lda	[muladdr],y
		adc	<sqrt64b+3
		sta	<sqrt64b+3

		lda	<mulbank
		clc
		adc	#8
		tam	#$02

		clc
		ldy	<sqrt64a
		lda	[muladdr],y
		adc	<sqrt64b+2
		sta	<sqrt64b+2

		ldy	<sqrt64a+1
		lda	[muladdr],y
		adc	<sqrt64b+3
		sta	<sqrt64b+3

		pla
		bpl	.jp01
;ans neg
		sec
		lda	<sqrt64b
		eor	#$FF
		adc	#0
		sta	<sqrt64b

		lda	<sqrt64b+1
		eor	#$FF
		adc	#0
		sta	<sqrt64b+1

		lda	<sqrt64b+2
		eor	#$FF
		adc	#0
		sta	<sqrt64b+2

		lda	<sqrt64b+3
		eor	#$FF
		adc	#0
		sta	<sqrt64b+3

.jp01:
		lda	<sqrt64b+2
		sta	<mul16a
		lda	<sqrt64b+3
		sta	<mul16a+1

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
		sbc	#SCREENZ
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

;centerY-Y0*128/Z0
;centerY-mul16a to vertex1Addr Y0
		ldy	#$02
		sec
		lda	<centerY
		sbc	<mul16a
		sta	[vertex1Addr],y
		iny
		lda	<centerY+1
		sbc	<mul16a+1
		sta	[vertex1Addr],y

;Z0>=128 flag set
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
calcEdge:
;calculation edge
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

		mov	<edgeSignX, #$FF

		bra	.edgeJump1

.edgeJump0:
		sta	<edgeSlopeX
		stz	<edgeSlopeX+1

		lda	#$01
		sta	<edgeSignX
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

;check edgeSignX
		bbs7	<edgeSignX, .edgeXLoop4Jump2

;edgeSignX plus
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

;edgeSignX minus
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
;;;;edgeSignX minus
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

;check edgeSignX
		bbs7	<edgeSignX, .edgeYLoop4Jump2

;edgeSignX plus
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
;edgeSignX minus
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
putHorizontalLine01Left:
;put left horizontal line
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
putHorizontalLine01Right:
;put right horizontal line
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
putHorizontalLine00:
;put left to right horizontal line
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
		st1	#$00
		st2	#$01

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
calcUnitVector:
;unitVectorX, unitVectorY, unitVectorZ
;sqrt64a+4 = unitVectorX * unitVectorX
		lda	unitVectorX
		sta	<mul16a
		sta	<mul16b

		lda	unitVectorX+1
		sta	<mul16a+1
		sta	<mul16b+1

		jsr	smul16

		movq	sqrt64a+4,<mul16c

;sqrt64a+4 += unitVectorY * unitVectorY
		lda	unitVectorY
		sta	<mul16a
		sta	<mul16b
		lda	unitVectorY+1
		sta	<mul16a+1
		sta	<mul16b+1

		jsr	smul16

		addq	sqrt64a+4,<mul16c

;sqrt64a+4 += unitVectorZ * unitVectorZ
		lda	unitVectorZ
		sta	<mul16a
		sta	<mul16b

		lda	unitVectorZ+1
		sta	<mul16a+1
		sta	<mul16b+1

		jsr	smul16

		addq	sqrt64a+4,<mul16c

;sqrt
		stzq	sqrt64a
		jsr	sqrt64

;unitVectorX / sqrt
		stzq	div64a
		lda	unitVectorX
		sta	div64a+4
		lda	unitVectorX+1
		sta	div64a+5
		bpl	.calcUnitJump0
		movw	div64a+6,#$FFFF
		bra	.calcUnitJump1
.calcUnitJump0:
		stzw	div64a+6

.calcUnitJump1:
		movq	<div16a,<sqrt64ans
		jsr	sdiv64
		movq	unitVectorX,<div16a

;unitVectorY / sqrt
		stzq	div64a
		lda	unitVectorY
		sta	div64a+4
		lda	unitVectorY+1
		sta	div64a+5
		bpl	.calcUnitJump2
		movw	div64a+6,#$FFFF
		bra	.calcUnitJump3
.calcUnitJump2:
		stzw	div64a+6

.calcUnitJump3:
		movq	<div16a,<sqrt64ans
		jsr	sdiv64
		movq	unitVectorY,<div16a

;unitVectorZ / sqrt
		stzq	div64a
		lda	unitVectorZ
		sta	div64a+4
		lda	unitVectorZ+1
		sta	div64a+5
		bpl	.calcUnitJump4
		movw	div64a+6,#$FFFF
		bra	.calcUnitJump5
.calcUnitJump4:
		stzw	div64a+6

.calcUnitJump5:
		movq	<div16a,<sqrt64ans
		jsr	sdiv64
		movq	unitVectorZ,<div16a

		rts


;----------------------------
atan:
;mul16a=x(-32768_32767), mul16b=y(-32768_32767)
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
;mul16a=x(0_65535), mul16b=y(0_65535)
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
		lda	atanDataLow,x
		sbc	<div16a
		lda	atanDataHigh,x
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
signExt:
;a(sign extension) = a
		bpl	.convPositive
		lda	#$FF
		bra	.convEnd
.convPositive:
		cla
.convEnd:
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
wireLineColorData0:
		.db	$00, $FF, $00, $FF


;----------------------------
wireLineColorData1:
		.db	$00, $00, $FF, $FF


;----------------------------
sinDataHigh:
;sin * 16384
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
;sin * 16384
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
;cos * 16384
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
;cos * 16384
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


;**********************************
		.bank	3
		INCBIN	"char.dat"		;    8K  3    $03
		INCBIN	"mul.dat"		;  128K  4~19 $04~$13
		INCBIN	"div.dat"		;   96K 20~31 $14~$1F
