(
{
	var timeOsc = SinOsc.ar(1.3) * SinOsc.ar(1.321) * SinOsc.ar(SinOsc.ar([0.0145, 0.012]).range(0.1, 1.2));
	var env = EnvGen.ar(Env.perc(0.01, 0.4), [timeOsc > 0.5, timeOsc < -0.5]);
	var osc = SinOsc.ar([100, 120] + (env * SinOsc.kr([0.01, 0.016]).range(10, 200))) * env * SinOsc.ar(SinOsc.ar([0.02145, 0.0342]).range(200, 600));
	osc = SelectX.ar(LFTri.kr(0.012).range(0, 1), [osc, CombC.ar(osc, 5, LFTri.kr(0.085).range(1,2) * [0.3, 0.5], LFTri.kr(0.012312).range(1,10), 1, osc)]);
	osc = SelectX.ar(LFTri.kr(0.019).range(0, 1), [osc, CombC.ar(osc, 5, LFTri.kr(0.035).range(1,5), LFTri.kr(0.042312).range(1,10), 1, osc)]);
	osc = osc / 2;
	HPF.ar(GVerb.ar(osc * SinOsc.ar(SinOsc.ar([0.0645, 0.0522]).range(60, 600)), 1, 3, 0), 55) * 0.01;
}.play;
)