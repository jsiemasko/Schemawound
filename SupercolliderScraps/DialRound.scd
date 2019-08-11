(
{
	var pulsePattern = LFPulse.kr([0.5, 1], 0, 0.5) * LFPulse.kr(1.5);
	var dialTone = SinOsc.ar(SinOsc.kr(0.3).range(440, 460)) * SinOsc.ar(44);
	var dialTonePattern = pulsePattern * dialTone * 0.1;
	var delayedPattern = dialTonePattern + DelayC.ar(GVerb.ar(dialTonePattern), 1, LFSaw.kr([0.1, 0.13]).range(0.95, 1), 0.5);
	HPF.ar(delayedPattern, 50);
}.play
)