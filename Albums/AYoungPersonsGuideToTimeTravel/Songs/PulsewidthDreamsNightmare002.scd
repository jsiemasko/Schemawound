(
{
	var t = 180;
	var pulse = Dust.kr([1.5,1.7]);
	var rand = Demand.kr(pulse, 0, Dxrand((0..4), inf));
	var crackle = SelectX.ar(rand, [Saw.ar(200), SinOsc.ar(400), Saw.ar(600), SinOsc.ar(800), Saw.ar(1000)]);
	var pulse2 = Dust.kr([1,1.2]);
	var rand2 = Demand.kr(pulse2, 0, Dxrand((0..4), inf));
	var crackle2 = SelectX.ar(rand2, [Saw.ar(10), Saw.ar(20), Saw.ar(30), Saw.ar(40), Saw.ar(50)]);
	var lines = GVerb.ar(SinOsc.ar(500 + SinOsc.ar([0.1, 0.15]).range(0, 100), 0, Line.ar(0, 1, t)) + SinOsc.ar([550, 575], 0, Line.ar(0, 1, t * 1.5)) * SinOsc.ar([10, 15]) * SinOsc.ar([0.7, 0.9], 0, 1));
	var crackle3 = crackle * crackle2 + lines * EnvGen.ar(Env.linen(0.01, t * 1.5, 0.01));
	var comb = CombC.ar(crackle3, 0.4, LFTri.ar(0.1).range(0.1, 0.15), 1, 1, crackle3);
	var select = SelectX.ar(Line.ar(0, 5, t * 1.5),
		[
			comb,
			CombC.ar(comb, 1, 1, 5, 1, comb),
			CombC.ar(comb, [0.5,0.6], 0.6, 5, 1, comb),
			CombC.ar(comb, [0.3,0.25], 0.3, 5, 1, comb),
			CombC.ar(comb, [0.125,0.15], 0.15, 5, 1, comb),
			CombC.ar(comb, [0.075,0.0625], 0.075, 5, 1, comb)
		]
	);
	var final = HPF.ar(FreeVerb.ar(CombC.ar(select, 1, 1, 10, 1, select), 0.33, 10), 40) * 0.05;
	Compander.ar(final, final, 0.7, 1, 1/30) * 0.5;
}.play
)

s.scope