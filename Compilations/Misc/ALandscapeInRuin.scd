/*
Appears on the free compilation "I PREFER THE TERM ARTIFICIAL PERSON MYSELF: A Compilation of Machine​-​Made Audio"
Available as a free download from Kill Collector Culture
http://killcollectorculture.bandcamp.com/album/i-prefer-the-term-artificial-person-myself-a-compilation-of-machine-made-audio

NOTE: Set your memsize to 65536
*/

(
{
	x = SinOsc.ar(SinOsc.ar(0.0045).range([40,42], [1000, 950])) * GrainSin.ar(2, Impulse.ar(1), SinOsc.kr(0.003).range(0.001, 0.01), SinOsc.kr(0.002).range(1000, 4000), SinOsc.kr(0.3), -1, 512, 0.5);
	x = CombC.ar(x, 4, SinOsc.kr(0.1).range(0.1, 2), 10, 1, x);
	x = RLPF.ar(x, SinOsc.kr(0.022).abs * SinOsc.kr(0.01).range(400, 4000), 1);
	x = CombC.ar(x, 6, 6, 10, 1, x);
	x = SinOsc.ar(SinOsc.ar(0.0001).range(400, 4000)) * x;
	x = GVerb.ar(x);
	x = Compander.ar(x, x, 0.2, 1, 1/10)  * 0.5;
	x = x + LPF.ar(DelayC.ar(x, 2, SinOsc.ar(0.01).range(0.9, 1.1), SinOsc.ar(0.0001).range(0, 1), 0), 200);
	y = GVerb.ar(HPF.ar(SinOsc.ar(SinOsc.kr(0.1).range(200, 210)) * GrainSin.ar(2, Impulse.ar(1), 1, SinOsc.ar(1/8).range(80, 100), 0, -1, 512, 0.1) * SinOsc.ar(0.001), 400));
	z = WhiteNoise.ar(SinOsc.kr([0.1, 0.145]) * SinOsc.kr(0.34) * SinOsc.kr(1.13) * SinOsc.kr(0.712));
	z = RHPF.ar(z, SinOsc.kr(0.001).range(1000, 4000) * SinOsc.kr(0.0212).abs, 0.5);
	z = z + CombC.ar(z, 1, 0.1, 1);
	z = z + CombC.ar(z, 1, 1, 10);
	z = z * SinOsc.ar(0.0001) * 0.004;
	x+y+z;
}.play
)
