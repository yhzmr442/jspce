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
staLineYY	.macro
		sta	.lineY1_0_\1
		sta	.lineY2_1_\1
		sta	.lineY3_2_\1
		sta	.lineY0_3_\1
		.endm


;----------------------------
addNextY	.macro
		clc
		lda	<lineX\2
		.db	$69	;adc	#__
.lineY\1_\2_X0:
		.db	$00
		sta	<lineX\1

		lda	<lineX\2+1
		.db	$69	;adc	#__
.lineY\1_\2_X1:
		.db	$00
		sta	<lineX\1+1

		lda	<lineX\2+2
		.db	$69	;adc	#__
.lineY\1_\2_X2:
		.db	$00
		sta	<lineX\1+2

		lda	<lineX\2+3
		.db	$69	;adc	#__
.lineY\1_\2_X3:
		.db	$00
		sta	<lineX\1+3

		clc
		lda	<lineY\2
		.db	$69	;adc	#__
.lineY\1_\2_Y0:
		.db	$00
		sta	<lineY\1

		lda	<lineY\2+1
		.db	$69	;adc	#__
.lineY\1_\2_Y1:
		.db	$00
		sta	<lineY\1+1

		lda	<lineY\2+2
		.db	$69	;adc	#__
.lineY\1_\2_Y2:
		.db	$00
		sta	<lineY\1+2

		lda	<lineY\2+3
		.db	$69	;adc	#__
.lineY\1_\2_Y3:
		.db	$00
		sta	<lineY\1+3
		.endm


;----------------------------
getLineData	.macro
		ldx	<lineY\1+2
		lda	bgDataAddr, x
		sta	.lineAddr\1_\2

		ldx	<lineX\1+2
		.db	$BD	;lda	____, x
		.db	$00
.lineAddr\1_\2:
		.db	$00
		.endm


;----------------------------
staLineXX	.macro
		sta	.line\1_0_\2
		sta	.line\1_1_\2
		sta	.line\1_2_\2
		sta	.line\1_3_\2
		.endm


;----------------------------
addNext2	.macro
		ldx	#LOW(lineX\1)

		clc
		set
		.db	$69	;adc	#__
.line\1_\2_X0:
		.db	$00

		inx
		set
		.db	$69	;adc	#__
.line\1_\2_X1:
		.db	$00

		inx
		set
		.db	$69	;adc	#__
.line\1_\2_X2:
		.db	$00

		inx
		set
		.db	$69	;adc	#__
.line\1_\2_X3:
		.db	$00

;--------
		ldx	#LOW(lineY\1)

		clc
		set
		.db	$69	;adc	#__
.line\1_\2_Y0:
		.db	$00

		inx
		set
		.db	$69	;adc	#__
.line\1_\2_Y1:
		.db	$00

		inx
		set
		.db	$69	;adc	#__
.line\1_\2_Y2:
		.db	$00

		lda	<lineY\1+3
		.db	$69	;adc	#__
.line\1_\2_Y3:
		.db	$00
		sta	<lineY\1+3
		.endm


;----------------------------
jne		.macro
		beq	.jp\@
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

		.bss
;**********************************
		.org 	$2100
;**********************************
		.org 	$2200

;++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++
;lineBgData		.ds	32
;++++++++++++++++++++++++++++++++
;++++++++++++++++++++++++++++++++


;//////////////////////////////////
		.code
		.bank	0
;**********************************
		.org	$3600
;----------------------------
rotationProc:

