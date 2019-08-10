(
{
	var time = 60*7;
	var hex = {|f| 1 - LFTri.ar(f)};
	var line = {|s,e| Line.kr(s,e,time,1,0)};
	var hexes = hex.(line.(17,1647)) * hex.(line.(217,17)) * hex.(67) * hex.([55,55.1]) * 0.05;
	var verb1 = hexes * SinOsc.ar(300) * SinOsc.ar(0.01);
	var verb2 = hexes * SinOsc.ar(SinOsc.ar(0.0334).range(100, 157.7)) * SinOsc.ar(0.008);
	var verb3 = hexes * SinOsc.ar(SinOsc.ar(0.0234).range(200, 257.7)) * SinOsc.ar(0.0043);
	var verb4 = (hexes * 20 * SinOsc.ar(3257.7)).clip(-1,1) * SinOsc.ar(1257.7) * SinOsc.ar(0.023) / 30;
	var combine = verb1 + verb2 + verb3 + CombC.ar(verb4 * SinOsc.ar(Line.ar(300, 10000, 60*7)), 10, 1, 10, 1, verb4);
	combine = combine * EnvGen.ar(Env.linen(0.01, time - 15, 13));
	combine = combine + DelayC.ar(GVerb.ar(combine, [1.7, 1.8], 10, drylevel: 0), 10, Line.kr(0.01, 1, time), 0.5) * 0.1;
	combine = combine + LPF.ar(CombC.ar(combine, 20, Line.kr(1, 0.01, time), 20), LFTri.ar([0.0312, 0.0222]).range(50, 10000)) * 0.1;
	combine = Compander.ar(combine, combine, 0.5, 1, 1/20) * 8;
	combine = Compander.ar(combine, combine, 0.5, 1, 1/20) / 2.5;
	HPF.ar(combine, 55);
}.play
)
