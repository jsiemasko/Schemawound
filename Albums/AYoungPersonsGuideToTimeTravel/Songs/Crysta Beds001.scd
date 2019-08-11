(//*********PREPARE**********
p.pop;
p = ProxySpace.push(s);
~x.play;
~x.fadeTime_(5);
)

(
~x = {
	var t = LFTri.ar(0.01).range(0.01, 1);
	var sqrLFO = LFPulse.ar(t * 0.2).range(1, 3) * LFPulse.ar(t * 0.3).range(4, 5) * LFPulse.ar(t * 0.45).range(1, 4) * LFPulse.ar(t * 0.37).range(1, 3) ** LFTri.ar(0.0018).range(1, 2);
	var sqr = SelectX.ar(LFTri.ar(LFTri.ar([0.0002, 0.0003]).range(0.0013, 10)).range(0, 2), [
		LFSaw.ar(sqrLFO * [1, 1.001]),
		SinOsc.ar(sqrLFO * [1, 1.001]),
		LFPulse.ar(sqrLFO * [1, 1.001])
	]);
	var lpf = RLPF.ar(sqr, SinOsc.ar([0.0343, 0.05]).range(100, 5000)) * 0.5;
	var comb = lpf + CombC.ar(lpf, 2, t * [0.2, 0.5], 10) * 0.1;
	var verb = comb + GVerb.ar(comb, [3, 1], 5, mul: 0.5) * 0.1;
	var hpf = HPF.ar(verb, 50);
	var comp = Compander.ar(hpf, hpf, 0.3, 1, 1/20);
	comp
}
)