;init
		subq	<lineDataX, <lineDataXX
		subq	<lineDataY, <lineDataXY

		movq	<lineX0, <lineDataX
		movq	<lineY0, <lineDataY

		addq	<lineX1, <lineX0, <lineDataYX
		addq	<lineY1, <lineY0, <lineDataYY

		addq	<lineX2, <lineX1, <lineDataYX
		addq	<lineY2, <lineY1, <lineDataYY

		addq	<lineX3, <lineX2, <lineDataYX
		addq	<lineY3, <lineY2, <lineDataYY

		addq	<lineDataX, <lineX3, <lineDataYX
		addq	<lineDataY, <lineY3, <lineDataYY

		mov	<lineLoopXWork, <lineLoopX


		lda	<lineDataXX
		staLineXX	0, X0
		staLineXX	1, X0
		staLineXX	2, X0
		staLineXX	3, X0

		lda	<lineDataXX+1
		staLineXX	0, X1
		staLineXX	1, X1
		staLineXX	2, X1
		staLineXX	3, X1

		lda	<lineDataXX+2
		staLineXX	0, X2
		staLineXX	1, X2
		staLineXX	2, X2
		staLineXX	3, X2

		lda	<lineDataXX+3
		staLineXX	0, X3
		staLineXX	1, X3
		staLineXX	2, X3
		staLineXX	3, X3

		lda	<lineDataXY
		staLineXX	0, Y0
		staLineXX	1, Y0
		staLineXX	2, Y0
		staLineXX	3, Y0

		lda	<lineDataXY+1
		staLineXX	0, Y1
		staLineXX	1, Y1
		staLineXX	2, Y1
		staLineXX	3, Y1

		lda	<lineDataXY+2
		staLineXX	0, Y2
		staLineXX	1, Y2
		staLineXX	2, Y2
		staLineXX	3, Y2

		lda	<lineDataXY+3
		staLineXX	0, Y3
		staLineXX	1, Y3
		staLineXX	2, Y3
		staLineXX	3, Y3


		lda	<lineDataYX
		staLineYY	X0

		lda	<lineDataYX+1
		staLineYY	X1

		lda	<lineDataYX+2
		staLineYY	X2

		lda	<lineDataYX+3
		staLineYY	X3

		lda	<lineDataYY
		staLineYY	Y0

		lda	<lineDataYY+1
		staLineYY	Y1

		lda	<lineDataYY+2
		staLineYY	Y2

		lda	<lineDataYY+3
		staLineYY	Y3


		stz	<lineAddr

		sei
		st0	#$00
		lda	<lineBgAddr
		sta	<lineBgAddrWork
		sta	VDC_2
		lda	<lineBgAddr+1
		sta	<lineBgAddrWork+1
		sta	VDC_3
		st0	#$02

		mov	<lineLoopX, <lineLoopXWork

		jmp	.loopX_0


.loopY:
;loop y
;next Y
		movq	<lineX0, <lineDataX
		movq	<lineY0, <lineDataY

		addNextY	1, 0
		addNextY	2, 1
		addNextY	3, 2

		clc
		lda	<lineX3
		.db	$69	;adc	#__
.lineY0_3_X0:
		.db	$00
		sta	<lineDataX

		lda	<lineX3+1
		.db	$69	;adc	#__
.lineY0_3_X1:
		.db	$00
		sta	<lineDataX+1

		lda	<lineX3+2
		.db	$69	;adc	#__
.lineY0_3_X2:
		.db	$00
		sta	<lineDataX+2

		lda	<lineX3+3
		.db	$69	;adc	#__
.lineY0_3_X3:
		.db	$00
		sta	<lineDataX+3

		clc
		lda	<lineY3
		.db	$69	;adc	#__
.lineY0_3_Y0:
		.db	$00
		sta	<lineDataY

		lda	<lineY3+1
		.db	$69	;adc	#__
.lineY0_3_Y1:
		.db	$00
		sta	<lineDataY+1

		lda	<lineY3+2
		.db	$69	;adc	#__
.lineY0_3_Y2:
		.db	$00
		sta	<lineDataY+2

		lda	<lineY3+3
		.db	$69	;adc	#__
.lineY0_3_Y3:
		.db	$00
		sta	<lineDataY+3


		sei
		st0	#$00
		lda	<lineBgAddrWork
		sta	<lineBgAddr
		sta	VDC_2
		lda	<lineBgAddrWork+1
		inc	a
		inc	a
		sta	<lineBgAddrWork+1
		sta	<lineBgAddr+1
		sta	VDC_3
		st0	#$02

		mov	<lineLoopX, <lineLoopXWork

		bra	.loopX_0
.loopX:
;loop x
		sei
		st0	#$00
		movw	VDC_2, <lineBgAddr
		st0	#$02

