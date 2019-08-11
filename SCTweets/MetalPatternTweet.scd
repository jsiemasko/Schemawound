play{x=Saw;y=SinOsc;GVerb.ar((x.ar([10,9])*x.ar([20,19])**x.ar([28,35]*x.ar(4)/4+0.25)/9).clip(-1,1)*y.ar(y.ar(0.1,0,300,400)))/4} // #sc3 //11/27/12 Metal
//Variation:
play{x=Saw;y=SinOsc;GVerb.ar((x.ar([100,700])*x.ar([200,400])**x.ar([208,305]*x.ar(8)/4+0.25)/9).clip(-1,1)*y.ar(y.ar(0.1,0,3000,400)))/4} //11/27/12 More Metal