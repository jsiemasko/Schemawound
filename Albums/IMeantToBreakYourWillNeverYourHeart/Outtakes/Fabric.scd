(
p.pop;

SynthDef(\fabric, {|out = 0|
	var fab = Pluck.ar(SinOsc.ar(SinOsc.ar(0.01).range(60, 600), mul:0.1), Impulse.kr(3), 1, 0.02, 10, coef: SinOsc.ar(0.17).range(-0.99, 0.99));
	fab = fab * SinOsc.ar(SinOsc.ar(0.02).range(400, [590,600]));
	fab = fab + CombC.ar(fab, 2, SinOsc.ar(0.015).range(0.5, 1) * [0.13, 0.17], 7);
	fab = fab + CombC.ar(fab, 2, SinOsc.ar(0.01).range(0.5, 1) * [0.1, 0.15], 7);
	fab = fab + CombC.ar(fab, 2, [1.5, 1.0], 7);
	fab = fab + DelayC.ar(HPF.ar(fab, 1000), 1, 1, mul:0.5);
	fab = Compander.ar(fab, fab, 0.5, 1, 1/30);
	fab = fab + GVerb.ar(fab, 10);
	fab = fab / 20;
	fab = fab.clip(-1, 1);
	Out.ar(out, fab * 0.5);
}).add;

SynthDef(\fabricHighFX, {|out = 0, in|
	var input = In.ar(in, 2);
	var output = CombC.ar(input, 2, SinOsc.ar(0.001).range(0.005, 0.01), 10, 0.1).clip(-0.5, 0.5) * SinOsc.ar(0.1234).range(0, 1);
	output = input + output;
	Out.ar(out, output);
}).add;

//---------Groups & Busses---------
~fabric = ~fabric ? ();
~fabric.groups = ~fabric.groups ? ();
~fabric.groups.synths = Group.new;
~fabric.groups.fx = Group.after(~fabric.groups.synths);
~fabric.busses = ~fabric.busses ? ();
~fabric.busses.mainOut = 0;
~fabric.busses.highFxInBus = Bus.audio(Server.default, 2);
~fabric.synths = ~fabric.synths ? ();
~fabric.postInfo = {''.postln; '--FABRIC--'.postln; ~fabric.dopostln; ''.postln;};

~fabric.postInfo.();
)

(
~fabric.synths.mainSynth = Synth(\fabric, [\out, ~fabric.busses.highFxInBus], ~fabric.groups.synths, \addToHead);
~fabric.synths.highFX = Synth(\fabricHighFX, [\in, ~fabric.busses.highFxInBus, \out, ~fabric.busses.mainOut], ~fabric.groups.fx, \addToTail);
)