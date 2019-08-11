(
fork{
	SynthDef(\basicFM, {|out = 0, gate = 1, amp = 1, carFreq = 1000, modFreq = 100, modAmount = 2000, clipAmount = 0.1|
		var modEnv = EnvGen.ar(Env.adsr(0.5, 0.5, 0.7, 0.1, peakLevel: modAmount), gate);
		var mod = SinOsc.ar(modFreq) * modEnv;
		var car = SinOsc.ar(carFreq + mod);
		var ampEnv = EnvGen.ar(Env.adsr(0.1, 0.3, 0.7, 0.2, peakLevel: amp), gate, doneAction: 2);
		var clip = clipAmount * 500;
		Out.ar(out, (car * ampEnv * clip).clip(-0.7, 0.7) * 0.1);
	}).add;

	s.sync;

	Pbind(*[
		instrument: \basicFM,
		out: [0, 1],
		dur: Pseq([1/7, 1/3] / 1.2, inf),
		sustain: Pkey(\dur),
		amp: 1/4,
		carFreq: Pseq([1, 1, 1, 2] * 350, inf),
		modFreq: Pkey(\carFreq) * (1/8),
		modAmount: Pseq([2, 1, 0.5, 2, 1, 0.5, 2, 1, 2, 1, 0.5, 2, 1, 0.5, 2, 4] * 500, inf),
		clipAmount: Pseq([Pn(0.1, 32), Pn(1, 32)], inf)
	]).play;
}
)