;//////////////////////////////////
charDataBank		.equ	2
mulDataBank		.equ	3
spxyDataBank		.equ	19
stage0DataBank		.equ	35
sp00DataBank		.equ	43


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
SCREEN_CENTERX		.equ	128
SCREEN_CENTERY		.equ	160


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
aslq		.macro
;\1 << 1
		asl	\1
		rol	\1+1
		rol	\1+2
		rol	\1+3

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

spDataCount		.ds	1

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

;---------------------
checkHitXPoint		.ds	2
checkHitX		.ds	2
checkHitYPoint		.ds	2
checkHitY		.ds	2


;//////////////////////////////////
		.bss
;**********************************
		.org 	$2100
;**********************************
		.org 	$2200
			.rsset	$0
;---------------------
MYSHOT_ANGLE		.rs	1
MYSHOT_XPOINT		.rs	2
MYSHOT_X		.rs	2
MYSHOT_YPOINT		.rs	2
MYSHOT_Y		.rs	2
MYSHOT_STRUCT_SIZE	.rs	0
MYSHOT_MAX		.equ	4
myshotTable		.ds	MYSHOT_STRUCT_SIZE*MYSHOT_MAX

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
		jsr	udiv32_2

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
udiv32_2:
;div16a(0_32767) div16b = div16d:div16c(0_32767*32767) / div16a(1_32767)
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
;div16d MSB 0
		rol	<div16d
		rol	<div16d+1

		lda	<div16d
		sbc	<div16a
		sta	<div16d

		lda	<div16d+1
		sbc	<div16a+1
		sta	<div16d+1

		bmi	.jpMi01

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
;div16d MSB 1
		rol	<div16d
		rol	<div16d+1

		lda	<div16d
		adc	<div16a
		sta	<div16d

		lda	<div16d+1
		adc	<div16a+1
		sta	<div16d+1

		bpl	.jpPl01

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
		jsr	initializeVdp

		jsr	setCharData

;++++++++++++++++++++++++++++
;set tiafunc tiifunc
		lda	#$E3;		tia
		sta	tiafunc

		lda	#$73;		tii
		sta	tiifunc

		lda	#$60;		rts
		sta	tiarts
		sta	tiirts

;initialize
		movq	<centerXPoint, #$0020, #$0000
		movq	<centerYPoint, #$0020, #$0000

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

		jsr	showScreen

		rmb7	<vsyncFlag

		cli

;++++++++++++++++++++++++++++
.mainLoop:
;wait vsync
		bbs7	<vsyncFlag, .mainLoop

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
		subq	<checkHitYPoint, <centerXYWorkPoint
		andm	<checkHitY+1, #$0F

		jsr	checkHit
		cmp	#$00
		beq	.checkHitJump00

		movq	<centerXYWorkPoint, <checkHitXPoint
		movq	<checkHitXPoint, <centerXPoint
		jsr	checkHit
		cmp	#$00
		beq	.checkHitJump00

		movq	<checkHitXPoint, <centerXYWorkPoint
		movq	<checkHitYPoint, <centerYPoint
		jsr	checkHit
		cmp	#$00
		bne	.checkHitJump01

.checkHitJump00:
		movq	<centerXPoint, <checkHitXPoint
		movq	<centerYPoint, <checkHitYPoint

.checkHitJump01:
.checkPadEnd:

.checkPadB:
		bbr1	<padstate, .checkPadBEnd
		jsr	setMyshot

.checkPadBEnd:

		jsr	moveMyshot

;set wall
		lda	<screenAngle
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#sp00DataBank
		tam	#$02

		lda	<screenAngle
		and	#$0F
		asl	a
		clc
		adc	#$40
		stz	tiasrc
		sta	tiasrc+1

		movw	tiadst, #VDC1_2
		movw	tialen, #$0200

		mov	VDC1_0, #$00
		movw	VDC1_2, #$4000

		mov	VDC1_0, #$02

		jsr	tiafunc

		movw	tiadst, #VDC2_2
		movw	tialen, #$0200

		mov	VDC2_0, #$00
		movw	VDC2_2, #$4000

		mov	VDC2_0, #$02

		jsr	tiafunc

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

		movw	<adjustCenterX, <rotationAnsX+2
		movw	<adjustCenterY, <rotationAnsY+2

;Left
;set sprite attribute VRAM address
		stz	VPC_6		;select VDC#1

		st0	#$00		;VRAM $0400
		st1	#$00
		st2	#$04

		st0	#$02

