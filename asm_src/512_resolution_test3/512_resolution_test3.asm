;//// Use pceas.exe ////
		.zp
		.bss
		.org	$2000
;------- do not move for loopxfunc -------------
;+++++++++++++++++++++++++++++++++++++++++++++++
x0a		.ds	3
y0a		.ds	3
x1a		.ds	3
y1a		.ds	3
;+++++++++++++++++++++++++++++++++++++++++++++++
;-----------------------------------------------
hitwork		.ds	2
;---------------------
lapflag		.ds	1
;---------------------
calclineptr	.ds	2
;---------------------
stageflag	.ds	1
;---------------------
padlast		.ds	1
padnow		.ds	1
padstate	.ds	1
;---------------------
vdpstatus	.ds	1
scrollxwork	.ds	1
;---------------------
mul16a		.ds	2
mul16b		.ds	2
mul16c		.ds	2
mul16d		.ds	2
;---------------------
mul16an		.ds	2
mul16bn		.ds	2
mul16cn		.ds	2
mul16dn		.ds	2
;---------------------
puthexaddr	.ds	2
puthexdata	.ds	1
;---------------------
psgchno		.ds	1
;;psgstate	.ds	1
psgfreqwork	.ds	2
psgdataaddrwork	.ds	2

psg0dataaddr	.ds	2
psg0addr	.ds	2
psg0count	.ds	1

psg1dataaddr	.ds	2
psg1addr	.ds	2
psg1count	.ds	1

;---------------------
spritexywork		.ds	2
spritexwork		.ds	2
spriteywork		.ds	2
spritenowork		.ds	2
spriteworkaddress	.ds	2


;///////////////////////////////////////////////
		.org	$2080
loopxfunc	.ds	$80

;///////////////////////////////////////////////
		.org 	$2100
;stack area

;///////////////////////////////////////////////
		.org 	$2200
;-----------------------------------------------
centerangle	.ds	1
centerx		.ds	4
centery		.ds	4
centerxwork	.ds	4
centerywork	.ds	4
centerangletmp	.ds	1
centerxtmp	.ds	4
centerytmp	.ds	4
centerlastangle	.ds	1
;---------------------
shipspeed	.ds	2
;---------------------
hitangle	.ds	1
hitspeed	.ds	2
;---------------------
hitnumber	.ds	1
hitlastnumber	.ds	1
hitdatanumber	.ds	1
hitanglework	.ds	1
hitspeedwork	.ds	1
;---------------------
lapcheck	.ds	1
lapcount	.ds	1
;---------------------
stageno		.ds	1

;---------------------
enemyangle	.ds	1
enemyx		.ds	4
enemyy		.ds	4
enemyangletmp	.ds	1
enemyxtmp	.ds	4
enemyytmp	.ds	4
enemyxwork	.ds	4
enemyywork	.ds	4
enemycalcxwork	.ds	4
enemycalcywork	.ds	4
enemyyindex	.ds	1
enemyflag	.ds	1
enemylocatex	.ds	2
enemyspeed	.ds	2

;---------------------
stageinittmp	.ds	1

;---------------------
laptime		.ds	3
laplasttime	.ds	9

;---------------------
framecount	.ds	1
drawcount	.ds	1
drawcountwork	.ds	1


;///////////////////////////////////////////////
		.org 	$3D00
;sprite work
spritework	.ds	64 * 8

;///////////////////////////////////////////////
;------- do not move for loopxfunc -------------
;+++++++++++++++++++++++++++++++++++++++++++++++
		.org 	$3F00
mapconv		.ds	256
;+++++++++++++++++++++++++++++++++++++++++++++++
;-----------------------------------------------

;///////////////////////////////////////////////

		.code
		.bank	0
		.org	$E000
;----------------------------
main:
;initialize
		jsr	init

		stz	stageno
		stz	<stageflag

		jsr	stageinit

;set raster count
		st0	#$06
		st1	#$80
		st2	#$00

;screen on
;bg sp       vsync raster
;+1
		st0	#$05
		st1	#$CC
		st2	#$00

;vsyncinterrupt start
		cli

.mainloop:
		tii	centerangle, centerangletmp, 9

;enemy
		tii	enemyangle, enemyangletmp, 9

;put line process
		jsr	putline

;enemy rotation
;enemyxwork = enemyxtmp - centerxtmp
		sec
		lda	enemyxtmp
		sbc	centerxtmp
		sta	enemyxwork

		lda	enemyxtmp+1
		sbc	centerxtmp+1
		sta	enemyxwork+1

		lda	enemyxtmp+2
		sbc	centerxtmp+2
		sta	enemyxwork+2

		lda	enemyxtmp+3
		sbc	centerxtmp+3
		sta	enemyxwork+3

;enemyywork = enemyytmp - centerytmp
		sec
		lda	enemyytmp
		sbc	centerytmp
		sta	enemyywork

		lda	enemyytmp+1
		sbc	centerytmp+1
		sta	enemyywork+1

		lda	enemyytmp+2
		sbc	centerytmp+2
		sta	enemyywork+2

		lda	enemyytmp+3
		sbc	centerytmp+3
		sta	enemyywork+3

;x scale
		lsr	enemyxwork+3
		ror	enemyxwork+2
		ror	enemyxwork+1

		lsr	enemyxwork+3
		ror	enemyxwork+2
		ror	enemyxwork+1

;y scale
		lsr	enemyywork+3
		ror	enemyywork+2
		ror	enemyywork+1

		lsr	enemyywork+3
		ror	enemyywork+2
		ror	enemyywork+1

;X=xcosA-ysinA process
		lda	enemyxwork+1
		sta	<mul16an
		lda	enemyxwork+2
		sta	<mul16an+1

		lda	centerangletmp
		eor	#$FF
		inc	a
		tax
		lda	cosdatalow,x
		sta	<mul16bn
		lda	cosdatahigh,x
		sta	<mul16bn+1

		jsr	smul16n

		lda	<mul16cn
		sta	enemycalcxwork
		lda	<mul16cn+1
		sta	enemycalcxwork+1
		lda	<mul16dn
		sta	enemycalcxwork+2
		lda	<mul16dn+1
		sta	enemycalcxwork+3

		lda	enemyywork+1
		sta	<mul16an
		lda	enemyywork+2
		sta	<mul16an+1

		lda	centerangletmp
		eor	#$FF
		inc	a
		tax
		lda	sindatalow,x
		sta	<mul16bn
		lda	sindatahigh,x
		sta	<mul16bn+1

		jsr	smul16n

		sec
		lda	enemycalcxwork
		sbc	<mul16cn
		sta	enemycalcxwork

		lda	enemycalcxwork+1
		sbc	<mul16cn+1
		sta	enemycalcxwork+1

		lda	enemycalcxwork+2
		sbc	<mul16dn
		sta	enemycalcxwork+2

		lda	enemycalcxwork+3
		sbc	<mul16dn+1
		sta	enemycalcxwork+3

		asl	enemycalcxwork
		rol	enemycalcxwork+1
		rol	enemycalcxwork+2
		rol	enemycalcxwork+3

		asl	enemycalcxwork
		rol	enemycalcxwork+1
		rol	enemycalcxwork+2
		rol	enemycalcxwork+3

;Y=xsinA+ycosA process
		lda	enemyxwork+1
		sta	<mul16an
		lda	enemyxwork+2
		sta	<mul16an+1

		lda	centerangletmp
		eor	#$FF
		inc	a
		tax
		lda	sindatalow,x
		sta	<mul16bn
		lda	sindatahigh,x
		sta	<mul16bn+1

		jsr	smul16n

		lda	<mul16cn
		sta	enemycalcywork
		lda	<mul16cn+1
		sta	enemycalcywork+1
		lda	<mul16dn
		sta	enemycalcywork+2
		lda	<mul16dn+1
		sta	enemycalcywork+3

		lda	enemyywork+1
		sta	<mul16an
		lda	enemyywork+2
		sta	<mul16an+1

		lda	centerangletmp
		eor	#$FF
		inc	a
		tax
		lda	cosdatalow,x
		sta	<mul16bn
		lda	cosdatahigh,x
		sta	<mul16bn+1

		jsr	smul16n

		clc
		lda	enemycalcywork
		adc	<mul16cn
		sta	enemycalcywork

		lda	enemycalcywork+1
		adc	<mul16cn+1
		sta	enemycalcywork+1

		lda	enemycalcywork+2
		adc	<mul16dn
		sta	enemycalcywork+2

		lda	enemycalcywork+3
		adc	<mul16dn+1
		sta	enemycalcywork+3

		asl	enemycalcywork
		rol	enemycalcywork+1
		rol	enemycalcywork+2
		rol	enemycalcywork+3

		asl	enemycalcywork
		rol	enemycalcywork+1
		rol	enemycalcywork+2
		rol	enemycalcywork+3

;move to enemy_work
		lda	enemycalcxwork
		sta	enemyxwork
		lda	enemycalcxwork+1
		sta	enemyxwork+1
		lda	enemycalcxwork+2
		sta	enemyxwork+2
		lda	enemycalcxwork+3
		sta	enemyxwork+3

		lda	enemycalcywork
		sta	enemyywork
		lda	enemycalcywork+1
		sta	enemyywork+1
		lda	enemycalcywork+2
		sta	enemyywork+2
		lda	enemycalcywork+3
		sta	enemyywork+3

;enemy screen locate
		stz	enemyyindex

;negative enemyywork
		clc
		lda	enemyywork
		eor	#$FF
		adc	#1
		sta	enemyywork

		lda	enemyywork+1
		eor	#$FF
		adc	#0
		sta	enemyywork+1

		lda	enemyywork+2
		eor	#$FF
		adc	#0
		sta	enemyywork+2

		lda	enemyywork+3
		eor	#$FF
		adc	#0
		sta	enemyywork+3

