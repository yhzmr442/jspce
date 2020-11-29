;VDC1
;VRAM
;0000-03FF	BG0	 1KWORD
;0400-0FFF
;1000-1FFF	CHR	 4KWORD	0-255CHR
;2000-4FFF	CHRBG0	12KWORD	32*24CHR(256*192)
;5000-7FFF

;Memory
;0000	I/O
;2000	RAM
;4000	mul data : div data : frame buffer ram $1F2000-$1F7FFF($F9-$FB) 24KBYTE
;6000
;8000
;A000	polygon process
;C000	polygon process
;E000	main irq


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


chardatBank		.equ	3
muldatBank		.equ	4
divdatBank		.equ	20


;----------------------------
putPolyLine00m		.macro
		lda	<polyLineColorDataWork0
		sta	[polyLineLeftAddr],y
		iny

		lda	<polyLineColorDataWork1
		sta	[polyLineLeftAddr],y
		clc
		tya
		adc	#$0F
		tay

		lda	<polyLineColorDataWork2
		sta	[polyLineLeftAddr],y
		iny

		lda	<polyLineColorDataWork3
		sta	[polyLineLeftAddr],y
		clc
		tya
		adc	#$0F
		tay
		bcc	.jp\@
		inc	<polyLineLeftAddr+1
.jp\@
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

;---------------------
;LDRU SsBA
padlast			.ds	1
padnow			.ds	1
padstate		.ds	1

;---------------------
puthexaddr		.ds	2
puthexdata		.ds	1

;---------------------
udiv32_2Work		.ds	2

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

;---------------------
edgeX0			.ds	1
edgeY0			.ds	1
edgeX1			.ds	1
edgeY1			.ds	1

edgeSlopeX		.ds	1
edgeSlopeY		.ds	1
edgeSigneX		.ds	1

;---------------------
polyLineX0		.ds	1
polyLineX1		.ds	1
polyLineY		.ds	1

polyLineLeftAddr	.ds	2

polyLineLeftData	.ds	1
polyLineLeftMask	.ds	1

polyLineRightData	.ds	1
polyLineRightMask	.ds	1

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

;vsync interrupt start
		cli

;main loop
.mainLoop:

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
		jsr	clearRam

		jsr	putPolyBuffer

		jsr	ramToChar

		inc	drawCount
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
		sta	$0000
		iny

		lda	vdcdata, y
		sta	$0002
		iny

		lda	vdcdata, y
		sta	$0003
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
		tia	palettedata, $0404, $20

;CHAR set to vram
		lda	#chardatBank
		tam	#$06

;vram address $1000
		st0	#$00
		st1	#$00
		st2	#$10

		st0	#$02
		tia	$C000, $0002, $2000

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

;left rotation with carry div16ans
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
;left rotation with carry div16ans
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
		lda	[muladdr],y
		sta	<mul16c

		ldy	<mul16a+1
		lda	[muladdr],y
		sta	<mul16c+1

		pla
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

		ldx	<mul16b+1
		lda	mulbankdata, x
		pha
		tam	#$02

		lda	muladdrdata, x
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

		pla
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

		lda	$0000

		jsr	getpaddata

		dec	frameCount
		bne	.irqEnd

		ldx	#0
		ldy	#24
		lda	drawCount
		jsr	puthex

		lda	#60
		sta	frameCount
		stz	drawCount

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
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $00, $00	;32x32
		.db	$FF		;end


;----------------------------
palettedata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\;GRB
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
;x=xcosA-ysinA y=xsinA+ycosA z=z
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		bne	.vertexRotationZJump0
		jmp	.vertexRotationZEnd
.vertexRotationZJump0:

		lda	<vertexCount
		bne	.vertexRotationZJump1
		jmp	.vertexRotationZEnd
.vertexRotationZJump1:
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

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1
		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ysinA

		sec				;xcosA-ysinA
		lda	<div16ans
		sbc	<mul16c
		sta	<mul16c
		lda	<div16ans+1
		sbc	<mul16c+1
		sta	<mul16c+1
		lda	<div16work
		sbc	<mul16d
		sta	<mul16d
		lda	<div16work+1
		sbc	<mul16d+1
		sta	<mul16d+1

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

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1
		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		lda	transform2DWork0+2,y	;Y0
		sta	<mul16a
		lda	transform2DWork0+3,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;ycosA

		clc				;xsinA+ycosA
		lda	<div16ans
		adc	<mul16c
		sta	<mul16c
		lda	<div16ans+1
		adc	<mul16c+1
		sta	<mul16c+1
		lda	<div16work
		adc	<mul16d
		sta	<mul16d
		lda	<div16work+1
		adc	<mul16d+1
		sta	<mul16d+1

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
		beq	.vertexRotationZEnd
		jmp	.vertexRotationZLoop

.vertexRotationZEnd:
		rts


;----------------------------
vertexRotationY:
;x=xcosA+zsinA y=y           z=-xsinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		bne	.vertexRotationYJump0
		jmp	.vertexRotationYEnd
.vertexRotationYJump0:

		lda	<vertexCount
		bne	.vertexRotationYJump1
		jmp	.vertexRotationYEnd
.vertexRotationYJump1:
		sta	<vertexCountWork

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

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1
		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xcosA

		clc				;zsinA+xcosA
		lda	<div16ans
		adc	<mul16c
		sta	<mul16c
		lda	<div16ans+1
		adc	<mul16c+1
		sta	<mul16c+1
		lda	<div16work
		adc	<mul16d
		sta	<mul16d
		lda	<div16work+1
		adc	<mul16d+1
		sta	<mul16d+1

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

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1
		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		lda	transform2DWork0,y	;X0
		sta	<mul16a
		lda	transform2DWork0+1,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;xsinA

		sec				;zcosA-xsinA
		lda	<div16ans
		sbc	<mul16c
		sta	<mul16c
		lda	<div16ans+1
		sbc	<mul16c+1
		sta	<mul16c+1
		lda	<div16work
		sbc	<mul16d
		sta	<mul16d
		lda	<div16work+1
		sbc	<mul16d+1
		sta	<mul16d+1

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
		beq	.vertexRotationYEnd
		jmp	.vertexRotationYLoop

.vertexRotationYEnd:
		rts


;----------------------------
vertexRotationX:
;x=x           y=ycosA-zsinA z= ysinA+zcosA
;transform2DWork0 => transform2DWork0
;vertexCount = count
;x = angle
		cpx	#0
		bne	.vertexRotationXJump0
		jmp	.vertexRotationXEnd
.vertexRotationXJump0:

		lda	<vertexCount
		bne	.vertexRotationXJump1
		jmp	.vertexRotationXEnd
