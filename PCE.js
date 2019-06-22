"use strict";

class PCE {
	constructor() {
		/* ************* */
		/* **** ETC **** */
		/* ************* */
		this.TimerID = null;
		this.MainCanvas = null;
		this.Ctx = null;
		this.ImageData = null;

		/* ************* */
		/* **** CPU **** */
		/* ************* */
		this.OpCycles = [
		 8, 7, 3, 4, 6, 4, 6, 7, 3, 2, 2, 2, 7, 5, 7, 6,// 0x00
		 2, 7, 7, 4, 6, 4, 6, 7, 2, 5, 2, 2, 7, 5, 7, 6,// 0x10
		 7, 7, 3, 4, 4, 4, 6, 7, 3, 2, 2, 2, 5, 5, 7, 6,// 0x20
		 2, 7, 7, 2, 4, 4, 6, 7, 2, 5, 2, 2, 5, 5, 7, 6,// 0x30
		 7, 7, 3, 4, 8, 4, 6, 7, 3, 2, 2, 2, 4, 5, 7, 6,// 0x40
		 2, 7, 7, 5, 2, 4, 6, 7, 2, 5, 3, 2, 2, 5, 7, 6,// 0x50
		 7, 7, 2, 2, 4, 4, 6, 7, 3, 2, 2, 2, 7, 5, 7, 6,// 0x60
		 2, 7, 7, 0, 4, 4, 6, 7, 2, 5, 3, 2, 7, 5, 7, 6,// 0x70
		 4, 7, 2, 7, 4, 4, 4, 7, 2, 2, 2, 2, 5, 5, 5, 6,// 0x80
		 2, 7, 7, 8, 4, 4, 4, 7, 2, 5, 2, 2, 5, 5, 5, 6,// 0x90
		 2, 7, 2, 7, 4, 4, 4, 7, 2, 2, 2, 2, 5, 5, 5, 6,// 0xA0
		 2, 7, 7, 8, 4, 4, 4, 7, 2, 5, 2, 2, 5, 5, 5, 6,// 0xB0
		 2, 7, 2, 0, 4, 4, 6, 7, 2, 2, 2, 2, 5, 5, 7, 6,// 0xC0
		 2, 7, 7, 0, 2, 4, 6, 7, 2, 5, 3, 2, 2, 5, 7, 6,// 0xD0
		 2, 7, 2, 0, 4, 4, 6, 7, 2, 2, 2, 2, 5, 5, 7, 6,// 0xE0
		 2, 7, 7, 0, 2, 4, 6, 7, 2, 5, 3, 2, 2, 5, 7, 6];//0xF0

		this.OpBytes = [
		 0, 2, 1, 2, 2, 2, 2, 2, 1, 2, 1, 1, 3, 3, 3, 0,// 0x00
		 0, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1, 1, 3, 3, 3, 0,// 0x10
		 0, 2, 1, 2, 2, 2, 2, 2, 1, 2, 1, 1, 3, 3, 3, 0,// 0x20
		 0, 2, 2, 1, 2, 2, 2, 2, 1, 3, 1, 1, 3, 3, 3, 0,// 0x30
		 0, 2, 1, 2, 0, 2, 2, 2, 1, 2, 1, 1, 0, 3, 3, 0,// 0x40
		 0, 2, 2, 2, 1, 2, 2, 2, 1, 3, 1, 1, 1, 3, 3, 0,// 0x50
		 0, 2, 1, 1, 2, 2, 2, 2, 1, 2, 1, 1, 0, 3, 3, 0,// 0x60
		 0, 2, 2, 0, 2, 2, 2, 2, 1, 3, 1, 1, 0, 3, 3, 0,// 0x70
		 0, 2, 1, 3, 2, 2, 2, 2, 1, 2, 1, 1, 3, 3, 3, 0,// 0x80
		 0, 2, 2, 4, 2, 2, 2, 2, 1, 3, 1, 1, 3, 3, 3, 0,// 0x90
		 2, 2, 2, 3, 2, 2, 2, 2, 1, 2, 1, 1, 3, 3, 3, 0,// 0xA0
		 0, 2, 2, 4, 2, 2, 2, 2, 1, 3, 1, 1, 3, 3, 3, 0,// 0xB0
		 2, 2, 1, 0, 2, 2, 2, 2, 1, 2, 1, 1, 3, 3, 3, 0,// 0xC0
		 0, 2, 2, 0, 1, 2, 2, 2, 1, 3, 1, 1, 1, 3, 3, 0,// 0xD0
		 2, 2, 1, 0, 2, 2, 2, 2, 1, 2, 1, 1, 3, 3, 3, 0,// 0xE0
		 0, 2, 2, 0, 1, 2, 2, 2, 1, 3, 1, 1, 1, 3, 3, 0];//0xF0

		this.A = 0;
		this.X = 0;
		this.Y = 0;
		this.PC = 0;
		this.S = 0;
		this.P = 0;

		this.NZCacheTable = new Array(0x100);
		this.NZCacheTable[0x00] = 0x02;
		for (let i=1; i<0x100; i++) {
			this.NZCacheTable[i] = i & 0x80;
		}

		this.NFlag = 0x80;
		this.VFlag = 0x40;
		this.TFlag = 0x20;
		this.BFlag = 0x10;
		this.DFlag = 0x08;
		this.IFlag = 0x04;
		this.ZFlag = 0x02;
		this.CFlag = 0x01;

		this.TIQFlag = 0x04;
		this.IRQ1Flag = 0x02;
		this.IRQ2Flag = 0x01;

		this.ProgressClock = 0;
		this.CPUBaseClock = 0;

		this.BaseClock1 = 12;
		this.BaseClock3 = 6;
		this.BaseClock5 = 4;
		this.BaseClock7 = 3;
		this.BaseClock10 = 2;

		/* ***************** */
		/* **** Storage **** */
		/* ***************** */
		this.MPR = new Array(8);
		this.MPRSelect = 0;
		this.RAM = new Array(0x2000);
		this.BRAM = new Array(0x2000).fill(0x00);
		this.BRAMUse = false;

		this.INTIRQ2 = 0x00;
		this.IntDisableRegister = 0;

		this.Mapper = null;

		this.MapperBase = class {
			constructor(core) {
				this.ROM = null;
				this.Core = core;
			}

			Init() {
			}

			Read(address) {
				return 0xFF;
			}

			Write(address, data) {
			}
		};

		this.Mapper0 = class extends this.MapperBase {
			constructor(rom, core) {
				super(core);
				this.ROM = rom;

				let tmp = this.ROM.length - 1;
				this.Address = 0x80000;
				while(this.Address > 0x0000) {
					if((this.Address & tmp) != 0x0000)
						break;
					this.Address >>>= 1;
				}
			}

			Read(address) {
				if(address >= this.ROM.length)
					return this.ROM[(address & (this.Address - 1)) | this.Address];
				else
					return this.ROM[address];
			}
		};

		this.Mapper1 = class extends this.MapperBase {
			constructor(rom, core) {
				super(core);
				this.ROM = rom;
				this.Address = 0;
			}

			Init() {
				this.Address = 0;
			}

			Read(address) {
				if(address < 0x80000)
					return this.ROM[address];
				else
					return this.ROM[this.Address | (address & 0x7FFFF)];
			}

			Write(address, data) {
				this.Address = ((address & 0x000F) + 1) << 19;
			}
		};

		this.Mapper2 = class extends this.MapperBase {
			constructor(rom, core) {
				super(core);
				this.ROM = rom.concat(new Array(0x80000).fill(0x00));
			}

			Read(address) {
				return this.ROM[address];
			}

			Write(address, data) {
				if(address >= 0x80000)
					this.ROM[address] = data;
			}
		};


		/* ************* */
		/* **** VCE **** */
		/* ************* */
		this.Palettes = new Array(512);

		this.VCEBaseClock = 0;
		this.VCEControl = 0;
		this.VCEAddress = 0;
		this.VCEData = 0;

		/* ************* */
		/* **** VDC **** */
		/* ************* */
		this.VDCRegister = new Array(20);
		this.VRAM = new Array(0x10000);
		this.SATB = new Array(256);
		this.DrawFlag = false;
		this.SpriteLimit = false;

		this.VDCStatus = 0;
		this.VDCRegisterSelect = 0;
		this.WriteVRAMData = 0;

		this.VRAMtoSTABStartFlag = false;
		this.VRAMtoSTABCount = 0;
		this.VRAMtoVRAMCount = 0;

		this.RasterCount = 0;
		this.VLineCount = 0;
		this.VDCProgressClock = 0;
		this.DrawBGLineCount = 0;

		this.VDCBurst = false;

		this.VScreenWidth = 0;
		this.VScreenHeight = 0;
		this.VScreenHeightMask = 0;
		this.ScreenWidth = 0;

		this.VDS = 0;
		this.VSW = 0;
		this.VDW = 0;
		this.HDS = 0;

		this.ScreenSize = [];
		this.ScreenSize[this.BaseClock5] = 288;
		this.ScreenSize[this.BaseClock7] = 384;
		this.ScreenSize[this.BaseClock10] = 576;

		this.VScreenWidthArray = [];
		this.VScreenWidthArray[0x00] = 32;
		this.VScreenWidthArray[0x10] = 64;
		this.VScreenWidthArray[0x20] = 128;
		this.VScreenWidthArray[0x30] = 128;

		this.SPLine = new Array(576);

		this.ReverseBit = new Array(0x100);
		for(let i=0; i<this.ReverseBit.length; i++)
			this.ReverseBit[i] = ((i & 0x80) >> 7) | ((i & 0x40) >> 5) | 
					     ((i & 0x20) >> 3) | ((i & 0x10) >> 1) | 
					     ((i & 0x08) << 1) | ((i & 0x04) << 3) | 
					     ((i & 0x02) << 5) | ((i & 0x01) << 7);

		this.ReverseBit16 = new Array(0x10000);
		for(let i=0; i<this.ReverseBit16.length; i++)
			this.ReverseBit16[i] = (this.ReverseBit[i & 0x00FF] << 8) | this.ReverseBit[(i & 0xFF00) >> 8];

		/* *************** */
		/* **** Sound **** */
		/* *************** */
		this.WaveDataArray = [];
		this.WaveClockCounter = 0;
		this.WaveVolume = 1.0;

		this.WebAudioCtx = null;
		this.WebAudioJsNode = null;
		this.WebAudioGainNode = null;
		this.WebAudioBufferSize = 2048;

		this.PSGClock = 3579545;

		/* ************* */
		/* **** PSG **** */
		/* ************* */
		this.PSGChannel = new Array(6);
		this.PSGBaseClock = this.BaseClock3;

		this.PSGProgressClock = 0;

		this.WaveVolumeLeft = 0;
		this.WaveVolumeRight = 0;

		this.WaveLfoOn = false;
		this.WaveLfoControl = 0;
		this.WaveLfoFreqency = 0;

		/* *************** */
		/* **** TIMER **** */
		/* *************** */
		this.TimerBaseClock = this.BaseClock7;
		this.TimerReload = 0;
		this.TimerFlag = false;
		this.TimerCounter = 0;
		this.TimerPrescaler = 0;
		this.INTTIQ = 0;

		/* ****************** */
		/* **** Joystick **** */
		/* ****************** */
		this.JoystickSEL = 0;
		this.JoystickCLR = 0;
		this.KeyUpFunction = null;
		this.KeyDownFunction = null;

		this.CountryTypePCE = 1;
		this.CountryTypeTG16 = 0;
		this.CountryType = this.CountryTypePCE;

		this.Keybord = [[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA]];
		this.GamePad = [[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA],
				[0xBF, 0xBF, 0xBF, 0xBA]];
		this.GamePadSelect = 0;
		this.GamePadButtonSelect = 1;
		this.GamePadButton6 = false;
		this.MultiTap = false;

		this.GamePadData = [];
		this.GamePadData["STANDARD PAD"] = [
			[[{type:"B", index:1}],// SHOT1
			 [{type:"B", index:0}],// SHOT2
			 [{type:"B", index:8}],// SELECT
			 [{type:"B", index:9}, {type:"B", index:2}],// RUN
			 [{type:"B", index:12}],// UP
			 [{type:"B", index:13}],// DOWN
			 [{type:"B", index:14}],// LEFT
			 [{type:"B", index:15}]],// RIGHT

			[[{type:"B", index:1}],// SHOT1
			 [{type:"B", index:0}],// SHOT2
			 [{type:"B", index:8}],// SELECT
			 [{type:"B", index:9}],// RUN
			 [{type:"B", index:12}],// UP
			 [{type:"B", index:13}],// DOWN
			 [{type:"B", index:14}],// LEFT
			 [{type:"B", index:15}],// RIGHT
			 [{type:"B", index:7}],// SHOT3
			 [{type:"B", index:5}],// SHOT4
			 [{type:"B", index:2}],// SHOT5
			 [{type:"B", index:3}]]];// SHOT6

		this.GamePadData["UNKNOWN PAD"] = [
			[[{type:"B", index:1}],// SHOT1
			 [{type:"B", index:0}],// SHOT2
			 [{type:"B", index:2}],// SELECT
			 [{type:"B", index:3}],// RUN
			 [{type:"A-", index:1}],// UP
			 [{type:"A+", index:1}],// DOWN
			 [{type:"A-", index:0}],// LEFT
			 [{type:"A+", index:0}]],// RIGHT

			[[{type:"B", index:1}],// SHOT1
			 [{type:"B", index:0}],// SHOT2
			 [{type:"B", index:2}],// SELECT
			 [{type:"B", index:3}],// RUN
			 [{type:"A-", index:1}],// UP
			 [{type:"A+", index:1}],// DOWN
			 [{type:"A-", index:0}],// LEFT
			 [{type:"A+", index:0}]]];// RIGHT

		this.GamePadData["HORI PAD 3 TURBO (Vendor: 0f0d Product: 0009)"] = [// Chrome
			[[{type:"B", index:2}],// SHOT1
			 [{type:"B", index:1}],// SHOT2
			 [{type:"B", index:8}],// SELECT
			 [{type:"B", index:9}, {type:"B", index:0}],// RUN
			 [{type:"P", index:9}],// UP (POV)
			 [{type:"N", index:0}],// DOWN (POV)
			 [{type:"N", index:0}],// LEFT (POV)
			 [{type:"N", index:0}]],// RIGHT (POV)

			[[{type:"B", index:2}],// SHOT1
			 [{type:"B", index:1}],// SHOT2
			 [{type:"B", index:8}],// SELECT
			 [{type:"B", index:9}],// RUN
			 [{type:"P", index:9}],// UP (POV)
			 [{type:"N", index:0}],// DOWN (POV)
			 [{type:"N", index:0}],// LEFT (POV)
			 [{type:"N", index:0}],// RIGHT (POV)
			 [{type:"B", index:7}],// SHOT3
			 [{type:"B", index:5}],// SHOT4
			 [{type:"B", index:0}],// SHOT5
			 [{type:"B", index:3}]]];// SHOT6

		this.GamePadData["0f0d-0009-HORI PAD 3 TURBO"] = [// Firefox
			[[{type:"B", index:2}],// SHOT1
			 [{type:"B", index:1}],// SHOT2
			 [{type:"B", index:8}],// SELECT
			 [{type:"B", index:9}, {type:"B", index:0}],// RUN
			 [{type:"AB", index:6}],// UP
			 [{type:"AB", index:7}],// DOWN
			 [{type:"AB", index:5}],// LEFT
			 [{type:"AB", index:4}]],// RIGHT

			[[{type:"B", index:2}],// SHOT1
			 [{type:"B", index:1}],// SHOT2
			 [{type:"B", index:8}],// SELECT
			 [{type:"B", index:9}],// RUN
			 [{type:"AB", index:6}],// UP
			 [{type:"AB", index:7}],// DOWN
			 [{type:"AB", index:5}],// LEFT
			 [{type:"AB", index:4}],// RIGHT
			 [{type:"B", index:7}],// SHOT3
			 [{type:"B", index:5}],// SHOT4
			 [{type:"B", index:0}],// SHOT5
			 [{type:"B", index:3}]]];// SHOT6

		this.GamePadKeyData = [{index:0, data:0x01}, {index:0, data:0x02},
				       {index:0, data:0x04}, {index:0, data:0x08},
				       {index:1, data:0x01}, {index:1, data:0x04},
				       {index:1, data:0x08}, {index:1, data:0x02},
				       {index:2, data:0x01}, {index:2, data:0x02},
				       {index:2, data:0x04}, {index:2, data:0x08}];

		this.GamePadPovData = [0x01, 0x01|0x02, 0x02, 0x02|0x04, 0x04, 0x04|0x08, 0x08, 0x01|0x08];
	}


