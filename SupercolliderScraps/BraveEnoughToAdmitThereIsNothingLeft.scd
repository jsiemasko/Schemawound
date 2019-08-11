(
{
	var clock = 2;
	var impulse = Impulse.ar(clock * 3) + Impulse.ar(clock);
	var osc1 = SinOsc.ar(4400 * SinOsc.kr([0.01, 0.021]));
	var osc2 = SinOsc.ar(3570 * SinOsc.kr([0.04, 0.05]));
	var osc3 = SinOsc.ar([1540, 2014] * SinOsc.kr([0.032, 0.048]));
	var decay = LFTri.kr([0.003, 0.002]).range(0.01, 0.1);
	var env = EnvGen.ar(Env.perc(0.01, decay), impulse);
	var synthMod = SinOsc.ar(6000) * SinOsc.ar(610);
	var synth = osc1 * osc2 * osc3 * env * synthMod;
	synth = RLPF.ar(synth, SinOsc.kr(SinOsc.ar(0.001) * 0.3).range(440, 900), 0.01);
	synth = synth + (DelayC.ar(synth, clock, SinOsc.kr(0.001).range(0.7 * clock, clock)) * 0.5);
	synth = Compander.ar(synth, synth, 0.2, 1, 0.0001, 0.001, 0.3, 4);
	synth = Compander.ar(synth, synth, 0.2, 1, 0.0001, 0.001, 0.3, 4) * SinOsc.ar(SinOsc.kr(0.4231).range(600, 603));
	HPF.ar(GVerb.ar(synth, 5, 2, 0.4, 0.5, 15, 1, 0.4, 0.2, 300, 0.1) * SinOsc.ar(SinOsc.ar([0.0175, 0.0241]).range(300,3000)), 80);
}.play
)