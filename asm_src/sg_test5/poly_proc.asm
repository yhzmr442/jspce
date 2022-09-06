;poly_proc.asm
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

;----------------------------
;vertex
;|v1 v2 v3|

;----------------------------
;matrix
;|a11 a21 a31|
;|a12 a22 a32|
;|a13 a23 a33|

;----------------------------
;memory map
;CPU
;$0000-$1FFF	I/O
;$2000-$3FFF	RAM
;$4000-$5FFF	cg data, sg data, mul data, transform div data, polygon function : switch when using
;$6000-$7FFF
;$8000-$9FFF
;$A000-$BFFF
;$C000-$DFFF	polygon function
;$E000-$FFFF	main

;----------------------------
;VRAM
;$0000-$03FF	BAT
;$0400-$04FF	SAT
;$0500-$0FFF	CG, SG
;$1000-$1FFF	CG
;$2000-$4FFF	BUFFER
;$5000-$7FFF	VRAM CLEAR DATA


;//////////////////////////////////
		.bank	1
		.org	$A000

;----------------------------
setZeroMatrix:
;
		phy

		cla
		cly
.loop0:
		sta	[matrix0], y
		iny
		cpy	#18
		bne	.loop0

		ply
		rts


;----------------------------
setMatrixRotationZ:
;
		phx
		phy

		jsr	setZeroMatrix

		ldy	#(0*3+1)*2
		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1
		sta	[matrix0], y

		ldy	#(1*3+0)*2
		sec
		cla
		sbc	<vertexRotationSin
		sta	[matrix0], y
		iny
		cla
		sbc	<vertexRotationSin+1
		sta	[matrix0], y

		txa
		clc
		adc	#64
		tax
		ldy	#(0*3+0)*2
		lda	sinDataLow, x			;cos
		sta	<vertexRotationCos
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	<vertexRotationCos+1
		sta	[matrix0], y

		ldy	#(1*3+1)*2
		lda	<vertexRotationCos
		sta	[matrix0], y
		iny
		lda	<vertexRotationCos+1
		sta	[matrix0], y

		ldy	#(2*3+2)*2
		cla
		sta	[matrix0], y
		iny
		lda	#$40
		sta	[matrix0], y

		ply
		plx
		rts


;----------------------------
setMatrixRotationY:
;
		phx
		phy

		jsr	setZeroMatrix

		ldy	#(0*3+2)*2
		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1
		sta	[matrix0], y

		ldy	#(2*3+0)*2
		sec
		cla
		sbc	<vertexRotationSin
		sta	[matrix0], y
		iny
		cla
		sbc	<vertexRotationSin+1
		sta	[matrix0], y

		txa
		clc
		adc	#64
		tax
		ldy	#(0*3+0)*2
		lda	sinDataLow, x			;cos
		sta	<vertexRotationCos
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	<vertexRotationCos+1
		sta	[matrix0], y

		ldy	#(2*3+2)*2
		lda	<vertexRotationCos
		sta	[matrix0], y
		iny
		lda	<vertexRotationCos+1
		sta	[matrix0], y

		ldy	#(1*3+1)*2
		cla
		sta	[matrix0], y
		iny
		lda	#$40
		sta	[matrix0], y

		ply
		plx
		rts


;----------------------------
setMatrixRotationX:
;
		phx
		phy

		jsr	setZeroMatrix

		ldy	#(2*3+1)*2
		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1
		sta	[matrix0], y

		ldy	#(1*3+2)*2
		sec
		cla
		sbc	<vertexRotationSin
		sta	[matrix0], y
		iny
		cla
		sbc	<vertexRotationSin+1
		sta	[matrix0], y

		txa
		clc
		adc	#64
		tax
		ldy	#(1*3+1)*2
		lda	sinDataLow, x			;cos
		sta	<vertexRotationCos
		sta	[matrix0], y
		iny
		lda	sinDataHigh, x
		sta	<vertexRotationCos+1
		sta	[matrix0], y

		ldy	#(2*3+2)*2
		lda	<vertexRotationCos
		sta	[matrix0], y
		iny
		lda	<vertexRotationCos+1
		sta	[matrix0], y

		ldy	#(0*3+0)*2
		cla
		sta	[matrix0], y
		iny
		lda	#$40
		sta	[matrix0], y

		ply
		plx
		rts


;----------------------------
vertexMultiply:
;
		phx
		phy

		clx
.loop0:
		phx
		cly

		stzq	<matrixTemp

.loop1:
		lda	[matrix0], y
		sta	<mul16a
		iny
		lda	[matrix0], y
		sta	<mul16a+1
		iny

		sxy

		lda	[matrix1], y
		sta	<mul16b
		iny
		lda	[matrix1], y
		sta	<mul16b+1
		iny

		jsr	smul16

		addq	<matrixTemp, <mul16c, <matrixTemp

		iny
		iny
		iny
		iny

		sxy
		cpy	#6
		bne	.loop1

		plx

		txa
		tay

		lda	<matrixTemp+2
		asl	<matrixTemp+1
		rol	a
		rol	<matrixTemp+3
		asl	<matrixTemp+1
		rol	a
		rol	<matrixTemp+3
		sta	[matrix2], y
		iny
		lda	<matrixTemp+3
		sta	[matrix2], y

		inx
		inx
		cpx	#6
		bne	.loop0

		ply
		plx
		rts


;----------------------------
matrixMultiply:
;
		jsr	vertexMultiply

		addw	<matrix0, #6
		addw	<matrix2, #6
		jsr	vertexMultiply

		addw	<matrix0, #6
		addw	<matrix2, #6
		jsr	vertexMultiply

		subw	<matrix0, #12
		subw	<matrix2, #12

		rts

;----------------------------
initializePolygonFunction:
;
;set tia tii function
		jsr	setTiaTiiFunction

;initialize VDC
		jsr	initializeVdc

;initialize VPC
		jsr	initializeVpc

;initialize SATB
		jsr	initializeSat

;initialize PAD
		jsr	initializePad

;initialize PSG
		jsr	initializePsg

;set BAT
		jsr	setBat

;set VRAM Address for polygon
		lda	#$20
		jsr	setPolygonTopAddress

;clear VRAM buffer
		movw	<argw0, #$5000
		movw	<argw1, #vramClearData
		ldy	#VDC1
		jsr	clearVramBuffer

		ldy	#VDC2
		jsr	clearVramBuffer

;set main volume
		lda	#$EE
		jsr	setMainVolume

;initialize DDA
		jsr	initializeDda

;initialize random
		jsr	initializeRandom

;disable interrupt IRQ2
		lda	#%00000001
		jsr	setInterruptDisable

		rts


;----------------------------
setMainVolume:
;
		sta	PSG_1
		rts


;----------------------------
initializePsg:
;
		stz	PSG_0
		stz	PSG_1
		stz	PSG_8
		stz	PSG_9

		cly
.loop0:
		sty	PSG_0
		stz	PSG_2
		stz	PSG_3
		mov	PSG_4, #$40
		stz	PSG_4
		stz	PSG_5

		clx
.loop1:
		stz	PSG_6
		inx
		cpx	#32
		bne	.loop1

		iny
		cpy	#6
		bne	.loop0

		mov	PSG_0, #4
		stz	PSG_7

		mov	PSG_0, #5
		stz	PSG_7

		rts


;----------------------------
initializeDda:
;use channel No3
		mov	PSG_0, #$03
		mov	PSG_4, #$DF
		mov	PSG_5, #$FF
		stz	PSG_6
		rts


;----------------------------
startDda:
;
		stz	TIMER_CONTROL_REG
		mov	TIMER_CONTROL_REG, #$01
		rts


;----------------------------
stopDda:
;
		stz	TIMER_CONTROL_REG
		rts