	/* ************* */
	/* **** ETC **** */
	/* ************* */
	UpdateAnimationFrame() {
		this.TimerID = window.requestAnimationFrame(this.UpdateAnimationFrame.bind(this));
		this.Run();
	}


	CancelAnimationFrame() {
		window.cancelAnimationFrame(this.TimerID);
		this.TimerID = null;
	}


	Pause() {
		if(this.TimerID != null) {
			this.JoystickEventRelease();
			this.CancelAnimationFrame();
		}
	}


	Start() {
		if(this.TimerID == null) {
			this.JoystickEventInit();
			this.UpdateAnimationFrame();
		}
	}


	Run() {
		this.CheckGamePad();
		while(!this.DrawFlag) {
			this.CPURun();
			this.VDCRun();
			this.TimerRun();
			this.PSGRun();
		}
		this.DrawFlag = false;
	}


	Reset() {
		this.StorageReset();
		this.Mapper.Init();
		this.CPUInit();
		this.VCEInit();
		this.VDCInit();
		this.TimerInit();
		this.JoystickInit();
		this.PSGInit();
		this.CPUReset();
	}


	Init() {
		this.StorageInit();
		this.CPUInit();
		this.VCEInit();
		this.VDCInit();
		this.TimerInit();
		this.JoystickInit();
		this.PSGInit();
	}


	SetCanvas(canvasID) {
		this.MainCanvas = document.getElementById(canvasID);
		if (!this.MainCanvas.getContext)
			return false;

		this.Ctx = this.MainCanvas.getContext("2d");

		this.ImageData = this.Ctx.createImageData(576, 263);
		for(let i=0; i<576*263*4; i+=4) {
			this.ImageData.data[i] = 0;
			this.ImageData.data[i + 1] = 0;
			this.ImageData.data[i + 2] = 0;
			this.ImageData.data[i + 3] = 255;
		}
		this.Ctx.putImageData(this.ImageData, 0, 0);

		return true;
	}


	/* ************* */
	/* **** CPU **** */
	/* ************* */
	CPUReset() {
		this.SetIFlag();
		this.PC = this.Get16(0xFFFE);
	}


	CPUInit() {
		this.A = 0;
		this.X = 0;
		this.Y = 0;
		this.PC = 0;
		this.S = 0;
		this.P = 0x00;

		this.ProgressClock = 0;
		this.CPUBaseClock = this.BaseClock1;

		this.LastInt = 0x00;
	}


	CPURun() {
		this.ProgressClock = 0;

		let tmp = this.LastInt;
		this.LastInt = (this.P & this.IFlag) == 0x00 ? this.GetIntStatus() : 0x00;

		if(tmp != 0x00) {
			this.LastInt = 0x00;

			if((tmp & this.TIQFlag) == this.TIQFlag) {//TIQ
				this.Push(this.PCH());
				this.Push(this.PCL());
				this.Push(this.P);
				this.P = 0x04;
				this.PC = this.Get16(0xFFFA);
			} else if((tmp & this.IRQ1Flag) == this.IRQ1Flag) {//IRQ1
				this.Push(this.PCH());
				this.Push(this.PCL());
				this.Push(this.P);
				this.P = 0x04;
				this.PC = this.Get16(0xFFF8);
			} else if((tmp & this.IRQ2Flag) == this.IRQ2Flag) {//IRQ2
				this.Push(this.PCH());
				this.Push(this.PCL());
				this.Push(this.P);
				this.SetIFlag();
				this.PC = this.Get16(0xFFF6);
			}
			this.ProgressClock = 8 * this.CPUBaseClock;
		} else
			this.OpExec();
	}


