(
{
	t = LFTri.ar(0.02).range(0.1, 0.5);
	i = Impulse.ar(t);
	e = EnvGen.ar(Env.perc, i);
	o = Saw.ar(LFTri.ar(0.0245).range(120, 1000)) * SinOsc.ar(60) * SinOsc.ar([0,10] + SinOsc.ar(0.1).range(100, 120) * SinOsc.ar(0.015).abs) * e * 0.5;
	a = LPF.ar(CombC.ar(o, 10, 1 * t, 10) * SinOsc.ar([0.011, 0.016]), 800);
	b = LPF.ar(CombC.ar(o, 10, 1.5 * t, 10) * SinOsc.ar([0.018, 0.021]), 1000);
	c = LPF.ar(CombC.ar(o, 10, 1.2 * t, 10) * SinOsc.ar([0.0137, 0.0174]), 1200);
	o = RLPF.ar(o, LFTri.ar(0.0123456).range(800, 1600), 0.5);
	x = o + (a + b + c * 0.7) + GVerb.ar(a + b + c * 0.3, 1, 1) * 0.5;
}.play
)