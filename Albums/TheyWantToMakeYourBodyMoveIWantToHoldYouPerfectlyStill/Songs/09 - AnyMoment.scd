/*
"Any Moment" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

({//-=-=-=-=-=-=-=-=-=-=-=-=-=- WATERPADRISE DEF -=-=-=-=-=-=-=-=-=-=-=-=-=-
	SynthDef(\WaterPadRise5, {
		|
			out = 0,	amp = 1, baseEnvLfoSpeed = 1, sinLfoSpeed = 0.001,
			maxEnvLfoDepth = 10, maxSinLfoDepth = 60
		|
		var numOfSines = 5;
		var minEnvLfoSpeed = baseEnvLfoSpeed * 0.09;
		var maxEnvLfoSpeed = baseEnvLfoSpeed * 1.1;
		var output = Mix(
			Array.fill(numOfSines, {
				arg i;
				var envLfoSpeed = Rand(minEnvLfoSpeed, maxEnvLfoSpeed);
				var envLfo = i * SinOsc.kr(envLfoSpeed).range(1, maxEnvLfoDepth);
				var env = max(0, LFNoise1.kr(envLfo));
				var oscLfo = SinOsc.kr(sinLfoSpeed).range(1, maxSinLfoDepth) * (i + 1);
				SinOsc.ar(oscLfo, mul: env);
			})
		);
		Out.ar(out, output * (amp * 0.1));
	}).add;

	SynthDef(\WaterPadRise25, {
		|
			out = 0,	amp = 1, baseEnvLfoSpeed = 1, sinLfoSpeed = 0.001,
			maxEnvLfoDepth = 10, maxSinLfoDepth = 60
		|
		var numOfSines = 25;
		var minEnvLfoSpeed = baseEnvLfoSpeed * 0.09;
		var maxEnvLfoSpeed = baseEnvLfoSpeed * 1.1;
		var output = Mix(
			Array.fill(numOfSines, {
				arg i;
				var envLfoSpeed = Rand(minEnvLfoSpeed, maxEnvLfoSpeed);
				var envLfo = i * SinOsc.kr(envLfoSpeed).range(1, maxEnvLfoDepth);
				var env = max(0, LFNoise1.kr(envLfo));
				var oscLfo = SinOsc.kr(sinLfoSpeed).range(1, maxSinLfoDepth) * (i + 1);
				SinOsc.ar(oscLfo, mul: env);
			})
		);
		Out.ar(out, output * (amp * 0.1));
	}).add;

	SynthDef(\WaterPadRise50, {
		|
			out = 0,	amp = 1, baseEnvLfoSpeed = 1, sinLfoSpeed = 0.001,
			maxEnvLfoDepth = 10, maxSinLfoDepth = 60
		|
		var numOfSines = 50;
		var minEnvLfoSpeed = baseEnvLfoSpeed * 0.09;
		var maxEnvLfoSpeed = baseEnvLfoSpeed * 1.1;
		var output = Mix(
			Array.fill(numOfSines, {
				arg i;
				var envLfoSpeed = Rand(minEnvLfoSpeed, maxEnvLfoSpeed);
				var envLfo = i * SinOsc.kr(envLfoSpeed).range(1, maxEnvLfoDepth);
				var env = max(0, LFNoise1.kr(envLfo));
				var oscLfo = SinOsc.kr(sinLfoSpeed).range(1, maxSinLfoDepth) * (i + 1);
				SinOsc.ar(oscLfo, mul: env);
			})
		);
		Out.ar(out, output * (amp * 0.1));
	}).add;

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- VERB DEF -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	SynthDef(\Verb, {
		arg 	out = 0,	in,
			mix = 0.25,	room = 0.15,	damp = 0.5;
	
		var input, verb;
		
		input = In.ar(in);
		verb = FreeVerb.ar(input, mix, room, damp);
		Out.ar(out, verb!2);
	}).add;

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- CONTROL OSC DEF -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	SynthDef(\ControlOsc, {
		|
			out = 0,	freq = 60, phase = 0pi, amp = 1
		|
	
		Out.kr(out, SinOsc.kr(freq, phase).range(0, amp));
	}).add;

	Server.default.sync;

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- SIGNAL FLOW -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
/*
	Water5  -> Verb1 -> Verb2 -> Out
	Water25 ->
	Water50 ->
*/

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- GROUPS AND BUSSES -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	~sourceGroup = Group.new;
	~fxGroup = Group.after(~sourceGroup);
	~mainOut = 0;
	~verbBus1 = Bus.audio(s, 2);
	~verbBus2 = Bus.audio(s, 2);
		
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- VERBS -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	// Verb 1
	~verb1 = Synth.head(~fxGroup, \Verb, [\in, ~verbBus1, \out, ~verbBus2]);
	~verb1AmntCtrlBus = Bus.control(s, 1); ~verb1AmntCtrlBus.set(1); 
	~verb1.map(\mix, ~verb1AmntCtrlBus);
	~verb1MixOsc = Synth.before(~verb1, \ControlOsc, [\out, ~verb1AmntCtrlBus, \freq, 0.05, \amp, 1]); 

	//Verb 2
	~verb2 = Synth.tail(~fxGroup, \Verb, [\in, ~verbBus2, \out, ~mainOut]);
	~verb2AmntCtrlBus = Bus.control(s, 1); ~verb2AmntCtrlBus.set(0); 
	~verb2.map(\mix, ~verb2AmntCtrlBus);
	~verb2MixOsc = Synth.before(~verb2, \ControlOsc, [\out, ~verb2AmntCtrlBus, \freq, 0.04, \amp, 1]); 

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- WATERS -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	// Water 5
	~water5Group = Group.head(~sourceGroup);
	~water5CtrlBus = Bus.control(s, 1); ~water5CtrlBus.set(0);
	~waterPadRise5 = Synth.tail(~water5Group, \WaterPadRise5, [\out, ~verbBus1]);
	~waterPadRise5.map(\amp, ~water5CtrlBus);
	~water5Lfo = Synth.head(~water5Group, \ControlOsc, [\out, ~water5CtrlBus, \freq, 0.1, \amp, 1]);

	// Water 25
	~water25Group = Group.head(~sourceGroup);
	~water25CtrlBus = Bus.control(s, 1); ~water25CtrlBus.set(0);
	~waterPadRise25 = Synth.tail(~water25Group, \WaterPadRise25, [\out, ~verbBus1]);
	~waterPadRise25.map(\amp, ~water25CtrlBus);
	~water25Lfo = Synth.head(~water25Group, \ControlOsc, [\out, ~water25CtrlBus, \freq, 0.1, \phase, 1pi, \amp, 1]);

	// Water 50
	~water50Group = Group.head(~sourceGroup);
	~water50CtrlBus = Bus.control(s, 1); ~water50CtrlBus.set(0);
	~waterPadRise50 = Synth.tail(~water50Group, \WaterPadRise50, [\out, ~verbBus1]);
	~waterPadRise50.map(\amp, ~water50CtrlBus);
	~water50Lfo = Synth.head(~water50Group, \ControlOsc, [\out, ~water50CtrlBus, \freq, 0.01, \phase, 1pi, \amp, 0.5]);
}.fork
)
