(
(
	{
	var s1, s2, s3, lfo1, lfo2, lfo3, lfo4, distwave;
	lfo4 = SinOsc.kr(0.002, add: 1, mul: 0.5);
	lfo3 = SinOsc.kr(0.005, add: 0, mul: 0.5);
	lfo1 = SinOsc.kr(0.004 + lfo3, add: 1, mul: 25);
	lfo2 = SinOsc.kr(0.0039, add: 1, mul: 20);
	s1 = SinOsc.ar(45 + lfo2);
	s2 = SinOsc.ar(MouseY.kr(100, 150) * lfo4);
	s3 = SinOsc.kr(40 + lfo1);
	distwave = ((s1 * (s2 * s3) * 20)).distort * 0.5;
	distwave = ((distwave * MouseX.kr(3, 10)).clip - 0.5) * 2;
	Out.ar([0,1], 
		distwave
	)}
).play;)