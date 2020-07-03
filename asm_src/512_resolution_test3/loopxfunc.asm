		.zp
		.org	$2000

;------- do not move for loopxfunc -------------
;+++++++++++++++++++++++++++++++++++++++++++++++
x0a		.ds	3
y0a		.ds	3
x1a		.ds	3
y1a		.ds	3
;+++++++++++++++++++++++++++++++++++++++++++++++
;-----------------------------------------------

		.bss
		.org	$2100

		.org	$2200

;///////////////////////////////////////////////
;------- do not move for loopxfunc -------------
;+++++++++++++++++++++++++++++++++++++++++++++++
		.org 	$3F00
mapconv		.ds	255
;+++++++++++++++++++++++++++++++++++++++++++++++
;-----------------------------------------------

		.code
		.bank	0

		.org	$2080

loopxfunc:
		ldy	#64

.loopX00:
		ldx	<y0a+2
		lda	mapconv, x
		tam	#$02

		lda	mapconvaddr, x

		sta	<.dataright+2	;<--- to #01
		ldx	<x0a+2
.dataright:
		lda	$0000, x	;<--- #01(address high)

		bbs7	<x0a+1, .datarightjump0
		tax
		lda	lsr4data, x
.datarightjump0:
		and	#$0F
		sta	<.dataor+1	;<--- to #03

		ldx	<y1a+2
		lda	mapconv, x
		tam	#$02

		lda	mapconvaddr, x

		sta	<.dataleft+2	;<--- to #02
		ldx	<x1a+2
.dataleft:
		lda	$0000, x	;<--- #02(address high)

		bbr7	<x1a+1, .dataleftjump0
		tax
		lda	asl4data, x
.dataleftjump0:
		and	#$F0

.dataor:
		ora	#$00		;<--- #03

		sei
		sta	$0002		;<--- store vram
		st2	#$01		;<--- palette 23 01
		cli

;next step
;add x0a cos0
		ldx	#LOW(x0a)
		clc
		set
		adc	#$11		;<--- cos0 69 11
		inx
		set
		adc	#$12		;<--- cos0+1 69 12
		inx
		set
		adc	#$13		;<--- cos0+2 69 13

;add y0a sin0
		inx
		clc
		set
		adc	#$14		;<--- sin0 69 14
		inx
		set
		adc	#$15		;<--- sin0+1 69 15
		inx
		set
		adc	#$16		;<--- sin0+2 69 16

;add x1a cos1
		inx
		clc
		set
		adc	#$17		;<--- cos1 69 17
		inx
		set
		adc	#$18		;<--- cos1+1 69 18
		inx
		set
		adc	#$19		;<--- cos1+2 69 19

;add y1a sin1
		inx
		clc
		set
		adc	#$1A		;<--- sin1 69 1A
		inx
		set
		adc	#$1B		;<--- sin1+1 69 1B
		inx
		set
		adc	#$1C		;<--- sin1+2 69 1C

		dey
		bne	.loopX00

		rts

;------- do not move for loopxfunc -------------
;+++++++++++++++++++++++++++++++++++++++++++++++
		.org	$FC00
asl4data:
		.db	$00
;----------------------------
		.org	$FD00
lsr4data:
		.db	$00
;----------------------------
		.org	$FE00
mapconvaddr:
		.db	$00
;+++++++++++++++++++++++++++++++++++++++++++++++
;-----------------------------------------------