.loopX_0:
;++++++++++++++++++++++++++++++++
;line0_0
;next X
		addNext2	0, 0

		stz	<lineDataWork

		ora	<lineX0+3
		bne	.line0Jump0

		getLineData	0, 0

		and	#$F0
		sta	<lineDataWork

.line0Jump0:

;--------------------------------
;line0_1
;next X
		addNext2	0, 1

		ora	<lineX0+3
		cla
		bne	.line0Jump1

		getLineData	0, 1

		and	#$0F

.line0Jump1:
		ora	<lineDataWork
		tax

		lda	bgDataHigh0, x
		sta	<lineBgData+0

		lda	bgDataHigh1, x
		sta	<lineBgData+1

		lda	bgDataHigh2, x
		sta	<lineBgData+16

		lda	bgDataHigh3, x
		sta	<lineBgData+17

;--------------------------------
;line0_2
;next X
		addNext2	0, 2

		stz	<lineDataWork

		ora	<lineX0+3
		bne	.line0Jump2

		getLineData	0, 2

		and	#$F0
		sta	<lineDataWork

.line0Jump2:

;--------------------------------
;line0_3
;next X
		addNext2	0, 3

		ora	<lineX0+3
		cla
		bne	.line0Jump3

		getLineData	0, 3

		and	#$0F
.line0Jump3:
		ora	<lineDataWork
		tax

		lda	<lineBgData+0
		ora	bgDataLow0, x
		sta	VDC_2
		tay

		lda	<lineBgData+1
		ora	bgDataLow1, x
		sta	VDC_3

		sty	VDC_2
		sta	VDC_3

		lda	<lineBgData+16
		ora	bgDataLow2, x
		sta	<lineBgData+16
		sta	<lineBgData+18

		lda	<lineBgData+17
		ora	bgDataLow3, x
		sta	<lineBgData+17
		sta	<lineBgData+19

;++++++++++++++++++++++++++++++++
;line1_0
;next X
		addNext2	1, 0

		stz	<lineDataWork

		ora	<lineX1+3
		bne	.line1Jump0

		getLineData	1, 0

		and	#$F0
		sta	<lineDataWork

.line1Jump0:

;--------------------------------
;line1_1
;next X
		addNext2	1, 1

		ora	<lineX1+3
		cla
		bne	.line1Jump1

		getLineData	1, 1

		and	#$0F

.line1Jump1:
		ora	<lineDataWork
		tax

		lda	bgDataHigh0, x
		sta	<lineBgData+4

		lda	bgDataHigh1, x
		sta	<lineBgData+5

		lda	bgDataHigh2, x
		sta	<lineBgData+20

		lda	bgDataHigh3, x
		sta	<lineBgData+21

;--------------------------------
;line1_2
;next X
		addNext2	1, 2

		stz	<lineDataWork

		ora	<lineX1+3
		bne	.line1Jump2

		getLineData	1, 2

		and	#$F0
		sta	<lineDataWork

.line1Jump2:

;--------------------------------
;line1_3
;next X
		addNext2	1, 3

		ora	<lineX1+3
		cla
		bne	.line1Jump3

		getLineData	1, 3

		and	#$0F

.line1Jump3:
		ora	<lineDataWork
		tax

		lda	<lineBgData+4
		ora	bgDataLow0, x
		sta	VDC_2
		tay

		lda	<lineBgData+5
		ora	bgDataLow1, x
		sta	VDC_3

		sty	VDC_2
		sta	VDC_3

		lda	<lineBgData+20
		ora	bgDataLow2, x
		sta	<lineBgData+20
		sta	<lineBgData+22

		lda	<lineBgData+21
		ora	bgDataLow3, x
		sta	<lineBgData+21
		sta	<lineBgData+23

;++++++++++++++++++++++++++++++++
;line2_0
;next X
		addNext2	2, 0

		stz	<lineDataWork

		ora	<lineX2+3
		bne	.line2Jump0

		getLineData	2, 0

		and	#$F0
		sta	<lineDataWork

.line2Jump0:

;--------------------------------
;line2_1
;next X
		addNext2	2, 1

		ora	<lineX2+3
		cla
		bne	.line2Jump1

		getLineData	2, 1

		and	#$0F

