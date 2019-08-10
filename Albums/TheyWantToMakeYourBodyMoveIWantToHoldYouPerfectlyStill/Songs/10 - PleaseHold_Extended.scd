/*
"Please Hold (Extended)" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
	var seconds;

	{	
		SynthDef(\PleaseHold, {|seconds = 7|
			var sines = 
				SinOsc.ar(Line.kr([40, 47], 47, seconds - 1)) 
				* 
				SinOsc.ar(Line.kr([65, 60], 47, seconds - 1))
				* 
				SinOsc.ar(Line.kr([80, 89], 47, seconds - 1))
				* 
				SinOsc.ar(Line.kr([300, 270], 47, seconds - 1))
				* 
				SinOsc.ar(Line.kr([435, 472], 47, seconds - 1))
				*
				Line.ar(1, 0, seconds)
			;
			var verb = FreeVerb.ar(sines, 1, 1, 0) * 0.9;
			var riseLine = (SinOsc.ar([330, 335]) * Line.ar(0, 0.5, seconds)).clip2(0.4);
			var env = EnvGen.ar(Env.linen(0.1, seconds - 0.2, 0.1), doneAction:2);
			var output = (verb + riseLine) * env;
			Out.ar(0, output * 0.6);
		}).add;

		s.sync;

		seconds = 420; Synth(\PleaseHold, [\seconds, seconds]);
	}.fork
)
