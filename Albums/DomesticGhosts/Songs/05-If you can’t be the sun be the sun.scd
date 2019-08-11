(
{
	//-----Variables-----
	var songClock;
    var sourceGroup, mainOut, fxGroup, fxBus, fxSynth;
	var padPattern;

	//-----Synth Defs-----
    SynthDef(\slowPad, {
		|
		    out = 0, gate = 1, freq = 400, amp = 0.1,
		    sawLfoAmount = 0.1, sawLfoLFreq = 0.1, sawLfoRFreq = 0.25, sawAmp = 0.5,
		    squareLfoDepth = 0.4, squareLfoFreq = 0.034, squareDetune = -0.3, squareAmp = 0.5,
		    combFreqMult = 0.0003, combDecay = 0.5,
		    filterMult = 4, filterAttack = 7, filterDecay = 5, filterSustain = 0.5, filterRelease = 3, filterRQ = 1, filterAmp = 0.5,
		    ampAttack = 2, ampDecay = 4, ampSustain = 0.5, ampRelease = 0.8
		|
	    //Saws
	    var sawLfo = SinOsc.kr([sawLfoLFreq, sawLfoRFreq]).range(sawLfoAmount * -1, sawLfoAmount);
	    var saws = (Saw.ar(freq) + Saw.ar((freq.cpsmidi + sawLfo).midicps)) * sawAmp;
	    //Square
		var defaultSquarePW = 0.5;
	    var squareLfo = SinOsc.kr(squareLfoFreq).range(defaultSquarePW - squareLfoDepth, defaultSquarePW + squareLfoDepth);
	    var square = PulseDPW.ar(freq + squareDetune, squareLfo) * squareAmp;
	    //Comb
		var combMaxDecay = 1;
		var comb = CombC.ar(saws + square, combMaxDecay, combFreqMult * freq, combDecay) + (saws + square);
		var comb2 = CombC.ar(comb, combMaxDecay, (combFreqMult / 3) * freq, combDecay / 2) + comb;
		//Filter
		var filterEnv = EnvGen.kr(Env.adsr(filterAttack, filterDecay, filterSustain, filterRelease), gate) * filterMult;
		var filter = BLowPass.ar(comb2, freq * filterEnv, filterRQ) * filterAmp;
		//Out
		var ampEnv = EnvGen.kr(Env.adsr(ampAttack, ampDecay, ampSustain, ampRelease), gate, doneAction:2) * amp;
		Out.ar(out, filter * ampEnv);
    }).add;

	SynthDef(\slowFX, {|out = 0, in, amp = 0.3|
		var inSig = In.ar(in, 2);
		inSig = GVerb.ar(inSig);
		inSig = Compander.ar(inSig, inSig, 0.5, 1, 1/16);
		inSig = HPF.ar(inSig, 100) * SinOsc.ar(80);
		Out.ar(out, inSig * amp);
	}).add;

	//-----Sync-----
	Server.default.sync;

	 //-----Groups and Busses-----
    sourceGroup = Group.new;
	fxGroup = Group.after(sourceGroup);
    mainOut = 0;
    fxBus = Bus.audio(s, 2);

	//-----Patterns-----
	songClock = TempoClock(1, 0);

	fxSynth = Synth(\slowFX, [\in, fxBus, \out, mainOut], target: fxGroup);

    padPattern = Pbind(*[instrument: \slowPad,
        degree: Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf),
		sawLfoAmount: Pseq([Pn(0.4, 8), Pn(20, 8)], inf),
        dur: 4,
		sustain: Pkey(\dur) * 1.5,
        amp: 0.5,
		octave: Pseq([Pn(4, 16), Pn(5, 16), Pn(6, 16), Pn(5, 16)], 1),
		out: fxBus,
		group: sourceGroup
	]).play(songClock);

}.fork
)