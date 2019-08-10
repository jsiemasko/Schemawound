/*
"Sound Check (Extended)" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
	var seconds;

	{	
		SynthDef(\SoundCheck, {|seconds = 7|
			var sin1 = SinOsc.kr([110, 90], 0, [440, 330]);
			var sin2 = SinOsc.kr(1, 0, 5, 105);
			var sinModDepth = SinOsc.kr(0.01, 0, 10) * SinOsc.ar(0.00033, 0, 1000); //Magic number for 7 seconds
			var sinMod = (sin1 + sin2) * sinModDepth;
			var ampMod = SinOsc.kr(0.1, 0, 0.5, 1) * SinOsc.kr(1, 0, 0.5, 1);
			var sinLine = SinOsc.ar(Line.kr(40, 10, seconds););
			var sum = SinOsc.ar(sinMod, 0, ampMod).distort;
			var comb1 = (CombL.ar(sum, 0.01, 0.005, 1) + sum) * sinLine;
			var comb2 = (comb1 + (CombL.ar(comb1, 0.008, 0.007, 0.5) * 0.4));
			var clip1 = comb2.clip2(1) * 0.8;
			var env = EnvGen.ar(Env.linen(0.1, seconds - 0.2, 0.1), doneAction:2);
			var output = (clip1 * SinOsc.ar(40) * SinOsc.ar(456)) * env;
			Out.ar(0, output * 0.5);
		}).add;

		s.sync;

		seconds = 200; Synth(\SoundCheck, [\seconds, seconds]);
	}.fork
)
