(
p.pop;
p = ProxySpace.push(s);
~storm.play;
~storm.fadeTime_(5);
~sin.fadeTime_(5);
~saw.fadeTime_(5);
)

(
~sin = {SinOsc.ar([100, 199])};
~saw = {Lag.ar(LFSaw.ar([2, 1]), 0.01)};
)

(
~storm = {
	var storm = ~sin.ar * SinOsc.ar(400) * ~saw.ar;
	// storm = CombC.ar(storm, 2, LFSaw.ar([0.1, 0.09]).range(1, 2), 10) * 0.1;
	storm = HPF.ar(storm, 100);
	CombC.ar(storm, 2, 2, 10) * 0.3;
};
)

~sin = {SinOsc.ar([100, 199])};
~sin = {SinOsc.ar([150, 151])};
~sin = {SinOsc.ar([215, 300])};
~sin = {SinOsc.ar([1150, 1000])};
~sin = {SinOsc.ar([5150, 5000])};
~saw = {Lag.ar(LFSaw.ar([0.4, 0.2], 0.1))};
~saw = {Lag.ar(LFSaw.ar([2, 1]), 0.01)};
~saw = {Lag.ar(LFSaw.ar([2.5, 1.3]), 0.01)};