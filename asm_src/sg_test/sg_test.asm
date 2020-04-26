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

charDataBank		.equ	$01
spXYDataBank		.equ	$02
spBankDataBank		.equ	$22
spNoDataBank		.equ	$23
spDataBank		.equ	$24
stageBank		.equ	$29


;----------------------------
jcc		.macro
		bcs	.jp\@
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

		clc
		lda	\2
		adc	\3
		sta	\1

		lda	\2+1
		adc	\3+1
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
		.endm


;----------------------------
subw		.macro
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

		.else

		sec
		lda	\1
		sbc	\2
		sta	\1

		lda	\1+1
		sbc	\2+1
		sta	\1+1

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
		lda	\2
		sta	\1
		lda	\2+1
		sta	\1+1

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


		.zp
;///////////////////////////////////////////////
		.org	$2000
;-----------------------------------------------
spDataWorkX		.ds	2
spDataWorkY		.ds	2

spDataWorkBGX		.ds	1
spDataWorkBGY		.ds	1

spDataWorkNo		.ds	2
spDataWorkAttr		.ds	2
spDataAddr		.ds	2
spDataAddrWork		.ds	2
spDataCount		.ds	1
spDataCountWork		.ds	1

spCharWorkAddr		.ds	2

bgDataWorkAddr		.ds	2

screenAngle		.ds	1
screenAngle2		.ds	1

vsyncFlag		.ds	1

bgCenterSpXPoint	.ds	1
bgCenterSpX		.ds	1
bgCenterX		.ds	1

bgCenterSpYPoint	.ds	1
bgCenterSpY		.ds	1
bgCenterY		.ds	1

bgCenterSpXAdjust	.ds	1
bgCenterSpYAdjust	.ds	1

bgCenterSpXPointLast	.ds	1
bgCenterSpXLast		.ds	1
bgCenterXLast		.ds	1

bgCenterSpYPointLast	.ds	1
bgCenterSpYLast		.ds	1
bgCenterYLast		.ds	1

bgCalcCenterSpX		.ds	1
bgCalcCenterX		.ds	1
bgCalcCenterSpY		.ds	1
bgCalcCenterY		.ds	1

angleCheckWork		.ds	1

bgBank			.ds	1

hitFlag			.ds	1

scrollWork		.ds	1

bgCenterMovement	.ds	2

ballSpeed		.ds	2
ballSpeedWork		.ds	2

setBgWork		.ds	2

;---------------------
;LDRU SsBA
padlast			.ds	1
padnow			.ds	1
padstate		.ds	1
;---------------------
vdpstatus		.ds	1
;---------------------
mul16a			.ds	2
mul16b			.ds	2
mul16c			.ds	2
mul16d			.ds	2
;---------------------
puthexaddr		.ds	2
puthexdata		.ds	1
;---------------------
rotationAngle		.ds	1
rotationX		.ds	2
rotationY		.ds	2
rotationAnsX		.ds	4
rotationAnsY		.ds	4


		.bss
;///////////////////////////////////////////////
		.org 	$2100
;stack area
;-----------------------------------------------


;///////////////////////////////////////////////
		.org 	$2200
;-----------------------------------------------
spAttrWork		.ds	32
hitWorkNo		.ds	32
hitWorkSpX		.ds	32
hitWorkSpY		.ds	32
hitWorkX		.ds	1

hitWorkFlag		.ds	8

tiafunc			.ds	8
tiifunc			.ds	8


;///////////////////////////////////////////////

		.code
		.bank	0
		.org	$E000
;----------------------------
main:
;initialize
		jsr	initializeVdp
		jsr	setCharData

;++++++++++++++++++++++++++++
;set tiafunc tiifunc
		lda	#$E3;		tia
		sta	tiafunc

		lda	#$73;		tii
		sta	tiifunc

		lda	#$60;		rts
		sta	tiafunc+7
		sta	tiifunc+7

;++++++++++++++++++++++++++++
;set bg0 char
		stz	VPC_6		;reg6 select VDC#1
		st0	#$00		;VRAM $0000
		st1	#$00
		st2	#$00
		st0	#$02

		ldy	#4 * 32
.setBg0Loop2:
		st1	#$01
		st2	#$01
		dey
		bne	.setBg0Loop2

		ldy	#30 - 4 * 2
.setBg0Loop0:
		clx
.setBg0Loop1:
		lda	bg0data,x
		sta	VDC1_2
		st2	#$01
		inx
		cpx	#32
		bne	.setBg0Loop1
		dey
		bne	.setBg0Loop0

		ldy	#4 * 32
.setBg0Loop3:
		st1	#$01
		st2	#$01
		dey
		bne	.setBg0Loop3

;++++++++++++++++++++++++++++
;set bg1 char
		lda	#$01
		sta	VPC_6		;reg6 select VDC#2

		st0	#$00		;VRAM $0000
		st1	#$00
		st2	#$00
		st0	#$02

		ldx	#4

		lda	#LOW(bg1data)
		sta	<setBgWork
		lda	#HIGH(bg1data)
		sta	<setBgWork+1
.setBg1Loop0:
		cly
.setBg1Loop1:
		lda	[setBgWork], y
		sta	VDC2_2
		st2	#$01
		iny
		bne	.setBg1Loop1
		inc	<setBgWork+1
		dex
		bne	.setBg1Loop0

;++++++++++++++++++++++++++++
;set sp ball char
		stz	VPC_6		;reg6 select VDC#1

		st0	#$00		;VRAM $0500
		st1	#$00
		st2	#$05

		st0	#$02
		tia	spballdata, VDC1_2, 128

