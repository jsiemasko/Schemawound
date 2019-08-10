/*
Schemawound track from the SIGNALVOID compilation.
SIGNALVOID is a noise compilation. Participants were asked to create up to three tracks, each of exactly one minute in length, with no gaps of silence at the beginning or end. Download the free compilation here: http://archive.org/details/SignalvoidMp3 or http://archive.org/details/SignalvoidFlac
Physical copies are available here http://signalvoid.bandcamp.com/merch/signalvoid-2

Blog post about the creation of this track http://schemawound.tumblr.com/post/29066507849/signalvoid-2-the-same-color-as-your-skin
*/

(
var songLength = 60;
{
	//Sines
	var sineLine1 = Line.kr(600, 210, songLength);
	var sineLine2 = Line.kr(100, 210, songLength);
	var sines = SinOsc.ar(sineLine1) * SinOsc.ar(sineLine2);
	//Filter
	var filterLineLFO = SinOsc.ar(0.2);
	var filterLine = Line.kr(200, 6000, songLength, doneAction: 2) * filterLineLFO;
	var filtLFO = SinOsc.kr(0.4).range(60, filterLine);
	var filter = BMoog.ar(sines, filtLFO, 0.9, 1).tanh * 0.5;
	//Comb
	var comb = CombL.ar(filter, 1, 0.3, 1);
	var mix1 = (comb + GVerb.ar(filter)) * 0.1;
	mix1 = (CombL.ar(mix1, 1, 1, 6) * 0.3) + mix1;
	HPF.ar(mix1, 100) * 0.5;
}.play
)
