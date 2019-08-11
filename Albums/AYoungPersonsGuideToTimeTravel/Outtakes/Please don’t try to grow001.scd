(
{
	var modTreePat, song;

	SynthDef(\modTree, {|out = 0, gate = 1, freqMod = 1, fmFreq = 100|
		var sawLFO = LFSaw.kr([0.2, 0.2] * LFTri.kr(0.3, 0, 3, 0.1), 0, 50 * freqMod, 40 * freqMod);
		var sinLFO = Array.with(
			LFTri.kr(0.028, 0, 100, 150),
			LFTri.kr(0.012, 0, 100, 227)
		);
		var osc = SinOsc.ar(sinLFO[0]) * SinOsc.ar(sinLFO[1]) * SinOsc.ar(sawLFO);
		var verb = FreeVerb.ar(osc);
		var env = Linen.kr(gate, 0.01, 1, 1, doneAction:2) * 0.4;
		var output = verb * env;
		output = output + (output * SinOsc.ar(fmFreq) * 0.5);
		Out.ar(out, output);
	}).add;

	SynthDef(\modTreeDelay, { |bus=0, gate=1|
		var in = In.ar(bus, 2);
		var delayLFO = LFTri.ar(0.1).range(0.9, 1.1);
		var delay = DelayC.ar(in, 1.5, delayLFO, 0.7);
		var out = in + HPF.ar(delay, 500);
		var env = Linen.kr(gate, 0.05, 1, 3, 2);
		XOut.ar(bus, env, out);
	}).add;

	s.sync;

	modTreePat = Array.with(
		Pbind(*[instrument: \modTree,
			dur: 2, sustain: Pkey(\dur),
			freqMod: Pseq([1,1,1,3]),
			fmFreq: Pseq([60,1,1,1,60,1,1,1] * 100)
		]),
		Pbind(*[instrument: \modTree,
			dur: 8, sustain: Pkey(\dur),
			freqMod: Pseq([5]),
		]),
	);

	song = Pseq([
			modTreePat[0],
			// Ppar(modTreePat)
		], inf);

	Pfx(song, \modTreeDelay, \bus, 0).play
}.fork;
)