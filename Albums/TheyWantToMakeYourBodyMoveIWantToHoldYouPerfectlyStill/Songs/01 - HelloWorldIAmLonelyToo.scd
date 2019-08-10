/*
"Hello World, I Am Lonely Too" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."

Full album is available for download from http://www.schemawound.com

Blog post about the creation of this track http://schemawound.com/post/31040026304/hello-world-i-am-lonely-too

Code by Jonathan Siemasko (Additional Code by Carl Testa - http://www.carltesta.net )
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
	{
		//Variables
		var mainOut, verbBus, reverb, dust, syn, synOctaveSeq, movements = Array(3);

		//SynthDefs
		SynthDef(\randomAddSynth, {|out = 0, freq = 200, gate = 1, amp = 1, maxDelay = 1, maxAttack = 1, maxDecay = 1, maxHold = 1, maxRelease = 1|
			var numOfHarmonics = 10;
			var harmonics = freq * (2..numOfHarmonics);
			var delayArray = Array.fill(numOfHarmonics, {arg i; Rand.new(0.0, maxDelay)});
			var attackArray = Array.fill(numOfHarmonics, {arg i; Rand.new(0.0, maxAttack)});
			var decayArray = Array.fill(numOfHarmonics, {arg i; Rand.new(0.0, maxDecay)});
			var holdArray = Array.fill(numOfHarmonics, {arg i; Rand.new(0.0, maxHold)});
			var releaseArray = Array.fill(numOfHarmonics, {arg i; Rand.new(0.0, maxRelease)});
			var sines = (SinOsc.ar(freq) * EnvGen.ar(Env.dadsr(Rand(maxDelay), Rand(maxAttack), Rand(maxDecay), Rand(maxHold), maxRelease), gate, doneAction:2)) / numOfHarmonics;
			harmonics.do{|frequency, i| sines = sines + (SinOsc.ar(frequency) * EnvGen.ar(Env.dadsr(delayArray[i], attackArray[i], decayArray[i], holdArray[i], releaseArray[i]), gate) / numOfHarmonics);};
			Out.ar(out, sines!2 * amp);
		}).add;

		SynthDef(\perc, { | out=0, freq=200, width=0.5, density=5, amp=0.1, gate=1 |
			var pan = Rand.new(-1, 1);
			var filterNoise = RLPF.ar(PinkNoise.ar, freq, width / freq);
			var dustNoise = Dust.kr(density) * filterNoise;
			var env = EnvGen.kr(Env.perc, gate, doneAction:2);
			Out.ar(out, Pan2.ar(dustNoise, pan, amp));
		}).add;

		SynthDef(\reverb, { |in=0, out=0, mix=0.5, room=0.5, damp=0.5, pan=0, amp=1 |
			var reverb = FreeVerb.ar(InFeedback.ar(in, 2),mix,room,damp);
			Out.ar(out, Pan2.ar(reverb, pan, amp));
		}).add;

		//Sync
		s.sync;

		//Busses
		mainOut = 0;
		verbBus = Bus.audio(Server.default, 2);
		reverb = Synth.new(\reverb, [\out, mainOut, \in, verbBus, \room, 1, \mix, 0.5, \damp, 0.5]);

		//Patterns
		dust = Pbind(*[
			instrument: \perc,
			density: 1,
			freq: Pseq([Pseq([10,10000], 20), Pseq([10,100,1000,10000], 10)], inf),
			dur: Pwhite(0.1,0.2,inf),
			sustain: 0.1,
			amp: 0.1,
			out: verbBus
		]);

		synOctaveSeq = Pseq([Prand([1,2], 8), Pwrand([1,2,3], [0.25, 0.5, 0.25], 10)], inf);
		syn = Pbind(*[
			instrument:	\randomAddSynth, 
			note: 		Prand([2.5,5.5,3.5,4.3,4.7], inf),
			octave:		synOctaveSeq,
			dur: 		Pwhite(1,3,inf),
			amp:		0.4,
			maxDelay:	2,
			maxAttack:	Pwrand([0.05, 4], [0.25, 0.75], inf), //Short or long attack 
			maxDecay:	10, 
			maxHold:	1,
			maxRelease:	10,
			out:		mainOut
		]);

		//Movements
		movements.add({
			"***Section 1***".postln;
			Pdef(\dust).play;
			Pdef(\dust, dust);							"Slow Crackle".postln;						15.wait; 	// 00:15
			Pbindef(\dust, \density, 100); 				"Speed Up".postln;							15.wait; 	// 00:30
			Pdef(\syn).fadeTime_(10).play;
			Pdef(\syn, syn);							"Syn".postln;								30.wait; 	// 01:00
			Pbindef(\dust, \density, 10); 				
			Pbindef(\syn, \out, verbBus);				"Verb".postln;								30.wait; 	// 01:30
			Pbindef(\dust, \density, 100); 				
			Pbindef(\syn, \out, mainOut);				"No verb".postln;							30.wait;	// 02:00
			Pdef(\dust).stop; Pdef(\syn).stop;			"Full Stop".postln;							7.wait;		// 02:07
		});
		movements.add({
			"***Section 2***".postln;
			Pdef(\dust, dust).play;					
			Pbindef(\dust, \density, 1); 				"Dust Back".postln;							7.wait;		// 00:00
			Pbindef(\dust, \density, 20); 				"Faster".postln;							7.wait;		// 00:07
			Pbindef(\dust, \density, 50); 				"And Faster".postln;						7.wait;		// 00:14
			Pbindef(\dust, \density, 100);
			Pdef(\syn, syn).play;
			Pbindef(\syn, \octave, synOctaveSeq + 1);	"Syn back and Hi".postln;					30.wait;	// 00:44
			Pbindef(\dust, \density, 20);
			Pbindef(\syn, \out, verbBus);				"Hi Verb".postln;							30.wait; 	// 01:14
			Pbindef(\syn, \out, mainOut);				"No verb".postln;							
			Pbindef(\dust, \density, 1); 				"Slow the crackle".postln;
			Pbindef(\syn, \dur, 0.5);					"Regulate Synth Rythum".postln;				30.wait;	// 01:44
			Pbindef(\dust, \density, 2);				"Density: 2".postln;						2.wait;		// 01:46
			Pbindef(\dust, \density, 4);				"Density: 4".postln;						2.wait;		// 01:48
			Pbindef(\dust, \density, 8);				"Density: 8".postln;						2.wait;		// 01:50
			Pbindef(\dust, \density, 16);				"Density: 16".postln;						2.wait;		// 01:52
			Pbindef(\dust, \density, 32);				"Density: 32".postln;						2.wait;		// 01:54
			Pbindef(\dust, \density, 64);				"Density: 64".postln;						2.wait;		// 01:56
			Pbindef(\dust, \density, 128);				"Density: 128".postln;						1.wait;		// 01:57
			Pbindef(\dust, \density, 256);				"Density: 256".postln;						1.wait;		// 01:58
			Pbindef(\dust, \density, 512);				"Density: 512".postln;						1.wait;		// 01:59
			Pbindef(\dust, \density, 1024);				"Density: 1024".postln;						1.wait;		// 02:00
			Pdef(\dust).stop; Pdef(\syn).stop;			"Full Stop".postln;							7.wait;		// 02:07
		});
		movements.add({
			"***Section 3***".postln;
			Pdef(\dust, dust).play; 
			Pdef(\syn, syn).play;			
			Pbindef(\syn, \dur, 0.5);					
			Pbindef(\syn, \octave, synOctaveSeq - 1);
			Pbindef(\syn, \out, verbBus);				"Down 2 octaves and verbed".postln;			60.wait;	// 01:00
			Pbindef(\dust, \density, 10);
			Pbindef(\dust, \freq, Pseq([10,100,1000,5000], inf));
			Pbindef(\dust, \dur, 0.25);					"New noise signature".postln;				45.wait;	// 01:45
			Pbindef(\syn, \dur, Pwhite(1,3,inf),);
			Pbindef(\syn, \octave, synOctaveSeq);
			Pbindef(\dust, \density, 20);				"Denser".postln;							45.wait;	// 02:30
			Pdef(\dust).stop; Pdef(\syn).stop; 			"Ring Out".postln;							10.wait;	// 02:40
		});

		//Sequence
		Pdef(\dust).fadeTime_(10); Pdef(\syn).fadeTime_(10);
		"".postln;"-----Start Sequence-----".postln;
		movements[0].(); // 02:07
		movements[1].(); // 04:14
		movements[2].(); // 06:54
		reverb.free;
		"-----End Sequence-----".postln; "".postln;
	}.fork
)
