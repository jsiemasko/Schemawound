//My version of 440 1(+)
fork{i=0;g=1;inf.do({if(2.rand==1,{g=g * -1});play{SinOsc.ar(i*g+440)*EnvGen.kr(Env.linen(0.1,440-i,1,0.004))!2};1.wait;i=i+1})}