;enemyywork = enemyywork + 1
		clc
		lda	enemyywork+2
		adc	#1
		sta	enemyywork+2

		lda	enemyywork+3
		adc	#0
		sta	enemyywork+3

		lda	enemyywork+3
		bne	.enemyjump02

		lda	enemyywork+2
		cmp	#55
		bcs	.enemyjump02	;enemyywork+2 >= 55

		sta	enemyyindex
		lda	enemyywork+1
		asl	a
		rol	enemyyindex
		asl	a
		rol	enemyyindex

;x scale
		lda	enemyxwork+1
		sta	<mul16an

		lda	enemyxwork+2
		sta	<mul16an+1

		lda	enemyxwork+3
		lsr	a
		ror	<mul16an+1
		ror	<mul16an
		lsr	a
		ror	<mul16an+1
		ror	<mul16an

		ldx	enemyyindex
		lda	enemyxconvlow,x
		sta	<mul16bn

		lda	enemyxconvhigh,x
		sta	<mul16bn+1

		jsr	smul16n

		lda	<mul16cn+1
		asl	a
		rol	<mul16dn
		rol	<mul16dn+1
		asl	a
		rol	<mul16dn
		rol	<mul16dn+1

		asl	a
		rol	<mul16dn
		rol	<mul16dn+1
		asl	a
		rol	<mul16dn
		rol	<mul16dn+1

		asl	<mul16dn
		rol	<mul16dn+1

		lda	<mul16dn
		sta	enemylocatex
		lda	<mul16dn+1
		inc	a
		sta	enemylocatex+1

		bra	.enemyjump00

.enemyjump02:
		lda	#$FF
		sta	enemyyindex

;enemy screen locate end
.enemyjump00:


;stage select
;select check
		bbr7	<stageflag, .selectcheckend
		rmb7	<stageflag

		lda	stageno
		inc	a
		and	#$01
		sta	stageno

		sei
		jsr	stageinit
		cli
.selectcheckend:


;set sprite
;clear	sprite work
		stz	spritework
		tii	spritework, spritework+1, 16 * 8 - 1

		lda	#LOW(spritework)
		sta	<spriteworkaddress
		lda	#HIGH(spritework)
		sta	<spriteworkaddress+1

;ship
		lda	#$00
		sta	<spritexwork
		lda	#$01
		sta	<spritexwork+1

		lda	#$A0
		sta	<spriteywork
		lda	#$00
		sta	<spriteywork+1

		lda	#$00
		sta	<spritenowork
		lda	#$00
		sta	<spritenowork+1

		jsr	setsprite3

;enemy
		ldx	enemyyindex
		lda	enemyyconv, x
		sta	<spriteywork
		lda	#$00
		sta	<spriteywork+1

		lda	enemylocatex
		sta	<spritexwork
		lda	enemylocatex+1
		sta	<spritexwork+1

		lda	enemynoconv, x
		sta	<spritenowork
		lda	#$00
		sta	<spritenowork+1

		jsr	setsprite3

;set sprite
		sei
		st0	#$00
		st1	#$00
		st2	#$30

		st0	#$02
		tia	spritework, $0002, 8 * 16
		cli

;SATB DMA set
		sei
		st0	#$13
		st1	#$00
		st2	#$30
		cli

;increment draw count
		inc	drawcount

;put data
;put data line 24
;put draw count
		ldx	#0
		ldy	#24
		lda	drawcountwork
		jsr	puthex

;put ship centerx
		ldx	#4
		lda	centerx+3
		jsr	puthex
		lda	centerx+2
		jsr	puthex2

;put ship centery
		ldx	#10
		lda	centery+3
		jsr	puthex
		lda	centery+2
		jsr	puthex2

;put hit number
		ldx	#16
		lda	hitnumber
		jsr	puthex

;put ship speed
		ldx	#20
		lda	shipspeed
		jsr	puthex

;put ship centerangle
		ldx	#24
		lda	centerangle
		jsr	puthex

;put hit speed
		ldx	#28
		lda	hitspeed
		jsr	puthex

;put hit angle
		ldx	#32
		lda	hitangle
		jsr	puthex

;put enemyx
		ldx	#36
		lda	enemyx+3
		jsr	puthex

		lda	enemyx+2
		jsr	puthex2

;put enemyy
		ldx	#42
		lda	enemyy+3
		jsr	puthex

		lda	enemyy+2
		jsr	puthex2
		cli

;put enemyspeed
		ldx	#48
		lda	enemyspeed
		jsr	puthex

;put enemyangle
		ldx	#52
		lda	enemyangle
		jsr	puthex

;put data line 25
;put lap count
		ldx	#0
		ldy	#25
		lda	lapcount
		jsr	puthex

;put lap check
		ldx	#4
		lda	lapcheck
		jsr	puthex

;put lap flag
		ldx	#8
		lda	<lapflag
		jsr	puthex

;put lap time
		ldx	#12
		lda	laptime+2
		jsr	puthex

		lda	#$27
		jsr	putchar2

		lda	laptime+1
		jsr	puthex2

		lda	#$22
		jsr	putchar2

		ldx	laptime
		lda	secconv, x
		jsr	puthex2

;put lap last time0
		ldx	#22
		lda	laplasttime+2
		jsr	puthex

		lda	#$27
		jsr	putchar2

		lda	laplasttime+1
		jsr	puthex2

		lda	#$22
		jsr	putchar2

		ldx	laplasttime
		lda	secconv, x
		jsr	puthex2

;put data line 26
;put lap last time1
		ldx	#22
		ldy	#26
		lda	laplasttime+5
		jsr	puthex

		lda	#$27
		jsr	putchar2

		lda	laplasttime+4
		jsr	puthex2

		lda	#$22
		jsr	putchar2

		ldx	laplasttime+3
		lda	secconv, x
		jsr	puthex2

;put stage no
		ldx	#0
		lda	stageno
		jsr	puthex

;put data line 27
;put lap last time2
		ldx	#22
		ldy	#27
		lda	laplasttime+8
		jsr	puthex

		lda	#$27
		jsr	putchar2

		lda	laplasttime+7
		jsr	puthex2

		lda	#$22
		jsr	putchar2

		ldx	laplasttime+6
		lda	secconv, x
		jsr	puthex2

;jump mainloop
		jmp	.mainloop


;----------------------------
getpaddata:
		lda	<padnow
		sta	<padlast

		lda	#$01
		sta	$1000
		lda	#$03
		sta	$1000

		lda	#$01
		sta	$1000
		lda	$1000
		asl	a
		asl	a
		asl	a
		asl	a
		sta	<padnow

		lda	#$00
		sta	$1000
		lda	$1000
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
checkpadmove:

;select button check
		bbr2	<padstate, .selectbuttonend
		smb7	<stageflag
.selectbuttonend:

;centerangle
		lda	centerangle
		sta	centerlastangle

;centerangle(0-255) Addition 
		bbs7	<padnow, .jumppadleft
		bbs5	<padnow, .jumppadright
		bra	.jumppadend

.jumppadleft:
		dec	centerangle
		dec	centerangle
		bra	.jumppadend

.jumppadright:
		inc	centerangle
		inc	centerangle
.jumppadend:

;ship spped
;add ship spped
		bbs0	<padnow, .shipspeed00
		lda	shipspeed
		beq	.shipspeed01
		dec	a
		sta	shipspeed
		bra	.shipspeed01
.shipspeed00:
;;---------------------------------------
;		;lda	shipspeed
;		;cmp	#192
;		;beq	.shipspeed01
;		;inc	shipspeed

		inc	shipspeed
		bne	.shipspeed01
		lda	#$FF
		sta	shipspeed
.shipspeed01:

;sub ship spped
		bbr1	<padnow, .shipspeed03
		lda	shipspeed
		sec
		sbc	#4
		bcs	.shipspeed02
		cla
.shipspeed02:
		sta	shipspeed
.shipspeed03:


;;---------------------------------------
;		;stz	<hitspeed
;		lda	<centerlastangle
;		cmp	<centerangle
;		beq	.shipspeed04
;		bcc	.shipspeed05
;
;		clc
;		adc	#64
;		sta	<hitangle
;		lda	<shipspeed
;		lsr	a
;		lsr	a
;		;lsr	a
;		sta	<hitspeed
;		bra	.shipspeed04
;.shipspeed05:
;		sec
;		sbc	#64
;		sta	<hitangle
;		lda	<shipspeed
;		lsr	a
;		lsr	a
;		;lsr	a
;		sta	<hitspeed
;.shipspeed04:


;add movement centerx centery
		ldy	centerangle
;add movement centerx
;centerx + sin
		lda	sindatalow, y
		sta	<mul16a
		lda	sindatahigh, y
		sta	<mul16a+1

		lda	shipspeed
		sta	<mul16b
		lda	shipspeed+1
		sta	<mul16b+1

		jsr	smul16

		clc
		lda	centerx
		adc	<mul16c
		sta	centerxwork

		lda	centerx+1
		adc	<mul16c+1
		sta	centerxwork+1

		lda	centerx+2
		adc	<mul16d
		sta	centerxwork+2

		lda	centerx+3
		adc	<mul16d+1
		sta	centerxwork+3

;add movement centery
;centery - cos
		lda	cosdatalow, y
		sta	<mul16a
		lda	cosdatahigh, y
		sta	<mul16a+1

		lda	shipspeed
		sta	<mul16b
		lda	shipspeed+1
		sta	<mul16b+1

		jsr	smul16

		sec
		lda	centery
		sbc	<mul16c
		sta	centerywork

		lda	centery+1
		sbc	<mul16c+1
		sta	centerywork+1

		lda	centery+2
		sbc	<mul16d
		sta	centerywork+2

		lda	centery+3
		sbc	<mul16d+1
		sta	centerywork+3

