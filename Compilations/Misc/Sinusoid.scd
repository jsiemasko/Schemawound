/*
Schemawound track for Waxen Wing's "Give Me A Sine" compilation.

Compilation Description: All songs written using ONLY sine waves in their creation. All oscillations, modulations, lfo's, envelopes, etc, use only sine waves. No samples or outside source audio were permitted on this releases, unless of course the samples were of pure sine waves. Download includes full 8 panel artwork and extensive liner notes on each piece written by each artist. 

Download the free compilation here: http://waxenwings.bandcamp.com/album/give-me-a-sine

Blog post about the creation of this track: http://schemawound.tumblr.com/post/24520532915/sinusoid
*/

(
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- Sinusoid -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	SynthDef(\Sinusoid, {
		|
			out = 0,					gate = 1,					amp = 1,					freqArrayMult = 1,		
			mod1FreqRLfoFreq = 0.1,		mod1FreqRLfoDepth = 100,	mod1FreqRLfoOffset = 100,	
			mod2Freq = 50,				combDelay = 0.7, 			combDecay = 9,				
			attack = 0.001 				release = 0.5
		|
		//
		var combMaxDelay = 10;
		//Many Sines
		var freqArray = (1..50) * freqArrayMult; 
		var manySines = Mix(SinOsc.ar(freqArray));
		//Mod1
		var mod1FreqL = SinOsc.kr(150, 0, 20);
		var mod1FreqRLfo = SinOsc.kr(mod1FreqRLfoFreq, 0, mod1FreqRLfoDepth, mod1FreqRLfoOffset);
		var mod1FreqR = SinOsc.kr(mod1FreqRLfo, 0, 37);
		var mod1 = SinOsc.ar([mod1FreqL, mod1FreqR]);
		//Mod2
		var mod2 = SinOsc.ar(mod2Freq);
		//Sum and FX
		var sinSum = manySines * mod1 * mod2;
		var comb = sinSum; //+ CombC.ar(sinSum, combMaxDelay, combDelay, combDecay);
		var dist = comb.tanh;
		var env = dist * Linen.kr(gate, attack, amp, release, doneAction: 2);
		//Output
		Out.ar(out, env);
	}).add;

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ELEKTRO KICK -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	SynthDef(\ElektroKick, { 
		|
			out = 0,		gate = 1,		amp = 1,			freqArrayMult = 1,		
			basefreq = 50,	envratio = 3, 	freqdecay = 0.02, 	ampdecay = 0.5
		|
		var fenv = EnvGen.ar(Env([envratio, 1], [freqdecay], \exp), 1) * basefreq;
		var aenv = EnvGen.ar(Env.perc(0.005, ampdecay), 1, doneAction:2);
		var output = SinOsc.ar(fenv, 0.5pi, aenv) * amp;
		Out.ar(out, output!2);
	}).add;

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- VERB -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	SynthDef(\Verb, {
		arg 	out = 0,	in,
			mix = 0.25,	room = 0.15,	damp = 0.5;
	
		var input, verb;
		
		input = In.ar(in);
		verb = FreeVerb.ar(input, mix, room, damp);
		Out.ar(out, verb!2);
	}).add;
)