.line2Jump1:
		ora	<lineDataWork
		tax

		lda	bgDataHigh0, x
		sta	<lineBgData+8

		lda	bgDataHigh1, x
		sta	<lineBgData+9

		lda	bgDataHigh2, x
		sta	<lineBgData+24

		lda	bgDataHigh3, x
		sta	<lineBgData+25

;--------------------------------
;line2_2
;next X
		addNext2	2, 2

		stz	<lineDataWork

		ora	<lineX2+3
		bne	.line2Jump2

		getLineData	2, 2

		and	#$F0
		sta	<lineDataWork

.line2Jump2:

;--------------------------------
;line2_3
;next X
		addNext2	2, 3

		ora	<lineX2+3
		cla
		bne	.line2Jump3

		getLineData	2, 3

		and	#$0F

.line2Jump3:
		ora	<lineDataWork
		tax

		lda	<lineBgData+8
		ora	bgDataLow0, x
		sta	VDC_2
		tay

		lda	<lineBgData+9
		ora	bgDataLow1, x
		sta	VDC_3

		sty	VDC_2
		sta	VDC_3

		lda	<lineBgData+24
		ora	bgDataLow2, x
		sta	<lineBgData+24
		sta	<lineBgData+26

		lda	<lineBgData+25
		ora	bgDataLow3, x
		sta	<lineBgData+25
		sta	<lineBgData+27


;++++++++++++++++++++++++++++++++
;line3_0
;next X
		addNext2	3, 0

		stz	<lineDataWork

		ora	<lineX3+3
		bne	.line3Jump0

		getLineData	3, 0

		and	#$F0
		sta	<lineDataWork

.line3Jump0:

;--------------------------------
;line3_1
;next X
		addNext2	3, 1

		ora	<lineX3+3
		cla
		bne	.line3Jump1

		getLineData	3, 1

		and	#$0F

.line3Jump1:
		ora	<lineDataWork
		tax

		lda	bgDataHigh0, x
		sta	<lineBgData+12

		lda	bgDataHigh1, x
		sta	<lineBgData+13

		lda	bgDataHigh2, x
		sta	<lineBgData+28

		lda	bgDataHigh3, x
		sta	<lineBgData+29

;--------------------------------
;line3_2
;next X
		addNext2	3, 2

		stz	<lineDataWork

		ora	<lineX3+3
		bne	.line3Jump2

		getLineData	3, 2

		and	#$F0
		sta	<lineDataWork

.line3Jump2:

;--------------------------------
;line3_3
;next X
		addNext2	3, 3

		ora	<lineX3+3
		cla
		bne	.line3Jump3

		getLineData	3, 3

		and	#$0F

.line3Jump3:
		ora	<lineDataWork
		tax

		lda	<lineBgData+12
		ora	bgDataLow0, x
		sta	VDC_2
		tay

		lda	<lineBgData+13
		ora	bgDataLow1, x
		sta	VDC_3

		sty	VDC_2
		sta	VDC_3

		lda	<lineBgData+28
		ora	bgDataLow2, x
		tay

		lda	<lineBgData+29
		ora	bgDataLow3, x

;--------------------------------
;put BG
		tia	lineBgData+16, VDC_2, 12
		sty	VDC_2
		sta	VDC_3
		sty	VDC_2
		sta	VDC_3

		cli

;calc next VRAM addr
		add	<lineBgAddr, #16
		bne	.lineBgAddrJump
		inc	<lineBgAddr+1
.lineBgAddrJump:

;loop x
		dec	<lineLoopX
		jne	.loopX

;loop y
		dec	<lineLoopY
		jne	.loopY

;.loopYEnd:
		rts


;////////////////////////////
		.bank	1

		.org	$C000

		.org	$D700
;---------------------
bgDataAddr

		.org	$D800
;---------------------
bgDataLow0

		.org	$D900
;---------------------
bgDataLow1

		.org	$DA00
;---------------------
bgDataLow2

		.org	$DB00
;---------------------
bgDataLow3

		.org	$DC00
;---------------------
bgDataHigh0

		.org	$DD00
;---------------------
bgDataHigh1

		.org	$DE00
;---------------------
bgDataHigh2

		.org	$DF00
;---------------------
bgDataHigh3