;sub hit spped
		lda	hitspeed
		sec
		sbc	#4
		bcs	.hitspeed02
		cla
.hitspeed02:
		sta	hitspeed
.hitspeed03:

;add hit movement centerx centery
		ldy	hitangle
;add hit movement centerx
;centerx + sin
		lda	sindatalow, y
		sta	<mul16a
		lda	sindatahigh, y
		sta	<mul16a+1

		lda	hitspeed
		sta	<mul16b
		lda	hitspeed+1
		sta	<mul16b+1

		jsr	smul16

		clc
		lda	centerxwork
		adc	<mul16c
		sta	centerxwork

		lda	centerxwork+1
		adc	<mul16c+1
		sta	centerxwork+1

		lda	centerxwork+2
		adc	<mul16d
		sta	centerxwork+2

		lda	centerxwork+3
		adc	<mul16d+1
		sta	centerxwork+3

;add movement centery
;centery - cos
		lda	cosdatalow, y
		sta	<mul16a
		lda	cosdatahigh, y
		sta	<mul16a+1

		lda	hitspeed
		sta	<mul16b
		lda	hitspeed+1
		sta	<mul16b+1

		jsr	smul16

		sec
		lda	centerywork
		sbc	<mul16c
		sta	centerywork

		lda	centerywork+1
		sbc	<mul16c+1
		sta	centerywork+1

		lda	centerywork+2
		sbc	<mul16d
		sta	centerywork+2

		lda	centerywork+3
		sbc	<mul16d+1
		sta	centerywork+3

;map hit number
		lda	hitnumber
		sta	hitlastnumber
		jsr	maphit2
		sta	hitnumber

;lapcheck
		cmp	#$02		;dark green
		beq	.lapcheckjump00
		cmp	#$06		;dark cyan
		beq	.lapcheckjump01

;on other color
		lda	hitlastnumber
		cmp	#$02		;dark green
		beq	.lapcheckjump02
		cmp	#$06		;dark cyan
		beq	.lapcheckjump02
		bra	.lapcheckend

.lapcheckjump02:
		lda	lapcheck
		asl	a
		asl	a
		ora	#$01
		and	#$3F
		sta	lapcheck
		bra	.lapcheckend

;on dark green
.lapcheckjump00:
		lda	hitlastnumber
		cmp	#$02		;dark green
		beq	.lapcheckend

		lda	lapcheck
		asl	a
		asl	a
		ora	#$02
		and	#$3F
		sta	lapcheck

		cmp	#$36
		bne	.lapcheckend
		smb7	<lapflag
		bra	.lapcheckend

;;on dark cyan
.lapcheckjump01:
		lda	hitlastnumber
		cmp	#$06		;dark cyan
		beq	.lapcheckend

		lda	lapcheck
		asl	a
		asl	a
		ora	#$03
		and	#$3F
		sta	lapcheck

		bbr7	<lapflag, .lapcheckend
		inc	lapcount
		stz	<lapflag

		ldx	#8
.laptimemove:
		lda	laptime,x
		sta	laptime+3,x
		dex
		bpl	.laptimemove

		stz	laptime
		stz	laptime+1
		stz	laptime+2
.lapcheckend:

;map effect check
		lda	hitnumber
		cmp	#$05		;dark magenta
		beq	.mapeffectjump000
		cmp	#$09		;red
		beq	.mapeffectjump001
		cmp	#$0F		;white
		beq	.mapeffectjump001
		bra	.mapeffectend

.mapeffectjump000:
		ldy	shipspeed
		lda	lsr4data, y
		sta	<hitwork

		sec
		lda	shipspeed
		sbc	<hitwork
		sta	shipspeed
		bra	.mapeffectend

.mapeffectjump001:
;slow down
		ldy	shipspeed
		lda	lsr4data, y
		lsr	a
		lsr	a
		sta	<hitwork

		sec
		lda	shipspeed
		sbc	<hitwork
		sta	shipspeed
		bra	.mapeffectend
.mapeffectend:

;map hit check
		lda	hitnumber
		cmp	#$00		;black
		beq	.maphitjump000
		cmp	#$0C		;blue
		beq	.maphitjump000
		;cmp	#$05		;dark magenta
		;cmp	#$06		;dark cyan
		;cmp	#$02		;dark green
		;cmp	#$09		;red
		;cmp	#$0F		;white
		;beq	.maphitjump000

		lda	centerxwork
		sta	centerx
		lda	centerxwork+1
		sta	centerx+1
		lda	centerxwork+2
		sta	centerx+2
		lda	centerxwork+3
		sta	centerx+3

		lda	centerywork
		sta	centery
		lda	centerywork+1
		sta	centery+1
		lda	centerywork+2
		sta	centery+2
		lda	centerywork+3
		sta	centery+3

		jmp	.maphitjump006

.maphitjump000:
		lda	shipspeed
		cmp	hitspeed
		bcs	.maphitjump007

		lda	hitangle
		sta	hitanglework

		lda	hitspeed
		sta	hitspeedwork

		bra	.maphitjump008

.maphitjump007:
		lda	centerangle
		sta	hitanglework

		lda	shipspeed
		sta	hitspeedwork

.maphitjump008:
		lda	centerxwork+2
		asl	a
		and	#$02
		sta	<hitwork

		lda	centerywork+2
		and	#$01
		ora	<hitwork

		eor	#$FF
		and	#$03
		sta	<hitwork

		lda	centerx+2
		asl	a
		and	#$02
		sta	<hitwork+1

		lda	centery+2
		and	#$01
		ora	<hitwork+1
		eor	<hitwork
		sta	<hitwork+1

		beq	.maphitjump005
		cmp	#$02
		beq	.maphitjump003

		stz	hitdatanumber
		lda	#$80
		sta	<hitwork

		bra	.maphitjump004

.maphitjump005:
		clc
		lda	hitanglework
		adc	#$80

		bra	.maphitjump001

.maphitjump003:
		lda	#$40
		sta	hitdatanumber
		lda	#$C0
		sta	<hitwork

.maphitjump004:
		lda	hitanglework
		cmp	hitdatanumber
		bcc	.maphitjump002	;hitanglework < hitdatanumber
		cmp	<hitwork
		bcs	.maphitjump002	;hitanglework >= hitwork

		lda	hitdatanumber
		asl	a
		sec
		sbc	hitanglework

		bra	.maphitjump001

.maphitjump002:
		lda	<hitwork
		asl	a
		sec
		sbc	hitanglework

.maphitjump001:
		sta	hitangle
		lda	hitspeedwork
		sta	hitspeed
		stz	shipspeed

.maphitjump006:
		rts


;----------------------------
stageinit:
		lda	stageno
		asl	a
		asl	a
		asl	a
		tax

		phx

;set mapconv
		lda	#8
		sta	stageinittmp
		lda	stagedata, x
		clx

.setmapconvloop1:
		ldy	#32
.setmapconvloop0:
		sta	mapconv, x
		inx
		dey
		bne	.setmapconvloop0

		inc	a
		dec	stageinittmp
		bne	.setmapconvloop1

;set stage BAT
		st0	#$00
		st1	#$00
		st2	#$00
		st0	#$02

		clx
.setbatloop0:
		lda	bgdata00, x
		sta	$0002
		st2	#$02

		inc	a
		sta	$0002
		st2	#$02

		inx
		bne	.setbatloop0

;set ship center
		plx

		stz	centerx
		stz	centerx+1
		lda	stagedata+1, x
		sta	centerx+2
		lda	stagedata+2, x
		sta	centerx+3

		stz	centery
		stz	centery+1
		lda	stagedata+3, x
		sta	centery+2
		stz	centery+3

;set enemy center
		stz	enemyx
		stz	enemyx+1
		lda	stagedata+4, x
		sta	enemyx+2
		lda	stagedata+5, x
		sta	enemyx+3

		stz	enemyy
		stz	enemyy+1
		lda	stagedata+6, x
		sta	enemyy+2
		stz	enemyy+3

;set ship angle
		lda	stagedata+7, x
		sta	centerangle

;set enemy angle
		sta	enemyangle

;set ship speed
		stz	shipspeed
		stz	shipspeed+1

;set enemy speed
		lda	#$00
		sta	enemyspeed
		stz	enemyspeed+1

;set hit angle
		stz	hitangle

;set hit speed
		stz	hitspeed
		stz	hitspeed+1

;set hit number
		stz	hitnumber

;set hit last number
		stz	hitlastnumber

;set lap check
		stz	lapcheck

;set lap flag
		stz	<lapflag

;set lap count
		stz	lapcount

;set lap time
.setlaptimeloop:
		stz	laptime, x
		inx
		cpx	#12
		bne	.setlaptimeloop

		rts


;----------------------------
maphit2:
;x centerxwork+3 centerxwork+2
;y centerywork+2
		ldy	centerywork+2
		lda	mapconv, y
		tam	#$04

		tya
		and	#$1F
		ora	#$80

		stz	<hitwork
		sta	<hitwork+1

		lda	centerxwork+3
		lsr	a
		lda	centerxwork+2
		ror	a

		tay
		lda	[hitwork], y

		bcs	.maphit2jump00

		tay
		lda	lsr4data, y

.maphit2jump00:
		and	#$0F

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

