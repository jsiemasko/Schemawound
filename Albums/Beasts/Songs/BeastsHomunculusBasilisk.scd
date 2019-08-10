/*
"BEASTS(Homunculus-Basilisk)" By Schemawound
Released by Dystimbria (http://Dystimbria.cc)

All code by Jonathan Siemasko
Contains samples from:
	"Llais-saL" by Alan Morse Davies
	"A Strange Seed" by C. Reider
	"Swamp Monsters, Secret Prisons" by Cinchel
	"A Brief Compendium of Silence" by Phillip Wilkerson
Artwork by Jonathan Siemasko
Source Photo by Dan Newkirk (http://newkirk.biz)

DESCRIPTION:
This track is created almost entirely from 9 snippets taken 

from the 4 tracks listed.  These are 
resequenced, repitched and run through a number of effects 

using Supercollider.  

WEBSITE:
http://www.schemawound.com
*/

(
fork{
	~media.dystimbria = ~media.skydrive ++ 'Dystimbria/';

	//---------Source Files---------
	~source = ~source ? ();
	~source.strangeSeed = ~media.dystimbria ++ "01-C_Reider-AStrangeSeed.wav";
	~source.llais = ~media.dystimbria ++ "06-Alan_Morse_Davies-Llais-saL.wav";
	~source.secretPrisons = ~media.dystimbria ++ "10-Cinchel-SwampMonsters-SecretPrisons.wav";
	~source.silence = ~media.dystimbria ++ "13-PhillipWilkerson-A_Brief_Compendium_of_Silence.wav";

	//---------Cut Samples---------
	Buffer.freeAll;
	~buffers = ~buffers ? ();
	~buffers.steamLo = Buffer.read(s, ~source.llais, 455000, 80000);
	~buffers.steamHi = Buffer.read(s, ~source.llais, 1605000, 80000);
	~buffers.tuvan = Buffer.read(s, ~source.strangeSeed, 2000000, 400000);
	~buffers.tuvan2 = Buffer.read(s, ~source.strangeSeed, 3000000, 400000);
	~buffers.secrets = Buffer.read(s, ~source.secretPrisons, 2000000, 40000);
	~buffers.marbles = Buffer.read(s, ~source.secretPrisons, 10000, 40000);
	~buffers.wobblySilence = Buffer.read(s, ~source.silence, 848000, 200000);
	~buffers.toneRise = Buffer.read(s, ~source.silence, 1608000, 200000);
	~buffers.buzz = Buffer.read(s, ~source.silence, 4608000, 14000);

	//---------SynthDef---------
	SynthDef(\bufPlay2, {|out = 0, bufnum, rateScale = 1, amp = 1|
		var buf = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rateScale, doneAction: 2);
		Out.ar(out, buf * amp);
	}).add;

	SynthDef(\bufADSR2, {|out = 0, gate = 1, bufnum, rateScale = 1, amp = 1, attack = 0.01, decay = 0.3, release = 1|
		var buf = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rateScale);
		var env = EnvGen.ar(Env.adsr(attack, decay, 1, release), gate, doneAction: 2);
		Out.ar(out, buf * env * amp);
	}).add;

	SynthDef(\distFiltDelay, {|out = 0, in, amp = 1, wet = 0.5, tempo = 1, cutoff = 500, leftDelay = 3, rightDelay = 5|
		var inSig = In.ar(in, 2);
		tempo = tempo * [leftDelay, rightDelay] / 2;
		inSig = inSig + (HPF.ar(DelayN.ar(inSig, tempo, tempo), cutoff) * wet);
		inSig = inSig + (GVerb.ar(inSig, 30, 6) * 0.1);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\WailSpectre, {|out = 0, freq = 400, amp = 0.25, gate = 1, release = 1|
		var oscLFO = SinOsc.ar([0.03, 0.05]).range(0, 10);
		var saw = Saw.ar(freq);
		var puretone = SinOsc.ar(freq);
		var offsettone = SinOsc.ar(freq + (freq / 10 ) + oscLFO);
		var osc =  puretone * offsettone;
		var osc2 = osc * saw;
		var cutoffLFO = SinOsc.ar(0.4).range(100, 200);
		var filt = RLPF.ar(osc2, cutoffLFO, 0.1);
		var dist = CrossoverDistortion.ar(filt) * 0.5;
		var osc3 = (osc * 0.3) + osc2 + dist;
		var output = ((puretone * 0.3) + osc3) * Linen.kr(gate, release: release, doneAction: 2) * amp;
		Out.ar(out, output);
    }).add;

	SynthDef(\crush, {|out = 0, in, amp = 1|
		var dec = Decimator.ar(In.ar(in, 2), 16000, 8);
		Out.ar(out, RHPF.ar(dec + (CrossoverDistortion.ar(dec) * 0.1), 200) * amp)
	}).add;

	SynthDef(\crushNoHPF, {|out = 0, in, amp = 1|
		var dec = Decimator.ar(In.ar(in, 2), 16000, 10);
		Out.ar(out, dec + (CrossoverDistortion.ar(dec) * 0.1) * amp)
	}).add;

	SynthDef(\crushNoHPF2, {|out = 0, in, amp = 1|
		var dec = Decimator.ar(In.ar(in, 2), SinOsc.kr(0.17).range(2000, 8000), 10);
		Out.ar(out, dec + (CrossoverDistortion.ar(dec) * 0.1) * amp)
	}).add;

	SynthDef(\distort, { arg out=0, sr = 441000, bits = 16, pregain=40, amp=0.2, gate=1;
		var in = In.ar(out, 2);
		var gain = (in * pregain).distort;
		var deci = Decimator.ar(gain, sr, bits);
		var clip = deci.clip(-0.9, 0.9);
		var env = Linen.kr(gate, 0.05, 1, 0.1, 2);
		XOut.ar(out, env, clip * amp);
	}).add;

	//---------Clock---------
	~songClock = TempoClock(1.0, 0);

	//---------Groups---------
	~group = ~group ? ();
	~group.homunculus = Group.new;
	~group.basilisk = Group.after(~group.homunculus);
    ~group.fx = Group.after(~group.basilisk);

	//---------Busses---------
	~delayBus = Bus.audio(Server.default, 2);
	~delayFX = Synth(\distFiltDelay, [\out: [0,1], \in: ~delayBus, amp: 1, tempo: ~songClock.tempo, cutoff: 250], target: ~group.fx);
	CmdPeriod.doOnce{~delayBus.free};

	~straightDelayBus = Bus.audio(Server.default, 2);
	~straightDelayFX = Synth(\distFiltDelay, [\out: [0,1], \in: ~straightDelayBus, amp: 1, tempo: ~songClock.tempo, cutoff: 250, leftDelay: 8, rightDelay: 8], target: ~group.fx);
	CmdPeriod.doOnce{~straightDelayBus.free};

	~doubleDelayBus = Bus.audio(Server.default, 2);
	~doubleDelayFX = Synth(\distFiltDelay, [\out: ~delayBus, \in: ~doubleDelayBus, amp: 0.7, tempo: ~songClock.tempo, cutoff: 0], target: ~group.fx);
	CmdPeriod.doOnce{~doubleDelayBus.free};

	~crushBus = Bus.audio(Server.default, 2);
	~crushFX = Synth(\crush, [\out: ~doubleDelayBus, \in: ~crushBus, amp: 0.5], target: ~group.fx);

	~crushBusNoHPF = Bus.audio(Server.default, 2);
	~crushFXNoHPF = Synth(\crushNoHPF, [\out: ~doubleDelayBus, \in: ~crushBusNoHPF, amp: 0.37], target: ~group.fx);

	~crushBusNoHPF2 = Bus.audio(Server.default, 2);
	~crushFXNoHPF2 = Synth(\crushNoHPF2, [\out: ~doubleDelayBus, \in: ~crushBusNoHPF2, amp: 0.1], target: ~group.fx);

	//---------Homunculus Patterns---------
	~homunculus = ();

	//---------Tuvan---------
	~homunculus.tuvanSkip1 = Pbind(*[bufnum: ~buffers.tuvan, dur: 1, sustain: Pkey(\dur), rateScale: Pn(1, 12), amp: 0.15, decay: 0.2, out: Pseq([~doubleDelayBus, Pn(~delayBus, 3)], inf)]); //12
	~homunculus.tuvanSkip2 = Pbind(*[bufnum: ~buffers.tuvan2, dur: 1, sustain: Pkey(\dur), rateScale: Pn(1, 12), amp: 0.15, decay: 0.2, out: Pseq([~doubleDelayBus, Pn(~delayBus, 3)], inf)]); //12
		~homunculus.tuvan1 = Ptpar([
		00.0, ~homunculus.tuvanSkip1,
		16.0, ~homunculus.tuvanSkip1,
		32.0, ~homunculus.tuvanSkip1, 32.5, ~homunculus.tuvanSkip1,
		48.0, ~homunculus.tuvanSkip1, 48.5, ~homunculus.tuvanSkip1
	]); //64
	~homunculus.tuvan2 = Ptpar([
		00.0, ~homunculus.tuvanSkip2,
		16.0, ~homunculus.tuvanSkip2,
		32.0, ~homunculus.tuvanSkip2, 32.5, ~homunculus.tuvanSkip2,
		48.0, ~homunculus.tuvanSkip2, 48.5, ~homunculus.tuvanSkip2,
	]); //64
	~homunculus.tuvan = Ptpar([00.0, ~homunculus.tuvan1, 64.0, ~homunculus.tuvan2]); //128

	//---------Percussion---------
	~homunculus.kick = Pbind(*[bufnum: Pseq((~buffers.steamLo!8).add(~buffers.steamHi!8).flatten, inf), dur: 1, sustain: Pkey(\dur), rateScale: Pseq([0.05].add(Rest!3).flatten, 16), amp: Pseq((0.4!8).add(0.3!8).flatten, inf), decay: 0.1, out: ~delayBus]); //64
	~homunculus.marbles = Pbind(*[bufnum: ~buffers.marbles, dur: 1/2, sustain: Pkey(\dur), rateScale: Pn(0.5, 8), amp: 1.5, decay: 0.5, out: ~delayBus]);
	~homunculus.percLoop64 = Ptpar([
		00.0, ~homunculus.kick,
		28.0, ~homunculus.marbles,
		60.0, ~homunculus.marbles
	]); //64
	~homunculus.percLoop128 = Ptpar([
		00.0, ~homunculus.percLoop64,
		64.0, ~homunculus.percLoop64
	]); //128

	//---------Wobble Synth---------
	~homunculus.wobbleSkip = Pbind(*[bufnum: ~buffers.wobblySilence, dur: 1/3, sustain: Pkey(\dur), rateScale: Pseq([1,1,1,0.98]), amp: 1, decay: 0.1, out: ~delayBus]);
	~homunculus.wobbleSkip64 = Ptpar([
		00.0, ~homunculus.wobbleSkip, 02.0, ~homunculus.wobbleSkip,
		08.0, ~homunculus.wobbleSkip, 10.0, ~homunculus.wobbleSkip,
		16.0, ~homunculus.wobbleSkip, 18.0, ~homunculus.wobbleSkip,
		24.0, ~homunculus.wobbleSkip, 26.0, ~homunculus.wobbleSkip,
	]); //64
	~homunculus.wobbleSkip128 = Ptpar([
		00.0, ~homunculus.wobbleSkip64,
		64.0, ~homunculus.wobbleSkip64
	]); //128
	~homunculus.wobbleSyn = Ppar([~homunculus.mainLoop, ~homunculus.wobbleSkip128]); //128

	//---------ToneSkip---------
	~homunculus.toneRiseSkip = Pbind(*[bufnum: ~buffers.toneRise, dur: 1/2, sustain: Pkey(\dur), rateScale: Pseq([Pn(1, 8), Pseq([1, Rest], 4)], 2), amp: 1, decay: 0.001, out: ~straightDelayBus]);
	~homunculus.toneRiseSkip = Pn(~homunculus.toneRiseSkip, 8); //128

	//---------Buzz---------
	~homunculus.buzz = Pbind(*[bufnum: ~buffers.buzz, dur: 1/8, sustain: Pkey(\dur)/5, rateScale: Pn(0.6, 8), amp: 0.5, release: 0.3, out: ~crushBus]);
	~homunculus.buzz16 = Ptpar([00.0, ~homunculus.buzz, 08.0, ~homunculus.buzz]);
	~homunculus.buzz128 = Ptpar([
		00.0, ~homunculus.buzz16,
		32.0, ~homunculus.buzz16,
		64.0, ~homunculus.buzz16,
		96.0, ~homunculus.buzz16
	]);

	//---------Snare---------
	~homunculus.snare = Pbind(*[bufNum: ~buffers.steamHi, dur: Pseq([4, 1, 3], 16), sustain: Pkey(\dur), rateScale: Pseq([Rest, 0.3, Rest], inf), amp: 0.45, decay: 0.01, out: ~delayBus]); //128

	//---------Secret---------
	~homunculus.secret = Pbind(*[bufnum: ~buffers.secrets, dur: Pseq(((1!3).add(1/2!2)!2).add(2).flatten.flatten), sustain: Pkey(\dur), rateScale: Pseq(([1, 0.5, 1, 1.5, 1.5]!2).add(Rest).flatten), amp: Pseq([1, 1, 1, 0.6, 0.6], inf), decay: 0.01, out: ~delayBus]);

	//---------Homunculus---------
	~homunculus.song =	Pseq([
		~homunculus.secret,
		Ppar([~homunculus.percLoop128, ~homunculus.tuvan]),
		Ppar([~homunculus.percLoop128, ~homunculus.tuvan, ~homunculus.wobbleSyn]),
		Ppar([~homunculus.snare, ~homunculus.percLoop128, ~homunculus.tuvan, ~homunculus.toneRiseSkip, ~homunculus.buzz128]),
		Ppar([~homunculus.snare, ~homunculus.percLoop128, ~homunculus.tuvan, ~homunculus.wobbleSyn, ~homunculus.toneRiseSkip, ~homunculus.buzz128]),
	]);
	~homunculus.song = Pchain(~homunculus.song, (group: ~group.homunculus));

	//---------basilisk Patterns---------
	~basilisk = ();

	~basilisk.wobble = Pbind(*[bufnum: ~buffers.wobblySilence, dur: 2/3, sustain: Pkey(\dur), rateScale: Pseq([0.5,0.5,0.98,0.5,0.5,0.5,0.98],4), amp: 1, decay: 0.1, out: ~delayBus]);
	~basilisk.kick = Pbind(*[bufnum: ~buffers.steamLo, dur: Pseq([2/3*3, 2/3*4], 4), sustain: 0.5, rateScale: 0.08, amp: 0.2, release: 0.1, out: ~crushBusNoHPF]); //64
	~basilisk.hat = Pbind(*[bufnum: ~buffers.steamLo, dur: Pseq([Pn(2/3/8, 8), Pn(Rest(2/3/8), 8)], 7), sustain: 0.5, rateScale: Pseq((128!16).add(64!16).flatten, inf) * Pwhite(0.8, 1.2), amp: Pwhite(0.02, 0.03), attack: 0.001, release: 0.001,  out: ~crushBusNoHPF]); //64
	~basilisk.singleKick = Pbind(*[bufnum: ~buffers.steamLo, dur: Pn(2/3*14, 2), sustain: 0.5, rateScale: 0.08, amp: 0.2, release: 0.1, out: ~crushBusNoHPF]); //64
	~basilisk.kickTone = Pbind(*[bufnum: ~buffers.steamLo, dur: Pseq([2/3*3, 2/3*4], 4), sustain: 0.5, rateScale: 0.8, amp: 0.1, release: 0.1, out: ~crushBusNoHPF]); //64
	~basilisk.kickTone2 = Pbind(*[bufnum: ~buffers.steamLo, dur: Pseq([2/3*3/2, 2/3*3/2, 2/3*4/2, 2/3*4/2], 4), sustain: 0.5, rateScale: Pseq([Rest, 6, Rest, 4], inf), amp: 0.1, release: 0.1, out: ~crushBusNoHPF2]); //64
	~basilisk.wail = Pbind(*[instrument: \WailSpectre, dur: Pseq([2/3] * 7, 4), sustain: Pseq([Pn(Pkey(\dur) / 3, 3), Pkey(\dur) / 10], inf), amp: 0.015, freq: Pseq([800, 800, 800, 900], inf), release: 0.1, out: ~delayBus]); //64
	~basilisk.distortPattern = Pmono(\distort, \dur, Pn(2/3, 7*4), \pregain, 1, \sr, Pseq([3e3, 2e3, 1e3, 4e3, 2e3, 1e3, 2e3], inf), \bits, Pseq([16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 8, 10, 12], inf), \amp, 0.7, \group, ~group.fx, \addAction, 1);

	~basilisk.song = Pseq([
		Pseq([
			Ppar([~basilisk.wobble, ~basilisk.kick]),
			Ppar([~basilisk.wobble, ~basilisk.singleKick, ~basilisk.kickTone]),
			Ppar([~basilisk.wobble, ~basilisk.kick, ~basilisk.kickTone2]),
			Ppar([~basilisk.wobble, ~basilisk.singleKick, ~basilisk.kickTone, ~basilisk.kickTone2]),
			Ppar([~basilisk.wobble, ~basilisk.kick, ~basilisk.wail, ~basilisk.hat]),
			Ppar([~basilisk.wobble, ~basilisk.singleKick, ~basilisk.kickTone, ~basilisk.wail, ~basilisk.hat]),
			Ppar([~basilisk.wobble, ~basilisk.kick, ~basilisk.kickTone2, ~basilisk.wail, ~basilisk.hat]),
			Ppar([~basilisk.wobble, ~basilisk.singleKick, ~basilisk.kickTone, ~basilisk.kickTone2, ~basilisk.wail, ~basilisk.hat]),
		], 2),
		Ppar([~basilisk.distortPattern, ~basilisk.wobble, ~basilisk.kick, ~basilisk.kickTone2, ~basilisk.wail, ~basilisk.hat]),
		Ppar([~basilisk.distortPattern, ~basilisk.singleKick, ~basilisk.kickTone, ~basilisk.kickTone2, ~basilisk.wail, ~basilisk.hat]),
		Ppar([~basilisk.distortPattern])
	]);
	~basilisk.song = Pchain(~basilisk.song, (group: ~group.basilisk));

	//---------Sync---------
	s.sync;

	//---------Display---------
	5.do{''.postln};

	'-----SOURCE-----'.postln; ~source.dopostln;
	'-----GROUPS-----'.postln; ~group.dopostln;
	'-----BUFFERS-----'.postln; ~buffers.dopostln;
	'-----HOMONCULUS-----'.postln; ~homunculus.dopostln;
	'-----BASILISK-----'.postln; ~basilisk.dopostln;

	//---------Song---------
	~fullSong = Pseq([
		~homunculus.song,
		~basilisk.song
	]);

	6.wait; //Something pops then echos when I first start up.  Delay to let it finish.
	~fullSong.play(~songClock, protoEvent: (instrument: \bufADSR2)); //13:37
};
)