.vertexRotationXJump1:
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

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1
		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	sinDataLow,x		;sin
		sta	<mul16b
		lda	sinDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zsinA

		sec				;ycosA-zsinA
		lda	<div16ans
		sbc	<mul16c
		sta	<mul16c
		lda	<div16ans+1
		sbc	<mul16c+1
		sta	<mul16c+1
		lda	<div16work
		sbc	<mul16d
		sta	<mul16d
		lda	<div16work+1
		sbc	<mul16d+1
		sta	<mul16d+1

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

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1
		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		lda	transform2DWork0+4,y	;Z0
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1
		lda	cosDataLow,x		;cos
		sta	<mul16b
		lda	cosDataHigh,x
		sta	<mul16b+1

		jsr	smul16			;zcosA

		clc				;ysinA+zcosA
		lda	<div16ans
		adc	<mul16c
		sta	<mul16c
		lda	<div16ans+1
		adc	<mul16c+1
		sta	<mul16c+1
		lda	<div16work
		adc	<mul16d
		sta	<mul16d
		lda	<div16work+1
		adc	<mul16d+1
		sta	<mul16d+1

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
		beq	.vertexRotationXEnd
		jmp	.vertexRotationXLoop

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

		bpl	.transform2D2Jump05
		jmp	.transform2D2Jump00

.transform2D2Jump05:
;X0 to mul16c
		lda	transform2DWork0,y
		sta	<mul16c
		lda	transform2DWork0+1,y
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4,y
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

;X0*128/Z0
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

;Y0 to mul16c
		lda	transform2DWork0+2,y
		sta	<mul16c
		lda	transform2DWork0+3,y
		sta	<mul16c+1

;Z0 to mul16a
		lda	transform2DWork0+4,y
		sta	<mul16a
		lda	transform2DWork0+5,y
		sta	<mul16a+1

;Y0*128/Z0
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
		beq	.transform2D2Jump02
		jmp	.transform2D2Loop0

.transform2D2Jump02:
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
putPolyBuffer:
;
		lda	polyBufferStart
		sta	<polyBufferAddr
		lda	polyBufferStart+1
		sta	<polyBufferAddr+1

.putPolyBufferLoop0:
		ldy	#5
		lda	[polyBufferAddr],y	;COUNT
		beq	.putPolyBufferEnd
		sta	<clip2D0Count
		pha

		ldy	#4
		lda	[polyBufferAddr],y	;COLOR
		sta	<polyLineColorNo

		clx
		ldy	#6

.putPolyBufferLoop1:
		lda	[polyBufferAddr],y
		sta	clip2D0,x
		inx
		inx
		iny

		lda	[polyBufferAddr],y
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
		lda	[polyBufferAddr],y
		tax
		iny
		lda	[polyBufferAddr],y
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
		sec
		lda	<translationX
		sbc	<eyeTranslationX
		sta	<translationX
		lda	<translationX+1
		sbc	<eyeTranslationX+1
		sta	<translationX+1

		sec
		lda	<translationY
		sbc	<eyeTranslationY
		sta	<translationY
		lda	<translationY+1
		sbc	<eyeTranslationY+1
		sta	<translationY+1

		sec
		lda	<translationZ
		sbc	<eyeTranslationZ
		sta	<translationZ
		lda	<translationZ+1
		sbc	<eyeTranslationZ+1
		sta	<translationZ+1

		jsr	vertexTranslation2

;eye rotation
		lda	<eyeRotationX
		sta	<rotationX
		lda	<eyeRotationY
		sta	<rotationY
		lda	<eyeRotationZ
		sta	<rotationZ

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
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		ldy	#$03
		lda	[modelAddr],y		;vertex data address
		sta	<vertex0Addr
		ldy	#$04
		lda	[modelAddr],y
		sta	<vertex0Addr+1

		lda	#LOW(transform2DWork0)
		sta	<vertex1Addr
		lda	#HIGH(transform2DWork0)
		sta	<vertex1Addr+1

		jsr	vertexMultiply

;translation
		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		lda	#LOW(transform2DWork0)
		sta	<vertex0Addr
		lda	#HIGH(transform2DWork0)
		sta	<vertex0Addr+1

		lda	#LOW(transform2DWork1)
		sta	<vertex1Addr
		lda	#HIGH(transform2DWork1)
		sta	<vertex1Addr+1

		jsr	vertexTranslation

;transform2D
		ldy	#$05
		lda	[modelAddr],y		;vertex count
		sta	<vertexCount

		lda	#LOW(transform2DWork1)
		sta	<vertex0Addr
		lda	#HIGH(transform2DWork1)
		sta	<vertex0Addr+1

		lda	#LOW(transform2DWork0)
		sta	<vertex1Addr
		lda	#HIGH(transform2DWork0)
		sta	<vertex1Addr+1

		jsr	transform2D

		jsr	setModelProc

		rts


;----------------------------
setModelProc2:
;
		ldy	#$00
		lda	[modelAddr],y
		sta	<modelAddrWork		;ModelData Polygon Addr
		iny
		lda	[modelAddr],y
		sta	<modelAddrWork+1

		ldy	#$02
		lda	[modelAddr],y		;Polygon Count
		sta	<modelPolygonCount

		cly

.setModelLoop3:
		phy

		lda	[modelAddrWork],y	;ModelData Vertex Count, Front Color
		and	#$F8
		lsr	a
		lsr	a
		sta	<setModelFrontColor

		lda	[modelAddrWork],y	;ModelData Vertex Count, Front Color
		and	#$07
		dec	a
		sta	<setModelCount

		iny

		lda	[modelAddrWork],y	;ModelData Polygon Attr, Back Color
		sta	<setModelAttr
		and	#$F8
		lsr	a
		lsr	a
		sta	<setModelBackColor

		iny

		lda	[modelAddrWork],y
		sta	<frontClipDataWork

		stz	<model2DClipIndexWork

		stz	<frontClipCount

		stz	<polyBufferZ0Work0
		stz	<polyBufferZ0Work0+1

.setModelLoop4:
		lda	[modelAddrWork],y
		sta	<frontClipData0

		iny

		lda	[modelAddrWork],y
		sta	<frontClipData1

		phy
		jsr	clipFront
		ply

		dec	<setModelCount
		bne	.setModelLoop4

;--------
		lda	[modelAddrWork],y
		sta	<frontClipData0

		lda	<frontClipDataWork
		sta	<frontClipData1

		jsr	clipFront

		lda	<frontClipCount
		bne	.setModelJump11
		jmp	.setModelJump0

.setModelJump11:
		sta	<clip2D0Count
		jsr	clip2D
		bne	.setModelJump3
		jmp	.setModelJump0

.setModelJump3:
;back side check
		sec
		lda	clip2D0+8		;X2
		sbc	clip2D0+4		;X1
		sta	<mul16a
		lda	#0
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0+2		;Y0
		sbc	clip2D0+6		;Y1
		sta	<mul16b
		lda	#0
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1

		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		sec
		lda	clip2D0+10		;Y2
		sbc	clip2D0+6		;Y1
		sta	<mul16a
		lda	#0
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0			;X0
		sbc	clip2D0+4		;X1
		sta	<mul16b
		lda	#0
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		sec
		lda	<div16ans
		sbc	<mul16c
		lda	<div16ans+1
		sbc	<mul16c+1

		lda	<div16work
		sbc	<mul16d
		lda	<div16work+1
		sbc	<mul16d+1

		bpl	.setModelJump2

;Back Side
		bbr0	<setModelAttr,.setModelJump6
		jmp	.setModelJump0

.setModelJump6:
		lda	<setModelBackColor
		bra	.setModelJump5

.setModelJump2:
;Front Side
		lda	<setModelFrontColor

.setModelJump5:
		ldy	#4
		sta	[polyBufferAddr],y	;COLOR

		lda	<clip2D0Count
		ldy	#5
		sta	[polyBufferAddr],y	;COUNT

