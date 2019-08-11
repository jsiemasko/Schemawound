(
{
	//-----Variables-----
	var songClock;
    var sourceGroup, mainOut, delayGroup, delayBus, delaySynth;
	var padPattern, steamPattern;

	//-----Synth Defs-----

	SynthDef(\slowDelay, {|out = 0, in, amp = 0.3|
		var inSig = In.ar(in, 2);
		inSig = DelayC.ar(inSig, 1, 2 + 1/5 + SinOsc.kr(0.01).range(0, 1/5), 0.4, inSig);
		inSig = inSig * SinOsc.ar(600) * SinOsc.ar(600 + SinOsc.kr(0.1).range(0, 54));
		inSig = inSig + CombC.ar(inSig, 1, 0.5, 10, SinOsc.ar(0.05).range(0.3, 0.7));
		inSig = DelayC.ar(inSig, 1, 1, 0.4, inSig);
		inSig = DelayC.ar(inSig, 1, 2 + 1/3 + SinOsc.kr(0.001).range(0, 2/4), 0.4, inSig);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\slowSteam, {|out = 0, amp = 0.5, attack = 0.01, decay = 0.01, freq = 400|
		var env = EnvGen.ar(Env.perc(attack, decay), doneAction:2) * amp;
		var noise = PinkNoise.ar()!2;
		var filter = RLPF.ar(noise, freq + (env * 100), 0.01);
		filter = LPF.ar(filter, 500);
		Out.ar(out, env * filter);
	}).add;

	//-----Sync-----
	Server.default.sync;

	 //-----Groups and Busses-----
    sourceGroup = Group.new;
	delayGroup = Group.after(sourceGroup);
	mainOut = 0;
	delayBus = Bus.audio(s, 2);

	//-----Patterns-----
	songClock = TempoClock(1, 0);

	delaySynth = Synth(\slowDelay, [\in, delayBus, \out, mainOut], target: delayGroup);

	steamPattern = Pbind(*[instrument: \slowSteam,
		dur: 6 + Pwhite(0, 4),
		amp: 0.4,
		freq: Pwhite(450, 800, 24),
		attack: 3,
		decay: 1,
		out: delayBus,
		group: sourceGroup
	]).play;
}.fork
)