/*
Code for using Supercollider as a realtime livecode FX processor for audio input. Blog post explaing this code: http://schemawound.com/post/53528545022/fxloop
*/

(//*********PREPARE**********
p.pop;
//Any code that needs to access your own environment goes here
p = ProxySpace.push(s);
~fxLoop.play.fadeTime_(5);
)

(//*********FXLoop**********
~fxLoop = {
	var in = SoundIn.ar([0,1]);
	in;
}
)