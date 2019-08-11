(
f = {
	var root = 72;
	var scale = [1,3,5,8,10,13] + root;
	var note = scale.choose;
	var freq = note.midicps;
	var attack = 0.01 + 0.1.rand;
	var decay = 0.1 + 0.1.rand;
	var release = 0.3 + 0.3.rand;
	var env = EnvGen.ar(Env.new([0,1,0.5,0], [attack, decay, release]), doneAction: 2);
	var osc = SinOsc.ar(freq, 0, 0.01, 0) * SinOsc.ar(freq / [2,3].choose);
	var comb = CombC.ar(osc * 0.7, 1, 0.1 + 0.3.rand, 1, 1, osc);
	var verb = GVerb.ar(comb, 1 + 15.0.rand, 10, add:comb);
	verb * env!2;
};
fork{
	100.do{
		f.play;
		(0.1 + 0.3.rand).wait;
	};
};
)

