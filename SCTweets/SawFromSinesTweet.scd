q={|f,e|a=Array.fill(e,{|j|e-j}).reverse;(Mix.ar(a.collect{|x|SinOsc.ar(f*x,0,1/x)})/2)!2};{q.(60,300)}.play //saw from sine #supercollider

//Change the values passed to q to control the frequency and how many sines are used.