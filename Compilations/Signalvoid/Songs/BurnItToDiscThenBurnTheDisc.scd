/*
Schemawound track from the SIGNALVOID compilation.
SIGNALVOID is a noise compilation. Participants were asked to create up to three tracks, each of exactly one minute in length, with no gaps of silence at the beginning or end. Download the free compilation here: http://archive.org/details/SignalvoidMp3 or http://archive.org/details/SignalvoidFlac
Physical copies are available here http://signalvoid.bandcamp.com/merch/signalvoid-2

Blog post about the creation of this track http://schemawound.tumblr.com/post/29065985817/signalvoid-1-burn-it-to-disc-then-burn-the-disc
*/

(
	{
		var saw1 = Saw.ar((10..100));
		var saw2 = Mix(Saw.ar(saw1).range(100, 600));
		var sin0 = SinOsc.ar(0.002).range(5,75);
		var sin1 = SinOsc.ar(0.1).range(1,sin0);
		var sin2 = SinOsc.ar(0.15).range(2,10);
		var sinMod = (sin1 * sin2)!2;
		var sin66 = SinOsc.ar(0.0164).range(600,1000);
		var saw3 = Saw.ar(sinMod).range(200, sin66);
		var saw4 = Saw.ar(saw3);
		var sin3 = Mix(SinOsc.ar((1..100)));
		var sum1 = (saw2 * saw4) * sin3;
		var comb1 = CombL.ar(sum1, 1, 0.2, 1) + sum1;
		var sin4 = SinOsc.ar(0.12).range(3, 1000);
		var comb2 = comb1.tanh;
		var sin5 = SinOsc.ar(sin4);
		var sin6 = SinOsc.ar(0.001);
		var comb3 = comb2 * sin5 * sin6;
		var sum2 = (comb2 + comb3) * 0.3;
		var verb1 = sum2;
		var line1 = Line.ar(1, 0.001, 60, doneAction: 2);
		var line2 = Line.ar(0, 1, 60);
		var comb4 = CombL.ar(verb1, 1, line1, 0.1) * line2;
		var sum3 = comb4 + verb1;
		sum3 * 0.5;
	}.play;
)
