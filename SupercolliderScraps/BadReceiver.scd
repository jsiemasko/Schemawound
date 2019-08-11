(
{
	Saw.ar(1000)
	*
	Saw.ar(Line.kr(1010.1, 1000, 10))
	*
	EnvGen.ar(Env.linen(0.01, 10, 1), 1, doneAction:2)!2
}.play
)