;++++++++++++++++++++++++++++
;initialize data
		lda	#128
		sta	<screenAngle

		lda	#5
		sta	<bgCenterX
		lda	#24
		sta	<bgCenterY

		lda	#6
		sta	<bgCenterSpX
		lda	#6
		sta	<bgCenterSpY

		stz	bgCenterSpXPoint
		stz	bgCenterSpYPoint

		stz	<bgCenterMovement
		stz	<bgCenterMovement+1

		stz	<ballSpeed
		stz	<ballSpeed+1

		lda	#stageBank
		sta	<bgBank

		stz	<scrollWork


;++++++++++++++++++++++++++++
;clear vsync flag
		rmb7	<vsyncFlag
		cli

;++++++++++++++++++++++++++++
.mainloop:
;wait vsync
		bbs7	<vsyncFlag, .mainloop

;++++++++++++++++++++++++++++
;check pad rotation
		bbs5	<padnow, .checkPadLeft
		bbs7	<padnow, .checkPadRight
		bra	.checkPadEnd

.checkPadLeft:
		inc	<screenAngle
		inc	<screenAngle
		bra	.checkPadEnd

.checkPadRight:
		dec	<screenAngle
		dec	<screenAngle
		;bra	.checkPadEnd

.checkPadEnd:
		lda	<screenAngle
		eor	#$80
		sta	<screenAngle2

;++++++++++++++++++++++++++++
;move down
		stz	<bgCenterMovement
		lda	#1
		sta	<bgCenterMovement+1

		lda	<ballSpeed+1
		sta	<ballSpeedWork+1
.moveDownLoop0:
		beq	.moveDownJump0
		jsr	moveDown
		beq	.moveDownJump1
		bcs	.moveDownJump1
		dec	<ballSpeedWork+1
		bra	.moveDownLoop0
.moveDownJump0:
		lda	<ballSpeed
		sta	<bgCenterMovement
		stz	<bgCenterMovement+1
		jsr	moveDown
		beq	.moveDownJump1
		bcs	.moveDownJump1
		bra	.moveDownJump2
.moveDownJump1:
		stz	<ballSpeed
		stz	<ballSpeed+1
.moveDownJump2:

;++++++++++++++++++++++++++++
;angle bgCenter put
		ldx	#0
		ldy	#2
		lda	<screenAngle
		jsr	puthex

		ldx	#0
		ldy	#3
		lda	<bgCenterX
		jsr	puthex

		ldx	#2
		ldy	#3
		lda	<bgCenterSpX
		jsr	puthex

		ldx	#6
		ldy	#3
		lda	<bgCenterY
		jsr	puthex

		ldx	#8
		ldy	#3
		lda	<bgCenterSpY
		jsr	puthex

;++++++++++++++++++++++++++++
;set center adjust
		lda	<screenAngle2
		sta	<rotationAngle

		stz	<rotationX
		lda	<bgCenterSpX
		sta	<rotationX+1

		stz	<rotationY
		lda	<bgCenterSpY
		sta	<rotationY+1

		jsr	rotationProc

		lda	<rotationAnsX+2
		sta	<bgCenterSpXAdjust

		lda	<rotationAnsY+2
		sta	<bgCenterSpYAdjust

;++++++++++++++++++++++++++++
;set sp char data
		stz	VPC_6		;reg6 select VDC#1

		st0	#$00		;VRAM $4000
		st1	#$00
		st2	#$40

		st0	#$02

		lda	#$01
		sta	VPC_6		;reg6 select VDC#2

		st0	#$00		;VRAM $4000
		st1	#$00
		st2	#$40

		st0	#$02

;++++++++++++++++++++++++++++
;sp bank data
		lda	#spBankDataBank
		tam	#$02		;Set $4000

		stz	<spCharWorkAddr
		lda	<screenAngle2
		lsr	a
		ror	<spCharWorkAddr
		lsr	a
		ror	<spCharWorkAddr
		lsr	a
		ror	<spCharWorkAddr
		ora	#$40
		sta	<spCharWorkAddr+1

		cly

.setSpCharLoop0:
		lda	[spCharWorkAddr], y
		cmp	#$FF
		beq	.setSpCharEnd

		clc
		adc	#spDataBank
		tam	#$03		;Set $6000
		iny

		lda	[spCharWorkAddr], y
		sta	tiafunc+1
		iny
		lda	[spCharWorkAddr], y
		ora	#$60
		sta	tiafunc+2
		iny

		lda	#LOW(VDC1_2)
		sta	tiafunc+3
		lda	#HIGH(VDC1_2)
		sta	tiafunc+4

		lda	#$80
		sta	tiafunc+5
		lda	#$00
		sta	tiafunc+6
		jsr	tiafunc

		lda	#LOW(VDC2_2)
		sta	tiafunc+3
		lda	#HIGH(VDC2_2)
		sta	tiafunc+4
		jsr	tiafunc

		iny
		cpy	#$20
		bne	.setSpCharLoop0

.setSpCharEnd:

;++++++++++++++++++++++++++++
;set sp xy data
		lda	<screenAngle2
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	#spXYDataBank
		tam	#$02		;Set $4000

		lda	<screenAngle2
		and	#$07
		asl	a
		asl	a
		ora	#$40
		stz	<spDataAddrWork
		sta	<spDataAddrWork+1

;++++++++++++++++++++++++++++
;sp attr data
		lda	#spNoDataBank
		tam	#$03		;Set $6000

		stz	tiifunc+1
		lda	<screenAngle2
		lsr	a
		ror	tiifunc+1
		lsr	a
		ror	tiifunc+1
		lsr	a
		ror	tiifunc+1
		ora	#$60
		sta	tiifunc+2

		lda	#LOW(spAttrWork)
		sta	tiifunc+3
		lda	#HIGH(spAttrWork)
		sta	tiifunc+4

		lda	#$20
		sta	tiifunc+5
		lda	#$00
		sta	tiifunc+6
		jsr	tiifunc

