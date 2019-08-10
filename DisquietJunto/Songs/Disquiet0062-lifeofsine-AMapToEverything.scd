/*NOTE: I have not bothered to clean this code up after writing it. Don't take it as a good example ;) */
(
fork{
	var pat = ();

	SynthDef(\addOfSine, {
		|
		out = 0, gate = 1, amp = 1, doneHandlerLength = 10,
		freq0 = 125, phase0 = 0, amp0 = 1, attack0 = 0.1, decay0 = 0.1, sustain0 = 0.5, release0 = 0.3, pan0 = 0,
		freq1 = 237, phase1 = 0, amp1 = 1, attack1 = 0.1, decay1 = 0.1, sustain1 = 0.5, release1 = 0.3, pan1 = 0,
		freq2 = 1012, phase2 = 0, amp2 = 1, attack2 = 0.1, decay2 = 0.1, sustain2 = 0.5, release2 = 0.3, pan2 = 0
		|
		var doneHandler = Linen.kr(gate, 0, 1, doneHandlerLength, doneAction:5); //This guy is just here to handle the doneAction
		var sine = [//Div by 3 to avoid clipping
			Pan2.ar(SinOsc.ar(freq0, phase0 * 2pi, amp0) * EnvGen.ar(Env.adsr(attack0, decay0, sustain0, release0), gate), pan0) / 3,
			Pan2.ar(SinOsc.ar(freq1, phase0 * 2pi, amp1) * EnvGen.ar(Env.adsr(attack1, decay1, sustain1, release1), gate), pan1) / 3,
			Pan2.ar(SinOsc.ar(freq2, phase0 * 2pi, amp2) * EnvGen.ar(Env.adsr(attack2, decay2, sustain2, release2), gate), pan2) / 3,
		];
		var output = (sine[0] + sine[1] + sine[2]) * amp;
		Out.ar(out, output);
	}).add;

	SynthDef(\mulOfSine, {
		|
		out = 0, gate = 1, amp = 1, doneHandlerLength = 10,
		freq0 = 125, phase0 = 0, amp0 = 1, attack0 = 0.1, decay0 = 0.1, sustain0 = 0.5, release0 = 0.3, pan0 = 0,
		freq1 = 237, phase1 = 0, amp1 = 1, attack1 = 0.1, decay1 = 0.1, sustain1 = 0.5, release1 = 0.3, pan1 = 0,
		freq2 = 1012, phase2 = 0, amp2 = 1, attack2 = 0.1, decay2 = 0.1, sustain2 = 0.5, release2 = 0.3, pan2 = 0
		|
		var doneHandler = Linen.kr(gate, 0, 1, doneHandlerLength, doneAction:5); //This guy is just here to handle the doneAction
		var sine = [
			Pan2.ar(SinOsc.ar(freq0, phase0 * 2pi, amp0) * EnvGen.ar(Env.adsr(attack0, decay0, sustain0, release0), gate), pan0),
			Pan2.ar(SinOsc.ar(freq1, phase0 * 2pi, amp1) * EnvGen.ar(Env.adsr(attack1, decay1, sustain1, release1), gate), pan1),
			Pan2.ar(SinOsc.ar(freq2, phase0 * 2pi, amp2) * EnvGen.ar(Env.adsr(attack2, decay2, sustain2, release2), gate), pan2),
		];
		var output = sine[0] * sine[1] * sine[2] * amp;
		Out.ar(out, output);
	}).add;

	s.sync;

	pat.intro =
	Pseq([
		Pbind(*[
			instrument: \addOfSine,
			amp: 1,
			dur: Pn(5, 1),
			sustain: 4,
			amp0: 1, attack0: 4, decay0: 0, sustain0: 1, release0: 1,
			amp1: 0,
			amp2: 0
		]),
		Pbind(*[
			instrument: \addOfSine,
			amp: 1,
			dur: Pn(5, 1),
			sustain: 4,
			amp0: 1, attack0: 4, decay0: 0, sustain0: 1, release0: 1,
			amp1: 1, attack1: 4, decay1: 0, sustain1: 1, release1: 1,
			amp2: 0
		]),
		Pbind(*[
			instrument: \addOfSine,
			amp: 1,
			dur: Pn(5, 1),
			sustain: 4,
			amp0: 1, attack0: 4, decay0: 0, sustain0: 1, release0: 1,
			amp1: 1, attack1: 4, decay1: 0, sustain1: 1, release1: 1,
			amp2: 1, attack2: 4, decay2: 0, sustain2: 1, release2: 1,
		]),
	]);

	pat.intro2 =
	Pseq([
		Pbind(*[
			instrument: \addOfSine,
			amp: 1,
			dur: Pn(12.8 / 3, 1),
			sustain: 4,
			amp0: 1, attack0: 4, decay0: 0, sustain0: 1, release0: 1,
			amp1: 0,
			amp2: 0
		]),
		Pbind(*[
			instrument: \addOfSine,
			amp: 1,
			dur: Pn(12.8 / 3, 1),
			sustain: 4,
			amp0: 0,
			amp1: 1, attack1: 4, decay1: 0, sustain1: 1, release1: 1,
			amp2: 0
		]),
		Pbind(*[
			instrument: \addOfSine,
			amp: 1,
			dur: Pn(12.8 / 3, 1),
			sustain: 4,
			amp0: 0,
			amp1: 0,
			amp2: 1, attack2: 4, decay2: 0, sustain2: 1, release2: 1,
		]),
	]);

	pat.p0 = Pbind(*[
		instrument: \addOfSine,
		amp: 1,
		dur: Pseq([0.1], 16),
		sustain: Pkey(\dur),
		doneHandlerLength: 1,
		phase0: Pseq([0.2, 0, 0, 0], inf), amp0: 1, attack0: 0.001, decay0: 0.001, pan0: Pseq([-0.5, 0.5], inf),
		phase1: 0, amp1: 0, attack1: 0.1, release1: 0,
		phase2: 0, amp2: 0, attack2: 0,
	]);

	pat.p1 = Pbind(*[
		instrument: \addOfSine,
		amp: 1,
		dur: Pseq([0.1], 16),
		sustain: Pkey(\dur),
		doneHandlerLength: 3,
		phase0: Pseq([0.2, 0, 0, 0], inf), amp0: 1, attack0: 0.001, decay0: 0.001, pan0: Pseq([-1, 1], inf),
		phase1: Pseq([0.2, 0.2, 0, 0], inf), amp1: Pseq([1,0,0], inf), attack1: 0.01, release1: 0.001, pan1: Pseq([1, 1, -1, -1, 0, 0, 0, 0], inf),
		amp2: 0, phase2: 0, attack2: 0,
	]);

	pat.p2 = Pbind(*[
		instrument: \addOfSine,
		amp: 1,
		dur: Pseq([0.1], 16),
		sustain: Pkey(\dur),
		doneHandlerLength: 3,
		phase0: Pseq([0.2, 0, 0, 0], inf), amp0: 1, attack0: 0.001, decay0: 0.001, pan0: Pseq([-0.5, 0.5], inf),
		phase1: 0, amp1: 0, attack1: 0.01, release1: 0.001, pan1: Pseq([1, 1, -1, -1, 0, 0, 0, 0], inf),
		phase2: Pwhite(), amp2: 0.7, attack2: 0.001, release2: 0.001, decay2: Pseq([0.3, 0.1, 0.01, 0.01, 0.01], inf), sustain2: 0, pan2: Pseq([-1, 0, 1], inf)
	]);

	pat.p3 = Pbind(*[
		instrument: \addOfSine,
		amp: 1,
		dur: Pseq([0.1], 16),
		sustain: Pkey(\dur),
		doneHandlerLength: 3,
		phase0: Pseq([0.2, 0, 0, 0], inf), amp0: 1, attack0: 0.001, decay0: 0.001, pan0: Pseq([-1, 1], inf),
		phase1: Pseq([0.2, 0.2, 0, 0], inf), amp1: Pseq([1,0,0], inf), attack1: 0.01, release1: 0.001, pan1: Pseq([1, 1, -1, -1, 0, 0, 0, 0], inf),
		phase2: Pwhite(), amp2: 0.7, attack2: 0.01, release2: 0.01, decay2: Pseq([0.3, 0.1, 0.01, 0.01, 0.01], inf), sustain2: 0, pan2: Pseq([-1, 0, 1], inf)
	]);

	pat.p4 = Pbind(*[
		instrument: \addOfSine,
		amp: 1,
		dur: Pseq([0.17], 16),
		sustain: Pkey(\dur),
		doneHandlerLength: 0.4,
		phase0: Pseq([0.2, 0, 0, 0], inf), amp0: 1, attack0: 0, decay0: 0, pan0: Pseq([-1, 1], inf),
		phase1: Pseq([0.2, 0.2, 0, 0], inf), amp1: Pseq([1,0,0], inf), attack1: 0, release1: 0, pan1: Pseq([1, 1, -1, -1, 0, 0, 0, 0], inf),
		phase2: Pwhite(), amp2: 0.7, attack2: 0.17, release2: 0, decay2: Pseq([0.3, 0.1, 0.01, 0.01, 0.01], inf), sustain2: 0, pan2: Pseq([-1, 0, 1], inf)
	]);

	pat.p5 = Pbind(*[
		instrument: \addOfSine,
		amp: Pseq([Pn(1,64), Pn(0, 64)], 4),
		dur: 0.05,
		sustain: Pkey(\dur),
		doneHandlerLength: 0.4,
		phase0: 0, amp0: 0.25, attack0: 0.05, decay0: 0.001, sustain0: 0, release0: 0.001, pan0: Pseq([-1, 1], inf),
		phase1: 0, amp1: 0.25, attack1: 0.05, decay0: 0.001, sustain0: 0, release0: 0.001, pan1: Pseq([1, 1, -1, -1, 0, 0, 0, 0], inf),
		phase2: 0, amp2: 0.25, attack2: 0.05, decay0: 0.001, sustain0: 0, release0: 0.001, pan2: Pseq([-1, 0, 1], inf)
	]);

	pat.p6 = Pbind(*[
		instrument: \addOfSine,
		amp: Pseq([Pn(1,64), Pn(0, 64)], 8),
		dur: 0.025,
		sustain: Pkey(\dur),
		doneHandlerLength: 1,
		phase0: 0.5, amp0: 0.2, attack0: 0.001, decay0: 0.001, sustain0: 0, release0: 0.001, pan0: Pseq([-1, 1], inf),
		phase1: 0.5, amp1: 0.2, attack1: 0.001, decay0: 0.001, sustain0: 0, release0: 0.001, pan1: Pseq([1, 1, -1, -1, 0, 0, 0, 0], inf),
		phase2: 0.5, amp2: 0.2, attack2: 0.001, decay0: 0.001, sustain0: 0, release0: 0.001, pan2: Pseq([-1, 0, 1], inf)
	]);

	pat.hold = Pbind(*[
		instrument: \mulOfSine,
		amp: 3,
		dur: Pn(0.2, 64),
		sustain: Pseq([Pkey(\dur), Pkey(\dur) / 2, Pkey(\dur), Pkey(\dur) / 4]),
		amp0: Pseq([1,0.5,0.3,0.5], inf), attack0: 0.001, decay0: 0.001, pan0: 0, release0: 0.001,
		amp1: Pseq([1,0.5,0.7], inf), attack1: 0.001, decay1: 0.001, pan1: 0, release1: 0.001,
		amp2: Pseq([1,0.5,0.7,1,0.7], inf), attack2: 0.001, decay2: 0.001, pan2: 0, release2: 0.001
	]);



	//Sequence
	Pseq([
		pat.intro,
		Pseq([Pn(pat.p0, 4), Pn(pat.p1, 4)], 2),
		Pseq([Pn(pat.p2, 4), Pn(pat.p3, 4)], 2),
		Pn(pat.hold, 1),
		Ppar([Pn(pat.hold, 2), Pseq([Pn(pat.p0, 4), Pn(pat.p1, 4)], 2)]),
		Ppar([pat.p5, Pn(pat.hold, 2), Pseq([Pn(pat.p2, 4), Pn(pat.p3, 4)], 2)]),
		Ppar([pat.p5, pat.p6, Pn(pat.hold, 2), Pseq([Pn(pat.p0, 4), Pn(pat.p1, 4)], 2)]),
		Ppar([pat.p5, pat.p6, pat.intro, Pn(pat.hold, 1)]),
	]).play
}
)
