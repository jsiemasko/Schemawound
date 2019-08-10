/*
"Fall Asleep Walking" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
/*Fall Asleep Walking*/
	{
		//Song Params
		var seconds = 400;
		var sourceGroup, fxGroup, fxBus, fxBus2, mainOut;
		
		//Synth Defs
		SynthDef(\FAW_LowPad, {|outbus = 0, seconds = 400, pan = -1|
			var env = EnvGen.ar(Env.linen(10, seconds - 20, 10), doneAction:2);
			var lfo = SinOsc.ar(0.01);
			var amp = 0.01;
			var sinFunc = {|i| 
				SinOsc.ar(
					3 * (i + 1), 
					mul: max(0, LFNoise1.kr(1))
				)
			};
			var mix = Mix(Array.fill(150, sinFunc)) ;
			var output = mix * lfo * env * amp;
			Out.ar(outbus, Pan2.ar(output, pan));
		}).add;

		SynthDef(\FAW_MidPad, {|outbus = 0, seconds = 400, pan = 1|
			var env = EnvGen.ar(Env.linen(10, seconds - 20, 10), doneAction:2);
			var lfo = SinOsc.ar(0.027);
			var amp = 0.01;
			var sinFunc = {|i| 
				SinOsc.ar(
					10 * (i + 1), 
					mul: max(0, LFNoise1.kr(1))
				)
			};
			var mix = Mix(Array.fill(100, sinFunc)) ;
			var output = mix * lfo * env *amp;
			Out.ar(outbus, Pan2.ar(output, pan));
		}).add;

		SynthDef(\FAW_FM, {|outbus = 0, seconds = 400|
			var line = Line.ar(0, 0.05, seconds, doneAction:2);
			var lfo = LFTri.ar(0.04) * LFTri.ar(0.5);
			var osc = (SinOsc.ar(50) * Saw.ar(51) * Saw.ar(2200) * SinOsc.ar(350)) / 3;
			var sum = line * osc * lfo;
			var output = sum + CombC.ar(sum, 0.1, 0.1, 10);
			Out.ar(outbus, output!2);
		}).add;

		SynthDef(\FAW_Verb, {|outbus = 0, inbus, room = 0.15,	damp = 0.5|
			var input, wetVerb, verbLFO;
			input = In.ar(inbus, 2);
			verbLFO = LFTri.kr(0.0034).range(0, 1);
			wetVerb = FreeVerb.ar(input, 1, room, damp) * verbLFO;
			Out.ar(outbus, (input + wetVerb) * 0.3);
		}).add;

		//Sync
		Server.default.sync;

		sourceGroup = Group.new;
		fxGroup = Group.after(sourceGroup);
		fxBus = Bus.audio(Server.default, 2);
		fxBus2 = Bus.audio(Server.default, 2);
		mainOut = 0;

		//Play
		Synth(\FAW_LowPad, [\outbus, fxBus, \seconds, seconds], target: sourceGroup);
		Synth(\FAW_MidPad, [\outbus, fxBus, \seconds, seconds], target: sourceGroup);
		Synth(\FAW_Verb, [\inbus, fxBus, \outbus, mainOut], target: fxGroup);

		Synth(\FAW_FM, [\outbus, fxBus2, \seconds, seconds], target: sourceGroup);
		Synth(\FAW_Verb, [\inbus, fxBus2, \outbus, mainOut, \room, 1], target: fxGroup);
	}.fork
)
