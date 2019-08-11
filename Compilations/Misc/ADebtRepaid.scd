(
play{
	var pulse = Impulse.ar(LFTri.ar([0.0047, 0.0037]).range(1e3, 9e3) * Line.ar(1, 0, 500));
	var count = PulseCount.ar(pulse);
	var bits = SelectX.ar(SinOsc.ar(0.1).range(0, 2), [
		  ((count*1)&(count>>[6,8]))|((count*57)&(count>>4))-3%128
		, ((count*1)&(count>>[6,8]))|((count*57)&(count>>4))-3%256
		, ((count*1)&(count>>[6,8]))|((count*57)&(count>>4))-3%512
	]);
	var verbScale = bits/127-1;
	var lowKill = HPF.ar(verbScale,20);
	var verb = GVerb.ar((lowKill.tanh / 2).clip(-1, 1) / 30, SinOsc.ar(0.00023).range(0.1, 3.7), SinOsc.ar(0.34).range(0.1, 3), 0.5, 0.5, 60);
	var verb2 = CombC.ar(verb * 0.7 , 1, 0.01, 1, 1, verb);
	var verb3 = CombC.ar(verb2 * 0.7 , 1, [0.5, 0.7], 10, 1, verb2) * EnvGen.ar(Env.linen(0.01, 400, 1));
	var comp = HPF.ar(SelectX.ar(EnvGen.ar(Env([0, 0, 1], [200, 200])), [verb3, GVerb.ar(verb3 * SinOsc.ar([90, 93]) * SinOsc.ar(127))]), 30);
	var comp2 = SelectX.ar(EnvGen.ar(Env([0, 0, 1], [300, 100])), [comp, GVerb.ar(comp, 10, 10, 0.5, 0.5, 15, 0.1) * 0.1]);
	var comp3 = Compander.ar(comp2, comp2, 0.8, 1, 1/30) * 0.5;
	var comp4 = Compander.ar(comp3, comp3, 0.7, 1, 1/30) * 0.7;
	var comp5 = Compander.ar(comp4, comp4, 0.7, 1, 1/30) * 0.6;
	Compander.ar(comp4, comp4, 0.7, 1, 0.001) * 0.3;
}
)

s.scope
s.makeWindow