;set left sprite count
		mov	spDataCount, #64

;set myship sprite
		movw	VDC1_2, #SCREEN_CENTERY+64-16
		movw	VDC1_2, #SCREEN_CENTERX+32-16
		movw	VDC1_2, #$0200
		movw	VDC1_2, #$1180

		dec	<spDataCount

		jsr	setMyshotSp

;spData set bank
		lda	<screenAngle
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#spxyDataBank
		tam	#$02

		lda	<screenAngle
		and	#$07
		asl	a
		asl	a
		clc
		adc	#$40
		stz	<spDataAddr
		sta	<spDataAddr+1

;spData index clear
		cly

.spLDataLoop:
		lda	[spDataAddr], y
		cmp	#$FF
		jeq	.spLDataLoopEnd
		sta	<spDataWorkX
		stz	<spDataWorkX+1
		iny

		lda	[spDataAddr], y
		sta	<spDataWorkY
		stz	<spDataWorkY+1
		iny

		lda	[spDataAddr], y
		add	<bgCenterX
		sta	<spDataWorkBGX
		iny

		lda	[spDataAddr], y
		add	<bgCenterY
		sta	<spDataWorkBGY
		iny

		bne	.spLDataJump0
		inc	<spDataAddr+1
.spLDataJump0:

		jsr	getStageData
		cmp	#$00
		beq	.spLDataLoop

		addw	<spDataWorkX, #32
		subw	<spDataWorkX, <adjustCenterX
		addw	<spDataWorkY, #64
		subw	<spDataWorkY, <adjustCenterY

		movw	VDC1_2, <spDataWorkY
		movw	VDC1_2, <spDataWorkX
		movw	VDC1_2, #$0200
		movw	VDC1_2, #$1180

		dec	<spDataCount
		jne	.spLDataLoop

.spLDataLoopEnd:

;Right
;set sprite attribute VRAM address
		lda	#$01
		sta	VPC_6		;select VDC#2

		st0	#$00		;VRAM $0400
		st1	#$00
		st2	#$04

		st0	#$02

;set right sprite count
		mov	spDataCount, #64

;spData set bank
		lda	<screenAngle
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#spxyDataBank
		tam	#$02

		lda	<screenAngle
		and	#$07
		asl	a
		asl	a
		clc
		adc	#$42
		stz	<spDataAddr
		sta	<spDataAddr+1

;spData index clear
		cly

.spRDataLoop:
		lda	[spDataAddr], y
		cmp	#$FF
		jeq	.spRDataLoopEnd
		sta	<spDataWorkX
		stz	<spDataWorkX+1
		iny

		lda	[spDataAddr], y
		sta	<spDataWorkY
		stz	<spDataWorkY+1
		iny

		lda	[spDataAddr], y
		add	<bgCenterX
		sta	<spDataWorkBGX
		iny

		lda	[spDataAddr], y
		add	<bgCenterY
		sta	<spDataWorkBGY
		iny

		bne	.spRDataJump0
		inc	<spDataAddr+1
.spRDataJump0:

		jsr	getStageData
		cmp	#$00
		beq	.spRDataLoop

		addw	<spDataWorkX, #32
		subw	<spDataWorkX, <adjustCenterX
		addw	<spDataWorkY, #64
		subw	<spDataWorkY, <adjustCenterY

		movw	VDC2_2, <spDataWorkY
		movw	VDC2_2, <spDataWorkX
		movw	VDC2_2, #$0200
		movw	VDC2_2, #$1180

		dec	<spDataCount
		jne	.spRDataLoop

.spRDataLoopEnd:

;++++++++++++++++++++++++++++
;SATB DMA set
		stz	VPC_6		;select VDC#1
		st0	#$13
		st1	#$00
		st2	#$04

		lda	#$01
		sta	VPC_6		;select VDC#2
		st0	#$13
		st1	#$00
		st2	#$04

