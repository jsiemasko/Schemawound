play{t=Impulse.kr(9);d=Demand.kr(t,0,Drand([0,2,4,7,9,12]+36,inf).midicps);e=EnvGen.ar(Env.perc(0,0.7,1),t);SyncSaw.ar(d,e*[400,300]+d,e)}