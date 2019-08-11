	//Sin
	/*
	sin = (SinOsc.ar([60,60.1] + SinOsc.ar([0.0234, 0.0346]).range(0, 10)) * 0.003)
	+ (Line.ar(0, 1, t / 2) * SinOsc.ar([120,120.2] + SinOsc.ar([0.0468, 0.0692]).range(0, 20)) * 0.003)
	+ (Line.ar(0, 1, t / 4 * 3) * SinOsc.ar([240,240.4] + SinOsc.ar([0.0936, 0.1384]).range(0, 40)) * 0.003)
	+ (Line.ar(0, 1, t) * SinOsc.ar([480,480.8] + SinOsc.ar([0.1872, 0.2768]).range(0, 80)) * 0.003);
	sin = SelectX.ar(LFTri.ar([0.004212, 0.005731]).range(0, 1), [sin, GVerb.ar(sin, 5, 10)]) * 0.6;
	sin = CombC.ar(sin * LFTri.ar(0.032).range(0, 1), 1, [1, 0.5], 3, 1, sin);
	sin = CombC.ar(sin * LFTri.ar(0.0452).range(0, 1), 1, [0.3, 0.7], 3, 1, sin);
	HPF.ar(sin * 0.7 + (theHorns * LFTri.ar(0.03).range(0, 1)) * 1.7, 50);
	*/