	OpExec() {
		let address;
		let tmp;
		let data;
		let bit;
		let src;
		let dist;
		let len;
		let alt;
		let i;

		let op = this.Get(this.PC);

		switch(op) {
			case 0x69: // ADC IMM
				this.ADC(this.PC + 1);
				break;
			case 0x65: // ADC ZP
				this.ADC(this.ZP());
				break;
			case 0x75: // ADC ZP, X
				this.ADC(this.ZP_X());
				break;
			case 0x72: // ADC (IND)
				this.ADC(this.IND());
				break;
			case 0x61: // ADC (IND, X)
				this.ADC(this.IND_X());
				break;
			case 0x71: // ADC (IND), Y
				this.ADC(this.IND_Y());
				break;
			case 0x6D: // ADC ABS
				this.ADC(this.ABS());
				break;
			case 0x7D: // ADC ABS, X
				this.ADC(this.ABS_X());
				break;
			case 0x79: // ADC ABS, Y
				this.ADC(this.ABS_Y());
				break;

			case 0xE9: // SBC IMM
				this.SBC(this.PC + 1);
				break;
			case 0xE5: // SBC ZP
				this.SBC(this.ZP());
				break;
			case 0xF5: // SBC ZP, X
				this.SBC(this.ZP_X());
				break;
			case 0xF2: // SBC (IND)
				this.SBC(this.IND());
				break;
			case 0xE1: // SBC (IND, X)
				this.SBC(this.IND_X());
				break;
			case 0xF1: // SBC (IND), Y
				this.SBC(this.IND_Y());
				break;
			case 0xED: // SBC ABS
				this.SBC(this.ABS());
				break;
			case 0xFD: // SBC ABS, X
				this.SBC(this.ABS_X());
				break;
			case 0xF9: // SBC ABS, Y
				this.SBC(this.ABS_Y());
				break;

			case 0x29: // AND IMM
				this.AND(this.PC + 1);
				break;
			case 0x25: // AND ZP
				this.AND(this.ZP());
				break;
			case 0x35: // AND ZP, X
				this.AND(this.ZP_X());
				break;
			case 0x32: // AND (IND)
				this.AND(this.IND());
				break;
			case 0x21: // AND (IND, X)
				this.AND(this.IND_X());
				break;
			case 0x31: // AND (IND), Y
				this.AND(this.IND_Y());
				break;
			case 0x2D: // AND ABS
				this.AND(this.ABS());
				break;
			case 0x3D: // AND ABS, X
				this.AND(this.ABS_X());
				break;
			case 0x39: // AND ABS, Y
				this.AND(this.ABS_Y());
				break;

			case 0x49: // EOR IMM
				this.EOR(this.PC + 1);
				break;
			case 0x45: // EOR ZP
				this.EOR(this.ZP());
				break;
			case 0x55: // EOR ZP, X
				this.EOR(this.ZP_X());
				break;
			case 0x52: // EOR (IND)
				this.EOR(this.IND());
				break;
			case 0x41: // EOR (IND, X)
				this.EOR(this.IND_X());
				break;
			case 0x51: // EOR (IND), Y
				this.EOR(this.IND_Y());
				break;
			case 0x4D: // EOR ABS
				this.EOR(this.ABS());
				break;
			case 0x5D: // EOR ABS, X
				this.EOR(this.ABS_X());
				break;
			case 0x59: // EOR ABS, Y
				this.EOR(this.ABS_Y());
				break;

			case 0x09: // ORA IMM
				this.ORA(this.PC + 1);
				break;
			case 0x05: // ORA ZP
				this.ORA(this.ZP());
				break;
			case 0x15: // ORA ZP, X
				this.ORA(this.ZP_X());
				break;
			case 0x12: // ORA (IND)
				this.ORA(this.IND());
				break;
			case 0x01: // ORA (IND, X)
				this.ORA(this.IND_X());
				break;
			case 0x11: // ORA (IND), Y
				this.ORA(this.IND_Y());
				break;
			case 0x0D: // ORA ABS
				this.ORA(this.ABS());
				break;
			case 0x1D: // ORA ABS, X
				this.ORA(this.ABS_X());
				break;
			case 0x19: // ORA ABS, Y
				this.ORA(this.ABS_Y());
				break;

			case 0x06: // ASL ZP
				address = this.ZP();
				this.Set(address, this.ASL(this.Get(address)));
				break;
			case 0x16: // ASL ZP, X
				address = this.ZP_X();
				this.Set(address, this.ASL(this.Get(address)));
				break;
			case 0x0E: // ASL ABS
				address = this.ABS();
				this.Set(address, this.ASL(this.Get(address)));
				break;
			case 0x1E: // ASL ABS, X
				address = this.ABS_X();
				this.Set(address, this.ASL(this.Get(address)));
				break;
			case 0x0A: // ASL A
				this.A = this.ASL(this.A);
				break;

			case 0x46: // LSR ZP
				address = this.ZP();
				this.Set(address, this.LSR(this.Get(address)));
				break;
			case 0x56: // LSR ZP, X
				address = this.ZP_X();
				this.Set(address, this.LSR(this.Get(address)));
				break;
			case 0x4E: // LSR ABS
				address = this.ABS();
				this.Set(address, this.LSR(this.Get(address)));
				break;
			case 0x5E: // LSR ABS, X
				address = this.ABS_X();
				this.Set(address, this.LSR(this.Get(address)));
				break;
			case 0x4A: // LSR A
				this.A = this.LSR(this.A);
				break;

			case 0x26: // ROL ZP
				address = this.ZP();
				this.Set(address, this.ROL(this.Get(address)));
				break;
			case 0x36: // ROL ZP, X
				address = this.ZP_X();
				this.Set(address, this.ROL(this.Get(address)));
				break;
			case 0x2E: // ROL ABS
				address = this.ABS();
				this.Set(address, this.ROL(this.Get(address)));
				break;
			case 0x3E: // ROL ABS, X
				address = this.ABS_X();
				this.Set(address, this.ROL(this.Get(address)));
				break;
			case 0x2A: // ROL A
				this.A = this.ROL(this.A);
				break;

			case 0x66: // ROR ZP
				address = this.ZP();
				this.Set(address, this.ROR(this.Get(address)));
				break;
			case 0x76: // ROR ZP, X
				address = this.ZP_X();
				this.Set(address, this.ROR(this.Get(address)));
				break;
			case 0x6E: // ROR ABS
				address = this.ABS();
				this.Set(address, this.ROR(this.Get(address)));
				break;
			case 0x7E: // ROR ABS, X
				address = this.ABS_X();
				this.Set(address, this.ROR(this.Get(address)));
				break;
			case 0x6A: // ROR A
				this.A = this.ROR(this.A);
				break;

			case 0x0F: // BBR0
				this.BBRi(0);
				break;
			case 0x1F: // BBR1
				this.BBRi(1);
				break;
			case 0x2F: // BBR2
				this.BBRi(2);
				break;
			case 0x3F: // BBR3
				this.BBRi(3);
				break;
			case 0x4F: // BBR4
				this.BBRi(4);
				break;
			case 0x5F: // BBR5
				this.BBRi(5);
				break;
			case 0x6F: // BBR6
				this.BBRi(6);
				break;
			case 0x7F: // BBR7
				this.BBRi(7);
				break;

			case 0x8F: // BBS0
				this.BBSi(0);
				break;
			case 0x9F: // BBS1
				this.BBSi(1);
				break;
			case 0xAF: // BBS2
				this.BBSi(2);
				break;
			case 0xBF: // BBS3
				this.BBSi(3);
				break;
			case 0xCF: // BBS4
				this.BBSi(4);
				break;
			case 0xDF: // BBS5
				this.BBSi(5);
				break;
			case 0xEF: // BBS6
				this.BBSi(6);
				break;
			case 0xFF: // BBS7
				this.BBSi(7);
				break;

			case 0x90: // BCC
				this.Branch((this.P & this.CFlag) == 0x00, 1);
				break;
			case 0xB0: // BCS
				this.Branch((this.P & this.CFlag) == this.CFlag, 1);
				break;
			case 0xD0: // BNE
				this.Branch((this.P & this.ZFlag) == 0x00, 1);
				break;
			case 0xF0: // BEQ
				this.Branch((this.P & this.ZFlag) == this.ZFlag, 1);
				break;
			case 0x10: // BPL
				this.Branch((this.P & this.NFlag) == 0x00, 1);
				break;
			case 0x30: // BMI
				this.Branch((this.P & this.NFlag) == this.NFlag, 1);
				break;
			case 0x50: // BVC
				this.Branch((this.P & this.VFlag) == 0x00, 1);
				break;
			case 0x70: // BVS
				this.Branch((this.P & this.VFlag) == this.VFlag, 1);
				break;
			case 0x80: // BRA
				this.Branch(true, 1);
				break;

			case 0x44: // BSR
				this.PC++;
				this.Push(this.PCH());
				this.Push(this.PCL());
				this.Branch(true, 0);
				break;
			case 0x20: // JSR ABS
				tmp = this.ABS();
				this.PC += 2;
				this.Push(this.PCH());
				this.Push(this.PCL());
				this.PC = tmp;
				this.ClearTFlag();
				break;

			case 0x40: // RTI
				this.P = this.Pull();
				this.toPCL(this.Pull());
				this.toPCH(this.Pull());
				break;
			case 0x60: // RTS
				this.ClearTFlag();
				this.toPCL(this.Pull());
				this.toPCH(this.Pull());
				this.PC++;
				break;

			case 0x4C: // JMP ABS
				this.PC = this.ABS();
				this.ClearTFlag();
				break;
			case 0x6C: // JMP (ABS)
				this.PC = this.ABS_IND();
				this.ClearTFlag();
				break;
			case 0x7C: // JMP (ABS, X)
				this.PC = this.ABS_X_IND();
				this.ClearTFlag();
				break;

			case 0x00: // BRK
				this.PC += 2;
				this.Push(this.PCH());
				this.Push(this.PCL());
				this.SetBFlag();
				this.Push(this.P);
				this.ClearDFlag();
				this.ClearTFlag();
				this.SetIFlag();
				this.PC = this.Get16(0xFFF6);
				break;

			case 0x62: // CLA
				this.A = 0x00;
				this.ClearTFlag();
				break;
			case 0x82: // CLX
				this.X = 0x00;
				this.ClearTFlag();
				break;
			case 0xC2: // CLY
				this.Y = 0x00;
				this.ClearTFlag();
				break;

			case 0x18: // CLC
				this.ClearCFlag();
				this.ClearTFlag();
				break;
			case 0xD8: // CLD
				this.ClearDFlag();
				this.ClearTFlag();
				break;
			case 0x58: // CLI
				this.ClearIFlag();
				this.ClearTFlag();
				break;
			case 0xB8: // CLV
				this.ClearVFlag();
				this.ClearTFlag();
				break;

			case 0x38: // SEC
				this.SetCFlag();
				this.ClearTFlag();
				break;
			case 0xF8: // SED
				this.SetDFlag();
				this.ClearTFlag();
				break;
			case 0x78: // SEI
				this.SetIFlag();
				this.ClearTFlag();
				break;
			case 0xF4: // SET
				this.SetTFlag();
				break;

			case 0xC9: // CMP IMM
				this.Compare(this.A, this.PC + 1);
				break;
			case 0xC5: // CMP ZP
				this.Compare(this.A, this.ZP());
				break;
			case 0xD5: // CMP ZP, X
				this.Compare(this.A, this.ZP_X());
				break;
			case 0xD2: // CMP (IND)
				this.Compare(this.A, this.IND());
				break;
			case 0xC1: // CMP (IND, X)
				this.Compare(this.A, this.IND_X());
				break;
			case 0xD1: // CMP (IND), Y
				this.Compare(this.A, this.IND_Y());
				break;
			case 0xCD: // CMP ABS
				this.Compare(this.A, this.ABS());
				break;
			case 0xDD: // CMP ABS, X
				this.Compare(this.A, this.ABS_X());
				break;
			case 0xD9: // CMP ABS, Y
				this.Compare(this.A, this.ABS_Y());
				break;
			case 0xE0: // CPX IMM
				this.Compare(this.X, this.PC + 1);
				break;
			case 0xE4: // CPX ZP
				this.Compare(this.X, this.ZP());
				break;
			case 0xEC: // CPX ABS
				this.Compare(this.X, this.ABS());
				break;
			case 0xC0: // CPY IMM
				this.Compare(this.Y, this.PC + 1);
				break;
			case 0xC4: // CPY ZP
				this.Compare(this.Y, this.ZP());
				break;
			case 0xCC: // CPY ABS
				this.Compare(this.Y, this.ABS());
				break;

			case 0xC6: // DEC ZP
				address = this.ZP();
				this.Set(address, this.Decrement(this.Get(address)));
				break;
			case 0xD6: // DEC ZP, X
				address = this.ZP_X();
				this.Set(address, this.Decrement(this.Get(address)));
				break;
			case 0xCE: // DEC ABS
				address = this.ABS();
				this.Set(address, this.Decrement(this.Get(address)));
				break;
			case 0xDE: // DEC ABS, X
				address = this.ABS_X();
				this.Set(address, this.Decrement(this.Get(address)));
				break;
			case 0x3A: // DEC A
				this.A = this.Decrement(this.A);
				break;
			case 0xCA: // DEX
				this.X = this.Decrement(this.X);
				break;
			case 0x88: // DEY
				this.Y = this.Decrement(this.Y);
				break;

			case 0xE6: // INC ZP
				address = this.ZP();
				this.Set(address, this.Increment(this.Get(address)));
				break;
			case 0xF6: // INC ZP, X
				address = this.ZP_X();
				this.Set(address, this.Increment(this.Get(address)));
				break;
			case 0xEE: // INC ABS
				address = this.ABS();
				this.Set(address, this.Increment(this.Get(address)));
				break;
			case 0xFE: // INC ABS, X
				address = this.ABS_X();
				this.Set(address, this.Increment(this.Get(address)));
				break;
			case 0x1A: // INC A
				this.A = this.Increment(this.A);
				break;
			case 0xE8: // INX
				this.X = this.Increment(this.X);
				break;
			case 0xC8: // INY
				this.Y = this.Increment(this.Y);
				break;

			case 0x48: // PHA
				this.Push(this.A);
				this.ClearTFlag();
				break;
			case 0x08: // PHP
				this.Push(this.P);
				this.ClearTFlag();
				break;
			case 0xDA: // PHX
				this.Push(this.X);
				this.ClearTFlag();
				break;
			case 0x5A: // PHY
				this.Push(this.Y);
				this.ClearTFlag();
				break;

			case 0x68: // PLA
				this.A = this.Pull();
				this.SetNZFlag(this.A);
				this.ClearTFlag();
				break;
			case 0x28: // PLP
				this.P = this.Pull();
				break;
			case 0xFA: // PLX
				this.X = this.Pull();
				this.SetNZFlag(this.X);
				this.ClearTFlag();
				break;
			case 0x7A: // PLY
				this.Y = this.Pull();
				this.SetNZFlag(this.Y);
				this.ClearTFlag();
				break;

			case 0x07: // RMB0
				this.RMBi(0);
				break;
			case 0x17: // RMB1
				this.RMBi(1);
				break;
			case 0x27: // RMB2
				this.RMBi(2);
				break;
			case 0x37: // RMB3
				this.RMBi(3);
				break;
			case 0x47: // RMB4
				this.RMBi(4);
				break;
			case 0x57: // RMB5
				this.RMBi(5);
				break;
			case 0x67: // RMB6
				this.RMBi(6);
				break;
			case 0x77: // RMB7
				this.RMBi(7);
				break;

			case 0x87: // SMB0
				this.SMBi(0);
				break;
			case 0x97: // SMB1
				this.SMBi(1);
				break;
			case 0xA7: // SMB2
				this.SMBi(2);
				break;
			case 0xB7: // SMB3
				this.SMBi(3);
				break;
			case 0xC7: // SMB4
				this.SMBi(4);
				break;
			case 0xD7: // SMB5
				this.SMBi(5);
				break;
			case 0xE7: // SMB6
				this.SMBi(6);
				break;
			case 0xF7: // SMB7
				this.SMBi(7);
				break;

			case 0x22: // SAX
				tmp = this.A;
				this.A = this.X;
				this.X = tmp;
				this.ClearTFlag();
				break;
			case 0x42: // SAY
				tmp = this.A;
				this.A = this.Y;
				this.Y = tmp;
				this.ClearTFlag();
				break;
			case 0x02: // SXY
				tmp = this.X;
				this.X = this.Y;
				this.Y = tmp;
				this.ClearTFlag();
				break;

			case 0xAA: // TAX
				this.X = this.A;
				this.SetNZFlag(this.X);
				this.ClearTFlag();
				break;
			case 0xA8: // TAY
				this.Y = this.A;
				this.SetNZFlag(this.Y);
				this.ClearTFlag();
				break;
			case 0xBA: // TSX
				this.X = this.S;
				this.SetNZFlag(this.X);
				this.ClearTFlag();
				break;
			case 0x8A: // TXA
				this.A = this.X;
				this.SetNZFlag(this.A);
				this.ClearTFlag();
				break;
			case 0x9A: // TXS
				this.S = this.X;
				this.ClearTFlag();
				break;
			case 0x98: // TYA
				this.A = this.Y;
				this.SetNZFlag(this.A);
				this.ClearTFlag();
				break;

			case 0x89: // BIT IMM
				this.BIT(this.PC + 1);
				break;
			case 0x24: // BIT ZP
				this.BIT(this.ZP());
				break;
			case 0x34: // BIT ZP, X
				this.BIT(this.ZP_X());
				break;
			case 0x2C: // BIT ABS
				this.BIT(this.ABS());
				break;
			case 0x3C: // BIT ABS, X
				this.BIT(this.ABS_X());
				break;

			case 0x83: // TST IMM ZP
				this.TST(this.PC + 1, 0x2000 | this.Get(this.PC + 2));
				break;
			case 0xA3: // TST IMM ZP, X
				this.TST(this.PC + 1, 0x2000 | ((this.Get(this.PC + 2) + this.X) & 0xFF));
				break;
			case 0x93: // TST IMM ABS
				this.TST(this.PC + 1, this.Get16(this.PC + 2));
				break;
			case 0xB3: // TST IMM ABS, X
				this.TST(this.PC + 1, (this.Get16(this.PC + 2) + this.X) & 0xFFFF);
				break;

			case 0x14: // TRB ZP
				this.TRB(this.ZP())
				break;
			case 0x1C: // TRB ABS
				this.TRB(this.ABS())
				break;

			case 0x04: // TSB ZP
				this.TSB(this.ZP())
				break;
			case 0x0C: // TSB ABS
				this.TSB(this.ABS())
				break;

			case 0xA9: // LDA IMM
				this.A = this.Load(this.PC + 1);
				break;
			case 0xA5: // LDA ZP
				this.A = this.Load(this.ZP());
				break;
			case 0xB5: // LDA ZP, X
				this.A = this.Load(this.ZP_X());
				break;
			case 0xB2: // LDA (IND)
				this.A = this.Load(this.IND());
				break;
			case 0xA1: // LDA (IND, X)
				this.A = this.Load(this.IND_X());
				break;
			case 0xB1: // LDA (IND), Y
				this.A = this.Load(this.IND_Y());
				break;
			case 0xAD: // LDA ABS
				this.A = this.Load(this.ABS());
				break;
			case 0xBD: // LDA ABS, X
				this.A = this.Load(this.ABS_X());
				break;
			case 0xB9: // LDA ABS, Y
				this.A = this.Load(this.ABS_Y());
				break;
			case 0xA2: // LDX IMM
				this.X = this.Load(this.PC + 1);
				break;
			case 0xA6: // LDX ZP
				this.X = this.Load(this.ZP());
				break;
			case 0xB6: // LDX ZP, Y
				this.X = this.Load(this.ZP_Y());
				break;
			case 0xAE: // LDX ABS
				this.X = this.Load(this.ABS());
				break;
			case 0xBE: // LDX ABS, Y
				this.X = this.Load(this.ABS_Y());
				break;
			case 0xA0: // LDY IMM
				this.Y = this.Load(this.PC + 1);
				break;
			case 0xA4: // LDY ZP
				this.Y = this.Load(this.ZP());
				break;
			case 0xB4: // LDY ZP, X
				this.Y = this.Load(this.ZP_X());
				break;
			case 0xAC: // LDY ABS
				this.Y = this.Load(this.ABS());
				break;
			case 0xBC: // LDY ABS, X
				this.Y = this.Load(this.ABS_X());
				break;

			case 0x85: // STA ZP
				this.Store(this.ZP(), this.A);
				break;
			case 0x95: // STA ZP, X
				this.Store(this.ZP_X(), this.A);
				break;
			case 0x92: // STA (IND)
				this.Store(this.IND(), this.A);
				break;
			case 0x81: // STA (IND, X)
				this.Store(this.IND_X(), this.A);
				break;
			case 0x91: // STA (IND), Y
				this.Store(this.IND_Y(), this.A);
				break;
			case 0x8D: // STA ABS
				this.Store(this.ABS(), this.A);
				break;
			case 0x9D: // STA ABS, X
				this.Store(this.ABS_X(), this.A);
				break;
			case 0x99: // STA ABS, Y
				this.Store(this.ABS_Y(), this.A);
				break;
			case 0x86: // STX ZP
				this.Store(this.ZP(), this.X);
				break;
			case 0x96: // STX ZP, Y
				this.Store(this.ZP_Y(), this.X);
				break;
			case 0x8E: // STX ABS
				this.Store(this.ABS(), this.X);
				break;
			case 0x84: // STY ZP
				this.Store(this.ZP(), this.Y);
				break;
			case 0x94: // STY ZP, X
				this.Store(this.ZP_X(), this.Y);
				break;
			case 0x8C: // STY ABS
				this.Store(this.ABS(), this.Y);
				break;
			case 0x64: // STZ ZP
				this.Store(this.ZP(), 0x00);
				break;
			case 0x74: // STZ ZP, X
				this.Store(this.ZP_X(), 0x00);
				break;
			case 0x9C: // STZ ABS
				this.Store(this.ABS(), 0x00);
				break;
			case 0x9E: // STZ ABS, X
				this.Store(this.ABS_X(), 0x00);
				break;

			case 0xEA: // NOP
				this.ClearTFlag();
				break;

			case 0x03: // ST0
				this.SetVDCSelect(this.Get(this.PC + 1));
				this.ClearTFlag();
				break;
			case 0x13: // ST1
				this.SetVDCLow(this.Get(this.PC + 1));
				this.ClearTFlag();
				break;
			case 0x23: // ST2
				this.SetVDCHigh(this.Get(this.PC + 1));
				this.ClearTFlag();
				break;

			case 0x53: // TAMi
				data = this.Get(this.PC + 1);
				bit = 0x01;
				if(data == 0x00)
					data = this.MPRSelect;
				else
					this.MPRSelect = data;
				for(i=0; i<8; i++)
					if((data & (bit << i)) != 0x00)
						this.MPR[i] = this.A << 13;
				break;
			case 0x43: // TMAi
				data = this.Get(this.PC + 1);
				bit = 0x01;
				if(data == 0x00)
					data = this.MPRSelect;
				else
					this.MPRSelect = data;
				for(i=0; i<8; i++)
					if((data & (bit << i)) != 0x00)
						 this.A = this.MPR[i] >>> 13;
				break;

			case 0xF3: // TAI
				src = this.Get16(this.PC + 1);
				dist = this.Get16(this.PC + 3);
				len = this.Get16(this.PC + 5);
				alt = 1;
				this.ProgressClock = 17;
				do {
					this.Set(dist, this.Get(src));
					src = (src + alt) & 0xFFFF;
					dist = (dist + 1) & 0xFFFF;
					len = (len - 1) & 0xFFFF;
					alt = alt == 1 ? -1 : 1;
					this.ProgressClock += 6;
				} while(len != 0)
				this.ClearTFlag();
				this.PC += 7;
				break;

			case 0xC3: // TDD
				src = this.Get16(this.PC + 1);
				dist = this.Get16(this.PC + 3);
				len = this.Get16(this.PC + 5);
				this.ProgressClock = 17;
				do {
					this.Set(dist, this.Get(src));
					src = (src - 1) & 0xFFFF;
					dist = (dist - 1) & 0xFFFF;
					len = (len - 1) & 0xFFFF;
					this.ProgressClock += 6;
				} while(len != 0)
				this.ClearTFlag();
				this.PC += 7;
				break;

			case 0xE3: // TIA
				src = this.Get16(this.PC + 1);
				dist = this.Get16(this.PC + 3);
				len = this.Get16(this.PC + 5);
				alt = 1;
				this.ProgressClock = 17;
				do {
					this.Set(dist, this.Get(src));
					src = (src + 1) & 0xFFFF;
					dist = (dist + alt) & 0xFFFF;
					len = (len - 1) & 0xFFFF;
					alt = alt == 1 ? -1 : 1;
					this.ProgressClock += 6;
				} while(len != 0)
				this.ClearTFlag();
				this.PC += 7;
				break;

			case 0x73: // TII
				src = this.Get16(this.PC + 1);
				dist = this.Get16(this.PC + 3);
				len = this.Get16(this.PC + 5);
				this.ProgressClock = 17;
				do {
					this.Set(dist, this.Get(src));
					src = (src + 1) & 0xFFFF;
					dist = (dist + 1) & 0xFFFF;
					len = (len - 1) & 0xFFFF;
					this.ProgressClock += 6;
				} while(len != 0)
				this.ClearTFlag();
				this.PC += 7;
				break;

			case 0xD3: // TIN
				src = this.Get16(this.PC + 1);
				dist = this.Get16(this.PC + 3);
				len = this.Get16(this.PC + 5);
				this.ProgressClock = 17;
				do {
					this.Set(dist, this.Get(src));
					src = (src + 1) & 0xFFFF;
					len = (len - 1) & 0xFFFF;
					this.ProgressClock += 6;
				} while(len != 0)
				this.ClearTFlag();
				this.PC += 7;
				break;

			case 0xD4: // CSH
				this.ClearTFlag();
				this.CPUBaseClock = this.BaseClock7;
				break;
			case 0x54: // CSL
				this.ClearTFlag();
				this.CPUBaseClock = this.BaseClock1;
				break;
			default:
				this.ClearTFlag();//NOP
				break;
		}
		this.PC += this.OpBytes[op];
		this.ProgressClock = (this.ProgressClock + this.OpCycles[op]) * this.CPUBaseClock;
	}


