(
play{
	var bits1 = ((PulseCount.ar(Impulse.ar(200+SinOsc.ar(0.017).range(0, [400, 420])))*7)&(PulseCount.ar(Impulse.ar(591))>>7))-1%256/256*0.5-0.5;
	var verb1 = bits1 * SinOsc.ar([600 + SinOsc.ar(0.012).range(0, 100), 601 + SinOsc.ar([0.016, 0.017]).range(0, 100)]);
	var verb2 = GVerb.ar(verb1, 1.7 + SinOsc.ar(0.012).range(0, 1), 30) * 0.07 + (verb1 * 0.1);
	var delay = LPF.ar(CombC.ar(HPF.ar(verb2, 500) * 0.7, 1.1, [1.1, 0.9], 1, 1, verb2), SinOsc.ar(0.0354).range(1000, 12000));
	var mess = SelectX.ar(SinOsc.ar(0.23).range(0, 1), [delay, GVerb.ar(delay * 0.3, 6, 10)]) * 0.2;
	var mess2 = Compander.ar(mess, mess, 0.5, 1, 1/7);
	Compander.ar(mess2, mess2, 0.7, 1, 1/30) * 0.5;
};
)