;------------------------------
;		lda	<mul16a+1
;		bne	.umul16jp05
;
;;a to d
;		stz	<mul16d
;		lda	<mul16a
;		sta	<mul16d+1
;
;;b to a
;		lda	<mul16b
;		sta	<mul16a
;		lda	<mul16b+1
;		sta	<mul16a+1
;
;;set counter
;		ldy	#8
;		bra	.umul16jp04
;
;.umul16jp05:
;		lda	<mul16b+1
;		bne	.umul16jp03
;
;;b to d
;		stz	<mul16d
;		lda	<mul16b
;		sta	<mul16d+1
;
;;set counter
;		ldy	#8
;		bra	.umul16jp04
;
;.umul16jp03:
;b to d
;		;;lda	<mul16b+1
;		sta	<mul16d+1
;		lda	<mul16b
;		sta	<mul16d
;------------------------------

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
smul16n:
;mul16dn:mul16cn = mul16an * mul16bn
;push x
		phx

;a eor b sign
		lda	<mul16an+1
		eor	<mul16bn+1
		pha

;a sign
		bbr7	<mul16an+1, .smul16njp00

;a neg
		ldx	#LOW(mul16an)
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

.smul16njp00:
;b sign
		bbr7	<mul16bn+1, .smul16njp01

;b neg
		ldx	#LOW(mul16bn)
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

.smul16njp01:
		jsr	umul16n

;anser sign
		pla
		and	#$80
		beq	.smul16njp02

;anser neg
		ldx	#LOW(mul16cn)
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

.smul16njp02:
;pull x
		plx
		rts


;----------------------------
umul16n:
;mul16dn:mul16cn = mul16an * mul16bn

		lda	<mul16an+1
		ora	<mul16bn+1
		bne	.umul16njp02
		jsr	umul8n
;clear d
		stz	<mul16dn
		stz	<mul16dn+1
		rts

.umul16njp02:
;push x y
		phx
		phy

;------------------------------
;		lda	<mul16an+1
;		bne	.umul16njp05
;
;;a to d
;		stz	<mul16dn
;		lda	<mul16an
;		sta	<mul16dn+1
;
;;b to a
;		lda	<mul16bn
;		sta	<mul16an
;		lda	<mul16bn+1
;		sta	<mul16an+1
;
;;set counter
;		ldy	#8
;		bra	.umul16njp04
;
;.umul16njp05:
;		lda	<mul16bn+1
;		bne	.umul16njp03
;
;;b to d
;		stz	<mul16dn
;		lda	<mul16bn
;		sta	<mul16dn+1
;
;;set counter
;		ldy	#8
;		bra	.umul16njp04
;
;.umul16njp03:
;b to d
;		;;lda	<mul16bn+1
;		sta	<mul16dn+1
;		lda	<mul16bn
;		sta	<mul16dn
;------------------------------

;b to d
		lda	<mul16bn
		sta	<mul16dn
		lda	<mul16bn+1
		sta	<mul16dn+1

;set counter
		ldy	#16

.umul16njp04:
;clear c
		stz	<mul16cn
		stz	<mul16cn+1

;umul16n loop
.umul16njp00:

;left shift c and d
		asl	<mul16cn
		rol	<mul16cn+1
		rol	<mul16dn
		rol	<mul16dn+1
		bcc	.umul16njp01

;add a to c
		ldx	#LOW(mul16cn)
		clc
		set
		adc	<mul16an
		inx
		set
		adc	<mul16an+1
		bcc	.umul16njp01

;inc d
		inc	<mul16dn
		bne	.umul16njp01
		inc	<mul16dn+1

.umul16njp01:
		dey
		bne	.umul16njp00

;pull y x
		ply
		plx
		rts


;----------------------------
umul8n:
;mul16cn = mul16an * mul16bn (8bit * 8bit)
;push x y
		phx
		phy

;b to c
		lda	<mul16bn
		sta	<mul16cn+1

;clear a
		cla

;set counter
		ldy	#8

;umul8 loop
.umul8njp00:
;left shift a
		asl	a
		rol	<mul16cn+1
		bcc	.umul8njp01

;add a to c
		clc
		adc	<mul16an
		bcc	.umul8njp01

;inc c
		inc	<mul16cn+1

.umul8njp01:
		dey
		bne	.umul8njp00

		sta	<mul16cn

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
makechar:
		phx
		phy

		clx
		pha
		and	#$01
		beq	.makecharjp01
		ldx	#$FF
.makecharjp01:
		cly
		pla
		and	#$02
		beq	.makecharjp02
		ldy	#$FF
.makecharjp02:
		stx	$0002
		sty	$0003
		stx	$0002
		sty	$0003
		stx	$0002
		sty	$0003
		stx	$0002
		sty	$0003

		ply
		plx
		rts


;----------------------------
setvramaddress:
		stz	<puthexaddr
		sty	<puthexaddr+1

		lsr	<puthexaddr+1
		ror	<puthexaddr
		lsr	<puthexaddr+1
		ror	<puthexaddr

		txa
		ora	<puthexaddr
		sta	<puthexaddr

		sei

		st0	#$00
		lda	<puthexaddr
		sta	$0002
		lda	<puthexaddr+1
		sta	$0003

		cli

		rts


;----------------------------
putchar2:
		sei

		st0	#$02
		sta	$0002
		st2	#$02

		cli

		rts


;----------------------------
putchar:
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

		txa
		ora	<puthexaddr
		sta	<puthexaddr

		sei

		st0	#$00
		ldy	<puthexaddr
		sty	$0002
		ldy	<puthexaddr+1
		sty	$0003

		st0	#$02
		lda	<puthexdata
		sta	$0002
		st2	#$02

		cli

		ply
		plx
		pla

		rts


;----------------------------
puthex2:
		pha
		phx
		phy

		sta	<puthexdata

		ldx	<puthexdata
		lda	lsr4data, x
		jsr	numtochar
		tax

		lda	<puthexdata
		and	#$0F
		jsr	numtochar

		sei

		st0	#$02
		stx	$0002
		st2	#$02

		sta	$0002
		st2	#$02

		cli

		ply
		plx
		pla

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

		txa
		ora	<puthexaddr
		sta	<puthexaddr

		ldx	<puthexdata
		lda	lsr4data, x
		jsr	numtochar
		tax

		lda	<puthexdata
		and	#$0F
		jsr	numtochar

		sei

		st0	#$00
		ldy	<puthexaddr
		sty	$0002
		ldy	<puthexaddr+1
		sty	$0003

		st0	#$02
		stx	$0002
		st2	#$02

		sta	$0002
		st2	#$02

		cli

		ply
		plx
		pla

		rts


;----------------------------
setsprite3:
		ldx	<spritenowork
		lda	shipdataindex, x
		sta	<spritenowork
		lda	shipdataindex+1, x
		sta	<spritenowork+1

		cly
		lda	[spritenowork], y
		tax

.spset3loop:
;sprite y
		iny
		clc
		lda	[spritenowork], y
		adc	<spriteywork
		sta	<spritexywork

		iny
		lda	[spritenowork], y
		adc	<spriteywork+1
		sta	<spritexywork+1

		cmp	#$04
		bcc	.spset3jump00	; < $04

		stz	<spritexywork
		stz	<spritexywork+1

.spset3jump00:
		lda	<spritexywork
		sta	[spriteworkaddress]
		lda	<spritexywork+1
		inc	<spriteworkaddress
		sta	[spriteworkaddress]

;sprite x
		iny
		clc
		lda	[spritenowork], y
		adc	<spritexwork
		sta	<spritexywork

		iny
		lda	[spritenowork], y
		adc	<spritexwork+1
		sta	<spritexywork+1

		cmp	#$04
		bcc	.spset3jump01	; < $04

		stz	<spritexywork
		stz	<spritexywork+1

.spset3jump01:
		lda	<spritexywork
		inc	<spriteworkaddress
		sta	[spriteworkaddress]
		lda	<spritexywork+1
		inc	<spriteworkaddress
		sta	[spriteworkaddress]

;sprite no
		iny
		lda	[spritenowork], y
		inc	<spriteworkaddress
		sta	[spriteworkaddress]
		iny
		lda	[spritenowork], y
		inc	<spriteworkaddress
		sta	[spriteworkaddress]

;sprite attribute
		iny
		lda	[spritenowork], y
		inc	<spriteworkaddress
		sta	[spriteworkaddress]
		iny
		lda	[spritenowork], y
		inc	<spriteworkaddress
		sta	[spriteworkaddress]

		inc	<spriteworkaddress
		bne	.spset3jump02
		inc	<spriteworkaddress+1
.spset3jump02:
		dex
		bne	.spset3loop

		rts


;----------------------------
init:
		cly
vdpdataloop:	lda	vdpdata, y
		cmp	#$FF
		beq	vdpdataend
		sta	$0000
		iny

		lda	vdpdata, y
		sta	$0002
		iny

		lda	vdpdata, y
		sta	$0003
		iny
		bra	vdpdataloop
vdpdataend:

;disable interrupts TIQD       IRQ2D
		lda	#$05
		sta	$1402

;262Line  VCE Clock 10MHz
		lda	#$06
		sta	$0400
		stz	$0401

;palette
		stz	$0402
		stz	$0403
		tia	bgpalettedata, $0404, $60

		stz	$0402
		lda	#$01
		sta	$0403
		tia	sppalettedata, $0404, $20

;clear BAT
		st0	#$00
		st1	#$00
		st2	#$00
		st0	#$02
		ldy	#64
.clearbatloop0:
		ldx	#64
.clearbatloop1:
		st1	#$00
		st2	#$02
		dex
		bne	.clearbatloop1
		dey
		bne	.clearbatloop0

;CHAR set to vram
		lda	#$12
		tam	#$02

;vram address $2000
		st0	#$00
		st1	#$00
		st2	#$20

		st0	#$02
		tia	$4000, $0002, $2000

;Sprite CHAR set to vram
		lda	#$13
		tam	#$02

;vram address $4000
		st0	#$00
		st1	#$00
		st2	#$40

		st0	#$02
		tia	$4000, $0002, $2000