;SAMPLE Z
		ldy	#2
		lda	<polyBufferZ0Work0	;SAMPLE Z
		sta	[polyBufferAddr],y
		iny
		lda	<polyBufferZ0Work0+1
		sta	[polyBufferAddr],y

;set buffer
		lda	#LOW(polyBufferStart)
		sta	<polyBufferNow
		lda	#HIGH(polyBufferStart)
		sta	<polyBufferNow+1

.setBufferLoop:
		ldy	#0			;NEXT ADDR
		lda	[polyBufferNow],y
		sta	<polyBufferNext
		iny
		lda	[polyBufferNow],y
		sta	<polyBufferNext+1

		ldy	#2			;NEXT SAMPLE Z
		lda	[polyBufferNext],y
		sta	<polyBufferZ0Work0
		iny
		lda	[polyBufferNext],y
		sta	<polyBufferZ0Work0+1

		ldy	#2			;SAMPLE Z
		sec
		lda	[polyBufferAddr],y
		sbc	<polyBufferZ0Work0
		iny
		lda	[polyBufferAddr],y
		sbc	<polyBufferZ0Work0+1

		bpl	.setBufferJump		;SAMPLE Z >= NEXT SAMPLE Z

		lda	<polyBufferNext
		sta	<polyBufferNow
		lda	<polyBufferNext+1
		sta	<polyBufferNow+1

		bra	.setBufferLoop

.setBufferJump:
		ldy	#0			;BUFFER -> NEXT
		lda	<polyBufferNext
		sta	[polyBufferAddr],y
		iny
		lda	<polyBufferNext+1
		sta	[polyBufferAddr],y

		ldy	#0			;NOW -> BUFFER
		lda	<polyBufferAddr
		sta	[polyBufferNow],y
		iny
		lda	<polyBufferAddr+1
		sta	[polyBufferNow],y

;set data
		clx
		ldy	#6
.setModelLoop2:
		lda	clip2D0,x
		sta	[polyBufferAddr],y
		inx
		inx
		iny

		lda	clip2D0,x
		sta	[polyBufferAddr],y
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
		beq	.setModelEnd
		jmp	.setModelLoop3

.setModelEnd:
		rts


;----------------------------
clipFront:
		ldx	<frontClipData0
		ldy	<frontClipData1

		lda	transform2DWork0+5,x	;Z0<128 flag
		and	#$80
		lsr	a
		sta	<frontClipFlag
		lda	transform2DWork0+5,y	;Z0<128 flag
		and	#$80
		ora	<frontClipFlag
		sta	<frontClipFlag
		bne	.clipFrontJump12
		jmp	.clipFrontJump8

.clipFrontJump12:
		cmp	#$C0
		bne	.clipFrontJump13
		jmp	.clipFrontJump9

.clipFrontJump13:
;clip front
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
		clc
		lda	<mul16a
		adc	<centerX
		sta	<clipFrontX
		lda	<mul16a+1
		adc	<centerX+1
		sta	<clipFrontX+1

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
		clc
		lda	<mul16a
		adc	<centerY
		sta	<clipFrontY
		lda	<mul16a+1
		adc	<centerY+1
		sta	<clipFrontY+1

		bbs7	<frontClipFlag,.clipFrontJump10

		ldy	<model2DClipIndexWork

		lda	<clipFrontX
		sta	clip2D0,y
		iny
		lda	<clipFrontX+1
		sta	clip2D0,y
		iny

		lda	<clipFrontY
		sta	clip2D0,y
		iny
		lda	<clipFrontY+1
		sta	clip2D0,y
		iny

		sty	<model2DClipIndexWork

		lda	#128
		sta	polyBufferZ0Work1
		stz	polyBufferZ0Work1+1

		inc	<frontClipCount

		bra	.clipFrontJump11

.clipFrontJump10:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0,x
		sta	clip2D0,y
		iny
		lda	transform2DWork0+1,x
		sta	clip2D0,y
		iny

		lda	transform2DWork0+2,x
		sta	clip2D0,y
		iny
		lda	transform2DWork0+3,x
		sta	clip2D0,y
		iny

		lda	<clipFrontX
		sta	clip2D0,y
		iny
		lda	<clipFrontX+1
		sta	clip2D0,y
		iny

		lda	<clipFrontY
		sta	clip2D0,y
		iny
		lda	<clipFrontY+1
		sta	clip2D0,y
		iny

		sty	<model2DClipIndexWork

		lda	transform2DWork0+4,x
		sta	polyBufferZ0Work1
		lda	transform2DWork0+5,x
		sta	polyBufferZ0Work1+1

		inc	<frontClipCount
		inc	<frontClipCount

		bra	.clipFrontJump11

.clipFrontJump8:
		ldy	<model2DClipIndexWork

		lda	transform2DWork0,x
		sta	clip2D0,y
		iny
		lda	transform2DWork0+1,x
		sta	clip2D0,y
		iny

		lda	transform2DWork0+2,x
		sta	clip2D0,y
		iny
		lda	transform2DWork0+3,x
		sta	clip2D0,y
		iny

		sty	<model2DClipIndexWork

		lda	transform2DWork0+4,x
		sta	polyBufferZ0Work1
		lda	transform2DWork0+5,x
		sta	polyBufferZ0Work1+1

		inc	<frontClipCount

.clipFrontJump11:
;check Z sample
		sec
		lda	<polyBufferZ0Work0
		sbc	<polyBufferZ0Work1
		lda	<polyBufferZ0Work0+1
		sbc	<polyBufferZ0Work1+1

		bpl	.clipFrontJump9

		lda	<polyBufferZ0Work1
		sta	<polyBufferZ0Work0
		lda	<polyBufferZ0Work1+1
		sta	<polyBufferZ0Work0+1

.clipFrontJump9:
		rts


;----------------------------
setModelProc:
;
		ldy	#$00
		lda	[modelAddr],y
		sta	<modelAddrWork		;ModelData Polygon Addr
		iny
		lda	[modelAddr],y
		sta	<modelAddrWork+1

		ldy	#$02
		lda	[modelAddr],y		;Polygon Count
		sta	<modelPolygonCount

		stz	<polyBufferAddrWork0	;ModelData Polygon

.setModelLoop0:
		ldy	<polyBufferAddrWork0

		lda	[modelAddrWork],y	;ModelData Vertex Count, Front Color
		and	#$F8
		lsr	a
		lsr	a
		sta	<setModelFrontColor

		lda	[modelAddrWork],y	;ModelData Vertex Count, Front Color
		and	#$07
		sta	<setModelCountWork
		sta	<setModelCount

		iny

		lda	[modelAddrWork],y	;ModelData Polygon Attr, Back Color
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
		lda	[modelAddrWork],y
		tax

		ldy	<polyBufferAddrWork1

;move to clip2D0
		lda	transform2DWork0,x	;2D X0
		sta	clip2D0,y
		inx
		iny

		lda	transform2DWork0,x
		sta	clip2D0,y
		inx
		iny

		lda	transform2DWork0,x	;2D Y0
		sta	clip2D0,y
		inx
		iny

		lda	transform2DWork0,x
		sta	clip2D0,y
		inx
		iny

		sty	<polyBufferAddrWork1

		sec
		lda	transform2DWork0,x	;3D Z0
		sbc	<polyBufferZ0Work0
		inx
		lda	transform2DWork0,x

		bpl	.setModelJump4		;Z0<128 flag check