;++++++++++++++++++++++++++++
;SP LEFT
		stz	VPC_6		;reg6 select VDC#1

;center ball
		st0	#$00		;VRAM $0400
		st1	#$00
		st2	#$04

		st0	#$02

		st1	#120 + 64 - 8
		st2	#$00

		st1	#128 + 32 - 8
		st2	#$00

		st1	#$28
		st2	#$00

		st1	#$00
		st2	#$00

		lda	<spDataAddrWork	;Set SPXYDATA LEFT ADDR
		sta	<spDataAddr
		lda	<spDataAddrWork+1
		sta	<spDataAddr+1

		lda	#63
		sta	<spDataCount

;SpData 256(angles) * 128(datas) * 4(bytes) * 2(left and right) = 256K
		cly
.spLDataLoop0:
		lda	[spDataAddr], y
		cmp	#$FF
		jeq	.spLDataJump3

.spLDataJump5:
		sta	<spDataWorkX
		stz	<spDataWorkX+1
		iny

		lda	[spDataAddr], y
		sta	<spDataWorkY
		stz	<spDataWorkY+1
		iny

		lda	[spDataAddr], y
		clc
		adc	<bgCenterX
		sta	<spDataWorkBGX
		iny

		lda	[spDataAddr], y
		clc
		adc	<bgCenterY
		sta	<spDataWorkBGY
		iny

		bne	.spLDataJump0
		inc	<spDataAddr+1

.spLDataJump0:
;check bg
		mov	<bgCalcCenterX, <spDataWorkBGX
		mov	<bgCalcCenterY, <spDataWorkBGY

		jsr	getBgData
		beq	.spLDataLoop0

		dec	a
		asl	a
		tax

;sp x
		sec
		lda	<spDataWorkX
		sbc	bgCenterSpXAdjust

		cmp	#8*8+1
		bcc	.spLDataLoop0

		sta	<spDataWorkX

		clc
		lda	<spDataWorkX
		adc	#32
		sta	<spDataWorkX
		bcc	.spLDataJump1
		inc	<spDataWorkX+1

.spLDataJump1:
;sp y
		sec
		lda	<spDataWorkY
		sbc	bgCenterSpYAdjust

		cmp	#8*26
		bcs	.spLDataLoop0

		sta	<spDataWorkY

		clc
		lda	<spDataWorkY
		adc	#64
		sta	<spDataWorkY
		bcc	.spLDataJump2
		inc	<spDataWorkY+1

.spLDataJump2:
		lda	<spDataWorkY
		sta	VDC1_2
		lda	<spDataWorkY+1
		sta	VDC1_3

		lda	<spDataWorkX
		sta	VDC1_2
		lda	<spDataWorkX+1
		sta	VDC1_3

		lda	spAttrWork, x	;No
		sta	VDC1_2
		lda	#$02
		sta	VDC1_3

		lda	spAttrWork+1, x	;ATTR
		stz	VDC1_2
		sta	VDC1_3

		dec	<spDataCount
		beq	.spLDataJump4
		jmp	.spLDataLoop0

.spLDataJump3:
		lda	<spDataCount
		sta	<spDataCountWork

.spLDataJump3B:
		st1	#$00		;Y
		st2	#$00
		st1	#$00		;X
		st2	#$00
		st1	#$00		;No
		st2	#$00
		st1	#$00		;ATTR
		st2	#$00

		dec	<spDataCount
		bne	.spLDataJump3B
		bra	.spLDataJump4B

.spLDataJump4:
		stz	<spDataCountWork

.spLDataJump4B:
;put left sp count
		ldx	#0
		ldy	#5
		lda	<spDataCountWork
		jsr	puthex

;++++++++++++++++++++++++++++
;SP RIGHT
		lda	#$01
		sta	VPC_6		;reg6 select VDC#2

		st0	#$00		;VRAM $0404
		st1	#$04
		st2	#$04

		st0	#$02

		lda	<spDataAddrWork	;Set SPXYDATA RIGHT ADDR
		sta	<spDataAddr
		lda	<spDataAddrWork+1
		ora	#$02
		sta	<spDataAddr+1

		lda	#63
		sta	<spDataCount

		cly
.spRDataLoop0:
		lda	[spDataAddr], y
		cmp	#$FF
		jeq	.spRDataJump3

.spRDataJump5:
		sta	<spDataWorkX
		stz	<spDataWorkX+1
		iny

		lda	[spDataAddr], y
		sta	<spDataWorkY
		stz	<spDataWorkY+1
		iny

		lda	[spDataAddr], y
		clc
		adc	<bgCenterX
		sta	<spDataWorkBGX
		iny

		lda	[spDataAddr], y
		clc
		adc	<bgCenterY
		sta	<spDataWorkBGY
		iny

		bne	.spRDataJump0
		inc	<spDataAddr+1

.spRDataJump0:
;check bg
		mov	<bgCalcCenterX, <spDataWorkBGX
		mov	<bgCalcCenterY, <spDataWorkBGY

		jsr	getBgData
		beq	.spRDataLoop0

		dec	a
		asl	a
		tax

;sp x
		sec
		lda	<spDataWorkX
		sbc	bgCenterSpXAdjust

		cmp	#8*22
		bcs	.spRDataLoop0

		sta	<spDataWorkX

		clc
		lda	<spDataWorkX
		adc	#32
		sta	<spDataWorkX
		bcc	.spRDataJump1
		inc	<spDataWorkX+1

