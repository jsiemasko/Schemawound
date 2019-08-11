(
{
	var speed = Pulse.ar(0.25).range(0.5, SinOsc.ar(0.025).range(10, [60, 90]));
	var imp = Impulse.ar(speed);
	var impEnv = EnvGen.ar(Env.perc(0.01, 0.3), imp);
	var lfo1 = LFTri.ar(0.057).range(60,[60,65]);
	var lfo2 = LFTri.ar([0.03,0.033]).range(60,200) * LFTri.ar(0.2).range(0.5,2);
	var syncSawAmp = 0.3;
	x = SyncSaw.ar(lfo1 + (impEnv * 120), lfo2 + (impEnv * 220)) * syncSawAmp;
	y = CombC.ar(x, 0.03, SinOsc.ar(0.076).range([0.02, 0.026], 0.03), 2, 1, x) * 0.3;
	z = y * impEnv;
	a = CombC.ar(z, 1, [0.35, 0.33], 1, 1, z);
	b = RLPF.ar(a, LFTri.ar([0.1, 0.25]).range(500, 10000) * (impEnv + 0.1 * 0.9), 0.5);
	b * 0.3 + CombC.ar(b * 0.05, 5, 0.25, 3);
}.play
)

s.scope