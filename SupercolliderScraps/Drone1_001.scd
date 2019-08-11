(
{
	var pulseLFO = LFTri.ar([0.1, 0.11]).range(-0.9, 0.9);
	var pitchLFO = LFTri.ar([0.243, 0.543], 0, 0.1);
	var pulse = Pulse.ar(40 + pitchLFO, pulseLFO);
	var filterLFO = LFTri.ar([0.0821, 0.0649]).range(100, 1000);
	var filtPulse = RLPF.ar(pulse, filterLFO, 0.7);
	var delayPulse = filtPulse + DelayN.ar(RHPF.ar(filtPulse, 200), 1, [0.5, 0.7], 0.7);
	delayPulse * 0.08 + (WhiteNoise.ar(0.1) * Dust.ar(100));
	//GVerb.ar(delayPulse, 30, 3, 0.1) + (delayPulse * 0.7) * 0.01;
}.play;
)