.spRDataJump1:
;sp y
		sec
		lda	<spDataWorkY
		sbc	bgCenterSpYAdjust

		cmp	#8*26
		bcs	.spRDataLoop0

		sta	<spDataWorkY

		clc
		lda	<spDataWorkY
		adc	#64
		sta	<spDataWorkY
		bcc	.spRDataJump2
		inc	<spDataWorkY+1

.spRDataJump2:
		lda	<spDataWorkY
		sta	VDC2_2
		lda	<spDataWorkY+1
		sta	VDC2_3

		lda	<spDataWorkX
		sta	VDC2_2
		lda	<spDataWorkX+1
		sta	VDC2_3

		lda	spAttrWork, x	;No
		sta	VDC2_2
		lda	#$02
		sta	VDC2_3

		lda	#$80		;ATTR
		sta	VDC2_2
		lda	spAttrWork+1, x	;ATTR
		sta	VDC2_3

		dec	<spDataCount
		beq	.spRDataJump4
		jmp	.spRDataLoop0

.spRDataJump3:
		lda	<spDataCount
		sta	<spDataCountWork

.spRDataJump3B:
		st1	#$00		;Y
		st2	#$00
		st1	#$00		;X
		st2	#$00
		st1	#$00		;No
		st2	#$00
		st1	#$00		;ATTR
		st2	#$00

		dec	<spDataCount
		bne	.spRDataJump3B
		bra	.spRDataJump4B

.spRDataJump4:
		stz	<spDataCountWork

.spRDataJump4B:
;put right sp count
		ldx	#4
		ldy	#5
		lda	<spDataCountWork
		jsr	puthex

;++++++++++++++++++++++++++++
;SATB DMA set
		stz	VPC_6		;reg6 select VDC#1

		st0	#$13
		st1	#$00
		st2	#$04

		lda	#$01
		sta	VPC_6		;reg6 select VDC#2

		st0	#$13
		st1	#$00
		st2	#$04

;++++++++++++++++++++++++++++
;set vsync flag
		smb7	<vsyncFlag

;++++++++++++++++++++++++++++
;add movement
		lda	<ballSpeed+1
		cmp	#2
		beq	.addMovementJump

		inc	<ballSpeed
		inc	<ballSpeed
		bne	.addMovementJump
		inc	<ballSpeed+1
.addMovementJump:

;++++++++++++++++++++++++++++
;jump mainloop
		jmp	.mainloop


;----------------------------
setCharData:
;CHAR set to vram
		;lda	#$01
		lda	#charDataBank
		tam	#$02

;vram address $1000
		stz	VPC_6	;reg6 select VDC#1

		st0	#$00
		st1	#$00
		st2	#$10

		st0	#$02
		tia	$4000, VDC1_2, $2000

		lda	#$01
		sta	VPC_6	;reg6 select VDC#2

		st0	#$00
		st1	#$00
		st2	#$10

		st0	#$02
		tia	$4000, VDC2_2, $2000

		rts


;----------------------------
initializeVdp:
;set vdp
		lda	VDC1_0
		lda	VDC2_0
vdpdataloop:	lda	vdpdata, y
		cmp	#$FF
		beq	vdpdataend
		sta	VDC1_0
		sta	VDC2_0
		iny

		lda	vdpdata, y
		sta	VDC1_2
		sta	VDC2_2
		iny

		lda	vdpdata, y
		sta	VDC1_3
		sta	VDC2_3
		iny
		bra	vdpdataloop
vdpdataend:

;set vpc
		lda	#$33
		sta	VPC_0	;reg0
		sta	VPC_1	;reg1

		stz	VPC_2	;reg2
		stz	VPC_3	;reg3
		stz	VPC_4	;reg4
		stz	VPC_5	;reg5

		stz	VPC_6	;reg6 select VDC#1

;disable interrupts TIQD       IRQ2D
		lda	#$05
		sta	INT_DIS_REG

;262Line  VCE Clock 5MHz
		lda	#$04
		sta	VCE_0

;set palette
		stz	VCE_2
		stz	VCE_3
		tia	bgpalettedata, VCE_4, $20

		stz	VCE_2
		lda	#$01
		sta	VCE_3
		tia	sppalettedata, VCE_4, $20

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

;screen on
;VDC#1
;bg sp       vsync
;+1
		st0	#$05
		st1	#$C8
		st2	#$00
;VDC#2
;bg sp
;+1
		lda	#$05
		sta	VDC2_0
		lda	#$C0
		sta	VDC2_2
		stz	VDC2_3

		rts


;----------------------------
moveDown:
;move down
		movw	<bgCenterSpXPointLast, <bgCenterSpXPoint
		mov	<bgCenterXLast, <bgCenterX

		movw	<bgCenterSpYPointLast, <bgCenterSpYPoint
		mov	<bgCenterYLast, <bgCenterY

		lda	<screenAngle
;hit check2C2
		jsr	hitCheck2C2
		jcc	.hitCheckEnd

;---------------------------
.hitCheckJumpTOP:
		lda	hitWorkFlag
		beq	.hitCheckJumpTOP_RIGHT

		cmp	#$08
		jeq	.hitCheckJumpTOP_LEFT1

.hitCheckJumpTOP1:
		cmp	#$01
		beq	.hitCheckJumpTOP_RIGHT1

		lda	<screenAngle
		ldx	#0
		jsr	angleCheck2C
		beq	.hitCheckJumpTOP0
		jsr	hitCheck2C2

.hitCheckJumpTOP0:
		jmp	.hitCheckEnd
