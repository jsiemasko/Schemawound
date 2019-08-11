(
{
	var numOfSines = 20;
	var spread = 40;
	Mix(
		Array.fill(
			numOfSines,
			{
				arg i;
				var ampCont;
				ampCont = max(0, LFNoise1.kr(5));
				SinOsc.ar(spread * (i + 1), mul: ampCont);
			}
		)
	) * 0.1
}.play;
)