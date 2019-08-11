(//*********PREPARE**********
//REQUIRES TASCAM_0125.wav - Recording of water drips
p.pop;
~media.fieldRecordings = ~media.skydrive ++ 'Audio/Field Recordings/';
//---------Source Files---------
~source = ~source ? ();
~source.hail = ~media.fieldRecordings ++ "TASCAM_0125.wav";
//---------Cut Samples---------
Buffer.freeAll;
b = b ? ();
b.hail = Buffer.read(s, ~source.hail, 1e5, 6e5);
p = ProxySpace.push(s);
~fx.play;
)

(
~storm = {
	var buf = PlayBuf.ar(2, b.hail, BufRateScale.kr(b.hail) * 0.6 * SinOsc.ar(0.1).range(0.1, 0.6), loop: 1);
	var fbLFO = SinOsc.ar([0.009, 0.008]).range(1, 10);
	var fb = buf + Fb({|feedback| (buf + feedback * 0.99)}, 10, fbLFO);
	var filterLFO = SinOsc.ar([0.0321, 0.0421]).range(700, 4000) * SinOsc.ar([0.0222,0.01245]).range(0.5, 1);
	var filter = RLPF.ar(fb, filterLFO, 0.7);
	var removeSubSonic = HPF.ar(filter, 30);
	var verbLFO = SinOsc.ar(0.6).range(0, 1);
	var verb = removeSubSonic + DelayC.ar(FreeVerb.ar(removeSubSonic, verbLFO, 3), 2, SinOsc.ar(0.012).range(0.1, 2));
	verb = LPF.ar(verb, 1e4);
	verb * 4;
};

)
(
~fx = {
	var storm = ~storm.ar;
	var stormCombSend = 1;
	var stormCombDelay = 3;
	var stormModWet = 0.5;
	var stormModFreq = 300;
	storm = (storm * (1 - stormModWet)) + (storm * SinOsc.ar(stormModFreq) * stormModWet);
	storm = storm + CombC.ar(storm * stormCombSend, 15, stormCombDelay, 15);
	storm = Compander.ar(storm, storm, 0.6, 1, 1/20);
	storm = Compander.ar(storm, storm, 0.6, 1, 1/20);
	storm = storm * 0.5;
	storm
};
)