;next polygon data index
		clc
		lda	<polyBufferAddrWork0
		adc	<setModelCount
		sta	<polyBufferAddrWork0
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
		lda	<setModelCountWork
		sta	<clip2D0Count
		jsr	clip2D
		bne	.setModelJump3

		jmp	.setModelJump0

.setModelJump3:
;back side check
		sec
		lda	clip2D0+8		;X2
		sbc	clip2D0+4		;X1
		sta	<mul16a
		lda	#0
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0+2		;Y0
		sbc	clip2D0+6		;Y1
		sta	<mul16b
		lda	#0
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		lda	<mul16c
		sta	<div16ans
		lda	<mul16c+1
		sta	<div16ans+1

		lda	<mul16d
		sta	<div16work
		lda	<mul16d+1
		sta	<div16work+1

		sec
		lda	clip2D0+10		;Y2
		sbc	clip2D0+6		;Y1
		sta	<mul16a
		lda	#0
		sbc	#0
		sta	<mul16a+1

		sec
		lda	clip2D0			;X0
		sbc	clip2D0+4		;X1
		sta	<mul16b
		lda	#0
		sbc	#0
		sta	<mul16b+1

		jsr	smul16

		sec
		lda	<div16ans
		sbc	<mul16c
		lda	<div16ans+1
		sbc	<mul16c+1

		lda	<div16work
		sbc	<mul16d
		lda	<div16work+1
		sbc	<mul16d+1

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
		sta	[polyBufferAddr],y	;COLOR

		lda	<clip2D0Count
		ldy	#5
		sta	[polyBufferAddr],y	;COUNT

		clx
		ldy	#6
.setModelLoop2:
		lda	clip2D0,x
		sta	[polyBufferAddr],y
		inx
		inx
		iny

		lda	clip2D0,x
		sta	[polyBufferAddr],y
		inx
		inx
		iny

		dec	<clip2D0Count
		bne	.setModelLoop2

		sty	<polyBufferAddrWork2

;SAMPLE Z
		ldy	#2
		lda	<polyBufferZ0Work0	;SAMPLE Z
		sta	[polyBufferAddr],y
		iny
		lda	<polyBufferZ0Work0+1
		sta	[polyBufferAddr],y

;set buffer
		lda	#LOW(polyBufferStart)
		sta	<polyBufferNow
		lda	#HIGH(polyBufferStart)
		sta	<polyBufferNow+1

.setBufferLoop:
		ldy	#0			;NEXT ADDR
		lda	[polyBufferNow],y
		sta	<polyBufferNext
		iny
		lda	[polyBufferNow],y
		sta	<polyBufferNext+1

		ldy	#2			;NEXT SAMPLE Z
		lda	[polyBufferNext],y
		sta	<polyBufferZ0Work0
		iny
		lda	[polyBufferNext],y
		sta	<polyBufferZ0Work0+1

		ldy	#2			;SAMPLE Z
		sec
		lda	[polyBufferAddr],y
		sbc	<polyBufferZ0Work0
		iny
		lda	[polyBufferAddr],y
		sbc	<polyBufferZ0Work0+1

		bpl	.setBufferJump		;SAMPLE Z >= NEXT SAMPLE Z

		lda	<polyBufferNext
		sta	<polyBufferNow
		lda	<polyBufferNext+1
		sta	<polyBufferNow+1

		bra	.setBufferLoop

.setBufferJump:
		ldy	#0			;BUFFER -> NEXT
		lda	<polyBufferNext
		sta	[polyBufferAddr],y
		iny
		lda	<polyBufferNext+1
		sta	[polyBufferAddr],y

		ldy	#0			;NOW -> BUFFER
		lda	<polyBufferAddr
		sta	[polyBufferNow],y
		iny
		lda	<polyBufferAddr+1
		sta	[polyBufferNow],y

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
		beq	.setModelEnd
		jmp	.setModelLoop0

.setModelEnd:
		rts


;----------------------------
initializePolyBuffer:
;
;initialize polyBufferAddr = polyBuffer
		lda	#LOW(polyBuffer)
		sta	<polyBufferAddr
		lda	#HIGH(polyBuffer)
		sta	<polyBufferAddr+1

;polyBufferStart NEXT ADDR = polyBufferEnd
		lda	#LOW(polyBufferEnd)
		sta	polyBufferStart
		lda	#HIGH(polyBufferEnd)
		sta	polyBufferStart+1

;polyBufferStart SAMPLE Z = $7FFF
		lda	#$FF
		sta	polyBufferStart+2
		lda	#$7F
		sta	polyBufferStart+3

;polyBufferEnd SAMPLE Z = $0000
		lda	#$00
		sta	polyBufferEnd+2
		lda	#$00
		sta	polyBufferEnd+3

;polyBufferEnd COLOR = $00
		stz	polyBufferEnd+4

;polyBufferEnd COUNT = $00
		stz	polyBufferEnd+5

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

		lda	matrix2,x
		sta	<mul16b
		inx
		lda	matrix2,x
		sta	<mul16b+1
		inx

		jsr	smul16

		clc
		lda	<mul16c
		adc	<vertexWork
		sta	<vertexWork
		lda	<mul16c+1
		adc	<vertexWork+1
		sta	<vertexWork+1
		lda	<mul16d
		adc	<vertexWork+2
		sta	<vertexWork+2
		lda	<mul16d+1
		adc	<vertexWork+3
		sta	<vertexWork+3

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

		lda	matrix0,x
		sta	<mul16a
		lda	matrix0+1,x
		sta	<mul16a+1

		lda	matrix1,y
		sta	<mul16b
		lda	matrix1+1,y
		sta	<mul16b+1

		jsr	smul16

		lda	<mul16c
		sta	<vertexWork
		lda	<mul16c+1
		sta	<vertexWork+1
		lda	<mul16d
		sta	<vertexWork+2
		lda	<mul16d+1
		sta	<vertexWork+3

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

		clc
		lda	<mul16c
		adc	<vertexWork
		sta	<vertexWork
		lda	<mul16c+1
		adc	<vertexWork+1
		sta	<vertexWork+1
		lda	<mul16d
		adc	<vertexWork+2
		sta	<vertexWork+2
		lda	<mul16d+1
		adc	<vertexWork+3
		sta	<vertexWork+3

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

		clc
		lda	<mul16c
		adc	<vertexWork
		sta	<vertexWork
		lda	<mul16c+1
		adc	<vertexWork+1
		sta	<vertexWork+1
		lda	<mul16d
		adc	<vertexWork+2
		sta	<vertexWork+2
		lda	<mul16d+1
		adc	<vertexWork+3
		sta	<vertexWork+3

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
		beq	.matrixMultiplyJump0
		jmp	.matrixMultiplyLoop0

.matrixMultiplyJump0:
		clx

		clc
		tya
		adc	#6
		tay
		cpy	#18
		beq	.matrixMultiplyJump1
		jmp	.matrixMultiplyLoop0

