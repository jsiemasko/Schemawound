(
SynthDef(\saw, {|freq = 400, lo = 10, hi = 440, len = 1, lfoFreq = 0.1, eAmpStart = 1, eAmpEnd = 1, amp = 1|
	var sin = SinOsc.ar(
			SinOsc.ar(freq).range(lo, [hi, hi * 0.9])
			*
			SinOsc.ar(lfoFreq).range(0.5, 1)
		);
	var env = EnvGen.ar(Env.new([eAmpStart, eAmpEnd], len), doneAction: 2);
	var output = CombN.ar(sin * env, 0.1, 0.08, 1, 1, sin * env);
	Out.ar(0, output * amp * 0.3);
	}
).add;
)

(
var t = 0.15;
var noise = {|len = 1, wait = 1, freq = 400, hi = 440, amp = 1|
	len = len * t;
	wait = wait * t;
	Synth(\saw, [\freq, freq, \len, len, \hi, hi, \amp, amp]);
	wait.wait;
};
var noisePat1 = {|repeats = 1, freq = 1, speed = 1|
	repeats.do{
		noise.(1 * speed, 1 * speed, 400 * freq);
		noise.(1 * speed, 2 * speed, 800 * freq);
		noise.(1 * speed, 1 * speed, 1600 * freq);
		noise.(1 * speed, 2 * speed, 1600 * freq, 4400);
		noise.(2 * speed, 2 * speed, 60 * freq, 100);
		noise.(2 * speed, 2 * speed, 1000 * freq, 5000, 0.4);
		noise.(1*0.7 * speed, 2 * speed, 1600 * freq, 4400);
	};
};
fork{
	5.do{
		noisePat1.(4);
		noisePat1.(1, 4);
		noisePat1.(4, 2);
		noisePat1.(1, 8);
	};
};
)