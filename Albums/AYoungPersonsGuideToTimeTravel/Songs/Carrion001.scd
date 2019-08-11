(
{
	y = {
		x = Pulse.ar(LFTri.kr([0.9, 0.92], 0, 100, 40), LFTri.kr(1, 0, 0.5, 0.5))
		* SinOsc.ar(LFTri.kr(0.1).range(5000, 6000));
		x = Compander.ar(x, x, 0.7, SinOsc.kr(0.1).abs * SinOsc.kr(0.4).range(2, 20));
		x = x + CombC.ar(x, 10, LFTri.kr(0.3).range(2, 4), 10) * 0.2;
		x = x * SinOsc.ar(LFTri.kr(0.5).range(300, 500));
		x = x + CombC.ar(x, 10, LFTri.kr(0.2).range(2, 4), 10) * 0.2;
		x = x + (RLPF.ar(DelayC.ar(x, 20, 5, 0.5), 400, 0.5) * SinOsc.ar(LFTri.ar(0.0123).range(200, 300)));
		x = x + (GVerb.ar(x, LFTri.ar(0.01).range(1, 10)) * LFTri.ar(0.003));
		x = x + (GVerb.ar(x) * 0.3);
		x = Compander.ar(x, x, 0.5, 1, 1/30);
		x = HPF.ar(x, 30) * 0.1;
	}.play;
	23.wait;
	'done'.postln;
}.fork
)