.matrixMultiplyJump1:
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

		bpl	.transform2DJump05
		jmp	.transform2DJump00

.transform2DJump05:
;X0 to mul16c
		ldy	#$00
		lda	[vertex0Addr],y
		sta	<mul16c
		iny
		lda	[vertex0Addr],y
		sta	<mul16c+1

;Z0 to mul16a
		ldy	#$04
		lda	[vertex0Addr],y
		sta	<mul16a
		iny
		lda	[vertex0Addr],y
		sta	<mul16a+1

;X0*128/Z0
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

;Y0 to mul16c
		ldy	#$02
		lda	[vertex0Addr],y
		sta	<mul16c
		iny
		lda	[vertex0Addr],y
		sta	<mul16c+1

;Z0 to mul16a
		ldy	#$04
		lda	[vertex0Addr],y
		sta	<mul16a
		iny
		lda	[vertex0Addr],y
		sta	<mul16a+1

;Y0*128/Z0
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
		beq	.transform2DJump02
		jmp	.transform2DLoop0

.transform2DJump02:
		rts


;----------------------------
transform2DProc:
;mul16c(-32768_32767) * 128 / mul16a(1_32767) = mul16a(rough value)
		phx
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
		ldx	<div16a+1
		lda	divbankdata, x
		pha
		tam	#$02

		lda	muladdrdata, x
		sta	<muladdr+1
		lda	<div16a
		sta	<muladdr

		lda	[muladdr]
		sta	<udiv32_2Work

		clc
		pla
		adc	#4
		tam	#$02

		lda	[muladdr]
		sta	<udiv32_2Work+1

;mul udiv32_2Work low byte
		ldx	<udiv32_2Work
		lda	mulbankdata, x
		pha
		tam	#$02

		lda	muladdrdata, x
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

		pla
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
		ldx	<udiv32_2Work+1
		lda	mulbankdata, x
		pha
		tam	#$02

		lda	muladdrdata, x
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

		pla
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
		plx
		rts


;----------------------------
clip2D:
;
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
		sta	clip2D1,x	;last X
		lda	clip2D1+1
		sta	clip2D1+1,x

		lda	clip2D1+2	;Y0
		sta	clip2D1+2,x	;last Y
		lda	clip2D1+3
		sta	clip2D1+3,x

		clx
		cly
		stz	<clip2D0Count

.clip2DX255Loop0:
		stz	<clip2DFlag

		sec
		lda	clip2D1,x	;X0
		sbc	#$00
		lda	clip2D1+1,x
		sbc	#$01
		bmi	.clip2DX255Jump00
		smb0	<clip2DFlag
.clip2DX255Jump00:

		sec
		lda	clip2D1+4,x	;X1
		sbc	#$00
		lda	clip2D1+5,x
		sbc	#$01
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
		sec
		lda	#255
		sbc	clip2D1,x	;X0
		sta	<mul16a
		lda	#0
		sbc	clip2D1+1,x
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D1+6,x	;Y1
		sbc	clip2D1+2,x	;Y0
		sta	<mul16b
		lda	clip2D1+7,x
		sbc	clip2D1+3,x
		sta	<mul16b+1

