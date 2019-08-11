(
SynthDef(\wn, {|decay = 0.5|
	var env = EnvGen.ar(Env.perc(0, decay, 1, -4));
	var noise = WhiteNoise.ar * env;
	noise = RLPF.ar(noise, env * 6000 + 100, 0.9);
	Out.ar([0, 1], noise);
}).add;

SynthDef(\gn, {|decay = 0.5|
	var env = EnvGen.ar(Env.perc(0, decay, 1, -4));
	var noise = GrayNoise.ar * env;
	noise = RLPF.ar(noise, env * 6000 + 100, 0.9);
	Out.ar([0, 1], noise);
}).add;

SynthDef(\pn, {|decay = 0.5|
	var env = EnvGen.ar(Env.perc(0, decay, 1, -4));
	var noise = PinkNoise.ar * env;
	noise = RLPF.ar(noise, env * 6000 + 100, 0.9);
	Out.ar([0, 1], noise);
}).add;

SynthDef(\bn, {|decay = 0.5|
	var env = EnvGen.ar(Env.perc(0, decay, 1, -4));
	var noise = BrownNoise.ar * env;
	noise = RLPF.ar(noise, env * 6000 + 100, 0.9);
	Out.ar([0, 1], noise);
}).add;

SynthDef(\fx, {
	var in = In.ar([0, 1]);
	var verb = (in * 0.1) + (GVerb.ar(in) * 0.1);
	var delay = verb + CombC.ar(verb, 1, 0.5, 0.5);
	ReplaceOut.ar([0, 1], delay);
}).add;
)

(
Pbind(*[
	instrument: Prand([\wn, \gn, \pn, \bn], inf),
	decay: Prand([0.1, 0.5, 1, 2], inf),
	dur: 0.2
]).play;

Synth.new(\fx);
)
