let pce = null;


function FileChange(e) {
	FileRead(e.target.files[0]);
}


function FileRead(file) {
	let reader = new FileReader();
	reader.onload = function (e) {
		RomChange(e.target.result);
	};
	reader.readAsArrayBuffer(file);
}


function Pause() {
	pce.Pause();
	document.querySelector("#pause").disabled = true;
	document.querySelector("#start").disabled = false;
}


function Start() {
	pce.Start();
	document.querySelector("#pause").disabled = false;
	document.querySelector("#start").disabled = true;
}


function RomChange(changerom) {
	Pause();

	let rom;
	let u8array = new Uint8Array(changerom);
	rom = new Array();
	for(let i=0; i<u8array.length; i++)
		rom.push(u8array[i]);

	pce.Init();
	pce.SetROM(rom);
	Start();
}


function FullScreen() {
	let canvas = document.querySelector("#canvas0");
	if(canvas.requestFullScreen)
		canvas.requestFullScreen();
	else if(canvas.webkitRequestFullScreen)
		canvas.webkitRequestFullScreen();
	else if(canvas.mozRequestFullScreen)
		canvas.mozRequestFullScreen();
}


function Set() {
	pce = new PCE();
	if(!pce.SetCanvas("canvas0"))
		return;

	window.addEventListener("dragenter",
		function (e) {
			e.preventDefault();
		}, false);

	window.addEventListener("dragover",
		function (e) {
			e.preventDefault();
		}, false);

	window.addEventListener("drop",
		function (e) {
			e.preventDefault();
			FileRead(e.dataTransfer.files[0]);
		}, false);

	document.querySelector("#file").addEventListener("change", FileChange, false);

	window.addEventListener("gamepadconnected", function(e) {
		if(e.gamepad.index == 0)
			document.querySelector("#pad0state").innerHTML = e.gamepad.id;
	});

	window.addEventListener("gamepaddisconnected", function(e) {
		if(e.gamepad.index == 0)
			document.querySelector("#pad0state").innerHTML = "";
	});

	document.querySelector("#pause").addEventListener("click", Pause, false);
	document.querySelector("#start").addEventListener("click", Start, false);
	document.querySelector("#fullscreen").addEventListener("click",  FullScreen, false);
}


window.addEventListener('load', Set, false);
