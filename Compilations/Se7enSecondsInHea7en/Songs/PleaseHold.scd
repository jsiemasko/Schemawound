/*
Schemawound track from "Waxen Wings Presents: Se7en Seconds in Hea7en". A Collection of 71 works all 7 seconds in length.
This compilation is meant to be downloaded in full and played on random.
The compilation is available for free download from http://waxenwings.bandcamp.com/album/se7en-seconds-in-hea7en/
Full HD version of the accompanying video can be seen at vimeo.com/47629281/
Blog post about this track: http://schemawound.tumblr.com/post/29553173950/se7en-seconds-in-hea7en-please-hold
*/

(
	var seconds = 7;

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

		Synth(\PleaseHold, [\seconds, seconds]);
	}.fork
)
