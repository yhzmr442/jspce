charDataBank		.equ	3
mulDataBank		.equ	4
spxyDataBank		.equ	20
stage0DataBank		.equ	36

spWallDataBank		.equ	44
spShotDataBank		.equ	45
spEnemy0DataBank	.equ	46
sp32DataBank		.equ	47
spETCDataBank		.equ	48
spBoss0CenterDataBank	.equ	49
spBoss0SatelliteDataBank	.equ	50

stageDataMemoryBank	.equ	2
stageDataAddrHigh	.equ	stageDataMemoryBank*$20

spxyDataMemoryBank	.equ	3
spxyDataLeftAddrHigh	.equ	spxyDataMemoryBank*$20
spxyDataRightAddrHigh	.equ	spxyDataLeftAddrHigh+$02

spRMyshotSpNo		.equ	$02
spRMyshotSpPalette	.equ	$03
spREnemy0SpNo		.equ	$04
spREnemy0SpPalette0	.equ	$02
spREnemy0SpPalette1	.equ	$03

frameChrNo		.equ	$0102
frameChrRadarNo		.equ	$0103

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
SCREEN_CENTERX		.equ	80+16
SCREEN_CENTERY		.equ	160+32

SCREEN_LEFT		.equ	32-12-16
SCREEN_RIGHT		.equ	32+16*12-4
SCREEN_TOP		.equ	64-12+8
SCREEN_BOTTOM		.equ	240+64-12


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
;\1 = \1 AND \2
		lda	\1
		ora	\2
		sta	\1
		.endm


;----------------------------
oramw		.macro
;\1 = \1 AND \2
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


;----------------------------
aslw		.macro
;\1 << 1
		asl	\1
		rol	\1+1

		.endm


;----------------------------
aslq		.macro
;\1 << 1
		asl	\1
		rol	\1+1
		rol	\1+2
		rol	\1+3

		.endm


;----------------------------
lsrw		.macro
;\1 >> 1
		lsr	\1+1
		ror	\1

		.endm


;----------------------------
lsrq		.macro
;\1 >> 1
		lsr	\1+3
		ror	\1+2
		ror	\1+1
		ror	\1

		.endm


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
randomseed		.ds	2

;---------------------
vdp1Status		.ds	1
vdp2Status		.ds	1

;---------------------
puthexaddr		.ds	2
puthexdata		.ds	1

;---------------------
;---------------------
screenAngle		.ds	1
vsyncFlag		.ds	1

;---------------------
spDataAddr		.ds	2

spDataWorkX		.ds	2
spDataWorkY		.ds	2

spDataWorkBGX		.ds	2
spDataWorkBGY		.ds	2

bgCenterX		.ds	1
bgCenterY		.ds	1

bgDataAddr		.ds	2

;---------------------
rotationAngle		.ds	1
rotationX		.ds	2
rotationY		.ds	2
rotationAnsX		.ds	4
rotationAnsY		.ds	4

;---------------------
centerXPoint		.ds	2
centerX			.ds	2
centerYPoint		.ds	2
centerY			.ds	2
centerXYWorkPoint	.ds	2
centerXYWork		.ds	2
adjustCenterX		.ds	2
adjustCenterY		.ds	2
centerTileNo		.ds	1

;---------------------
checkHitXPoint		.ds	2
checkHitX		.ds	2
checkHitYPoint		.ds	2
checkHitY		.ds	2

;---------------------
getSpAngle		.ds	1
getSpNo			.ds	1
getSpPalette		.ds	1
spNoWork		.ds	2
spAttrWork		.ds	2

;---------------------
setEnemyAngle		.ds	1
setEnemyType		.ds	1
setEnemyTileNo		.ds	1
setEnemyLife		.ds	1
setEnemyXPoint		.ds	2
setEnemyX		.ds	2
setEnemyYPoint		.ds	2
setEnemyY		.ds	2

;---------------------
setEnemyShotAngle	.ds	1
setEnemyShotType	.ds	1
setEnemyShotXPoint	.ds	2
setEnemyShotX		.ds	2
setEnemyShotYPoint	.ds	2
setEnemyShotY		.ds	2
setEnemyShotTableAddr	.ds	2

;---------------------
checkHitObjX0		.ds	2
checkHitObjY0		.ds	2
checkHitObjX1		.ds	2
checkHitObjY1		.ds	2
checkHitObjWork		.ds	2

;---------------------
moveEnemyWork		.ds	1

;---------------------
myshipStatus		.ds	1
myshipCounter		.ds	1

;---------------------
reflectionBGX0		.ds	1
reflectionBGY0		.ds	1
reflectionBGX1		.ds	1
reflectionBGY1		.ds	1
reflectionCheckFlag	.ds	1

reflectionX0Point	.ds	2
reflectionX0		.ds	2
reflectionY0Point	.ds	2
reflectionY0		.ds	2

reflectionX1Point	.ds	2
reflectionX1		.ds	2
reflectionY1Point	.ds	2
reflectionY1		.ds	2

reflectionAngle		.ds	1
reflectionCount		.ds	1

;---------------------
VDC1WriteAddr
VDC1SatAddr
VDC1SpDmaAddr
VDC2WriteAddr
VDC2SatAddr
VDC2SpDmaAddr		.ds	2

VDC1SpriteY
VDC2SpriteY		.ds	2
VDC1SpriteX
VDC2SpriteX		.ds	2
VDC1SpriteNo
VDC2SpriteNo		.ds	2
VDC1SpriteAttr
VDC2SpriteAttr		.ds	2

VDC1SpriteCounter	.ds	1
VDC2SpriteCounter	.ds	1


;//////////////////////////////////
		.bss
;**********************************
		.org 	$2100
;**********************************
		.org 	$2200
;---------------------
frameAddrWork		.ds	2

;---------------------
			.rsset	$0
MYSHOT_ANGLE		.rs	1
MYSHOT_REFLECTION_COUNT	.rs	1
MYSHOT_XPOINT		.rs	2
MYSHOT_X		.rs	2
MYSHOT_YPOINT		.rs	2
MYSHOT_Y		.rs	2
MYSHOT_STRUCT_SIZE	.rs	0
MYSHOT_MAX		.equ	4
MYSHOT_TABLE_SIZE	.equ	MYSHOT_STRUCT_SIZE*MYSHOT_MAX
myshotTable		.ds	MYSHOT_TABLE_SIZE
MYSHOT_REFLECTION_INIT_COUNT	.equ	8

;---------------------
			.rsset	$0
ENEMY_ANGLE		.rs	1
ENEMY_TYPE		.rs	1
ENEMY_TILE_NO		.rs	1
ENEMY_LIFE		.rs	1
ENEMY_STATUS		.rs	1
ENEMY_COUNTER		.rs	1
ENEMY_XPOINT		.rs	2
ENEMY_X			.rs	2
ENEMY_YPOINT		.rs	2
ENEMY_Y			.rs	2
ENEMY_STRUCT_SIZE	.rs	0
ENEMY_MAX		.equ	16
ENEMY_TABEL_SIZE	.equ	ENEMY_STRUCT_SIZE*ENEMY_MAX
enemyTable		.ds	ENEMY_TABEL_SIZE


enemyAngleTable		.ds	32
enemyTypeTable		.ds	32
enemyTileNoTable	.ds	32
enemyLifeTable		.ds	32
enemyStatusTable	.ds	32
enemyCounterTable	.ds	32

enemyXPointLowTable	.ds	32
enemyXPointHighTable	.ds	32
enemyXLowTable		.ds	32
enemyXHighTable		.ds	32

enemyYPointLowTable	.ds	32
enemyYPointHighTable	.ds	32
enemyYLowTable		.ds	32
enemyYHighTable		.ds	32


;---------------------
			.rsset	$0
ENEMYSHOT_ANGLE		.rs	1
ENEMYSHOT_TYPE		.rs	1
ENEMYSHOT_XPOINT	.rs	2
ENEMYSHOT_X		.rs	2
ENEMYSHOT_YPOINT	.rs	2
ENEMYSHOT_Y		.rs	2
ENEMYSHOT_COUNTER	.rs	1
ENEMYSHOT_STRUCT_SIZE	.rs	0
ENEMYSHOT_MAX		.equ	16
ENEMYSHOT_TABLE_SIZE	.equ	ENEMYSHOT_STRUCT_SIZE*ENEMYSHOT_MAX
enemyshotTable		.ds	ENEMYSHOT_TABLE_SIZE

;---------------------
			.rsset	$0
STAGEENEMY_ANGLE	.rs	1
STAGEENEMY_TYPE		.rs	1
STAGEENEMY_LIFE		.rs	1
STAGEENEMY_TILE_NO	.rs	1
STAGEENEMY_X		.rs	2
STAGEENEMY_Y		.rs	2
STAGEENEMY_STRUCT_SIZE	.rs	0

;---------------------
			.rsset	$0
OBJ_TYPE		.rs	1
OBJ_X			.rs	2
OBJ_Y			.rs	2
OBJ_STRUCT_SIZE		.rs	0
OBJ_MAX			.equ	16
OBJ_TABEL_SIZE		.equ	OBJ_STRUCT_SIZE*OBJ_MAX
objTable		.ds	OBJ_TABEL_SIZE

;---------------------
spNo0No_0		.ds	2
spNo0Attr_0		.ds	2
spNo0No_32		.ds	2
spNo0Attr_32		.ds	2
spNo0No_64		.ds	2
spNo0Attr_64		.ds	2
spNo0No_96		.ds	2
spNo0Attr_96		.ds	2

spNo1No_0		.ds	2
spNo1Attr_0		.ds	2
spNo1No_32		.ds	2
spNo1Attr_32		.ds	2
spNo1No_64		.ds	2
spNo1Attr_64		.ds	2
spNo1No_96		.ds	2
spNo1Attr_96		.ds	2

;---------------------
tiafunc			.ds	1
tiasrc			.ds	2
tiadst			.ds	2
tialen			.ds	2
tiarts			.ds	1

;---------------------
tiifunc			.ds	1
tiisrc			.ds	2
tiidst			.ds	2
tiilen			.ds	2
tiirts			.ds	1


;//////////////////////////////////
		.code
;**********************************
		.bank	0
		.org	$E000
;----------------------------
sdiv32:
;div16a div16b = div16d:div16c / div16a
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
		cla
		sbc	<div16c
		sta	<div16c

		cla
		sbc	<div16c+1
		sta	<div16c+1

		cla
		sbc	<div16d
		sta	<div16d

		cla
		sbc	<div16d+1
		sta	<div16d+1

.sdiv32jp00:
;a sign
		bbr7	<div16a+1, .sdiv32jp01

;a neg
		sec
		cla
		sbc	<div16a
		sta	<div16a

		cla
		sbc	<div16a+1
		sta	<div16a+1

.sdiv32jp01:
		jsr	udiv32

;anser sign
		pla
		bpl	.sdiv32jp02

;anser neg
		sec
		cla
		sbc	<div16a
		sta	<div16a

		cla
		sbc	<div16a+1
		sta	<div16a+1

.sdiv32jp02:
;remainder sign
		pla
		bpl	.sdiv32jp03

;remainder neg
		sec
		cla
		sbc	<div16b
		sta	<div16b

		cla
		sbc	<div16b+1
		sta	<div16b+1

.sdiv32jp03:
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
sqrt64:
;sqrt64ans = sqrt(sqrt64a)
;push x
		phx

		bbr7	<sqrt64a+7, .sqrtjump3

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
;div16b:div16a div16d:div16c = div64a / div16b:div16a
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
		cla
		sbc	<div64a
		sta	<div64a

		cla
		sbc	<div64a+1
		sta	<div64a+1

		cla
		sbc	<div64a+2
		sta	<div64a+2

		cla
		sbc	<div64a+3
		sta	<div64a+3

		cla
		sbc	<div64a+4
		sta	<div64a+4

		cla
		sbc	<div64a+5
		sta	<div64a+5

		cla
		sbc	<div64a+6
		sta	<div64a+6

		cla
		sbc	<div64a+7
		sta	<div64a+7

.sdiv64jp00:
;b:a sign
		bbr7	<div16b+1, .sdiv64jp01

;b:a neg
		sec
		cla
		sbc	<div16a
		sta	<div16a

		cla
		sbc	<div16a+1
		sta	<div16a+1

		cla
		sbc	<div16b
		sta	<div16b

		cla
		sbc	<div16b+1
		sta	<div16b+1

.sdiv64jp01:
		jsr	udiv64

;anser sign
		pla
		bpl	.sdiv64jp02

;anser neg
		sec
		cla
		sbc	<div16a
		sta	<div16a

		cla
		sbc	<div16a+1
		sta	<div16a+1

		cla
		sbc	<div16b
		sta	<div16b

		cla
		sbc	<div16b+1
		sta	<div16b+1

.sdiv64jp02:
;remainder sign
		pla
		bpl	.sdiv64jp03

;remainder neg
		sec
		cla
		sbc	<div16c
		sta	<div16c

		cla
		sbc	<div16c+1
		sta	<div16c+1

		cla
		sbc	<div16d
		sta	<div16d

		cla
		sbc	<div16d+1
		sta	<div16d+1

.sdiv64jp03:
		rts