;---------------------------
.hitCheckJumpTOP_RIGHT:
		lda	hitWorkFlag+1
		beq	.hitCheckJumpRIGHT

.hitCheckJumpTOP_RIGHT1:
		lda	<screenAngle
		ldx	#224
		jsr	angleCheck2C2
		beq	.hitCheckJumpTOP_RIGHT0
		jsr	hitCheck2C2

.hitCheckJumpTOP_RIGHT0:
		jmp	.hitCheckEnd
;---------------------------
.hitCheckJumpRIGHT:
		lda	hitWorkFlag+2
		beq	.hitCheckJumpBOTTOM_RIGHT

		cmp	#$08
		beq	.hitCheckJumpTOP_RIGHT1

		cmp	#$01
		beq	.hitCheckJumpBOTTOM_RIGHT1

		lda	<screenAngle
		ldx	#192
		jsr	angleCheck2C
		beq	.hitCheckJumpRIGHT0
		jsr	hitCheck2C2

.hitCheckJumpRIGHT0:
		jmp	.hitCheckEnd
;---------------------------
.hitCheckJumpBOTTOM_RIGHT:
		lda	hitWorkFlag+3
		beq	.hitCheckJumpBOTTOM

.hitCheckJumpBOTTOM_RIGHT1:
		lda	<screenAngle
		ldx	#160
		jsr	angleCheck2C2
		beq	.hitCheckJumpBOTTOM_RIGHT0
		jsr	hitCheck2C2

.hitCheckJumpBOTTOM_RIGHT0:
		bra	.hitCheckEnd
;---------------------------
.hitCheckJumpBOTTOM:
		lda	hitWorkFlag+4
		beq	.hitCheckJumpBOTTOM_LEFT

		cmp	#$08
		beq	.hitCheckJumpBOTTOM_LEFT1

		cmp	#$01
		beq	.hitCheckJumpBOTTOM_RIGHT1

		lda	<screenAngle
		ldx	#128
		jsr	angleCheck2C
		beq	.hitCheckJumpBOTTOM0
		jsr	hitCheck2C2

.hitCheckJumpBOTTOM0:
		bra	.hitCheckEnd
;---------------------------
.hitCheckJumpBOTTOM_LEFT:
		lda	hitWorkFlag+5
		beq	.hitCheckJumpLEFT

.hitCheckJumpBOTTOM_LEFT1:
		lda	<screenAngle
		ldx	#96
		jsr	angleCheck2C2
		beq	.hitCheckJumpBOTTOM_LEFT0
		jsr	hitCheck2C2

.hitCheckJumpBOTTOM_LEFT0:
		bra	.hitCheckEnd
;---------------------------
.hitCheckJumpLEFT:
		lda	hitWorkFlag+6
		beq	.hitCheckJumpTOP_LEFT

		cmp	#$08
		beq	.hitCheckJumpTOP_LEFT1

		cmp	#$01
		beq	.hitCheckJumpBOTTOM_LEFT1

		lda	<screenAngle
		ldx	#64
		jsr	angleCheck2C
		beq	.hitCheckJumpLEFT0
		jsr	hitCheck2C2

.hitCheckJumpLEFT0:
		bra	.hitCheckEnd
;---------------------------
.hitCheckJumpTOP_LEFT:
		lda	hitWorkFlag+7
		beq	.hitCheckEnd

.hitCheckJumpTOP_LEFT1:
		lda	<screenAngle
		ldx	#32
		jsr	angleCheck2C2
		beq	.hitCheckJumpTOP_LEFT0
		jsr	hitCheck2C2

.hitCheckJumpTOP_LEFT0:
;---------------------------
.hitCheckEnd:
		rts


;----------------------------
angleCheck2C2:
;reg A:angle
;reg X:base angle
		stx	<angleCheckWork
		sec
		sbc	<angleCheckWork
		clc
		adc	#128
		cmp	#128
		php
		bcc	.angleCheck2C2Jump0

		txa
		sec
		sbc	#224
		clc
		adc	#64
		bra	.angleCheck2C2Jump1

.angleCheck2C2Jump0:
		txa
		sec
		sbc	#224
		clc
		adc	#128

.angleCheck2C2Jump1:
		plp
		rts


;----------------------------
angleCheck2C:
;reg A:angle
;reg X:base angle
		stx	<angleCheckWork
		sec
		sbc	<angleCheckWork
		clc
		adc	#128
		cmp	#128
		php
		bcc	.angleCheck2CJump0

		txa
		clc
		adc	#64
		bra	.angleCheck2CJump1

.angleCheck2CJump0:
		txa
		clc
		adc	#192

.angleCheck2CJump1:
		plp
		rts


;----------------------------
hitCheck2C2:
		pha

		movw	<bgCenterSpXPoint, <bgCenterSpXPointLast
		mov	<bgCenterX, <bgCenterXLast

		movw	<bgCenterSpYPoint, <bgCenterSpYPointLast
		mov	<bgCenterY, <bgCenterYLast

		pla

		jsr	calcMoveCenter2
		jsr	hitCheck2C
		bcc	.hitCheck2C2End

		movw	<bgCenterSpXPoint, <bgCenterSpXPointLast
		mov	<bgCenterX, <bgCenterXLast

		movw	<bgCenterSpYPoint, <bgCenterSpYPointLast
		mov	<bgCenterY, <bgCenterYLast

		sec

.hitCheck2C2End:
		lda	#1
		rts


;----------------------------
hitCheck2C:
;hit check
;multi hit check 28point

		rmb7	<hitFlag
		clx
