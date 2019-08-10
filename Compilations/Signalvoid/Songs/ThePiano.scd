/* 
Schemawound track from the SIGNALVOID compilation.
SIGNALVOID is a noise compilation. Participants were asked to create up to three tracks, each of exactly one minute in length, with no gaps of silence at the beginning or end. Download the free compilation here: http://archive.org/details/SignalvoidMp3 or http://archive.org/details/SignalvoidFlac
Physical copies are available here http://signalvoid.bandcamp.com/merch/signalvoid-2

Blog post about the creation of this track http://schemawound.tumblr.com/post/29070261257/signalvoid-3-the-piano
*/

(
	SynthDef(\ThePiano, {
		|
			sampleHoldFreq = 1,			saw0Freq = 0.1,			saw0DepthMin = 1,		saw0DepthMax = 1000,
			saw1FreqLeft = 10,			saw1FreqRight = 10.92, 
			saw2FreqLeft = 9, 			saw2FreqRight = 11.59,
			saw5FreqLeft = 0.1,			saw5FreqRight = 0.125,	saw5DepthMin = 1,		saw5DepthMax = 60
			i_comb0MaxDelay = 1,		comb0Delay = 0.001,		comb0Decay = 0.1,
			i_comb1MaxDelay = 1,		comb1Delay = 0.0125,	comb1Decay = 0.1,
			verb0Mix		= 1.0,		verb0Room = 0.7,
			verb1Mix		= 1.0,		verb1Room = 1.0,
			amp = 1
		|

		//Local Vars
		var sampleAndHold;
		var saw = Array.new;
		var comb = Array.new;
		var verb = Array.new;
		var comp;
		
		//Saws
		/* -----------
			Saw Index:
			0: Mod for Saw 3 (Sample and Hold mod)
			1: Dual Channel Saw
			2: Dual Channel Saw
			3: Saw with freq modified by a S&H
			4: 1 * 2 * 3
			5: Mod for saw 6
			6: 5 * 4, used for reverb
		-------------*/
		sampleAndHold = Latch.ar(WhiteNoise.ar, Impulse.ar(sampleHoldFreq));
		saw = saw.add(SinOsc.ar(saw0Freq).range(saw0DepthMin, saw0DepthMax));
		saw = saw.add(LFSaw.ar([saw1FreqLeft, saw1FreqRight]));
		saw = saw.add(LFSaw.ar([saw2FreqLeft, saw2FreqRight]));
		saw = saw.add(LFSaw.ar(sampleAndHold * saw[0]));
		saw = saw.add(saw[1] * saw[2] * saw[3]);
		saw = saw.add(LFSaw.kr([saw5FreqLeft, saw5FreqRight]).range(saw5DepthMin, saw5DepthMax));
		saw = saw.add(LFSaw.ar(saw [5] * saw[4]));
		
		//Combs
		comb = comb.add(CombC.ar(saw[4],	i_comb0MaxDelay, 	comb0Delay, 	comb0Decay));
		comb = comb.add(CombC.ar(comb[0],	i_comb1MaxDelay, 	comb1Delay, 	comb1Decay));
		
		//Verbs
		verb = verb.add(FreeVerb.ar(comb[1], 			verb0Mix,	verb0Room));
		verb = verb.add(FreeVerb.ar(verb[0] * saw[6],	verb1Mix,	verb1Room));
		
		//Out
		Out.ar(0, verb[1] * (amp * 0.2));
	}).add;
)

(
	x = Synth(\ThePiano, [
		\saw0ModFreq, 		0.1,	\saw0ModDepthMin,	1,		\saw0ModDepthMax,	1000,	
		\saw1FreqLeft,		10,		\saw1FreqRight,		10.92,
		\saw2FreqLeft,		9,		\saw2FreqRight,		11.59,
		\saw5FreqLeft,		0.1,	\saw5FreqRight,		0.125,	\saw5DepthMin,		1,		\saw5DepthMax,		60,
		\i_comb0MaxDelay,	0.001,	\comb0Delay,		0.001,	\comb0Decay,		0.1,
		\i_comb1MaxDelay,	0.0125,	\comb1Delay,		0.0125,	\comb1Decay,		0.1,
		\verb0Mix,			1.0,	\verb0Room,			0.7,	
		\verb1Mix,			1.0,	\verb1Room,			1.0,
		\amp,				1
	]);
)