;----------------------------
setDda:
;
		bbr7	<dda0Flag, .jp00

		ora	#$00
		bmi	.jp01

		cmp	<dda0No
		beq	.jp02
		bcs	.funcEnd
		bra	.jp02

.jp01:
		and	#$7F
		cmp	<dda0No
		bcs	.funcEnd

.jp00:
		and	#$7F
.jp02:
		sei
		sta	<dda0No
		movw	<dda0Address, #$4000
		smb7	<dda0Flag
		cli

.funcEnd:
		rts


;----------------------------
timerPlayDdaFunction:
;
		phx

		bbr7	<dda0Flag, .funcEnd

;set dda data bank
		tma	#$02
		pha

		lda	<dda0No
		tam	#$02

;get dda data
		lda	[dda0Address]
		bpl	.jp00

		rmb7	<dda0Flag
		and	#$1F

.jp00:
		ldx	#$03
		stx	PSG_0
		sta	PSG_6
		incw	<dda0Address

.jp01:
;restore bank
		pla
		tam	#$02

.funcEnd:
		plx
		rts


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
		phx
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
		ply
		plx
		rts


;----------------------------
udiv32:
;div16a div16b = div16d:div16c / div16a
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
		phy

;save MPR2 data
		tma	#$02
		pha

		lda	<mul16b
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#mulDataBank
		tam	#$02

		lda	<mul16b
		and	#$0F
		asl	a
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
		adc	#mulDataBank
		tam	#$02

		lda	<mul16b+1
		and	#$0F
		asl	a
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
		pla
		tam	#$02

		ply
		rts


;----------------------------
usqrt32:
;mul16c = sqrt(sqr32a)
		phx
		phy

		stzq	<work4a
		stzq	<work4b

		stzw	<mul16c

		ldy	#15

.loop:
		tya
		lsr	a
		lsr	a
		tax

		asl	<sqr32a, x
		rolq	<work4a
		asl	<sqr32a, x
		rolq	<work4a

		aslq	<work4b
		smb0	<work4b

		aslw	<mul16c

		subq	<work4c, <work4a, <work4b
		bcc	.jp00

		movq	<work4a, <work4c

		smb0	<mul16c

		incq	<work4b

		bra	.jp01

.jp00:
		rmb0	<work4b

.jp01:
		dey
		bpl	.loop

		ply
		plx
		rts


;----------------------------
calcDistance:
;mul16c = (angleX0, angleY0, angleZ0)  (angleX1, angleY1, angleZ1)
		subw	<mul16a, <angleX1, <angleX0
		movw	<mul16b, <mul16a
		jsr	smul16
		movq	<work4a, <mul16c

		subw	<mul16a, <angleY1, <angleY0
		movw	<mul16b, <mul16a
		jsr	smul16
		addq	<work4a, <mul16c

		subw	<mul16a, <angleZ1, <angleZ0
		movw	<mul16b, <mul16a
		jsr	smul16
		addq	<sqr32a, <work4a, <mul16c

		jsr	usqrt32

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

		stz	IO_REG

		asl	a
		asl	a
		asl	a
		asl	a
		sta	<padNow

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
		beq	.rotationSelectX

		cmp	#2
		beq	.rotationSelectZ
		bcc	.rotationSelectY
		rts

.rotationSelectZ:
		ldx	<rotationZ
		jsr	vertexRotationZ
		rts

.rotationSelectX:
		ldx	<rotationX
		jsr	vertexRotationX
		rts

.rotationSelectY:
		ldx	<rotationY
		jsr	vertexRotationY
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

		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1

		txa
		clc
		adc	#64
		tax
		lda	sinDataLow, x			;cos
		sta	<vertexRotationCos
		lda	sinDataHigh, x
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
		ady	#6

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

		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1

		txa
		clc
		adc	#64
		tax
		lda	sinDataLow, x			;cos
		sta	<vertexRotationCos
		lda	sinDataHigh, x
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
		ady	#6

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

		lda	sinDataLow, x			;sin
		sta	<vertexRotationSin
		lda	sinDataHigh, x
		sta	<vertexRotationSin+1

		txa
		clc
		adc	#64
		tax
		lda	sinDataLow, x			;cos
		sta	<vertexRotationCos
		lda	sinDataHigh, x
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
		ady	#6

		dex
		jne	.vertexRotationXLoop

.vertexRotationXEnd:
		ply
		plx
		rts


;----------------------------
vertexTranslation:
;
		phx
		phy

		ldx	<vertexCount
		beq	.vertexTranslationEnd

		cly

.vertexTranslationLoop:
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

		ady	#6

		dex
		bne	.vertexTranslationLoop

.vertexTranslationEnd:
		ply
		plx
		rts


;----------------------------
transform2D:
;
		phx
		phy

;save MPR2 data
		tma	#$02
		pha

		ldy	<vertexCount
		clx

.transform2DLoop0:
;Z0 < 128 check
		sec
		lda	transform2DWork0+4, x	;Z0
		sta	transform2DWork1+4, x
		sbc	#SCREEN_Z
		lda	transform2DWork0+5, x
		sta	transform2DWork1+5, x
		sbc	#0

		bpl	.transform2DJump05
		jmp	.transform2DJump00

.transform2DJump05:
;X0 to mul16c
		lda	transform2DWork0, x
		sta	transform2DWork1, x
		sta	<mul16c
		lda	transform2DWork0+1, x
		sta	transform2DWork1+1, x
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4, x
		sta	<mul16a
		lda	transform2DWork0+5, x
		sta	<mul16a+1

;X0*128/Z0
		jsr	transform2DProc

;X0*128/Z0+centerX
;mul16a+centerX to X0
		clc
		lda	<mul16a
		adc	<centerX
		sta	transform2DWork0, x	;X0
		lda	<mul16a+1
		adc	<centerX+1
		sta	transform2DWork0+1, x

;Y0 to mul16c
		lda	transform2DWork0+2, x
		sta	transform2DWork1+2, x
		sta	<mul16c
		lda	transform2DWork0+3, x
		sta	transform2DWork1+3, x
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4, x
		sta	<mul16a
		lda	transform2DWork0+5, x
		sta	<mul16a+1

;Y0*128/Z0
		jsr	transform2DProc

;centerY-Y0*128/Z0
;centerY-mul16a to Y0
		sec
		lda	<centerY
		sbc	<mul16a
		sta	transform2DWork0+2, x	;Y0
		lda	<centerY+1
		sbc	<mul16a+1
		sta	transform2DWork0+3, x

		jmp	.transform2DJump01

.transform2DJump00:
		lda	transform2DWork0, x
		sta	transform2DWork1, x
		lda	transform2DWork0+1, x
		sta	transform2DWork1+1, x

		lda	transform2DWork0+2, x
		sta	transform2DWork1+2, x
		lda	transform2DWork0+3, x
		sta	transform2DWork1+3, x

;Z0<128 flag set
		stz	transform2DWork0+4, x
		lda	#$80
		sta	transform2DWork0+5, x

.transform2DJump01:
		adx	#6

		dey
		jne	.transform2DLoop0

;set MPR2 data
		pla
		tam	#$02

		ply
		plx
		rts


;----------------------------
transform2DProc:
;mul16a(rough value) = (mul16c(-32768_32767) * 128 / mul16a(1_32767))
		phx
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
		adc	#divDataBank
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
		adc	#mulDataBank
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
		adc	#mulDataBank
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
		ply
		plx
		rts


;----------------------------
moveToTransform2DWork0:
;vertex0Addr to Transform2DWork0

		phx
		phy

		ldx	<vertexCount
		beq	.moveToTransform2DWork0End

		cly