	Adder(address, neg) {
		let data0;
		let data1 = this.Get(address);

		if(!neg && (this.P & this.TFlag) == this.TFlag) {
			this.ProgressClock = 3;
			data0 = this.Get(0x2000 | this.X);
		} else
			data0 = this.A;

		if(neg)
			data1 = ~data1 & 0xFF;

		let carry = this.P & 0x01;
		let tmp = data0 + data1 + carry;

		if((this.P & this.DFlag) == 0x00) {
			if((((~data0 & ~data1 & tmp) | (data0 & data1 & ~tmp)) & 0x80) == 0x80)
				this.SetVFlag();
			else
				this.ClearVFlag();
		} else {
			this.ProgressClock += 1;
			if(neg) {
				if((tmp & 0x0F) > 0x09)
					tmp -= 0x06;
				if((tmp & 0xF0) > 0x90)
					tmp -= 0x60;
			} else {
				if(((data0 & 0x0F) + (data1 & 0x0F) + carry) > 0x09)
					tmp += 0x06;
				if((tmp & 0x1F0) > 0x90)
					tmp += 0x60;
			}
		}

		if(tmp > 0xFF)
			this.SetCFlag();
		else
			this.ClearCFlag();

		tmp &= 0xFF;
		this.SetNZFlag(tmp);

		if(!neg && (this.P & this.TFlag) == this.TFlag)
			this.Set(0x2000 | this.X, tmp);
		else
			this.A = tmp;

		this.ClearTFlag();
	}