;++++++++++++++++++++++++++++
;put datas
		lda	<screenAngle
		ldx	#$00
		ldy	#$02
		jsr	putHex

		lda	<centerX+1
		ldx	#$00
		ldy	#$03
		jsr	putHex

		lda	<centerX
		ldx	#$02
		ldy	#$03
		jsr	putHex

		lda	<centerXPoint+1
		ldx	#$04
		ldy	#$03
		jsr	putHex

		lda	<centerXPoint
		ldx	#$06
		ldy	#$03
		jsr	putHex

		lda	<centerY+1
		ldx	#$00
		ldy	#$04
		jsr	putHex

		lda	<centerY
		ldx	#$02
		ldy	#$04
		jsr	putHex

		lda	<centerYPoint+1
		ldx	#$04
		ldy	#$04
		jsr	putHex

		lda	<centerYPoint
		ldx	#$06
		ldy	#$04
		jsr	putHex

;myshot0
		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_ANGLE
		ldx	#$00
		ldy	#$06
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_X+1
		ldx	#$00
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_X
		ldx	#$02
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_XPOINT+1
		ldx	#$04
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_XPOINT
		ldx	#$06
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_Y+1
		ldx	#$00
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_Y
		ldx	#$02
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_YPOINT+1
		ldx	#$04
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*0+MYSHOT_YPOINT
		ldx	#$06
		ldy	#$08
		jsr	putHex

;myshot1
		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_ANGLE
		ldx	#$08
		ldy	#$06
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_X+1
		ldx	#$08
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_X
		ldx	#$0A
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_XPOINT+1
		ldx	#$0C
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_XPOINT
		ldx	#$0E
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_Y+1
		ldx	#$08
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_Y
		ldx	#$0A
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_YPOINT+1
		ldx	#$0C
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*1+MYSHOT_YPOINT
		ldx	#$0E
		ldy	#$08
		jsr	putHex

;myshot2
		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_ANGLE
		ldx	#$10
		ldy	#$06
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_X+1
		ldx	#$10
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_X
		ldx	#$12
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_XPOINT+1
		ldx	#$14
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_XPOINT
		ldx	#$16
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_Y+1
		ldx	#$10
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_Y
		ldx	#$12
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_YPOINT+1
		ldx	#$14
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*2+MYSHOT_YPOINT
		ldx	#$16
		ldy	#$08
		jsr	putHex

;myshot3
		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_ANGLE
		ldx	#$18
		ldy	#$06
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_X+1
		ldx	#$18
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_X
		ldx	#$1A
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_XPOINT+1
		ldx	#$1C
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_XPOINT
		ldx	#$1E
		ldy	#$07
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_Y+1
		ldx	#$18
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_Y
		ldx	#$1A
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_YPOINT+1
		ldx	#$1C
		ldy	#$08
		jsr	putHex

		lda	myshotTable+MYSHOT_STRUCT_SIZE*3+MYSHOT_YPOINT
		ldx	#$1E
		ldy	#$08
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

		jsr	getPadData

		bbr7	<vsyncFlag, .irqEnd

;VDC#1 section
		stz	VPC_6		;select VDC#1

		st0	#$07		;scrollx
		st1	#$00
		st2	#$00

		st0	#$08		;scrolly
		st1	#$00
		st2	#$00

;clear SATB
		st0	#$00		;set SATB addr
		st1	#$00
		st2	#$04

		st0	#$02		;VRAM clear
		st1	#$00
		st2	#$00

		st0	#$10		;set DMA src
		st1	#$00
		st2	#$04

		st0	#$11		;set DMA dist
		st1	#$01
		st2	#$04

		st0	#$12		;set DMA count 255WORD
		st1	#$FF
		st2	#$00

;VDC#2 section
		lda	#$01
		sta	VPC_6		;select VDC#2

		st0	#$07		;scrollx
		st1	#$00
		st2	#$00

		st0	#$08		;scrolly
		st1	#$00
		st2	#$00

;clear SATB
		st0	#$00		;set SATB addr
		st1	#$00
		st2	#$04

		st0	#$02		;VRAM clear
		st1	#$00
		st2	#$00

		st0	#$10		;set DMA src
		st1	#$00
		st2	#$04

		st0	#$11		;set DMA dist
		st1	#$01
		st2	#$04

		st0	#$12		;set DMA count 255WORD
		st1	#$FF
		st2	#$00

		rmb7	<vsyncFlag
.irqEnd:

		ply
		plx
		pla

		rts


;----------------------------
checkHit:
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

		cmp	#$00
		bne	.checkLoopEnd

		inx
		cpx	#8
		bne	.checkLoop

.checkLoopEnd:
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

;----------------------------
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

;----------------------------
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

