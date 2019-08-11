(
{
	var delayTime = 1;
	var lfo1 = Slew.kr(LFNoise0.kr(1).range(1,2), 0.3, 0.3);
	var crack = Crackle.ar(lfo1) * SinOsc.ar([100, 159] * (1 + (lfo1 / [5,4]))) * SinOsc.ar(LFTri.ar(1/60).range(100, 200));
	var delay1 = LPF.ar(DelayN.ar(crack, delayTime, delayTime), 2000);
	var delay2 = LPF.ar(DelayN.ar(delay1, delayTime, delayTime), 1000);
	var delay3 = LPF.ar(DelayN.ar(delay2, delayTime, delayTime), 500);
	FreeVerb.ar(crack + delay1 + delay2 + delay3, 0.6) * 0.5;
}.play;
)