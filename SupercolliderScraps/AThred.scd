(
{
	SynthDef(\saw, {|gate = 1, midi = 60, amp = 1, sawAmp = 1, sinAmp = 1, osc2Offset = 7, filtRes = 1, filtAtk = 1, ampAtk = 1|
		var osc1 = Saw.ar(midi.midicps, sawAmp) + SinOsc.ar(midi.midicps, sinAmp);
		var osc2 = Saw.ar((midi + osc2Offset).midicps, sawAmp) + SinOsc.ar((midi + osc2Offset).midicps, sinAmp);
		var ampEnv = EnvGen.ar(Env.adsr(ampAtk, 0.5, 0.5, 0.5), gate, amp, doneAction: 2);
		var filtEnv = EnvGen.ar(Env.adsr(filtAtk, 0.6, 0.5, 0.6), gate, amp);
		var out = RLPF.ar((osc1 + osc2) * ampEnv, 15000 * filtEnv, filtRes);
		Out.ar(0, out!2);
	}).add;
	s.sync;
	Pbind(*[
		instrument: \saw,
		midi: (Pseq([1, 4, 7, 4, 7], 16) + Pseq([Pn(48, Prand([2,4,6,8], inf)), Pn(60, Prand([2,4,6,8], inf)), Pn(72, Prand([2,4,6,8], inf))], inf)),
		dur: 0.24,
		amp: 0.05,
		sawAmp: Pwhite(0, 1, inf),
		sinAmp: Pwhite(0, 1, inf),
		ampAtk: 0.1,
		filtRes: Pwhite(0.3, 0.7, inf),
		filtAtk: Pwhite(0.01, 1, inf),
		osc2Offset: Pseq([12, 7, 24, 7], inf)
	]).play;
}.fork;
)

fps