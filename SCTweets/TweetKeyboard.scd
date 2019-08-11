//An attempt to fit a simple GUI in a tweet
//Careful, synths do not release

g=SinOsc;w=FlowView(nil,Rect(90,90,305,55)).front;16.do{|x|Button(w).action_{play{g.ar(x+1*200)*g.ar(70)*EnvGen.ar(Env.perc(0,1))/2}}}