	ADC(address) {
		this.Adder(address, false);
	}


	SBC(address) {
		this.Adder(address, true);
	}


	AND(address) {
		let data0;
		let data1 = this.Get(address);

		if((this.P & this.TFlag) == 0x00) {
			data0 = this.A;
		} else {
			this.ProgressClock = 3;
			data0 = this.Get(0x2000 | this.X);
		}

		let tmp = data0 & data1;
		this.SetNZFlag(tmp);

		if((this.P & this.TFlag) == 0x00)
			this.A = tmp;
		else
			this.Set(0x2000 | this.X, tmp);

		this.ClearTFlag();
	}


	EOR(address) {
		let data0;
		let data1 = this.Get(address);

		if((this.P & this.TFlag) == 0x00) {
			data0 = this.A;
		} else {
			this.ProgressClock = 3;
			data0 = this.Get(0x2000 | this.X);
		}

		let tmp = data0 ^ data1;
		this.SetNZFlag(tmp);

		if((this.P & this.TFlag) == 0x00)
			this.A = tmp;
		else
			this.Set(0x2000 | this.X, tmp);

		this.ClearTFlag();
	}


	ORA(address) {
		let data0;
		let data1 = this.Get(address);

		if((this.P & this.TFlag) == 0x00) {
			data0 = this.A;
		} else {
			this.ProgressClock = 3;
			data0 = this.Get(0x2000 | this.X);
		}

		let tmp = data0 | data1;
		this.SetNZFlag(tmp);

		if((this.P & this.TFlag) == 0x00)
			this.A = tmp;
		else
			this.Set(0x2000 | this.X, tmp);

		this.ClearTFlag();
	}


	ASL(data) {
		data <<= 1;
		if(data > 0xFF)
			this.SetCFlag();
		else
			this.ClearCFlag();

		data &= 0xFF;
		this.SetNZFlag(data);
		this.ClearTFlag();
		return data;
	}


	LSR(data) {
		if((data & 0x01) == 0x01)
			this.SetCFlag();
		else
			this.ClearCFlag();

		data >>= 1;
		this.SetNZFlag(data);
		this.ClearTFlag();
		return data;
	}


	ROL(data) {
		data = (data << 1) | (this.P & 0x01);
		if(data > 0xFF)
			this.SetCFlag();
		else
			this.ClearCFlag();

		data &= 0xFF;
		this.SetNZFlag(data);
		this.ClearTFlag();
		return data;
	}


	ROR(data) {
		let tmp = this.P & this.CFlag;
		if((data & 0x01) == 0x01)
			this.SetCFlag();
		else
			this.ClearCFlag();

		data = (data >> 1) | (tmp << 7);
		this.SetNZFlag(data);
		this.ClearTFlag();
		return data;
	}


	BBRi(bit) {
		let tmp = this.Get(this.ZP());
		tmp = (tmp >> bit) & 0x01;
		this.Branch(tmp == 0, 2);
	}


	BBSi(bit) {
		let  tmp = this.Get(this.ZP());
		tmp = (tmp >> bit) & 0x01;
		this.Branch(tmp == 1, 2);
	}


	Branch(status, adr) {
		this.ClearTFlag();
		if(status) {
			let tmp = this.Get(this.PC + adr);
			if(tmp >= 0x80)
				tmp |= 0xFF00;
			this.PC = (this.PC + adr + 1 + tmp) & 0xFFFF;
			this.ProgressClock = 2;
		} else
			this.PC += adr + 1;
	}


	Compare(data0, data1) {
		data0 -= this.Get(data1);
		if(data0 < 0)
			this.ClearCFlag();
		else
			this.SetCFlag();

		this.ClearTFlag();
		this.SetNZFlag(data0 & 0xFF);
	}


	Decrement(data) {
		data = (data - 1) & 0xFF;
		this.SetNZFlag(data);
		this.ClearTFlag();
		return data;
	}


	Increment(data) {
		data = (data + 1) & 0xFF;
		this.SetNZFlag(data);
		this.ClearTFlag();
		return data;
	}


	Push(data) {
		this.Set(0x2100 | this.S, data);
		this.S = (this.S - 1) & 0xFF;
	}


	Pull() {
		this.S = (this.S + 1) & 0xFF;
		return this.Get(0x2100 | this.S);
	}


	RMBi(bit) {
		let address = this.ZP();
		this.Set(address, this.Get(address) & ~(0x01 << bit));
		this.ClearTFlag();
	}


	SMBi(bit) {
		let address = this.ZP();
		this.Set(address, this.Get(address) | (0x01 << bit));
		this.ClearTFlag();
	}


	BIT(address) {
		let tmp = this.Get(address);
		this.SetNZFlag(this.A & tmp);
		this.P = (this.P & ~(this.NFlag | this.VFlag)) | (tmp & (this.NFlag | this.VFlag));
		this.ClearTFlag();
	}


	TST(address0, address1) {
		let tmp0 = this.Get(address0);
		let tmp1 = this.Get(address1);
		this.SetNZFlag(tmp0 & tmp1);
		this.P = (this.P & ~(this.NFlag | this.VFlag)) | (tmp1 & (this.NFlag | this.VFlag));
		this.ClearTFlag();
	}


	TRB(address) {
		let tmp = this.Get(address);
		let res = ~this.A & tmp;
		this.Set(address, res);
		this.SetNZFlag(res);
		this.P = (this.P & ~(this.NFlag | this.VFlag)) | (tmp & (this.NFlag | this.VFlag));
		this.ClearTFlag();
	}


	TSB(address) {
		let tmp = this.Get(address);
		let res = this.A | tmp;
		this.Set(address, res);
		this.SetNZFlag(res);
		this.P = (this.P & ~(this.NFlag | this.VFlag)) | (tmp & (this.NFlag | this.VFlag));
		this.ClearTFlag();
	}


	Load(address) {
		let data = this.Get(address);
		this.SetNZFlag(data);
		this.ClearTFlag();
		return data;
	}


	Store(address, data) {
		this.Set(address, data);
		this.ClearTFlag();
	}


	ZP() {
		return 0x2000 | this.Get(this.PC + 1);
	}


	ZP_X() {
		return 0x2000 | ((this.Get(this.PC + 1) + this.X) & 0xFF);
	}


	ZP_Y() {
		return 0x2000 | ((this.Get(this.PC + 1) + this.Y) & 0xFF);
	}


	IND() {
		return this.Get16(0x2000 | this.Get(this.PC + 1));
	}


	IND_X() {
		return this.Get16(0x2000 | ((this.Get(this.PC + 1) + this.X) & 0xFF));
	}


	IND_Y() {
		return (this.Get16(0x2000 | this.Get(this.PC + 1)) + this.Y) & 0xFFFF;
	}


	ABS() {
		return this.Get16(this.PC + 1);
	}


	ABS_X() {
		return (this.Get16(this.PC + 1) + this.X) & 0xFFFF;
	}


	ABS_Y() {
		return (this.Get16(this.PC + 1) + this.Y) & 0xFFFF;
	}


	ABS_IND() {
		return this.Get16(this.Get16(this.PC + 1));
	}


	ABS_X_IND() {
		return this.Get16((this.Get16(this.PC + 1) + this.X) & 0xFFFF);
	}


	SetNZFlag(data) { // Set N Z Flags
		this.P = (this.P & ~(this.NFlag | this.ZFlag)) | this.NZCacheTable[data];
	}


	SetVFlag() { // Set V Flag
		this.P |= this.VFlag;
	}


	ClearVFlag() { // Clear V Flag
		this.P &= ~this.VFlag;
	}


	SetTFlag() { // Set T Flag
		this.P |= this.TFlag;
	}


	ClearTFlag() { // Clear T Flag
		this.P &= ~this.TFlag;
	}


	SetBFlag() { // Set B Flag
		this.P |= this.BFlag;
	}


	ClearBFlag() { // Clear B Flag
		this.P &= ~this.BFlag;
	}


	SetDFlag() { // Set D Flag
		this.P |= this.DFlag;
	}


	ClearDFlag() { // Clear D Flag
		this.P &= ~this.DFlag;
	}


	SetIFlag() { // Set I Flag
		this.P |= this.IFlag;
	}


	ClearIFlag() { // Clear I Flag
		this.P &= ~this.IFlag;
	}


	SetCFlag() { // Set C Flag
		this.P |= this.CFlag;
	}


	ClearCFlag() { // Clear C Flag
		this.P &= ~this.CFlag;
	}


	PCH() {
		return this.PC >> 8;
	}


	PCL() {
		return this.PC & 0x00FF;
	}


	toPCH(data) {
		this.PC = (this.PC & 0x00FF) | (data << 8);
	}


	toPCL(data) {
		this.PC = (this.PC & 0xFF00) | data;
	}


	/* ***************** */
	/* **** Storage **** */
	/* ***************** */
	GetIntStatus() {
		return ~this.IntDisableRegister & this.GetIntReqest();
	}


	GetIntDisable() {
		return this.IntDisableRegister;
	}


	SetIntDisable(data) {
		this.IntDisableRegister = data;
		this.TimerAcknowledge();
	}


	GetIntReqest() {
		return ((this.VDCStatus & 0x3F) != 0x00 ? this.IRQ1Flag : 0x00) | this.INTIRQ2 | this.INTTIQ;
	}


	SetIntReqest(data) {
		this.TimerAcknowledge();
	}


	SetROM(rom) {
		this.Init();
		let tmp = rom.slice(rom.length % 8192);
		//if(tmp[0x001FFF] < 0xE0)
		//	tmp = tmp.map((d) => {return this.ReverseBit[d];});
		this.Mapper = new this.Mapper0(tmp, this);
		this.CPUReset();
	}


	StorageInit() {
		this.RAM.fill(0x00);
		this.StorageReset();
	}


	StorageReset() {
		this.IntDisableRegister = 0x00;//IntInit

		for(let i=0; i<7; i++)
			this.MPR[i] = 0xFF << 13;
		this.MPR[7] = 0x00;

		this.MPRSelect = 0x01;
	}


	Get16(address) {
		return (this.Get(address + 1) << 8) | this.Get(address);
	}


	Get(address) {
		address = this.MPR[address >> 13] | (address & 0x1FFF);

		if(address < 0x100000) // ROM
			return this.Mapper.Read(address);

		if(address < 0x1EE000)// NOT USE
			return;

		if(address < 0x1F0000) {// BRAM
			if(this.BRAMUse)
				return this.BRAM[address & 0x1FFF];
			else
				return 0xFF;
		}

		if(address < 0x1F8000)// RAM
			return this.RAM[address & 0x1FFF];

		if(address < 0x1FE000)// NOT USE
			return 0xFF;

		if(address < 0x1FE400) {// VDC
			switch(address & 0x000003) {
				case 0x00:
					return this.GetVDCStatus();
				case 0x01:
					return 0x00;
				case 0x02:
					return this.GetVDCLow();
				case 0x03:
					return this.GetVDCHigh();
			}
		}

		if(address < 0x1FE800) {// VCE
			switch(address & 0x000007) {
				case 0x04:
					return this.GetVCEDataLow();
				case 0x05:
					return this.GetVCEDataHigh();
				default:
					return 0xFF;

			}
		}

		if(address < 0x1FEC00)// PSG
			return this.GetPSG(address & 0x00000F);

		if(address < 0x1FF000)// TIMER
			return this.ReadTimerCounter();

		if(address < 0x1FF400)// IO
			return this.GetJoystick();

		if(address < 0x1FF800) {// INT Register
			switch(address & 0x000003) {
				case 0x02:
					return this.GetIntDisable();
				case 0x03:
					return this.GetIntReqest();
				default:
					return 0x00;
			}
		}

		return 0xFF;//EXT
	}


