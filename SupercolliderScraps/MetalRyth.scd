(
SynthDef(\metalRyth, {|out = 0, gate = 1, amp = 1, f1 = 28, f2 = 35, f3 = 300, f4 = 400, f5 = 10, f6 = 9, f7 = 30, f8 = 19|
	var lfo1 = [f1, f2] * Saw.ar(4) /4 + 0.25;
	var lfo2 = SinOsc.ar(0.1,0,f3,f4);
	var osc = Saw.ar([f5, f6]);
	osc = osc * Saw.ar([f7, f8]);
	osc = osc ** Saw.ar(lfo1);
	osc = osc / 9;
	osc = osc.clip(-1,1);
	osc = osc * SinOsc.ar(lfo2);
	Out.ar(out, (GVerb.ar(osc)/4) * Linen.kr(gate, 0.01, amp, 0.01, 2));
}).add;

SynthDef(\AEKick, {|
	out = 0, amp = 1,
	attack = 0.01, decay = 0.7, curve = 3,
	pEnvMul = 20, pEnvAdd = 40, pEnvAtk = 0.01, pEnvDecay = 0.25, pEnvCurve = -4
	fmAmp = 1, fmpEnvMul = 100, fmpEnvAdd = 10, fmpEnvAtk = 0.001, fmpEnvDecay = 0.10, fmpEnvCurve = -2
	|
	var ampEvn = EnvGen.ar(Env.perc(attack, decay, amp, curve), doneAction: 2);
	var pitchEnv = EnvGen.kr(Env.perc(pEnvAtk, pEnvDecay, pEnvMul, pEnvCurve)) + pEnvAdd;
	var fmpitchEnv = EnvGen.kr(Env.perc(fmpEnvAtk, fmpEnvDecay, fmpEnvMul, fmpEnvCurve)) + fmpEnvAdd;
	var fmMod = SinOsc.ar(fmpitchEnv) * fmAmp;
	var sin = SinOsc.ar(pitchEnv) * fmMod;
	sin = sin + (LFNoise0.ar(10000) * EnvGen.ar(Env.perc(0.01, 0.02, 0.001, 0)));
	Out.ar(out, sin * ampEvn!2);
}).add;

SynthDef(\slowSteam, {|out = 0, amp = 0.5, attack = 0.01, decay = 0.01, freq = 40|
	var env = EnvGen.ar(Env.perc(attack, decay), doneAction:2) * amp;
	var noise = PinkNoise.ar()!2;
	var filter = HPF.ar(noise, freq);
	Out.ar(out, env * filter);
}).add;
)

(
var songClock = TempoClock(1, 0);
var pw = {|max| Pwhite(0, max)}; //shortcut because I use too many Pwhites.
var metals, drums, loop;

//METALS
metals = Ppar([
	Pbind(*[instrument: \metalRyth, f1: pw.(280), f2: pw.(350), f3: pw.(300), f4: pw.(400), f5: pw.(100), f6: pw.(90), f7: pw.(300), f8: pw.(109), amp: Pn(0.3, 4), dur: 2, sustain: Pkey(\dur)]),
	Pbind(*[instrument: \metalRyth, f1: pw.(2800), f2: pw.(3500), f3: pw.(3000), f4: pw.(4000), f5: pw.(1000), f6: pw.(900), f7: pw.(3000), f8: pw.(1009), amp: Pseq([Rest, 0.3], 8), dur: 0.5, sustain: Pkey(\dur)])
]);

//DRUMS
drums = Ppar([
	Pbind(*[instrument: \slowSteam, amp: Pn(0.2, 64), dur: 1/8]), //Hats
    Pbind(*[instrument: \AEKick, amp: Pseq([Pseq([0.7, Rest], 14), Pn(0.7, 4)]), dur: 1/4]) //Kick
]);

//SUM
loop = Ppar([metals, drums]);
Pn(loop, 4).play(songClock);
)