;make char
;vram address $1000
		st0	#$00
		st1	#$00
		st2	#$10

		st0	#$02

		ldy	#$00
.makecharloop00:
		ldx	#$00
.makecharloop01:
		txa
		and	#$03
		jsr	makechar

		tya
		and	#$03
		jsr	makechar

		txa
		lsr	a
		lsr	a
		jsr	makechar

		tya
		lsr	a
		lsr	a
		jsr	makechar

		inx
		cpx	#$10
		bne	.makecharloop01

		iny
		cpy	#$10
		bne	.makecharloop00

;clear zeropage
		stz	$2000
		tii	$2000, $2001, $00FF

;clear Sprite abt vram
		stz	$2200
		tii	$2200, $2201, $01FF

		st0	#$00
		st1	#$00
		st2	#$30

		st0	#$02
		tia	$2200, $0002, 512

;clear	sprite work
		stz	spritework
		tii	spritework, spritework+1, 64 * 8 - 1

;loopxfunc set
		tii	loopxfuncdata, loopxfunc, 122

;set code bank6
		lda	#$01
		tam	#$06

;initialize psg

		jsr	psginit

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

;jump main
		jmp	main


;----------------------------
_irq1:
;IRQ1 interrupt process
		pha
		phx
		phy
;ACK interrupt
		lda	$0000
		sta	<vdpstatus
		bbs5	<vdpstatus, .vsyncproc

;raster
		st0	#$07
		st1	#$00
		st2	#$00
		jmp	.irq1end

.vsyncproc:

;psg process
		jsr	psgrun

;lap time
		sed

		clc
		lda	laptime
		adc	#1
		sta	laptime

		cmp	#$60
		bne	.laptimeend
		stz	laptime

		clc
		lda	laptime+1
		adc	#1
		sta	laptime+1

		cmp	#$60
		bne	.laptimeend
		stz	laptime+1

		clc
		lda	laptime+2
		adc	#1
		sta	laptime+2
.laptimeend:
		cld

;scrool x set 0
		lda	centerangletmp
		stz	<scrollxwork

		asl	a
		rol	<scrollxwork
		asl	a
		rol	<scrollxwork
		asl	a
		rol	<scrollxwork

		st0	#$07
		sta	$0002
		lda	<scrollxwork
		and	#$01
		sta	$0003

;frame count
		lda	framecount
		inc	a
		sta	framecount
		cmp	#60
		bne	.framecountend

		lda	drawcount
		sta	drawcountwork

;count set 0
		stz	framecount
		stz	drawcount

.framecountend:
		jsr	getpaddata
		jsr	checkpadmove

;enemy speed
		lda	enemyspeed
		cmp	#$E0
		bcs	.enemyspeedend	;enemyspeed >= $E0
		inc	a
		sta	enemyspeed
.enemyspeedend:

;move enemy
		lda	enemyy+2
		lsr	a
		tay
		clc
		lda	mapconv, y
		adc	#8		;add $10000(64K)
		tam	#$04

		tya
		and	#$1F
		ora	#$80

		stz	<hitwork
		sta	<hitwork+1

		lda	enemyx+3
		lsr	a
		lda	enemyx+2
		ror	a

		tay
		lda	[hitwork], y

		sta	enemyangle

;add movement enemyx enemyy
		ldy	enemyangle

;add movement enemyx
;enemyx + sin
		lda	sindatalow, y
		sta	<mul16a
		lda	sindatahigh, y
		sta	<mul16a+1

		lda	enemyspeed
		sta	<mul16b
		lda	enemyspeed+1
		sta	<mul16b+1

		jsr	smul16

		clc
		lda	enemyx
		adc	<mul16c
		sta	enemyx

		lda	enemyx+1
		adc	<mul16c+1
		sta	enemyx+1

		lda	enemyx+2
		adc	<mul16d
		sta	enemyx+2

		lda	enemyx+3
		adc	<mul16d+1
		and	#$01
		sta	enemyx+3

;add movement enemyy
;enemyy - cos
		lda	cosdatalow, y
		sta	<mul16a
		lda	cosdatahigh, y
		sta	<mul16a+1

		lda	enemyspeed
		sta	<mul16b
		lda	enemyspeed+1
		sta	<mul16b+1

		jsr	smul16

		sec
		lda	enemyy
		sbc	<mul16c
		sta	enemyy

		lda	enemyy+1
		sbc	<mul16c+1
		sta	enemyy+1

		lda	enemyy+2
		sbc	<mul16d
		sta	enemyy+2

		lda	enemyy+3
		sbc	<mul16d+1
		and	#$00
		sta	enemyy+3

.irq1end:
		st0	#$02

		ply
		plx
		pla
		rti


;----------------------------
_irq2:
_timer:
_nmi:
;IRQ2 TIMER NMI interrupt process
		rti


;----------------------------
stagedata:
		.db	$14, 176, 0, 38, 176, 0, 42, 64	;BANKNo, ShipXLow, ShipXHigh, ShipY, EnemyXLow, EnemyXHigh, EnemyY, Angle
		.db	$20, 180, 0, 16, 180, 0, 20, 64


;----------------------------
secconv:
		.db	$00, $02, $03, $05, $07, $08, $10, $12, $13, $15, $00, $00, $00, $00, $00, $00,\
			$17, $18, $20, $22, $23, $25, $27, $28, $30, $32, $00, $00, $00, $00, $00, $00,\
			$33, $35, $37, $38, $40, $42, $43, $45, $47, $48, $00, $00, $00, $00, $00, $00,\
			$50, $52, $53, $55, $57, $58, $60, $62, $63, $65, $00, $00, $00, $00, $00, $00,\
			$67, $68, $70, $72, $73, $75, $77, $78, $80, $82, $00, $00, $00, $00, $00, $00,\
			$83, $85, $87, $88, $90, $92, $93, $95, $97, $98, $00, $00, $00, $00, $00, $00


;----------------------------
bgdata00:
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		.db	$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02

		.db	$04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
		.db	$04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04

		.db	$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
		.db	$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06

		.db	$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
		.db	$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08

		.db	$0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $14, $18
		.db	$14, $18, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A

		.db	$0C, $0C, $0E, $0C, $0E, $0E, $0C, $0E, $0C, $0E, $0C, $10, $10, $10, $12, $16
		.db	$12, $16, $10, $10, $0C, $0C, $0E, $0C, $0C, $0E, $0C, $0C, $0C, $0C, $0E, $0E


;----------------------------
enemynoconv	.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\
			$02, $02, $02, $02, $02, $02, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04,\
			$04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04,\
			$04, $04, $04, $04, $04, $04, $04, $04, $06, $06, $06, $06, $06, $06, $06, $06,\
			$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06,\
			$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06,\
			$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
enemyxconvlow	.db	$C4, $89, $4D, $12, $D6, $9B, $5F, $24, $E8, $AD, $90, $72, $36, $19, $FB, $DD,\
			$BF, $A2, $84, $66, $48, $2B, $0D, $F9, $E5, $D1, $BE, $AA, $96, $87, $78, $69,\
			$5A, $4C, $3D, $2E, $1F, $16, $0C, $02, $F8, $EE, $DA, $D0, $C6, $BC, $B2, $A8,\
			$9D, $95, $8D, $85, $7D, $75, $6D, $68, $60, $59, $51, $49, $41, $39, $31, $2C,\
			$26, $20, $1A, $14, $0E, $08, $02, $FC, $F6, $F1, $EC, $E7, $E2, $DA, $D8, $D3,\
			$CE, $C9, $C4, $BF, $BC, $BA, $B7, $B3, $AF, $AB, $A7, $A3, $9F, $9B, $97, $93,\
			$8F, $8B, $87, $83, $7F, $7C, $79, $76, $74, $73, $70, $6D, $6B, $6A, $67, $64,\
			$62, $61, $5E, $5B, $59, $58, $55, $52, $4F, $4D, $4C, $49, $46, $43, $42, $40,\
			$3E, $3C, $3A, $38, $36, $35, $34, $32, $30, $2E, $2C, $2A, $28, $27, $26, $24,\
			$24, $22, $20, $1E, $1C, $1A, $18, $16, $14, $12, $10, $0E, $0C, $0A, $08, $07,\
			$06, $05, $04, $03, $02, $01, $00, $FF, $FE, $FD, $FC, $FB, $FA, $F9, $F8, $F7,\
			$F6, $F5, $F4, $F3, $F2, $F1, $F0, $EF, $EE, $ED, $EC, $EB, $EA, $E9, $E8, $E7,\
			$E6, $E5, $E4, $E3, $E2, $E1, $E0, $DF, $DE, $DD, $DC, $DB, $DA, $D9, $D8, $D7,\
			$D6, $D5, $D4, $D3, $D2, $D1, $D0, $CF, $CE, $CD, $CC, $CC, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
enemyxconvhigh	.db	$07, $07, $07, $07, $06, $06, $06, $06, $05, $05, $05, $05, $05, $05, $04, $04,\
			$04, $04, $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03, $03, $03,\
			$03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02,\
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\
			$02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