	Set(address, data) {
		let tmp = address;
		address = this.MPR[address >> 13] | (address & 0x1FFF);

		if(address < 0x100000) {// ROM
			this.Mapper.Write(address, data);
			return;
		}

		if(address < 0x1EE000)// NOT USE
			return;

		if(address < 0x1F0000) {// BRAM
			if(this.BRAMUse)
				this.BRAM[address & 0x1FFF] = data;
			return;
		}

		if(address < 0x1F8000) {// RAM
			this.RAM[address & 0x1FFF] = data;
			return;
		}

		if(address < 0x1FE000)// NOT USE
			return;

		if(address < 0x1FE400) {// VDC
			switch(address & 0x000003) {
				case 0x00:
					this.SetVDCSelect(data);
					break;
				case 0x02:
					this.SetVDCLow(data);
					break;
				case 0x03:
					this.SetVDCHigh(data);
					break;
			}
			return;
		}

		if(address < 0x1FE800) {// VCE
			switch(address & 0x000007) {
				case 0x00:
					this.SetVCEControl(data);
					break;
				case 0x02:
					this.SetVCEAddressLow(data);
					break;
				case 0x03:
					this.SetVCEAddressHigh(data);
					break;
				case 0x04:
					this.SetVCEDataLow(data);
					break;
				case 0x05:
					this.SetVCEDataHigh(data);
					break;
			}
			return;
		}

		if(address < 0x1FEC00) {// PSG
			this.SetPSG(address & 0x00000F, data);
			return;
		}

		if(address < 0x1FF000) {// TIMER
			switch(address & 0x000001) {
				case 0x00:
					this.WirteTimerReload(data);
					break;
				case 0x01:
					this.WirteTimerControl(data);
					break;
			}
			return;
		}

		if(address < 0x1FF400) {// IO
			this.SetJoystick(data);
			return;
		}

		if(address < 0x1FF800) {// INT Register
			switch(address & 0x000003) {
				case 0x02:
					this.SetIntDisable(data);
					break;
				case 0x03:
					this.SetIntReqest(data);
					break;
			}
			return;
		}
	}


	/* ************* */
	/* **** VCE **** */
	/* ************* */
	VCEInit() {
		for(let i=0; i<this.Palettes.length; i++)
			this.Palettes[i] = {data:0, r:0, g:0, b:0};

		this.VCEBaseClock = this.BaseClock5;
		this.VCEControl = 0x00;
		this.VCEAddress = 0x00;
		this.VCEData = 0x00;
	}


	SetVCEControl(data) {
		this.VCEControl = data;

		switch(data & 0x03) {
			case 0x00:
				this.VCEBaseClock = this.BaseClock5;
				break;
			case 0x01:
				this.VCEBaseClock = this.BaseClock7;
				break;
			case 0x02:
			case 0x03:
				this.VCEBaseClock = this.BaseClock10;
				break;
		}
	}


	SetVCEAddressLow(data) {
		this.VCEAddress = (this.VCEAddress & 0xFF00) | data;
	}


	SetVCEAddressHigh(data) {
		this.VCEAddress = ((this.VCEAddress & 0x00FF) | (data << 8)) & 0x01FF;
	}


	GetVCEDataLow() {
		return this.Palettes[this.VCEAddress].data & 0x00FF;
	}


	GetVCEDataHigh() {
		let tmp = ((this.Palettes[this.VCEAddress].data & 0xFF00) >> 8) | 0xFE;
		this.VCEAddress = (this.VCEAddress + 1) & 0x01FF;
		return tmp;
	}


	SetVCEDataLow(data) {
		this.Palettes[this.VCEAddress].data  = (this.Palettes[this.VCEAddress].data & 0xFF00) | data;
		this.ToPalettes();
	}


	SetVCEDataHigh(data) {
		this.Palettes[this.VCEAddress].data  = (this.Palettes[this.VCEAddress].data & 0x00FF) | (data << 8);
		this.ToPalettes();
		this.VCEAddress = (this.VCEAddress + 1) & 0x01FF;
	}


	ToPalettes() {
		let color = this.Palettes[this.VCEAddress].data;
		this.Palettes[this.VCEAddress].r = ((color >> 3) & 0x07) * 36;
		this.Palettes[this.VCEAddress].g = ((color >> 6) & 0x07) * 36;
		this.Palettes[this.VCEAddress].b = (color & 0x07) * 36;
	}


	/* ************* */
	/* **** VDC **** */
	/* ************* */
	MakeSpriteLine() {
		let sp = this.SPLine;
		for(let i=0; i<this.ScreenWidth; i++) {
			sp[i].data = 0x00;
			sp[i].palette = 0x00;
			sp[i].no = 255;
			sp[i].priority = 0x00;
		}

		if((this.VDCRegister[0x05] & 0x0040) == 0x0000)
			return;

		let dotcount = 0;
		let line = this.VLineCount - (this.VDS + this.VSW - 16);

		let vram = this.VRAM;
		let satb = this.SATB;
		let revbit16 = this.ReverseBit16;
		for(let i=0, s=0; i<64; i++, s+=4) {

			let y = satb[s] & 0x3FF;
			let attribute = satb[s + 3];

			let height;
			switch(attribute & 0x3000) {
				case 0x0000:
					height = 16;
					break;
				case 0x1000:
					height = 32;
					break;
				case 0x2000:
				case 0x3000:
					height = 64;
					break;
			}

			if((line + 64) < y || (line + 64) > (y + height - 1))
				continue;

			let spy = (line + 64) - y;
			if((attribute & 0x8000) == 0x8000)
				spy = (height - 1) - spy;

			let width = (attribute & 0x0100) == 0x0000 ? 16 : 32;

			let index = satb[s + 2] & 0x07FE;
			if(width == 32)
				index &= 0x07FC;

			if(height == 32)
				index &= 0x07FA;
			else if(height == 64)
				index &= 0x07F2;

			index = (index << 5) | (((spy & 0x30) << 3) | (spy & 0x0F));

			let data0;
			let data1;
			let data2;
			let data3;
			if((attribute & 0x0800) == 0x0000) {
				data0 = revbit16[vram[index]];
				data1 = revbit16[vram[index + 16]];
				data2 = revbit16[vram[index + 32]];
				data3 = revbit16[vram[index + 48]];
				if(width == 32) {
					data0 |= revbit16[vram[(index | 0x0040)]] << 16;
					data1 |= revbit16[vram[(index | 0x0040) + 16]] << 16;
					data2 |= revbit16[vram[(index | 0x0040) + 32]] << 16;
					data3 |= revbit16[vram[(index | 0x0040) + 48]] << 16;
				}
			} else {
				data0 = vram[index];
				data1 = vram[index + 16];
				data2 = vram[index + 32];
				data3 = vram[index + 48];
				if(width == 32) {
					data0 = (data0 << 16) | vram[(index | 0x0040)];
					data1 = (data1 << 16) | vram[(index | 0x0040) + 16];
					data2 = (data2 << 16) | vram[(index | 0x0040) + 32];
					data3 = (data3 << 16) | vram[(index | 0x0040) + 48];
				}
			}

			let palette = ((attribute & 0x000F) << 4) | 0x0100;
			let priority = attribute  & 0x0080;
			let x = (satb[s + 1] & 0x3FF) - 32;

			let j = 0;
			if(x < 0) {
				j -= x;
				x = 0;
			}

			for(; j<width && x<this.ScreenWidth; j++, x++) {
				let dot =  ((data0 >>> j)       & 0x0001)
					| (((data1 >>> j) << 1) & 0x0002)
					| (((data2 >>> j) << 2) & 0x0004)
					| (((data3 >>> j) << 3) & 0x0008);


				if(sp[x].data == 0x00 && dot != 0x00) {
					sp[x].data = dot;
					sp[x].palette = palette;
					sp[x].priority = priority;
				}

				if(sp[x].no == 255)
					sp[x].no = i;

				if(i != 0 && sp[x].no == 0) {
					this.VDCStatus |= this.VDCRegister[0x05] & 0x01;//SetSpriteCollisionINT
				}

				if(++dotcount == 256) {
					this.VDCStatus |= this.VDCRegister[0x05] & 0x02;//SetSpriteOverINT
					if(this.SpriteLimit)
						return;
				}
			}
		}
	}


	MakeBGLine() {
		let data = this.ImageData.data;
		let imageIndex = this.VLineCount * 576 * 4;

		let palettes = this.Palettes;

		let black = palettes[0x100];
		for(let i=0; i<this.HDS; i++) {
			data[imageIndex]     = black.r;
			data[imageIndex + 1] = black.g;
			data[imageIndex + 2] = black.b;
			imageIndex += 4;
		}

		let sp = this.SPLine;

		if((this.VDCRegister[0x05] & 0x0080) == 0x0000) {
			for(let i=0; i<this.ScreenWidth; i++, imageIndex+=4) {
				let spcolor = sp[i].data;
				let color = spcolor != 0x00 ? palettes[spcolor | sp[i].palette] : black;

				data[imageIndex]     = color.r;
				data[imageIndex + 1] = color.g;
				data[imageIndex + 2] = color.b;
			}
			return;
		}

		let WidthMask = this.VScreenWidth - 1;

		let x = this.VDCRegister[0x07];
		let index_x = (x >> 3) & WidthMask;
		x = x & 0x07;

		let y = this.DrawBGLineCount;
		let index_y = ((y >> 3) & (this.VScreenHeight - 1)) * this.VScreenWidth;
		y = y & 0x07;

		let vram = this.VRAM;
		let bgx = 0;

		let revbit = this.ReverseBit;
		while(bgx < this.ScreenWidth) {
			let tmp = vram[index_x + index_y];
			let address = ((tmp & 0x0FFF) << 4) + y;
			let palette = (tmp & 0xF000) >> 8;

			let data0 = revbit[vram[address] & 0x00FF];
			let data1 = revbit[(vram[address] & 0xFF00) >> 8] << 1;
			let data2 = revbit[vram[address + 8] & 0x00FF] << 2;
			let data3 = revbit[(vram[address + 8] & 0xFF00) >> 8] << 3;

			for(let j=x; j<8 && bgx < this.ScreenWidth; j++, bgx++, imageIndex+=4) {
				let dot = ((data0 >> j) & 0x01) | ((data1 >> j) & 0x02) | ((data2 >> j) & 0x04) | ((data3 >> j) & 0x08);
				let spcolor = sp[bgx].data;
				let color = spcolor != 0x00 && (dot == 0x00 || sp[bgx].priority == 0x0080) ?
							palettes[spcolor | sp[bgx].palette] : palettes[dot | (dot == 0x00 ? 0x00 : palette)];

				data[imageIndex]     = color.r;
				data[imageIndex + 1] = color.g;
				data[imageIndex + 2] = color.b;
			}
			x = 0;
			index_x = (index_x + 1) & WidthMask;
		}

		for(let i=0; i<this.ScreenSize[this.VCEBaseClock] - (this.ScreenWidth + this.HDS); i++) {
			data[imageIndex]     = black.r;
			data[imageIndex + 1] = black.g;
			data[imageIndex + 2] = black.b;
			imageIndex += 4;
		}
	}


