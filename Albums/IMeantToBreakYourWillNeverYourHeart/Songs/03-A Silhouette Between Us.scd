(
play{
	var pulse = Impulse.ar(Line.ar(15e3, 9e3, 1000));
	var count = PulseCount.ar(pulse) * 0.1;
	var bits = ((count*1.7)&(count>>9.99))|((count*5.1)&(count>>101))|((count*22)&(count>>11.1))-3 % 256;
	var delay = DelayN.ar(bits, 1, 1, 1, bits) / 400;
	var verb = GVerb.ar(bits)/127-1;
	var lowKill = HPF.ar(verb,40).tanh/2;
	var out1 = lowKill.clip(-1, 1) / 2;
	var out2 = CombC.ar(HPF.ar(out1, 1000) * 0.8, 4, [2,3], 10, 1, out1);
	SelectX.ar(Line.ar(0, 1, 1000, doneAction: 2), [out1, out2]) * 0.6;
};
)