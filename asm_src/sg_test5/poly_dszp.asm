;poly_dszp.asm
;//////////////////////////////////
;----------------------------
sqr32a
mul16a
div16a			.ds	2
mul16b
div16b			.ds	2

mul16c
div16c			.ds	2
mul16d
div16d			.ds	2

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
clipFrontX		;.ds	2
polyLineLeftAddr	;.ds	2
circleX			;.ds	2
edgeX0			.ds	1
edgeY0			.ds	1

clipFrontY		;.ds	2
polyLineRightAddr	;.ds	2
circleY			;.ds	2
edgeX1			.ds	1
edgeY1			.ds	1

polyLineYAddr		;.ds	2
circleD			;.ds	2
frontClipFlag		;.ds	1
edgeSlopeX		.ds	1
frontClipCount		;.ds	1
edgeSlopeY		.ds	1

work8a			;.ds	8
work4a			;.ds	4
circleDH		;.ds	2
frontClipData0		;.ds	1
edgeSigneX		.ds	1
frontClipData1		;.ds	1
polyLineColorDataWork	.ds	1

circleDD		;.ds	2
calcEdgeLastAddr	;.ds	1
polyLineX0		.ds	1
polyLineX1		.ds	1

work4b			;.ds	4
circleRadius		;.ds	2
polyLineY		.ds	1
polyLineCount		.ds	1

circleCenterX		;.ds	2
polyLineLeftData	.ds	1
polyLineLeftMask	.ds	1

work8b			;.ds	8
work4c			;.ds	4
circleCenterY		;.ds	2
polyLineRightData	.ds	1
polyLineRightMask	.ds	1

circleYTop		;.ds	2
circleXLeft		;.ds	2
polyLineColorDataWork0	.ds	1
polyLineColorDataWork1	.ds	1

work4d			;.ds	4
circleYBottom		;.ds	2
circleXRight		;.ds	2
polyLineColorDataWork2	.ds	1
polyLineColorDataWork3	.ds	1

circleYWork		;.ds	2
polyLineDataLow		.ds	1
polyLineDataHigh	.ds	1

frontClipDataWork	;.ds	1
circleTmp		.ds	1

;---------------------
polygonTopAddress		.ds	1

;---------------------
minEdgeY		.ds	1

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

;---------------------
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
angleX0			;.ds	2
argw0			;.ds	2
arg0			.ds	1
arg1			.ds	1

angleX1			;.ds	2
argw1			;.ds	2
arg2			.ds	1
arg3			.ds	1

angleY0			;.ds	2
argw2			;.ds	2
arg4			.ds	1
arg5			.ds	1

angleY1			;.ds	2
argw3			;.ds	2
arg6			.ds	1
arg7			.ds	1

tempw0			;.ds	2
angleZ0			.ds	2
tempw1			;.ds	2
angleZ1			.ds	2

tempw2			;.ds	2
temp4			;.ds	1
ansAngleX		.ds	1
temp5			;.ds	1
ansAngleY		.ds	1

;---------------------
polyBufferAddr		.ds	2
polyBufferZ0Work0	.ds	2
polyBufferZ0Work1	.ds	2

polyBufferNow		.ds	2
polyBufferNext		.ds	2

;---------------------
modelAddr		.ds	2
modelAddrWork		.ds	2
modelPolygonCount	.ds	1
setModelCount		.ds	1
setModelFrontColor	.ds	1
setModelBackColor	.ds	1
setModelAttr		.ds	1
model2DClipIndexWork	.ds	1

;---------------------
edgeLoopCount		.ds	1
edgeLoopAddr		.ds	2

;---------------------
satBufferAddr		.ds	2

;---------------------
dda0Flag		.ds	1
dda0No			.ds	1
dda0Address		.ds	2
