;poly_macro.asm
;//////////////////////////////////
;----------------------------
edgeSigneXPlus0m	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		inx

		pha
		setEdgeBuffer0m
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneXMinus0m	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		dex

		pha
		setEdgeBuffer0m
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneYPlus0m	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		iny

.jp_\@:
		pha
		setEdgeBuffer0m
		pla

		.endm


;----------------------------
edgeSigneYMinus0m	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		dey

.jp_\@:
		pha
		setEdgeBuffer0m
		pla

		.endm


;----------------------------
edgeSigneXPlusm	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		inx

		pha
		setEdgeBufferm
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneXMinusm	.macro
		iny
		clc
		adc	<edgeSlopeY
		bcc	.jp_\@

		sbc	<edgeSlopeX
		dex

		pha
		setEdgeBufferm
		pla

.jp_\@:
		.endm


;----------------------------
edgeSigneYPlusm	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		iny

.jp_\@:
		pha
		setEdgeBufferm
		pla

		.endm


;----------------------------
edgeSigneYMinusm	.macro
		inx
		clc
		adc	<edgeSlopeX
		bcc	.jp_\@

		sbc	<edgeSlopeY
		dey

.jp_\@:
		pha
		setEdgeBufferm
		pla

		.endm


;----------------------------
putPolyLineV1m	.macro
		sta	VDC1_2
		sty	VDC1_3
		.endm


;----------------------------
putPolyLineV2m	.macro
		sta	VDC2_2
		sty	VDC2_3
		.endm


;----------------------------
putPolyLineV1lm	.macro
		putPolyLineV1m		;30

		putPolyLineV1m		;29
		putPolyLineV1m		;28
		putPolyLineV1m		;27
		putPolyLineV1m		;26
		putPolyLineV1m		;25
		putPolyLineV1m		;24
		putPolyLineV1m		;23
		putPolyLineV1m		;22
		putPolyLineV1m		;21

		putPolyLineV1m		;20
		putPolyLineV1m		;19
		putPolyLineV1m		;18
		putPolyLineV1m		;17
		putPolyLineV1m		;16
		putPolyLineV1m		;15
		putPolyLineV1m		;14
		putPolyLineV1m		;13
		putPolyLineV1m		;12
		putPolyLineV1m		;11

		putPolyLineV1m		;10
		putPolyLineV1m		;9
		putPolyLineV1m		;8
		putPolyLineV1m		;7
		putPolyLineV1m		;6
		putPolyLineV1m		;5
		putPolyLineV1m		;4
		putPolyLineV1m		;3
		putPolyLineV1m		;2
		putPolyLineV1m		;1
		.endm


;----------------------------
putPolyLineV2lm	.macro
		putPolyLineV2m		;30

		putPolyLineV2m		;29
		putPolyLineV2m		;28
		putPolyLineV2m		;27
		putPolyLineV2m		;26
		putPolyLineV2m		;25
		putPolyLineV2m		;24
		putPolyLineV2m		;23
		putPolyLineV2m		;22
		putPolyLineV2m		;21

		putPolyLineV2m		;20
		putPolyLineV2m		;19
		putPolyLineV2m		;18
		putPolyLineV2m		;17
		putPolyLineV2m		;16
		putPolyLineV2m		;15
		putPolyLineV2m		;14
		putPolyLineV2m		;13
		putPolyLineV2m		;12
		putPolyLineV2m		;11

		putPolyLineV2m		;10
		putPolyLineV2m		;9
		putPolyLineV2m		;8
		putPolyLineV2m		;7
		putPolyLineV2m		;6
		putPolyLineV2m		;5
		putPolyLineV2m		;4
		putPolyLineV2m		;3
		putPolyLineV2m		;2
		putPolyLineV2m		;1
		.endm


;----------------------------
setEdgeBuffer0m	.macro
;
		tya
		sta	edgeLeft,x
		inc	edgeCount,x
		.endm


