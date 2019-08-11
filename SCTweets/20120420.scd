{CombC.ar(Mix(SinOsc.ar((1..20)*6.12))* SinOsc.ar([SinOsc.ar(15.4,0,20),SinOsc.ar(1.9,0,37)])* SinOsc.ar([500,400]),1,0.01,10)*0.01}.play

{CombC.ar(Mix(SinOsc.ar((1..20)*145.12))* SinOsc.ar([SinOsc.ar(0.14,0,40),SinOsc.ar(0.19,0,37)])* SinOsc.ar([0.023,0.012]),1,0.1,10)*0.09}.play

{(CombC.ar([Mix(SinOsc.ar((40..50)*7.23,(1..10)/10)),Mix(SinOsc.ar((40..50)*6.41,(1..10)/10))],10,SinOsc.ar(0.0001,0,10),2)*0.02)}.play