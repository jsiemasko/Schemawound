(//*********PREPARE**********
p.pop;
~media.fieldRecordings = ~media.skydrive ++ 'Audio/Field Recordings/';
//---------Source Files---------
~source = ~source ? ();
~source.hail = ~media.dropbox ++ 'Audio/TASCAM_0128S12.wav';
//---------Cut Samples---------
Buffer.freeAll;
b = b ? ();
b.hail = Buffer.read(s, ~source.hail, 3e7, 6e5);
p = ProxySpace.push(s);
~storm.play.fadeTime_(10);
)

(
~storm = {
	var bufRaw = PlayBuf.ar(2, b.hail, BufRateScale.kr(b.hail) *  SinOsc.ar(0.11).range(0.1, 1), loop: 1);
	var buf = bufRaw * SinOsc.ar(SinOsc.ar(0.0027).range(100, 1000));
	var fbLFO = SinOsc.ar([0.009, 0.008]).range(1, 10);
	var fb = buf + Fb({|feedback| (buf + feedback * 0.99)}, 10, fbLFO);
	var filterLFO = SinOsc.ar([0.0321, 0.0421]).range(700, 4000) * SinOsc.ar([0.0222,0.01245]).range(0.5, 1);
	var filter = RLPF.ar(fb, filterLFO, 0.7);
	var removeSubSonic = HPF.ar(filter, 30);
	var verbLFO = SinOsc.ar(0.6).range(0, 1);
	var verb = removeSubSonic + DelayC.ar(FreeVerb.ar(removeSubSonic, verbLFO, 3), 2, SinOsc.ar(0.012).range(0.1, 2));
	verb = LPF.ar(verb, 1e4);
	verb = verb + (GVerb.ar(verb, 5, 1) * SinOsc.ar(0.14));
	verb = verb + CombC.ar(verb, 2, 0.3, 10, SinOsc.ar(0.043).range(0, 1));
	verb = verb + (bufRaw * SinOsc.ar(0.07128).range(0, 1));
	verb = (EnvGen.ar(Env.linen(0.01, 240, 30)) * verb);
	verb = verb * 0.2;
};
)