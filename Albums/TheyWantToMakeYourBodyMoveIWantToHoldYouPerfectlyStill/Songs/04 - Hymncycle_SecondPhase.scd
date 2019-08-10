/*
"Hymncycle (Second Phase)" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
{
	var seconds = 400;
	var source, effect, verbBus, verb, pulse1, pulse2;

	SynthDef(\verb, {|outbus = 0, inbus, room = 0.15, damp = 0.5, seconds = 400|
		var mix = SinOsc.kr(0.06).range(0.50, 1);
		var input = In.ar(inbus);
		var verb = FreeVerb.ar(input, mix, room, damp);
		var verb2 = FreeVerb.ar(verb, mix, [room, room * 0.95], damp);
		var filt = DFM1.ar(verb2, SinOsc.ar(0.08).range(800, 4500), 0.3, 1, 0.0);
		var line = Line.kr(0.0, 1.0, seconds);
		var temp = (filt * (1 - line)) + (filt * SinOsc.ar(5000) * SinOsc.ar(400) * line);
		var delay = temp + DelayC.ar(temp, 2, 2);
		Out.ar(outbus, delay * 0.4);
	}).add;

	SynthDef(\pulse, {|outbus = 0, freq = 60, second = 400|
		var pulse = Impulse.ar(freq) * LFTri.ar(10001); 
		var output = pulse + (SinOsc.ar(Line.ar(60, 80, seconds, doneAction: 2)) * 0.02);
		Out.ar(outbus, output)
	}).add;

	Server.default.sync;
	
	source = Group.head();
	effect = Group.tail();
	verbBus = Bus.audio(Server.default, 2);
	verb = Synth.head(effect, \verb, [\inbus, verbBus, \outbus, 0, \mix, 1, \room, 1]);
	pulse1 =  Synth.head(source,\pulse, [\outbus, verbBus, \freq, 60, \seconds, seconds]);
	pulse2 =  Synth.head(source,\pulse, [\outbus, verbBus, \freq, 60, \seconds, seconds]);

	~t1 = fork{loop{pulse1.set(\freq, rrand(0.1, 600)); 0.5.wait}};
	~t2 = fork{loop{pulse2.set(\freq, rrand(0.1, 600)); 0.51.wait}};
	(seconds + 10).wait;
	~t1.stop;~t2.stop;
	"done".postln
}.fork
)
