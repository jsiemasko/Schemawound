(
{
	//-----Variables-----
	var songClock;
	var sourceGroup, mainOut, fxGroup, fxBus;
	var synthPattern, kickPattern;
	var kPattern_Main, kPattern_Fill_Seq, kPattern_Fill;

	//-----SynthDefs-----
	SynthDef(\SW_Kick, {
		|
			outbus = 0,					waveShape = 1, //1 = Sin, 0 = pulse, mix inbetween
			baseFreq = 60, 				pitchDepth = 40, 	pitchCurve = 0,
			ampCurve = -4, 				amp = 1, 			decay = 1, 		clickLevel = 0.5,
			clickDecayFactor = 0.05, 	clickFreq = 100,	pan = 0
		|
		//Osc
		var vco = EnvGen.ar(Env.perc(0, decay, pitchDepth, pitchCurve));
		var vca = EnvGen.ar(Env.perc(0.005, decay, amp, ampCurve), doneAction: 2);
		var sin = SinOsc.ar(baseFreq + vco) * waveShape;
		var pulse = Pulse.ar(baseFreq + vco) * (1 - waveShape);
		var osc = (sin + pulse) * vca;
		//Click
		var noiseVca = EnvGen.ar(Env.perc(0, decay * clickDecayFactor, amp, ampCurve));
		var noise = WhiteNoise.ar(clickLevel * noiseVca);
		var click = BPF.ar(noise, clickFreq, 1);
		var output = Pan2.ar(osc + click, pan);
		Out.ar(outbus, output);
	}).add;

	SynthDef(\ODL_Synth, {
		|
			amp = 1,									numOfCycles = 100,			sourceOscMaxFreq = 50,
			loLfoMaxFreq = 0.5,		volLfoMaxFreq = 100,		envMinAttack = 0.1,
			envMaxAttack = 30,			envMinDecay = 0.1,			envMaxDecay = 30,
			mainOscFreqMin = 60, 	mainOscFreqMax = 1000,	pitchEnvMul = 2,
			out = 0
		|
		//Local Vars
		var sourceOscFreq, sourceOsc, loLfoFreq, loLfo, volLfoFreq1, volLfoFreq2, volLfoFreq, volLfo;
		var env, envAttack, envDecay, mainOscFreq, mix, pitchEnv;
		//volEnv
		envAttack = Rand(envMinAttack, envMaxAttack);
		envDecay = Rand(envMinDecay, envMaxDecay);
		env = EnvGen.kr(Env.perc(envAttack, envDecay), doneAction: 2) * amp;
		//sourceOsc
		sourceOscFreq = [Rand(0.5, sourceOscMaxFreq), Rand(0.5, sourceOscMaxFreq)];
		sourceOsc = SinOsc.kr(sourceOscFreq, 1.5pi, 0.5, 0.5);
		//loLfo
		loLfoFreq = [Rand(0.1,loLfoMaxFreq), Rand(0.1, loLfoMaxFreq)];
		loLfo = SinOsc.kr(loLfoFreq, 1.5pi, 0.5, 0.5);
		//volLfo
		volLfoFreq1 = (Rand(0.5, volLfoMaxFreq) * sourceOsc) * loLfo;
		volLfoFreq2 = (Rand(0.5, volLfoMaxFreq) * (1 - sourceOsc)) * (1 - loLfo);
		volLfoFreq = [volLfoFreq1, volLfoFreq2];
		volLfo = SinOsc.kr([volLfoFreq1, volLfoFreq2], 1.5pi, 0.5, 0.5);
		//mix
		pitchEnv = EnvGen.kr(Env.perc(envAttack + envDecay, 0, pitchEnvMul, 1)) + 1;
		mainOscFreq = Rand(mainOscFreqMin, mainOscFreqMax);
		mix = Mix.fill(1, {//was numOfCycles
			SinOsc.ar(mainOscFreq  * pitchEnv, 0, 0.1);
		});
		//out
		Out.ar(out, mix * volLfo * env)
	}).add;

	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ODL_VERB DEF -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	SynthDef(\ODL_Verb, {|outbus = 0, inbus, mix = 0.25, room = 0.15, damp = 0.5|
		var input, verb;
		input = In.ar(inbus);
		verb = FreeVerb.ar(input, mix, room, damp);
		Out.ar(outbus, verb!2);
	}).add;

	s.sync;

	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- GROUPS AND BUSSES -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	sourceGroup = Group.new;
	fxGroup = Group.after(sourceGroup);
	mainOut = 0;
	fxBus = Bus.audio(s, 2);
	Synth(\ODL_Verb, [\inbus, fxBus, \outbus, mainOut, \mix, 0.3, \room, 0.75], target: fxGroup);

	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ODL_Synth Patterns -=-=-=-=-=-=-=-=-=-=-=-=-=-
	synthPattern = Pbind(*[
		instrument: 					\ODL_Synth,
		amp: 							0.2,
		sourceOscMaxFreq: 				100,
		out: 							mainOut,
		dur: 							Pseq([1, 0.5, 0.5], inf),
		numOfCycles:					Pseq([1, 10, 100, 300], inf),
		loLfoMaxFreq: 					Pseq([0.5, 0.5, 0.5, 100], inf),
		volLfoMaxFreq: 					Pseq([10, 100, 10, 1000], inf),
		mainOscFreqMin: 				Pseq([50, 500, 500], inf),
		mainOscFreqMax: 				Pseq([200, 2000, 2000], inf),
		pitchEnvMul:					Pseq([Pseq([0], 3), Pseq([0.1], 3), Pseq([0.2], 3)], inf),
		#[envMinDecay, envMaxDecay]:	Pseq([[5.6, 4.2], [0.84, 4.2], [0.84, 4.2]], inf),
		#[envMinAttack, envMaxAttack]:	Pseq([[5.6, 4.2], [0.84, 4.2], [0.84, 4.2]], inf)
	]);

	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ODL_Kick Patterns -=-=-=-=-=-=-=-=-=-=-=-=-=-
	kPattern_Main = Pseq([[1, 5.6], [1, 2.8], [1, 2.8]], 1);
	kPattern_Fill_Seq = Array.newClear(3);
	kPattern_Fill_Seq[0] = Pseq([[1/3, 1.84], [1/3, 0.44], [1/6, 0.44], [1/6, 0.44]], 1);
	kPattern_Fill_Seq[1] = Pseq([[1/3, 1.84], [1/3, 0.44], [1/9, 0.44], [1/9, 0.44], [1/9, 0.44]], 1);
	kPattern_Fill_Seq[2] = Pseq([[1/3, 1.84], [1/3, 0.44], [1/4, 0.7], [1/12, 0.22]], 1);
	kPattern_Fill = Pxrand(kPattern_Fill_Seq, 1);
	kickPattern = Pbind(*[
			instrument: 	\SW_Kick,
			clickFreq: 		Pwhite(50, 100, inf),
			baseFreq:		Pwhite(30, 40, inf),
			waveShape: 		1,
			pitchDepth: 	50,
			clickLevel: 	0.4,
			outbus: 		fxBus,
			amp: 			0.3,
			#[dur, decay]:	Pseq([kPattern_Main, kPattern_Fill], inf)
		]);
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- Score -=-=-=-=-=-=-=-=-=-=-=-=-=-
	songClock = TempoClock(0.48, 0);
	Pdef(\synth).stop; Pdef(\kick).stop;
	Pdef(\synth, synthPattern);
	Pdef(\kick, kickPattern);
	songClock.schedAbs(0, {Pdef(\synth).play(songClock); 4});
	songClock.schedAbs(0, {Pdef(\kick).play(songClock); 4});
}.fork;
)