(
SynthDef.new(\foldOsc, {|freq = 440, decay = 1, ampBeforeFold = 1, curve = -4, roomsize = 10, revTime = 3, weirdFreq = 1.001, octAmp = 1|
	var foldOsc = Fold.ar(SinOsc.ar([freq, freq * 1.0001], 0, ampBeforeFold), -0.1, 0.1) * 5;
	var osc = foldOsc + SinOsc.ar(freq, 0, 1) + SinOsc.ar(freq * 2, 0, octAmp) * SinOsc.ar(freq * weirdFreq);
	var verb = GVerb.ar(osc, roomsize, revTime) * 0.5;
	var env = EnvGen.ar(Env.perc(0.01, decay, 0.03, curve), doneAction: 2);
	Out.ar([0, 1], osc + verb * env);
}).add;

SynthDef(\globalVerb, {
	var source;
	source = In.ar(0, 2);
	source = DelayN.ar(source * 0.7, 0.2, 0.2, 1, source);
	source = FreeVerb2.ar(source[0], source[1], 0.2);
	ReplaceOut.ar([0,1], source);
}).add;
)

(
 Pbind(
	\instrument, \foldOsc,
	\freq, Pseq([ 1/1, 3/2, 4/3, 9/8, 16/9, 5/4, 8/5 ] * 220, inf),
	\decay, Pseq([ 2.5, 1, 1, 2, 1, 1, 2, 1 ] * 0.8, inf),
	\ampBeforeFold, Pseq([ 1, 0.5, 0.25, 1.5 ], inf),
	\curve, Pseq([ -4, -6, -8, -6 ], inf),
	\roomsize, Pseq([ 10, 1, 9, 2, 8, 3, 7, 4, 6, 5], inf),
	\revTime, Pseq([ 10, 9, 2, 8, 3, 7, 4, 6, 5], inf),
	\weirdFreq, Pseq([ 1.001, 1.001, 1.001, 2, 2.5, 0.5, 0.5, 0.5], inf),
	\octAmp, Pseq([0.3], inf),
  \dur, Pseq([ 1, 1, 1, 1, 1, 1.5, 1.7, 2] * 0.19, inf),
 ).play;
Synth.tail(s, \globalVerb);
)