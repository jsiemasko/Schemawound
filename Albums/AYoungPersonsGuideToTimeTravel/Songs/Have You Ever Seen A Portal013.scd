(
s.prepareForRecord;
{
	//Global stuff
	var t = 80; //Length for a single time increment //80
	var globalSpeed = LFSaw.kr(0.0001).range(0.1, 5) * LFTri.kr(0.000356).range(0.2, 3); //A global oscilator that messes with the master timing

	//Functions
	var trigOsc = {|tFreq = 1, oFreq = 440|
		//This function creates our oscilator, it is made up of a saw at pitch, using a percusive envelope, controlled by the upward pulse of a sine wave.
		//This is added to 2 sines, each an extra octave down, using a perc envelop, controlled by the downward pulse of a sine wave
		//The results of these are filtered by a RLPF using an LFO based off the timing and freq of the oscilators

		//tFreq = timing frequency
		//oFreq = oscilator frequency

		//Create the saw pulse
		var hiTrig = SinOsc.ar(tFreq * globalSpeed) > 0;
		var hiEnv = EnvGen.ar(Env.perc(LFTri.kr([0.012342, 0.015212]).range(0.001, 0.02), LFTri.kr([0.0022222, 0.00333334]).range(0.01, 1)), hiTrig, doneAction: 0);
		var hiOsc = SelectX.ar(LFTri.kr(0.0043201).range(0, 2), [Saw.ar(oFreq), SinOsc.ar(oFreq), Pulse.ar(oFreq)]) * hiEnv;

		//create the sin pulses
		var loTrig = SinOsc.ar(tFreq * globalSpeed) < 0;
		var loEnv = EnvGen.ar(Env.perc(LFTri.kr([0.022342, 0.02212]).range(0.001, 0.02), LFTri.kr([0.0065422, 0.00885334]).range(0.01, 1)), loTrig, doneAction: 0);
		var loOsc = SinOsc.ar(oFreq / 4 ) + SinOsc.ar(oFreq / 2) * loEnv;

		//Add them
		var osc = hiOsc + loOsc;

		//And filter
		var filtLFO = LFTri.kr(tFreq/4 * globalSpeed).range(oFreq/4, oFreq * 2);
		var filt = RLPF.ar(osc, filtLFO, 0.5);
		filt;
	};

	//Envs
	//Sorry- this sucks for readability but I am doing a lot of adjusting to the song length so I am putting all my envelopes and lines in one spot here.
	var loSelectEnv = EnvGen.kr(Env.new([0,   0, 0.5, 0.5, 0], [t, t, t * 6, t]));
	var hiSelectEnv = EnvGen.kr(Env.new([0.1, 1,   1,   1, 0], [t, t, t * 6, t]));
	var noiseAmpEnv = EnvGen.kr(Env.new([0, 0,1/3,1], [t * 4, t, t*2]));
	var noise2AmpEnv = EnvGen.kr(Env.new([0, 0,1], [t * 4, t, t*3])); //Double line is a cheap attempt to have the noise fade in later
	var masterAmpEnv = EnvGen.kr(Env.linen(t/2, t * 6, 60, 0.3), doneAction: 0);
	var masterFilterEnv = EnvGen.kr(Env.linen(t, t * 6, 60, 19800)) + 200;

	//Low Part
	var lo = trigOsc.([2,1], 440) + trigOsc.([1/3, 1/6], 880) + trigOsc.(0.7!2, 220) + trigOsc.((1/2)!2, 660) / 4;
	var loDelayVerb = CombC.ar(GVerb.ar(lo/3), 2, SinOsc.kr(0.001).range(0.1, 2), 1, 1, lo);
	var loSelectLFO = LFTri.kr(0.03, 3).range(0, 1);
	var loSelect = SelectX.ar(loSelectLFO, [lo, loDelayVerb]) / 4;
	var loMaster = loSelect;
	var loMasterFX = CombC.ar(loMaster, 0.5, 0.5, 5, 1, loMaster);
	var loFinal = HPF.ar(SelectX.ar(loSelectEnv, [loMaster, loMasterFX]), 80);

	//High Part
	var hi = trigOsc.([1, 2], 1760) + trigOsc.(0.7!2, 3520) + trigOsc.([1/6, 1/3], 880) + trigOsc.((1/4)!2, 2640) / 4;
	var hiDelayTimeLFO = SinOsc.kr(0.0035).range(0.1, 4);
	var hiDelayVerb = CombC.ar(GVerb.ar(hi/3), 4, hiDelayTimeLFO, 1, 1, hi);
	var hiSelectLFO = LFTri.kr(0.04, 3).range(0, 1);
	var hiSelect = SelectX.ar(hiSelectLFO, [hi, hiDelayVerb]) / 4;
	var hiExtraVerb = GVerb.ar(GVerb.ar(hiSelect, 5, 3), 1, 3) * 0.1;
	var hiMaster = hiExtraVerb;
	var hiMasterFX = CombC.ar(hiMaster, 0.5, LFTri.kr(0.001245).range(0.2, 0.5), 2, 1, hiMaster);
	var hiFinal = SelectX.ar(hiSelectEnv, [hiMaster, hiMasterFX]);//

	//Noise
	var noiseTrig = SinOsc.ar(0.5 * globalSpeed) > 0;
	var noiseEnv = EnvGen.ar(Env.perc(0.01, LFTri.kr([0.0167, 0.0152]).range(0.01, 0.1)), noiseTrig, doneAction: 0);
	var noiseOsc = RLPF.ar(WhiteNoise.ar(), LFTri.ar(0.001).range(6000, 600), 0.5) * noiseEnv * noiseAmpEnv  * LFTri.ar(0.00124).range(0.8, 1);
	var noiseDelay = CombC.ar(HPF.ar(noiseOsc * SinOsc.ar([0.0533, 0.0432]).range(0.3,1), 400), 1.5, [0.5, 0.25] * SinOsc.kr(0.012).range(0.9, 1.1), 5, 1, noiseOsc);
	var noiseVerb = GVerb.ar(noiseDelay, 10, 3, drylevel: LFTri.kr(0.03821).range(0, 0.3)) * 0.4;

	//Noise2
	var noise2Trig = SinOsc.ar(0.25 * globalSpeed) > 0;
	var noise2Env = EnvGen.ar(Env.perc(0.01, LFTri.kr([0.167, 0.152]).range(0.01, 0.5)), noise2Trig, doneAction: 0);
	var noise2Osc = RLPF.ar(WhiteNoise.ar(), LFTri.ar(0.01).range(6000, 600), 0.5) * noise2Env * noise2AmpEnv * LFTri.ar(0.00324).range(0.8, 0.1);
	var noise2Delay = CombC.ar(HPF.ar(noise2Osc * SinOsc.ar([0.0533, 0.0432]).range(0.3,1), 400), 1.5, ([0.5, 0.25]/2) * SinOsc.kr(0.12).range(0.8, 1.2), 5, 1, noise2Osc);
	var noise2Verb = GVerb.ar(noise2Delay, 10, 1, drylevel: LFTri.kr([0.3821, 0.4]).range(0, 0.3)) * 0.35;

	//Master
	var masterSelectLFO = (LFTri.kr(0.007, 1) * 3).clip(-1, 1) * 0.5 + 0.5; //Clipped tri
	var masterOsc = HPF.ar(SelectX.ar(masterSelectLFO, [loFinal, hiFinal]), 55);
	var finalOut = LPF.ar(masterOsc * masterAmpEnv, masterFilterEnv) + (noiseVerb + noise2Verb) * 0.1;

	//Play
	finalOut;

}.play;

 x=0;
 fork{
 	s.record;
 	595.wait;
 	s.stopRecording
 };
)