;(255-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D1+4,x	;X1
		sbc	clip2D1,x	;X0
		sta	<mul16a
		lda	clip2D1+5,x
		sbc	clip2D1+1,x
		sta	<mul16a+1

;(255-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(255-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D1+2,x	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+3,x
		sta	<mul16a+1

		bbs1	<clip2DFlag,.clip2DX255Jump04
;X0>255 X1<=255
		lda	#$FF
		sta	clip2D0,y	;X0
		lda	#$00
		sta	clip2D0+1,y

		lda	<mul16a
		sta	clip2D0+2,y	;Y0
		lda	<mul16a+1
		sta	clip2D0+3,y

		inc	<clip2D0Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DX255Jump03

.clip2DX255Jump04:
;X0<=255 X1>255
		lda	clip2D1,x	;X0
		sta	clip2D0,y	;X0
		lda	clip2D1+1,x
		sta	clip2D0+1,y

		lda	clip2D1+2,x	;Y0
		sta	clip2D0+2,y	;Y0
		lda	clip2D1+3,x
		sta	clip2D0+3,y

		lda	#$FF
		sta	clip2D0+4,y	;X1
		lda	#$00
		sta	clip2D0+5,y

		lda	<mul16a
		sta	clip2D0+6,y	;Y1
		lda	<mul16a+1
		sta	clip2D0+7,y

		clc
		lda	<clip2D0Count
		adc	#$02
		sta	<clip2D0Count

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DX255Jump03

.clip2DX255Jump02:
;X0<=255 X1<=255
		lda	clip2D1,x	;X0
		sta	clip2D0,y	;X0
		lda	clip2D1+1,x
		sta	clip2D0+1,y

		lda	clip2D1+2,x	;Y0
		sta	clip2D0+2,y	;Y0
		lda	clip2D1+3,x
		sta	clip2D0+3,y

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
		beq	.clip2DX255Jump07
		jmp	.clip2DX255Loop0
.clip2DX255Jump07:

		rts


;----------------------------
clip2DX0:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax

		lda	clip2D0		;X0
		sta	clip2D0,x	;last X
		lda	clip2D0+1
		sta	clip2D0+1,x

		lda	clip2D0+2	;Y0
		sta	clip2D0+2,x	;last Y
		lda	clip2D0+3
		sta	clip2D0+3,x

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
		bne	.clip2DX0Jump05
		jmp	.clip2DX0Jump02
.clip2DX0Jump05:
		cmp	#$03
		bne	.clip2DX0Jump06
		jmp	.clip2DX0Jump03
.clip2DX0Jump06:

;(0-X0) to mul16a
		sec
		lda	#0
		sbc	clip2D0,x	;X0
		sta	<mul16a
		lda	#0
		sbc	clip2D0+1,x
		sta	<mul16a+1

;(Y1-Y0) to mul16b
		sec
		lda	clip2D0+6,x	;Y1
		sbc	clip2D0+2,x	;Y0
		sta	<mul16b
		lda	clip2D0+7,x
		sbc	clip2D0+3,x
		sta	<mul16b+1

;(0-X0)*(Y1-Y0) to mul16d:mul16c
		jsr	smul16

;(X1-X0) to mul16a
		sec
		lda	clip2D0+4,x	;X1
		sbc	clip2D0,x	;X0
		sta	<mul16a
		lda	clip2D0+5,x
		sbc	clip2D0+1,x
		sta	<mul16a+1

;(0-X0)*(Y1-Y0)/(X1-X0)
		jsr	sdiv32

;(0-X0)*(Y1-Y0)/(X1-X0)+Y0
		clc
		lda	<mul16a
		adc	clip2D0+2,x	;Y0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+3,x
		sta	<mul16a+1

		bbs1	<clip2DFlag,.clip2DX0Jump04
;X0<0 X1>=0
		lda	#$00
		sta	clip2D1,y	;X0
		lda	#$00
		sta	clip2D1+1,y

		lda	<mul16a
		sta	clip2D1+2,y	;Y0
		lda	<mul16a+1
		sta	clip2D1+3,y

		inc	<clip2D1Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DX0Jump03

.clip2DX0Jump04:
;X0>=0 X1<0
		lda	clip2D0,x	;X0
		sta	clip2D1,y	;X0
		lda	clip2D0+1,x
		sta	clip2D1+1,y

		lda	clip2D0+2,x	;Y0
		sta	clip2D1+2,y	;Y0
		lda	clip2D0+3,x
		sta	clip2D1+3,y

		lda	#$00
		sta	clip2D1+4,y	;X1
		lda	#$00
		sta	clip2D1+5,y

		lda	<mul16a
		sta	clip2D1+6,y	;Y1
		lda	<mul16a+1
		sta	clip2D1+7,y

		clc
		lda	<clip2D1Count
		adc	#$02
		sta	<clip2D1Count

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DX0Jump03

.clip2DX0Jump02:
;X0>=0 X1>=0
		lda	clip2D0,x	;X0
		sta	clip2D1,y	;X0
		lda	clip2D0+1,x
		sta	clip2D1+1,y

		lda	clip2D0+2,x	;Y0
		sta	clip2D1+2,y	;Y0
		lda	clip2D0+3,x
		sta	clip2D1+3,y

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
		beq	.clip2DX0Jump07
		jmp	.clip2DX0Loop0
.clip2DX0Jump07:

		rts


;----------------------------
clip2DY255:
;
		lda	<clip2D1Count
		asl	a
		asl	a
		tax

		lda	clip2D1		;X0
		sta	clip2D1,x	;last X
		lda	clip2D1+1
		sta	clip2D1+1,x

		lda	clip2D1+2	;Y0
		sta	clip2D1+2,x	;last Y
		lda	clip2D1+3
		sta	clip2D1+3,x

		clx
		cly
		stz	<clip2D0Count

.clip2DY255Loop0:
		stz	<clip2DFlag

		sec
		lda	clip2D1+2,x	;Y0
		sbc	#192
		lda	clip2D1+3,x
		sbc	#0
		bmi	.clip2DY255Jump00
		smb0	<clip2DFlag
.clip2DY255Jump00:

		sec
		lda	clip2D1+6,x	;Y1
		sbc	#192
		lda	clip2D1+7,x
		sbc	#0
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
		sec
		lda	#191
		sbc	clip2D1+2,x	;Y0
		sta	<mul16a
		lda	#0
		sbc	clip2D1+3,x
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D1+4,x	;X1
		sbc	clip2D1,x	;X0
		sta	<mul16b
		lda	clip2D1+5,x
		sbc	clip2D1+1,x
		sta	<mul16b+1

;(191-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D1+6,x	;Y1
		sbc	clip2D1+2,x	;Y0
		sta	<mul16a
		lda	clip2D1+7,x
		sbc	clip2D1+3,x
		sta	<mul16a+1

;(191-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(191-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D1,x	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D1+1,x
		sta	<mul16a+1

		bbs1	<clip2DFlag,.clip2DY255Jump04
;Y0>191 Y1<=191
		lda	<mul16a
		sta	clip2D0,y	;X0
		lda	<mul16a+1
		sta	clip2D0+1,y

		lda	#191
		sta	clip2D0+2,y	;Y0
		lda	#0
		sta	clip2D0+3,y

		inc	<clip2D0Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DY255Jump03

.clip2DY255Jump04:
;Y0<=191 Y1>191
		lda	clip2D1,x	;X0
		sta	clip2D0,y	;X0
		lda	clip2D1+1,x
		sta	clip2D0+1,y

		lda	clip2D1+2,x	;Y0
		sta	clip2D0+2,y	;Y0
		lda	clip2D1+3,x
		sta	clip2D0+3,y

		lda	<mul16a
		sta	clip2D0+4,y	;X1
		lda	<mul16a+1
		sta	clip2D0+5,y

		lda	#191
		sta	clip2D0+6,y	;Y1
		lda	#0
		sta	clip2D0+7,y

		clc
		lda	<clip2D0Count
		adc	#$02
		sta	<clip2D0Count

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DY255Jump03

.clip2DY255Jump02:
;Y0<=191 Y1<=191
		lda	clip2D1,x	;X0
		sta	clip2D0,y	;X0
		lda	clip2D1+1,x
		sta	clip2D0+1,y

		lda	clip2D1+2,x	;Y0
		sta	clip2D0+2,y	;Y0
		lda	clip2D1+3,x
		sta	clip2D0+3,y

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
		beq	.clip2DY255Jump07
		jmp	.clip2DY255Loop0
.clip2DY255Jump07:

		rts


;----------------------------
clip2DY0:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax

		lda	clip2D0		;X0
		sta	clip2D0,x	;last X
		lda	clip2D0+1
		sta	clip2D0+1,x

		lda	clip2D0+2	;Y0
		sta	clip2D0+2,x	;last Y
		lda	clip2D0+3
		sta	clip2D0+3,x

		clx
		cly
		stz	<clip2D1Count

.clip2DY0Loop0:
		stz	<clip2DFlag

		lda	clip2D0+3,x	;Y0
		bpl	.clip2DY0Jump00
		smb0	<clip2DFlag
.clip2DY0Jump00:

		lda	clip2D0+7,x	;Y1
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
		sec
		lda	#0
		sbc	clip2D0+2,x	;Y0
		sta	<mul16a
		lda	#0
		sbc	clip2D0+3,x
		sta	<mul16a+1

;(X1-X0) to mul16b
		sec
		lda	clip2D0+4,x	;X1
		sbc	clip2D0,x	;X0
		sta	<mul16b
		lda	clip2D0+5,x
		sbc	clip2D0+1,x
		sta	<mul16b+1

;(0-Y0)*(X1-X0) to mul16d:mul16c
		jsr	smul16

;(Y1-Y0) to mul16a
		sec
		lda	clip2D0+6,x	;Y1
		sbc	clip2D0+2,x	;Y0
		sta	<mul16a
		lda	clip2D0+7,x
		sbc	clip2D0+3,x
		sta	<mul16a+1

;(0-Y0)*(X1-X0)/(Y1-Y0)
		jsr	sdiv32

;(0-Y0)*(X1-X0)/(Y1-Y0)+X0
		clc
		lda	<mul16a
		adc	clip2D0,x	;X0
		sta	<mul16a
		lda	<mul16a+1
		adc	clip2D0+1,x
		sta	<mul16a+1

		bbs1	<clip2DFlag,.clip2DY0Jump04
;Y0<0 Y1>=0
		lda	<mul16a
		sta	clip2D1,y	;X0
		lda	<mul16a+1
		sta	clip2D1+1,y

		lda	#$00
		sta	clip2D1+2,y	;Y0
		lda	#$00
		sta	clip2D1+3,y

		inc	<clip2D1Count

		clc
		tya
		adc	#$04
		tay

		bra	.clip2DY0Jump03

.clip2DY0Jump04:
;Y0>=0 Y1<0
		lda	clip2D0,x	;X0
		sta	clip2D1,y	;X0
		lda	clip2D0+1,x
		sta	clip2D1+1,y

		lda	clip2D0+2,x	;Y0
		sta	clip2D1+2,y	;Y0
		lda	clip2D0+3,x
		sta	clip2D1+3,y

		lda	<mul16a
		sta	clip2D1+4,y	;X1
		lda	<mul16a+1
		sta	clip2D1+5,y

		lda	#$00
		sta	clip2D1+6,y	;Y1
		lda	#$00
		sta	clip2D1+7,y

		clc
		lda	<clip2D1Count
		adc	#$02
		sta	<clip2D1Count

		clc
		tya
		adc	#$08
		tay

		bra	.clip2DY0Jump03

.clip2DY0Jump02:
;Y0>=0 Y1>=0
		lda	clip2D0,x	;X0
		sta	clip2D1,y	;X0
		lda	clip2D0+1,x
		sta	clip2D1+1,y

		lda	clip2D0+2,x	;Y0
		sta	clip2D1+2,y	;Y0
		lda	clip2D0+3,x
		sta	clip2D1+3,y

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
		beq	.clip2DY0Jump07
		jmp	.clip2DY0Loop0
.clip2DY0Jump07:

		rts


;----------------------------
calcEdge_putPoly:
;
		lda	<clip2D0Count
		asl	a
		asl	a
		tax
		lda	clip2D0
		sta	clip2D0,x
		lda	clip2D0+2
		sta	clip2D0+2,x

		jsr	initCalcEdge
		clx
.calcEdge_putPolyLoop0:
		lda	clip2D0,x
		sta	<edgeX0
		lda	clip2D0+2,x
		sta	<edgeY0
		lda	clip2D0+4,x
		sta	<edgeX1
		lda	clip2D0+6,x
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

		cly
.calcEdge_putPolyLoop2
		lda	edgeCount,y
		bpl	.calcEdge_putPolyJump1
		iny
		bra	.calcEdge_putPolyLoop2

.calcEdge_putPolyLoop1:
		lda	edgeCount,y
		bmi	.calcEdge_putPolyEnd

.calcEdge_putPolyJump1:
		jsr	putPolyLine

.calcEdge_putPolyJump0:
		iny
		bra	.calcEdge_putPolyLoop1

.calcEdge_putPolyEnd:
		rts


;----------------------------
calcEdge:
;calculation edge Y
		sec
		lda	<edgeY1
		sbc	<edgeY0
		beq	.edgeJump6

		sta	<edgeSlopeY
		bcs	.edgeJump7

		eor	#$FF
		inc	a
		sta	<edgeSlopeY

;edgeY0 > edgeY1 exchange X0 X1 Y0 Y1
		lda	<edgeX0
		ldx	<edgeX1
		sta	<edgeX1
		stx	<edgeX0

		lda	<edgeY0
		ldx	<edgeY1
		sta	<edgeY1
		stx	<edgeY0

		bra	.edgeJump7

.edgeJump6:
;edgeY0 = edgeY1
		ldy	<edgeX0
		ldx	<edgeY0

		jsr	setEdgeBuffer
		ldy	<edgeX1
		jsr	setEdgeBuffer
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

		lda	#$FF
		sta	<edgeSigneX

		bra	.edgeJump3

.edgeJump1:
;edgeX0 = edgeX1
		ldy	<edgeX0
		ldx	<edgeY0
.edgeLoop0:
		jsr	setEdgeBuffer
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
		bcs	.edgeJump4

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
		jsr	setEdgeBuffer
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
		jsr	setEdgeBuffer
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
		jsr	setEdgeBuffer
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
		jsr	setEdgeBuffer
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
setEdgeBuffer:
;set edge buffer
		lda	edgeCount,x

		beq	.setEdgeBufferJump0	;count 1
		bpl	.setEdgeBufferJump1	;count 2

;count 0
		tya
		sta	edgeLeft,x
		inc	edgeCount,x
		rts

;count 1
.setEdgeBufferJump0:
		tya
		cmp	edgeLeft,x
		bcs	.setEdgeBufferJump4	;a >= edgeLeft,x

		lda	edgeLeft,x
		sta	edgeRight,x
		tya
		sta	edgeLeft,x

		inc	edgeCount,x
		rts

.setEdgeBufferJump4:
		sta	edgeRight,x
		inc	edgeCount,x
		rts

;count 2
.setEdgeBufferJump1:
		tya
		cmp	edgeLeft,x
		bcs	.setEdgeBufferJump3	;a >= edgeLeft,x
		sta	edgeLeft,x
		rts

.setEdgeBufferJump3:
		cmp	edgeRight,x
		bcc	.setEdgeBufferJump2	;a < edgeRight,x
		sta	edgeRight,x

.setEdgeBufferJump2:
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

;set poly color
		tya
		and	#$01
		ora	<polyLineColorNo
		tax

		lda	polyLineColorData0,x
		sta	<polyLineColorDataWork0

		lda	polyLineColorData1,x
		sta	<polyLineColorDataWork1

		lda	polyLineColorData2,x
		sta	<polyLineColorDataWork2

		lda	polyLineColorData3,x
		sta	<polyLineColorDataWork3

;calation vram address
;left
		ldx	edgeLeft,y
		lda	polyLineAddrConvYLow0,y
		ora	polyLineAddrConvXLow0,x
		sta	<polyLineLeftAddr

		lda	polyLineAddrConvYHigh0,y
		ora	polyLineAddrConvXHigh0,x
		sta	<polyLineLeftAddr+1

		lda	polyLineAddrConvYBank,y
		tam	#$02

		lda	polyLineAddrConvX,x
		sta	<polyLineCount

		lda	polyLineAddrConvXShift,x
		tax
		lda	polyLineLeftDatas,x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

;right
		ldx	edgeRight,y

		sec
		lda	polyLineAddrConvX,x
		sbc	<polyLineCount
		beq	.polyLineJump03
		sta	<polyLineCount

		lda	polyLineAddrConvXShift,x
		tax
		lda	polyLineRightDatas,x
		sta	<polyLineRightData
		eor	#$FF
		sta	<polyLineRightMask

		jsr	putPolyLine01Left
		phy
		jsr	putPolyLine00
		jsr	putPolyLine01Right
		ply

		rts

.polyLineJump03:
		lda	polyLineAddrConvXShift,x
		tax
		lda	<polyLineLeftData
		and	polyLineRightDatas,x
		sta	<polyLineLeftData
		eor	#$FF
		sta	<polyLineLeftMask

		jsr	putPolyLine01Left

.polyLineJump04:
		rts


;----------------------------
putPolyLine01Left:
;put left poly line
		lda	<polyLineColorDataWork0
		and	<polyLineLeftData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr]
		and	<polyLineLeftMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr]

		inc	<polyLineLeftAddr

		lda	<polyLineColorDataWork1
		and	<polyLineLeftData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr]
		and	<polyLineLeftMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr]

		clc
		lda	<polyLineLeftAddr
		adc	#$0F
		sta	<polyLineLeftAddr

		lda	<polyLineColorDataWork2
		and	<polyLineLeftData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr]
		and	<polyLineLeftMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr]

		inc	<polyLineLeftAddr

		lda	<polyLineColorDataWork3
		and	<polyLineLeftData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr]
		and	<polyLineLeftMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr]

		rts


