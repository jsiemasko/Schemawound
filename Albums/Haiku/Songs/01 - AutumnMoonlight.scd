(
{
	var time = 60 * 5;
	var line = Line.ar(0, 1, time);
	var oscEnv = EnvGen.ar(Env.linen(sustainTime: time - 3, releaseTime: 2));
	var sin = SinOsc.ar(LFTri.kr(0.1).range(5000, 6000));
	var pulse = Pulse.ar(LFTri.kr([0.9, 0.92], 0, 100, 40), LFTri.kr(1, 0, 0.5, 0.5));
	var osc = pulse * sin * oscEnv;
	var compressLFO = SinOsc.kr(0.1).abs * SinOsc.kr(0.4).range(2, 20);
	var compress = Compander.ar(osc, osc, 0.7, compressLFO);
	var delay1 = compress + CombC.ar(compress, 10, LFTri.kr(0.3).range(2, 4), 10) * 0.2;
	var osc2 = delay1 * SinOsc.ar(LFTri.kr(0.5).range(300, 500));
	var delay2 = osc2 + CombC.ar(osc2, 10, LFTri.kr(0.2).range(2, 4), 10) * 0.2;
	var lpf = delay2 + (RLPF.ar(DelayC.ar(delay2, 20, 5, 0.5), 400, 0.5) * SinOsc.ar(LFTri.ar(0.0123).range(200, 300)));
	var verb1 = lpf + (GVerb.ar(lpf, LFTri.ar(0.01).range(1, 10)) * LFTri.ar(0.003));
	var verb2 = verb1 + (GVerb.ar(verb1) * 0.3);
	var compress2 = Compander.ar(verb2, verb2, 0.5, 1, 1/30);
	var hpf = HPF.ar(compress2, 30) * 0.1 * EnvGen.ar(Env.linen(0.01, time - 10, 3));
	var comb = (hpf * (1 - line)) + CombC.ar(hpf, 10, Line.ar(1, 0.1, time), 10, line);
	comb * 3;
}.play;
)
