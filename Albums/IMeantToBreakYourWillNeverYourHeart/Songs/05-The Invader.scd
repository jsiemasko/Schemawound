(
play{
	var time = 300;
	var line = Line.ar(9e3, 6e3, time);
	var pulse = Impulse.ar([line, line+100]);
	var count = PulseCount.ar(pulse);
	var bits = ((count*12.7)&(count>>900.99))|((count*16.1)&(count>>1001))|((count*220)&(count>>101.1))-1 % 256;
	var bass = GVerb.ar(LFTri.ar(LFTri.ar(0.01).range(60, 70) * LFTri.ar([0.015, 0.017]).range(1, 1.4)));
	var lowKill = HPF.ar(bits, 20).tanh/2;
	var bitwise = (bass * 0.17) + lowKill.clip(-1, 1) / 2 * EnvGen.ar(Env.linen(0.01, time, 4));
	var merge = SelectX.ar(Line.ar(0, 10, time), [
		bitwise,
		GVerb.ar(bitwise, 10, 3, drylevel: 0),
		CombC.ar(GVerb.ar(bitwise, 10, 5, drylevel: 0.3), 0.2, 0.2, 3, 1, bitwise),
		GVerb.ar(bitwise, 10, 3, drylevel: 0),
		bitwise,
		GVerb.ar(bitwise, 10, 5, drylevel: 0),
		CombC.ar(GVerb.ar(bitwise, 10, 5, drylevel: 0.1), 0.2, 0.2, 3, 1, bitwise),
		GVerb.ar(bitwise, 10, 5, drylevel: 0),
		bitwise,
		GVerb.ar(bitwise, 10, 10, drylevel: 0),
		CombC.ar(GVerb.ar(bitwise, 10, 10, drylevel: 0), 0.2, 0.2, 10, 1, bitwise)
	], 1) * 0.1;
	var merge2 = HPF.ar(merge, 40);
	var comp1 = Compander.ar(merge2, merge2, 0.2, 1, 1/30);
	var comp2 = Compander.ar(comp1, comp1, 0.3, 1, 1/30);
	Compander.ar(comp2, comp2, 0.5, 1, 1/30) * 0.3;
}
)