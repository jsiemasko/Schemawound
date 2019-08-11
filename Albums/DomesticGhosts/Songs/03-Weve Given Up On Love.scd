(
{
	a = ((Saw.ar(40) + Saw.ar(41) + Saw.ar(42) / 3!2) * Saw.ar(412) * Saw.ar(412.001) * SinOsc.ar(0.01).range(0.5, 100)).clip(-1, 1) / 2;
	b = (((Saw.ar(45) + Saw.ar(41) + Saw.ar(42) / 3!2) * Saw.ar(612) * Saw.ar(62.001) * SinOsc.ar(0.01).range(0.5, 100)).clip(-1, 1) / 2) * SinOsc.ar(SinOsc.ar(0.02345).range(40,400))  * SinOsc.ar(SinOsc.ar(0.05345).range(30,100));
	c = (a * SinOsc.ar(0.1).range(0,1)) + (b * SinOsc.ar(0.1, pi).range(0,1));
	c = GVerb.ar(c, mul:0.5);
	d = CombC.ar(c, 10, SinOsc.ar(0.01).range(0.2, 1), 1);
	e = (c * SinOsc.ar(0.03).range(0,1)) + (d * SinOsc.ar(0.03, pi).range(0,1)) * 0.5;
	f = (SinOsc.ar(SinOsc.ar(0.023).range(300,400)) * 0.1) * 0.5;
	f = (f * SinOsc.ar(0.4).range(0,1)) + (CombC.ar(GVerb.ar(GVerb.ar(f), mul: 0.2), 0.5, 0.5, 2) * SinOsc.ar(0.4, pi).range(0,1)) * 0.5;
	g = e + f;
	g * 0.5
}.play
)