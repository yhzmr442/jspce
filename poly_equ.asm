;poly_equ.asm
;//////////////////////////////////
;----------------------------
VDC_0			.equ	$0000
VDC_1			.equ	$0001
VDC_2			.equ	$0002
VDC_3			.equ	$0003

VDC1			.equ	1
VDC1_0			.equ	VDC_0
VDC1_1			.equ	VDC_1
VDC1_2			.equ	VDC_2
VDC1_3			.equ	VDC_3

VDC2			.equ	2
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

PSG_0			.equ	$0800
PSG_1			.equ	$0801
PSG_2			.equ	$0802
PSG_3			.equ	$0803
PSG_4			.equ	$0804
PSG_5			.equ	$0805
PSG_6			.equ	$0806
PSG_7			.equ	$0807
PSG_8			.equ	$0808
PSG_9			.equ	$0809

TIMER_COUNTER_REG	.equ	$0C00
TIMER_CONTROL_REG	.equ	$0C01

INTERRUPT_DISABLE_REG	.equ	$1402
INTERRUPT_STATE_REG	.equ	$1403

IO_REG			.equ	$1000

;----------------------------
polygonFunctionBank	.equ	1
polygonFunctionMap	.equ	5
polygonSubFunctionBank	.equ	2
polygonSubFunctionMap	.equ	2
charDataBank		.equ	3
mulDataBank		.equ	4
divDataBank		.equ	20
