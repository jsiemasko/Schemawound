/*
"The Crawl (Extended)" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
	var seconds;

	{
		SynthDef(\TheCrawl, {|seconds = 7|
			var env = EnvGen.ar(Env.linen(0.1, seconds - 0.2, 0.1), doneAction:2);
			var output = 
					Mix(
						Pulse.ar(
							(400..550) * Line.ar(1, 2.5, seconds),  
							* SinOsc.ar(0.2222) * SinOsc.ar(0.31) * SinOsc.ar(0.123).range(0.1, 0.9)
						)
					) * 0.1 * SinOsc.ar([300,150]) * env;
			output = ((output + CombL.ar(output, 0.1, 0.1, 0.1) * 0.5) * 0.4).clip2(0.2);
			output = BMoog.ar(output, 5000);
			output = FreeVerb.ar(output, Line.ar(0, 1, seconds) , 1, 0);
			Out.ar(0, output);
		}).add;

		s.sync;

		seconds = 120; Synth(\TheCrawl, [\seconds, seconds]);
	}.fork
)
