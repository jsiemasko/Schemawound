(
SynthDef(\gauntlet, {
	//Arguments
	|
	out = 0, gate = 1, amp = 1,
	o1LFreq = 50, o1RFreq = 47, o2Freq = 70, o3Freq = 1000, o4Freq = 1001,
	o5LSyncLFOSpeed = 0.15, o5RSyncLFOSpeed = 0.17, o5SyncLFOMin = 100, o5SyncLFOMax = 102,
	o5FreqLFOSpeed = 0.023, o5FreqLFOMin = 800, o5FreqLFOMax = 909,
	dryLFO1Freq = 0.1, dryLFO2Freq = 0.07
	|

	//Variables
	var osc1, osc2, osc3, osc4, osc5, osc5Sync, osc5Freq;
	var dryEnv, drySig, dryLFO1, dryLFO2;
	var verb1, verb1RoomLFO, verb2, verb2RoomLFO, verb;
	var combDelayLFO, combDecayLFO, combVerb;
	var postFXEnv, ampScale = 0.3;

	//Osc
	osc1 = SinOsc.ar([o1LFreq, o1RFreq]);
	osc2 = SinOsc.ar(o2Freq);
	osc3 = SinOsc.ar(o3Freq);
	osc4 = SinOsc.ar(o4Freq);
	osc5Sync = LFTri.ar([o5LSyncLFOSpeed, o5RSyncLFOSpeed]).range(o5SyncLFOMin, o5SyncLFOMax);
	osc5Freq = LFTri.ar(o5FreqLFOSpeed).range(o5FreqLFOMin, o5FreqLFOMax);
	osc5 = SyncSaw.ar(osc5Sync, osc5Freq);

	//Dry
	dryEnv = Linen.kr(gate);
	drySig = osc1 * osc2 + osc3 * osc4 * osc5 * dryEnv;
	dryLFO1 = SinOsc.ar(dryLFO1Freq);
	dryLFO2 = SinOsc.ar(dryLFO2Freq);
	drySig = drySig * dryLFO1 * dryLFO2;

	//Verb
	verb1RoomLFO = SinOsc.ar(1).range(0.1, 1);
	verb1 = FreeVerb.ar(drySig, 1, verb1RoomLFO);
	verb2RoomLFO = SinOsc.ar(0.7).range(0.1, 1);
	verb2 = FreeVerb.ar(drySig, 1, verb2RoomLFO);
	verb = verb1 + verb2;

	//Comb
	combDelayLFO = SinOsc.ar([0.0023,0.001]).range([0.01, 0.1],[0.02, 0.2]);
	combDecayLFO = SinOsc.ar(0.007).range(0.1, 10);
	combVerb = CombC.ar(verb, 10, combDelayLFO, combDecayLFO);

	//PostFX
	postFXEnv = Linen.kr(gate, releaseTime: 10, doneAction:2);
	Out.ar(out, drySig + combVerb * ampScale * amp * postFXEnv);
}).add;
)

x = Synth(\gauntlet)

x.release