enemyyconv	.db	$B0, $AC, $A8, $A4, $A0, $9C, $98, $94, $92, $90, $8C, $8A, $88, $86, $84, $82, \
			$80, $7E, $7C, $7A, $78, $76, $75, $74, $72, $71, $70, $6F, $6E, $6D, $6C, $6B, \
			$6A, $69, $68, $67, $66, $65, $64, $64, $63, $62, $61, $61, $60, $60, $5F, $5E, \
			$5E, $5D, $5D, $5C, $5C, $5B, $5B, $5A, $5A, $59, $59, $58, $58, $57, $57, $56, \
			$56, $55, $55, $55, $54, $54, $54, $53, $53, $53, $52, $52, $52, $51, $51, $51, \
			$50, $50, $50, $50, $4F, $4F, $4F, $4E, $4E, $4E, $4E, $4D, $4D, $4D, $4D, $4C, \
			$4C, $4C, $4C, $4B, $4B, $4B, $4B, $4B, $4B, $4A, $4A, $4A, $4A, $4A, $4A, $49, \
			$49, $49, $49, $49, $49, $48, $48, $48, $48, $48, $48, $48, $47, $47, $47, $47, \
			$47, $47, $47, $46, $46, $46, $46, $46, $46, $46, $46, $46, $46, $45, $45, $45, \
			$45, $45, $45, $45, $45, $44, $44, $44, $44, $44, $44, $44, $44, $43, $43, $43, \
			$43, $43, $43, $43, $43, $43, $43, $42, $42, $42, $42, $42, $42, $42, $42, $42, \
			$42, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $40, $40, $40, $40, $40, \
			$40, $40, $40, $40, $40, $40, $40, $40, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, \
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, \
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, \
			$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


;----------------------------
shipdataindex:
		.dw	shipdata00
		.dw	shipdata01
		.dw	shipdata02
		.dw	shipdata03
		.dw	shipdata04

shipdata00:
		.db	8

		.dw	$0030	;64 - 16
		.dw	$FFF0	;32 - 64 + 16
		.dw	$0200	;No 0
		.dw	$1080	;Y 2CGY X 1CGX SP COLOR0

		.dw	$0030	;64 - 16
		.dw	$0000	;32 - 32
		.dw	$0208	;No 4
		.dw	$1180	;Y 2CGY X 2CGX SP COLOR0

		.dw	$0030	;64 - 16
		.dw	$0020	;32
		.dw	$0208	;No 4
		.dw	$1980	;Y 2CGY ~X 2CGX SP COLOR0

		.dw	$0030	;64 - 16
		.dw	$0040	;32 + 32
		.dw	$0200	;No 0
		.dw	$1880	;Y 2CGY ~X 1CGX SP COLOR0

		.dw	$0048	;64 - 16 + 16 + 8
		.dw	$FFE0	;32 - 64
		.dw	$0210	;No 8
		.dw	$0180	;Y 1CGY X 2CGX SP COLOR0

		.dw	$0048	;64 - 16 + 16 + 8
		.dw	$0000	;32 - 32
		.dw	$0214	;No 10
		.dw	$0180	;Y 1CGY X 2CGX SP COLOR0

		.dw	$0048	;64 + 128 + 32 - 16 + 16 + 8
		.dw	$0020	;32
		.dw	$0214	;No 10
		.dw	$8980	;~Y 1CGY ~X 2CGX SP COLOR0

		.dw	$0048	;64 - 16 + 16 + 8
		.dw	$0040	;32 + 32
		.dw	$0210	;No 8
		.dw	$8980	;~Y 1CGY ~X 2CGX SP COLOR0

shipdata01:
		.db	4

		.dw	$0040	;64 - 16 + 16
		.dw	$FFF0	;32 - 64 + 16
		.dw	$0202	;No 1
		.dw	$0080	;Y 1CGY X 1CGX SP COLOR0

		.dw	$0030	;64 - 16
		.dw	$0000	;32 - 32
		.dw	$0228	;No 20
		.dw	$1180	;Y 2CGY X 2CGX SP COLOR0

		.dw	$0030	;64 - 16
		.dw	$0020	;32
		.dw	$0228	;No 20
		.dw	$1980	;Y 2CGY ~X 2CGX SP COLOR0

		.dw	$0040	;64 - 16 + 16
		.dw	$0040	;32 + 32
		.dw	$0202	;No 1
		.dw	$0880	;Y 1CGY ~X 1CGX SP COLOR0

shipdata02:
		.db	2

		.dw	$0030	;64 - 16
		.dw	$0000	;32 - 32
		.dw	$0220	;No 16
		.dw	$1180	;Y 2CGY X 2CGX SP COLOR0

		.dw	$0030	;64 - 16
		.dw	$0020	;32
		.dw	$0220	;No 16
		.dw	$1980	;Y 2CGY ~X 2CGX SP COLOR0

shipdata03:
		.db	2

		.dw	$0038	;64 - 8
		.dw	$0010	;32 - 16
		.dw	$0206	;No 3
		.dw	$0080	;Y 1CGY X 1CGX SP COLOR0

		.dw	$0038	;64 - 8
		.dw	$0020	;32
		.dw	$0206	;No 3
		.dw	$0880	;Y 1CGY ~X 1CGX SP COLOR0

shipdata04:
		.db	1

		.dw	$0038	;64 - 8
		.dw	$0018	;32 - 8
		.dw	$0230	;No 24
		.dw	$0080	;Y 1CGY X 1CGX SP COLOR0


;----------------------------
vdpdata:
		.db	$05, $00, $00	;screen off
		.db	$0A, $02, $0B	;HSW $02 HDS $0B
		.db	$0B, $3F, $04	;HDW $3F HDE $04
		.db	$0C, $02, $0D	;VSW $02 VDS $0D
		.db	$0D, $EF, $00	;VDW $00EF
		.db	$0E, $03, $00	;VCR $03
		.db	$07, $00, $00	;scrollx 0
		.db	$08, $00, $00	;scrolly 0
		.db	$09, $50, $00	;64x64
		.db	$FF		;end


;----------------------------
linebgpalettedata:
		.db	$21, $00, $11, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00,\
			$01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00

;----------------------------
bgpalettedata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF

		.dw	$0049, $0061, $0109, $0121, $004C, $0064, $010C, $016D,\
			$01B6, $00BA, $01D2, $01FA, $0097, $00BF, $01D7, $01FF

		.dw	$00DB, $00E3, $011B, $0123, $00DC, $00E4, $011C, $01B6,\
			$01FF, $013C, $01E4, $01FC, $0127, $013F, $01E7, $01FF


;----------------------------
sppalettedata:
		.dw	$0000, $0020, $0100, $0120, $0004, $0024, $0104, $0124,\
			$01B6, $0038, $01C0, $01F8, $0007, $003F, $01C7, $01FF


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


;------- do not move for loopxfunc -------------
;+++++++++++++++++++++++++++++++++++++++++++++++
		.org  $FC00
asl4data:
		.db	$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0,\
			$00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $A0, $B0, $C0, $D0, $E0, $F0


;----------------------------
		.org  $FD00
lsr4data:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,\
			$02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,\
			$03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03,\
			$04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04,\
			$05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05,\
			$06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06,\
			$07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07,\
			$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08,\
			$09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09,\
			$0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A,\
			$0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B,\
			$0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C,\
			$0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D,\
			$0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E,\
			$0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F


;----------------------------
		.org  $FE00
mapconvaddr:
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


;+++++++++++++++++++++++++++++++++++++++++++++++
;-----------------------------------------------

		.org	$FF00
;----------------------------
loopxfuncdata:
		.db	$A0, $40, $A6, $05, $BD, $00, $3F, $53, $04, $BD, $00, $FE, $85, $92, $A6, $02,\
			$BD, $00, $00, $FF, $01, $04, $AA, $BD, $00, $FD, $29, $0F, $85, $B9, $A6, $0B,\
			$BD, $00, $3F, $53, $04, $BD, $00, $FE, $85, $AE, $A6, $08, $BD, $00, $00, $7F,\
			$07, $04, $AA, $BD, $00, $FC, $29, $F0, $09, $00, $78, $8D, $02, $00, $23, $01,\
			$58, $A2, $00, $18, $F4, $69, $00, $E8, $F4, $69, $00, $E8, $F4, $69, $00, $E8,\
			$18, $F4, $69, $00, $E8, $F4, $69, $00, $E8, $F4, $69, $00, $E8, $18, $F4, $69,\
			$00, $E8, $F4, $69, $00, $E8, $F4, $69, $00, $E8, $18, $F4, $69, $00, $E8, $F4,\
			$69, $00, $E8, $F4, $69, $00, $88, $D0, $89, $60


;----------------------------
vramaddrconv:
		.dw	$0200, $0240, $0280, $02C0, $0300, $0340, $0380, $03C0,\
			$0400, $0440, $0480, $04C0, $0500, $0540, $0580, $05C0


;----------------------------
;interrupt vectors
		.org	$FFF6

		.dw	_irq2
		.dw	_irq1
		.dw	_timer
		.dw	_nmi
		.dw	_reset


;///////////////////////////////////////////////
		.code
		.bank	1
		.org	$C000
;----------------------------
putline:
;put line process
;centerangletmp centerxtmp centerytmp

;initialize line counter
		clx

;set x y sin cos data
;set x y sin cos data address
;256angle * 32line * 16byte[x(4byte), y(4byte), sin(4byte), cos(4byte)]
		stz	<calclineptr
		lda	centerangletmp
		asl	a
		and	#$1F
		clc
		adc	#$60
		sta	<calclineptr+1

		ldy	centerangletmp
		lda	lsr4data, y
		inc	a
		inc	a
		tam	#$03

;put line loop
.calcloop:

;set line bg palette
		lda	linebgpalettedata, x
		sta	<$BF		;loopfunc addr $BF

;set VRAM address
		sei
		st0	#$00
		lda	vramaddrconv, x
		sta	$0002
		lda	vramaddrconv+1, x
		sta	$0003
		st0	#$02
		cli

;calculate high line
;set x0a y0a
;X=xcosA-ysinA X+=centerx process
		clc
		cly
		lda	[calclineptr], y
		adc	centerxtmp
		sta	<x0a

		iny
		lda	[calclineptr], y
		adc	centerxtmp+1
		sta	<x0a+1

		iny
		lda	[calclineptr], y
		adc	centerxtmp+2
		sta	<x0a+2

		iny
		lda	[calclineptr], y
		adc	centerxtmp+3
		;sta	<???
		lsr	a
		ror	<x0a+2
		ror	<x0a+1
		ror	<x0a

