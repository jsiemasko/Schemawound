Ndef(\a).fadeTime_(15).play;fork{loop{Ndef(\a,{Klank.ar(`[9.collect{[5000.0.rand,5000.0.rand]},nil,1!4],PinkNoise.ar(7e-3))/3});9.wait}}
