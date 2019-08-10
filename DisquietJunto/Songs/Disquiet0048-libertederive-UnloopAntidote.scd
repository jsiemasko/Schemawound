/*
Unloop Antidote [disquiet0048-libertederive]
By Schemawound

All code by Jonathan Siemasko
All sound sampled from the releases mentioned below

NOTE: ~media.disquiet just points to the directory containing the files.

DESCRIPTION:
This Disquiet Junto project was done as a celebration of the efforts of the Three Legs Duck netlabel,
and to support its employment of licenses that allow for derivative works. This track is comprised of
three pieces of music, all originally released on Three Legs Duck: “Unloop Hullaballoo” off The Fleet’s
Lit Up by Alex Charles and Richard Sanderson, “Etude” off Emosphere by !Kung, and “04:54AM” off Four AM
at Dusk Jérôme Poirier. More on the Three Legs Duck netlabel, and the original versions of these tracks,
at http://threelegsduck.weebly.com/.

More on this 48th Disquiet Junto project at: http://disquiet.com/2012/11/29/disquiet0048-libertederive/

More details on the Disquiet Junto at: http://soundcloud.com/groups/disquiet-junto/info/
*/

(
fork{
	//Source Files
	~etude = ~media.disquiet ++ "Emosphere - 03 Etude.wav";
	~four54 = ~media.disquiet ++ "Four AM at Dusk - 02 04-54AM.wav";
	~unloop = ~media.disquiet ++ "The Fleets Lit Up - 04 Unloop Hullaballoo.wav";

	//Cut Samples
	Buffer.freeAll;
	~buffers = ();
	~buffers.squeak = Buffer.read(s, ~etude, 0, 29000);
	~buffers.hornSnip = Buffer.read(s, ~etude, 29000, 6000);
	~buffers.clickClack = Buffer.read(s, ~etude, 5000, 15000);
	~buffers.thumpThump = Buffer.read(s, ~etude, 50000, 15000);
	~buffers.paperNoise = Buffer.read(s, ~etude, 70000, 15000);
	~buffers.steamlet = Buffer.read(s, ~etude, 83000, 15000);
    ~buffers.steamlet2 = Buffer.read(s, ~etude, 105000, 15000);
	~buffers.steamSynth = Buffer.read(s, ~unloop, 105000, 300000);
	~buffers.steamSynth2 = Buffer.read(s, ~unloop, 555000, 300000);
	~buffers.stab = Buffer.read(s, ~unloop, 4005000, 30000);
	~buffers.clickSnare = Buffer.read(s, ~unloop, 9025500, 6000);
	~buffers.lowPluck = Buffer.read(s, ~four54, 1222000, 1400);

	//SynthDef
	SynthDef(\bufPlay2, {|out = 0, bufnum, rateScale = 1, amp = 1|
		var buf = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rateScale, doneAction: 2);
		Out.ar(out, buf * amp);
	}).add;

	SynthDef(\bufADSR2, {|out = 0, gate = 1, bufnum, rateScale = 1, amp = 1, attack = 0.01, decay = 0.3, release = 1|
		var buf = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rateScale);
		var env = EnvGen.ar(Env.adsr(attack, decay, 1, release), gate, doneAction: 2);
		Out.ar(out, buf * env * amp);
	}).add;

	SynthDef(\snareFX, {|out = 0, in, amp = 1|
		var inSig = In.ar(in, 2);
		inSig = inSig + (CombC.ar(inSig, 10, 0.5, 0.5) * 0.8);
		inSig = inSig + (GVerb.ar(inSig, 8, 2) * 0.2);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\hatFX, {|out = 0, in, amp = 1|
		var inSig = In.ar(in, 2);
		inSig = inSig + (CombC.ar(inSig, 10, 0.5, 0.5) * 0.8);
		inSig = GVerb.ar(inSig);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\squeakFX, {|out = 0, in, amp = 1|
		var inSig = In.ar(in, 2);
		inSig = inSig + (CombC.ar(inSig, 10, 0.3, 3) * 0.8);
		inSig = GVerb.ar(inSig);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\kickFX, {|out = 0, in, amp = 1|
		var inSig = In.ar(in, 2);
		inSig = BLowPass4.ar(inSig, 300);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\twinkleFilterFX, {|out = 0, in, amp = 1|
		var inSig = In.ar(in, 2);
		inSig = RHPF.ar(inSig, 1000);
		Out.ar(out, inSig * amp);
	}).add;

	//Sync
	s.sync;

	//Display
	~buffers.do{|buf| buf.postln};

	//FX
	~snareBus = Bus.audio(Server.default, 2);
	~snareFX = Synth(\snareFX, [\out: [0,1], \in: ~snareBus, amp: 0.3]);
	~hatBus = Bus.audio(Server.default, 2);
	~hatFX = Synth(\hatFX, [\out: [0,1], \in: ~hatBus, amp: 0.5]);
	~squeakBus = Bus.audio(Server.default, 2);
	~squeakFX = Synth(\squeakFX, [\out: [0,1], \in: ~squeakBus, amp: 0.5]);
	~kickBus = Bus.audio(Server.default, 2);
	~kickFX = Synth(\kickFX, [\out: [0,1], \in: ~kickBus, amp: 0.5]);
	~twinkleFilterBus = Bus.audio(Server.default, 2);
	~twinkleFilterFX = Synth(\twinkleFilterFX, [\out: ~hatBus, \in: ~twinkleFilterBus, amp: 0.5]);

	//Sequence (8 beat bars)
    ~songClock = TempoClock(1, 0);
	~pat = ();
	~pat.intro = Pbind(*[instrument: \bufADSR2, bufnum: ~buffers.steamSynth2, dur: 8, amp: Pn(1, 1), rateScale: 1, out: ~snareBus]);
	~pat.thump = Ppar([
		Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.thumpThump, dur: 1, amp: Pseq([Pseq([1.5,Rest], 3), Pn(1,2)], 1), rateScale: 0.5]),
		Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.thumpThump, dur: 1, amp: Pseq([1,Rest], 4), rateScale: 0.2]),
	]);
	~pat.clickSnare = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.clickSnare, dur: 1, amp: Pseq([Rest, 0.9], 4), rateScale: 1, out: ~snareBus]);
	~pat.squeakHalf = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.squeak, dur: 1, amp: Pseq([Pn(Rest,4), Pn(1,4)],1), rateScale: 0.5]);
	~pat.squeak = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.squeak, dur: 1, amp: Pn(0.9,8), rateScale: 0.5]);
	~pat.squeakInfinity = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.squeak, dur: 1, amp: Pn(0.9,8), rateScale: 0.5, out: ~squeakBus]);
	~pat.squeakInfinity2 = Pbind(*[instrument: \bufADSR2, bufnum: ~buffers.squeak, dur: 1, sustain: 5, amp: Pn(0.5,8), rateScale: 0.05, out: ~squeakBus]);
	~pat.clickClack = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.clickClack, dur: 1/2, amp: Pseq([Rest, 0.5], 8), rateScale: Pseq([Pn(1, 8), Pn(0.8, 8)])]);
	~pat.paperNoise = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.paperNoise, dur: 1/2, amp: Pseq([0.9], 16), rateScale: 0.7]);
	~pat.steamlet2Half = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.steamlet2, dur: 1/4, amp: Pseq([Pn(Rest, 8), Pn(1, 4), Pn(Rest, 4)], 2), rateScale: 0.5, amp: 0.6]);
	~pat.steamSynth = Pbind(*[instrument: \bufADSR2, bufnum: ~buffers.steamSynth, dur: Pseq([Pn(1,7),Pn(1/4,4)]), sustain: Pkey(\dur), amp: 3.3, rateScale: Pseq([Pn(1,4), Pn(1.5,7)]), amp: 0.6, decay: 0.01]);
	~pat.steamSynth2 = Pbind(*[instrument: \bufADSR2, bufnum: ~buffers.steamSynth2, dur: Pseq([Pn(1,7),Pn(1/4,4)]), sustain: Pkey(\dur), amp: 3.3, rateScale: Pseq([Pn(1,4), Pn(1.5,7)]), amp: 0.6, decay: 0.01]);
	~pat.stab = Pbind(*[instrument: \bufADSR2, bufnum: ~buffers.stab, dur: 1/4, sustain: Pkey(\dur), amp: 0.1, rateScale: Pseq([0.5, Rest, Rest, 0.7], 4), amp: 0.6, decay: 0.01]);
	~pat.hat = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.steamlet, dur: 1/8, amp: Pn(0.15, 64), rateScale: Pseq([10, 20, 30, 20], inf), out: ~hatBus]);
	~pat.hatDoubleTime = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.steamlet, dur: 1/16, amp: Pn(0.15, 128), rateScale: Pseq([10, 10, 10, 10], inf), out: ~hatBus]);
	~pat.pluck = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.lowPluck, dur: 1/8, amp: Pn(0.3, 64), rateScale: Pseq([10, 20, 30, 20], inf), out: ~hatBus]);
	~pat.kickish = Pbind(*[instrument: \bufPlay2, bufnum: ~buffers.lowPluck, dur: 2, amp: Pn(2, 4), rateScale: 0.18, release: 0.25, out: ~kickBus]);
	~pat.twinkleFilter = Pbind(*[instrument: \bufADSR2, bufnum: ~buffers.steamSynth, dur: 1/16, amp: Pseq([0.2, Rest], 32), rateScale: Pseq([4,5,6,7],inf), release: 0.1, out: ~twinkleFilterBus]);

	Pseq([
		~pat.intro,
		Pn(Ppar([~pat.thump, ~pat.paperNoise, ~pat.squeakHalf, ~pat.clickSnare, ~pat.kickish]), 2),
		Pn(Ppar([~pat.thump, ~pat.paperNoise, ~pat.clickClack, ~pat.clickSnare, ~pat.steamlet2Half, ~pat.steamSynth, ~pat.hat, ~pat.kickish]), 2),
		Pn(Ppar([~pat.thump, ~pat.squeakHalf, ~pat.paperNoise, ~pat.clickSnare, ~pat.clickClack, ~pat.steamlet2Half, ~pat.steamSynth, ~pat.hat, ~pat.kickish]), 2),
		Pn(Ppar([~pat.thump, ~pat.paperNoise, ~pat.clickClack, ~pat.clickSnare, ~pat.steamlet2Half, ~pat.steamSynth2, ~pat.hat, ~pat.kickish, ~pat.twinkleFilter]), 2),
		Pn(Ppar([~pat.thump, ~pat.squeakHalf, ~pat.paperNoise, ~pat.clickSnare, ~pat.clickClack, ~pat.steamlet2Half, ~pat.steamSynth2, ~pat.hat, ~pat.kickish, ~pat.twinkleFilter]), 2),
		Pn(Ppar([~pat.thump, ~pat.clickSnare, ~pat.steamSynth, ~pat.hat, ~pat.kickish, ~pat.pluck]), 2),
		Pn(Ppar([~pat.thump, ~pat.paperNoise, ~pat.clickSnare, ~pat.steamSynth, ~pat.kickish, ~pat.hatDoubleTime, ~pat.pluck]), 2),
		Pn(Ppar([~pat.thump, ~pat.paperNoise, ~pat.clickClack, ~pat.clickSnare, ~pat.steamlet2Half, ~pat.steamSynth, ~pat.hat, ~pat.kickish, ~pat.pluck]), 2),
		Pn(Ppar([~pat.thump, ~pat.squeakHalf, ~pat.paperNoise, ~pat.clickSnare, ~pat.clickClack, ~pat.steamlet2Half, ~pat.steamSynth, ~pat.hat, ~pat.kickish, ~pat.pluck]), 2),
		Pn(Ppar([~pat.thump, ~pat.paperNoise, ~pat.clickClack, ~pat.clickSnare, ~pat.steamlet2Half, ~pat.steamSynth2, ~pat.hat, ~pat.kickish, ~pat.pluck, ~pat.twinkleFilter]), 2),
		Pn(Ppar([~pat.thump, ~pat.squeakHalf, ~pat.paperNoise, ~pat.clickSnare, ~pat.clickClack, ~pat.steamlet2Half, ~pat.steamSynth2, ~pat.hat, ~pat.kickish, ~pat.pluck, ~pat.twinkleFilter]), 2),
		Pn(Ppar([~pat.thump, ~pat.squeak]), 2),
		~pat.squeakInfinity,
		Ppar([~pat.squeakInfinity2, ~pat.intro]),
		~pat.squeakInfinity2
	]).play(~songClock);
};
)