;Y=xsinA+ycosA Y+=centery process
		clc
		ldy	#$04
		lda	[calclineptr], y
		adc	centerytmp
		sta	<y0a

		iny
		lda	[calclineptr], y
		adc	centerytmp+1
		sta	<y0a+1

		iny
		lda	[calclineptr], y
		adc	centerytmp+2
		sta	<y0a+2

		;iny
		;lda	[calclineptr], y
		;adc	centerytmp+3
		;sta	<???

;set loopxfunc sin0 cos0
;sin0
		ldy	#$08
		lda	[calclineptr], y
		sta	<$D3		;loopfunc addr $D3

		iny
		lda	[calclineptr], y
		sta	<$D7		;loopfunc addr $D7

		iny
		lda	[calclineptr], y
		sta	<$DB		;loopfunc addr $DB

;cos0
		ldy	#$0C
		lda	[calclineptr], y
		sta	<$C6		;loopfunc addr $C6

		iny
		lda	[calclineptr], y
		sta	<$CA		;loopfunc addr $CA

		iny
		lda	[calclineptr], y

		cmp	#$80
		ror	a
		sta	<$CE		;loopfunc addr $CE
		ror	<$CA
		ror	<$C6

;increment calclinecounter
		inx

;calculate low line
;set x1a y1a
;X=xcosA-ysinA X+=centerx process
		clc
		ldy	#$10
		lda	[calclineptr], y
		adc	centerxtmp
		sta	<x1a

		iny
		lda	[calclineptr], y
		adc	centerxtmp+1
		sta	<x1a+1

		iny
		lda	[calclineptr], y
		adc	centerxtmp+2
		sta	<x1a+2

		iny
		lda	[calclineptr], y
		adc	centerxtmp+3
		;sta	<???
		lsr	a
		ror	<x1a+2
		ror	<x1a+1
		ror	<x1a

;Y=xsinA+ycosA Y+=centery process
		clc
		ldy	#$14
		lda	[calclineptr], y
		adc	centerytmp
		sta	<y1a

		iny
		lda	[calclineptr], y
		adc	centerytmp+1
		sta	<y1a+1

		iny
		lda	[calclineptr], y
		adc	centerytmp+2
		sta	<y1a+2

		;iny
		;lda	[calclineptr], y
		;adc	centerytmp+3
		;sta	<???

;set loopxfunc sin1 cos1
;sin1
		ldy	#$18
		lda	[calclineptr], y
		sta	<$ED		;loopfunc addr $ED

		iny
		lda	[calclineptr], y
		sta	<$F1		;loopfunc addr $F1

		iny
		lda	[calclineptr], y
		sta	<$F5		;loopfunc addr $F5

;cos1
		ldy	#$1C
		lda	[calclineptr], y
		sta	<$E0		;loopfunc addr $E0

		iny
		lda	[calclineptr], y
		sta	<$E4		;loopfunc addr $E4

		iny
		lda	[calclineptr], y

		cmp	#$80
		ror	a
		sta	<$E8		;loopfunc addr $E8
		ror	<$E4
		ror	<$E0

;jump loopxfunc
		phx
		jsr	loopxfunc
		plx

;set x y sin cos data address(next 2lines)
		clc
		lda	<calclineptr
		adc	#$20
		sta	<calclineptr
		bcc	.sincosaddrjump
		inc	<calclineptr+1
.sincosaddrjump:

;increment calclinecounter
		inx
		cpx	#32
		beq	.calcloopend
		jmp	.calcloop
.calcloopend:
		rts

;----------------------------
psgrun:
		stz	<psgchno
		clx

.psgrunloop:
		;dec	psg0count, x
		;bne	.psgrunjump07

		lda	psg0count, x
		beq	.psgrunjump00
		dec	a
		sta	psg0count, x
		jmp	.psgrunjump07

.psgrunjump00:
		lda	[psg0addr, x]
		bmi	.psgrunjump01

		and	#$0F
		cmp	#$0C
		bcs	.psgrunjump02

;note
		asl	a
		tay
		lda	psgfreqdata, y
		sta	<psgfreqwork
		lda	psgfreqdata+1, y
		sta	<psgfreqwork+1

		lda	[psg0addr, x]
		tay
		lda	lsr4data, y

;scale(octave) shift
.psgrunjump04:
		dec	a
		bmi	.psgrunjump03

		lsr	<psgfreqwork+1
		ror	<psgfreqwork
		bra	.psgrunjump04

.psgrunjump03:
		lda	<psgchno

		sta	$0800	;select ch
		lda	<psgfreqwork
		sta	$0802	;r2 frequency
		lda	<psgfreqwork+1
		sta	$0803	;r3 frequency
		lda	#$9F
		sta	$0804	;r4 keyon ddaoff volume31

		bra	.psgrunjump05

;rest
.psgrunjump02:
		lda	<psgchno
		sta	$0800	;select ch
		lda	#$00
		sta	$0804	;r4 keyoff ddaoff volume0

;set count
.psgrunjump05:
		jsr	psgdatanext
		lda	[psg0addr, x]
		dec	a
		sta	psg0count, x

		jsr	psgdatanext
		bra	.psgrunjump07

.psgrunjump01:
		jsr	psgdatanext
		lda	[psg0addr, x]
		sta	psgdataaddrwork
		jsr	psgdatanext
		lda	[psg0addr, x]
		sta	psgdataaddrwork+1

		clc
		lda	psg0dataaddr, x
		adc	psgdataaddrwork
		sta	psg0addr, x
		lda	psg0dataaddr+1, x
		adc	psgdataaddrwork+1
		sta	psg0addr+1, x

		jmp	.psgrunjump00

.psgrunjump07:
		inc	<psgchno

		inx
		inx
		inx
		inx
		inx

		cpx	#10
		beq	.psgrunend
		jmp	.psgrunloop

.psgrunend:
		rts

;----------------------------
psgdatanext:
		clc
		lda	psg0addr, x
		adc	#$01
		sta	psg0addr, x
		lda	psg0addr+1, x
		adc	#$00
		sta	psg0addr+1, x

		rts


;----------------------------
psginit:
		;$0800~$080F

		cla
		sta	$0800	;select ch0
		sta	$0801	;ch0 r1 mainvolumeleft0 mainvolumeright0
		sta	$0808	;ch0 r8 lfofrequency0
		sta	$0809	;ch0 r9 lfooff lfoctl0

.psginitloop0:
		sta	$0800	;ch select

		clx
		stx	$0802	;r2 frequency0
		stx	$0803	;r3 frequency0

		ldx	#$40	;r4 ddaon(wave buffer index reset)
		stx	$0804
		clx
		stx	$0804	;r4 keyoff ddaoff volume0

		stx	$0805	;r5 leftvolume0 rightvolume0

		sta	$0807	;r7 noiseoff noisefrequency0

		inc	a
		cmp	#6
		bne	.psginitloop0

		lda	#$00
		sta	$0800	;ch0 select

		clx
.psginitloop1:
		lda	psgwavedata0, x
		sta	$0806	;ch0 r6 wavebuffer
		inx
		cpx	#$20
		bne	.psginitloop1


		lda	#$01
		sta	$0800	;ch0 select

		clx
.psginitloop2:
		lda	psgwavedata1, x
		sta	$0806	;ch1 r6 wavebuffer
		inx
		cpx	#$20
		bne	.psginitloop2


		cla
		sta	$0800	;select ch0

		lda	#$FF
		sta	$0801	;ch0 r1 mainvolumeleft15 mainvolumeright15

		lda	#$88
		sta	$0805	;ch0 r5 leftvolume15 rightvolume15

		lda	#1
		sta	$0800	;select ch1

		lda	#$CC
		sta	$0805	;ch1 r5 leftvolume0 rightvolume15

;;psg clock 3579545
;;freq = 3579545 / (Hz * 32)
;;3579545 / (440 * 32) = 254.2290482954545

		lda	#LOW(psgmmldata0)
		sta	psg0dataaddr
		sta	<psg0addr
		lda	#HIGH(psgmmldata0)
		sta	psg0dataaddr+1
		sta	<psg0addr+1

		stz	psg0count

		lda	#LOW(psgmmldata1)
		sta	psg1dataaddr
		sta	<psg1addr
		lda	#HIGH(psgmmldata1)
		sta	psg1dataaddr+1
		sta	<psg1addr+1

		stz	psg1count

		rts