;----------------------------
udiv64:
;div16b:div16a div16d:div16c = div64a / div16b:div16a
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

		stz	<muladdr

		ldy	<mul16b
		lda	umul16Bank, y

		sta	<mulbank
		tam	#$02

		lda	umul16Address, y
		sta	<muladdr+1

		ldy	<mul16a
		lda	[muladdr], y
		sta	<mul16c

		ldy	<mul16a+1
		lda	[muladdr], y
		sta	<mul16c+1

		clc
		lda	<mulbank
		adc	#8		;carry clear
		tam	#$02

		ldy	<mul16a
		lda	[muladdr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[muladdr], y
		adc	#0		;carry clear
		sta	<mul16d


		ldy	<mul16b+1
		lda	umul16Bank, y

		sta	<mulbank
		tam	#$02

		lda	umul16Address, y
		sta	<muladdr+1

		ldy	<mul16a
		lda	[muladdr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[muladdr], y
		adc	<mul16d
		sta	<mul16d

		cla
		adc	#0		;carry clear
		sta	<mul16d+1

		lda	<mulbank
		adc	#8		;carry clear
		tam	#$02

		ldy	<mul16a
		lda	[muladdr], y
		adc	<mul16d
		sta	<mul16d

		ldy	<mul16a+1
		lda	[muladdr], y
		adc	<mul16d+1
		sta	<mul16d+1

;pull y
		ply
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
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

		cla
		sbc	<mul16b
		sta	<mul16b

		cla
		sbc	<mul16b+1
		sta	<mul16b+1

.smul32jp00:
;d sign
		bbr7	<mul16d+1, .smul32jp01

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

.smul32jp01:
		jsr	umul32

;anser sign
		pla
		bpl	.smul32jp02

;anser neg
		sec
		cla
		sbc	<mul16a
		sta	<mul16a

		cla
		sbc	<mul16a+1
		sta	<mul16a+1

		cla
		sbc	<mul16b
		sta	<mul16b

		cla
		sbc	<mul16b+1
		sta	<mul16b+1

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
signExt:
;a(sign extension) = a
		ora	#$00
		bpl	.convPositive
		lda	#$FF
		bra	.convEnd
.convPositive:
		cla
.convEnd:
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

;Clear RAM
		lda	#$F9
		tam	#$02

		lda	#$FA
		tam	#$03

		lda	#$FB
		tam	#$04

		stz	$2000
		tii	$2000, $2001, 32767

;set main bank
		lda	#$01
		tam	#$06

;jump main
		jmp	main


;----------------------------
_irq1:
;IRQ1 interrupt process
;ACK interrupt
		jsr	mainIrqProc

		rti


;----------------------------
_irq2:
_timer:
_nmi:
;IRQ2 TIMER NMI interrupt process
		rti


;----------------------------
umul16Bank
		.db	$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank,\
			$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank,\
			$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank,\
			$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank,\
			$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank,\
			$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank,\
			$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank,\
			$00+mulDataBank, $00+mulDataBank, $00+mulDataBank, $00+mulDataBank

		.db	$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank,\
			$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank,\
			$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank,\
			$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank,\
			$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank,\
			$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank,\
			$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank,\
			$01+mulDataBank, $01+mulDataBank, $01+mulDataBank, $01+mulDataBank

		.db	$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank,\
			$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank,\
			$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank,\
			$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank,\
			$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank,\
			$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank,\
			$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank,\
			$02+mulDataBank, $02+mulDataBank, $02+mulDataBank, $02+mulDataBank

		.db	$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank,\
			$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank,\
			$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank,\
			$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank,\
			$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank,\
			$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank,\
			$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank,\
			$03+mulDataBank, $03+mulDataBank, $03+mulDataBank, $03+mulDataBank

		.db	$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank,\
			$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank,\
			$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank,\
			$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank,\
			$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank,\
			$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank,\
			$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank,\
			$04+mulDataBank, $04+mulDataBank, $04+mulDataBank, $04+mulDataBank

		.db	$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank,\
			$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank,\
			$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank,\
			$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank,\
			$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank,\
			$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank,\
			$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank,\
			$05+mulDataBank, $05+mulDataBank, $05+mulDataBank, $05+mulDataBank

		.db	$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank,\
			$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank,\
			$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank,\
			$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank,\
			$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank,\
			$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank,\
			$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank,\
			$06+mulDataBank, $06+mulDataBank, $06+mulDataBank, $06+mulDataBank

		.db	$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank,\
			$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank,\
			$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank,\
			$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank,\
			$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank,\
			$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank,\
			$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank,\
			$07+mulDataBank, $07+mulDataBank, $07+mulDataBank, $07+mulDataBank


;----------------------------
umul16Address
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


;**********************************
		.bank	1
		.org	$C000

;----------------------------
main:

;set func bank
		lda	#$02
		tam	#$05

		jsr	initializeVdp

;++++++++++++++++++++++++++++
;set tiafunc tiifunc
		lda	#$E3;		tia
		sta	tiafunc

		lda	#$73;		tii
		sta	tiifunc

		lda	#$60;		rts
		sta	tiarts
		sta	tiirts

;set character
		lda	#charDataBank
		tam	#$02

;vram address $1000
		stz	VPC_6	;select VDC#1

		mov	VDC1_0,	#$00
		mov	VDC1_2,	#$00
		mov	VDC1_3,	#$10

		mov	VDC1_0,	#$02
		tia	$4000, VDC1_2, $1000


		mov	VDC2_0,	#$00
		mov	VDC2_2,	#$00
		mov	VDC2_3,	#$10

		mov	VDC2_0,	#$02
		tia	$4000, VDC2_2, $1000

;set sprite character
;left ETC
		lda	#spETCDataBank
		tam	#$02

		mov	VDC1_0, #$00
		movw	VDC1_2, #$0500

		mov	VDC1_0, #$02

		tia	$4000, VDC1_2, 512*3

		mov	VDC1_0, #$00
		movw	VDC1_2, #$1800

		mov	VDC1_0, #$02

		tia	$5000, VDC1_2, 4096

;right ETC
		mov	VDC2_0, #$00
		movw	VDC2_2, #$0500

		mov	VDC2_0, #$02

		tia	$4000, VDC2_2, 512*3

		mov	VDC2_0, #$00
		movw	VDC2_2, #$1800

		mov	VDC2_0, #$02

		tia	$5000, VDC2_2, 4096

;left No0
		lda	#spWallDataBank
		tam	#$02

		mov	VDC1_0, #$00
		movw	VDC1_2, #$2000

		mov	VDC1_0, #$02

		tia	$4000, VDC1_2, 8192

;right No0
		mov	VDC2_0, #$00
		movw	VDC2_2, #$2000

		mov	VDC2_0, #$02

		tia	$4000, VDC2_2, 8192

;left No2
		lda	#spShotDataBank
		tam	#$02

		tia	$4000, VDC1_2, 8192

;right No2
		tia	$4000, VDC2_2, 8192

;right No4
		lda	#spEnemy0DataBank
		tam	#$02

		tia	$4000, VDC2_2, 8192

;right No8
		lda	#spBoss0CenterDataBank
		tam	#$02

		mov	VDC2_0, #$00
		movw	VDC2_2, #$6000

		mov	VDC2_0, #$02

		tia	$4000, VDC2_2, 8192

;right No10
		lda	#spBoss0SatelliteDataBank
		tam	#$02

		mov	VDC2_0, #$00
		movw	VDC2_2, #$7000

		mov	VDC2_0, #$02

		tia	$4000, VDC2_2, 8192

;left angle 32
		lda	#sp32DataBank
		tam	#$02

		mov	VDC1_0, #$00
		movw	VDC1_2, #$0800

		mov	VDC1_0, #$02

		tia	$4000, VDC1_2, 4096

;right angle 32
		mov	VDC2_0, #$00
		movw	VDC2_2, #$0800

		mov	VDC2_0, #$02

		tia	$5000, VDC2_2, 4096


;++++++++++++++
;frame
;-----
		movw	frameAddrWork, #$0018
		ldy	#30

.frameLoopR0:
		mov	VDC1_0, #$00
		movw	VDC1_2, frameAddrWork

		mov	VDC1_0, #$02
		ldx	#8
.frameLoopR1:
		movw	VDC1_2, #frameChrNo
		dex
		bne	.frameLoopR1

		addw	frameAddrWork, #$0020
		dey
		bne	.frameLoopR0

;-----
		movw	frameAddrWork, #$0000
		ldy	#3

.frameLoopU0:
		mov	VDC1_0, #$00
		movw	VDC1_2, frameAddrWork

		mov	VDC1_0, #$02
		ldx	#32
.frameLoopU1:
		movw	VDC1_2, #frameChrNo
		dex
		bne	.frameLoopU1

		addw	frameAddrWork, #$0020
		dey
		bne	.frameLoopU0

;-----
		movw	frameAddrWork, #$03A0
		ldy	#1

.frameLoopD0:
		mov	VDC1_0, #$00
		movw	VDC1_2, frameAddrWork

		mov	VDC1_0, #$02
		ldx	#32
.frameLoopD1:
		movw	VDC1_2, #frameChrNo
		dex
		bne	.frameLoopD1

		addw	frameAddrWork, #$0020
		dey
		bne	.frameLoopD0

;-----
		movw	frameAddrWork, #$0180+$0018
		ldy	#8

.radarLoop0:
		mov	VDC1_0, #$00
		movw	VDC1_2, frameAddrWork

		mov	VDC1_0, #$02
		ldx	#8
.radarLoop1:
		movw	VDC1_2, #frameChrRadarNo
		dex
		bne	.radarLoop1

		addw	frameAddrWork, #$0020
		dey
		bne	.radarLoop0

;initialize
.initialize:
		stz	<myshipStatus

		movq	<centerXPoint, #$0040, #$0000
		movq	<centerYPoint, #$01E0, #$0000

		stzw	<centerXYWorkPoint
		stzw	<centerXYWork

		stz	<screenAngle

		stzw	<spDataWorkX
		stzw	<spDataWorkY

		stzw	<spDataWorkBGX
		stzw	<spDataWorkBGY

		stz	<bgCenterX
		stz	<bgCenterY

		jsr	initMyshot

		jsr	initEnemy

		jsr	initEnemyshot

		jsr	initObj

		mov	objTable+OBJ_TYPE, #$00
		movw	objTable+OBJ_X, #$0040
		movw	objTable+OBJ_Y, #$0040

		mov	objTable+OBJ_STRUCT_SIZE+OBJ_TYPE, #$00
		movw	objTable+OBJ_STRUCT_SIZE+OBJ_X, #$0180
		movw	objTable+OBJ_STRUCT_SIZE+OBJ_Y, #$0070

		clx
.setEnemyDataLoop:
		lda	stage0EnemyData+STAGEENEMY_ANGLE, x
		cmp	#$FF
		beq	.setEnemyDataLoopEnd

		sta	<setEnemyAngle

		lda	stage0EnemyData+STAGEENEMY_TYPE, x
		sta	<setEnemyType

		lda	stage0EnemyData+STAGEENEMY_TILE_NO, x
		sta	<setEnemyTileNo

		lda	stage0EnemyData+STAGEENEMY_LIFE, x
		sta	<setEnemyLife

		movw	<setEnemyXPoint, #$0000

		lda	stage0EnemyData+STAGEENEMY_X, x
		sta	<setEnemyX

		lda	stage0EnemyData+STAGEENEMY_X+1, x
		sta	<setEnemyX+1

		movw	<setEnemyYPoint, #$0000

		lda	stage0EnemyData+STAGEENEMY_Y, x
		sta	<setEnemyY

		lda	stage0EnemyData+STAGEENEMY_Y+1, x
		sta	<setEnemyY+1

		jsr	setEnemy

		clc
		txa
		adc	#STAGEENEMY_STRUCT_SIZE
		tax

		bra	.setEnemyDataLoop

.setEnemyDataLoopEnd:
		jsr	showScreen

		rmb7	<vsyncFlag

;enable irq
		cli

;++++++++++++++++++++++++++++
.mainLoop:
;wait vsync
		bbs7	<vsyncFlag, .mainLoop

		bbr7	<myshipStatus, .checkPadA

		lda	<myshipCounter
		cmp	#$C0
		jeq	.initialize
		jmp	.checkPadBEnd

;check pad
.checkPadA:
		bbr0	<padnow, .checkPadLeft

		lda	<padnow
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		tax
		lda	padAngleData, x
		bra	.checkPadJump

.checkPadLeft:
		bbr7	<padnow, .checkPadRight
		lda	<screenAngle
		inc	a
		and 	#$7F
		sta	<screenAngle
		bra	.checkPadUp

.checkPadRight:
		bbr5	<padnow, .checkPadUp
		lda	<screenAngle
		dec	a
		and 	#$7F
		sta	<screenAngle

.checkPadUp:
		lda	#$80
		bbr4	<padnow, .checkPadDown
		lda	#$00
		bra	.checkPadJump

.checkPadDown:
		bbr6	<padnow, .checkPadJump
		lda	#$40

.checkPadJump:

;move and check hit
		ora	#$00
		jmi	.checkPadEnd
		add	<screenAngle
		and 	#$7F
		asl	a
		tax

		stz	<centerXYWorkPoint
		lda	sinDataLow, x
		sta	<centerXYWorkPoint+1
		lda	sinDataHigh, x
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		movq	<checkHitXPoint, <centerXPoint

		subq	<checkHitXPoint, <centerXYWorkPoint
		subq	<checkHitXPoint, <centerXYWorkPoint
		andm	<checkHitX+1, #$0F

		stz	<centerXYWorkPoint
		lda	cosDataLow, x
		sta	<centerXYWorkPoint+1
		lda	cosDataHigh, x
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		movq	<checkHitYPoint, <centerYPoint

		subq	<checkHitYPoint, <centerXYWorkPoint
		subq	<checkHitYPoint, <centerXYWorkPoint
		andm	<checkHitY+1, #$0F

;++++++++
		clx
.enemyHitLoop:
		lda	enemyAngleTable, x
		bmi	.enemyHitJump

		lda	enemyTileNoTable, x
		cmp	<centerTileNo
		jne	.enemyHitJump

		movw	<checkHitObjX0, <checkHitX
		movw	<checkHitObjY0, <checkHitY

		lda	enemyXLowTable, x
		sta	<checkHitObjX1
		lda	enemyXHighTable, x
		sta	<checkHitObjX1+1

		lda	enemyYLowTable, x
		sta	<checkHitObjY1
		lda	enemyYHighTable, x
		sta	<checkHitObjY1+1

		jsr	checkHitObj16
		bcs	.checkHitJump01

.enemyHitJump:
		inx
		cpx	#32
		bne	.enemyHitLoop

;++++++++
;check move x y
		jsr	checkHit
		bcc	.checkHitJump00

;check move x
		movq	<centerXYWorkPoint, <checkHitXPoint
		movq	<checkHitXPoint, <centerXPoint
		jsr	checkHit
		bcc	.checkHitJump00

;check move y
		movq	<checkHitXPoint, <centerXYWorkPoint
		movq	<checkHitYPoint, <centerYPoint
		jsr	checkHit
		bcs	.checkHitJump01

.checkHitJump00:
		movq	<centerXPoint, <checkHitXPoint
		movq	<centerYPoint, <checkHitYPoint

.checkHitJump01:
.checkPadEnd:

.checkPadB:
		bbr1	<padnow, .checkPadBEnd
		jsr	setMyshot

.checkPadBEnd:


;++++++++
;get tile no
		movw	<spDataWorkBGX, <centerX
		movw	<spDataWorkBGY, <centerY
		jsr	getStageData2
		sta	<centerTileNo


;++++++++
;move myshot
		jsr	moveMyshot

;++++++++
;move enemy
		jsr	moveEnemy

;++++++++
;move enemyshot
		jsr	moveEnemyshot

;++++++++
;hit check myshot enemy
		jsr	checkMyshotEnemy

;++++++++
;hit check enemyshot
		jsr	checkEnemyshot

;++++++++
;set adjust center
		lda	<screenAngle
		asl	a
		sta	<rotationAngle

		stz	<rotationX
		lda	<centerX
		and	#$0F
		sta	<rotationX+1

		mov	<bgCenterX, <centerX
		lda	<centerX+1
		lsr	a
		ror	<bgCenterX
		lsr	a
		ror	<bgCenterX
		lsr	a
		ror	<bgCenterX
		lsr	a
		ror	<bgCenterX

		stz	<rotationY
		lda	<centerY
		and	#$0F
		sta	<rotationY+1

		mov	<bgCenterY, <centerY
		lda	<centerY+1
		lsr	a
		ror	<bgCenterY
		lsr	a
		ror	<bgCenterY
		lsr	a
		ror	<bgCenterY
		lsr	a
		ror	<bgCenterY

		jsr	rotationProc

		addw	<adjustCenterX, <rotationAnsX+2, #SCREEN_CENTERX-128+32+16
		subw	<adjustCenterY, <rotationAnsY+2, #64-16

;++++++++
;Left
;set sprite attribute VRAM address
		movw	<VDC1SatAddr, #$0400
		jsr	clearVDC1Sat

;++++++++
;set radar sprite
		jsr	setRadarSp

;++++++++
;set enemyshot sprite
		jsr	setEnemyshotSp

;++++++++
;spData set bank
		lda	<screenAngle
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#spxyDataBank
		tam	#spxyDataMemoryBank

		lda	<screenAngle
		and	#$07
		asl	a
		asl	a
		clc
		adc	#spxyDataLeftAddrHigh
		stz	<spDataAddr
		sta	<spDataAddr+1

;++++++++
;get sp no attr
;angle 0
		mov	<getSpAngle, <screenAngle

		mov	<getSpNo, #$00
		jsr	getSpNoAttr
		movw	spNo0No_0, <spNoWork
		movw	spNo0Attr_0, <spAttrWork

		mov	<getSpNo, #$01
		jsr	getSpNoAttr
		movw	spNo1No_0, <spNoWork
		movw	spNo1Attr_0, <spAttrWork

;angle 32
		add	<getSpAngle, <screenAngle, #32

		mov	<getSpNo, #$00
		jsr	getSpNoAttr
		movw	spNo0No_32, <spNoWork
		movw	spNo0Attr_32, <spAttrWork

		mov	<getSpNo, #$01
		jsr	getSpNoAttr
		movw	spNo1No_32, <spNoWork
		movw	spNo1Attr_32, <spAttrWork

;angle 64
		add	<getSpAngle, <screenAngle, #64

		mov	<getSpNo, #$00
		jsr	getSpNoAttr
		movw	spNo0No_64, <spNoWork
		movw	spNo0Attr_64, <spAttrWork

		mov	<getSpNo, #$01
		jsr	getSpNoAttr
		movw	spNo1No_64, <spNoWork
		movw	spNo1Attr_64, <spAttrWork

;angle 96
		add	<getSpAngle, <screenAngle, #96

		mov	<getSpNo, #$00
		jsr	getSpNoAttr
		movw	spNo0No_96, <spNoWork
		movw	spNo0Attr_96, <spAttrWork

		mov	<getSpNo, #$01
		jsr	getSpNoAttr
		movw	spNo1No_96, <spNoWork
		movw	spNo1Attr_96, <spAttrWork

;++++++++
;clear spData index
		cly

;left wall
		bra	.spLDataLoop

.spLDataJpINY2:
		iny
.spLDataJpINY1:
		iny
		bne	.L_addrNoCarry1
		inc	<spDataAddr+1
.L_addrNoCarry1:

.spLDataLoop:
;set sprite position data
		lda	[spDataAddr], y
		cmp	#$80
		jeq	.spLDataLoopEnd

		add	<bgCenterX
		sta	<bgDataAddr
		iny

		lda	[spDataAddr], y
		add	<bgCenterY
		tax
		iny

;get stage data
		lda	stageDataBankData, x
		tam	#stageDataMemoryBank

		lda	stageDataAddrHighData, x
		sta	<bgDataAddr+1

		lda	[bgDataAddr]
		bmi	.spLDataJpINY2
		tax

;calculation  sprite position
		sec
		lda	[spDataAddr], y
		sbc	<adjustCenterX
		sta	<VDC1SpriteX
		cla
		sbc	<adjustCenterX+1
		sta	<VDC1SpriteX+1
		iny

		cmpw	VDC1SpriteX, #SCREEN_LEFT
		bmi	.spLDataJpINY1

		sec
		lda	[spDataAddr], y
		sbc	<adjustCenterY
		sta	<VDC1SpriteY
		cla
		sbc	<adjustCenterY+1
		sta	<VDC1SpriteY+1

		cmpw	VDC1SpriteY, #SCREEN_TOP
		bmi	.spLDataJpINY1

		cmpw	VDC1SpriteY, #SCREEN_BOTTOM
		bpl	.spLDataJpINY1

		iny
		bne	.L_addrNoCarry0
		inc	<spDataAddr+1
.L_addrNoCarry0:

;set left wall sprite
		sei

		movw	VDC1_2, <VDC1SpriteY
		movw	VDC1_2, <VDC1SpriteX

		lda	spNo0No_0, x
		sta	VDC1_2
		lda	spNo0No_0+1, x
		sta	VDC1_2+1

		lda	spNo0No_0+2, x
		sta	VDC1_2
		lda	spNo0No_0+3, x
		sta	VDC1_2+1

		cli

;check VDC1 sprite counter
		lda	<VDC1SpriteCounter
		inc	a
		sta	<VDC1SpriteCounter
		cmp	#$64
		jcc	.spLDataLoop

.spLDataLoopEnd:

;++++++++
;Right
;set sprite attribute VRAM address
		movw	<VDC2SatAddr, #$0400
		jsr	clearVDC2Sat

;++++++++
;set myship sprite
		bbs7	<myshipStatus, .setmyshipSp

		movw	<VDC2SpriteY, #SCREEN_CENTERY+64-8
		movw	<VDC2SpriteX, #SCREEN_CENTERX+32-8

		movw	<VDC2SpriteNo, #$00C0
		movw	<VDC2SpriteAttr, #$0002
		bra	.setmyshipSpEnd

.setmyshipSp:
		movw	<VDC2SpriteY, #SCREEN_CENTERY+64-16
		movw	<VDC2SpriteX, #SCREEN_CENTERX+32-16
		lda	<myshipCounter
		and	#$C0
		lsr	a
		lsr	a
		lsr	a
		add	#$28
		sta	<VDC2SpriteNo
		stz	<VDC2SpriteNo+1
		movw	<VDC2SpriteAttr, #$1182

		inc	<myshipCounter

.setmyshipSpEnd:
		jsr	setVDC2Sp

;++++++++
;set myshot sprite
		jsr	setMyshotSp

;++++++++
;set enemy sprite
		jsr	setEnemySp

;++++++++
;set blast sprite
		jsr	setBlastSp

;++++++++
;set obj sprite
		jsr	setObjSp

;spData set bank
		lda	<screenAngle
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#spxyDataBank
		tam	#spxyDataMemoryBank

		lda	<screenAngle
		and	#$07
		asl	a
		asl	a
		clc
		adc	#spxyDataRightAddrHigh
		stz	<spDataAddr
		sta	<spDataAddr+1

;clear spData index
		cly

;right wall
		bra	.spRDataLoop

.spRDataJpINY2:
		iny
.spRDataJpINY1:
		iny
		bne	.R_addrNoCarry1
		inc	<spDataAddr+1
.R_addrNoCarry1:

.spRDataLoop:
;set sprite position data
		lda	[spDataAddr], y
		cmp	#$80
		jeq	.spRDataLoopEnd

		add	<bgCenterX
		sta	<bgDataAddr
		iny

		lda	[spDataAddr], y
		add	<bgCenterY
		tax
		iny

;get stage data
		lda	stageDataBankData, x
		tam	#stageDataMemoryBank

		lda	stageDataAddrHighData, x
		sta	<bgDataAddr+1

		lda	[bgDataAddr]
		bmi	.spRDataJpINY2
		tax

;calculation  sprite position
		sec
		lda	[spDataAddr], y
		sbc	<adjustCenterX
		sta	<VDC2SpriteX
		cla
		sbc	<adjustCenterX+1
		sta	<VDC2SpriteX+1
		iny

		cmpw	VDC2SpriteX, #SCREEN_RIGHT
		bpl	.spRDataJpINY1

		sec
		lda	[spDataAddr], y
		sbc	<adjustCenterY
		sta	<VDC2SpriteY
		cla
		sbc	<adjustCenterY+1
		sta	<VDC2SpriteY+1

		cmpw	VDC2SpriteY, #SCREEN_TOP
		bmi	.spRDataJpINY1

		cmpw	VDC2SpriteY, #SCREEN_BOTTOM
		bpl	.spRDataJpINY1

		iny
		bne	.R_addrNoCarry0
		inc	<spDataAddr+1
.R_addrNoCarry0:

;set right wall sprite
		sei

		movw	VDC2_2, <VDC2SpriteY
		movw	VDC2_2, <VDC2SpriteX

		lda	spNo0No_0, x
		sta	VDC2_2
		lda	spNo0No_0+1, x
		sta	VDC2_2+1

		lda	spNo0No_0+2, x
		ora	#$80
		sta	VDC2_2
		lda	spNo0No_0+3, x
		sta	VDC2_2+1

		cli

;check VDC2 sprite counter
		lda	<VDC2SpriteCounter
		inc	a
		sta	<VDC2SpriteCounter
		cmp	#$64
		jcc	.spRDataLoop

.spRDataLoopEnd:

;++++++++++++++++++++++++++++
;SATB DMA set
		movw	<VDC1SpDmaAddr, #$0400
		jsr	setVDC1SpDma

		movw	<VDC2SpDmaAddr, #$0400
		jsr	setVDC2SpDma

;++++++++++++++++++++++++++++
;put datas
		lda	<screenAngle
		ldx	#$18
		ldy	#$02
		jsr	putHex

		lda	<centerTileNo
		ldx	#$1A
		ldy	#$02
		jsr	putHex

		lda	<VDC1SpriteCounter
		ldx	#$18
		ldy	#$03
		jsr	putHex

		lda	<VDC2SpriteCounter
		ldx	#$1A
		ldy	#$03
		jsr	putHex

;++++++++++++++++++++++++++++
;set vsync flag
		smb7	<vsyncFlag

		jmp	.mainLoop


;----------------------------
mainIrqProc:
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
;VDC#1 section
		mov	VDC1_0, #$07		;scroll x
		movw	VDC1_2, #$0000

		mov	VDC1_0, #$08		;scroll y
		movw	VDC1_2, #$0000

;clear SATB
		mov	VDC1_0, #$00		;set SATB addr
		movw	VDC1_2, #$0400

		mov	VDC1_0, #$02		;VRAM clear
		movw	VDC1_2, #$0000

		mov	VDC1_0, #$10		;set DMA src
		movw	VDC1_2, #$0400

		mov	VDC1_0, #$11		;set DMA dist
		movw	VDC1_2, #$0401

		mov	VDC1_0, #$12		;set DMA count 255WORD
		movw	VDC1_2, #$00FF

;VDC#2 section
		mov	VDC2_0, #$07		;scroll x
		movw	VDC2_2, #$0000

		mov	VDC2_0, #$08		;scroll y
		movw	VDC2_2, #$0000

;clear SATB
		mov	VDC2_0, #$00		;set SATB addr
		movw	VDC2_2, #$0400

		mov	VDC2_0, #$02		;VRAM clear
		movw	VDC2_2, #$0000

		mov	VDC2_0, #$10		;set DMA src
		movw	VDC2_2, #$0400

		mov	VDC2_0, #$11		;set DMA dist
		movw	VDC2_2, #$0401

		mov	VDC2_0, #$12		;set DMA count 255WORD
		movw	VDC2_2, #$00FF

		rmb7	<vsyncFlag
.vsyncProcEnd:

		jsr	getPadData

		ply
		plx
		pla

		rts


;----------------------------
setRadarSp:
;
;set center
		movw	<VDC1SpriteY, #96+32+64
		movw	<VDC1SpriteX, #192+32+32

		;;;movw	<VDC1SpriteNo, #$007A
		movw	<VDC1SpriteNo, #$00CA
		movw	<VDC1SpriteAttr, #$0083
		jsr	setVDC1Sp

;++++++++
		clx
.radarEnemyLoop:
		lda	enemyAngleTable, x
		jmi	.enemyNext

		lda	<screenAngle
		asl	a
		sta	<rotationAngle

		lda	enemyXLowTable, x
		sta	<rotationX
		lda	enemyXHighTable, x
		sta	<rotationX+1

		lda	enemyYLowTable, x
		sta	<rotationY
		lda	enemyYHighTable, x
		sta	<rotationY+1

		subw	<rotationX, <centerX
		subw	<rotationY, <centerY

		cmpw	<rotationX, #$FD2C
		jmi	.enemyNext

		cmpw	<rotationX, #$02D4
		jpl	.enemyNext

		cmpw	<rotationY, #$FD2C
		jmi	.enemyNext

		cmpw	<rotationY, #$02D4
		jpl	.enemyNext

		jsr	rotationProc

		mov	<VDC1SpriteX, <rotationAnsX+1
		lda	<rotationAnsX+2
		lsr	a
		ror	<VDC1SpriteX
		lsr	a
		ror	<VDC1SpriteX
		lsr	a
		ror	<VDC1SpriteX
		lsr	a
		ror	<VDC1SpriteX
		sta	<VDC1SpriteX+1

		addw	<VDC1SpriteX, #192+32+32
		andmw	<VDC1SpriteX, #$03FF

		cmpw	<VDC1SpriteX, #192+32
		bmi	.enemyNext

		cmpw	<VDC1SpriteX, #256+32
		bpl	.enemyNext

;--------
		mov	<VDC1SpriteY, <rotationAnsY+1
		lda	<rotationAnsY+2
		lsr	a
		ror	<VDC1SpriteY
		lsr	a
		ror	<VDC1SpriteY
		lsr	a
		ror	<VDC1SpriteY
		lsr	a
		ror	<VDC1SpriteY
		sta	<VDC1SpriteY+1

		addw	<VDC1SpriteY, #96+32+64
		andmw	<VDC1SpriteY, #$03FF

		cmpw	<VDC1SpriteY, #96+64
		bmi	.enemyNext

		cmpw	<VDC1SpriteY, #96+64+64
		bpl	.enemyNext

		movw	<VDC1SpriteNo, #$00C8
		movw	<VDC1SpriteAttr, #$0083
		jsr	setVDC1Sp

.enemyNext:
		inx
		cpx	#32
		jne	.radarEnemyLoop

		rts


;----------------------------
checkEnemyshot:
;
		bbs7	<myshipStatus, .enemyshotEnd

		movw	<checkHitObjX0, <centerX
		subw	<checkHitObjX0, #$0008

		movw	<checkHitObjY0, <centerY
		subw	<checkHitObjY0, #$0008

		clx
		ldy	#ENEMYSHOT_MAX

.enemyshotLoop:
		lda	enemyshotTable+ENEMYSHOT_ANGLE, x
		cmp	#$80
		beq	.nextEnemyshot

		lda	enemyshotTable+ENEMYSHOT_X, x
		sta	<checkHitObjX1
		lda	enemyshotTable+ENEMYSHOT_X+1, x
		sta	<checkHitObjX1+1

		lda	enemyshotTable+ENEMYSHOT_Y, x
		sta	<checkHitObjY1
		lda	enemyshotTable+ENEMYSHOT_Y+1, x
		sta	<checkHitObjY1+1

		jsr	checkHitObj16_3
		bcc	.nextEnemyshot

		lda	#$80
		sta	enemyshotTable+ENEMYSHOT_ANGLE, x

		mov	<myshipStatus, #$80
		stz	<myshipCounter

		bra	.enemyshotEnd

.nextEnemyshot:
		txa
		add	#ENEMYSHOT_STRUCT_SIZE
		tax
		dey
		bne	.enemyshotLoop
.enemyshotEnd:
		rts


;----------------------------
checkMyshotEnemy:
;
		cly
.loopInitEnemy:
		lda	enemyAngleTable, y
		bmi	.loopNextInitEnemy

		lda	enemyStatusTable, y
		and	#$7F
		sta	enemyStatusTable, y

.loopNextInitEnemy:
		iny
		cpy	#32
		bne	.loopInitEnemy

;--------
		clx
.loopShot:
		lda	myshotTable+MYSHOT_ANGLE, x
		cmp	#$80
		beq	.loopNextShot

;--------
		lda	myshotTable+MYSHOT_X, x
		sta	<checkHitObjX0
		lda	myshotTable+MYSHOT_X+1, x
		sta	<checkHitObjX0+1

		subw	<checkHitObjX0, #$0008

		lda	myshotTable+MYSHOT_Y, x
		sta	<checkHitObjY0
		lda	myshotTable+MYSHOT_Y+1, x
		sta	<checkHitObjY0+1

		subw	<checkHitObjY0, #$0008

		cly
.loopEnemy:
		lda	enemyAngleTable, y
		bmi	.loopNextEnemy

;--------
		lda	enemyXLowTable, y
		sta	<checkHitObjX1
		lda	enemyXHighTable, y
		sta	<checkHitObjX1+1

		lda	enemyYLowTable, y
		sta	<checkHitObjY1
		lda	enemyYHighTable, y
		sta	<checkHitObjY1+1

		jsr	checkHitObj16_3
		bcc	.loopNextEnemy

		lda	#$80
		sta	myshotTable+MYSHOT_ANGLE, x

		lda	enemyStatusTable, y
		ora	#$80
		sta	enemyStatusTable, y

		lda	enemyLifeTable, y
		dec	a
		sta	enemyLifeTable, y
		bne	.loopNextShot

		lda	#$81
		sta	enemyAngleTable, y

		cla
		sta	enemyCounterTable, y

		bra	.loopNextShot

.loopNextEnemy:
		iny
		cpy	#32
		bne	.loopEnemy

.loopNextShot:
		txa
		add	#MYSHOT_STRUCT_SIZE
		tax
		cpx	#MYSHOT_STRUCT_SIZE*MYSHOT_MAX
		jne	.loopShot

		rts


;----------------------------
initEnemy:
;initialize enemy
		clx
.enemyInitLoop:
		lda	#$80
		sta	enemyAngleTable, x
		inx
		cpx	#32
		bne	.enemyInitLoop
		rts


;----------------------------
setEnemy:
;set enemy
		phx

		clx
.enemySetLoop:
		lda	enemyAngleTable, x
		bpl	.enemySetJump

		lda	<setEnemyAngle
		sta	enemyAngleTable, x

		lda	<setEnemyType
		sta	enemyTypeTable, x

		lda	<setEnemyTileNo
		sta	enemyTileNoTable, x

		lda	<setEnemyLife
		sta	enemyLifeTable, x

		stz	enemyStatusTable, x

		stz	enemyCounterTable, x

		lda	<setEnemyXPoint
		sta	enemyXPointLowTable, x
		lda	<setEnemyXPoint+1
		sta	enemyXPointHighTable, x

		lda	<setEnemyX
		sta	enemyXLowTable, x
		lda	<setEnemyX+1
		sta	enemyXHighTable, x

		lda	<setEnemyYPoint
		sta	enemyYPointLowTable, x
		lda	<setEnemyYPoint+1
		sta	enemyYPointHighTable, x

		lda	<setEnemyY
		sta	enemyYLowTable, x
		lda	<setEnemyY+1
		sta	enemyYHighTable, x

		bra	.enemySetEnd

.enemySetJump:
		inx
		cpx	#32
		bne	.enemySetLoop
.enemySetEnd:
		plx
		rts


;----------------------------
moveEnemy:
;move enemy

		clx

.moveEnemyLoop:
		lda	enemyAngleTable, x
		bmi	.checkHitJump04

		lda	enemyTileNoTable, x
		cmp	<centerTileNo
		bne	.checkHitJump04

		lda	enemyTypeTable, x
		bne	.type1
		jsr	moveEnemyType0
		bra	.typeEnd

.type1:
		dec	a
		bne	.type2
		jsr	moveEnemyType0
		bra	.typeEnd

.type2:
		dec	a
		bne	.type3
		jsr	moveEnemyType0
		bra	.typeEnd

.type3:
		dec	a
		bne	.type4
		jsr	moveEnemyType3
		bra	.typeEnd

.type4:
		jsr	moveEnemyType4

.typeEnd:

.checkHitJump04:
		inx
		cpx	#32
		bne	.moveEnemyLoop

		rts


;----------------------------
moveEnemyType0:
;
		sec
		lda	<centerX
		sbc	enemyXLowTable, x
		sta	<mul16b
		lda	<centerX+1
		sbc	enemyXHighTable, x
		sta	<mul16b+1

		sec
		lda	<centerY
		sbc	enemyYLowTable, x
		sta	<mul16a
		lda	<centerY+1
		sbc	enemyYHighTable, x
		sta	<mul16a+1

		jsr	atanStep2

		lsr	a
		eor	#$40
		sta	enemyAngleTable, x

;--------
		asl	a
		tay

;--------
		stz	<centerXYWorkPoint
		lda	sinDataLow, y
		sta	<centerXYWorkPoint+1
		lda	sinDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

;speed 1/2
		lsrq	<centerXYWorkPoint

		lda	enemyXPointLowTable, x
		sta	<checkHitXPoint
		lda	enemyXPointHighTable, x
		sta	<checkHitXPoint+1
		lda	enemyXLowTable, x
		sta	<checkHitX
		lda	enemyXHighTable, x
		sta	<checkHitX+1

		subq	<checkHitXPoint, <centerXYWorkPoint
		andm	<checkHitX+1, #$0F

;--------
		stz	<centerXYWorkPoint
		lda	cosDataLow, y
		sta	<centerXYWorkPoint+1
		lda	cosDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

;speed 1/2
		lsrq	<centerXYWorkPoint

		lda	enemyYPointLowTable, x
		sta	<checkHitYPoint
		lda	enemyYPointHighTable, x
		sta	<checkHitYPoint+1
		lda	enemyYLowTable, x
		sta	<checkHitY
		lda	enemyYHighTable, x
		sta	<checkHitY+1

		subq	<checkHitYPoint, <centerXYWorkPoint
		andm	<checkHitY+1, #$0F

;--------
;myship hit check
		bbs7	<myshipStatus, .checkHitJump03
		movw	<checkHitObjX0, <centerX
		movw	<checkHitObjY0, <centerY
		movw	<checkHitObjX1, <checkHitX
		movw	<checkHitObjY1, <checkHitY

		jsr	checkHitObj16
		jcs	.checkHitJump01

;--------
.checkHitJump03:
		stx	<moveEnemyWork

		clx

.enemyHitLoop:
		cpx	<moveEnemyWork
		beq	.enemyHitJump

		lda	enemyAngleTable, x
		bmi	.enemyHitJump

		lda	enemyTileNoTable, x
		cmp	<centerTileNo
		jne	.enemyHitJump

		movw	<checkHitObjX0, <checkHitX
		movw	<checkHitObjY0, <checkHitY

		lda	enemyXLowTable, x
		sta	<checkHitObjX1
		lda	enemyXHighTable, x
		sta	<checkHitObjX1+1

		lda	enemyYLowTable, x
		sta	<checkHitObjY1
		lda	enemyYHighTable, x
		sta	<checkHitObjY1+1

		jsr	checkHitObj16
		bcs	.checkHitJump02

.enemyHitJump:
		inx
		cpx	#32
		bne	.enemyHitLoop

		clc

.checkHitJump02:
		ldx	<moveEnemyWork

		jcs	.checkHitJump01

;--------
;check move x y
		jsr	checkHit
		bcc	.checkHitJump00

;check move x
		movq	<centerXYWorkPoint, <checkHitXPoint
		lda	enemyXPointLowTable, x
		sta	<checkHitXPoint
		lda	enemyXPointHighTable, x
		sta	<checkHitXPoint+1
		lda	enemyXLowTable, x
		sta	<checkHitX
		lda	enemyXHighTable, x
		sta	<checkHitX+1

		jsr	checkHit
		bcc	.checkHitJump00

;check move y
		movq	<checkHitXPoint, <centerXYWorkPoint
		lda	enemyYPointLowTable, x
		sta	<checkHitYPoint
		lda	enemyYPointHighTable, x
		sta	<checkHitYPoint+1
		lda	enemyYLowTable, x
		sta	<checkHitY
		lda	enemyYHighTable, x
		sta	<checkHitY+1

		jsr	checkHit
		bcs	.checkHitJump01

.checkHitJump00:
		lda	<checkHitXPoint
		sta	enemyXPointLowTable, x
		lda	<checkHitXPoint+1
		sta	enemyXPointHighTable, x
		lda	<checkHitX
		sta	enemyXLowTable, x
		lda	<checkHitX+1
		sta	enemyXHighTable, x

		lda	<checkHitYPoint
		sta	enemyYPointLowTable, x
		lda	<checkHitYPoint+1
		sta	enemyYPointHighTable, x
		lda	<checkHitY
		sta	enemyYLowTable, x
		lda	<checkHitY+1
		sta	enemyYHighTable, x

;--------
.checkHitJump01:
		lda	enemyCounterTable, x
		inc	a
		cmp	#60
		bne	.shotEnd

		lda	enemyAngleTable, x
		sta	<setEnemyShotAngle

		lda	enemyTypeTable, x
		sta	<setEnemyShotType

		lda	enemyXPointLowTable, x
		sta	<setEnemyShotXPoint
		lda	enemyXPointHighTable, x
		sta	<setEnemyShotXPoint+1
		lda	enemyXLowTable, x
		sta	<setEnemyShotX
		lda	enemyXHighTable, x
		sta	<setEnemyShotX+1

		lda	enemyYPointLowTable, x
		sta	<setEnemyShotYPoint
		lda	enemyYPointHighTable, x
		sta	<setEnemyShotYPoint+1
		lda	enemyYLowTable, x
		sta	<setEnemyShotY
		lda	enemyYHighTable, x
		sta	<setEnemyShotY+1


		jsr	setEnemyshot
		cla
.shotEnd:
		sta	enemyCounterTable, x
.checkHitJump04:
		rts


;----------------------------
moveEnemyType3:
;
		sec
		lda	<centerX
		sbc	enemyXLowTable, x
		sta	<mul16b
		lda	<centerX+1
		sbc	enemyXHighTable, x
		sta	<mul16b+1

		sec
		lda	<centerY
		sbc	enemyYLowTable, x
		sta	<mul16a
		lda	<centerY+1
		sbc	enemyYHighTable, x
		sta	<mul16a+1

		jsr	atanStep2

		lsr	a
		eor	#$40
		sta	enemyAngleTable, x

;--------
.checkHitJump01:
		lda	enemyCounterTable, x
		inc	a
		cmp	#60
		bne	.shotEnd

		lda	enemyAngleTable, x
		sta	<setEnemyShotAngle

		mov	<setEnemyShotType, #0

		lda	enemyXPointLowTable, x
		sta	<setEnemyShotXPoint
		lda	enemyXPointHighTable, x
		sta	<setEnemyShotXPoint+1
		lda	enemyXLowTable, x
		sta	<setEnemyShotX
		lda	enemyXHighTable, x
		sta	<setEnemyShotX+1

		lda	enemyYPointLowTable, x
		sta	<setEnemyShotYPoint
		lda	enemyYPointHighTable, x
		sta	<setEnemyShotYPoint+1
		lda	enemyYLowTable, x
		sta	<setEnemyShotY
		lda	enemyYHighTable, x
		sta	<setEnemyShotY+1


		jsr	setEnemyshot
		cla
.shotEnd:
		sta	enemyCounterTable, x
.checkHitJump04:
		rts


;----------------------------
moveEnemyType4:
;
		rts


;----------------------------
setEnemySp:
;set enemy sprite
		clx

.enemySetSpLoop:
		lda	enemyAngleTable, x
		jmi	.enemySetSpJump00

		lda	<screenAngle
		asl	a
		sta	<rotationAngle

		lda	enemyXLowTable, x
		sta	<rotationX
		lda	enemyXHighTable, x
		sta	<rotationX+1

		lda	enemyYLowTable, x
		sta	<rotationY
		lda	enemyYHighTable, x
		sta	<rotationY+1

		jsr	objRotationProc
		jcs	.enemySetSpJump00

		movw	<VDC2SpriteY, <rotationAnsY+1
		movw	<VDC2SpriteX, <rotationAnsX+1

		sec
		lda	<screenAngle
		sbc	enemyAngleTable, x
		and	#$7F

		sta	<getSpAngle


		lda	enemyTypeTable, x
		beq	.enemy0
		dec	a
		beq	.enemy1
		dec	a
		beq	.enemy2
		dec	a
		beq	.enemy3
		dec	a
		beq	.enemy4
		bra	.enemy5

.enemy0:
.enemy1:
.enemy2:
.enemy3:
		mov	<getSpNo, #spREnemy0SpNo

		lda	#spREnemy0SpPalette0
		tst	#$80, enemyStatusTable, x
		beq	.paletteSet0
		lda	#spREnemy0SpPalette1
.paletteSet0:
		sta	<getSpPalette

		bra	.enemyEnd

.enemy4:
		mov	<getSpNo, #$08
		mov	<getSpPalette, #$03
		tst	#$80, enemyStatusTable, x
		beq	.paletteSet4
		mov	<getSpPalette, #$02
.paletteSet4:
		bra	.enemyEnd
.enemy5:
		mov	<getSpNo, #$0A
		mov	<getSpPalette, #$03
		tst	#$80, enemyStatusTable, x
		beq	.paletteSet5
		mov	<getSpPalette, #$02
.paletteSet5:

.enemyEnd:
		jsr	getSpNoAttr

		movw	<VDC2SpriteNo, <spNoWork
		oram	<VDC2SpriteAttr, #$0080
		movw	<VDC2SpriteAttr, <spAttrWork

		jsr	setVDC2Sp

.enemySetSpJump00:
		inx
		cpx	#32
		jne	.enemySetSpLoop

.enemySetSpEnd:
		rts


;----------------------------
setBlastSp:
;set blast sprite
		clx

.blastSetSpLoop:
		lda	enemyAngleTable, x

		bpl	.blastSetSpJump00
		and	#$7F
		beq	.blastSetSpJump00

		lda	enemyCounterTable, x
		inc	a
		cmp	#$C0
		bne	.blastSetSpJump01

		lda	#$80
		sta	enemyAngleTable, x
		jmp	.blastSetSpJump00


.blastSetSpJump01:
		sta	enemyCounterTable, x

		lda	<screenAngle
		asl	a
		sta	<rotationAngle

		lda	enemyXLowTable, x
		sta	<rotationX
		lda	enemyXHighTable, x
		sta	<rotationX+1


		lda	enemyYLowTable, x
		sta	<rotationY
		lda	enemyYHighTable, x
		sta	<rotationY+1

		jsr	objRotationProc
		bcs	.blastSetSpJump00

		movw	<VDC2SpriteY, <rotationAnsY+1
		movw	<VDC2SpriteX, <rotationAnsX+1

		lda	enemyCounterTable, x
		and	#$C0
		lsr	a
		lsr	a
		lsr	a
		add	#$28

		sta	<VDC2SpriteNo
		stz	<VDC2SpriteNo+1
		movw	<VDC2SpriteAttr, #$1182

		jsr	setVDC2Sp

.blastSetSpJump00:
		inx
		cpx	#32
		jne	.blastSetSpLoop

.blastSetSpEnd:
		rts


;----------------------------
initEnemyshot:
;initialize enemyshot
		clx
		ldy	#ENEMYSHOT_MAX
.enemyshotInitLoop:
		lda	#$80
		sta	enemyshotTable+ENEMYSHOT_ANGLE, x
		txa
		add	#ENEMYSHOT_STRUCT_SIZE
		tax
		dey
		bne	.enemyshotInitLoop

		rts


;----------------------------
moveEnemyshot:
;move enemyshot
		clx
		ldy	#ENEMYSHOT_MAX

.enemyshotMoveLoop:
		phy

		lda	enemyshotTable+ENEMYSHOT_ANGLE, x
		cmp	#$80
		jeq	.enemyshotMoveJump

		lda	enemyshotTable+ENEMYSHOT_TYPE, x
		bne	.enemyshotType1
		jsr	moveEnemyshotType0
		bra	.enemyshotTypeEnd
.enemyshotType1:
		dec	a
		bne	.enemyshotType2
		jsr	moveEnemyshotType1
		bra	.enemyshotTypeEnd
.enemyshotType2:
		jsr	moveEnemyshotType2
.enemyshotTypeEnd:

.enemyshotMoveJump:
		txa
		add	#ENEMYSHOT_STRUCT_SIZE
		tax

		ply
		dey
		jne	.enemyshotMoveLoop
.enemyshotMoveEnd:
		rts


;----------------------------
moveEnemyshotType0:
;move enemyshot

		lda	enemyshotTable+ENEMYSHOT_ANGLE, x
		asl	a
		tay

;--------
		lda	sinDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1
		stz	<centerXYWorkPoint
		lda	sinDataLow, y

		asl	a
		rol	<centerXYWork
		rol	<centerXYWork+1
		sta	<centerXYWorkPoint+1

		sec
		lda	enemyshotTable+ENEMYSHOT_XPOINT, x
		sbc	<centerXYWorkPoint
		sta	enemyshotTable+ENEMYSHOT_XPOINT, x
		lda	enemyshotTable+ENEMYSHOT_XPOINT+1, x
		sbc	<centerXYWorkPoint+1
		sta	enemyshotTable+ENEMYSHOT_XPOINT+1, x

		lda	enemyshotTable+ENEMYSHOT_X, x
		sbc	<centerXYWork
		sta	enemyshotTable+ENEMYSHOT_X, x
		lda	enemyshotTable+ENEMYSHOT_X+1, x
		sbc	<centerXYWork+1
		sta	enemyshotTable+ENEMYSHOT_X+1, x

;--------
		lda	cosDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1
		stz	<centerXYWorkPoint
		lda	cosDataLow, y

		asl	a
		rol	<centerXYWork
		rol	<centerXYWork+1
		sta	<centerXYWorkPoint+1

		sec
		lda	enemyshotTable+ENEMYSHOT_YPOINT, x
		sbc	<centerXYWorkPoint
		sta	enemyshotTable+ENEMYSHOT_YPOINT, x
		lda	enemyshotTable+ENEMYSHOT_YPOINT+1, x
		sbc	<centerXYWorkPoint+1
		sta	enemyshotTable+ENEMYSHOT_YPOINT+1, x

		lda	enemyshotTable+ENEMYSHOT_Y, x
		sbc	<centerXYWork
		sta	enemyshotTable+ENEMYSHOT_Y, x
		lda	enemyshotTable+ENEMYSHOT_Y+1, x
		sbc	<centerXYWork+1
		sta	enemyshotTable+ENEMYSHOT_Y+1, x

;--------
		lda	enemyshotTable+ENEMYSHOT_X, x
		sta	<spDataWorkBGX
		lda	enemyshotTable+ENEMYSHOT_X+1, x
		sta	<spDataWorkBGX+1

		lda	enemyshotTable+ENEMYSHOT_Y, x
		sta	<spDataWorkBGY
		lda	enemyshotTable+ENEMYSHOT_Y+1, x
		sta	<spDataWorkBGY+1

;--------
		jsr	getStageData2
		bcc	.enemyshotMove0Jump

		lda	#$80
		sta	enemyshotTable+ENEMYSHOT_ANGLE, x

.enemyshotMove0Jump:
		rts


;----------------------------
moveEnemyshotType1:
;move enemyshot

		lda	enemyshotTable+ENEMYSHOT_ANGLE, x
		asl	a
		tay

;--------
		lda	sinDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1
		stz	<centerXYWorkPoint
		lda	sinDataLow, y

		asl	a
		rol	<centerXYWork
		rol	<centerXYWork+1
		asl	a
		rol	<centerXYWork
		rol	<centerXYWork+1
		sta	<centerXYWorkPoint+1

		sec
		lda	enemyshotTable+ENEMYSHOT_XPOINT, x
		sbc	<centerXYWorkPoint
		sta	enemyshotTable+ENEMYSHOT_XPOINT, x
		lda	enemyshotTable+ENEMYSHOT_XPOINT+1, x
		sbc	<centerXYWorkPoint+1
		sta	enemyshotTable+ENEMYSHOT_XPOINT+1, x

		lda	enemyshotTable+ENEMYSHOT_X, x
		sbc	<centerXYWork
		sta	enemyshotTable+ENEMYSHOT_X, x
		lda	enemyshotTable+ENEMYSHOT_X+1, x
		sbc	<centerXYWork+1
		sta	enemyshotTable+ENEMYSHOT_X+1, x

;--------
		lda	cosDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1
		stz	<centerXYWorkPoint
		lda	cosDataLow, y

		asl	a
		rol	<centerXYWork
		rol	<centerXYWork+1
		asl	a
		rol	<centerXYWork
		rol	<centerXYWork+1
		sta	<centerXYWorkPoint+1

		sec
		lda	enemyshotTable+ENEMYSHOT_YPOINT, x
		sbc	<centerXYWorkPoint
		sta	enemyshotTable+ENEMYSHOT_YPOINT, x
		lda	enemyshotTable+ENEMYSHOT_YPOINT+1, x
		sbc	<centerXYWorkPoint+1
		sta	enemyshotTable+ENEMYSHOT_YPOINT+1, x

		lda	enemyshotTable+ENEMYSHOT_Y, x
		sbc	<centerXYWork
		sta	enemyshotTable+ENEMYSHOT_Y, x
		lda	enemyshotTable+ENEMYSHOT_Y+1, x
		sbc	<centerXYWork+1
		sta	enemyshotTable+ENEMYSHOT_Y+1, x

;--------
		lda	enemyshotTable+ENEMYSHOT_X, x
		sta	<spDataWorkBGX
		lda	enemyshotTable+ENEMYSHOT_X+1, x
		sta	<spDataWorkBGX+1

		lda	enemyshotTable+ENEMYSHOT_Y, x
		sta	<spDataWorkBGY
		lda	enemyshotTable+ENEMYSHOT_Y+1, x
		sta	<spDataWorkBGY+1

;--------
		jsr	getStageData2
		bcc	.enemyshotMove1Jump

		lda	#$80
		sta	enemyshotTable+ENEMYSHOT_ANGLE, x

.enemyshotMove1Jump:
		rts


;----------------------------
moveEnemyshotType2:
;
		lda	enemyshotTable+ENEMYSHOT_ANGLE, x
		sta	<reflectionAngle

		asl	a
		tay

		lda	enemyshotTable+ENEMYSHOT_XPOINT, x
		sta	<reflectionX0Point
		lda	enemyshotTable+ENEMYSHOT_XPOINT+1, x
		sta	<reflectionX0Point+1

		lda	enemyshotTable+ENEMYSHOT_X, x
		sta	<reflectionX0
		lda	enemyshotTable+ENEMYSHOT_X+1, x
		sta	<reflectionX0+1

		lda	enemyshotTable+ENEMYSHOT_YPOINT, x
		sta	<reflectionY0Point
		lda	enemyshotTable+ENEMYSHOT_YPOINT+1, x
		sta	<reflectionY0Point+1

		lda	enemyshotTable+ENEMYSHOT_Y, x
		sta	<reflectionY0
		lda	enemyshotTable+ENEMYSHOT_Y+1, x
		sta	<reflectionY0+1

;--------
		stz	<centerXYWorkPoint
		lda	sinDataLow, y
		sta	<centerXYWorkPoint+1
		lda	sinDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		aslq	<centerXYWorkPoint

		subq	<reflectionX1Point, <reflectionX0Point, <centerXYWorkPoint

;--------
		stz	<centerXYWorkPoint
		lda	cosDataLow, y
		sta	<centerXYWorkPoint+1
		lda	cosDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		aslq	<centerXYWorkPoint

		subq	<reflectionY1Point, <reflectionY0Point, <centerXYWorkPoint

		movw	<spDataWorkBGX, <reflectionX1
		movw	<spDataWorkBGY, <reflectionY1
		jsr	getStageData2
		jcs	.jp20

		lda	<reflectionX1Point
		sta	enemyshotTable+ENEMYSHOT_XPOINT, x
		lda	<reflectionX1Point+1
		sta	enemyshotTable+ENEMYSHOT_XPOINT+1, x

		lda	<reflectionX1
		sta	enemyshotTable+ENEMYSHOT_X, x
		lda	<reflectionX1+1
		sta	enemyshotTable+ENEMYSHOT_X+1, x

		lda	<reflectionY1Point
		sta	enemyshotTable+ENEMYSHOT_YPOINT, x
		lda	<reflectionY1Point+1
		sta	enemyshotTable+ENEMYSHOT_YPOINT+1, x

		lda	<reflectionY1
		sta	enemyshotTable+ENEMYSHOT_Y, x
		lda	<reflectionY1+1
		sta	enemyshotTable+ENEMYSHOT_Y+1, x

		jmp	.enemyshot2MoveJump

.jp20:
		lda	enemyshotTable+ENEMYSHOT_COUNTER, x
		sta	<reflectionCount

		phx
		ldx	#2
.loop0:
		lda	<reflectionAngle
		asl	a
		tay

		stz	<centerXYWorkPoint
		lda	sinDataLow, y
		sta	<centerXYWorkPoint+1
		lda	sinDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		subq	<reflectionX1Point, <reflectionX0Point, <centerXYWorkPoint

		stz	<centerXYWorkPoint
		lda	cosDataLow, y
		sta	<centerXYWorkPoint+1
		lda	cosDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		subq	<reflectionY1Point, <reflectionY0Point, <centerXYWorkPoint

		jsr	checkReflection
		jcc	.jp10

		dec	<reflectionCount
		bne	.jp10

		mov	<reflectionAngle, #$80
		bra	.loop0End

.jp10:
		dex
		bne	.loop0

.loop0End:
		plx

		lda	<reflectionAngle
		sta	enemyshotTable+ENEMYSHOT_ANGLE, x
		cmp	#$80
		beq	.enemyshot2MoveJump

		lda	<reflectionCount
		sta	enemyshotTable+ENEMYSHOT_COUNTER, x

		lda	<reflectionX0Point
		sta	enemyshotTable+ENEMYSHOT_XPOINT, x
		lda	<reflectionX0Point+1
		sta	enemyshotTable+ENEMYSHOT_XPOINT+1, x

		lda	<reflectionX0
		sta	enemyshotTable+ENEMYSHOT_X, x
		lda	<reflectionX0+1
		sta	enemyshotTable+ENEMYSHOT_X+1, x

		lda	<reflectionY0Point
		sta	enemyshotTable+ENEMYSHOT_YPOINT, x
		lda	<reflectionY0Point+1
		sta	enemyshotTable+ENEMYSHOT_YPOINT+1, x

		lda	<reflectionY0
		sta	enemyshotTable+ENEMYSHOT_Y, x
		lda	<reflectionY0+1
		sta	enemyshotTable+ENEMYSHOT_Y+1, x

.enemyshot2MoveJump:
		rts


;----------------------------
setEnemyshotSp:
;set enemyshot sprite
		clx
		ldy	#ENEMYSHOT_MAX

.enemyshotSetSpLoop:
		lda	enemyshotTable+ENEMYSHOT_ANGLE, x
		cmp	#$80
		jeq	.enemyshotSetSpJump00

		lda	<screenAngle
		asl	a
		sta	<rotationAngle

		lda	enemyshotTable+ENEMYSHOT_X, x
		sta	<rotationX
		lda	enemyshotTable+ENEMYSHOT_X+1, x
		sta	<rotationX+1

		lda	enemyshotTable+ENEMYSHOT_Y, x
		sta	<rotationY
		lda	enemyshotTable+ENEMYSHOT_Y+1, x
		sta	<rotationY+1

		jsr	objRotationProc
		bcs	.enemyshotSetSpJump01

		movw	<VDC1SpriteY, <rotationAnsY+1
		movw	<VDC1SpriteX, <rotationAnsX+1

		sec
		lda	<screenAngle
		sbc	enemyshotTable+ENEMYSHOT_ANGLE, x
		and	#$7F

		sta	<getSpAngle
		mov	<getSpNo, #$02
		lda	enemyshotTable+ENEMYSHOT_TYPE, x
		inc	a
		inc	a
		sta	<getSpPalette
		jsr	getSpNoAttr

		movw	<VDC1SpriteNo, <spNoWork
		movw	<VDC1SpriteAttr, <spAttrWork

		jsr	setVDC1Sp

		bra	.enemyshotSetSpJump00

.enemyshotSetSpJump01:

.enemyshotSetSpJump00:
		txa
		add	#ENEMYSHOT_STRUCT_SIZE
		tax
		dey
		jne	.enemyshotSetSpLoop

.enemyshotSetSpEnd:
		rts


;----------------------------
setEnemyshot:
;set enemyshot
		phx
		phy

		clx
		ldy	#ENEMYSHOT_MAX

.setEnemyshotLoop:
		lda	enemyshotTable+ENEMYSHOT_ANGLE, x
		cmp	#$80
		beq	.setEnemyshotJump00

		txa
		add	#ENEMYSHOT_STRUCT_SIZE
		tax
		dey
		bne	.setEnemyshotLoop
		bra	.setEnemyshotEnd

.setEnemyshotJump00:
		lda	<setEnemyShotAngle
		sta	enemyshotTable+ENEMYSHOT_ANGLE, x

		lda	<setEnemyShotType
		sta	enemyshotTable+ENEMYSHOT_TYPE, x

		lda	<setEnemyShotXPoint
		sta	enemyshotTable+ENEMYSHOT_XPOINT, x

		lda	<setEnemyShotXPoint+1
		sta	enemyshotTable+ENEMYSHOT_XPOINT+1, x

		lda	<setEnemyShotX
		sta	enemyshotTable+ENEMYSHOT_X, x

		lda	<setEnemyShotX+1
		sta	enemyshotTable+ENEMYSHOT_X+1, x

		lda	<setEnemyShotYPoint
		sta	enemyshotTable+ENEMYSHOT_YPOINT, x

		lda	<setEnemyShotYPoint+1
		sta	enemyshotTable+ENEMYSHOT_YPOINT+1, x

		lda	<setEnemyShotY
		sta	enemyshotTable+ENEMYSHOT_Y, x

		lda	<setEnemyShotY+1
		sta	enemyshotTable+ENEMYSHOT_Y+1, x

		lda	#4
		sta	enemyshotTable+ENEMYSHOT_COUNTER, x

.setEnemyshotEnd:
		ply
		plx
		rts


;----------------------------
initMyshot:
;initialize myshot
		clx
		ldy	#MYSHOT_MAX
.myshotInitLoop:
		lda	#$80
		sta	myshotTable+MYSHOT_ANGLE, x
		txa
		add	#MYSHOT_STRUCT_SIZE
		tax
		dey
		bne	.myshotInitLoop

		rts


;----------------------------
setMyshot:
;set myshot
		clx
		ldy	#MYSHOT_MAX
.myshotSetLoop:
		lda	myshotTable+MYSHOT_ANGLE, x
		cmp	#$80
		bne	.myshotSetJump

		lda	<screenAngle
		sta	myshotTable+MYSHOT_ANGLE, x

		lda	#MYSHOT_REFLECTION_INIT_COUNT
		sta	myshotTable+MYSHOT_REFLECTION_COUNT, x

		lda	<centerXPoint
		sta	myshotTable+MYSHOT_XPOINT, x
		lda	<centerXPoint+1
		sta	myshotTable+MYSHOT_XPOINT+1, x

		lda	<centerX
		sta	myshotTable+MYSHOT_X, x
		lda	<centerX+1
		sta	myshotTable+MYSHOT_X+1, x

		lda	<centerYPoint
		sta	myshotTable+MYSHOT_YPOINT, x
		lda	<centerYPoint+1
		sta	myshotTable+MYSHOT_YPOINT+1, x

		lda	<centerY
		sta	myshotTable+MYSHOT_Y, x
		lda	<centerY+1
		sta	myshotTable+MYSHOT_Y+1, x

		bra	.myshotSetEnd

.myshotSetJump:
		txa
		add	#MYSHOT_STRUCT_SIZE
		tax
		dey
		bne	.myshotSetLoop
.myshotSetEnd:
		rts


;----------------------------
moveMyshot:
;move myshot
		clx
		ldy	#MYSHOT_MAX

.myshotMoveLoop:
		lda	myshotTable+MYSHOT_ANGLE, x
		cmp	#$80
		jeq	.myshotMoveJump

		phy

		asl	a
		tay

;--------
		stz	<centerXYWorkPoint
		lda	sinDataLow, y
		sta	<centerXYWorkPoint+1
		lda	sinDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		aslq	<centerXYWorkPoint
		aslq	<centerXYWorkPoint
		aslq	<centerXYWorkPoint

		sec
		lda	myshotTable+MYSHOT_XPOINT, x
		sbc	<centerXYWorkPoint
		sta	myshotTable+MYSHOT_XPOINT, x
		lda	myshotTable+MYSHOT_XPOINT+1, x
		sbc	<centerXYWorkPoint+1
		sta	myshotTable+MYSHOT_XPOINT+1, x

		lda	myshotTable+MYSHOT_X, x
		sbc	<centerXYWork
		sta	myshotTable+MYSHOT_X, x
		lda	myshotTable+MYSHOT_X+1, x
		sbc	<centerXYWork+1
		sta	myshotTable+MYSHOT_X+1, x

;--------
		stz	<centerXYWorkPoint
		lda	cosDataLow, y
		sta	<centerXYWorkPoint+1
		lda	cosDataHigh, y
		sta	<centerXYWork
		jsr	signExt
		sta	<centerXYWork+1

		aslq	<centerXYWorkPoint
		aslq	<centerXYWorkPoint
		aslq	<centerXYWorkPoint

		sec
		lda	myshotTable+MYSHOT_YPOINT, x
		sbc	<centerXYWorkPoint
		sta	myshotTable+MYSHOT_YPOINT, x
		lda	myshotTable+MYSHOT_YPOINT+1, x
		sbc	<centerXYWorkPoint+1
		sta	myshotTable+MYSHOT_YPOINT+1, x

		lda	myshotTable+MYSHOT_Y, x
		sbc	<centerXYWork
		sta	myshotTable+MYSHOT_Y, x
		lda	myshotTable+MYSHOT_Y+1, x
		sbc	<centerXYWork+1
		sta	myshotTable+MYSHOT_Y+1, x

;--------
		lda	myshotTable+MYSHOT_X, x
		sta	<spDataWorkBGX
		lda	myshotTable+MYSHOT_X+1, x
		sta	<spDataWorkBGX+1

		lda	myshotTable+MYSHOT_Y, x
		sta	<spDataWorkBGY
		lda	myshotTable+MYSHOT_Y+1, x
		sta	<spDataWorkBGY+1

;--------
		ply

		jsr	getStageData2
		bcc	.myshotMoveJump

		lda	#$80
		sta	myshotTable+MYSHOT_ANGLE, x

.myshotMoveJump:
		txa
		add	#MYSHOT_STRUCT_SIZE
		tax
		dey
		jne	.myshotMoveLoop
.myshotMoveEnd:
		rts


;----------------------------
setMyshotSp:
;set myshot sprite
		clx
		ldy	#MYSHOT_MAX

.myshotSetSpLoop:
		lda	myshotTable+MYSHOT_ANGLE, x
		cmp	#$80
		jeq	.myshotSetSpJump00

		lda	<screenAngle
		asl	a
		sta	<rotationAngle

		lda	myshotTable+MYSHOT_X, x
		sta	<rotationX
		lda	myshotTable+MYSHOT_X+1, x
		sta	<rotationX+1

		lda	myshotTable+MYSHOT_Y, x
		sta	<rotationY
		lda	myshotTable+MYSHOT_Y+1, x
		sta	<rotationY+1

		jsr	objRotationProc
		bcs	.myshotSetSpJump01

		movw	<VDC2SpriteY, <rotationAnsY+1
		movw	<VDC2SpriteX, <rotationAnsX+1

		sec
		lda	<screenAngle
		sbc	myshotTable+MYSHOT_ANGLE, x
		and	#$7F

		sta	<getSpAngle
		mov	<getSpNo, #spRMyshotSpNo
		mov	<getSpPalette, #spRMyshotSpPalette
		jsr	getSpNoAttr

		movw	<VDC2SpriteNo, <spNoWork
		oram	<VDC2SpriteAttr, #$0080
		movw	<VDC2SpriteAttr, <spAttrWork

		jsr	setVDC2Sp

		bra	.myshotSetSpJump00

.myshotSetSpJump01:
		lda	#$80
		sta	myshotTable+MYSHOT_ANGLE, x

.myshotSetSpJump00:
		txa
		add	#MYSHOT_STRUCT_SIZE
		tax
		dey
		jne	.myshotSetSpLoop

.myshotSetSpEnd:
		rts


;----------------------------
initObj:
;
		clx
		ldy	#OBJ_MAX
.initObjLoop:
		lda	#$FF
		sta	objTable+OBJ_TYPE, x

		txa
		add	#OBJ_STRUCT_SIZE
		tax
		dey
		jne	.initObjLoop
		rts


;----------------------------
setObjSp:
;set obj sprite
		clx
		ldy	#OBJ_MAX

.setObjSpLoop:
		lda	objTable+OBJ_TYPE, x
		cmp	#$FF
		jeq	.setObjSpJump00

		lda	<screenAngle
		asl	a
		sta	<rotationAngle

		lda	objTable+OBJ_X, x
		sta	<rotationX
		lda	objTable+OBJ_X+1, x
		sta	<rotationX+1

		lda	objTable+OBJ_Y, x
		sta	<rotationY
		lda	objTable+OBJ_Y+1, x
		sta	<rotationY+1

		jsr	objRotationProc2
		bcs	.setObjSpJump00

		movw	<VDC2SpriteY, <rotationAnsY+1
		movw	<VDC2SpriteX, <rotationAnsX+1

		movw	<VDC2SpriteNo, #$00D0
		movw	<VDC2SpriteAttr, #$0083

		jsr	setVDC2Sp

.setObjSpJump00:
		txa
		add	#OBJ_STRUCT_SIZE
		tax
		dey
		jne	.setObjSpLoop

.setObjSpEnd:
		rts


;----------------------------
padAngleData:
		;	0000 000U 00R0 00RU 0D00 0D0U 0DR0 0DRU L000 L00U L0R0 L0RU LD00 LD0U LDR0 LDRU
		.db	$80, $00, $60, $70, $40, $80, $50, $80, $20, $10, $80, $80, $30, $80, $80, $80


;----------------------------
stage0EnemyData
		.db	$00, $00, $01, $81, $28, $00, $18, $00
		.db	$00, $00, $01, $81, $58, $00, $18, $00
		.db	$00, $01, $04, $82, $D8, $01, $28, $00
		.db	$00, $01, $04, $82, $D8, $01, $D8, $00
		.db	$00, $05, $10, $85, $08, $05, $F8, $00
		.db	$00, $05, $10, $85, $28, $05, $F8, $00
		.db	$00, $05, $10, $85, $F8, $04, $08, $01
		.db	$00, $04, $10, $85, $18, $05, $08, $01
		.db	$00, $05, $10, $85, $38, $05, $08, $01
		.db	$00, $05, $10, $85, $08, $05, $18, $01
		.db	$00, $05, $10, $85, $28, $05, $18, $01
		.db	$00, $03, $08, $83, $C8, $01, $48, $03
		.db	$00, $03, $08, $83, $B8, $02, $48, $03
		.db	$00, $03, $08, $83, $C8, $01, $C8, $03
		.db	$00, $03, $08, $83, $B8, $02, $C8, $03
		.db	$00, $03, $08, $83, $C8, $01, $48, $04
		.db	$00, $03, $08, $83, $B8, $02, $48, $04
		.db	$00, $02, $10, $84, $68, $04, $F8, $04
		.db	$00, $02, $10, $84, $98, $04, $F8, $04
		.db	$00, $02, $10, $84, $68, $04, $28, $05
		.db	$00, $02, $10, $84, $98, $04, $28, $05
		.db	$FF


;**********************************
		.bank	2
		.org	$A000

;----------------------------
;--                        --
;----------------------------
getSpNoAttr:
;
		phx
		phy

		lda	<getSpNo
		and	#$FE
		tax

		lda	<getSpAngle

		cpx	#$00
		bne	.spNotNo0_1

		add	#$10

;No0,2,4,6,8,10
.spNotNo0_1:
		and	#$7E
		tay

		lda	spAttrData, y
		sta	<spAttrWork
		lda	spAttrData+1, y
		sta	<spAttrWork+1

		lda	spNoData, y
		bmi	.attr32

		ora	spBaseData, x
		sta	<spNoWork
		lda	spBaseData+1, x
		sta	<spNoWork+1

		bra	.attrChekNo0

.attr32:
		lda	spNo32Data, x
		sta	<spNoWork
		stz	<spNoWork+1

.attrChekNo0:
		lda	<getSpNo
		beq	.noAttrEnd

		cmp	#$01
		beq	.spNo1

;set palette
		oram	<spAttrWork, <getSpPalette

		bra	.noAttrEnd

;set palette
.spNo1:
		oram	<spAttrWork, #$01

.noAttrEnd:
		ply
		plx
		rts


;----------------------------
checkReflection:
;
		lda	<reflectionX0
		sta	<reflectionBGX0
		lda	<reflectionX0+1
		lsr	a
		ror	<reflectionBGX0
		lsr	a
		ror	<reflectionBGX0
		lsr	a
		ror	<reflectionBGX0
		lsr	a
		ror	<reflectionBGX0

		lda	<reflectionY0
		sta	<reflectionBGY0
		lda	<reflectionY0+1
		lsr	a
		ror	<reflectionBGY0
		lsr	a
		ror	<reflectionBGY0
		lsr	a
		ror	<reflectionBGY0
		lsr	a
		ror	<reflectionBGY0


		lda	<reflectionX1
		sta	<reflectionBGX1
		lda	<reflectionX1+1
		lsr	a
		ror	<reflectionBGX1
		lsr	a
		ror	<reflectionBGX1
		lsr	a
		ror	<reflectionBGX1
		lsr	a
		ror	<reflectionBGX1

		lda	<reflectionY1
		sta	<reflectionBGY1
		lda	<reflectionY1+1
		lsr	a
		ror	<reflectionBGY1
		lsr	a
		ror	<reflectionBGY1
		lsr	a
		ror	<reflectionBGY1
		lsr	a
		ror	<reflectionBGY1


		mov	<spDataWorkBGX, <reflectionBGX1
		mov	<spDataWorkBGY, <reflectionBGY1

		jsr	getStageData

		bcs	.jpWall

;not wall
		movq	<reflectionX0Point, <reflectionX1Point
		movq	<reflectionY0Point, <reflectionY1Point
		clc
		rts

;wall
.jpWall:

		lda	<reflectionBGY1
		cmp	<reflectionBGY0
		beq	.jp00

		lda	<reflectionBGX1
		cmp	<reflectionBGX0
		beq	.jp01

;X0!=X1 Y0!=Y1

		stz	<reflectionCheckFlag

		mov	<spDataWorkBGX, <reflectionBGX0
		mov	<spDataWorkBGY, <reflectionBGY1

		jsr	getStageData

		cmp	#$80
		beq	.checkjp00
		mov	<reflectionCheckFlag, #$80
.checkjp00:

		mov	<spDataWorkBGX, <reflectionBGX1
		mov	<spDataWorkBGY, <reflectionBGY0

		jsr	getStageData

		cmp	#$80
		beq	.checkjp01
		oram	<reflectionCheckFlag, #$40
.checkjp01:

		lda	<reflectionCheckFlag
		cmp	#$80
		beq	.jp01
		cmp	#$40
		beq	.jp00

		clc
		lda	<reflectionAngle
		adc	#64
		and	#$7F
		sta	<reflectionAngle
		bra	.jp02

.jp00:
;Y0==Y1
		sec
		lda	#128
		sbc	<reflectionAngle
		and	#$7F
		sta	<reflectionAngle
		bra	.jp02

.jp01:
;X0==X1
		sec
		lda	#64
		sbc	<reflectionAngle
		and	#$7F
		sta	<reflectionAngle

.jp02:
		sec
		rts


;----------------------------
objRotationProc:
;rotationX rotationY
;rotationAnsX rotationAnsY
;rotationAnsX+1 += #SCREEN_CENTERX+32-16
;rotationAnsY+1 += #SCREEN_CENTERY+64-16

		subw	<rotationX, <centerX
		subw	<rotationY, <centerY

		jsr	checkRelativeCenterXY
		bcs	.outJump

		jsr	rotationProc

		addw	<rotationAnsX+1, #SCREEN_CENTERX+32-16
		addw	<rotationAnsY+1, #SCREEN_CENTERY+64-16

		jsr	checkScreenXY

.outJump:
		rts


;----------------------------
objRotationProc2:
;rotationX rotationY
;rotationAnsX rotationAnsY
;rotationAnsX+1 += #SCREEN_CENTERX+32-8
;rotationAnsY+1 += #SCREEN_CENTERY+64-8

		subw	<rotationX, <centerX
		subw	<rotationY, <centerY

		jsr	checkRelativeCenterXY
		bcs	.outJump

		jsr	rotationProc

		addw	<rotationAnsX+1, #SCREEN_CENTERX+32-8
		addw	<rotationAnsY+1, #SCREEN_CENTERY+64-8

		jsr	checkScreenXY

.outJump:
		rts


;----------------------------
checkRelativeCenterXY:
;rotationAnsX rotationAnsY
		phx
		lda	<screenAngle
		asl	a
		tax

		sec
		lda	<rotationX
		sbc	relativeCenterX0, x
		lda	<rotationX+1
		sbc	relativeCenterX0+1, x
		jmi	.outJump

		sec
		lda	<rotationX
		sbc	relativeCenterX1, x
		lda	<rotationX+1
		sbc	relativeCenterX1+1, x
		bpl	.outJump

		sec
		lda	<rotationY
		sbc	relativeCenterY0, x
		lda	<rotationY+1
		sbc	relativeCenterY0+1, x
		bmi	.outJump

		sec
		lda	<rotationY
		sbc	relativeCenterY1, x
		lda	<rotationY+1
		sbc	relativeCenterY1+1, x
		bpl	.outJump

		clc
		bra	.endJump
.outJump:
		sec
.endJump:
		plx
		rts


;----------------------------
checkScreenXY:
;rotationAnsX rotationAnsY

		;X < 4
		cmpw	<rotationAnsX+1, #SCREEN_LEFT
		bmi	.outJump

		;X >= 220
		cmpw	<rotationAnsX+1, #SCREEN_RIGHT
		bpl	.outJump

		;Y < 52
		cmpw	<rotationAnsY+1, #SCREEN_TOP
		bmi	.outJump

		;Y >= 292
		cmpw	<rotationAnsY+1, #SCREEN_BOTTOM
		bpl	.outJump

		clc
		rts
.outJump:
		sec
		rts


;----------------------------
checkHitObj16_3:
;1dot 16*16 object
;checkHitObjX0:checkHitObjY0 1dot object
;checkHitObjX1:checkHitObjY1 16*16 object centerX-8:centerY-8
		subw	<checkHitObjWork, <checkHitObjX1, <checkHitObjX0
		bmi	.withoutXY

		cmpw	<checkHitObjWork, #$00016
		bpl	.withoutXY			;>=16

		subw	<checkHitObjWork, <checkHitObjY1, <checkHitObjY0
		bmi	.withoutXY

		cmpw	<checkHitObjWork, #$00016
		bpl	.withoutXY			;>=16

		sec
		rts

.withoutXY:
		clc
		rts


;----------------------------
checkHitObj16_2:
;1dot 16*16 object
;checkHitObjX0:checkHitObjY0 1dot object
;checkHitObjX1:checkHitObjY1 16*16 object
		subw	<checkHitObjWork, <checkHitObjX1, <checkHitObjX0
		bmi	.XMinus

		cmpw	<checkHitObjWork, #$0008
		bpl	.withoutXY			;>=8
		bra	.withinX

.XMinus:
		cmpw	<checkHitObjWork, #$FFF8
		bmi	.withoutXY			;<-8


.withinX:
		subw	<checkHitObjWork, <checkHitObjY1, <checkHitObjY0
		bmi	.YMinus

		cmpw	<checkHitObjWork, #$0008
		bpl	.withoutXY			;>=8
		bra	.withinY

.YMinus:
		cmpw	<checkHitObjWork, #$FFF8
		bmi	.withoutXY			;<-8

.withinY:
		sec
		rts

.withoutXY:
		clc
		rts


;----------------------------
checkHitObj16:
;16*16 16*16 object
		subw	<checkHitObjWork, <checkHitObjX1, <checkHitObjX0
		bmi	.XMinus

		cmpw	<checkHitObjWork, #$0010
		bpl	.withoutXY			;>=16
		bra	.withinX

.XMinus:
		cmpw	<checkHitObjWork, #$FFF1
		bmi	.withoutXY			;<-15


.withinX:
		subw	<checkHitObjWork, <checkHitObjY1, <checkHitObjY0
		bmi	.YMinus

		cmpw	<checkHitObjWork, #$0010
		bpl	.withoutXY			;>=16
		bra	.withinY

.YMinus:
		cmpw	<checkHitObjWork, #$FFF1
		bmi	.withoutXY			;<-15

.withinY:
		sec
		rts

.withoutXY:
		clc
		rts


;----------------------------
checkHit:
;block checkHitX checkHitY
		phx

		clx

.checkLoop:
		lda	hitDataX, x
		sta	<spDataWorkBGX
		jsr	signExt
		sta	<spDataWorkBGX+1

		addw	<spDataWorkBGX, <checkHitX

		lda	hitDataY, x
		sta	<spDataWorkBGY
		jsr	signExt
		sta	<spDataWorkBGY+1

		addw	<spDataWorkBGY, <checkHitY

		jsr	getStageData2

		bcs	.checkLoopEnd

		inx
		cpx	#8
		bne	.checkLoop

		plx
		clc
		rts

.checkLoopEnd:
		plx
		sec
		rts


;----------------------------
getStageData2:
;
		lda	<spDataWorkBGX+1
		lsr	a
		ror	<spDataWorkBGX
		lsr	a
		ror	<spDataWorkBGX
		lsr	a
		ror	<spDataWorkBGX
		lsr	a
		ror	<spDataWorkBGX

		lda	<spDataWorkBGY+1
		lsr	a
		ror	<spDataWorkBGY
		lsr	a
		ror	<spDataWorkBGY
		lsr	a
		ror	<spDataWorkBGY
		lsr	a
		ror	<spDataWorkBGY

		jsr	getStageData

		rts


;----------------------------
getStageData:
;
		phy

		ldy	<spDataWorkBGY
		lda	stageDataBankData, y
		tam	#stageDataMemoryBank

		stz	<bgDataAddr
		lda	stageDataAddrHighData, y
		sta	<bgDataAddr+1

		ldy	<spDataWorkBGX
		lda	[bgDataAddr], y

		bmi	.notWall

		sec
		ply
		rts

.notWall:
		clc
		ply
		rts


;----------------------------
atanStep2:
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
		jsr	_atanStep2

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
_atanStep2:
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
;--                        --
;----------------------------
setCharData:
;CHAR set to vram
		lda	#charDataBank
		tam	#$02

;vram address $1000
		stz	VPC_6	;select VDC#1

		st0	#$00
		st1	#$00
		st2	#$10

		st0	#$02
		tia	$4000, VDC1_2, $2000

		lda	#$01
		sta	VPC_6	;select VDC#2

		st0	#$00
		st1	#$00
		st2	#$10

		st0	#$02
		tia	$4000, VDC2_2, $2000

		rts


;----------------------------
putHex:
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

		sei

		stz	VDC1_0
		ldy	<puthexaddr
		sty	VDC1_2
		ldy	<puthexaddr+1
		sty	VDC1_3

		ldy	#$02
		sty	VDC1_0
		stx	VDC1_2
		ldy	#$01
		sty	VDC1_3

		sta	VDC1_2
		sty	VDC1_3

		cli

		ply
		plx
		pla

		rts


;----------------------------
;--                        --
;----------------------------
setVDC1WriteAddr:
;
		sei
		mov	VDC1_0, #$00
		movw	VDC1_2, <VDC1WriteAddr
		mov	VDC1_0, #$02
		cli
		rts


;----------------------------
clearVDC1Sat:
;
		sei
		mov	VDC1_0, #$00
		movw	VDC1_2, <VDC1SatAddr
		mov	VDC1_0, #$02

		cli
		stz	<VDC1SpriteCounter
		rts


;----------------------------
setVDC1Sp:
;
		lda	<VDC1SpriteCounter
		cmp	#$64
		bcs	.jp00

		jsr	_setVDC1Sp

		inc	<VDC1SpriteCounter

		clc

.jp00:
		rts


;----------------------------
_setVDC1Sp:
;
		sei
		movw	VDC1_2, <VDC1SpriteY
		movw	VDC1_2, <VDC1SpriteX
		movw	VDC1_2, <VDC1SpriteNo
		movw	VDC1_2, <VDC1SpriteAttr
		cli

		rts


;----------------------------
setVDC1SpDma:
;
		sei
		mov	VDC1_0, #$13
		movw	VDC1_2, <VDC1SpDmaAddr
		cli
		rts


;----------------------------
setVDC2WriteAddr:
;
		sei
		mov	VDC2_0, #$00
		movw	VDC2_2, <VDC2WriteAddr
		mov	VDC2_0, #$02
		cli
		rts


;----------------------------
clearVDC2Sat:
;
		sei
		mov	VDC2_0, #$00
		movw	VDC2_2, <VDC2SatAddr
		mov	VDC2_0, #$02

		cli
		stz	<VDC2SpriteCounter
		rts


;----------------------------
setVDC2Sp:
;
		lda	<VDC2SpriteCounter
		cmp	#$64
		bcs	.jp00

		jsr	_setVDC2Sp

		inc	<VDC2SpriteCounter

		clc

.jp00:
		rts


;----------------------------
_setVDC2Sp:
;
		sei
		movw	VDC2_2, <VDC2SpriteY
		movw	VDC2_2, <VDC2SpriteX
		movw	VDC2_2, <VDC2SpriteNo
		movw	VDC2_2, <VDC2SpriteAttr
		cli

		rts


;----------------------------
setVDC2SpDma:
;
		sei
		mov	VDC2_0, #$13
		movw	VDC2_2, <VDC2SpDmaAddr
		cli
		rts


;----------------------------
initializeVdp:
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
		lda	VDC1_0
		lda	VDC2_0
vdpdataloop:	lda	vdpData, y
		cmp	#$FF
		beq	vdpdataend
		sta	VDC1_0
		sta	VDC2_0
		iny

		lda	vdpData, y
		sta	VDC1_2
		sta	VDC2_2
		iny

		lda	vdpData, y
		sta	VDC1_3
		sta	VDC2_3
		iny
		bra	vdpdataloop
vdpdataend:

		lda	#$33
		sta	VPC_0
		sta	VPC_1

		stz	VPC_2
		stz	VPC_3
		stz	VPC_4
		stz	VPC_5

		stz	VPC_6	;select VDC#1

;disable interrupts TIQD       IRQ2D
		lda	#$05
		sta	INT_DIS_REG

;262Line  VCE Clock 5MHz
		lda	#$04
		sta	VCE_0

;set palette
		stz	VCE_2
		stz	VCE_3
		tia	bgPaletteData, VCE_4, $0200

		stz	VCE_2
		lda	#$01
		sta	VCE_3
		tia	spPaletteData, VCE_4, $0200

;clear BG
		lda	#$02

		stz	VDC1_0
		stz	VDC1_2
		stz	VDC1_3
		sta	VDC1_0

		stz	VDC2_0
		stz	VDC2_2
		stz	VDC2_3
		sta	VDC2_0

		ldy	#4
		lda	#$01
.clearBGLoop0:
		clx
.clearBGLoop1:
		stz	VDC1_2
		sta	VDC1_3

		stz	VDC2_2
		sta	VDC2_3

		dex
		bne	.clearBGLoop1

		dey
		bne	.clearBGLoop0

		rts


;----------------------------
showScreen:
;show screen
		sei
;VDC#1
;bg sp       vsync
;+1
		mov	VDC1_0, #$05
		movw	VDC1_2, #$00C8

;VDC#2
;bg sp
;+1
		mov	VDC2_0, #$05
		movw	VDC2_2, #$00C0

		cli

		rts


;----------------------------
;--                        --
;----------------------------
rotationMulProc:
		lda	<mul16b
		beq	.bLowZero

.smul16:
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

.umul16:
		phy

		stz	<muladdr

		ldy	<mul16b
		lda	umul16Bank, y

		sta	<mulbank
		tam	#$02

		lda	umul16Address, y
		sta	<muladdr+1

		ldy	<mul16a
		lda	[muladdr], y
		sta	<mul16c

		ldy	<mul16a+1
		lda	[muladdr], y
		sta	<mul16c+1

		clc
		lda	<mulbank
		adc	#8		;carry clear
		tam	#$02

		ldy	<mul16a
		lda	[muladdr], y
		adc	<mul16c+1
		sta	<mul16c+1

		ldy	<mul16a+1
		lda	[muladdr], y
		adc	#0		;carry clear
		sta	<mul16d

		stz	<mul16d+1
		ply

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

.bLowZero:
		lda	<mul16b+1
		beq	.bHighZero
		bpl	.bHighPlus

		stz	<mul16c

		sec
		cla
		sbc	<mul16a
		sta	<mul16c+1

		cla
		sbc	<mul16a+1
		sta	<mul16d

		cla
		sbc	<mul16b
		sta	<mul16d+1

		rts

.bHighZero:
		stzq	<mul16c
		rts

.bHighPlus:
		stz	<mul16c

		lda	<mul16a
		sta	<mul16c+1

		lda	<mul16a+1
		sta	<mul16d

		lda	<mul16b
		sta	<mul16d+1

		rts


;----------------------------
rotationProc:
;rotationAngle
;rotationX -> rotationAnsX
;rotationY -> rotationAnsY
;X=xcosA-ysinA process
;xcosA
		phx

		movw	<mul16a, <rotationX

		ldx	<rotationAngle
		lda	cosDataLow,x
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	rotationMulProc

		movq	<rotationAnsX, <mul16c

;ysinA
		movw	<mul16a, <rotationY

		ldx	<rotationAngle
		lda	sinDataLow,x
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	rotationMulProc

;xcosA-ysinA
		subq	<rotationAnsX, <mul16c

;Y=xsinA+ycosA process
;xsinA
		movw	<mul16a, <rotationX

		ldx	<rotationAngle
		lda	sinDataLow,x
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	rotationMulProc

		movq	<rotationAnsY, <mul16c

;ycosA
		movw	<mul16a, <rotationY

		ldx	<rotationAngle
		lda	cosDataLow,x
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	rotationMulProc

;xsinA+ycosA
		addq	<rotationAnsY, <mul16c

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
;--                        --
;----------------------------
vdpData:
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
bgPaletteData:
		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

;--------
		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0111, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
spPaletteData:
		.dw	$0000, $00DB, $01B6, $01FF, $0000, $00DB, $01B6, $01FF,\
			$0000, $00DB, $01B6, $01FF, $0000, $00DB, $01B6, $01FF

		.dw	$0000, $0000, $0000, $0000, $00DB, $00DB, $00DB, $00DB,\
			$01B6, $01B6, $01B6, $01B6, $01FF, $01FF, $01FF, $01FF

		.dw	$0000, $0007, $01B6, $00DB, $0038, $0005, $016D, $01FF,\
			$0000, $00DB, $01B6, $00F6, $01FF, $01FF, $01FF, $01FF

		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
;--------
		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000


;----------------------------
hitDataX:
		.db	 -8,   0,   7,  -8,   7,  -8,   0,   7;16*16


;----------------------------
hitDataY:
		.db	 -8,  -8,  -8,   0,   0,   7,   7,   7;16*16


;----------------------------
spNoData:
		.dw	$0000, $0008, $0010, $0018, $0020, $0028, $0030, $0038,\
			$0040, $0048, $0050, $0058, $0060, $0068, $0070, $0078,\
			$00FF, $0078, $0070, $0068, $0060, $0058, $0050, $0048,\
			$0040, $0038, $0030, $0028, $0020, $0018, $0010, $0008,\
			$0000, $0008, $0010, $0018, $0020, $0028, $0030, $0038,\
			$0040, $0048, $0050, $0058, $0060, $0068, $0070, $0078,\
			$00FF, $0078, $0070, $0068, $0060, $0058, $0050, $0048,\
			$0040, $0038, $0030, $0028, $0020, $0018, $0010, $0008


;----------------------------
spNo32Data:
		.dw	$0040, $0048, $0050, $0058, $0060, $0068


;----------------------------
spBaseData:
		.dw	$0100, $0180, $0200, $0280, $0300 ,$0380


;----------------------------
spAttrData:
		.dw	$1100, $1100, $1100, $1100, $1100, $1100, $1100, $1100,\
			$1100, $1100, $1100, $1100, $1100, $1100, $1100, $1100,\
			$1100, $9100, $9100, $9100, $9100, $9100, $9100, $9100,\
			$9100, $9100, $9100, $9100, $9100, $9100, $9100, $9100,\
			$9100, $9900, $9900, $9900, $9900, $9900, $9900, $9900,\
			$9900, $9900, $9900, $9900, $9900, $9900, $9900, $9900,\
			$1900, $1900, $1900, $1900, $1900, $1900, $1900, $1900,\
			$1900, $1900, $1900, $1900, $1900, $1900, $1900, $1900


;----------------------------
stageDataBankData:
		.db	$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank, $00+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank, $01+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank, $02+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank, $03+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank, $04+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank, $05+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank, $06+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank,\
			$07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank, $07+stage0DataBank


;----------------------------
stageDataAddrHighData:
		.db	$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh,\
			$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh,\
			$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh,\
			$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh,\
			$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh,\
			$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh,\
			$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh,\
			$00+stageDataAddrHigh, $01+stageDataAddrHigh, $02+stageDataAddrHigh, $03+stageDataAddrHigh,\
			$04+stageDataAddrHigh, $05+stageDataAddrHigh, $06+stageDataAddrHigh, $07+stageDataAddrHigh,\
			$08+stageDataAddrHigh, $09+stageDataAddrHigh, $0A+stageDataAddrHigh, $0B+stageDataAddrHigh,\
			$0C+stageDataAddrHigh, $0D+stageDataAddrHigh, $0E+stageDataAddrHigh, $0F+stageDataAddrHigh,\
			$10+stageDataAddrHigh, $11+stageDataAddrHigh, $12+stageDataAddrHigh, $13+stageDataAddrHigh,\
			$14+stageDataAddrHigh, $15+stageDataAddrHigh, $16+stageDataAddrHigh, $17+stageDataAddrHigh,\
			$18+stageDataAddrHigh, $19+stageDataAddrHigh, $1A+stageDataAddrHigh, $1B+stageDataAddrHigh,\
			$1C+stageDataAddrHigh, $1D+stageDataAddrHigh, $1E+stageDataAddrHigh, $1F+stageDataAddrHigh


;----------------------------
;--                        --
;----------------------------
sinDataLow:
		.db	$00, $06, $0D, $13, $19, $1F, $26, $2C, $32, $38, $3E, $44, $4A, $50, $56, $5C,\
			$62, $68, $6D, $73, $79, $7E, $84, $89, $8E, $93, $98, $9D, $A2, $A7, $AC, $B1,\
			$B5, $B9, $BE, $C2, $C6, $CA, $CE, $D1, $D5, $D8, $DC, $DF, $E2, $E5, $E7, $EA,\
			$ED, $EF, $F1, $F3, $F5, $F7, $F8, $FA, $FB, $FC, $FD, $FE, $FF, $FF, $00, $00,\
			$00, $00, $00, $FF, $FF, $FE, $FD, $FC, $FB, $FA, $F8, $F7, $F5, $F3, $F1, $EF,\
			$ED, $EA, $E7, $E5, $E2, $DF, $DC, $D8, $D5, $D1, $CE, $CA, $C6, $C2, $BE, $B9,\
			$B5, $B1, $AC, $A7, $A2, $9D, $98, $93, $8E, $89, $84, $7E, $79, $73, $6D, $68,\
			$62, $5C, $56, $50, $4A, $44, $3E, $38, $32, $2C, $26, $1F, $19, $13, $0D, $06,\
			$00, $FA, $F3, $ED, $E7, $E1, $DA, $D4, $CE, $C8, $C2, $BC, $B6, $B0, $AA, $A4,\
			$9E, $98, $93, $8D, $87, $82, $7C, $77, $72, $6D, $68, $63, $5E, $59, $54, $4F,\
			$4B, $47, $42, $3E, $3A, $36, $32, $2F, $2B, $28, $24, $21, $1E, $1B, $19, $16,\
			$13, $11, $0F, $0D, $0B, $09, $08, $06, $05, $04, $03, $02, $01, $01, $00, $00,\
			$00, $00, $00, $01, $01, $02, $03, $04, $05, $06, $08, $09, $0B, $0D, $0F, $11,\
			$13, $16, $19, $1B, $1E, $21, $24, $28, $2B, $2F, $32, $36, $3A, $3E, $42, $47,\
			$4B, $4F, $54, $59, $5E, $63, $68, $6D, $72, $77, $7C, $82, $87, $8D, $93, $98,\
			$9E, $A4, $AA, $B0, $B6, $BC, $C2, $C8, $CE, $D4, $DA, $E1, $E7, $ED, $F3, $FA 


;----------------------------
sinDataHigh:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01,\
			$01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
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


;----------------------------
cosDataLow:
		.db	$00, $00, $00, $FF, $FF, $FE, $FD, $FC, $FB, $FA, $F8, $F7, $F5, $F3, $F1, $EF,\
			$ED, $EA, $E7, $E5, $E2, $DF, $DC, $D8, $D5, $D1, $CE, $CA, $C6, $C2, $BE, $B9,\
			$B5, $B1, $AC, $A7, $A2, $9D, $98, $93, $8E, $89, $84, $7E, $79, $73, $6D, $68,\
			$62, $5C, $56, $50, $4A, $44, $3E, $38, $32, $2C, $26, $1F, $19, $13, $0D, $06,\
			$00, $FA, $F3, $ED, $E7, $E1, $DA, $D4, $CE, $C8, $C2, $BC, $B6, $B0, $AA, $A4,\
			$9E, $98, $93, $8D, $87, $82, $7C, $77, $72, $6D, $68, $63, $5E, $59, $54, $4F,\
			$4B, $47, $42, $3E, $3A, $36, $32, $2F, $2B, $28, $24, $21, $1E, $1B, $19, $16,\
			$13, $11, $0F, $0D, $0B, $09, $08, $06, $05, $04, $03, $02, $01, $01, $00, $00,\
			$00, $00, $00, $01, $01, $02, $03, $04, $05, $06, $08, $09, $0B, $0D, $0F, $11,\
			$13, $16, $19, $1B, $1E, $21, $24, $28, $2B, $2F, $32, $36, $3A, $3E, $42, $47,\
			$4B, $4F, $54, $59, $5E, $63, $68, $6D, $72, $77, $7C, $82, $87, $8D, $93, $98,\
			$9E, $A4, $AA, $B0, $B6, $BC, $C2, $C8, $CE, $D4, $DA, $E1, $E7, $ED, $F3, $FA,\
			$00, $06, $0D, $13, $19, $1F, $26, $2C, $32, $38, $3E, $44, $4A, $50, $56, $5C,\
			$62, $68, $6D, $73, $79, $7E, $84, $89, $8E, $93, $98, $9D, $A2, $A7, $AC, $B1,\
			$B5, $B9, $BE, $C2, $C6, $CA, $CE, $D1, $D5, $D8, $DC, $DF, $E2, $E5, $E7, $EA,\
			$ED, $EF, $F1, $F3, $F5, $F7, $F8, $FA, $FB, $FC, $FD, $FE, $FF, $FF, $00, $00


;----------------------------
cosDataHigh:
		.db	$01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
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
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01


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


;----------------------------
relativeCenterX0:
		.dw	$FF90, $FF87, $FF7E, $FF75, $FF6D, $FF65, $FF5D, $FF56,\
			$FF4F, $FF49, $FF43, $FF3D, $FF38, $FF34, $FF30, $FF2C,\
			$FF29, $FF27, $FF25, $FF23, $FF22, $FF22, $FF22, $FF23,\
			$FF24, $FF25, $FF28, $FF2B, $FF2E, $FF32, $FF36, $FF3B,\
			$FF40, $FF3B, $FF36, $FF32, $FF2E, $FF2B, $FF28, $FF25,\
			$FF24, $FF23, $FF22, $FF22, $FF22, $FF23, $FF25, $FF27,\
			$FF29, $FF2C, $FF30, $FF34, $FF38, $FF3D, $FF43, $FF49,\
			$FF4F, $FF56, $FF5D, $FF65, $FF6D, $FF75, $FF7E, $FF87,\
			$FF90, $FF8D, $FF8A, $FF88, $FF86, $FF84, $FF82, $FF81,\
			$FF80, $FF7F, $FF7F, $FF7F, $FF7F, $FF80, $FF81, $FF82,\
			$FF84, $FF85, $FF87, $FF8A, $FF8D, $FF90, $FF93, $FF96,\
			$FF9A, $FF9E, $FFA2, $FFA7, $FFAB, $FFB0, $FFB5, $FFBB,\
			$FFC0, $FFBB, $FFB5, $FFB0, $FFAB, $FFA7, $FFA2, $FF9E,\
			$FF9A, $FF96, $FF93, $FF90, $FF8D, $FF8A, $FF87, $FF85,\
			$FF84, $FF82, $FF81, $FF80, $FF7F, $FF7F, $FF7F, $FF7F,\
			$FF80, $FF81, $FF82, $FF84, $FF86, $FF88, $FF8A, $FF8D


;----------------------------
relativeCenterX1:
		.dw	$0070, $0073, $0076, $0078, $007A, $007C, $007E, $007F,\
			$0080, $0081, $0081, $0081, $0081, $0080, $007F, $007E,\
			$007C, $007B, $0079, $0076, $0073, $0070, $006D, $006A,\
			$0066, $0062, $005E, $0059, $0055, $0050, $004B, $0045,\
			$0040, $0045, $004B, $0050, $0055, $0059, $005E, $0062,\
			$0066, $006A, $006D, $0070, $0073, $0076, $0079, $007B,\
			$007C, $007E, $007F, $0080, $0081, $0081, $0081, $0081,\
			$0080, $007F, $007E, $007C, $007A, $0078, $0076, $0073,\
			$0070, $0079, $0082, $008B, $0093, $009B, $00A3, $00AA,\
			$00B1, $00B7, $00BD, $00C3, $00C8, $00CC, $00D0, $00D4,\
			$00D7, $00D9, $00DB, $00DD, $00DE, $00DE, $00DE, $00DD,\
			$00DC, $00DB, $00D8, $00D5, $00D2, $00CE, $00CA, $00C5,\
			$00C0, $00C5, $00CA, $00CE, $00D2, $00D5, $00D8, $00DB,\
			$00DC, $00DD, $00DE, $00DE, $00DE, $00DD, $00DB, $00D9,\
			$00D7, $00D4, $00D0, $00CC, $00C8, $00C3, $00BD, $00B7,\
			$00B1, $00AA, $00A3, $009B, $0093, $008B, $0082, $0079


;----------------------------
relativeCenterY0:
		.dw	$FF40, $FF3B, $FF36, $FF32, $FF2E, $FF2B, $FF28, $FF25,\
			$FF24, $FF23, $FF22, $FF22, $FF22, $FF23, $FF25, $FF27,\
			$FF29, $FF2C, $FF30, $FF34, $FF38, $FF3D, $FF43, $FF49,\
			$FF4F, $FF56, $FF5D, $FF65, $FF6D, $FF75, $FF7E, $FF87,\
			$FF90, $FF8D, $FF8A, $FF88, $FF86, $FF84, $FF82, $FF81,\
			$FF80, $FF7F, $FF7F, $FF7F, $FF7F, $FF80, $FF81, $FF82,\
			$FF84, $FF85, $FF87, $FF8A, $FF8D, $FF90, $FF93, $FF96,\
			$FF9A, $FF9E, $FFA2, $FFA7, $FFAB, $FFB0, $FFB5, $FFBB,\
			$FFC0, $FFBB, $FFB5, $FFB0, $FFAB, $FFA7, $FFA2, $FF9E,\
			$FF9A, $FF96, $FF93, $FF90, $FF8D, $FF8A, $FF87, $FF85,\
			$FF84, $FF82, $FF81, $FF80, $FF7F, $FF7F, $FF7F, $FF7F,\
			$FF80, $FF81, $FF82, $FF84, $FF86, $FF88, $FF8A, $FF8D,\
			$FF90, $FF87, $FF7E, $FF75, $FF6D, $FF65, $FF5D, $FF56,\
			$FF4F, $FF49, $FF43, $FF3D, $FF38, $FF34, $FF30, $FF2C,\
			$FF29, $FF27, $FF25, $FF23, $FF22, $FF22, $FF22, $FF23,\
			$FF24, $FF25, $FF28, $FF2B, $FF2E, $FF32, $FF36, $FF3B


;----------------------------
relativeCenterY1:
		.dw	$0040, $0045, $004B, $0050, $0055, $0059, $005E, $0062,\
			$0066, $006A, $006D, $0070, $0073, $0076, $0079, $007B,\
			$007C, $007E, $007F, $0080, $0081, $0081, $0081, $0081,\
			$0080, $007F, $007E, $007C, $007A, $0078, $0076, $0073,\
			$0070, $0079, $0082, $008B, $0093, $009B, $00A3, $00AA,\
			$00B1, $00B7, $00BD, $00C3, $00C8, $00CC, $00D0, $00D4,\
			$00D7, $00D9, $00DB, $00DD, $00DE, $00DE, $00DE, $00DD,\
			$00DC, $00DB, $00D8, $00D5, $00D2, $00CE, $00CA, $00C5,\
			$00C0, $00C5, $00CA, $00CE, $00D2, $00D5, $00D8, $00DB,\
			$00DC, $00DD, $00DE, $00DE, $00DE, $00DD, $00DB, $00D9,\
			$00D7, $00D4, $00D0, $00CC, $00C8, $00C3, $00BD, $00B7,\
			$00B1, $00AA, $00A3, $009B, $0093, $008B, $0082, $0079,\
			$0070, $0073, $0076, $0078, $007A, $007C, $007E, $007F,\
			$0080, $0081, $0081, $0081, $0081, $0080, $007F, $007E,\
			$007C, $007B, $0079, $0076, $0073, $0070, $006D, $006A,\
			$0066, $0062, $005E, $0059, $0055, $0050, $004B, $0045




;**********************************
		.bank	3
		INCBIN	"char.dat"		;    8K  3    $02
		INCBIN	"mul.dat"		;  128K  4~19 $04~$13
		INCBIN	"spxy.dat"		;  128K 20~35 $14~$23	SPXY and BGXY ([spx:1byte, spy:1byte, bgx:1byte, bgy:1byte] * 128data * 128angle * 2left and right)
		INCBIN	"stage0.dat"		;   64K 36~43 $24~$2B	256 * 256
		INCBIN	"spWall.dat"		;    8K 44~44 $2C~$2C	32dot*32dot*16 left right No0_1
		INCBIN	"spShot.dat"		;    8K 45~45 $2D~$2D	32dot*32dot*16 left No2
		INCBIN	"spEnemy0.dat"		;    8K 46~46 $2E~$2E	32dot*32dot*16 right No2
		INCBIN	"sp32.dat"		;    8K 47~47 $2F~$2F	32dot*32dot*16 left right no0_1 2 4 6 8 10 X X
		INCBIN	"spETC.dat"		;    8K 48~48 $30~$30	32dot*32dot*16
		INCBIN	"spBoss0Center.dat"	;    8K 49~49 $31~$31	32dot*32dot*16
		INCBIN	"spBoss0Satellite.dat"	;    8K 50~50 $32~$32	32dot*32dot*16
