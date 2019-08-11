(
SynthDef(\cwal, {|t = 1, f = 1, g = 1.4, a=2|
	x = SelectX.ar(SinOsc.ar(t).range(0, 1), [LFSaw.ar([f * 880, (f * 880) + 0.25], 0, 1), LFSaw.ar([f * 440, (f * 440) + 0.5], 0, 1)]);
	x = x * SinOsc.ar([f*300, (f*300) + 0.01], 0, 1);
	x = x * LFPulse.kr([t*1, t*1.5], 0, 0.1, 0.5, 0.5) * LFPulse.kr([t*0.15, t*0.1], 0, 0.1, 0.5, 0.5);
	x = RLPF.ar(x, SinOsc.ar(t/4).range(5000, 60), 0.5);
	x = CombC.ar(x, t, [t*2/5, t/3], 2, 1, x);
	x = GVerb.ar(x, g, 1, add: x);
	x = HPF.ar(x, 100);
	Out.ar(0, x * EnvGen.ar(Env.perc(a, 2-a), 1, doneAction:2) * 0.05);
}).add;
)

(
var aArray = ((1..20))/10;
var tArray = ((1..4));
var fArray = ((1..100))/10;
Pbind(*[
	instrument: \cwal,
	a: Prand(aArray, inf),
	t: Prand(tArray, inf),
	f: Prand(fArray, inf),
	dur: Pseq([
		1/2, 1/2, 1/2, 1/2, 1/2, 1/2, 1/2, 1/2,
		1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4,
		1/3, 1/3, 1/3, 1/3, 1/3, 1/3
	], inf)
]).play;
)