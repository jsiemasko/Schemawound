(
fork{
	//-----Variables-----
	var sourceGroup, mainOut, delayGroup, delayBus, delaySynth;

	//-----Synth Defs-----
	SynthDef(\slowDelay, {|out = 0, in, amp = 1|
		var inSig = In.ar(in, 2);
		inSig = DelayC.ar(inSig, 2, 2, 1, inSig);
		inSig = GVerb.ar(inSig, 1, 3, 0.4, 0.4, 15, SinOsc.ar(0.001));
		Out.ar(out, inSig * amp!2);
	}).add;

	SynthDef(\shorelineInsects, {|out = 0, sinAmp = 1, sawAmp = 0, amp = 1, freq1 = 60, freq2 = 60, attack = 0.1, decay = 0.5, sustain = 0.1, release = 0.02|
		var sin = Saw.ar(freq1) * sinAmp;
		var saw = Saw.ar(freq2) * sawAmp;
		var env = EnvGen.ar(Env.linen(attack, decay, sustain, release), doneAction: 2);
		var output = (sin + saw) * env * amp;
		Out.ar(out, output);
	}).add;

	//-----Sync-----
	s.sync;

	//-----Groups and Busses-----
    sourceGroup = Group.new;
	delayGroup = Group.after(sourceGroup);
	mainOut = 0;
	delayBus = Bus.audio(s, 2);

	//-----Patterns-----
	delaySynth = Synth(\slowDelay, [\in, delayBus, \out, mainOut], target: delayGroup);

	p = Pbind(*[
		instrument: \shorelineInsects,
		dur: Pseq([Pseq([Pn(Pwhite(0.01, 0.02), 99), 2], 16), Pseq([Pn(Pwhite(0.1, 0.2), 99), 2], 16)]),
		freq1: Pseq([Pwhite(20, 10e3, 800), Pwhite(60, 600, 800)], inf),
		freq2: Pseq([Pwhite(20, 10e3, 800), Pwhite(60, 600, 800)], inf),
		attack: Pwhite(0.1, 1),
		decay: Pwhite(0.5, 3),
		attack: Pwhite(0.2, 0.5),
		sinAmp: Pwhite(0, 1),
		sawAmp: Pwhite(0, 1),
		out: delayBus,
		group: sourceGroup
	]).play;

}
)

p.stop;