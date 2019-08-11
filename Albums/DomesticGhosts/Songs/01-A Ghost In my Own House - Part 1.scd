(
play{
	var duration = 600, durLine, osc, sound = 0, mod, crystalDin, liner, sum, high;
	durLine = Line.ar(0, 1, duration);

	//Crystal Din
	osc = {|speed, freq| Saw.ar(freq) * EnvGen.ar(Env.perc(0.0001, 0.0001), Impulse.ar(speed))};
	8.do{|i| sound = sound + osc.(0.1 + (i/100), 1000 - (i/10)) + osc.(0.22 + (i/100), 10000 - (i/10))};
	sound = Compander.ar(sound, sound, 0.1, 1, 0.001, 0.01, 0.1, 1);
	mod = {|in,f1,f2,f3,f4| SinOsc.ar([f1,f2]) * SinOsc.ar([f3,f4]) * in};
	sound = mod.(sound,0.001,0.0023,3000,2356) + mod.(sound,0.027,0.015,300,200) + mod.(sound,0.017,0.063,100,50);
	sound = sound + CombC.ar(sound, 2, 0.1, 2);
	sound = sound + CombC.ar(sound, 2, 2, 2);
	sound = sound + (GVerb.ar(sound) * SinOsc.ar([0.07, 0.08]));
	crystalDin = (sound * Line.kr(0.7, 100, duration, 1, 0)).clip(-1, 1);

	//Liner
	liner = SinOsc.ar(Line.kr(40, [1000, 900], duration)) * SinOsc.ar(Line.kr([90, 89], 40, duration)) * SinOsc.ar(Line.kr(60, 200, duration));
	liner = Decimator.ar(liner, Line.ar(8000, [800, 900], duration), 4);
	liner = GVerb.ar(liner) * 0.1;

	//High
	high = Decimator.ar(Saw.ar(987) * Saw.ar(1500) * EnvGen.kr(Env([0,0,1,0], [duration/3*2, duration, duration + 10])), 8000, 8);

	//Sum
	sum = (crystalDin * 0.3) + (liner * 10 * durLine) + high;
	sum = EnvGen.kr(Env.linen(1, duration, 1)) * sum;
	sum = (sum * (1 - durLine)) + (sum + CombC.ar(sum, 10, 0.5, 10) + CombC.ar(sum, 10, 0.7, 10) * durLine);
	sum = sum.clip(-1, 1) * 0.1;
	sum = (sum * (1 - durLine)) + (GVerb.ar(sum) * (1 - durLine));
	sum * 0.5;
}
)