;----------------------------
putPolyLine01Right:
;put right poly line
		lda	<polyLineColorDataWork0
		and	<polyLineRightData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr],y
		and	<polyLineRightMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr],y

		iny

		lda	<polyLineColorDataWork1
		and	<polyLineRightData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr],y
		and	<polyLineRightMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr],y

		clc
		tya
		adc	#$0F
		tay

		lda	<polyLineColorDataWork2
		and	<polyLineRightData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr],y
		and	<polyLineRightMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr],y

		iny

		lda	<polyLineColorDataWork3
		and	<polyLineRightData
		sta	<polyLineColorDataWork

		lda	[polyLineLeftAddr],y
		and	<polyLineRightMask
		ora	<polyLineColorDataWork
		sta	[polyLineLeftAddr],y

		rts


;----------------------------
putPolyLine00:
;put left to right poly line
		lda	<polyLineLeftAddr
		adc	#$0F
		tay
		bcc	.putPolyLine00Jump0
		inc	<polyLineLeftAddr+1
.putPolyLine00Jump0:
		stz	<polyLineLeftAddr

		lda	<polyLineCount
		asl	a
		tax
		jmp	[putPolyJumpAddr, x]

putPolyLine30:
		putPolyLine00m
putPolyLine29:
		putPolyLine00m
