(
{
	var in = (Line.ar(0, 0.7, 300) * LFSaw.ar([62, 62.1]) * LFSaw.ar([61.1,61])) + SinOsc.ar(60) * 0.05;
	in = in * SinOsc.ar(10);
	in = RLPF.ar(in, SinOsc.ar([0.01, 0.014]).range(100, 4000), 0.1);
	in = in * SinOsc.ar(400) * SinOsc.ar([LFSaw.ar(0.1) * 401, LFSaw.ar(0.09) * 402]);
	// in = in + CombC.ar(in, 1, SinOsc.ar([0.21,0.14]).range(0.002, 0.2), 10);
	in = in + CombC.ar(in, 10, [0.02, 0.01], 3);
	in = in + CombC.ar(in, 10, [0.5, 0.3], 3);
	// in = GVerb.ar(in, 1);
	in.clip(-0.3, 0.3) * 0.1;
	in = GVerb.ar(in, 10, 3, drylevel: 0.1) * 0.1;
}.play
)