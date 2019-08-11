(
{
	var verbError = GVerb.ar(SinOsc.ar(300) * GVerb.ar(GVerb.ar(SinOsc.ar(SinOsc.ar(0.0777).range(50, 60), 0, 0.05), SinOsc.ar(0.001).range(3, 4))), SinOsc.ar(0.027).range(3, 4), mul: 0.05);
	verbError = Compander.ar(verbError, verbError, 0.3, 1, 1/20) * 2;
	verbError = Compander.ar(verbError, verbError, 0.3, 1, 1/20) * 2;
	verbError = Compander.ar(verbError, verbError, 0.3, 1, 1/20);
	verbError = LPF.ar(verbError + CombC.ar(verbError, 10, 2, 10) / 4, 200);
	verbError = (SinOsc.ar(60, mul: 0.02) * verbError * VarLag.ar(LFPulse.ar(0.4), 0.2)) + GVerb.ar((SinOsc.ar(60, 0, 0.1) * VarLag.ar(LFPulse.ar(0.1), 0.2))) + GVerb.ar((SinOsc.ar(SinOsc.ar(0.0001).range(3000, 6000), 0, 0.0002) * VarLag.ar(LFPulse.ar(0.08), 0.2)), 1, drylevel: 0);
	verbError = verbError + CombC.ar(verbError, 10, SinOsc.ar(SinOsc.ar(0.001).range(0.01, 0.1)).range(0.3, [0.5, 0.6]), SinOsc.ar(0.33).range(3, 10)) * 0.3;
	HPF.ar(verbError, 50);
}.play
)