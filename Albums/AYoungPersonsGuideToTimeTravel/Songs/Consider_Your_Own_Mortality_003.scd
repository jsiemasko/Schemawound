(//*********PREPARE**********
//REQUIRES TASCAM_0104.wav - Recording of Ice Storm - Edit recording to eliminate handling noise
p.pop;
~media.fieldRecordings = ~media.skydrive ++ 'Audio/Field Recordings/';
//---------Source Files---------
~source = ~source ? ();
~source.hail = ~media.fieldRecordings ++ "TASCAM_0104.wav";
//---------Cut Samples---------
Buffer.freeAll;
b = b ? ();
b.hail = Buffer.read(s, ~source.hail, 1e5, 6e4);
p = ProxySpace.push(s);
~fx.play;
)

/*

QuNeo Controls
VSliders
0 - storm amp
1 - storm LPF Cutoff
2 - osc amp
3 - osc LPF Cutoff

Pads
0 - storm X Delay Time, Press Amt
1 - osc X Delay Time, Press Amt
*/
~storm.play;
(
//~stormAmp = {q.vSliders[0].loc.kr(lagTime: 10)};
//~stormFinalLPFFreq = {q.vSliders[1].loc.kr(16e3, 60, 0.5)};
//~storm
//~stormBufSinLFOSpeed = {q.lSliders[0].loc.kr(1, 0.001)};
~stormAmp = {1};
~stormFinalLPFFreq = {1e4};
~stormBufSinLFOSpeed = {1};
~storm = {
	var buf = PlayBuf.ar(2, b.hail, BufRateScale.kr(b.hail) * SinOsc.ar(~stormBufSinLFOSpeed).range(0.1, 0.6), loop: 1);
	var fbLFO = SinOsc.ar([0.009, 0.008]).range(1, 10);
	var fb = buf + Fb({|feedback| (buf + feedback * 0.99)}, 10, fbLFO);
	var filterLFO = SinOsc.ar([0.0321, 0.0421]).range(700, 4000) * SinOsc.ar([0.0222,0.01245]).range(0.5, 1);
	var filter = RLPF.ar(fb, filterLFO, 0.7);
	var removeSubSonic = HPF.ar(filter, 30);
	var verbLFO = SinOsc.ar(0.006).range(0.1, 0.5);
	var verb = FreeVerb.ar(removeSubSonic, verbLFO, 3);
	verb = LPF.ar(verb, ~stormFinalLPFFreq.ar);
	verb * 4 * ~stormAmp.ar;
};

~osc = {
	var amp = q.vSliders[2].loc.kr(lagTime:10);
	var finalLPFFreq = q.vSliders[3].loc.kr(7e3, 60, 0.5);
	var sin = SinOsc.ar(SinOsc.ar(0.00345).range(60, 1000)) * SinOsc.ar(SinOsc.ar(0.00445).range(1, 10));
	var fb = sin * 0.1 + Fb({|feedback|
		RLPF.ar(feedback * 2 + sin, SinOsc.ar(0.00233).range(100,2000), 3.8).distort;
	},1, SinOsc.ar([0.001, 0.0009]).range(0.001, 1));
	var removeSubSonic = HPF.ar(fb, 30);
	var verb = GVerb.ar(removeSubSonic, 1, 10) * 0.01;
	var comp1 = Compander.ar(verb, verb, 0.5, 1, 1/20);
	var comp2 = Compander.ar(comp1, verb, 0.5, 1, 1/20);
	comp2 = LPF.ar(comp2, finalLPFFreq);
	comp2 * 1.5 * amp;
};
)

(
~fx = {
	var osc = ~osc.ar;
	var storm = ~storm.ar;
	var sum;
	var oscCombSend = q.pads[1].press.kr(1, lagTime:1);
	var oscCombDelay = q.pads[1].x.kr(0.5, 0.2, 1);
	var stormCombSend = q.pads[0].press.kr(1, lagTime:1);
	var stormCombDelay = q.pads[0].x.kr(0.5, 0.2, 1);
	var stormModWet = q.pads[4].press.kr(lagTime: 0.5);
	var stormModFreq = q.pads[4].press.kr(300, 30, lagTime: 0.5);
	var oscModWet = q.pads[5].press.kr(lagTime: 0.5);
	var oscModFreq = q.pads[5].press.kr(1000, 30, lagTime: 0.5);
	osc = (osc * (1 - oscModWet)) + (osc * SinOsc.ar(oscModFreq) * oscModWet);
	osc = osc + CombC.ar(osc * oscCombSend, 15, oscCombDelay, 15);
	storm = (storm * (1 - stormModWet)) + (storm * SinOsc.ar(stormModFreq) * stormModWet);
	storm = storm + CombC.ar(storm * stormCombSend, 15, stormCombDelay, 15);
	sum = osc + storm;
	Compander.ar(sum, sum, 0.6, 1, 1/20);
};
)