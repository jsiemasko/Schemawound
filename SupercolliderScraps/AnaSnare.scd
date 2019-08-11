(
fork{
	SynthDef(\anaSnare, {|out = 0, noiseCurve = 1, oscCurve = 1, tuning = 1|
		var noiseAmp = EnvGen.ar(Env.perc(curve: -4 * noiseCurve));
		var noise = WhiteNoise.ar() * noiseAmp;
		var filt = BPF.ar(noise, 800 * tuning);
		var oscAmp = EnvGen.ar(Env.perc(curve: -8 * oscCurve), doneAction:2);
		var osc = LFTri.ar(400 * tuning) * oscAmp;
		var snare = filt + osc;
		Out.ar(out, snare);
	}).add;

	s.sync;

	Pbind(*[
		instrument: \anaSnare,
		dur: 1/8,
		freq: Pseq([1, \rest, \rest, 1, \rest, \rest, 1, \rest], inf),
		noiseCurve: Pseq([1, 0.5, 0], inf),
		oscCurve: Pseq([1, 0.5, 0, 0.5], inf),
		tuning: Pseq([1, 0.75, 0.5, 1, 1.25, 1.5, 2], inf)
	]).play;
}
)