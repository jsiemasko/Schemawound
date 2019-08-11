//Spires In The Garden - 5:00
(
play{
	var pulse = Impulse.ar(9e3);
	var count = PulseCount.ar(pulse);
	var bits = ((count*1.7)&(count>>9.99)|(count*1.6)&(count>>9.09))-3 % 256;
	var verb = CombC.ar(bits * 0.5, 0.1, SinOsc.ar(0.001).range(0.01, 0.8), 10)/127-1;
	var lowKill = HPF.ar(verb,20).tanh/5!2;
	var clip = lowKill.clip(-1, 1) * 2;
	var comp = Compander.ar(clip, clip, 0.5, 1, 1/30);
	var mod = comp * SinOsc.ar(600);
	var mod2 = comp * SinOsc.ar(6000);
	var line1 = SelectX.ar(Line.ar(0, 2, 300), [comp, mod, mod2]);
	var line2 = SelectX.ar(Line.ar(0, 1, 300), [line1, GVerb.ar(line1)]);
	line2 * 0.5;
};
)
