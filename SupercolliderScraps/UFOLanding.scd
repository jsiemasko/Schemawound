(
{
	var time = 30;
	var line = Line.kr(3000, 290, time);
	var line2 = Line.kr(280, 290, time);
	var line3 = Line.kr(0.01, 10, time);
	var sin = Mix.ar(SinOsc.ar([line, line2]) * SinOsc.ar(line3));
	var comb = CombC.ar(sin, time, SinOsc.kr(0.1).range(0.1, 0.2), time);
	var env = EnvGen.ar(Env.linen(0.01, time, 10), 1, doneAction:2);
	comb * env * 0.05!2;
}.play
)