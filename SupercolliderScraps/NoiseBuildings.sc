(
	{
	var sin1, sin2, sin3, sin4, sin5, sin6, sin7, sin8;
	sin1 = SinOsc.kr(220, 0, 440);
	sin2 = SinOsc.kr(1, 0, 5, 105);
	sin3 = SinOsc.kr(sin2, 0, 440);
	sin4 = SinOsc.kr(0.1, 0, 0.5, 1);
	sin5 = SinOsc.kr(1, 0, 0.5, 1);
	sin6 = SinOsc.kr(0.01, 0, 10);
	sin7 = SinOsc.kr(2, 0, 0.5) + SinOsc.kr(1.9, 0, 0.5);
	sin8 = SinOsc.ar(0.0001, 0, 1000);
	Out.ar(0,	
		Pan2.ar(
			SinOsc.ar(((sin1+sin2) * sin6) * sin8, 0, sin5 * sin4).distort,
			sin7
		)
	);
	}.play(s);
)