.hitCheck2BLoop:
		movw	<bgCalcCenterSpX, <bgCenterSpX
		movw	<bgCalcCenterSpY, <bgCenterSpY

		lda	hitdatax2, x
		ldy	hitdatay2, x

		phx
		tax
		jsr	calcCenterSp
		plx

		lda	<bgCalcCenterSpX
		sta	hitWorkSpX, x
		lda	<bgCalcCenterSpY
		sta	hitWorkSpY, x

		jsr	getBgData
		sta	hitWorkNo, x
		beq	.hitCheck2BJump0
		smb7	<hitFlag

.hitCheck2BJump0:
		inx
		cpx	#28
		bne	.hitCheck2BLoop

;0~3	TOP
		ldx	#0
		ldy	#4
		jsr	hitCheck2CSub
		sta	hitWorkFlag

;4~6	TOP RIGHT
		ldx	#4
		ldy	#3
		jsr	hitCheck2CSub
		sta	hitWorkFlag+1

;7~10	RIGHT
		ldx	#7
		ldy	#4
		jsr	hitCheck2CSub
		sta	hitWorkFlag+2

;11~13	BOTTOM RIGHT
		ldx	#11
		ldy	#3
		jsr	hitCheck2CSub
		sta	hitWorkFlag+3

;14~17	BOTTOM
		ldx	#14
		ldy	#4
		jsr	hitCheck2CSub
		sta	hitWorkFlag+4

;18~20	BOTTOM LEFT
		ldx	#18
		ldy	#3
		jsr	hitCheck2CSub
		sta	hitWorkFlag+5

;21~24	LEFT
		ldx	#21
		ldy	#4
		jsr	hitCheck2CSub
		sta	hitWorkFlag+6

;25~27	TOP LEFT
		ldx	#25
		ldy	#3
		jsr	hitCheck2CSub
		sta	hitWorkFlag+7

		lda	<hitFlag
		rol	a

		rts


;----------------------------
hitCheck2CSub:
		cla

.hitCheck2CSubLoop:
		tst	#$FF, hitWorkNo, x
		beq	.hitCheck2CSubJump0

		sec
		rol	a
		bra	.hitCheck2CSubJump1

.hitCheck2CSubJump0:
		clc
		rol	a

.hitCheck2CSubJump1:
		inx
		dey
		bne	.hitCheck2CSubLoop

		rts


;----------------------------
getBgData:
;in	bgCalcCenterX
;	bgCalcCenterY
;	bgBank
;use	bgDataWorkAddr
;	$6000 Bank
;out	0:set zero, not 0:clear zero

		lda	<bgCalcCenterY
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		lsr	a
		clc
		adc	<bgBank
		tam	#$03		;Set $6000

		lda	<bgCalcCenterY
		and	#$1F
		ora	#$60
		sta	<bgDataWorkAddr+1

		lda	<bgCalcCenterX
		sta	<bgDataWorkAddr

		lda	[bgDataWorkAddr]
		rts


;----------------------------
calcMoveCenter2:
;in	regA angle
;	bgCenterX:bgCenterSpX:bgCenterSpXPoint
;	bgCenterY:bgCenterSpY:bgCenterSpYPoint
;	bgCenterMovement
;out	bgCenterX:bgCenterSpX:bgCenterSpXPoint
;	bgCenterY:bgCenterSpY:bgCenterSpYPoint

		tax

		movw	<mul16a, <bgCenterMovement

		lda	sindatalow, x
		sta	<mul16b
		lda	sindatahigh, x
		sta	<mul16b+1

		jsr	smul16

		subw	<bgCenterSpXPoint, <mul16c+1

		bpl	.calcMoveCenter2Jump0
		lda	#11
		sta	<bgCenterSpX
		dec	<bgCenterX
		bra	.calcMoveCenter2Jump1

.calcMoveCenter2Jump0:
		cmp	#12
		bne	.calcMoveCenter2Jump1
		stz	<bgCenterSpX
		inc	<bgCenterX

.calcMoveCenter2Jump1:
		movw	<mul16a, <bgCenterMovement

		lda	cosdatalow, x
		sta	<mul16b
		lda	cosdatahigh, x
		sta	<mul16b+1

		jsr	smul16

		subw	<bgCenterSpYPoint, <mul16c+1

		bpl	.calcMoveCenter2Jump2
		lda	#11
		sta	<bgCenterSpY
		dec	<bgCenterY
		bra	.calcMoveCenter2Jump3

.calcMoveCenter2Jump2:
		cmp	#12
		bne	.calcMoveCenter2Jump3
		stz	<bgCenterSpY
		inc	<bgCenterY

.calcMoveCenter2Jump3:
		rts


;----------------------------
calcCenterSp:
;in	regX(-11 ~ 11)
;	regY(-11 ~ 11)
;	bgCalcCenterX:bgCalcCenterSpX
;	bgCalcCenterY:bgCalcCenterSpY
;out	bgCalcCenterX:bgCalcCenterSpX + regX(-11 ~ 11)
;	bgCalcCenterY:bgCalcCenterSpY + regY(-11 ~ 11)

		clc
		txa
		adc	<bgCalcCenterSpX
		sta	<bgCalcCenterSpX
		bpl	.calcCenterSpJump0

		clc
		adc	#12
		sta	<bgCalcCenterSpX
		dec	<bgCalcCenterX
		bra	.calcCenterSpJump1

.calcCenterSpJump0:
		sec
		sbc	#12
		bmi	.calcCenterSpJump1
		sta	<bgCalcCenterSpX
		inc	<bgCalcCenterX

