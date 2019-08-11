(
{
	h = 250;
	a = h* 2;
	d = h * 4;
	e = SinOsc.ar(d) * SinOsc.ar([d + (d * 0.9), a - (d * 0.9)]) * SinOsc.ar([0.1, 0.11]) * 0.1;
	f = CombC.ar(e, 1, [0.4, 0.6] * SinOsc.ar(0.018).range(0.9, 1.1), 10, 1, e);
	x = h;
	y = SinOsc.ar(x) * SinOsc.ar([x + (x * 0.9), x - (x * 0.9)]) * SinOsc.ar([0.1, 0.11]) * 0.1;
	z = CombC.ar(y, 1, [0.1, 0.15] * SinOsc.ar(0.017).range(0.9, 1.1), 10, 1, y);
	b = SinOsc.ar(a) * SinOsc.ar([a + (a * 0.9), a - (a * 0.9)]) * SinOsc.ar([0.1, 0.11]) * 0.1;
	c = CombC.ar(b, 1, [0.3, 0.2] * SinOsc.ar(0.016).range(0.9, 1.1), 10, 1, b);
	g = (z * SinOsc.ar(0.07)) +
		(c * SinOsc.ar(0.05)) +
		(f * SinOsc.ar(0.02));
	i = CombC.ar(g, 1, [0.95, 0.97] * SinOsc.ar(0.006).range(0.8, 1.2), 10, 1, g);
	i = i + (i * SinOsc.ar(SinOsc.ar(0.0057).range(800, 1000)) * SinOsc.ar(0.025));
	HPF.ar(i, 50) * 0.5;
}.play
)

(
{
CombC.ar(Impulse.ar(2), 1, [0.3, 0.2], 2, 1, Impulse.ar(2)) +
	CombC.ar(Impulse.ar(2 * 1.001), 1, [0.3* 1.005, 0.2* 1.005], 2, 1, Impulse.ar(2* 1.005))
	 +
	CombC.ar(Impulse.ar(2 * 1.01), 1, [0.3* 1.001, 0.2* 1.01], 2, 1, Impulse.ar(2* 1.01))
}.play
)