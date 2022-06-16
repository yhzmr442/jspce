;sg_test5.asm
;//////////////////////////////////
;Sound effect Files
;Taira Komori All Rights Reserved. 制作・著作 小森平  komoritaira@gmail.com
;https://taira-komori.jpn.org/
;//////////////////////////////////


;///////////////////////////
;////////    EQU    ////////
;///////////////////////////
;---------------------
		INCLUDE	"poly_equ.asm"

;---------------------
spDataBank		.equ	33
soundExplosion		.equ	34
soundLaser		.equ	35


;/////////////////////////////
;////////    MACRO    ////////
;/////////////////////////////
;---------------------
		INCLUDE	"poly_macro.asm"


;///////////////////////////
;////////    RAM    ////////
;///////////////////////////
		.zp
;----------------------------------
;---------------------
		INCLUDE	"poly_dszp.asm"

		.bss
;----------------------------------
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
enemyMAX		.equ	8
enemyNo			.equ	1
enemyByteSize		.equ	4
enemyState		.ds	enemyByteSize*enemyMAX
enemyX			.ds	enemyByteSize*enemyMAX
enemyY			.ds	enemyByteSize*enemyMAX
enemyZ			.ds	enemyByteSize*enemyMAX
enemyTimer		.ds	1

;---------------------
objectMAX		.equ	8
objectState		.ds	4*objectMAX
objectX			.ds	4*objectMAX
objectY			.ds	4*objectMAX
objectZ			.ds	4*objectMAX
objectTimer		.ds	1

;---------------------
starMAX			.equ	8
starState		.ds	2*starMAX
starX			.ds	2*starMAX
starY			.ds	2*starMAX
starZ			.ds	2*starMAX
starMovementZ		.ds	2*starMAX

;---------------------
checkHitWork		.ds	2

;---------------------
wallDeltaZ		.ds	2
wallDeltaZWork		.ds	2

;---------------------
		INCLUDE	"poly_ds.asm"


;///////////////////////////
;////////    ROM    ////////
;///////////////////////////
		.code
;////////////////////////////
		.bank	0
		.org	$E000

;----------------------------
main:
;
;initialize system
		jsr	initializeSystem

;initialize datas
		jsr	initializeDatas

;initialize vsync, auto-increment, screen display and hide
		jsr	initializeScreenVsync

;start timer for DDA
		jsr	startDda

;vsync interrupt start
		cli

.mainLoop:
;polygon and sprite initialize processing
;initialize buffer
		jsr	initializePolygonBuffer

;clear sat buffer
		jsr	clearSatBuffer

;game process
;don't let interruptions be blocked for a long time.

;check pad
		jsr	checkPad

;set world data
		jsr	setWorldData

;sprite process
;set aim
		jsr	setAim

;sprite process
;set star
		jsr	moveStar

;object move
		jsr	moveEnemy
		jsr	moveEnemyShot
		jsr	moveShot
		jsr	moveObject

;set enemy
		jsr	setEnemyByTimer

;set object
		jsr	setObjectByTimer

;set shot
		jsr	setShotByPad

;check hit
		jsr	checkHitShotEnemy

;set polygon color index
		cla
		jsr	setPolygonColorIndex

;set model
		jsr	setEnemyModel
		jsr	setEnemyShotModel
		jsr	setShotModel
		jsr	setObjectModel

;polygon and sprite output processing
;wait vsync and DMA
		jsr	waitScreenVsync

;put polygon
		jsr	putPolygonBuffer

;VRAM access operation process
		inc	drawCountWork

		ldx	#0
		ldy	#24
		jsr	calBatAddressXY

		lda	<selectVdc
		jsr	setWriteVramAddress

		lda	drawCount
		ldx	#$00
		ldy	<selectVdc
		jsr	putHex

;set SATB DMA
		jsr	setSatbDma

;set vsync flag
		jsr	setVsyncFlag

;jump mainloop
		jmp	.mainLoop


;----------------------------
checkPad:
;
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

;.checkShipLeft:
;		cmpw2	shipX, #-1024+128
;		bpl	.checkShipRight
;		movw	shipX, #-1024+128
;.checkShipRight:
;		cmpw2	shipX, #1024-128
;		bmi	.checkShipTop
;		movw	shipX, #1024-128
;.checkShipTop:
;		cmpw2	shipY, #1024-128
;		bmi	.checkShipBottom
;		movw	shipY, #1024-128
;.checkShipBottom:
;		cmpw2	shipY, #-1024+128
;		bpl	.checkShipEnd
;		movw	shipY, #-1024+128
;.checkShipEnd:

		rts


;----------------------------
setWall:
;
		stzw	<translationX
		stzw	<translationY
		stzw	<translationZ

		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0
		mov	<rotationSelect, #$12

		movw	<modelAddr, #modelData007

		jsr	setModel2
		rts