	VDCRun() {
		this.VDCProgressClock += this.ProgressClock;

		if(this.VRAMtoSTABCount > 0) {//VRAMtoSTAB
			this.VRAMtoSTABCount -= this.ProgressClock;
			if(this.VRAMtoSTABCount <= 0) {
				this.VDCStatus &= 0xBF;
				this.VDCStatus |= (this.VDCRegister[0x0F] & 0x01) << 3;//VRAMtoSTAB INT
			}
		}

		if(this.VRAMtoVRAMCount > 0) {//VRAMtoVRAM
			this.VRAMtoVRAMCount -= this.ProgressClock;
			if(this.VRAMtoVRAMCount <= 0) {
				this.VDCStatus &= 0xBF;
				this.VDCStatus |= (this.VDCRegister[0x0F] & 0x02) << 3;//VRAMtoVRAM INT
			}
		}

		while(this.VDCProgressClock >= 1368) {
			this.VDCProgressClock -= 1368;

			this.VLineCount++;

			if(this.VLineCount == 262) {
				this.VLineCount = 0;
				this.GetScreenSize();
			}

			if(this.VLineCount < 240) {
				if(this.VLineCount >= (this.VDS + this.VSW - 16) && this.VLineCount <= (this.VDS + this.VSW - 16 + this.VDW)) {
					if(this.VLineCount == (this.VDS + this.VSW - 16))
						this.DrawBGLineCount = this.VDCRegister[0x08] & this.VScreenHeightMask;
					else
						this.DrawBGLineCount = (this.DrawBGLineCount + 1) & this.VScreenHeightMask;

					this.MakeSpriteLine();
					this.MakeBGLine();
				} else {
					let data = this.ImageData.data;
					let imageIndex = this.VLineCount * 576 * 4;

					let black = this.Palettes[0x100];
					let cnt = this.ScreenSize[this.VCEBaseClock];
					for(let i=0; i<cnt; i++) {
						data[imageIndex]     = black.r;
						data[imageIndex + 1] = black.g;
						data[imageIndex + 2] = black.b;
						imageIndex += 4;
					}
				}
			}

			if(this.VLineCount == (this.VDS + this.VSW - 16 + this.VDW + 3)) {
				this.VDCStatus |= (this.VDCRegister[0x05] & 0x08) << 2;//SetVSync INT
				this.Ctx.putImageData(this.ImageData, 0, 0, 0, 0, this.ScreenSize[this.VCEBaseClock], 240);
				this.DrawFlag = true;
				if(this.VRAMtoSTABStartFlag) {//VRAMtoSTAB
					for(let i=0, addr=this.VDCRegister[0x13]; i<256; i++, addr++)
						this.SATB[i] = this.VRAM[addr];
					this.VRAMtoSTABCount = 256 * this.VCEBaseClock;
					this.VDCStatus |= 0x40;
					this.VRAMtoSTABStartFlag = (this.VDCRegister[0x0F] & 0x10) == 0x10;
				}
			}

			let tmp = this.VDS + this.VSW - 16 - 1;
			if(tmp < 0)
				tmp += 262;
			if(this.VLineCount == tmp)
				this.RasterCount = 64;
			else
				this.RasterCount++;

			if(this.RasterCount == this.VDCRegister[0x06] && (this.VDCStatus & 0x20) == 0x00)
				this.VDCStatus |= this.VDCRegister[0x05] & 0x04;//SetRaster INT
		}
	}


	GetScreenSize() {
		let r = this.VDCRegister;

		this.VScreenWidth = this.VScreenWidthArray[r[0x09] & 0x0030];

		this.VScreenHeight = (r[0x09] & 0x0040) == 0x0000 ? 32 : 64;
		this.VScreenHeightMask = this.VScreenHeight * 8 - 1;
		this.ScreenWidth = ((r[0x0B] & 0x007F) + 1) * 8;
		if(this.ScreenWidth > 576)
			this.ScreenWidth = 576;

		this.VDS = ((r[0x0C] & 0xFF00) >> 8) - 1;
		this.VSW = r[0x0C] & 0x001F;
		this.VDW = r[0x0D] & 0x01FF;
		this.HDS = (r[0x0A] & 0x7F00) >> 5;

		let tmp = this.ScreenSize[this.VCEBaseClock];

		if(this.MainCanvas.width != tmp) {
			//this.MainCanvas.style.width = (tmp * 2) + 'px';//<--
			this.MainCanvas.width = tmp;
		}
		this.VDCBurst = (r[0x05] & 0x00C0) == 0x0000 ? true : false;
	}


	VDCInit() {
		this.VDCRegister.fill(0x0000);

		this.VRAM.fill(0x0000);

		this.SATB.fill(0x0000);

		for(let i=0; i<this.SPLine.length; i++)
			this.SPLine[i] = {data:0x00, no:255, priority:0x00};

		this.VDCRegister[0x09] = 0x0010;
		this.VDCRegister[0x0A] = 0x0202;
		this.VDCRegister[0x0B] = 0x031F;
		this.VDCRegister[0x0C] = 0x0F02;
		this.VDCRegister[0x0D] = 0x00EF;
		this.VDCRegister[0x0E] = 0x0003;

		this.GetScreenSize();

		this.SpriteLimit = true;
		this.DrawFlag = false;
		this.VDCStatus = 0x00;

		this.VRAMtoSTABCount = 0;
		this.VRAMtoVRAMCount = 0;

		this.VLineCount = 0;
		this.RasterCount = 64;
		this.VDCProgressClock = 0;

		this.VDCRegisterSelect = 0x00;
		this.WriteVRAMData = 0x0000;
		this.DrawBGLineCount = 0;
	}


	SetVDCSelect(data) {
		this.VDCRegisterSelect = data & 0x1F;
	}


	SetVDCLow(data) {
		if(this.VDCRegisterSelect == 0x02)
			this.WriteVRAMData = data;
		else
			this.VDCRegister[this.VDCRegisterSelect] = (this.VDCRegister[this.VDCRegisterSelect] & 0xFF00) | data;

		if(this.VDCRegisterSelect == 0x01) {
			this.VDCRegister[0x02] = this.VRAM[this.VDCRegister[0x01]];
			return;
		}

		if(this.VDCRegisterSelect == 0x08) {
			this.DrawBGLineCount = this.VDCRegister[0x08];
			return;
		}

		if(this.VDCRegisterSelect == 0x0F)
			this.VRAMtoSTABStartFlag = (this.VDCRegister[0x0F] & 0x10) == 0x10;
	}


	SetVDCHigh(data) {
		if(this.VDCRegisterSelect == 0x02) {
			this.VRAM[this.VDCRegister[0x00]] = this.WriteVRAMData | (data << 8);
			this.VDCRegister[0x00] = (this.VDCRegister[0x00] + this.GetVRAMIncrement()) & 0xFFFF;
			return;
		}

		this.VDCRegister[this.VDCRegisterSelect] = (this.VDCRegister[this.VDCRegisterSelect] & 0x00FF) | (data << 8);

		if(this.VDCRegisterSelect == 0x01) {
			this.VDCRegister[0x02] = this.VRAM[this.VDCRegister[0x01]];
			return;
		}

		if(this.VDCRegisterSelect == 0x08) {
			this.DrawBGLineCount = this.VDCRegister[0x08];
			return;
		}

		if(this.VDCRegisterSelect == 0x12) {//VRAMtoVRAM
			let si = (this.VDCRegister[0x0F] & 0x04) == 0x00 ? 1 : -1;
			let di = (this.VDCRegister[0x0F] & 0x08) == 0x00 ? 1 : -1;

			let s = this.VDCRegister[0x10];
			let d = this.VDCRegister[0x11];
			let l = this.VDCRegister[0x12] + 1;

			this.VRAMtoVRAMCount = l * this.VCEBaseClock;
			this.VDCStatus |= 0x40;

			let vram = this.VRAM;
			for(;l > 0; l--) {
				vram[d] = vram[s];
				s = (s + si) & 0xFFFF;
				d = (d + di) & 0xFFFF;
			}
			return;
		}

		if(this.VDCRegisterSelect == 0x13)//VRAMtoSTAB
			this.VRAMtoSTABStartFlag = true;
	}


	GetVRAMIncrement() {
		switch(this.VDCRegister[0x05] & 0x1800) {
			case 0x0000:
				return 1;
			case 0x0800:
				return 32;
			case 0x1000:
				return 64;
			case 0x1800:
				return 128;
		}
	}


	GetVDCStatus() {
		let tmp = this.VDCStatus;
		this.VDCStatus &= 0x40;
		return tmp;
	}


	GetVDCLow() {
		return this.VDCRegister[this.VDCRegisterSelect] & 0x00FF;
	}


	GetVDCHigh(a) {
		if(this.VDCRegisterSelect == 0x02) {
			let tmp = (this.VDCRegister[0x02] & 0xFF00) >> 8;
			this.VDCRegister[0x01] = (this.VDCRegister[0x01] + this.GetVRAMIncrement()) & 0xFFFF;
			this.VDCRegister[0x02] = this.VRAM[this.VDCRegister[0x01]];
			return tmp;
		}

		return (this.VDCRegister[this.VDCRegisterSelect] & 0xFF00) >> 8;
	}


	/* *************** */
	/* **** Sound **** */
	/* *************** */
	WebAudioFunction(e) {
		let output = [];
		let data = [];

		for(let i=0; i<2; i++) {
			output[i] = e.outputBuffer.getChannelData(i);
			data[i] = new Float32Array(this.WebAudioBufferSize);
			if(this.WaveDataArray[i].length < this.WebAudioBufferSize) {
				data[i].fill(0.0);
			} else {
				for(let j=0; j<data[i].length; j++)
					data[i][j] = this.WaveDataArray[i].shift() / ((32 * 16 * 32) * 8 * 16);
				if(this.WaveDataArray[i].length > this.WebAudioBufferSize * 2)
					this.WaveDataArray[i] = this.WaveDataArray[i].slice(this.WebAudioBufferSize);
			}
			output[i].set(data[i]);
		}
	}


	SoundInit() {
		this.WaveClockCounter = 0;
		this.WaveDataArray = [];
		this.WaveDataArray[0] = [];
		this.WaveDataArray[1] = [];
		this.WaveDataArrayLeft = [];
		this.WaveDataArrayRight = [];

		if(typeof AudioContext !== "undefined" && this.WebAudioCtx == null) {
			this.WebAudioCtx = new window.AudioContext();
			this.WebAudioJsNode = this.WebAudioCtx.createScriptProcessor(this.WebAudioBufferSize, 0, 2);
			this.WebAudioJsNode.onaudioprocess = this.WebAudioFunction.bind(this);
			this.WebAudioGainNode = this.WebAudioCtx.createGain();
			this.WebAudioJsNode.connect(this.WebAudioGainNode);
			this.WebAudioGainNode.connect(this.WebAudioCtx.destination);
		}
	}


	SoundSet() {
		let waveoutleft;
		let waveoutright;
		let ch;

		let i;
		let j;
		let out;

		this.WaveClockCounter += this.WebAudioCtx.sampleRate;
		if(this.WaveClockCounter >= this.PSGClock) {
			this.WaveClockCounter -= this.PSGClock;

			waveoutleft = 0;
			waveoutright = 0;
			for(j=0; j<6; j++) {
				if(j != 1 || !this.WaveLfoOn) {
					ch = this.PSGChannel[j];

					if(j < 4 || !ch.noiseon)
						out =  ch.keyon ? (ch.dda ? ch.R[6] & 0x1F : ch.wave[ch.index]) : 0;
					else
						out = (ch.noise & 0x0001) == 0x0001 ? 0x0F : 0;

					waveoutleft += out * ch.leftvol;
					waveoutright += out * ch.rightvol;
				}
			}
			this.WaveDataArray[0].push(waveoutleft * this.WaveVolumeLeft);
			this.WaveDataArray[1].push(waveoutright * this.WaveVolumeRight);
			this.WebAudioGainNode.gain.value = this.WaveVolume;
		}
	}


	/* ************* */
	/* **** PSG **** */
	/* ************* */
	PSGInit() {
		this.SoundInit();

		for(let i=0; i<this.PSGChannel.length; i++)
			this.PSGChannel[i] = {  R: new Array(10).fill(0),
						keyon: false,
						dda: false,
						freq: 0,
						count: 0,
						vol: 0,
						leftvol: 0,
						rightvol: 0,
						noiseon: false,
						noisefreq: 0,
						noise: 0x8000,
						noisestate: 0,
						index: 0,
						wave: new Array(32).fill(0)};
	}


