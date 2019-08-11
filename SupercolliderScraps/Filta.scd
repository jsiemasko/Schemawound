(
{
	x = SinOsc.ar([100, 110]) * SinOsc.ar(4) * SinOsc.ar(124);
	x = RLPF.ar(x, SinOsc.ar(SinOsc.ar(0.1).range(40, 200)).range(10, 2000) * 0.5, 0.01).clip(-0.5, 0.5)!2;
	//x = CombC.ar(x, 1, 0.1, 10, 1, x);
	x = GVerb.ar(DelayC.ar(x, 1, 1) * 0.2, 0.1, 5, drylevel: 0) + x;
	x = x * 0.03;
	x = HPF.ar(x, 50);
	x = Compander.ar(x, x, 0.5, 1, 1/30);
	x = x + GVerb.ar(x);
	x * 0.4;
}.play
)