;----------------------------
setDeltaWall:
;
		movw	wallDeltaZWork, wallDeltaZ

		ldx	#4
.deltaLoop:
		stzw	<translationX
		movw	<translationY, #-1024
		movw	<translationZ, wallDeltaZWork

		mov	<rotationX, #0
		mov	<rotationY, #0
		mov	<rotationZ, #0
		mov	<rotationSelect, #$12

		movw	<modelAddr, #modelData009

		jsr	setModel2

		addw	wallDeltaZWork, #2048

		dex
		bne	.deltaLoop

		subw	wallDeltaZ, #$0080
		bpl	.deltaJp

		movw	wallDeltaZ, #2048

.deltaJp:
		rts


;----------------------------
setObjectByTimer:
;
		dec	objectTimer
		bne	.setObjectJp
		jsr	setObject
		jsr	getRandom
		and	#$07
		ora	#$08
		sta	objectTimer
.setObjectJp:
		rts


;----------------------------
setEnemyByTimer:
;
		dec	enemyTimer
		bne	.setEnemyJp
		jsr	setEnemy
		jsr	getRandom
		and	#$0F
		ora	#$10
		sta	enemyTimer
.setEnemyJp:
		rts


;----------------------------
setShotByPad:
;
		bbr0	<padNow, .checkShotEnd
		jsr	setShot
.checkShotEnd:
		rts


;----------------------------
setAim
;
		movw	<argw0, #64+96-8	;Y
		movw	<argw1, #32+128-16	;X
		movw	<argw2, #$0028		;char code
		movw	<argw3, #$0180		;attribute
		jsr	setSatBuffer
		rts

;----------------------------
setWorldData:
;
		movw	<eyeTranslationX, shipX
		movw	<eyeTranslationY, shipY
		movw	<eyeTranslationZ, shipZ

		mov	<eyeRotationX, #0
		mov	<eyeRotationY, #0
		mov	<eyeRotationZ, #0
		mov	<eyeRotationSelect, #$12

		rts


;----------------------------
initializeDatas:
;
;set screen center
		ldx	#128
		ldy	#96
		jsr	setScreenCenter

;initialize datas
		lda	#60
		sta	frameCount
		stz	drawCount
		stz	drawCountWork

		stzw	shipX
		stzw	shipY
		stzw	shipZ

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

		stzw	wallDeltaZ

		rts


;----------------------------
initializeStar:
;
		clx
.setStarLoop:
		jsr	setStar
		inx
		inx
		cpx	#2*starMAX
		bne	.setStarLoop

		rts

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

		jsr	setSatBuffer

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

		lda	#soundExplosion
		jsr	setDda

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
		sbc	#$80
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

		lda	#soundLaser
		jsr	setDda

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
initializeSystem:
;
;set polygon function bank
		lda	#polygonFunctionBank
		tam	#polygonFunctionMap

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

;set all palettes
		movw	<argw0, #paletteData
		jsr	setAllPalette

;set all polygon colors
		movw	<argw0, #polygonColor0
		jsr	setAllPolygonColor

;set bg char data
		mov	<arg0, #charDataBank
		mov	<arg1, #$00
		mov	<arg2, #VDC1
		mov	<arg3, #256-1
		movw	<argw2, #$1000
		jsr	setCgCharData

		mov	<arg2, #VDC2
		jsr	setCgCharData

;set sp char data
		mov	<arg0, #spDataBank
		mov	<arg1, #$50
		mov	<arg2, #VDC1
		mov	<arg3, #176-1
		movw	<argw2, #$0500
		jsr	setCgCharData

		mov	<arg2, #VDC2
		jsr	setCgCharData

;set Clear VRAM buffer
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

;////////////////////////////////////////
;execute polygon function first
		jsr	irq1PolygonFunction
;////////////////////////////////////////

;call vsync function
		bbr5	<vdpStatus, .skip
		jsr	vsyncFunction
.skip:

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

;disable interrupts
		lda	#%00000111
		sta	INTERRUPT_DISABLE_REG

;jump main
		jmp	main


;----------------------------
_timer:
;TIMER interrupt process
		pha
		phx
		phy

;timer acknowledge
		stz	INTERRUPT_STATE_REG

;////////////////////////////////////////
;play DDA
		jsr	timerPlayDdaFunction
;////////////////////////////////////////

		ply
		plx
		pla
		rti


;----------------------------
_irq2:
_nmi:
;IRQ2 NMI interrupt process
		rti


;----------------------------
;--------    DATA    --------
;----------------------------
;Wall Delta
modelData009
		.dw	modelData009Polygon
		.db	1
		.dw	modelData009Vertex
		.db	3

