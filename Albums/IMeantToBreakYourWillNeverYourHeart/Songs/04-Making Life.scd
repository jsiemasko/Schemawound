//Making Life
(
play{
	var pulse = Impulse.ar(9e3);
	var count = PulseCount.ar(pulse);
	var bits = ((count*2.7)&(count>>9.99))|((count*1.1)&(count>>11))|((count*22)&(count>>11.1))-3 % 256;
	var verb = GVerb.ar(bits)/127-1;
	//var delay = verb + CombC.ar(verb, 0.2, 0.2, 10, LFTri.ar(0.01).range(0, 1)) / 2;
	var lowKill = HPF.ar(verb,20).tanh/2;
	lowKill.clip(-1, 1) / 2;
};
)