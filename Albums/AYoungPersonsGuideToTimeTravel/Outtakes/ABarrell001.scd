(
{
	t = Impulse.ar(5 /** SinOsc.kr(0.001).range(0.9, 1)*/, 0, 0.1);
	d = PulseDivider.ar(t, 4, 9);
	k = DynKlank.ar(`[[360, 240, 740, 1480, 1000], nil, [0.1, 0.1, 0.1, 0.1, 0.1]], t, SinOsc.ar(0.03).range(0.1, 1));
	k = k + (PinkNoise.ar() * EnvGen.ar(Env.perc(0.01, 0.1), d));
	k = CombC.ar(k, 0.5, [0.5, 0.3] * LFTri.kr(0.01).range(0.9, 1.1), 10, 1, k);
	GVerb.ar(k, 1, 1) * 0.1;
}.play;
)