.moveToTransform2DWork0Loop:
		lda	[vertex0Addr], y
		sta	transform2DWork0, y
		iny
		lda	[vertex0Addr], y
		sta	transform2DWork0, y
		iny

		lda	[vertex0Addr], y
		sta	transform2DWork0, y
		iny
		lda	[vertex0Addr], y
		sta	transform2DWork0, y
		iny

		lda	[vertex0Addr], y
		sta	transform2DWork0, y
		iny
		lda	[vertex0Addr], y
		sta	transform2DWork0, y
		iny

		dex
		bne	.moveToTransform2DWork0Loop

.moveToTransform2DWork0End:
		ply
		plx
		rts


;----------------------------
setPolygonColorIndex:
;
		sta	<polygonColorIndex
		rts


;----------------------------
putPolygonBuffer:
;
		phx
		phy

;save MPR2 data
		tma	#polygonSubFunctionMap
		pha

;set polygon procedure bank
		lda	#polygonSubFunctionBank
		tam	#polygonSubFunctionMap

;+32 vsync
		st012	#$05, #$0808

		movw	<polyBufferAddr, polyBufferStart

.putPolyBufferLoop0:
		ldy	#4
		lda	[polyBufferAddr], y	;COLOR

		clc
		adc	<polygonColorIndex

		tax
		lda	polygonColorP0, x
		sta	polyLineColorWork_H_P0
		sta	polyLineColorWork_L_P0
		rol	a
		rol	polyLineColorWork_L_P0

		lda	polygonColorP1, x
		sta	polyLineColorWork_H_P1
		sta	polyLineColorWork_L_P1
		rol	a
		rol	polyLineColorWork_L_P1

		lda	polygonColorP2, x
		sta	polyLineColorWork_H_P2
		sta	polyLineColorWork_L_P2
		rol	a
		rol	polyLineColorWork_L_P2

		lda	polygonColorP3, x
		sta	polyLineColorWork_H_P3
		sta	polyLineColorWork_L_P3
		rol	a
		rol	polyLineColorWork_L_P3

		ldy	#5
		lda	[polyBufferAddr], y	;COUNT
		beq	.putPolyBufferEnd

		sta	<polyAttribute
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

		jsr	calcCircle_putPoly
		bra	.nextData

.polygonProc:
		and	#$0F
		sta	<clip2D0Count
		pha

;check Y coordinate
		stz	<yCheckFlag
		ldy	#7
		lda	[polyBufferAddr], y
		sta	<yCheckWork

		clx
		dey

.putPolyBufferLoop1:
		lda	[polyBufferAddr], y
		sta	clip2D0, x
		inx
		inx
		iny

		lda	[polyBufferAddr], y
		sta	clip2D0, x
		inx
		inx
		iny

		cmp	<yCheckWork
		beq	.jp01
		smb7	<yCheckFlag
.jp01:

		dec	<clip2D0Count
		bne	.putPolyBufferLoop1

		pla

		bbr7	<yCheckFlag, .nextData

		sta	<clip2D0Count
		jsr	calcEdge_putPoly

.nextData:
		cly
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
		pla
		tam	#$02

		ply
		plx
		rts


;----------------------------
setModelRotation:
;
		phx
		phy
;rotation
		ldy	#$03
		lda	[modelAddress], y		;vertex data address
		sta	<vertex0Addr
		iny
		lda	[modelAddress], y
		sta	<vertex0Addr+1

		iny
		lda	[modelAddress], y		;vertex count
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

		jsr	vertexTranslation

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

		jsr	setModel

		ply
		plx
		rts


;----------------------------
setModel:
;
;transform2D
		phx
		phy

		jsr	transform2D

		cly
		lda	[modelAddress], y
		sta	<modelAddrWork		;ModelData Polygon Addr
		iny
		lda	[modelAddress], y
		sta	<modelAddrWork+1

		iny
		lda	[modelAddress], y	;Polygon Count
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
		lda	<setModelAttr
		and	#%11000000
		sta	[polyBufferAddr], y	;COUNT

		dey
		lda	<setModelFrontColor
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

		stz	<backCheckFlag

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
		tii	clip2D0, backCheckWork, 3*4
		jsr	clip2D
		jeq	.setModelJump0

;back side check
		stz	<backCheckFlag
		subw	<mul16a, backCheckWork+8, backCheckWork+4	;X2-X1
		subw	<mul16b, backCheckWork+2, backCheckWork+6	;Y0-Y1
		jsr	smul16
		movq	<work8a, <mul16c

		subw	<mul16a, backCheckWork+10, backCheckWork+6	;Y2-Y1
		subw	<mul16b, backCheckWork, backCheckWork+4		;X0-X1
		jsr	smul16

		subq	<work8a, <mul16c
		bmi	.setModelJump2

		lda	<work8a
		ora	<work8a+1
		ora	<work8a+2
		ora	<work8a+3
		jeq	.setModelJump0

;back side
		smb0	<backCheckFlag
		bbr0	<setModelAttr, .setModelJump6
		jmp	.setModelJump0

.setModelJump6:
		lda	<setModelBackColor
		bra	.setModelJump10

.setModelJump2:
;front side
		lda	<setModelFrontColor

.setModelJump10:
		ldy	#4
		sta	[polyBufferAddr], y	;COLOR

		lda	<setModelAttr
		and	#%11000000
		ora	<clip2D0Count
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
		cly				;NEXT ADDR
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
		cly				;BUFFER -> NEXT
		lda	<polyBufferNext
		sta	[polyBufferAddr], y
		iny
		lda	<polyBufferNext+1
		sta	[polyBufferAddr], y

		cly				;NOW -> BUFFER
		lda	<polyBufferAddr
		sta	[polyBufferNow], y
		iny
		lda	<polyBufferAddr+1
		sta	[polyBufferNow], y

;set data
		bbs0	<backCheckFlag, .setModelJump11

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

		bra	.setModelJump12

.setModelJump11:
		lda	<clip2D0Count
		dec	a
		asl	a
		asl	a
		tax
		ldy	#6
.setModelLoop6:
		lda	clip2D0, x
		sta	[polyBufferAddr], y
		inx
		inx
		iny

		lda	clip2D0, x
		sta	[polyBufferAddr], y
		sbx	#6
		iny

		dec	<clip2D0Count
		bne	.setModelLoop6

.setModelJump12:
;next buffer address
		clc
		tya
		adc	<polyBufferAddr
		sta	<polyBufferAddr
		bcc	.setModelJump0
		inc	<polyBufferAddr+1

.setModelJump0:
		pla
		add	#8
		tay

		dec	<modelPolygonCount
		jne	.setModelLoop3

		ply
		plx
		rts


;----------------------------
clipFront:
;
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
		lda	#SCREEN_Z
		sbc	transform2DWork1+4, x
		sta	<mul16a
		cla
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
		lda	#SCREEN_Z
		sbc	transform2DWork1+4, x
		sta	<mul16a
		cla
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

		lda	#SCREEN_Z
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

		inx
		inx
		inx
		inx

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
		lda	clip2D1, y	;X0
		sbc	#$00
		lda	clip2D1+1, y
		sbc	#$01
		bmi	.clip2DX255Jump00
		smb0	<clip2DFlag
.clip2DX255Jump00:

		sec
		lda	clip2D1+4, y	;X1
		sbc	#$00
		lda	clip2D1+5, y
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
		sbc	clip2D1, y	;X0
		sta	<mul16a
		cla
		sbc	clip2D1+1, y
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D1+6, y	;Y1
		sbc	clip2D1+2, y	;Y0
		sta	<mul16b
		lda	clip2D1+7, y
		sbc	clip2D1+3, y
		sta	<mul16b+1

