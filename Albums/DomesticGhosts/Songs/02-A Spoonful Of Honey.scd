(
{
	//Variables
	var mainOut, verbBus, osc1Bus, osc2Bus, osc3Bus, hiSineBus, spaceSawGroup, fxGroup;
	var time = 350;
	var songEnv = Env.new([1, 1, 0.001], [time - 30, 30]);
	var ampEnv = Env.new([1, 1, 0], [time - 5, 5]);

	//SynthDefs
	SynthDef(\SpaceSawOsc1, {|out = 0|
		var osc;
	    osc = Pulse.kr(0.1).range(0.1, 1) * 7.81;
		osc = Saw.kr(osc).range(1,[2500,3000]) * EnvGen.ar(songEnv, doneAction: 2);
	    osc = osc + Saw.kr(21).range(1,[250,300]);
		osc = Saw.ar(osc);
		Out.ar(out, osc);
	}, [\ir]).add;

	SynthDef(\SpaceSawOsc2, {|out = 0|
		var osc;
	    osc = SinOsc.kr(0.023).range(0.1,1) * 7.01;
	    osc = SinOsc.kr(osc).range(1,200);
	    osc = osc + SinOsc.kr(3.9).range(1,100);
	    osc = osc + SinOsc.kr(90.1).range(1,[102,150.3]);
		osc = SinOsc.ar(osc);
		Out.ar(out, osc);
	}, [\ir]).add;

	SynthDef(\SpaceSawOsc3, {|out = 0|
		var osc;
	    osc = SinOsc.ar(20 * SinOsc.ar(0.032)) * EnvGen.ar(songEnv, doneAction: 2);
		Out.ar(out, osc);
	}, [\ir]).add;

	SynthDef(\SpaceSawHiSine, {|out = 0|
		var hiSine;
	    hiSine = SinOsc.ar(100) * SinOsc.ar(0.002) * 0.01;
	    hiSine = hiSine * SinOsc.ar(150) * SinOsc.ar(0.0017) * 0.01;
		Out.ar(out, hiSine);
	}, [\ir]).add;

    SynthDef(\SpaceSaw, {|out = 0, in1, in2, in3, in4|
	    var osc1, osc2, osc3, oscSum, cutoffLFO, hiSine;
		osc1 = In.ar(in1, 1);
		osc2 = In.ar(in2, 1);
		osc3 = In.ar(in3, 1);
		hiSine = In.ar(in4, 1);
	    oscSum = osc1 * osc2 * osc3;
	    oscSum = Clip.ar(oscSum, -0.01, 0.01);
	    cutoffLFO = SinOsc.kr(0.27).range(1000,3000) * SinOsc.ar(0.001);
	    oscSum = RLPF.ar(oscSum, cutoffLFO);
	    oscSum = oscSum + hiSine;
		Out.ar(out, oscSum  * EnvGen.ar(ampEnv));
	}, [\ir, \ir]).add;

	SynthDef(\SpaceSawVerb, {|out = 0, in, lfoRate = 0.0412|
		var input, verbLFO, verb, hpf, dly;
		input = In.ar(in, 1);
		verbLFO = SinOsc.kr(lfoRate).range(0.3, 0.8);
		verb = FreeVerb.ar(input, mix: verbLFO / 2, room: 1, damp: 0);
		dly = verb + RLPF.ar(CombC.ar(verb, 10, SinOsc.ar(0.003).range(1, 2), 10, 0.5), 2000, 1, SinOsc.ar(0.002).range(0, 0.5));
		hpf = LPF.ar(HPF.ar(dly * 13, 30), 10000);
		hpf = RHPF.ar(hpf, SinOsc.ar(0.01).range(100, 10000), 0.3);
		hpf = Compander.ar(hpf, hpf, 0.4, 1, 1/20) * 2;
		hpf = Compander.ar(hpf, hpf, 0.4, 1, 1/20) * 2;
		hpf = Compander.ar(hpf, hpf, 0.4, 1, 1/20) * 2;
		hpf = Compander.ar(hpf, hpf, 0.4, 1, 1/20) * 2;
		hpf = Compander.ar(hpf, hpf, 0.4, 1, 1/20) * 2;
		hpf = Compander.ar(hpf, hpf, 0.4, 1, 1/20) * 0.03;
		hpf = DelayC.ar(hpf, 5, 5, 1, hpf);
		Out.ar(out, hpf!2);
	}, [\ir, \ir, 20]).add;

	//Sync
	s.sync;

	//Groups
	spaceSawGroup = Group.new;
	fxGroup = Group.tail(~sourceGroup);

	//Busses
	mainOut = [0,1];
	verbBus = Bus.audio(Server.default, 2);
	osc1Bus = Bus.audio(Server.default, 1);
	osc2Bus = Bus.audio(Server.default, 1);
	osc3Bus = Bus.audio(Server.default, 1);
	hiSineBus = Bus.audio(Server.default, 1);

	//Synths
	~reverb = Synth(\SpaceSawVerb, [\out, mainOut, \in, verbBus], fxGroup, \addToTail);
	~spaceSawOsc1 = Synth(\SpaceSawOsc1, [\out, osc1Bus], spaceSawGroup, \addToHead);
	~spaceSawOsc2 = Synth(\SpaceSawOsc2, [\out, osc2Bus], spaceSawGroup, \addToHead);
	~spaceSawOsc3 = Synth(\SpaceSawOsc3, [\out, osc3Bus], spaceSawGroup, \addToHead);
	~spaceSawHiSine = Synth(\SpaceSawHiSine, [\out, hiSineBus], spaceSawGroup, \addToHead);
	~spaceSaw = Synth(\SpaceSaw, [
		\out, verbBus,
		\in1, osc1Bus,
		\in2, osc1Bus,
		\in3, osc1Bus,
		\in4, hiSineBus
	], spaceSawGroup, \addToTail);

	a = {SinOsc.ar([Line.kr(60, 40, time), Line.kr(47, 52, time)]) * SinOsc.ar([Line.kr(40, 50, time), Line.kr(45, 39, time)]) * SinOsc.ar(43) * SinOsc.ar(0.01) * SinOsc.ar(23) * SinOsc.ar(0.01)}.play;
	b = {SinOsc.ar([Line.kr(100, 150, time), Line.kr(200, 150, time)]) * SinOsc.ar([Line.kr(60, 90, time), Line.kr(60, 45, time)]) * SinOsc.ar(430) * SinOsc.ar([SinOsc.ar(0.01).range(2,3), SinOsc.ar(0.016).range(2,3)]) * SinOsc.ar([0.021, 0.017]) * SinOsc.ar(230) * 0.1}.play;
}.fork
)