modelData009Polygon
		;	attribute: circle($80 = circlre) + even line skip($40 = skip) + front clip($04 = cancel) + back check($02 = cancel) + back draw($01 = not draw : front side = counterclockwise) 
		;	front color(0-63)
		;	back color(0-63) or circle radius(1-8192) low byte
		;	vertex count: count(3-4) or circle radius(1-8192) high byte
		;	vertex index 0,
		;	vertex index 1,
		;	vertex index 2,
		;	vertex index 3
		.db	%00000010, $01, $00, $03, 0*6, 1*6, 2*6, 0*6

modelData009Vertex
		.dw	    0,    0, -256
		.dw	  256,    0,  256
		.dw	 -256,    0,  256


;----------------------------
;Wall Enemy
modelData008
		.dw	modelData008Polygon
		.db	5
		.dw	modelData008Vertex
		.db	8

modelData008Polygon
		.db	%00000001, $19, $00, $04, 0*6, 1*6, 2*6, 3*6
		.db	%00000001, $1A, $00, $04, 4*6, 5*6, 1*6, 0*6
		.db	%00000001, $1B, $00, $04, 3*6, 2*6, 6*6, 7*6
		.db	%00000001, $1C, $00, $04, 4*6, 0*6, 3*6, 7*6
		.db	%00000001, $1D, $00, $04, 1*6, 5*6, 6*6, 2*6

modelData008Vertex
		.dw	 -128,  128, -128
		.dw	 -128, -128, -128
		.dw	  128, -128, -128
		.dw	  128,  128, -128

		.dw	 -128,  128,  128
		.dw	 -128, -128,  128
		.dw	  128, -128,  128
		.dw	  128,  128,  128


;----------------------------
;Outer Wall
modelData007
		.dw	modelData007Polygon
		.db	4	;polygon count
		.dw	modelData007Vertex
		.db	16	;vertex count

modelData007Polygon
		.db	%00000010, $07, $00, $04, 0*6, 1*6, 2*6, 3*6
		.db	%00000010, $07, $00, $04, 7*6, 6*6, 5*6, 4*6
		.db	%00000010, $07, $00, $04, 8*6, 9*6,10*6,11*6
		.db	%00000010, $07, $00, $04,15*6,14*6,13*6,12*6

modelData007Vertex
		.dw	 -1020,  1024,   128
		.dw	 -1024,  1020,   128
		.dw	 -1024,  1020,  8192
		.dw	 -1020,  1024,  8192

		.dw	  1020,  1024,   128
		.dw	  1024,  1020,   128
		.dw	  1024,  1020,  8192
		.dw	  1020,  1024,  8192

		.dw	 -1024, -1020,   128
		.dw	 -1020, -1024,   128
		.dw	 -1020, -1024,  8192
		.dw	 -1024, -1020,  8192

		.dw	  1024, -1020,   128
		.dw	  1020, -1024,   128
		.dw	  1020, -1024,  8192
		.dw	  1024, -1020,  8192


;----------------------------
;Circle Enemy Shot
modelData003
		.dw	modelData003Polygon
		.db	1	;polygon count
		.dw	modelData003Vertex
		.db	1	;vertex count

modelData003Polygon
		.db	%10000000, $03, $80, $00, 0*6, 0*6, 0*6, 0*6

modelData003Vertex
		.dw	   0,   0,   0


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
		.dw	   0,   0,   0


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
		.dw	   0,   0,   0


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
		.dw	 -128,  -32,    0
		.dw	 -128,    0,  256
		.dw	 -128,   32,    0
		.dw	  128,  -32,    0
		.dw	  128,    0,  256
		.dw	  128,   32,    0


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
		.dw	    0,    0,  128
		.dw	 -128,    0,    0
		.dw	  128,    0,    0
		.dw	    0,  128,    0

		.dw	 -128,    0,  256
		.dw	 -128,  128, -256
		.dw	 -128, -128, -256

		.dw	  128,    0,  256
		.dw	  128, -128, -256
		.dw	  128,  128, -256


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
		.dw	  -96,  192,    0
		.dw	  212,  144,    0
		.dw	    0, -240,    0
		.dw	 -384,  -96,    0

		.dw	   48,  -48, -192


;----------------------------
vramClearData:
		.db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,\
			$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


;----------------------------
polygonColor0:
		.db	$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF,\
			$00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF


;----------------------------
polygonColor1:
		.db	$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF,\
			$00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF


;----------------------------
polygonColor2:
		.db	$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $55, $FF, $55, $00, $AA, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $FF,\
			$00, $00, $00, $00, $FF, $FF, $FF, $FF, $00, $AA, $FF, $AA, $00, $55, $FF, $FF


;----------------------------
polygonColor3:
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
;use bank1 to bank31
		INCLUDE	"poly_proc.asm"


;////////////////////////////
		.bank	32
		.org	$C000


;////////////////////////////
		.bank	33
		INCBIN	"sp_char.chr"		;    8K  33   $21

;////////////////////////////
		.bank	34
		INCBIN	"explosion.dat"		;    8K  34   $22
		INCBIN	"laser.dat"		;    8K  35   $23
