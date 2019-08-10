(
play {
	var airFreqLfo = SinOsc.kr([0.01, 0.013], [0, 90], [40, 30], [500, 750]);
	var airAmp = 0.005;
	var air = BMoog.ar(PinkNoise.ar(airAmp), airFreqLfo, mode: 2);
	var verb = JPverb.ar(air, 3);
	var airVerb = SelectX.ar(SinOsc.kr([0.09, 0.07], 0, 0.5, 0.5), [air, verb]);
	var theTone = SinOsc.ar(60 + SinOsc.ar([0.234, 0.2321], [0, 180], 5), 0, 0.06) * SinOsc.ar([120, 30]);
	var theToneAmpLFO = SinOsc.ar([0.034, 0.023], 0, 0.9, 0.1);
	var theToneVerb = JPverb.ar(theTone * theToneAmpLFO, [3, 7]);
	theToneVerb + airVerb;
}
)