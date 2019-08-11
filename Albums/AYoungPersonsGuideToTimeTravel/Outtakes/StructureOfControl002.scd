(
{
	x = (20..100) * 1.741 * Line.ar(1.1, 9.01, 300, 1, 0, 2);
	x = [Mix.ar(SinOsc.ar(x)), Mix.ar(SinOsc.ar(x * 1.001))];
	x = Compander.ar(x, x, 0.3, 1, 1/30);
	x = CombC.ar(x, 1, 0.1, 1, 1, x);
	x = Compander.ar(x, x, 0.3, 1, 1/30);
	x = x * Mix.ar(SinOsc.ar(x * 1.992));
	x = Compander.ar(x, x, 0.3, 1, 1/30);
	x = GVerb.ar(x * 0.3, 2.11, LFTri.ar(0.01).range(1, 3), add: x);
	x = x * 0.1;
}.play;
)