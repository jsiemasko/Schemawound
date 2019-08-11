//http://schemawound.tumblr.com/post/23586814450/supercollider-tweets
{CombC.ar(Klang.ar(`[[100,101,1000,1001]],1,0)*0.1,1.33,LFTri.ar(0.3, 0, 0.1, 0.71)+LFTri.ar(0.7, 0, 0.1, 0.52),10)!2}.play;
{CombC.ar(Klang.ar(`[[100,101,1000,1001]],1,0)*0.1,0.33,LFTri.ar(0.1, 0, 0.1, 0.11)+LFTri.ar(0.17, 0, 0.1, 0.22),10)!2}.play;
{CombC.ar(Mix(SinOsc.ar((1..20)*6.12))*SinOsc.ar([SinOsc.ar(15.4,0,20),SinOsc.ar(1.9,0,37)])*SinOsc.ar([500,400]),1,0.01,10)*0.01}.play
{CombC.ar(Mix(SinOsc.ar((1..20)*145.12))*SinOsc.ar([SinOsc.ar(0.14,0,40),SinOsc.ar(0.19,0,37)])*SinOsc.ar([0.023,0.012]),1,0.1,10)*0.09}.play
{(CombC.ar([Mix(SinOsc.ar((40..50)*7.23,(1..10)/10)),Mix(SinOsc.ar((40..50)*6.41,(1..10)/10))],10,SinOsc.ar(0.0001,0,10),2)*0.02)}.play
play{a=Mix(Array.fill(75,{|i|SinOsc.ar(rrand(1,50)*i+10,0,LFNoise1.kr([1.8,2.3]))}))*0.02;CombL.ar(a,15,SinOsc.ar([0.1,0.11],0,0.5,0.6),10)}
{CombC.ar(GrainFM.ar(2,Impulse.kr(LFTri.kr(0.08,0,10,10)),0.1,LFTri.kr(0.04,0,40,400),500,LFNoise1.kr.range(1,10),0,-1),0.3,3,5)}.play;

//http://schemawound.tumblr.com/post/25584334028/supercollider-tweets-2
fork{y=[Blip,Saw,Pulse,SinOsc];loop{x=play{z=_.ar(rand(2000));z.(y.choose)*z.(y.choose)!2*0.4};(rand(0.2)+0.05).wait;x.free;}}
fork{y=[Blip,Saw,Pulse,SinOsc];loop{x=play{z=_.ar(rand(999));z.(y.choose)*z.(y.choose)*z.(y.choose)!2};(rand(0.1)+0.05).wait;x.free;}}
play{x=FreeVerb;y=SinOsc;DFM1.ar(x.ar(x.ar(GVerb.ar(Dust.ar(9),10,3,0.5),1,1)*y.ar(60),1,1)*y.ar(150),y.kr([0.1,0.17]).range(900,9999))}
g=SinOsc;w=FlowView(nil,Rect(90,90,305,55)).front;16.do{|x|Button(w).action_{play{g.ar(x+1*200)*g.ar(70)*EnvGen.ar(Env.perc(0,1))/2}}}

//http://schemawound.com/post/35775153718/supercollider-tweets-3
play{x={|a,b,c|Pulse.kr(a).range(b,c)};(Blip.ar(x.(0.87,4,80)*x.(1.7,1,10)*x.(1.13,1,10))*SinOsc.ar(LFTri.ar(0.006,0,9999)))*SinOsc.ar(50)}
Pspawner{|sp|6.do{|i|sp.par(Pbind(*[degree:Pseq(((0..i)*2),inf),octave:7-i,dur:0.2*(2**i)]))};sp.seq}.trace.play //#supercollider #sc140
‎{h={|f|1-LFTri.ar(f)};l={|s,e|Line.ar(s,e,1200,1,0,2)};FreeVerb.ar(h.(l.(147,5147))*h.(l.(1117,17))*h.(100)*h.([55,55.1])*0.05,0.7,1)}.play
{t=Mix.fill(3,{|i|SinOsc.ar(1000+(i*70))})/8;t=Streson.ar(t,SinOsc.kr(0.1).range(0.1,1),1);t=CombN.ar(t,30,0.7,30)+t;t=t!2 * 0.05}.play

//Individual Posts
play{a=SinOsc;y=CombC.ar(Dust.ar(1),1,a.ar(0.01,0,2e-3,3e-3),30,1);z=CombC.ar(y,1,[0.2,0.3],30,1,y);SelectX.ar(a.ar(0.1),[z,z*a.ar(99)])/2} //12/31/15