.calcCenterSpJump1:
		clc
		tya
		adc	<bgCalcCenterSpY
		sta	<bgCalcCenterSpY
		bpl	.calcCenterSpJump2

		clc
		adc	#12
		sta	<bgCalcCenterSpY
		dec	<bgCalcCenterY
		bra	.calcCenterSpJump3

.calcCenterSpJump2:
		sec
		sbc	#12
		bmi	.calcCenterSpJump3
		sta	<bgCalcCenterSpY
		inc	<bgCalcCenterY

.calcCenterSpJump3:
		rts


;----------------------------
rotationProc:
;rotationAngle
;rotationX -> rotationAnsX
;rotationY -> rotationAnsY
;X=xcosA-ysinA process
;xcosA
		movw	<mul16a, <rotationX

		ldx	<rotationAngle
		lda	cosdatalow,x
		sta	<mul16b
		lda	cosdatahigh,x
		sta	<mul16b+1

		jsr	smul16

		movq	<rotationAnsX, <mul16c

;ysinA
		movw	<mul16a, <rotationY

		ldx	<rotationAngle
		lda	sindatalow,x
		sta	<mul16b
		lda	sindatahigh,x
		sta	<mul16b+1

		jsr	smul16

;xcosA-ysinA
		subq	<rotationAnsX, <mul16c

;Y=xsinA+ycosA process
;xsinA
		movw	<mul16a, <rotationX

		ldx	<rotationAngle
		lda	sindatalow,x
		sta	<mul16b
		lda	sindatahigh,x
		sta	<mul16b+1

		jsr	smul16

		movq	<rotationAnsY, <mul16c

;ycosA
		movw	<mul16a, <rotationY

		ldx	<rotationAngle
		lda	cosdatalow,x
		sta	<mul16b
		lda	cosdatahigh,x
		sta	<mul16b+1

		jsr	smul16

;xsinA+ycosA
		addq	<rotationAnsY, <mul16c

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
		ldx	#LOW(mul16a)
		set
		eor	#$FF
		sec
		set
		adc	#$00
		inx
		set
		eor	#$FF
		set
		adc	#$00

.smul16jp00:
;b sign
		bbr7	<mul16b+1, .smul16jp01

;b neg
		ldx	#LOW(mul16b)
		set
		eor	#$FF
		sec
		set
		adc	#$00
		inx
		set
		eor	#$FF
		set
		adc	#$00

.smul16jp01:
		jsr	umul16

;anser sign
		pla
		and	#$80
		beq	.smul16jp02

;anser neg
		ldx	#LOW(mul16c)
		set
		eor	#$FF
		sec
		set
		adc	#$00
		inx
		set
		eor	#$FF
		set
		adc	#$00
		inx
		set
		eor	#$FF
		set
		adc	#$00
		inx
		set
		eor	#$FF
		set
		adc	#$00

.smul16jp02:
;pull x
		plx
		rts


;----------------------------
umul16:
;mul16d:mul16c = mul16a * mul16b

		lda	<mul16a+1
		ora	<mul16b+1
		bne	.umul16jp02
		jsr	umul8
;clear d
		stz	<mul16d
		stz	<mul16d+1
		rts

.umul16jp02:
;push x y
		phx
		phy

;b to d
		lda	<mul16b
		sta	<mul16d
		lda	<mul16b+1
		sta	<mul16d+1

;set counter
		ldy	#16

.umul16jp04:
;clear c
		stz	<mul16c
		stz	<mul16c+1

;umul16 loop
.umul16jp00:

;left shift c and d
		asl	<mul16c
		rol	<mul16c+1
		rol	<mul16d
		rol	<mul16d+1
		bcc	.umul16jp01

;add a to c
		ldx	#LOW(mul16c)
		clc
		set
		adc	<mul16a
		inx
		set
		adc	<mul16a+1
		bcc	.umul16jp01

;inc d
		inc	<mul16d
		bne	.umul16jp01
		inc	<mul16d+1

.umul16jp01:
		dey
		bne	.umul16jp00

;pull y x
		ply
		plx
		rts


;----------------------------
umul8:
;mul16c = mul16a * mul16b (8bit * 8bit)
;push x y
		phx
		phy

;b to c
		lda	<mul16b
		sta	<mul16c+1

;clear a
		cla

;set counter
		ldy	#8

;umul8 loop
.umul8jp00:
;left shift a
		asl	a
		rol	<mul16c+1
		bcc	.umul8jp01

;add a to c
		clc
		adc	<mul16a
		bcc	.umul8jp01

;inc c
		inc	<mul16c+1

.umul8jp01:
		dey
		bne	.umul8jp00

		sta	<mul16c

;pull y x
		ply
		plx
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
getpaddata:
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
		stz	$2000
		tii	$2000, $2001, 32767

;jump main
		jmp	main


;----------------------------
_irq1:
;IRQ1 interrupt process
;ACK interrupt
		lda	VDC1_0
		sta	<vdpstatus
		lda	VDC2_0

		jsr	getpaddata

		bbr7	<vsyncFlag, .irq1End

		stz	VPC_6		;reg6 select VDC#1

		st0	#$07		;scrollx
		st1	#$00
		st2	#$00

		st0	#$08		;scrolly
		st1	#$00
		st2	#$00

		lda	#$01
		sta	VPC_6		;reg6 select VDC#2

		lda	<scrollWork
		st0	#$07		;scrollx
		sta	VDC2_2
		st2	#$00

		st0	#$08		;scrolly
		sta	VDC2_2
		st2	#$00

		inc	<scrollWork

		rmb7	<vsyncFlag
.irq1End:
		rti


;----------------------------
_irq2:
_timer:
_nmi:
;IRQ2 TIMER NMI interrupt process
		rti


