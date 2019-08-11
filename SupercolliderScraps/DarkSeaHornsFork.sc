(
	Ndef(\x,	{
		var output;
		var delayTime;
		var delayMax = 0.2;
		var delayAdd = 0.1;
		var pulseFreq = 0.5;
		var proxyMul = 2;
		var pulseMin = 40;
		var pulseMax = 130;
		var numOfEchos = 2;

		var mainPulse = LFPulse.ar(pulseFreq, 0, 0.5).range(pulseMin, pulseMax);
		var proxy = Ndef(\x).ar * proxyMul;
		var ampModFreq = SinOsc.ar(0.01, 0).range(0.3, 30);
		var ampMod = LFNoise1.ar(ampModFreq, 6);
		output = SinOsc.ar(mainPulse + proxy, 0, ampMod).tanh;
		numOfEchos.do{
			delayTime = {delayMax.rand + delayAdd}!2;
			output = AllpassL.ar(output, 0.1, delayTime, 5);
		};
	output.tanh;
	}).play
)