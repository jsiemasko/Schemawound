(
{
	x =
	SinOsc.ar(SinOsc.ar([1.23,1.27]).range(100, 200))
	*
	//SinOsc.ar([127])
	//*
	//SinOsc.ar([670, 677])
	//*
	SinOsc.ar([67, 67.7])
	*
	SinOsc.ar([63, 63.3])
	*
	0.03;
	x = CombC.ar(x, 1, SinOsc.ar([10.1, 10.145]).range(0.009, 0.0092), 10, 1, x);
	//x = x * SinOsc.ar(SinOsc.ar(267).range(1, 30) * [60, 100]);
	//x = GVerb.ar(x, [9,10], 1) + x * 0.1;
	x = CombC.ar(x, 1, SinOsc.ar([10.1, 10.145]).range(SinOsc.ar([0.01, 0.012]).range(0.008, 0.009), 0.0092), 10, 1, x) * 0.3;
	x = SinOsc.ar(SinOsc.ar([0.056, 0.065]).range(80, 160)) * x;
	x = GVerb.ar(x, [5,4] * SinOsc.ar(0.01).range(1, 1.01), 1) + x * 0.3;
	x = GVerb.ar(x, [4,2] * SinOsc.ar(0.02).range(1, 1.1), 1) + x * 0.06;
	x = GVerb.ar(x, [1,1.5] * SinOsc.ar(0.03).range(0.9, 1.2), 1) + x * 0.1;
	x = HPF.ar(x, 40, 1);
	x = CombC.ar(x, 1, [0.5, 0.7], 1, 1, x) * 0.3;
	x = x * SinOsc.ar(1001.1) * SinOsc.ar(1000) * 0.3;
	x = CombC.ar(x, 1, 0.1, 1, 1, x) * 0.1;
}.play;
)