//Not Blogged
play{x=Saw;y=SinOsc;GVerb.ar((x.ar([10,9])*x.ar([20,19])**x.ar([28,35]*x.ar(4)/4+0.25)/9).clip(-1,1)*y.ar(y.ar(0.1,0,300,400)))/4} // #sc3 //11/27/12 Metal
play{x=Saw;y=SinOsc;GVerb.ar((x.ar([100,700])*x.ar([200,400])**x.ar([208,305]*x.ar(8)/4+0.25)/9).clip(-1,1)*y.ar(y.ar(0.1,0,3000,400)))/4} //11/27/12 More Metal
{((SmoothDecimator.ar(Saw.ar([4e3,4054],0,0.2),LFTri.kr(0.01,1e3,1e3).abs)**Saw.ar(400))**Saw.ar(2e3)).clip(-0.5,0.5)}.play //11/29/12 - broken atari
Pspawner{|p|x={|y|Pbind(*[dur:0.5+(y*0.005),midinote:Pseq([0,4,7]+(y*12)%120,inf)])};12.do{|y|p.par(x.(y))};p.seq;}.play #supercollider  //11/30/12 - many phase
q={|f,e|a=Array.fill(e,{|j|e-j}).reverse;(Mix.ar(a.collect{|x|SinOsc.ar(f*x,0,1/x)})/2)!2};{q.(60,300)}.play //saw from sine #supercollider
x={|y|LFSaw.ar([1+(y/100),1+(y+1/100)])*SinOsc.ar([y*43,y+1*27])};a=SinOsc.ar(0);((1..100)*5-1).do{|z|{x.(z)/100}.play;}
play{VarSaw.ar(LFPulse.kr([0.3,0.2],0,0.3,200,200),0,LFTri.kr([0.1,0.4],0,0.5,0.5))}//X/Y scope this #sc140 #supercollider //03/01/14 - Reading Rainbow
play{o=LFSaw.ar([0.4,0.3]);x=GVerb.ar(LFSaw.ar(60)*EnvGen.ar(Env.perc(0,0.1),[o>0,o<0]),5,5)*0.08;CombC.ar(x,0.2,[0.02,0.015],15,1,x)/2;} //03/04/14
{x=SinOsc.ar([250,50])*SinOsc.ar(200)*SinOsc.ar([1,0.3])*Pulse.ar([1.4,0.7]/2);GVerb.ar(CombC.ar(x,1,[0.7,0.5],1,1,x),300,3)/99;}.play //07/29/14
play{x=Saw.ar([0.7,0.03]).range(97,100);GVerb.ar(SinOsc.ar(x)*SinOsc.ar(x*1.7)*SinOsc.ar([x*1.3,x*1.9]),106,15)*0.02} #supercollider #sc140 //07/29/14
play{x=LFSaw.ar([0.3,0.6])*LFSaw.ar([1,1.5])*SinOsc.ar([440,220]*LFPulse.kr(0.12).range(1,2));CombC.ar(x,0.5,0.5,9,0.5,x)/12} //12/12/14
{i=Impulse;d=Demand;q=Drand(((3..24))*100,inf);CombC.ar(PMOsc.ar(d.kr(i.kr(2.25),0,q),d.kr(i.kr(1)*[0.5,2],0,q),5),1,[0.2,0.25],3)/20}.play //1/07/16
{x=Mix.ar(SinOsc.ar((5..25)*(10..1)*SinOsc.ar(0.1).range(1.9,3),0,SinOsc.ar((1..10)/9,0,(3..1)/3)))/20!2;CombC.ar(x,1,1,9,1,x)}.play //3/2/16

//Super Clip
fork{x={Klang.ar(`(Array.fill(20,{[500.rand,1.0.rand,2pi.rand]})))};loop{play{x.()*x.()*x.()*EnvGen.kr(Env.linen(0.1,0,1,0.1))!2};1.wait}}
//Need Input
play{a=15;b=15;c=100;x=SoundIn.ar([0,1]);y=x;a.do{|i|y=y+(CombL.ar(x,3,(i+1)/b,3)/(a-i))};y*SinOsc.ar(c)} //FX For BassGuitar #Supercollider
//Uses Mouse
play{Mix.ar(SinOsc.ar(MouseY.kr([100,150],[800,790]))*SinOsc.ar((60..115)*MouseX.kr([0.001,0.1],[3,4])))*0.015} // #Supercollider
play{x=Dseq((5..20)*50,inf);y={|a|SinOsc.ar(Demand.kr(Impulse.kr(a),0,x))};y.(MouseY.kr(1,7))*y.(MouseX.kr(1,7))*SinOsc.ar([990,600])}

Ndef(\a).fadeTime_(15).play;fork{loop{Ndef(\a,{Klank.ar(`[9.collect{[5000.0.rand,5000.0.rand]},nil,1!4],PinkNoise.ar(7e-3))/3});9.wait}} //Endless drone generator 11/20/14