;----------------------------
		lda	myshotTable+MYSHOT_X, x
		sta	<spDataWorkBGX
		lda	myshotTable+MYSHOT_X+1, x
		sta	<spDataWorkBGX+1

		lda	myshotTable+MYSHOT_Y, x
		sta	<spDataWorkBGY
		lda	myshotTable+MYSHOT_Y+1, x
		sta	<spDataWorkBGY+1

;----------------------------
		ply

		jsr	getStageData2

		cmp	#$00
		beq	.myshotMoveJump

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

		subw	<rotationX, <centerX

		lda	myshotTable+MYSHOT_Y, x
		sta	<rotationY
		lda	myshotTable+MYSHOT_Y+1, x
		sta	<rotationY+1

		subw	<rotationY, <centerY

		jsr	rotationProc

		addw	<rotationAnsX+1, #SCREEN_CENTERX+32-16
		addw	<rotationAnsY+1, #SCREEN_CENTERY+64-16

		;X < 128-16*6+32-32
		cmpw	<rotationAnsX+1, #$0020
		bcc	.myshotSetSpJump01

		;X >= 128+16*6+32
		cmpw	<rotationAnsX+1, #$0100
		bcs	.myshotSetSpJump01

		;Y < 0+64-32
		cmpw	<rotationAnsY+1, #$0020
		bcc	.myshotSetSpJump01

		;Y >= 240+64
		cmpw	<rotationAnsY+1, #$0130
		bcs	.myshotSetSpJump01

		movw	VDC1_2, <rotationAnsY+1
		movw	VDC1_2, <rotationAnsX+1
		movw	VDC1_2, #$0200
		movw	VDC1_2, #$1180

		dec	<spDataCount
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

		lda	<spDataWorkBGY
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#stage0DataBank
		tam	#$03

		lda	<spDataWorkBGY
		and	#$1F
		clc
		adc	#$60
		stz	<bgDataAddr
		sta	<bgDataAddr+1

		ldy	<spDataWorkBGX
		lda	[bgDataAddr], y

		ply
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

		jsr	smul16

		movq	<rotationAnsX, <mul16c

;ysinA
		movw	<mul16a, <rotationY

		ldx	<rotationAngle
		lda	sinDataLow,x
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16

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

		jsr	smul16

		movq	<rotationAnsY, <mul16c

;ycosA
		movw	<mul16a, <rotationY

		ldx	<rotationAngle
		lda	cosDataLow,x
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16

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

		ply
		plx
		pla

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

;set vpc
		lda	#$77
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
		tia	bgPaletteData, VCE_4, $20

		stz	VCE_2
		lda	#$01
		sta	VCE_3
		tia	spPaletteData, VCE_4, $20

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
;VDC#1
;bg sp       vsync
;+1
		stz	VPC_6		;select VDC#1

		st0	#$05
		st1	#$C8
		st2	#$00

;VDC#2
;bg sp
;+1
		lda	#$01
		sta	VPC_6		;select VDC#2

		st0	#$05
		st1	#$C0
		st2	#$C0

		rts


;----------------------------
padAngleData:
		;	0000 000U 00R0 00RU 0D00 0D0U 0DR0 0DRU L000 L00U L0R0 L0RU LD00 LD0U LDR0 LDRU
		.db	$80, $00, $60, $70, $40, $80, $50, $80, $20, $10, $80, $80, $30, $80, $80, $80


;----------------------------
vdpData:
		.db	$05, $00, $00	;screen off +1
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $04	;HDW $1F HDE $04
		.db	$0C, $02, $0D	;VSW $02 VDS $0D
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $03, $00	;VCR $03
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $00, $00	;32x32
		.db	$FF		;end


;----------------------------
bgPaletteData:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
spPaletteData:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


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
hitDataX:
		.db	-16,   0,  15, -16,  15, -16,   0,  15


;----------------------------
hitDataY:
		.db	-16, -16, -16,   0,   0,  15,  15,  15


;**********************************
		.bank	2
		INCBIN	"char.dat"		;    8K  2    $02
		INCBIN	"mul.dat"		;  128K  3~18 $03~$12
		INCBIN	"spxy.dat"		;  128K 19~34 $13~$22	SPXY and BGXY ([spx:1byte, spy:1byte, bgx:1byte, bgy:1byte] * 128data * 128angle * 2left and right)
		INCBIN	"stage0.dat"		;   64K 35~42 $23~$2A	256 * 256
		INCBIN	"sp00.dat"		;   64K 43~50 $2B~$32	32dot*32dot 128angle
