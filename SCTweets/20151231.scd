play{a=SinOsc;y=CombC.ar(Dust.ar(1),1,a.ar(0.01,0,2e-3,3e-3),30,1);z=CombC.ar(y,1,[0.2,0.3],30,1,y);SelectX.ar(a.ar(0.1),[z,z*a.ar(99)])/3}
