/*
2/26/13 - JMS -
Just a patch of "reverbed electric birds"  I had kicking around.  I like it but it is pretty directionless and unfocused at the moment.
*/

(({
	var grainCarFreq = SinOsc.kr([0.1, 0.12]).range([20, 50, 10], [100, 75, 20]) * SinOsc.kr(0.09).range(0.01, 200);
	var grainModFreq = SinOsc.kr([0.0012, 0.0025]).range([10, 5], [30, 35]);
	var dustFreq = SinOsc.kr([0.00051, 0.0006]).range([0.1, 0.2], [2, 2]);
	var grainDur = SinOsc.kr([0.08, 0.07]).range(0.001, 0.6);
	var grainIndex = SinOsc.kr([0.009, 0.01]).range(1, 5);
	var dustTrig = Dust.ar(dustFreq);
	var grains = (GrainFM.ar(1, dustTrig, grainDur, grainCarFreq, grainModFreq, grainIndex, 0, -1, 1500) * 1).distort;
	var verb = FreeVerb.ar(grains, 1, 1, 0) * 0.3;
	Out.ar([0,1], verb);
}).play;)
  