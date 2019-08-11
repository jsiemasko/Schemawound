(
fork{
	var treeGate = Bus.audio(s, 2);

	SynthDef(\trees, {
		|out = 0, gate = 1, amp = 1|
		var base = 500 + SinOsc.ar(0.08).range(0, 10) + SinOsc.ar(0.07).range(0, 10) + SinOsc.ar(0.06).range(0, 10);
		var sin = SinOsc.ar([base + 0.04, base + 0.03]) * SinOsc.ar(base + 1) * SinOsc.ar(base + 0.1) * SinOsc.ar(base + 0.01) * SinOsc.ar(base + 0.001) * SinOsc.ar(base) / 2;
		sin = sin ** 2 / 10;
		sin = sin ** SinOsc.ar(40) / 10;
		sin = sin ** sin;
		sin = sin * 10;
		sin = sin.clip(-0.1, 0.1) * 5;
		sin = sin * Saw.ar(300);
		sin = sin * gate;
		// sin = CombC.ar(sin, 10, SinOsc.kr(0.05).range(0.5, 1.0), 3, 0.5) + sin;
		sin = GVerb.ar(sin) * 0.2;
		sin = HPF.ar(CombC.ar(sin, 10, SinOsc.kr(0.03).range(0.1, 0.5), 3, 0.3), 500) + sin;
		Out.ar(out, sin * amp);
	}).add;

	SynthDef(\impulse, {|out = 0, gate = 1|
		Out.ar(out, EnvGen.ar(Env.perc(0.01, 2), gate, doneAction: 2))
	}).add;

	s.sync;

	//Start up trees
	Synth(\trees, [\gate, treeGate.asMap, \amp, 1]);

	//Send it gate signals
	Pbind(*[
		instrument: \impulse,
		dur: Pseq([1, 1, 1, 1/4, 1/4, 1/4, 1/4], inf),
		out: treeGate
	]).play;



}
)