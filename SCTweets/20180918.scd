({var t=PulseCount.ar(Impulse.ar(SinOsc.ar(0.007,0,200,2e3)));a=(t*5);b=(t>>[4,2]);d=(t*17);e=(t>>5);GVerb.ar(HPF.ar(([a|b,a&b]|[d|e,d&e])&255,20).tanh*0.015)}.play)
