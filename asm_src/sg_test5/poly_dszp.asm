;poly_dszp.asm
;//////////////////////////////////
;----------------------------
mul16a			.ds	2
mul16b			.ds	2
div16a			equ	mul16a		;2Byte
div16b			equ	mul16b		;2Byte
sqr32a			equ	mul16a		;4Byte

mul16c			.ds	2
mul16d			.ds	2
div16c			equ	mul16c		;2Byte
div16d			equ	mul16d		;2Byte

mulAddr			.ds	2

;---------------------
;LDRU RSBA
padLast			.ds	1
padNow			.ds	1
padState		.ds	1

;---------------------
vsyncFlag		.ds	1
vdpStatus		.ds	1
vdp1Status		.ds	1
vdp2Status		.ds	1
selectVdc		.ds	1

;---------------------
vertexCount		.ds	1
vertex0Addr		.ds	2

;---------------------
clip2D0Count		.ds	1
clip2D1Count		.ds	1
clip2DFlag		.ds	1

;---------------------
;---------------------
;share area start
;---------------------
shareAreaTop
circleX			.ds	2
circleY			.ds	2
circleD			.ds	2
circleDH		.ds	2
circleDD		.ds	2
circleRadius		.ds	2
circleCenterX		.ds	2
circleCenterY		.ds	2
circleXLeft0		.ds	2
circleXRight0		.ds	2
circleXLeft1		.ds	2
circleXRight1		.ds	2
circleYWork		.ds	2
circleXLeftWork		.ds	1
circleXRightWork	.ds	1
;			total 28 Byte
shareAreaBottom

;---------------------
			.org	shareAreaTop
edgeX0			.ds	1
edgeY0			.ds	1
edgeX1			.ds	1
edgeY1			.ds	1
edgeSlopeX		.ds	1
edgeSlopeY		.ds	1
edgeSigneX		.ds	1
calcEdgeLastAddr	.ds	1
polyLineColorDataWork	.ds	1
polyLineX0		.ds	1
polyLineX1		.ds	1
polyLineY		.ds	1
polyLineCount		.ds	1
polyLineLeftData	.ds	1
polyLineLeftMask	.ds	1
polyLineRightData	.ds	1
polyLineRightMask	.ds	1
polyLineColorDataWork0	.ds	1
polyLineColorDataWork1	.ds	1
polyLineColorDataWork2	.ds	1
polyLineColorDataWork3	.ds	1
polyLineDataLow		.ds	1
polyLineDataHigh	.ds	1
;			total 23 Byte

;---------------------
			.org	shareAreaTop
clipFrontX		.ds	2
clipFrontY		.ds	2
frontClipFlag		.ds	1
frontClipCount		.ds	1
frontClipData0		.ds	1
frontClipData1		.ds	1
frontClipDataWork	.ds	1
;			total 9 Byte

;---------------------
			.org	shareAreaTop
polyLineLeftAddr	.ds	2
polyLineRightAddr	.ds	2
polyLineYAddr		.ds	2
work4a			.ds	4
work4b			.ds	4
work8a			equ	work4a		;8Byte
work4c			.ds	4
work4d			.ds	4
work8b			equ	work4c		;8Byte
backCheckFlag		.ds	1
;			total 23 Byte

;---------------------
			.org	shareAreaTop
angleX0			.ds	2
angleX1			.ds	2
angleY0			.ds	2
angleY1			.ds	2
angleZ0			.ds	2
angleZ1			.ds	2
ansAngleX		.ds	1
ansAngleY		.ds	1
;			total 14 Byte

;---------------------
			.org	shareAreaTop
arg0			.ds	1
arg1			.ds	1
argw0			equ	arg0			;2Byte
si			equ	arg0			;2Byte

arg2			.ds	1
arg3			.ds	1
argw1			equ	arg2			;2Byte
di			equ	arg2			;2Byte

arg4			.ds	1
arg5			.ds	1
argw2			equ	arg4			;2Byte

arg6			.ds	1
arg7			.ds	1
argw3			equ	arg6			;2Byte

temp0			.ds	1
temp1			.ds	1
tempw0			equ	temp0			;2Byte

temp2			.ds	1
temp3			.ds	1
tempw1			equ	temp2			;2Byte

temp4			.ds	1
temp5			.ds	1
tempw2			equ	temp4			;2Byte
;			total 14 Byte

;---------------------
			.org	shareAreaTop
matrix0			.ds	2			;2Byte
matrix1			.ds	2			;2Byte
matrix2			.ds	2			;2Byte
matrixTemp		.ds	4			;4Byte
;			total 10 Byte

;---------------------
			.org	shareAreaBottom
;---------------------
;share area end
;---------------------
;---------------------

;---------------------
polygonTopAddress	.ds	1

;---------------------
minEdgeY		.ds	1
maxEdgeY		.ds	1

;---------------------
polygonColorIndex	.ds	1
polyAttribute		.ds	1

;---------------------
centerX			.ds	2
centerY			.ds	2

;---------------------
translationX		.ds	2
translationY		.ds	2
translationZ		.ds	2

rotationX		.ds	1
rotationY		.ds	1
rotationZ		.ds	1

rotationSelect		.ds	1

vertexRotationSin	.ds	2
vertexRotationCos	.ds	2

;---------------------
eyeTranslationX		.ds	2
eyeTranslationY		.ds	2
eyeTranslationZ		.ds	2

eyeRotationX		.ds	1
eyeRotationY		.ds	1
eyeRotationZ		.ds	1

eyeRotationSelect	.ds	1

;---------------------
polyBufferAddr		.ds	2
polyBufferZ0Work0	.ds	2
polyBufferZ0Work1	.ds	2

polyBufferNow		.ds	2
polyBufferNext		.ds	2

;---------------------
modelAddress		.ds	2
modelAddrWork		.ds	2
modelPolygonCount	.ds	1
setModelCount		.ds	1
setModelFrontColor	.ds	1
setModelBackColor	.ds	1
setModelAttr		.ds	1
model2DClipIndexWork	.ds	1

;---------------------
satBufferAddr		.ds	2

;---------------------
dda0Flag		.ds	1
dda0No			.ds	1
dda0Address		.ds	2
