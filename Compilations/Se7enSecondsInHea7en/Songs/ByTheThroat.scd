/*
Schemawound track from "Waxen Wings Presents: Se7en Seconds in Hea7en". A Collection of 71 works all 7 seconds in length.
This compilation is meant to be downloaded in full and played on random.
The compilation is available for free download from http://waxenwings.bandcamp.com/album/se7en-seconds-in-hea7en/
Full HD version of the accompanying video can be seen at vimeo.com/47629281/
Blog post about this track: http://schemawound.tumblr.com/post/29553190911/se7en-seconds-in-hea7en-by-the-throat
*/

(
	var seconds = 7;

	{	
		SynthDef(\ByTheThroat, {|seconds = 7|
			var pulse = (Pulse.ar(10, 0.5, 0.5) + Pulse.ar(35, 0.3, 0.5));
			var sin1 = SinOsc.ar(LFNoise0.kr([1.2, 1.0], 1000, 1000));
			var line1 = Line.kr(10, 3000, seconds);
			var sin2 = SinOsc.ar(line1);
			var out = pulse * sin1 * sin2 * 0.3;
			var line2 = Line.kr(100, 5000, seconds);
			var filt1 = BMoog.ar(out, line2, 0.1, 0, 0.95) * 0.8;
			var env = EnvGen.ar(Env.linen(0.1, seconds - 0.2, 0.1), doneAction:2);
			var comb = (CombL.ar(filt1, 0.1, 0.1, 1) + filt1) * env;
			Out.ar(0, HPF.ar(comb, 15) * 0.4);
		}).add;

		s.sync;

		Synth(\ByTheThroat, [\seconds, seconds]);
	}.fork
)