(
	//Groups and Busses
	var sourceGroup = Group.new;
	var fxGroup = Group.after(~sourceGroup);
	var verbBus = Bus.audio(s, 2);
	var mainOut = 0;
	var verb = Synth.tail(~fxGroup, \Verb, [\in, verbBus, \out, mainOut, \mix, 1, \room, 1]);

	//Song Variables
	var bar = 0.94;
	var qNote = bar/4;
	var eNote = bar/8;

	//Mix
	var finalAmp 	= 0.1;
	var hatAmp 		= 0.6 * finalAmp;
	var bassAmp 	= 0.8 * finalAmp;
	var loToneAmp 	= 0.8 * finalAmp;
	var hiWhineAmp 	= 0.7 * finalAmp;
	var eKickAmp 	= 2.1 * finalAmp;

	//Basic Patterns
	var hat = {|beatsPerMeasure = 9, freqArrayMult = 1|
		Pbind(*[instrument: \Sinusoid, amp: hatAmp, group: sourceGroup,
			dur:				Pseq([bar / beatsPerMeasure], beatsPerMeasure),
			freqArrayMult:		Pxrand((1..12), inf),
			mod2Freq:			Pwhite(60, 6000, inf),
			mod1FreqRLfoFreq:	0.01,
			mod1FreqRLfoDepth:	Pwhite(1000, 3000, inf),
			mod1FreqRLfoOffset:	Pwhite(10, 300, inf),
			release:			Pkey(\dur)
		])
	};
	var bass = {|beatsPerMeasure|
		Pbind(*[instrument: \Sinusoid, amp: bassAmp, group: sourceGroup,
			dur:				Pseq([bar / beatsPerMeasure], beatsPerMeasure),
			mod2Freq:			Pwhite(30, 300, inf),
			mod1FreqRLfoFreq:	Pwhite(0.1, 0.3, inf),
			mod1FreqRLfoDepth:	Pwhite(10, 300, inf),
			mod1FreqRLfoOffset:	Pwhite(10, 300, inf),
			release:			0.001
		])
	};
	var lowtone = {|beatsPerMeasure = 1, attack = 0.001, out = 0|
		Pbind(*[instrument: \Sinusoid, amp: loToneAmp, group: sourceGroup,
			dur:				Pseq([bar / beatsPerMeasure], beatsPerMeasure),
			mod2Freq:			Pwhite(30, 400, inf),
			mod1FreqRLfoFreq:	Pwhite(0.1, 0.3, inf),
			mod1FreqRLfoDepth:	Pwhite(10, 300, inf),
			mod1FreqRLfoOffset:	Pwhite(10, 300, inf),
			attack:				attack,
			release:			Pkey(\dur),
			out:				out
		])
	};
	var lowtoneLong = Pbind(*[instrument: \Sinusoid, amp: loToneAmp, group: sourceGroup,
		dur:				Pseq([bar*8], 1),
		freqArrayMult:		3,
		mod2Freq:			50,
		mod1FreqRLfoFreq:	0.1,
		mod1FreqRLfoDepth:	100,
		mod1FreqRLfoOffset:	100,
		release:			3
	]);
	var hiWhine = {|out = 0|
		Pbind(*[instrument: \Sinusoid, amp: hiWhineAmp, group: sourceGroup,
			dur:				Pseq([bar], 1),
			mod2Freq:			2000,
			mod1FreqRLfoFreq:	Pwhite(0.1, 0.3, inf),
			mod1FreqRLfoDepth:	100,
			mod1FreqRLfoOffset:	100,
			release:			Pkey(\dur),
			out:				out
		])
	};
	var elektroKick = {|beatsPerMeasure = 1|
		Pbind(*[instrument: \ElektroKick, amp: eKickAmp, group: sourceGroup,
			dur:				Pseq([bar / beatsPerMeasure], beatsPerMeasure),
			basefreq:			Pwhite(70, 75),
			ampdecay:			2,
			envratio:			1,
			freqdecay:			1
		])
	};

	//8 Bar Patterns
	var loTonePat = [
		Pn(lowtone.(1), 8),					//loTone pattern 0 - 8 bars
		Pn(lowtone.(1, bar), 8),				//loTone pattern 1 - 8 bars
		Pn(lowtone.(1, out:verbBus), 8)	//loTone pattern 2 - 8 bars
	];

	var hiWhinePat = [
		Pn(hiWhine.(verbBus), 8),	//hiWhine pattern 0 - 8 bars
		Pn(hiWhine.(mainOut), 8)	//hiWhine pattern 0 - 8 bars
	];

	var hatPat = [
		Pseq([//hat pattern 0 - 8 bars
			Pn(hat.(9), 7),		hat.(11)
		]),	
		Pseq([//hat pattern 1 - 8 bars
			hat.(8), 			hat.(9,(1..12)),	hat.(9), 			hat.(7,(1..12)),
			hat.(6,(1..12)),	hat.(12,(1..12)),	hat.(6,(1..12)),	hat.(24,(1..12))
		]),
		Pseq([//hat pattern 2 - 8 bars
			hat.(8), 			hat.(3),			hat.(6),			hat.(9),
			hat.(8,(1..12)),	hat.(3,(1..12)),	hat.(6,(1..12)),	hat.(12,(1..12))
		]),
		Pseq([//hat pattern 3 - 8 bars
			hat.(9), 			hat.(8),			hat.(7),			hat.(8),
			hat.(9,(1..12)),	hat.(8,(1..12)),	hat.(16,(1..12)),	hat.(32,(1..12))
		])
	];

	var bassPat = [
		Pn(bass.(3), 8),	//bass pattern 0 - 8 bars
		Pseq([				//bass pattern 1 - 8 bars
			bass.(4),	Pn(bass.(3),3)
		], 2),
		Pseq([				//bass pattern 2 - 8 bars
			bass.(4),	Pn(bass.(3),3),		
			bass.(4),	Pn(bass.(3),2), 	bass.(5)
		]),
		Pseq([				//bass pattern 3 - 8 bars
			bass.(4), 	bass.(3.5), 		bass.(3),		bass.(3.5),
			bass.(4), 	bass.(3), 			bass.(6),		bass.(7)
		]),
		Pseq([				//bass pattern 4 - 8 bars
			bass.(4),	Pn(bass.(3), 7)
		]),
	];

	var kickPat = [
		Pn(elektroKick.(1), 8),		//kick pattern 0 - 8 bars
		Pn(elektroKick.(2), 8)	//kick pattern 1 - 8 bars
	];

	var drop = [
		Pn(Ppar([lowtone.(1), hiWhine.(verbBus)]), 2),										//Drop Pattern 0 - 2 bars
		Pn(Ppar([lowtone.(1), hiWhine.(verbBus), elektroKick.(1)]), 2),						//Drop Pattern 1 - 2 bars
		Pn(Ppar([lowtone.(1), hiWhine.(verbBus), elektroKick.(1), hiWhine.(mainOut)]), 2),	//Drop Pattern 2 - 2 bars
	];

	//Song
	var song = Pseq([
								loTonePat[0], 				
		Ppar([	bassPat[0], 	loTonePat[0]																				]), 
		Ppar([	bassPat[0], 	loTonePat[0],					hatPat[0]													]), 
		drop[0], 
		Ppar([	bassPat[0], 	loTonePat[0], 								kickPat[0]										]), 
		Ppar([	bassPat[0], 	loTonePat[0],					hatPat[0], 	kickPat[0]										]),
		drop[1],
		Ppar([	bassPat[1], 									hatPat[2], 	kickPat[0]										]), 
		Ppar([	bassPat[2], 	loTonePat[0], 					hatPat[2], 	kickPat[0]										]),
		drop[2],
		Ppar([	bassPat[1], 									hatPat[2], 	kickPat[0],		hiWhinePat[0]					]), 
		Ppar([	bassPat[2], 	loTonePat[0], 					hatPat[2], 	kickPat[0]										]),
		Ppar([	bassPat[1], 					loTonePat[2],	hatPat[2], 	kickPat[0],		hiWhinePat[0],	hiWhinePat[1]	]), 
		Ppar([	bassPat[2], 	loTonePat[0],	loTonePat[2],	hatPat[2], 	kickPat[0],						hiWhinePat[1]	]),
		drop[0],
								loTonePat[2]
	]);

	song.play;
)