	PSGRun() {
		if(this.WebAudioCtx == null)
			return;

		let ch;
		let i;
		let j;
		let ch0;
		let ch1;
		let freqtmp;

		this.PSGProgressClock += this.ProgressClock;
		i = (this.PSGProgressClock / this.PSGBaseClock) | 0;
		this.PSGProgressClock %= this.PSGBaseClock;

		while(i > 0) {
			i--;
			j = 0;

			if(this.WaveLfoOn) {
				ch0 = this.PSGChannel[0];
				ch1 = this.PSGChannel[1];
				if(ch0.keyon) {
					if(ch0.count == 0) {
						ch0.index = (ch0.index + 1) & 0x1F;
						freqtmp = 0;
						if(this.WaveLfoControl != 0x00) {
							freqtmp = ch1.wave[ch1.index];
							freqtmp = freqtmp > 0x0F ? freqtmp - 0x20 : freqtmp & 0x0F;
							freqtmp <<= 4 * (this.WaveLfoControl - 1);
						}
						freqtmp = ch0.freq + freqtmp;
						if(freqtmp < 0)
							freqtmp = 0;
						ch0.count = freqtmp;
					} else
						ch0.count--;

					if(ch1.count == 0) {
						ch1.index = (ch1.index + 1) & 0x1F;
						ch1.count = ch1.freq * this.WaveLfoFreqency;
					} else
						ch1.count--;
				}
				j = 2;
			}

			for(; j<6; j++) {
				ch = this.PSGChannel[j];
				if(j < 4 || !ch.noiseon) {
					if(ch.keyon && !ch.dda) {
						if(ch.count == 0) {
							ch.index = (ch.index + 1) & 0x1F;
							ch.count = ch.freq;
						} else
							ch.count--;
					}
				} else {
					if(ch.keyon && !ch.dda) {
						if(ch.count == 0) {
							ch.index = (ch.index + 1) & 0x1F;
							if(ch.index == 0)
								ch.noise = (ch.noise >> 1) | (((ch.noise << 12) ^ (ch.noise << 15)) & 0x8000);
							ch.count = ch.noisefreq;
						} else
							ch.count--;
					}
				}
			}
			this.SoundSet();
		}
	}


	SetPSG(r, data) {
		if(r == 0) {
			this.PSGChannel[0].R[0] = data & 0x07;
			return;
		}

		if(this.PSGChannel[0].R[0] > 5)
			return;

		let ch = this.PSGChannel[this.PSGChannel[0].R[0]];
		ch.R[r] = data;

		switch(r) {
			case 1:
				this.PSGChannel[0].R[1] = data;
				this.WaveVolumeLeft = (data & 0xF0) >> 4;
				this.WaveVolumeRight = data & 0x0F;
				return;

			case 2:
			case 3:
				ch.freq = ((ch.R[3] << 8) | ch.R[2]) & 0x0FFF;
				return;

			case 4:
				ch.keyon = (data & 0x80) == 0x80 ? true : false;
				ch.dda = (data & 0x40) == 0x40 ? true : false;
				if((data & 0x40) == 0x40)
					ch.index = 0;
				ch.vol = data & 0x1F;
			case 5:
				let vol = ch.R[4] & 0x1F;
				ch.leftvol = ((ch.R[5] & 0xF0) >> 4) * vol;
				ch.rightvol = (ch.R[5] & 0x0F) * vol;
				return;

			case 6:
				if(!ch.dda) {
					ch.wave[ch.index] = data & 0x1F;
					ch.index = (ch.index + 1) & 0x1F;
				}
				return;

			case 7:
				ch.noiseon = (data & 0x80) == 0x80 ? true : false;
				ch.noisefreq = (data & 0x1F) ^ 0x1F;
				return;

			case 8:
				this.PSGChannel[0].R[8] = data;
				this.WaveLfoFreqency = data;
				return;

			case 9:
				this.PSGChannel[0].R[9] = data;
				this.WaveLfoOn = (data & 0x80) == 0x80 ? true : false;
				this.WaveLfoControl = data & 0x03;
				return;
		}
	}


	GetPSG(r) {
		if(r > 9)
			return 0xFF;
		if(r == 0 || r  == 1 || r == 8 || r == 9)
			return this.PSGChannel[0].R[r];
		if(this.PSGChannel[0].R[0] > 5)
			return 0xFF;
		return this.PSGChannel[this.PSGChannel[0].R[0]].R[r];
	}


	/* *************** */
	/* **** TIMER **** */
	/* *************** */
	TimerInit() {
		this.TimerReload = 0x00;
		this.TimerFlag = false;
		this.TimerCounter = 0x00;
		this.TimerPrescaler = 0;
		this.INTTIQ = 0x00;
	}


	ReadTimerCounter() {
		return this.TimerCounter;
	}


	TimerAcknowledge() {
		this.INTTIQ = 0x00;
	}


	WirteTimerReload(data) {
		this.TimerReload = data & 0x7F;
	}


	WirteTimerControl(data) {
		if(!this.TimerFlag && (data & 0x01) == 0x01) {
			this.TimerCounter = this.TimerReload;
			this.TimerPrescaler = 0;
		}

		this.TimerFlag = (data & 0x01) == 0x01 ? true : false;
	}


	TimerRun() {
		if(this.TimerFlag) {
			this.TimerPrescaler += this.ProgressClock;
			while(this.TimerPrescaler >= (1024 * this.TimerBaseClock)) {
				this.TimerPrescaler -= 1024 * this.TimerBaseClock;
				this.TimerCounter--;
				if(this.TimerCounter < 0) {
					this.TimerCounter = this.TimerReload;
					this.INTTIQ = this.TIQFlag;
				}
			}
		}
	}


	/* ****************** */
	/* **** Joystick **** */
	/* ****************** */
	JoystickInit() {
		this.JoystickSEL = 0;
		this.JoystickCLR = 0;

		for(let i=0; i<this.Keybord.length; i++) {
			this.Keybord[i][0] = 0xBF;
			this.Keybord[i][1] = 0xBF;
			this.Keybord[i][2] = 0xBF;
			this.Keybord[i][3] = 0xBA;
		}

		for(let i=0; i<this.GamePad.length; i++) {
			this.GamePad[i][0] = 0xBF;
			this.GamePad[i][1] = 0xBF;
			this.GamePad[i][2] = 0xBF;
			this.GamePad[i][3] = 0xBA;
		}

		this.GamePadSelect = 0;
		this.GamePadButtonSelect = 1;
	}


	SetJoystick(data) {
		let sel = data & 0x01;
		let clr = (data & 0x02) >> 1;

		if((this.JoystickSEL == 1 && this.JoystickCLR == 0) && (sel == 1 && clr == 1)) {
			this.GamePadSelect = 0;
			this.GamePadButtonSelect = (this.GamePadButtonSelect + 1) & 0x01;
		}

		if((this.JoystickSEL == 0 && this.JoystickCLR == 0) && (sel == 1 && clr == 0))
			this.GamePadSelect++;

		this.JoystickSEL = sel;
		this.JoystickCLR = clr;
	}


	GetJoystick() {
		let sel = this.MultiTap ? this.GamePadSelect : 0;
		if(sel < 5) {
			let tmp = this.GamePadButton6 ? (this.GamePadButtonSelect << 1) | this.JoystickSEL : this.JoystickSEL;
			return (this.Keybord[sel][tmp] & this.GamePad[sel][tmp]) | (this.CountryType << 6);
		} else
			return 0xBF | (this.CountryType << 6);
	}


	CheckKeyUpFunction(evt) {
		switch (evt.keyCode){
			case 83:// RUN 'S'
				this.Keybord[0][0] |= 0x08;
				break;
			case 65:// SELECT 'A'
				this.Keybord[0][0] |= 0x04;
				break;
			case 90:// SHOT2 'Z'
				this.Keybord[0][0] |= 0x02;
				break;
			case 88:// SHOT1 'X'
				this.Keybord[0][0] |= 0x01;
				break;

			case 86:// SHOT2 'V'
				this.Keybord[0][0] |= 0x02;
				break;
			case 66:// SHOT1 'B'
				this.Keybord[0][0] |= 0x01;
				break;

			case 37:// LEFT
				this.Keybord[0][1] |= 0x08;
				break;
			case 39:// RIGHT
				this.Keybord[0][1] |= 0x02;
				break;
			case 40:// DOWN
				this.Keybord[0][1] |= 0x04;
				break;
			case 38:// UP
				this.Keybord[0][1] |= 0x01;
				break;

			case 71:// SHOT6 'G'
				this.Keybord[0][2] |= 0x08;
				break;
			case 70:// SHOT5 'F'
				this.Keybord[0][2] |= 0x04;
				break;
			case 68:// SHOT4 'D'
				this.Keybord[0][2] |= 0x02;
				break;
			case 67:// SHOT3 'C'
				this.Keybord[0][2] |= 0x01;
				break;
		}
		evt.preventDefault();
	}


	CheckKeyDownFunction(evt) {
		switch (evt.keyCode){
			case 83:// RUN 'S'
				this.Keybord[0][0] &= ~0x08;
				break;
			case 65:// SELECT 'A'
				this.Keybord[0][0] &= ~0x04;
				break;
			case 90:// SHOT2 'Z'
				this.Keybord[0][0] &= ~0x02;
				break;
			case 88:// SHOT1 'X'
				this.Keybord[0][0] &= ~0x01;
				break;

			case 86:// SHOT2 'V'
				this.Keybord[0][0] &= ~0x02;
				break;
			case 66:// SHOT1 'B'
				this.Keybord[0][0] &= ~0x01;
				break;

			case 37:// LEFT
				this.Keybord[0][1] &= ~0x08;
				break;
			case 39:// RIGHT
				this.Keybord[0][1] &= ~0x02;
				break;
			case 40:// DOWN
				this.Keybord[0][1] &= ~0x04;
				break;
			case 38:// UP
				this.Keybord[0][1] &= ~0x01;
				break;

			case 71:// SHOT6 'G'
				this.Keybord[0][2] &= ~0x08;
				break;
			case 70:// SHOT5 'F'
				this.Keybord[0][2] &= ~0x04;
				break;
			case 68:// SHOT4 'D'
				this.Keybord[0][2] &= ~0x02;
				break;
			case 67:// SHOT3 'C'
				this.Keybord[0][2] &= ~0x01;
				break;
		}
		evt.preventDefault();
	}


	JoystickEventInit() {
		this.KeyUpFunction = this.CheckKeyUpFunction.bind(this);
		this.KeyDownFunction = this.CheckKeyDownFunction.bind(this);
		window.addEventListener("keyup", this.KeyUpFunction, true);
		window.addEventListener("keydown", this.KeyDownFunction, true);
	}


	JoystickEventRelease() {
		window.removeEventListener("keyup", this.KeyUpFunction, true);
		window.removeEventListener("keydown", this.KeyDownFunction, true);
	}

	CheckGamePad() {
		for(let i=0; i<this.GamePad.length; i++) {
			this.GamePad[i][0] = 0xBF;
			this.GamePad[i][1] = 0xBF;
			this.GamePad[i][2] = 0xBF;
			this.GamePad[i][3] = 0xBA;
		}

		if(typeof navigator.getGamepads === "undefined")
			return;

		let pads = navigator.getGamepads();
		for(let i=0; i<5; i++) {
			let pad = pads[i];
			if(typeof pad !== "undefined" && pad !== null) {

				let paddata;
				if(pad.mapping === "standard")
					paddata = this.GamePadData["STANDARD PAD"];
				else {
					paddata = this.GamePadData[pad.id];
					if(typeof paddata === "undefined")
						paddata = this.GamePadData["UNKNOWN PAD"];
				}
				paddata = this.GamePadButton6 ? paddata[1] : paddata[0];

				let tmp = 0;
				for(const val0 of paddata) {
					for(const val1 of val0) {
						switch(val1.type) {
							case "B":
								if(pad.buttons[val1.index].pressed)
									this.GamePad[i][this.GamePadKeyData[tmp].index] &= ~this.GamePadKeyData[tmp].data;
								break;
							case "A-":
								if(pad.axes[val1.index] < -0.5)
									this.GamePad[i][this.GamePadKeyData[tmp].index] &= ~this.GamePadKeyData[tmp].data;
								break;
							case "A+":
								if(pad.axes[val1.index] > 0.5)
									this.GamePad[i][this.GamePadKeyData[tmp].index] &= ~this.GamePadKeyData[tmp].data;
								break;
							case "AB":
								if(pad.axes[val1.index] > -0.75)
									this.GamePad[i][this.GamePadKeyData[tmp].index] &= ~this.GamePadKeyData[tmp].data;
								break;
							case "P":
								let povtmp = ((pad.axes[val1.index] + 1) * 7 / 2 + 0.5) | 0;
								this.GamePad[i][1] &= ~(povtmp <= 7 ? this.GamePadPovData[povtmp] : 0x00);
								break;
						}
					}
					tmp++;
				}
			}
		}
	}
}