;(255-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D1+4, y	;X1
		sbc	clip2D1, y	;X0
		sta	<mul16a
		lda	clip2D1+5, y
		sbc	clip2D1+1, y
		sta	<mul16a+1

;(255-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(255-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D1+2, y	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+3, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DX255Jump04
;X0>255 X1<=255
		lda	#$FF
		sta	clip2D0, x	;X0
		stz	clip2D0+1, x

		lda	<mul16a
		sta	clip2D0+2, x	;Y0
		lda	<mul16a+1
		sta	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

		bra	.clip2DX255Jump03

.clip2DX255Jump04:
;X0<=255 X1>255
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		lda	#$FF
		sta	clip2D0+4, x	;X1
		stz	clip2D0+5, x

		lda	<mul16a
		sta	clip2D0+6, x	;Y1
		lda	<mul16a+1
		sta	clip2D0+7, x

		add	<clip2D0Count, #$02

		adx	#8

		bra	.clip2DX255Jump03

.clip2DX255Jump02:
;X0<=255 X1<=255
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

.clip2DX255Jump03:
;X0>255 X1>255
		iny
		iny
		iny
		iny

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

		lda	clip2D0+1, y	;X0
		bpl	.clip2DX0Jump00
		smb0	<clip2DFlag
.clip2DX0Jump00:

		lda	clip2D0+5, y	;X1
		bpl	.clip2DX0Jump01
		smb1	<clip2DFlag
.clip2DX0Jump01:

		lda	<clip2DFlag
		jeq	.clip2DX0Jump02

		cmp	#$03
		jeq	.clip2DX0Jump03

;(0-X0) to mul16a
		sec
		cla
		sbc	clip2D0, y	;X0
		sta	<mul16a
		cla
		sbc	clip2D0+1, y
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D0+6, y	;Y1
		sbc	clip2D0+2, y	;Y0
		sta	<mul16b
		lda	clip2D0+7, y
		sbc	clip2D0+3, y
		sta	<mul16b+1

;(0-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D0+4, y	;X1
		sbc	clip2D0, y	;X0
		sta	<mul16a
		lda	clip2D0+5, y
		sbc	clip2D0+1, y
		sta	<mul16a+1

;(0-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(0-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D0+2, y	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+3, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DX0Jump04
;X0<0 X1>=0
		stz	clip2D1, x	;X0
		stz	clip2D1+1, x

		lda	<mul16a
		sta	clip2D1+2, x	;Y0
		lda	<mul16a+1
		sta	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

		bra	.clip2DX0Jump03

.clip2DX0Jump04:
;X0>=0 X1<0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		stz	clip2D1+4, x	;X1
		stz	clip2D1+5, x

		lda	<mul16a
		sta	clip2D1+6, x	;Y1
		lda	<mul16a+1
		sta	clip2D1+7, x

		add	<clip2D1Count, #$02

		adx	#8

		bra	.clip2DX0Jump03

.clip2DX0Jump02:
;X0>=0 X1>=0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

.clip2DX0Jump03:
;X0<0 X1<0
		iny
		iny
		iny
		iny

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
		lda	clip2D1+2, y	;Y0
		sbc	#192
		lda	clip2D1+3, y
		sbc	#0
		bmi	.clip2DY255Jump00
		smb0	<clip2DFlag
.clip2DY255Jump00:

		sec
		lda	clip2D1+6, y	;Y1
		sbc	#192
		lda	clip2D1+7, y
		sbc	#0
		bmi	.clip2DY255Jump01
		smb1	<clip2DFlag
.clip2DY255Jump01:

		lda	<clip2DFlag
		jeq	.clip2DY255Jump02

		cmp	#$03
		jeq	.clip2DY255Jump03

;(191-Y0) to mul16a
		sec
		lda	#191
		sbc	clip2D1+2, y	;Y0
		sta	<mul16a
		cla
		sbc	clip2D1+3, y
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D1+4, y	;X1
		sbc	clip2D1, y	;X0
		sta	<mul16b
		lda	clip2D1+5, y
		sbc	clip2D1+1, y
		sta	<mul16b+1

;(191-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D1+6, y	;Y1
		sbc	clip2D1+2, y	;Y0
		sta	<mul16a
		lda	clip2D1+7, y
		sbc	clip2D1+3, y
		sta	<mul16a+1

;(191-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(191-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D1, y	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+1, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DY255Jump04
;Y0>191 Y1<=191
		lda	<mul16a
		sta	clip2D0, x	;X0
		lda	<mul16a+1
		sta	clip2D0+1, x

		lda	#191
		sta	clip2D0+2, x	;Y0
		stz	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

		bra	.clip2DY255Jump03

.clip2DY255Jump04:
;Y0<=191 Y1>191
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		lda	<mul16a
		sta	clip2D0+4, x	;X1
		lda	<mul16a+1
		sta	clip2D0+5, x

		lda	#191
		sta	clip2D0+6, x	;Y1
		stz	clip2D0+7, x

		add	<clip2D0Count, #$02

		adx	#8

		bra	.clip2DY255Jump03

.clip2DY255Jump02:
;Y0<=191 Y1<=191
		lda	clip2D1, y	;X0
		sta	clip2D0, x	;X0
		lda	clip2D1+1, y
		sta	clip2D0+1, x

		lda	clip2D1+2, y	;Y0
		sta	clip2D0+2, x	;Y0
		lda	clip2D1+3, y
		sta	clip2D0+3, x

		inc	<clip2D0Count

		inx
		inx
		inx
		inx

.clip2DY255Jump03:
;Y0>191 Y1>191
		iny
		iny
		iny
		iny

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

		lda	clip2D0+3, y	;Y0
		bpl	.clip2DY0Jump00
		smb0	<clip2DFlag
.clip2DY0Jump00:

		lda	clip2D0+7, y	;Y1
		bpl	.clip2DY0Jump01
		smb1	<clip2DFlag
.clip2DY0Jump01:

		lda	<clip2DFlag
		jeq	.clip2DY0Jump02

		cmp	#$03
		jeq	.clip2DY0Jump03

;(0-Y0) to mul16a
		sec
		cla
		sbc	clip2D0+2, y	;Y0
		sta	<mul16a
		cla
		sbc	clip2D0+3, y
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D0+4, y	;X1
		sbc	clip2D0, y	;X0
		sta	<mul16b
		lda	clip2D0+5, y
		sbc	clip2D0+1, y
		sta	<mul16b+1

;(0-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D0+6, y	;Y1
		sbc	clip2D0+2, y	;Y0
		sta	<mul16a
		lda	clip2D0+7, y
		sbc	clip2D0+3, y
		sta	<mul16a+1

;(0-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(0-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D0, y	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+1, y
		sta	<mul16a+1

		bbs1	<clip2DFlag, .clip2DY0Jump04
;Y0<0 Y1>=0
		lda	<mul16a
		sta	clip2D1, x	;X0
		lda	<mul16a+1
		sta	clip2D1+1, x

		stz	clip2D1+2, x	;Y0
		stz	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

		bra	.clip2DY0Jump03

.clip2DY0Jump04:
;Y0>=0 Y1<0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		lda	<mul16a
		sta	clip2D1+4, x	;X1
		lda	<mul16a+1
		sta	clip2D1+5, x

		stz	clip2D1+6, x	;Y1
		stz	clip2D1+7, x

		add	<clip2D1Count, #$02

		adx	#8

		bra	.clip2DY0Jump03

.clip2DY0Jump02:
;Y0>=0 Y1>=0
		lda	clip2D0, y	;X0
		sta	clip2D1, x	;X0
		lda	clip2D0+1, y
		sta	clip2D1+1, x

		lda	clip2D0+2, y	;Y0
		sta	clip2D1+2, x	;Y0
		lda	clip2D0+3, y
		sta	clip2D1+3, x

		inc	<clip2D1Count

		inx
		inx
		inx
		inx

.clip2DY0Jump03:
;Y0<0 Y1<0
		iny
		iny
		iny
		iny

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
clearVramBuffer:
;clear Vram Buffer
;argw0:vram address, argw1:clear data, y:VDC No
		phx
		phy

		movw	tiaSrc, <argw1
		movw	tiaCnt, #32

		cpy	#VDC1
		bne	.VDC2

		stz	VDC1_0
		movw	VDC1_2, <argw0
		mov	VDC1_0, #$02

		movw	tiaDst, #VDC1_2

		bra	.loop

.VDC2:
		stz	VDC2_0
		movw	VDC2_2, <argw0
		mov	VDC2_0, #$02

		movw	tiaDst, #VDC2_2

.loop:
		ldy	#3
.vramClearLoop0:
		clx
.vramClearLoop1:
		jsr	tiaFunction
		inx
		bne	.vramClearLoop1
		dey
		bne	.vramClearLoop0

		ply
		plx
		rts


;----------------------------
setCgCharData:
;arg0: bank No, arg1: CG No, arg2: VDC No, arg3: count, argw2: VRAM Address
;arg1: CG No to argw2: CG No
		phx
		phy

;set CG data bank
		tma	#$02
		pha

		lda	<arg0
		tam	#$02

;CG address
		stz	tiaSrc
		lda	<arg1
		lsr	a
		ror	tiaSrc
		lsr	a
		ror	tiaSrc
		lsr	a
		ror	tiaSrc
		sta	tiaSrc+1

		addw	tiaSrc, #$4000

;Byte count
		stz	tiaCnt
		lda	<arg3
		lsr	a
		ror	tiaCnt
		lsr	a
		ror	tiaCnt
		lsr	a
		ror	tiaCnt
		sta	tiaCnt+1

		addw	tiaCnt, #32

;VDC1 or VDC2
		lda	<arg2
		cmp	#VDC1
		bne	.VDC2

;VDC1
		stz	VDC1_0
		movw	VDC1_2, <argw2
		mov	VDC1_0, #$02
		movw	tiaDst, #VDC1_2

		jsr	tiaFunction
		bra	.funcEnd
.VDC2:
		stz	VDC2_0
		movw	VDC2_2, <argw2
		mov	VDC2_0, #$02
		movw	tiaDst, #VDC2_2

		jsr	tiaFunction

.funcEnd:
;restore bank
		pla
		tam	#$02

		ply
		plx
		rts


;----------------------------
setSgCharData:
;arg0: bank No, arg1: SP No, arg2: VDC No, arg3: count, argw2: VRAM Address
;arg1: SG No to argw2: SG No
		phx
		phy

;set SG data bank
		tma	#$02
		pha

		lda	<arg0
		tam	#$02

;SG address
		stz	tiaSrc
		lda	<arg1
		lsr	a
		ror	tiaSrc
		lsr	a
		ror	tiaSrc
		sta	tiaSrc+1

		addw	tiaSrc, #$4000

;Byte count
		stz	tiaCnt
		lda	<arg3
		lsr	a
		ror	tiaCnt
		lsr	a
		ror	tiaCnt
		sta	tiaCnt+1

		addw	tiaCnt, #64

;VDC1 or VDC2
		lda	<arg2
		cmp	#VDC1
		bne	.VDC2

;VDC1
		stz	VDC1_0
		movw	VDC1_2, <argw2
		mov	VDC1_0, #$02
		movw	tiaDst, #VDC1_2

		jsr	tiaFunction
		bra	.funcEnd
.VDC2:
		stz	VDC2_0
		movw	VDC2_2, <argw2
		mov	VDC2_0, #$02
		movw	tiaDst, #VDC2_2

		jsr	tiaFunction

.funcEnd:
;restore bank
		pla
		tam	#$02

		ply
		plx
		rts


;----------------------------
setTiaTiiFunction:
;
		mov	tiaFunction, #$E3
		mov	tiaRts, #$60
		mov	tiiFunction, #$73
		mov	tiiRts, #$60
		rts


;----------------------------
setAllPolygonColor:
;set all polygon color
;argw0:color data
		movw	tiiSrc, <argw0
		movw	tiiDst, #polygonColorP0
		movw	tiiCnt, #64*4
		jsr	tiiFunction

		rts


;----------------------------
setAllPalette:
;set all palette
;argw0:palette data
		stzw	VCE_2

		movw	tiaSrc, <argw0
		movw	tiaDst, #VCE_4
		movw	tiaCnt, #$20*32
		jsr	tiaFunction

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
		stz	VDC1_0
		stzw	VDC1_2
		mov	VDC1_0, #$02

		stz	VDC2_0
		stzw	VDC2_2
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
setInterruptDisable:
;
		sta	INTERRUPT_DISABLE_REG
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
		st012	#$11, #$2000		;set DMA dest
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
		st012	#$11, #$2000		;set DMA dest
		st012	#$12, #$3000		;set DMA count

;change selectVdc
		mov	<selectVdc, #VDC1

.vsyncProcEnd:
		rts


;----------------------------
clearSatBuffer:
;don't block interruptions.
		clx
.loop0:
		stz	satBuffer, x
		stz	satBuffer+1, x
		stz	satBuffer+2, x
		stz	satBuffer+3, x
		stz	satBuffer+4, x
		stz	satBuffer+5, x
		stz	satBuffer+6, x
		stz	satBuffer+7, x

		stz	satBuffer+256, x
		stz	satBuffer+256+1, x
		stz	satBuffer+256+2, x
		stz	satBuffer+256+3, x
		stz	satBuffer+256+4, x
		stz	satBuffer+256+5, x
		stz	satBuffer+256+6, x
		stz	satBuffer+256+7, x

		adx	#8
		bne	.loop0

		movw	satBufferAddr, #satBuffer

		rts


;----------------------------
setSatBuffer:
;
;argw0:Y, argw1:X, argw2:address, argw3:attribute
		phy

		cmpw2	<satBufferAddr, #satBuffer+512
		bcs	.setEnd

		cly
.loop:
		lda	argw0, y
		sta	[satBufferAddr], y

		iny
		cpy	#8
		bne	.loop

		addwb	<satBufferAddr, #8

.setEnd:
		ply
		rts


;----------------------------
initializeSat:
;initialize SAT
		stz	VDC1_0
		movw	VDC1_2, #$1000
		mov	VDC1_0, #$02

		stz	VDC2_0
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
setPolygonTopAddress:
;
		sta	<polygonTopAddress
		rts


;----------------------------
setScreenCenter:
;
		stx	<centerX
		sty	<centerY
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
initializeScreenVsync:
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
		tia	satBuffer, VDC1_2, 512

;set VRAM_SATB DMA
		st012	#$13, #$0400

		bra	.satbDmaEnd

.vdc2SatbDma:
;VDC2
;set vram addr
		st012	#$00, #$0400

;transfer satb to VRAM
		st0	#$02
		tia	satBuffer, VDC2_2, 512

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
initializeRandom:
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
setCgToSgStringData:
;arg2: top or bottom left or right, arg3: VDC No, argw2: SG No, argw3: stiring address
		phx
		phy

;set CG data bank
		lda	<arg2
		and	#$02
		sta	<temp4

		lda	<arg2
		and	#$01
		sta	<temp5

		mov	<arg0, #charDataBank

		cly

.loop00:
		lda	[argw3], y
		beq	.funcEnd
		sta	<arg1

		lda	<temp4
		ora	<temp5
		sta	<arg2

		jsr	setCgToSgData

		lda	<temp5
		inc	a
		and	#$01
		sta	<temp5
		bne	.jp00

		addw	<argw2, #2

.jp00:
		iny
		bra	.loop00

.funcEnd:
		ply
		plx
		rts


;----------------------------
setCgToSgData:
;arg0: bank No, arg1: CG No, arg2: top or bottom left or right, arg3: VDC No, argw2: SG No
		phx
		phy

;set CG data bank
		tma	#$02
		pha

		lda	<arg0
		tam	#$02

;CG address
		lda	<arg1
		stz	<tempw0
		lsr	a
		ror	<tempw0
		lsr	a
		ror	<tempw0
		lsr	a
		ror	<tempw0
		sta	<tempw0+1

		addw	<tempw0, #$4000

;SG address
		mov	<tempw1+1, <argw2+1

		lda	<argw2
		asl	a
		rol	<tempw1+1
		asl	a
		rol	<tempw1+1
		asl	a
		rol	<tempw1+1
		asl	a
		rol	<tempw1+1
		asl	a
		rol	<tempw1+1
		sta	<tempw1

;top or bottom
		bbr1	<arg2, .jp00
		addw	<tempw1, #8

.jp00:
;VDC1 or VDC2
		lda	<arg3
		cmp	#VDC1
		bne	.VDC2

;VDC1
		cly

.loop00:
		stz	VDC1_0
		movw	VDC1_2, <tempw1

		mov	VDC1_0, #$01
		movw	VDC1_2, <tempw1

		mov	VDC1_0, #$02

.loop01:
;left or right
		bbs0	<arg2, .jp01

;left
		ldx	VDC1_2
		lda	VDC1_3

		lda	[tempw0], y
		stx	VDC1_2
		sta	VDC1_3

		bra	.jp02

.jp01:
;right
		lda	VDC1_2
		ldx	VDC1_3

		lda	[tempw0], y
		sta	VDC1_2
		stx	VDC1_3

.jp02:
		iny
		iny
		cpy	#33
		jeq	.funcEnd

		cpy	#16
		bne	.jp05
		ldy	#1
		bra	.jp07

.jp05:
		cpy	#17
		bne	.jp06
		ldy	#16
		bra	.jp07

.jp06:
		cpy	#32
		bne	.loop01
		ldy	#17

.jp07:
		addw	<tempw1, #16
		bra	.loop00

.VDC2:
		cly

.loop02:
		stz	VDC2_0
		movw	VDC2_2, <tempw1

		mov	VDC2_0, #$01
		movw	VDC2_2, <tempw1

		mov	VDC2_0, #$02

.loop03:
;left or right
		bbs0	<arg2, .jp03

;left
		ldx	VDC2_2
		lda	VDC2_3

		lda	[tempw0], y
		stx	VDC2_2
		sta	VDC2_3

		bra	.jp04

.jp03:
;right
		lda	VDC2_2
		ldx	VDC2_3

		lda	[tempw0], y
		sta	VDC2_2
		stx	VDC2_3

.jp04:
		iny
		iny
		cpy	#33
		jeq	.funcEnd

		cpy	#16
		bne	.jp08
		ldy	#1
		bra	.jp10

.jp08:
		cpy	#17
		bne	.jp09
		ldy	#16
		bra	.jp10

.jp09:
		cpy	#32
		bne	.loop03
		ldy	#17

.jp10:
		addw	<tempw1, #16
		bra	.loop02

.funcEnd:
;restore bank
		pla
		tam	#$02

		ply
		plx
		rts


;----------------------------
calcBatAddressXY:
;x:X, y:Y
		stx	<tempw0
		sty	<tempw0+1

		cla
		lsr	<tempw0+1
		ror	a
		lsr	<tempw0+1
		ror	a
		lsr	<tempw0+1
		ror	a
		ora	<tempw0
		tay

		ldx	<tempw0+1

		rts


;----------------------------
setWriteVramAddress:
;a:VDC No, x:y:VramAddress

		cmp	#VDC2
		beq 	.vdc_2

		stz	VDC1_0
		sty	VDC1_2
		stx	VDC1_3

		rts

.vdc_2:
		stz	VDC2_0
		sty	VDC2_2
		stx	VDC2_3

		rts


;----------------------------
setVramData:
;x:a: Data, y:VDC No
		cpy	#VDC2
		beq 	.vdc_2

		pha
		mov	VDC1_0, #$02
		pla
		sta	VDC1_2
		stx	VDC1_3

		rts

.vdc_2:
		pha
		mov	VDC2_0, #$02
		pla
		sta	VDC2_2
		stx	VDC2_3

		rts


;----------------------------
putChar:
;a:CG No, x:palette, y:VDC No
		phx

		pha

		txa
		asl	a
		asl	a
		asl	a
		asl	a
		inc	a
		tax

		pla

		jsr	setVramData

		plx
		rts


;----------------------------
putString:
;argw0:String Address, arg2:palette, arg3:VDC No
		phx
		phy

		lda	<arg2
		asl	a
		asl	a
		asl	a
		asl	a
		inc	a
		tax

		cly

.loop0:		lda	[argw0], y
		beq	.procEnd

		phy
		ldy	<arg3
		jsr	setVramData
		ply

		iny

		bra	.loop0

.procEnd:
		ply
		plx
		rts


;----------------------------
putHex:
;a:Data, x:palette, y:VDC No

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

		jsr	putChar

		rts


;----------------------------
vdcData:
		.db	$05, $00, $00	;+1 bgoff spoff
		.db	$0A, $02, $02	;HSW $02 HDS $02
		.db	$0B, $1F, $03	;HDW $1F HDE $03
		.db	$0C, $02, $0F	;VSW $02 VDS $0F
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $03, $00	;VCR $0003
		.db	$0F, $00, $00	;DMA +1 +1
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $00, $00	;32x32
		.db	$FF		;end


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
;tan(a) * 512
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $04, $04, $04,\
			$05, $05, $05, $06, $06, $07, $08, $09, $0A, $0C, $0E, $12, $17, $20, $36, $A2


;----------------------------
atanDataLow:
;tan(a) * 512
		.db	$06, $13, $1F, $2C, $39, $46, $52, $5F, $6C, $7A, $87, $94, $A2, $B0, $BE, $CD,\
			$DB, $EB, $FA, $0A, $1A, $2A, $3B, $4D, $5F, $72, $86, $9A, $AF, $C5, $DC, $F4,\
			$0D, $27, $43, $60, $80, $A1, $C4, $EA, $13, $3F, $6E, $A2, $DB, $19, $5E, $AA,\
			$00, $61, $D0, $50, $E6, $97, $6C, $72, $BE, $6E, $BA, $09, $3A, $8E, $4D, $F7


;////////////////////////////
		.bank	2
		.org	$4000

;----------------------------
calcEdge_putPoly:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		sta	<calcEdgeLastAddr
		tax
		lda	clip2D0
		sta	clip2D0, x
		lda	clip2D0+2
		sta	clip2D0+2, x

		cly
		ldx	#$04
.minLoop:
		lda	clip2D0+2, y
		cmp	clip2D0+2, x
		bcc	.minJp

		txa
		tay
.minJp:
		inx
		inx
		inx
		inx
		cpx	<calcEdgeLastAddr
		bne	.minLoop

		mov	<minEdgeY, #$FF
		stz	<maxEdgeY

		sxy

.calcEdge_putPolyLoop0:
		lda	clip2D0, x
		sta	<edgeX0
		lda	clip2D0+2, x
		sta	<edgeY0

		cmp	<minEdgeY
		jcs	.calcEdge_putPolyJump2
		sta	<minEdgeY

.calcEdge_putPolyJump2:
		cmp	<maxEdgeY
		jcc	.calcEdge_putPolyJump6
		sta	<maxEdgeY

.calcEdge_putPolyJump6:
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
		beq	.loopEnd

		cpx	<calcEdgeLastAddr
		bne	.calcEdge_putPolyLoop0
		clx
		bra	.calcEdge_putPolyLoop0
.loopEnd:

		jsr	putPolyLine

		rts


;----------------------------
calcCircle_putPoly:
;
;top < 192
		sec
		lda	<circleCenterY
		sbc	<circleRadius
		sta	<minEdgeY
		lda	<circleCenterY+1
		sbc	<circleRadius+1

		bmi	.jp11
		beq	.jp10
		rts

.jp10:
		lda	<minEdgeY
		cmp	#192
		jcc	.jp11
		rts

.jp11:
;bottom >= 0
		clc
		lda	<circleCenterY
		adc	<circleRadius
		lda	<circleCenterY+1
		adc	<circleRadius+1

		bpl	.jp12
		rts

.jp12:
;left < 256
		sec
		lda	<circleCenterX
		sbc	<circleRadius
		lda	<circleCenterX+1
		sbc	<circleRadius+1

		bmi	.jp13
		beq	.jp13
		rts

.jp13:
;right >= 0
		clc
		lda	<circleCenterX
		adc	<circleRadius
		lda	<circleCenterX+1
		adc	<circleRadius+1

		bpl	.jp14
		rts

.jp14:
		mov	<minEdgeY, #$FF
		stz	<maxEdgeY

		subw	<circleD, #1, <circleRadius

		movw	<circleDH, #3

		movw	<circleDD, <circleRadius
		asl	<circleDD
		rol	<circleDD+1

		subw	<circleDD, #5, <circleDD

		movw	<circleX, <circleRadius

		stzw	<circleY

		addw	<circleXRight0, <circleCenterX, <circleX
		subw	<circleXLeft0, <circleCenterX, <circleX

		movw	<circleXRight1, <circleCenterX
		movw	<circleXLeft1, <circleCenterX

.loop0:
		sec
		lda	<circleX
		sbc	<circleY
		lda	<circleX+1
		sbc	<circleY+1
		bpl	.jp00

		lda	<minEdgeY
		cmp	#$FF
		beq	.jp03
		jsr	putPolyLine
.jp03:
		rts

.jp00:
		bbr7	<circleD+1, .jp01

		addw	<circleD, <circleDH

		addwb	<circleDH, #2

		addwb	<circleDD, #2

		bra	.jp02

.jp01:
		addw	<circleD, <circleDD

		addwb	<circleDH, #2

		addwb	<circleDD, #4

		decw	<circleX

		decw	<circleXRight0
		incw	<circleXLeft0

.jp02:
		lda	<circleXLeft0
		sta	<circleXLeftWork

		lda	<circleXLeft0+1
		beq	.jp20
		bpl	.jp04

		stz	<circleXLeftWork

.jp20:
		lda	<circleXRight0
		sta	<circleXRightWork

		lda	<circleXRight0+1
		bmi	.jp04
		beq	.jp21

		mov	<circleXRightWork, #$FF

.jp21:
		addw	<circleYWork, <circleCenterY, <circleY
		jsr	setCircleEdge0

		subw	<circleYWork, <circleCenterY, <circleY
		jsr	setCircleEdge0

.jp04:
		lda	<circleXLeft1
		sta	<circleXLeftWork

		lda	<circleXLeft1+1
		beq	.jp22
		bpl	.jp05

		stz	<circleXLeftWork

.jp22:
		lda	<circleXRight1
		sta	<circleXRightWork

		lda	<circleXRight1+1
		bmi	.jp05
		beq	.jp23

		mov	<circleXRightWork, #$FF

.jp23:
		addw	<circleYWork, <circleCenterY, <circleX
		jsr	setCircleEdge1

		subw	<circleYWork, <circleCenterY, <circleX
		jsr	setCircleEdge1

.jp05:
		incw	<circleY

		incw	<circleXRight1
		decw	<circleXLeft1

		jmp	.loop0


;----------------------------
setCircleEdge0:
;
		lda	<circleYWork+1
		bne	.endSet

		ldy	<circleYWork
		cpy	#192
		bcs	.endSet

		cpy	<minEdgeY
		jcs	.jp02

		sty	<minEdgeY

.jp02:
		cpy	<maxEdgeY
		jcc	.jp03

		sty	<maxEdgeY

.jp03:
		lda	<circleXLeftWork
		sta	edgeLeft, y

		lda	<circleXRightWork
		sta	edgeRight, y

.endSet:
		rts


;----------------------------
setCircleEdge1:
;
		lda	<circleYWork+1
		bne	.endSet

		ldy	<circleYWork
		cpy	#192
		bcs	.endSet

		cpy	<minEdgeY
		jcs	.jp02

		sty	<minEdgeY

.jp02:
		cpy	<maxEdgeY
		jcc	.jp03

		sty	<maxEdgeY

.jp03:
		lda	<circleXLeftWork
		sta	edgeLeft, y

		lda	<circleXRightWork
		sta	edgeRight, y

.endSet:
		rts


;----------------------------
calcEdge:
;
		lda	<edgeY1
		cmp	<edgeY0
		jcc	.jp00

;calculation left edge
;calculation edge Y
		sec
		lda	<edgeY1
		sbc	<edgeY0
		beq	.edgeJump6L

		sta	<edgeSlopeY
		jcs	.edgeJump7L

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

		jmp	.edgeJump7L

.edgeJump6L:
;edgeY0 = edgeY1
		rts

.edgeJump7L:
;calculation edge X
		sec
		lda	<edgeX1
		sbc	<edgeX0
		beq	.edgeJump1L

		sta	<edgeSlopeX
		stz	<edgeSigneX
		bcs	.edgeJump3L

		eor	#$FF
		inc	a
		sta	<edgeSlopeX

		mov	<edgeSigneX, #$FF

		bra	.edgeJump3L

.edgeJump1L:
;edgeX0 = edgeX1
		lda	<edgeY1
		eor	<edgeY0
		lsr	a

		lda	<edgeX0
		ldx	<edgeY0

		bcc	.edgeLoop0_1L

.edgeLoop0_0L:
		sta	edgeLeft, x
		inx

.edgeLoop0_1L:
		sta	edgeLeft, x

		cpx	<edgeY1
		beq	.edgeJump9L
		inx
		bra	.edgeLoop0_0L

.edgeJump9L:
		rts

.edgeJump3L:
;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		jcs	.edgeJump4L

;edgeSlopeX > edgeSlopeY
;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10L

;edgeSigneX plus
		lda	<edgeX1
		eor	<edgeX0
		lsr	a

;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldy	<edgeX0
		ldx	<edgeY0

		bcc	.edgeXLoop0_1L

.edgeXLoop0_0L:
		say
		sta	edgeLeft, x
		say

.edgeXLoop1_0L:
		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop1_1L

		sbc	<edgeSlopeX
		inx

.edgeXLoop0_1L:
		say
		sta	edgeLeft, x
		say

.edgeXLoop1_1L:
		cpy	<edgeX1
		beq	.edgeXLoop3L

		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop1_0L

		sbc	<edgeSlopeX
		inx
		bra	.edgeXLoop0_0L
.edgeXLoop3L:
		rts

;edgeSigneX minus
.edgeJump10L:
		lda	<edgeX0
		eor	<edgeX1
		lsr	a

;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldy	<edgeX1
		ldx	<edgeY1

		bcc	.edgeXLoop4_1L

.edgeXLoop4_0L:
		say
		sta	edgeLeft, x
		say

.edgeXLoop5_0L:
		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop5_1L

		sbc	<edgeSlopeX
		dex

.edgeXLoop4_1L:
		say
		sta	edgeLeft, x
		say

.edgeXLoop5_1L:
		cpy	<edgeX0
		beq	.edgeXLoop7L

		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop5_0L

		sbc	<edgeSlopeX
		dex
		bra	.edgeXLoop4_0L
.edgeXLoop7L:
		rts

.edgeJump4L:
;edgeSlopeY >= edgeSlopeX
		lda	<edgeY1
		eor	<edgeY0
		lsr	a

;edgeSlope initialize
		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldy	<edgeX0
		ldx	<edgeY0

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop8L

;edgeSigneX plus
		bcc	.edgeYLoop0_1L

.edgeYLoop0_0L:
		say
		sta	edgeLeft, x
		say

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop0_1L

		sbc	<edgeSlopeY
		iny

.edgeYLoop0_1L:
		say
		sta	edgeLeft, x
		say

		cpx	<edgeY1
		beq	.edgeYLoop3L

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop0_0L

		sbc	<edgeSlopeY
		iny
		bra	.edgeYLoop0_0L
.edgeYLoop3L:
		rts

;edgeSigneX minus
.edgeYLoop8L:
		bcc	.edgeYLoop4_1L

.edgeYLoop4_0L:
		say
		sta	edgeLeft, x
		say

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop4_1L

		sbc	<edgeSlopeY
		dey

.edgeYLoop4_1L:
		say
		sta	edgeLeft, x
		say

		cpx	<edgeY1
		beq	.edgeYLoop7L

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop4_0L

		sbc	<edgeSlopeY
		dey
		bra	.edgeYLoop4_0L
.edgeYLoop7L:
		rts

.jp00:
;calculation right edge
;calculation edge Y
		sec
		lda	<edgeY1
		sbc	<edgeY0
		beq	.edgeJump6R

		sta	<edgeSlopeY
		jcs	.edgeJump7R

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

		jmp	.edgeJump7R

.edgeJump6R:
;edgeY0 = edgeY1
		rts

.edgeJump7R:
;calculation edge X
		sec
		lda	<edgeX1
		sbc	<edgeX0
		beq	.edgeJump1R

		sta	<edgeSlopeX
		stz	<edgeSigneX
		bcs	.edgeJump3R

		eor	#$FF
		inc	a
		sta	<edgeSlopeX

		mov	<edgeSigneX, #$FF

		bra	.edgeJump3R

.edgeJump1R:
;edgeX0 = edgeX1
		lda	<edgeY1
		eor	<edgeY0
		lsr	a

		lda	<edgeX0
		ldx	<edgeY0

		bcc	.edgeLoop0_1R

.edgeLoop0_0R:
		sta	edgeRight, x
		inx

.edgeLoop0_1R:
		sta	edgeRight, x

		cpx	<edgeY1
		beq	.edgeJump9R
		inx
		bra	.edgeLoop0_0R

.edgeJump9R:
		rts

.edgeJump3R:
;edgeSlope compare
		lda	<edgeSlopeY
		cmp	<edgeSlopeX
		jcs	.edgeJump4R

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeJump10R

;edgeSigneX plus
		lda	<edgeX1
		eor	<edgeX0
		lsr	a

;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldy	<edgeX0
		ldx	<edgeY0

		bcc	.edgeXLoop0_1R

.edgeXLoop0_0R:
		say
		sta	edgeRight, x
		say

.edgeXLoop1_0R:
		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop1_1R

		sbc	<edgeSlopeX
		inx

.edgeXLoop0_1R:
		say
		sta	edgeRight, x
		say

.edgeXLoop1_1R:
		cpy	<edgeX1
		beq	.edgeXLoop3R

		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop1_0R

		sbc	<edgeSlopeX
		inx
		bra	.edgeXLoop0_0R
.edgeXLoop3R:
		rts

;edgeSigneX minus
.edgeJump10R:
		lda	<edgeX0
		eor	<edgeX1
		lsr	a

;edgeSlope initialize
		lda	<edgeSlopeX
		eor	#$FF
		inc	a

		ldy	<edgeX1
		ldx	<edgeY1

		bcc	.edgeXLoop4_1R

.edgeXLoop4_0R:
		say
		sta	edgeRight, x
		say

.edgeXLoop5_0R:
		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop5_1R

		sbc	<edgeSlopeX
		dex

.edgeXLoop4_1R:
		say
		sta	edgeRight, x
		say

.edgeXLoop5_1R:
		cpy	<edgeX0
		beq	.edgeXLoop7R

		iny
		adc	<edgeSlopeY
		bcc	.edgeXLoop5_0R

		sbc	<edgeSlopeX
		dex
		bra	.edgeXLoop4_0R
.edgeXLoop7R:
		rts

.edgeJump4R:
;edgeSlopeY >= edgeSlopeX
		lda	<edgeY1
		eor	<edgeY0
		lsr	a

;edgeSlope initialize
		lda	<edgeSlopeY
		eor	#$FF
		inc	a

		ldy	<edgeX0
		ldx	<edgeY0

;check edgeSigneX
		bbs7	<edgeSigneX, .edgeYLoop8R

;edgeSigneX plus
		bcc	.edgeYLoop0_1R

.edgeYLoop0_0R:
		say
		sta	edgeRight, x
		say

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop0_1R

		sbc	<edgeSlopeY
		iny

.edgeYLoop0_1R:
		say
		sta	edgeRight, x
		say

		cpx	<edgeY1
		beq	.edgeYLoop3R

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop0_0R

		sbc	<edgeSlopeY
		iny
		bra	.edgeYLoop0_0R
.edgeYLoop3R:
		rts

;edgeSigneX minus
.edgeYLoop8R:
		bcc	.edgeYLoop4_1R

.edgeYLoop4_0R:
		say
		sta	edgeRight, x
		say

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop4_1R

		sbc	<edgeSlopeY
		dey

.edgeYLoop4_1R:
		say
		sta	edgeRight, x
		say

		cpx	<edgeY1
		beq	.edgeYLoop7R

		inx
		adc	<edgeSlopeX
		bcc	.edgeYLoop4_0R

		sbc	<edgeSlopeY
		dey
		bra	.edgeYLoop4_0R
.edgeYLoop7R:
		rts


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

		bbs6	<polyAttribute, .functionEnd	;skip line

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

.loopStart:	cpy	<maxEdgeY
		bcc	.putPolyProc
		beq	.putPolyProc
		rts

.putPolyProc:
		lda	edgeLeft, y
		cmp	edgeRight, y
		bcc	.jp0

		tax
		lda	edgeRight, y
		sta	edgeLeft, y
		tax
		sta	edgeRight, y

;calation vram address
;left
;calation counts
		lda	edgeLeft, y
.jp0:
		lsr	a
		lsr	a
		lsr	a
		sta	<polyLineCount

;left address
		tax
		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineLeftAddr

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh, y
		clc
		adc	<polygonTopAddress
		sta	<polyLineLeftAddr+1

;left put data
		lda	edgeLeft, y
		and	#$07
		tax

		lda	polyLineLeftDatas, x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;right
;calation counts
		lda	edgeRight, y
		lsr	a
		lsr	a
		lsr	a
		tax
		sec
		sbc	<polyLineCount

;count 0 then
		jeq	.polyLineJump03

		sta	<polyLineCount

;right address
		lda	polyLineAddrConvXLow, x
		ora	polyLineAddrConvYLow, y
		sta	<polyLineRightAddr

		lda	polyLineAddrConvXHigh, x
		ora	polyLineAddrConvYHigh, y
		clc
		adc	<polygonTopAddress
		sta	<polyLineRightAddr+1

;right put data
		lda	edgeRight, y
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
		lda	edgeRight, y
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
polyLineAddrConvYHigh:
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
polyLineAddrConvYLow:
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
polyLineAddrConvXHigh:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03


;----------------------------
polyLineAddrConvXLow:
		.db	$00, $20, $40, $60, $80, $A0, $C0, $E0, $00, $20, $40, $60, $80, $A0, $C0, $E0,\
			$00, $20, $40, $60, $80, $A0, $C0, $E0, $00, $20, $40, $60, $80, $A0, $C0, $E0

;----------------------------
polyLineLeftDatas:
		.db	$FF, $7F, $3F, $1F, $0F, $07, $03, $01


;----------------------------
polyLineRightDatas:
		.db	$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF


;////////////////////////////
		.bank	3
		INCBIN	"char.chr"		;    8K  3    $03
		INCBIN	"mul.dat"		;  128K  4~19 $04~$13
		INCBIN	"div.dat"		;   96K 20~31 $14~$1F
