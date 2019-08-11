(
play({
	var t = 90;  //Total length of piece
	var pulse, tri, readingRainbow; //Used to make reading rainbow 1
	var theHorns; //The Horns
	var rainbowHorns;
	var aMess;

	//Reading Rainbow 1 & 2
	pulse = LFPulse.kr([0.3,0.2] * SinOsc.ar(0.012).range(0.9, 1), 0, 0.3, 200, 200); //freq for readingRainbow
	tri = LFTri.kr([0.1, 0.4]).range(0,1); //width for readingRainbow
	readingRainbow = VarSaw.ar(pulse, 0, tri, 0.1);
	//readingRainbow = SelectX.ar(SinOsc.ar(0.012).range(0, 1), [readingRainbow, readingRainbow * pulse * tri]) * 0.01;
	readingRainbow = SelectX.ar(SinOsc.ar([0.03544, 0.02332]).range(0, 1), [readingRainbow, CombC.ar(readingRainbow, 0.5, [0.1, 0.2] * SinOsc.kr(0.0455).range(0.7, 1), 0.5, 0.7, readingRainbow)]);
	readingRainbow = SelectX.ar(SinOsc.ar([0.0574, 0.04732]).range(0, 1), [readingRainbow, CombC.ar(readingRainbow, 1, [1, 0.7] * SinOsc.kr(0.0875).range(0.7, 1), 1, 0.7, readingRainbow)]) * 0.7;

	//The Horns - Formed from Reading Rainbow 1 & 2
	theHorns = CombC.ar(readingRainbow, 10, [3, 5] / SinOsc.kr([0.072, 0.054]).range(3, 4), SinOsc.kr(0.0792).range(3, 5), 1, readingRainbow);
	theHorns = GVerb.ar(theHorns, 10, 1).clip(-0.5, 0.5) * 0.1;
	theHorns = SelectX.ar(LFTri.kr([0.0043, 0.0037]).range(0, 1), [theHorns, GVerb.ar(theHorns, 7, 10)]) * 0.1;
	theHorns = SelectX.ar(LFTri.kr([0.0057, 0.0072]).range(0, 1), [theHorns, GVerb.ar(theHorns, 3, 10)]) * 0.1;
	theHorns = SelectX.ar(Lag.ar(LFSaw.ar([0.087, 0.082]).range(0, 1)), [theHorns, theHorns * SinOsc.ar(Line.ar(60, 600, t, 1, 0))]);
	theHorns = theHorns * LFTri.ar(0.3, 0.5).range(0.8, 1) * LFTri.ar(0.0015, 0.0025).range(0.8, 1);
	theHorns = CombC.ar(theHorns, 1, [0.3, 0.5], 2, 1, theHorns);

	//Bullshit party
	rainbowHorns = theHorns + (readingRainbow * EnvGen.ar(Env.new([0, 0, 0.03, 0.03, 099], [t / 2, t, t, t])));
	rainbowHorns = HPF.ar(rainbowHorns, 40);
	rainbowHorns = rainbowHorns * 3;
	rainbowHorns = Compander.ar(rainbowHorns, rainbowHorns, 0.9, 1, 1/10);

	aMess = SelectX.ar(EnvGen.ar(Env.new([0, 0, 0, 1, 1], [t / 2, t, t, t]), doneAction:2), [rainbowHorns, GVerb.ar(rainbowHorns.clip2(0.0001) * 420, 3.7, 1) * 0.05 * SinOsc.ar(LFTri.kr(0.0032).range(400, 600) *
		LFTri.kr(0.015).range(0.7, 1.3))]);

	Compander.ar(aMess, aMess, 0.3, 1, 1/30);
});
)

s.scope