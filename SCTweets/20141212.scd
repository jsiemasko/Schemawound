play{x=LFSaw.ar([0.3,0.6])*LFSaw.ar([1,1.5])*SinOsc.ar([440,220]*LFPulse.kr(0.12).range(1,2));CombC.ar(x,0.5,0.5,9,0.5,x)/12}
