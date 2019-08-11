(
{
	var saw = Saw.ar(400);
	var sinPulse = SinOsc.ar(Pulse.ar(0.2,0.5).range(10,[2000,3000]));
	var sinPulse2 = SinOsc.ar([Pulse.ar(0.5, 0.4).range(40,440),441]) ** Saw.ar([439, 438]);
	var drunkMachine = (saw ** sinPulse * sinPulse2).clip(0.9);
	var sin = SinOsc.ar(37);
	var loOsc = 1 - (SinOsc.ar(0.1) * SinOsc.ar(36));
	var sinisterPad = sin * loOsc;
	var line = Line.ar(0.2, 5, 60, doneAction:2);
	drunkMachine * sinisterPad * 0.5
}.play
)