;----------------------------
setEdgeBufferm	.macro
;set edge buffer
		lda	edgeCount,x

		beq	.jpCount1_\@			;count 1
		bpl	.jpCount2_\@			;count 2

;count 0
.jpCount0_\@:
		tya
		sta	edgeLeft,x
		inc	edgeCount,x
		bra	.jp2_\@

;count 1
.jpCount1_\@:
		tya
		cmp	edgeLeft,x
		bcc	.jp4_\@			;a < edgeLeft,x

		sta	edgeRight,x
		inc	edgeCount,x
		bra	.jp2_\@

.jp4_\@:
		lda	edgeLeft,x
		sta	edgeRight,x
		tya
		sta	edgeLeft,x

		inc	edgeCount,x
		bra	.jp2_\@

;count 2
.jpCount2_\@:
		tya
		cmp	edgeLeft,x
		bcs	.jp3_\@			;a >= edgeLeft,x
		sta	edgeLeft,x
		bra	.jp2_\@

.jp3_\@:
		cmp	edgeRight,x
		bcc	.jp2_\@			;a < edgeRight,x
		sta	edgeRight,x

.jp2_\@:
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
incw		.macro
;\1(word) = \1(word) + 1
		inc	\1
		bne	.jp0\@
		inc	\1+1
.jp0\@
		.endm


;----------------------------
incq		.macro
;\1(word) = \1(word) + 1
		inc	\1
		bne	.jp0\@
		inc	\1+1
		bne	.jp0\@
		inc	\1+2
		bne	.jp0\@
		inc	\1+3
.jp0\@
		.endm


;----------------------------
decw		.macro
;\1(word) = \1(word) - 1
		lda	\1
		bne	.jp0\@
		dec	\1+1
.jp0\@
		dec	a
		sta	\1
		.endm


;----------------------------
addq		.macro
;\1 = \2 + \3
;\1 = \1 + \2
		.if	(\# = 3)
			.if	(\?2 = 2);Immediate
				clc
				lda	\1
				adc	#LOW(\3)
				sta	\1

				lda	\1+1
				adc	#HIGH(\3)
				sta	\1+1

				lda	\1+2
				adc	#LOW(\2)
				sta	\1+2

				lda	\1+3
				adc	#HIGH(\2)
				sta	\1+3
			.else
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
			.endif
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
subwb		.macro
;\1(word) = \1(word) - \2(byte)
		sec
		lda	\1
		sbc	\2
		sta	\1
		bcs	.jp0\@
		dec	\1+1
.jp0\@
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
adx		.macro
;x = x + \1
		txa
		clc
		adc	\1
		tax
		.endm


;----------------------------
ady		.macro
;y = y + \1
		tya
		clc
		adc	\1
		tay
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
aslw		.macro
;\1
		asl	\1
		rol	\1+1
		.endm


;----------------------------
aslq		.macro
;\1
		asl	\1
		rol	\1+1
		rol	\1+2
		rol	\1+3
		.endm


;----------------------------
rolq		.macro
;\1
		rol	\1
		rol	\1+1
		rol	\1+2
		rol	\1+3
		.endm


;----------------------------
lsrw		.macro
;\1
		lsr	\1+1
		ror	\1
		.endm


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
cmpw		.macro
;\1 - \2
		.if	(\?2 = 2);Immediate
			lda	\1+1
			cmp	#HIGH(\2)
			bne	.jp0\@
			lda	\1
			cmp	#LOW(\2)
		.else
			lda	\1+1
			cmp	\2+1
			bne	.jp0\@
			lda	\1
			cmp	\2
		.endif
		beq	.jp0\@
		lda	#$01
		bcs	.jp0\@
		lda	#$80
.jp0\@
		.endm


;----------------------------
cmpw2		.macro
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
cmpq2		.macro
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
st012		.macro
;
		st0	#\1
		st1	#LOW(\2)
		st2	#HIGH(\2)
		.endm
