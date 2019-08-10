/*
"The Same Color As Your Skin (Extended)" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
	var seconds;

	{	
		SynthDef(\TheSameColorAsYourSkin, {|seconds = 320|
			//Sines
			var sineLine1 = Line.kr(600, 210, seconds);
			var sineLine2 = Line.kr(100, 210, seconds);
			var sines = SinOsc.ar(sineLine1) * SinOsc.ar(sineLine2);
			//Filter
			var filterLineLFO = SinOsc.ar(0.2);
			var filterLine = Line.kr(200, 6000, seconds, doneAction: 2) * filterLineLFO;
			var filtLFO = SinOsc.kr(0.4).range(60, filterLine);
			var filter = BMoog.ar(sines, filtLFO, 0.9, 1).tanh * 0.5;
			//Comb
			var comb = CombL.ar(filter, 1, 0.3, 1);
			var mix1 = (comb + GVerb.ar(filter)) * 0.1;
			mix1 = (CombL.ar(mix1, 1, 1, 6) * 0.3) + mix1;
			mix1 = HPF.ar(mix1, 20) * 0.5;
			Out.ar(0, mix1);
		}).add;

		s.sync;

		seconds = 320; Synth(\TheSameColorAsYourSkin, [\seconds, seconds]);
	}.fork
)
