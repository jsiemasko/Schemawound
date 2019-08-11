(
{
	t = 666;
	x =
	SinOsc.ar(Line.ar(30, 900, t) + [0, 0.0001])
	*
	SinOsc.ar(Line.ar(900, 28, t) + [0.027, 1.0001])
	*
	SelectX.ar(Line.ar(0, 1, t), [SinOsc.ar(30), Saw.ar(30)])
	;
	y = SelectX.ar(SinOsc.kr(0.0001).range(0, 1), [x, DelayC.ar(x, 1, SinOsc.kr(0.0123).range(0.1, 1), 1, x)]);
	z = SelectX.ar(SinOsc.kr(0.00345).range(0, 1), [x, DelayC.ar(x, 1, SinOsc.kr(0.02211).range(0.1, 1), 1, x)]);
	a = y * z + SinOsc.ar([60, 59], 0, 0.2) * 0.3;
	b = GVerb.ar(HPF.ar(a, 50), 50, 10, 0, drylevel: 0.1) * 0.2;
	c = GVerb.ar(b, 50, 10, 0, drylevel: 0.8) * 0.02 * SinOsc.ar(111);
	c = Compander.ar(c, c, 0.5, 1, 1/30) * SinOsc.ar([0.01, 0.015]).range(0, 1);
	d = CombC.ar(c, 2, [1, 0.9], 10, 1, c);
	e = CombC.ar(d, 1, [0.4, 5], 10, 1, d);
	f = CombC.ar(e, 0.5, [0.1, 0.2], 10, 1, e);
	g = SelectX.ar(Line.ar(0, 3, t), [c, d, e, f]);
	h = HPF.ar(g, 50) * 2 * EnvGen.ar(Env.new([0, 1, 1, 0], [1, t-2, 1]));
	CombC.ar(HPF.ar(h, 1000), 1, [0.5, 0.7], 20, 0.7, h);
}.play
)