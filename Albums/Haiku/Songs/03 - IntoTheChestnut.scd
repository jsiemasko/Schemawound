(
{
	x = RLPF.ar(SinOsc.ar(SinOsc.ar([0.020, 0.019]).range(3, 10)) * SyncSaw.ar(SinOsc.ar(0.01).range(1, 100), SinOsc.ar(0.017).range(300, 1000)), Line.ar(60, 10000, 60*5));
	x = GVerb.ar(x + CombL.ar(x, 10, 0.2, 10));
	EnvGen.ar(Env.linen(0.01, 60*5, 20), doneAction:2) * x * 0.03!2
}.play
)
