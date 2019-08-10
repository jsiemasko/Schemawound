/*
Schemawound track from "Waxen Wings Presents: Se7en Seconds in Hea7en". A Collection of 71 works all 7 seconds in length.
This compilation is meant to be downloaded in full and played on random.
The compilation is available for free download from http://waxenwings.bandcamp.com/album/se7en-seconds-in-hea7en/
Full HD version of the accompanying video can be seen at vimeo.com/47629281/
Blog post about this track: http://schemawound.tumblr.com/post/29553130142/se7en-seconds-in-hea7en-the-crawl
*/

(
	var seconds = 7;

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

		Synth(\TheCrawl, [\seconds, seconds]);
	}.fork
)
