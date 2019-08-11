(
fork{

/*
2/26/13 - JMS -
I believe this is the same synth I used in "Hello World I Am Lonley Too" but I am using it in a different way here.
*/
	SynthDef(\addSineSynth, {
		| out = 0, freq = 440, gate = 1, amp = 1 |
		var n = 10;
		var fund = freq;

		var ampArray = Array.fill(n, {arg i; Rand.new(0.0, 1.0)});
		var freqArray = fund * (1..n);

		var output = Mix(SinOsc.ar(freqArray, 0, ampArray)) * Linen.kr(gate, 0.01, 0.2, 0.1, doneAction: 2);

		Out.ar(out, output!2 * amp);
	}).add;

s.sync;

/*
2/26/13 - JMS -
I like the way the tempo of the piece changes slightly between repititions.  It keeps the whole piece feeling slightly "off".  I am running through a tone of synths to generate the sound of the piece.  We may want to just sample it into a buffer to save memory later on.
*/
	p = Pbind(*[
		instrument:	\addSineSynth,
		note: 		Pseq([Pseq([1], 1000), Pseq([5], 1000)], inf),
		octave:		Pseq([Pseq([2], 500), Pseq([1], 500)], inf),
		dur: 		Pseq([Pseq([0.03], 2000), Pseq([0.04], 2000), Pseq([0.05], 2000), Pseq([0.04], 2000)], inf)
	]);
	o = Pbind(*[
		instrument:	\addSineSynth,
		note: 		Pseq([Pseq([1], 10), Pseq([5], 10)], inf),
		octave:		Pseq([Pseq([3], 5), Pseq([2], 5)], inf),
		dur: 		Pseq([Pseq([0.3], 20), Pseq([0.4], 20), Pseq([0.5], 20), Pseq([0.4], 20)], inf)
	]);
	Ppar([p,o]).play;

}
)