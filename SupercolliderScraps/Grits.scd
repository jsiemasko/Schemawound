(
{
	100.do{
		{
			var numOfRes = 40;
			var freq = numOfRes.collect{1000.0.rand} + 60;
			var amp = numOfRes.collect{0.999.rand} + 0.001;
			var ringTime = numOfRes.collect{0.999.rand} + 0.001;
			var klank = Klank.ar(`[freq, amp, ringTime], PinkNoise.ar([7e-3,7e-3]));
			var env = EnvGen.ar(Env.perc(0.01, 0.3));
			var env2 = EnvGen.ar(Env.linen(0.01, 1, 1), doneAction:2);
			var osc = klank * env;
			var comb = CombC.ar(osc, 1, [0.3, 0.5], 5, 1, osc);
			comb = GVerb.ar(comb, 10, 1, mul: 1, add: 0) * 0.3;
			comb * env2;
		}.play;
		0.4.wait;
	};
}.fork;
)