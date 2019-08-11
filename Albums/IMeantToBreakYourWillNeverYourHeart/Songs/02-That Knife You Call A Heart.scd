//That Knife You Call A Heart
(
play{
	var pulse = Impulse.ar(9e3);
	var count = PulseCount.ar(pulse);
	var bits = ((count*12.7)&(count>>90.99))|((count*1.1)&(count>>101))|((count*22)&(count>>11.1))-3 % 256;
	var verb = GVerb.ar(bits)/127-1;
	var lowKill = HPF.ar(verb,20).tanh/2;
	lowKill.clip(-1, 1) / 2;
};
)