(
{
	x = SinOsc.ar(0.2) * SinOsc.ar(0.12) * SinOsc.ar(SinOsc.ar([0.01, 0.012]).range(420, 650));
	x = x + CombC.ar(x, 2, LFTri.ar(0.1).range(0.5, 2), 10, 0.5);
	x = x + CombC.ar(x, 1.74, LFTri.ar(0.1).range(0.5, 2), 10, 0.5);
	x = x + CombC.ar(x, 1.34, LFTri.ar(0.1).range(0.5, 2), 10, 0.5);
	x = x + CombC.ar(x, 1.1224, LFTri.ar(0.1).range(0.5, 2), 10, 0.5);
	x = x + CombC.ar(x, 0.1224, LFTri.ar(0.1).range(0.5, 2), 10, 0.5);
	x = HPF.ar(x, 200);
	x + HPF.ar(DelayC.ar(GVerb.ar(x, 10, 3), 0.5, [0.2, 0.3], 0.7), 500) * 0.005;
}.play
)