putPolyLine28:
		putPolyLine00m
putPolyLine27:
		putPolyLine00m
putPolyLine26:
		putPolyLine00m
putPolyLine25:
		putPolyLine00m
putPolyLine24:
		putPolyLine00m
putPolyLine23
		putPolyLine00m
putPolyLine22:
		putPolyLine00m
putPolyLine21:
		putPolyLine00m

putPolyLine20:
		putPolyLine00m
putPolyLine19:
		putPolyLine00m
putPolyLine18:
		putPolyLine00m
putPolyLine17:
		putPolyLine00m
putPolyLine16:
		putPolyLine00m
putPolyLine15:
		putPolyLine00m
putPolyLine14:
		putPolyLine00m
putPolyLine13
		putPolyLine00m
putPolyLine12:
		putPolyLine00m
putPolyLine11:
		putPolyLine00m

putPolyLine10:
		putPolyLine00m
putPolyLine09:
		putPolyLine00m
putPolyLine08:
		putPolyLine00m
putPolyLine07:
		putPolyLine00m
putPolyLine06:
		putPolyLine00m
putPolyLine05:
		putPolyLine00m
putPolyLine04:
		putPolyLine00m
putPolyLine03
		putPolyLine00m
putPolyLine02:
		putPolyLine00m
putPolyLine01:
		putPolyLine00m

putPolyLineEnd:
		rts


;----------------------------
clearRam:
;
		lda	#$F9
		tam	#$02
		tii	clearRamData0, $4000, $20
		tii	$4000, $4020, $2000-$20

		lda	#$FA
		tam	#$02
		tii	clearRamData0, $4000, $20
		tii	$4000, $4020, $1000-$20
		tii	clearRamData1, $5000, $20
		tii	$5000, $5020, $1000-$20

		lda	#$FB
		tam	#$02
		tii	clearRamData1, $4000, $20
		tii	$4000, $4020, $2000-$20

		rts


;----------------------------
ramToChar:
;move ram to vram
		lda	#$F9
		tam	#$02

		sei
		st0	#$00
		st1	#$00
		st2	#$20
		st0	#$02
		tia	$4000, $0002, $2000
		cli

		lda	#$FA
		tam	#$02

		sei
		st0	#$00
		st1	#$00
		st2	#$30
		st0	#$02
		tia	$4000, $0002, $2000
		cli

		lda	#$FB
		tam	#$02

		sei
		st0	#$00
		st1	#$00
		st2	#$40
		st0	#$02
		tia	$4000, $0002, $2000
		cli

		rts


;----------------------------
setBAT:
;set BAT
		stz	setBatWork
		lda	#$02
		sta	setBatWork+1

		st0	#$00
		st1	#$00
		st2	#$00
		st0	#$02

		ldy	#24
.setBatLoop0:
		ldx	#32
.setBatLoop1:
		lda	setBatWork
		sta	$0002
		lda	setBatWork+1
		sta	$0003

		clc
		lda	setBatWork
		adc	#1
		sta	setBatWork
		bcc	.setBatJump0
		inc	setBatWork+1

.setBatJump0:
		dex
		bne	.setBatLoop1
		dey
		bne	.setBatLoop0

		rts


;////////////////////////////
		.bank	2

		.org	$C000

;----------------------------
putPolyJumpAddr:
			dw	putPolyLineEnd
			dw	putPolyLineEnd

			dw	putPolyLine01
			dw	putPolyLine02
			dw	putPolyLine03
			dw	putPolyLine04
			dw	putPolyLine05
			dw	putPolyLine06
			dw	putPolyLine07
			dw	putPolyLine08
			dw	putPolyLine09

			dw	putPolyLine10
			dw	putPolyLine11
			dw	putPolyLine12
			dw	putPolyLine13
			dw	putPolyLine14
			dw	putPolyLine15
			dw	putPolyLine16
			dw	putPolyLine17
			dw	putPolyLine18
			dw	putPolyLine19

			dw	putPolyLine20
			dw	putPolyLine21
			dw	putPolyLine22
			dw	putPolyLine23
			dw	putPolyLine24
			dw	putPolyLine25
			dw	putPolyLine26
			dw	putPolyLine27
			dw	putPolyLine28
			dw	putPolyLine29

			dw	putPolyLine30


;----------------------------
clearRamData0:
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
clearRamData1:
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
divbankdata:
		.db	$14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14,\
			$14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14,\
			$15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15,\
			$15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15,\
			$16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16,\
			$16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16,\
			$17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17,\
			$17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17


;----------------------------
polyLineAddrConvYBank:
		.db	$F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9,\
			$F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9,\
			$F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9,\
			$F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9, $F9,\
			$FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA,\
			$FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA,\
			$FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA,\
			$FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA, $FA,\
			$FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB,\
			$FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB,\
			$FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB,\
			$FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB, $FB,\
			$FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC,\
			$FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC,\
			$FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC,\
			$FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC


;----------------------------
polyLineAddrConvYHigh0:
		.db	$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C,\
			$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C,\
			$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C,\
			$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C,\
			$40, $40, $40, $40, $40, $40, $40, $40, $44, $44, $44, $44, $44, $44, $44, $44,\
			$48, $48, $48, $48, $48, $48, $48, $48, $4C, $4C, $4C, $4C, $4C, $4C, $4C, $4C,\
			$50, $50, $50, $50, $50, $50, $50, $50, $54, $54, $54, $54, $54, $54, $54, $54,\
			$58, $58, $58, $58, $58, $58, $58, $58, $5C, $5C, $5C, $5C, $5C, $5C, $5C, $5C


;----------------------------
polyLineAddrConvYLow0:
		.db	$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E,\
			$00, $02, $04, $06, $08, $0A, $0C, $0E, $00, $02, $04, $06, $08, $0A, $0C, $0E


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
polyLineAddrConvXShift:
		.db	$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07,\
			$00, $01, $02, $03, $04, $05, $06, $07, $00, $01, $02, $03, $04, $05, $06, $07


;----------------------------
polyLineLeftDatas:
		.db	$FF, $7F, $3F, $1F, $0F, $07, $03, $01


;----------------------------
polyLineRightDatas:
		.db	$80, $C0, $E0, $F0, $F8, $FC, $FE, $FF


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
		INCBIN	"div.dat"		;   64K 20~27 $14~$1B
