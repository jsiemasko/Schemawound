(
{
	x = SinOsc.ar(SinOsc.kr(0.01).range(78, 780)) * SinOsc.ar(80) * SinOsc.ar([700.1, 700.17]);
	x = x * SinOsc.ar([1, 0.9]) * Pulse.ar([1.4, 0.7]);
	x = CombC.ar(x, 1, [0.001, 0.0017], 1, 1, x);
	x = CombC.ar(x, 1, [0.7, 0.5], 1, 1, x);
	x = GVerb.ar(x, 30, 10) * 0.001;
	x = Compander.ar(x, x, 0.5, 1, 1/1000) * 4;
	x = HPF.ar(x, 50);
}.play
)