;----------------------------
bg0data:
		.db	$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01


;----------------------------
bg1data:
		.db	$04, $05, $06, $07, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 0
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$08, $09, $0A, $0B, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 1
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$0C, $0D, $0E, $0F, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 2
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$10, $11, $12, $13, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 3
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $04, $05, $06, $07, $02, $02, $02, $02, $02, $02,\	;line 0
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $08, $09, $0A, $0B, $02, $02, $02, $02, $02, $02,\	;line 1
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $0C, $0D, $0E, $0F, $02, $02, $02, $02, $02, $02,\	;line 2
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $10, $11, $12, $13, $02, $02, $02, $02, $02, $02,\	;line 3
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 0
			$04, $05, $06, $07, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 1
			$08, $09, $0A, $0B, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 2
			$0C, $0D, $0E, $0F, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 3
			$10, $11, $12, $13, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 0
			$02, $02, $02, $02, $02, $02, $04, $05, $06, $07, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 1
			$02, $02, $02, $02, $02, $02, $08, $09, $0A, $0B, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 2
			$02, $02, $02, $02, $02, $02, $0C, $0D, $0E, $0F, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 3
			$02, $02, $02, $02, $02, $02, $10, $11, $12, $13, $02, $02, $02, $02, $02, $02

		.db	$14, $15, $16, $17, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 0
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$18, $19, $1A, $1B, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 1
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$1C, $1D, $1E, $1F, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 2
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$3C, $3D, $3E, $3F, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 3
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $14, $15, $16, $17, $02, $02, $02, $02, $02, $02,\	;line 0
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $18, $19, $1A, $1B, $02, $02, $02, $02, $02, $02,\	;line 1
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $1C, $1D, $1E, $1F, $02, $02, $02, $02, $02, $02,\	;line 2
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $3C, $3D, $3E, $3F, $02, $02, $02, $02, $02, $02,\	;line 3
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 0
			$14, $15, $16, $17, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 1
			$18, $19, $1A, $1B, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 2
			$1C, $1D, $1E, $1F, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 3
			$3C, $3D, $3E, $3F, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 0
			$02, $02, $02, $02, $02, $02, $14, $15, $16, $17, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 1
			$02, $02, $02, $02, $02, $02, $18, $19, $1A, $1B, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 2
			$02, $02, $02, $02, $02, $02, $1C, $1D, $1E, $1F, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\	;line 3
			$02, $02, $02, $02, $02, $02, $3C, $3D, $3E, $3F, $02, $02, $02, $02, $02, $02


;----------------------------
vdpdata:
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
bgpalettedata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
sppalettedata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


;----------------------------
spballdata:
		.dw	$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,\
			$0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000

		.dw	$0000, $0000, $03C0, $0FF0, $1FF8, $1FF8, $3FFC, $3FFC,\
			$3FFC, $3FFC, $1FF8, $1FF8, $0FF0, $03C0, $0000, $0000

		.dw	$0000, $0000, $03C0, $0FF0, $1E78, $1E78, $3FFC, $3FFC,\
			$3FFC, $3FFC, $1FF8, $1FF8, $0FF0, $03C0, $0000, $0000

		.dw	$0000, $0000, $0000, $07E0, $0E70, $0E70, $1FF8, $1FF8,\
			$1998, $1998, $0FF0, $0FF0, $07E0, $0000, $0000, $0000


;----------------------------
hitdatax2:
		.db	$FE, $FF, $00, $01	;0~3	TOP
		.db	$02, $03, $04		;4~6	TOP RIGHT
		.db	$05, $05, $05, $05	;7~10	RIGHT
		.db	$04, $03, $02		;11~13	BOTTOM RIGHT
		.db	$FE, $FF, $00, $01	;14~17	BOTTOM
		.db	$FB, $FC, $FD		;18~20	BOTTOM LEFT
		.db	$FA, $FA, $FA, $FA	;21~24	LEFT
		.db	$FD, $FC, $FB		;25~27	TOP LEFT


;----------------------------
hitdatay2:
		.db	$FA, $FA, $FA, $FA	;0~3	TOP
		.db	$FB, $FC, $FD		;4~6	TOP RIGHT
		.db	$FE, $FF, $00, $01	;7~10	RIGHT
		.db	$02, $03, $04		;11~13	BOTTOM RIGHT
		.db	$05, $05, $05, $05	;14~17	BOTTOM
		.db	$02, $03, $04		;18~20	BOTTOM LEFT
		.db	$FE, $FF, $00, $01	;21~24	LEFT
		.db	$FB, $FC, $FD		;25~27	TOP LEFT


;----------------------------
sindatalow:
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
sindatahigh:
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
cosdatalow:
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
cosdatahigh:
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
;interrupt vectors
		.org	$FFF6

		.dw	_irq2
		.dw	_irq1
		.dw	_timer
		.dw	_nmi
		.dw	_reset


;////////////////////////////
		.bank	1
		INCBIN	"char.dat"		;  8K  1    $01
		INCBIN	"spxy.dat"		;256K  2~33 $02~$21
		INCBIN	"spbank.dat"		;  8K 34    $22
		INCBIN	"spno.dat"		;  8K 35    $23
		INCBIN	"sp00_00_3F.dat"	;  8K 36    $24
		INCBIN	"sp01_00_3F.dat"	;  8K 37    $25
		INCBIN	"sp02_00_3F.dat"	;  8K 38    $26
		INCBIN	"sp03_00_3F.dat"	;  8K 39    $27
		INCBIN	"sp03_00_3F.dat"	;  8K 40    $28
		INCBIN	"stage0.dat"		; 64K 41~48 $29~$30
