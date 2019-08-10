/*
Telegraph Incantation [disquiet0050-morsebeat]
By Schemawound

All code by Jonathan Siemasko

Blog post about this track: http://schemawound.com/post/38127291200/telegraph-incantation-disquiet0050-morsebeat

DESCRIPTION:
This week’s project explores invokes Morse Code for its rhythmic content. The instructions are as follows: Select a word or phrase. 
Encode that word or phrase by the Morse method. Record a rhythmic foundation in which the dash is represented by a long beat and the 
dot by a brief one. Use that rhythmic foundation as a loop for the length of your track, at the speed you desire — speed can vary over 
the length of the recording. Record accompanying drone/melodic material that takes the underlying rhythm as its compositional foundation.

More on this 50th Disquiet Junto project at: http://disquiet.com/2012/12/13/disquiet0050-morsebeat/

More details on the Disquiet Junto at: http://soundcloud.com/groups/disquiet-junto/info/
*/

(
fork{
	var phrase = "LYRA";
	var fxSynth, group, bus, mainOut, patBass, patBassLoop, patMorse, patMorseDeci, patMorseDeciLoop, patMorseFast, patKick, patPad, patKickAndPad, patMainLoop, patFullSong;
	var morse;  //Holds the main object used by the song
	var songClock = TempoClock(11);
	var createMorse = {|inString, spaceBetweenLetters = 3, spaceBetweenWords = 7|
		/* Function to take a string and convert it an event that can create morse code duration streams. Handles a-z, A-Z and 0-9.
		   Parameters allow you to adjust the space between letters and words. These parameters default to international morse code as shown on http://en.wikipedia.org/wiki/Morse_code
		   NOTE: outEvent.wordSpace must be equal to or greater than outEvent.letterSpace. */

		var charToMorse;
		var outEvent = (message: inString, code: "", letterSpace: "", wordSpace: "");

		//Fill letterSpace and wordspace per number specified in input args.
		//outEvent.wordSpace reduced by the size of outEvent.letterSpace to account for that will occur before it.
		(spaceBetweenLetters - 1).do{outEvent.letterSpace = outEvent.letterSpace ++ " "};
		(spaceBetweenWords - spaceBetweenLetters).do{outEvent.wordSpace = outEvent.wordSpace ++ " "};

		//Function to convert a single character to morse code
		charToMorse = {|inChar|
			switch(inChar,
				$A, {".-"},		$B, {"-..."},	$C, {"-.-."},	$D, {"-.."},	$E, {"."},	    $F, {"..-."},  $G, {"--."},    $H, {"...."},
				$I, {".."},		$J, {".---"},	$K, {"-.-"},	$L, {".-.."},   $M, {"--"},		$N, {"-."},	   $O, {"---"},	   $P, {".--."},
				$Q, {"--.-"},	$R, {".-."},    $S, {"..."},	$T, {"-"},		$U, {"..-"},	$V, {"...-"},  $W, {".--"},    $X, {"-..-"},
				$Y, {"-.--"},	$Z, {"--.."},   $1, {".----"},	$2, {"..---"},	$3, {"...--"},	$4, {"....-"}, $5, {"....."},  $6, {"-...."},
				$7, {"--..."},	$8, {"---.."},	$9, {"----."},	$0, {"-----"},  $ , {outEvent.wordSpace}
			);
		};

		//Take the input string, convert to uppercase and convert one letter at a time.  Add outEvent.letterSpace between letters
		inString.toUpper.do{|char, i|
			var isFinalChar = (i != (inString.size - 1));
			var isWordSpace = (char != $ );
			outEvent.code = outEvent.code ++ charToMorse.(char);
			//Include outEvent.letterSpace after each character except outEvent.wordSpaces and the final letter.
			if(isFinalChar && isWordSpace, {outEvent.code = outEvent.code + outEvent.letterSpace});
		};

		//Create a Prout that duration streams can be generated from
		outEvent.prout = Prout{|in|
			inf.do{|i|
				var char = outEvent.code.wrapAt(i);
				switch(char,
					$., {in = 1.embedInStream(in)},
					$-, {in = 3.embedInStream(in)},
					$ , {in = Rest(1).embedInStream(in)}
				);
			};
		};

		//Function to create a new duration stream
		outEvent.durStream = {outEvent.prout.asStream;};

		//Count number of events in the stream
		outEvent.numEvents = outEvent.code.size;

		//Calculate the number of beats in the stream
		outEvent.numBeats = 0;
		outEvent.code.do{|val,i|
			var char = outEvent.code[i];
				switch(char,
					$., {outEvent.numBeats = outEvent.numBeats + 1},
					$-, {outEvent.numBeats = outEvent.numBeats + 3},
					$ , {outEvent.numBeats = outEvent.numBeats + 1}
				);
			};


		//Return event
		outEvent;
	};

	//--------------------SynthDef--------------------
	SynthDef(\morseTone, {|out = 0, freq = 400, gate = 1, pan = 0, wobbleDepth = 10, wobbleRate = 3, amp = 1, attack = 0.03, decay = 0.03, release = 0.03|
		var env = EnvGen.ar(Env.adsr(attack, decay, 1, release), gate, doneAction: 2);
		var wobble = SinOsc.ar(wobbleRate).range(0, wobbleDepth);
		var osc = SinOsc.ar(freq) * SinOsc.ar(freq + 1 + wobble);
		var output = Pan2.ar(osc * env, pan, amp);
		Out.ar(out, output);
	}).add;

	SynthDef(\AEKick, {|
		out = 0, amp = 1,
		attack = 0.01, decay = 0.7, curve = 3,
		pEnvMul = 20, pEnvAdd = 40, pEnvAtk = 0.01, pEnvDecay = 0.25, pEnvCurve = -4
		fmAmp = 1, fmpEnvMul = 100, fmpEnvAdd = 10, fmpEnvAtk = 0.001, fmpEnvDecay = 0.10, fmpEnvCurve = -2
		|
		var ampEvn = EnvGen.ar(Env.perc(attack, decay, amp, curve), doneAction: 2);
		var pitchEnv = EnvGen.kr(Env.perc(pEnvAtk, pEnvDecay, pEnvMul, pEnvCurve)) + pEnvAdd;
		var fmpitchEnv = EnvGen.kr(Env.perc(fmpEnvAtk, fmpEnvDecay, fmpEnvMul, fmpEnvCurve)) + fmpEnvAdd;
		var fmMod = SinOsc.ar(fmpitchEnv) * fmAmp;
		var sin = SinOsc.ar(pitchEnv) * fmMod;
		sin = sin + (LFNoise0.ar(10000) * EnvGen.ar(Env.perc(0.01, 0.02, 0.001, 0)));
		Out.ar(out, sin * ampEvn!2);
	}).add;

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

	SynthDef(\slowFX, {|out = 0, in, amp = 0.1|
		var inSig = In.ar(in, 2);
		inSig = GVerb.ar(inSig);
		inSig = Compander.ar(inSig, inSig, 0.5, 1, 1/16);
		inSig = HPF.ar(inSig, 100) * SinOsc.ar(80);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\verb, {|out = 0, in, amp = 0.3, roomsize = 10, revtime = 3|
		var inSig = In.ar(in, 2);
		inSig = inSig + (GVerb.ar(inSig, roomsize, revtime) * 0.3);
		inSig = Compander.ar(inSig, inSig, 0.5, 1, 1/16);
		Out.ar(out, inSig * amp);
	}).add;

	SynthDef(\deciVerb, {|out = 0, in, amp = 0.2|
		var inSig = In.ar(in, 2);
		inSig = Decimator.ar(inSig, 5e3, 16);
		inSig = Compander.ar(inSig, inSig, 0.5, 1, 1/16);
		Out.ar(out, inSig * amp);
	}).add;

	//--------------------Sync--------------------
	s.sync;

	//--------------------Create Morse--------------------
	morse = createMorse.(phrase);

	//-----Groups and Busses-----
	group = ();
	group.synths = Group.new;
    group.fx = Group.after(group.synths);
    mainOut = 0;
	bus = ();
	bus.modVerb = Bus.audio(s, 2);
	bus.smallVerb = Bus.audio(s, 2);
	bus.verb = Bus.audio(s, 2);
	bus.deciVerb = Bus.audio(s, 2);

	//--------------------Cleanup--------------------
	CmdPeriod.doOnce{
		bus.modVerb.free;
		bus.verb.free;
		bus.deciVerb.free;
		bus.smallVerb.free;
	};

	//--------------------FX Synths--------------------
	fxSynth = ();
	fxSynth.deciVerb = Synth(\deciVerb, [\in, bus.deciVerb, \out, mainOut], target: group.fx);
	fxSynth.modVerb = Synth(\slowFX, [\in, bus.modVerb, \out, mainOut], target: group.fx);
	fxSynth.smallVerb = Synth(\verb, [\in, bus.smallVerb, \out, mainOut, \roomsize, 10, \revtime, 1.5], target: group.fx);
	fxSynth.verb = Synth(\verb, [\in, bus.verb, \out, mainOut], target: group.fx);

	//--------------------Pattern--------------------
	patBass = Pbind(*[instrument: \morseTone, freq: 60, wobbleDepth: 0, dur: morse.durStream * 0.25, amp: 0.3, pan: Pseq((1!morse.numEvents).add(-1!morse.numEvents).flatten, 4), out: bus.deciVerb ]);
	patMorse = Pbind(*[instrument: \morseTone, wobbleDepth: Pwhite(3.0, 10.0), dur: morse.durStream, amp: 0.3, pan: Pseq((1!morse.numEvents).add(-1!morse.numEvents).flatten, 2), out: bus.smallVerb ]);
	patMorseFast = Pbind(*[instrument: \morseTone, freq: 600, wobbleDepth: Pwhite(3.0, 10.0), dur: morse.durStream * 0.5, amp: 0.2, pan: Pseq((1!morse.numEvents).add(-1!morse.numEvents).flatten, 4), out: bus.smallVerb]);
	patMorseDeci = Pbind(*[instrument: \morseTone, wobbleDepth: Pwhite(3.0, 10.0), dur: morse.durStream, amp: 0.2, pan: Pseq((1!morse.numEvents).add(-1!morse.numEvents).flatten, 2), out: bus.deciVerb ]);
	patKick = Pbind(*[instrument: \AEKick, dur: Pseq((morse.numBeats/2!2).add(Rest(morse.numBeats/2)!2).flatten, 4), amp: 0.2, decay: 0.3, out: bus.verb]);
	patPad = Pbind(*[instrument: \slowPad, dur: Pn(morse.numBeats * 4, 2), amp: 0.7, out: bus.modVerb]);
	patKickAndPad = Ppar([patKick, patPad]);
	patMainLoop = Ptpar([
		000.0, patMorse,
		000.0, patKick,
		000.0, patPad,
		morse.numBeats * 4, patMorse,
		morse.numBeats * 4, patMorseFast
	]);
	patBassLoop = Ptpar([
		000.0, patBass,
		morse.numBeats * 4, patBass
	]);
	patMorseDeciLoop = Ptpar([
		000.0, patMorseDeci,
		morse.numBeats * 4, patMorseDeci
	]);
	patFullSong = Ptpar([
		000.0, patKickAndPad,
		morse.numBeats * 8, patMainLoop,
		morse.numBeats * 16, patMainLoop, morse.numBeats * 16, patBassLoop,
		morse.numBeats * 24, patMainLoop, morse.numBeats * 24, patBassLoop, morse.numBeats * 24, patMorseDeciLoop,
		morse.numBeats * 32, patPad, morse.numBeats * 32, patMorseDeciLoop
	]);

	//--------------------Output--------------------
	'-----MORSE-----'.postln; morse.dopostln;
	'-----GROUPS-----'.postln; group.dopostln;
	'-----BUSSES-----'.postln; bus.dopostln;
	'-----FX SYNTHS-----'.postln; fxSynth.dopostln;

	//--------------------Play--------------------
	patFullSong.play(songClock)
}
)
