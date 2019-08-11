(
x={
	|a,b,c,d|
	Mix(SinOsc.ar((a..b)/c+d))
};
y = {|freq = 60|
	{(
		x.(160,200,600,freq * 0.2)
		*
		x.(10,20,700,freq * 0.4)
		*
		x.(80,100,800,freq * 0.7)
		*
		x.(1060,1111,900,freq)
	)!2 * 0.000001
	* Line.ar(1, 0, 2, doneAction:2)
	}.play
};
r = Routine { loop{y.(rand(700));(rand(1) + 0.5).yield;}};
r.play;
)