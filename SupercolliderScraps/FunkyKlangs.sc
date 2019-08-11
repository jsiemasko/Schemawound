/*	Some Funky Klangs - Totally botched the math on what I was trying to do but it sounds better this way */

(
	SynthDef(\DistKlangBlip, {
		| out = 0,	release = 1, freq1 = 1, freq2 = 5, freq3 = 8,  freqMult = 4 |
		var env = Linen.kr(Impulse.kr(0), 0.01, 1, release, doneAction:2);
		var freqs = ([freq1, freq2, freq3] * freqMult).midicps;
		var klang = Klang.ar(`[freqs, nil, nil ], 1, 0);
		Out.ar(out, klang.tanh!2 * env * 0.5)
	}).add
)

(
	Pbind(*[
				instrument: 	\DistKlangBlip,
				dur:			Pxrand([0.25, 0.5], inf) * 0.5,
				release:		Pkey(\dur),
				freqMult:		Pxrand((3..12), inf),
				freq2:			Prand([4,5], inf),
				freq3:			Prand([8,12], inf)
			]).play;
)        