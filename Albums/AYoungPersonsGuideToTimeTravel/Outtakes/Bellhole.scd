(
{
	x = SinOsc.ar(SinOsc.ar(0.23).range(60, 240)) * SinOsc.ar([444, 435]) * EnvGen.ar(Env.perc(), Impulse.ar(0.2));
	x = SinOsc.ar(330) * CombC.ar(x, 0.5, /*LFTri.ar(0.03).range(0.1, 0.3)*/ 1/3, 1, 1, x);
	x = SinOsc.ar(301) * CombC.ar(x, 0.5, /*LFTri.ar(0.0134).range(0.1, 0.47)*/ 1/7, 1, 1, x);
	x = SinOsc.ar(357) * CombC.ar(x, 0.8, /*LFTri.ar(0.0534).range(0.1, 0.77)*/ 1/5, 1, 1, x);
	x = CombC.ar(SelectX.ar(SinOsc.ar(0.14).range(0, 3), [GVerb.ar(x, 1, 3), GVerb.ar(x, 2, 3), GVerb.ar(x, 3, 3), GVerb.ar(x, 4, 3)]), 1, 1, 10, 1, x);
	x = HPF.ar(x, 45);
	x = Compander.ar(x, x, 0.3, 1, 1/10);
	x = x * SinOsc.ar([0.3, 0.47]).range(0.5, 1);
	x = x * 0.1;
	x;
}.play
) 