;----------------------------
psgmmldata0:
		.db	$27, $07, $0C, $02,\	;1
			$27, $07, $0C, $02,\
			$27, $07, $0C, $02,\
			$27, $07, $0C, $02,\
			$27, $07, $0C, $02,\
			$27, $07, $0C, $02,\
			$27, $07, $0C, $02,\
			$29, $07, $0C, $02

		.db	$29, $07, $0C, $02,\	;2
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$2A, $07, $0C, $02

		.db	$2A, $07, $0C, $02,\	;3
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$29, $07, $0C, $02

		.db	$29, $07, $0C, $02,\	;4
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02

		.db	$2A, $07, $0C, $02,\	;5
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$29, $07, $0C, $02

		.db	$29, $07, $0C, $02,\	;6
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$2A, $07, $0C, $02

		.db	$2A, $07, $0C, $02,\	;7
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$2A, $07, $0C, $02,\
			$29, $07, $0C, $02

		.db	$29, $07, $0C, $02,\	;8
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02,\
			$29, $07, $0C, $02

		.db	$45, $19, $0C, $02,\	;9
			$43, $19, $0C, $02,\
			$42, $10, $0C, $02

		.db	$40, $19, $0C, $02,\	;10
			$42, $19, $0C, $02,\
			$43, $10, $0C, $02

		.db	$45, $19, $0C, $02,\	;11
			$43, $19, $0C, $02,\
			$42, $10, $0C, $02

		.db	$40, $22, $0C, $02,\	;12
			$0C, $12,\
			$40, $04,\
			$42, $05,\
			$43, $04,\
			$45, $05

		.db	$47, $19, $0C, $02,\	;13
			$45, $19, $0C, $02,\
			$4A, $10, $0C, $02

		.db	$48, $19, $0C, $02,\	;14
			$47, $19, $0C, $02,\
			$45, $10, $0C, $02

		.db	$47, $19, $0C, $02,\	;15
			$48, $19, $0C, $02,\
			$47, $10, $0C, $02

		.db	$45, $19, $0C, $02,\	;16
			$43, $19, $0C, $02,\
			$42, $10, $0C, $02

		.db	$45, $19, $0C, $02,\	;17
			$43, $19, $0C, $02,\
			$42, $10, $0C, $02

		.db	$40, $19, $0C, $02,\	;18
			$42, $19, $0C, $02,\
			$43, $10, $0C, $02

		.db	$45, $19, $0C, $02,\	;19
			$43, $19, $0C, $02,\
			$42, $10, $0C, $02

		.db	$40, $22, $0C, $02,\	;20
			$0C, $12,\
			$40, $04,\
			$42, $05,\
			$43, $04,\
			$45, $05

		.db	$47, $19, $0C, $02,\	;21
			$45, $19, $0C, $02,\
			$4A, $10, $0C, $02

		.db	$48, $19, $0C, $02,\	;22
			$47, $19, $0C, $02,\
			$45, $10, $0C, $02

		.db	$47, $19, $0C, $02,\	;23
			$48, $19, $0C, $02,\
			$47, $10, $0C, $02

		.db	$45, $19, $0C, $02,\	;24
			$43, $19, $0C, $02,\
			$42, $10, $0C, $02

		.db	$39, $22, $0C, $02,\	;25
			$0C, $09,\
			$37, $07, $0C, $02,\
			$39, $07, $0C, $02,\
			$3A, $07, $0C, $02

		.db	$40, $22, $0C, $02,\	;26
			$0C, $09,\
			$37, $07, $0C, $02,\
			$39, $07, $0C, $02,\
			$3A, $07, $0C, $02

		.db	$42, $22, $0C, $02,\	;27
			$0C, $09,\
			$39, $07, $0C, $02,\
			$3A, $07, $0C, $02,\
			$42, $07, $0C, $02

		.db	$43, $22, $0C, $02,\	;28
			$0C, $09,\
			$39, $07, $0C, $02,\
			$3A, $07, $0C, $02,\
			$43, $07, $0C, $02

		.db	$45, $22, $0C, $02,\	;29
			$0C, $09,\
			$28, $07, $0C, $02,\
			$31, $07, $0C, $02,\
			$33, $07, $0C, $02

		.db	$35, $22, $0C, $02,\	;30
			$0C, $09,\
			$31, $07, $0C, $02,\
			$35, $07, $0C, $02,\
			$38, $07, $0C, $02

		.db	$41, $22, $0C, $02,\	;31
			$0C, $09,\
			$35, $07, $0C, $02,\
			$41, $07, $0C, $02,\
			$43, $07, $0C, $02

		.db	$45, $22, $0C, $02,\	;32
			$0C, $09,\
			$38, $07, $0C, $02,\
			$40, $07, $0C, $02,\
			$43, $07, $0C, $02

		.db	$46, $0A, $0C, $02,\	;33
			$45, $0A, $0C, $02,\
			$43, $0A, $0C, $02,\
			$41, $0A, $0C, $02,\
			$3B, $0A, $0C, $02,\
			$41, $0A, $0C, $02

		.db	$3A, $0A, $0C, $02,\	;34
			$38, $0A, $0C, $02,\
			$36, $0A, $0C, $02,\
			$35, $0A, $0C, $02,\
			$33, $0A, $0C, $02,\
			$31, $0A, $0C, $02

		.db	$33, $0A, $0C, $02,\	;35
			$35, $0A, $0C, $02,\
			$36, $0A, $0C, $02,\
			$33, $0A, $0C, $02,\
			$35, $0A, $0C, $02,\
			$36, $0A, $0C, $02

		.db	$43, $46, $0C, $02	;36

		.db	$0C, $24,\		;37
			$46, $04,\
			$44, $05,\
			$42, $04,\
			$41, $05,\
			$3B, $04,\
			$39, $05,\
			$38, $04,\
			$36, $05

		.db	$80, $00, $00


;----------------------------
psgmmldata1:
		;.db	$39, $FF, $0C, $FF, $80, $00, $00
		;.db	$30, $10, $0C, $10, $30, $10, $32, $10, $34, $40,\
		;	$37, $10, $0C, $10, $37, $10, $39, $10, $37, $40,\
		;	$80, $00, $00

		.db	$20, $46, $0C, $02	;1

		.db	$25, $46, $0C, $02	;2

		.db	$23, $46, $0C, $02	;3

		.db	$25, $2B, $0C, $02,\	;4
			$22, $10, $0C, $02,\
			$21, $07, $0C, $02

		.db	$20, $46, $0C, $02	;5

		.db	$25, $46, $0C, $02	;6

		.db	$23, $46, $0C, $02	;7

		.db	$25, $2B, $0C, $02,\	;8
			$22, $10, $0C, $02,\
			$21, $07, $0C, $02

		.db	$20, $07, $0C, $02,\	;9
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$22, $07, $0C, $02,\
			$1A, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$17, $07, $0C, $02,\	;10
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$20, $07, $0C, $02,\	;11
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$22, $07, $0C, $02,\
			$1A, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$17, $07, $0C, $02,\	;12
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$21, $07, $0C, $02,\	;13
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$23, $07, $0C, $02,\
			$10, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$18, $07, $0C, $02,\	;14
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$21, $07, $0C, $02,\	;15
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$23, $07, $0C, $02,\
			$10, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$18, $07, $0C, $02,\	;16
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$20, $07, $0C, $02,\	;17
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$22, $07, $0C, $02,\
			$1A, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$17, $07, $0C, $02,\	;18
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$20, $07, $0C, $02,\	;19
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$20, $07, $0C, $02,\
			$22, $07, $0C, $02,\
			$1A, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$17, $07, $0C, $02,\	;20
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02,\
			$17, $07, $0C, $02

		.db	$21, $07, $0C, $02,\	;21
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$23, $07, $0C, $02,\
			$10, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$18, $07, $0C, $02,\	;22
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$21, $07, $0C, $02,\	;23
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$21, $07, $0C, $02,\
			$23, $07, $0C, $02,\
			$10, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$18, $07, $0C, $02,\	;24
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$0C, $10, $0C, $02,\	;25
			$27, $07, $0C, $02,\
			$29, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$0C, $10, $0C, $02,\	;26
			$2A, $07, $0C, $02,\
			$30, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$0C, $10, $0C, $02,\	;27
			$27, $07, $0C, $02,\
			$29, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$0C, $10, $0C, $02,\	;28
			$2A, $07, $0C, $02,\
			$30, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$0C, $10, $0C, $02,\	;29
			$27, $07, $0C, $02,\
			$29, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$0C, $10, $0C, $02,\	;30
			$2A, $07, $0C, $02,\
			$30, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$0C, $10, $0C, $02,\	;31
			$27, $07, $0C, $02,\
			$29, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$0C, $10, $0C, $02,\	;32
			$2A, $07, $0C, $02,\
			$30, $10, $0C, $02,\
			$0C, $07, $0C, $02,\
			$0C, $10, $0C, $02

		.db	$13, $07, $0C, $02,\	;33
			$13, $07, $0C, $02,\
			$13, $07, $0C, $02,\
			$13, $07, $0C, $02,\
			$13, $07, $0C, $02,\
			$13, $07, $0C, $02,\
			$13, $07, $0C, $02,\
			$13, $07, $0C, $02

		.db	$0B, $07, $0C, $02,\	;34
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02

		.db	$06, $07, $0C, $02,\	;35
			$06, $07, $0C, $02,\
			$06, $07, $0C, $02,\
			$06, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02,\
			$18, $07, $0C, $02

		.db	$0B, $07, $0C, $02,\	;36
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02

		.db	$0B, $07, $0C, $02,\	;37
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02,\
			$0B, $07, $0C, $02

		.db	$80, $00, $00

;----------------------------
psgwavedata0:
		.db	$1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
psgwavedata1:
		.db	$00, $02, $04, $06, $08, $0A, $0C, $0E, $10, $12, $14, $16, $18, $1A, $1C, $1E,\
			$1E, $1C, $1A, $18, $16, $14, $12, $10, $0E, $0C, $0A, $08, $06, $04, $02, $00


;----------------------------
psgfreqdata:
		.dw	$0D5D, $0C9C, $0BE7, $0B3C, \
			$0A9B, $0A02, $0973, $08EB, \
			$086B, $07F2, $0780, $0714


;////////////////////////////
		.bank	2
		INCBIN	"x_y_sin_cos.dat"	;128K	 2~17	$02~$11
		INCBIN	"char.dat"		;8K	18	$12
		INCBIN	"ship.dat"		;8K	19	$13
		INCBIN	"course1.dat"		;64K	20~27	$14~$1B
		INCBIN	"course1angle.dat"	;32K	28~31	$1C~$1F
		INCBIN	"course2.dat"		;64K	32~39	$20~$27
		INCBIN	"course2angle.dat"	;32K	40~43	$28~$2B
