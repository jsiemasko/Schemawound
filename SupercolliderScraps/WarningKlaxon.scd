(
{
	SynthDef(\warningBeep,
		{|freq = 1000|
			var osc = SinOsc.ar(freq) * Saw.ar(Line.kr(2000, 7000, 1));
			Out.ar(0,
				(osc + CombC.ar(osc, 0.2, 0.2, 1))
				*
				EnvGen.ar(Env.perc(), 1, doneAction:2)!2
			);
	}).add;

	s.sync;

	Pbind(*[instrument: \warningBeep, amp: 0, dur: 1, freq: Pseq([1000, 1000, 1000, 1000, 800, 800, 800, 800])]).play
}.fork
)