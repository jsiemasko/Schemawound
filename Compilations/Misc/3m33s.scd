(
{
	t = 3 * 60 + 33;
	e = EnvGen.ar(Env.linen(2, t - 10, 8));
	x =
	LPF.ar(
		SinOsc.ar(SinOsc.kr([0.00017, 0.00009]).range(200,400))
		* Saw.ar(SinOsc.kr([0.0001, 0.00008]).range(40,50))
		* Saw.ar(SinOsc.kr([0.00013, 0.0002]).range(40,50))
		, SinOsc.kr(0.0021).range(100, 1000))
	+
	LPF.ar(
		SinOsc.ar(SinOsc.kr(0.00027).range(Line.kr(20,200,t),Line.kr(40,100,t)))
		* SinOsc.ar(SinOsc.kr(0.0002).range(Line.kr(40,400,t),Line.kr(50,300,t)))
		* SinOsc.ar(SinOsc.kr(0.00023).range(Line.kr(40,400,t),Line.kr(50,300,t)))
		, SinOsc.kr(0.0031).range(1000, 3000));
	x = GVerb.ar(x * e, 1, 30) * 0.05;
	x = x + (CombC.ar(x, 10, 1, 1) * SinOsc.ar(0.001)) * 0.05;
	x = HPF.ar(x, 60);
	x = Compander.ar(x, x, 0.3, 1, 1/30) * 2;
	x = Compander.ar(x, x, 0.5, 1, 1/30);
	x = x + (CombC.ar(x, 10, 0.01, 10) * SinOsc.ar(0.08));
	x * 0.7;
}.play
)
