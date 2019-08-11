//6 channel output hook to first 6 in's in Reaper project.  Record on 3 tracks.

(
//-=-=-=-=-=-=-= SETUP =-=-=-=-=-=-=-
p.pop;
//Using v to store all my variables so that I can modify the code between runs
v = ();
v.songLength = 500;  //15 minutes
v.baseTone = 55 + 50.0.rand; //Base tone of the piece can be between 55 and 105
v.lfoRatio = 8.collect{1 + 0.9.rand}; //LFOs can vary up to 1.9 time normal speed
p = ProxySpace.push(s);
~out.play(numChannels:6);
)

(
//-=-=-=-=-=-=-= PARTS =-=-=-=-=-=-=-
//---------OUT---------
/*~out = {
	var tweaksAmp = 1;
	var bassAmp = 1;
	var bass = Compander.ar(HPF.ar(~bass.ar, 50), HPF.ar(~bass.ar), 50, 0.5, 1, 1/30) * 0.05 * bassAmp;
	var source = (~tweaks.ar * tweaksAmp) + bass;
	var loFilt = HPF.ar(source, 50);
	var comp = Compander.ar(loFilt, loFilt, 0.5, 1, 1/30);
	var clip = (comp * 0.3);
	var comp2 = Compander.ar(clip, clip, 0.5, 1, 1/30);
	CombC.ar(comp2, 1, 1, 10, 1, comp2) * 0.5;
};*/

~out = {
	var bass = Compander.ar(HPF.ar(~bass.ar, 50), HPF.ar(~bass.ar), 50, 0.5, 1, 1/30) * 0.001;
	var tweaks = HPF.ar(~tweaks.ar,50) * 0.02;
	var high = HPF.ar(~high.ar,50) * 0.02;
	[bass[0], bass[1], tweaks[0], tweaks[1], high[0], high[1]];
};

//---------BASS---------
v.bassPat = Array.new();
~bass.fadeTime_(40);

v.bassPat = v.bassPat.add({
	var loTone = SinOsc.ar(v.baseTone)!2 * 4;
	'v.bassPat[0] - '.post;
	loTone;
});

v.bassPat = v.bassPat.add({
	var loTone = SinOsc.ar(v.baseTone) * LFSaw.ar(SinOsc.kr(0.01 * [v.lfoRatio[6], v.lfoRatio[7]]).range(600,[900,1000])) * 0.5 + SinOsc.ar(v.baseTone * 0.9) *0.8;
	'v.bassPat[1] - '.post;
	loTone;
});

v.bassPat = v.bassPat.add({
	var loTone = SinOsc.ar(v.baseTone) * LFSaw.ar(SinOsc.kr(0.01 * [v.lfoRatio[6], v.lfoRatio[7]]).range(60,[90,100])) * 0.5 + SinOsc.ar(v.baseTone * 0.9) *0.8;
	'v.bassPat[2] - '.post;
	loTone;
});

v.bassPat = v.bassPat.add({
	var loTone = GVerb.ar(SinOsc.ar(v.baseTone) * LFSaw.ar(SinOsc.kr(0.01 * [v.lfoRatio[6], v.lfoRatio[7]]).range(60,[90,100])) * 0.5 + SinOsc.ar(v.baseTone * 0.9)) * 0.4 + SinOsc.ar(v.baseTone);
	'v.bassPat[3] - '.post;
	loTone;
});

v.bassPat = v.bassPat.add({
	var loTone = GVerb.ar(SinOsc.ar(v.baseTone) * LFSaw.ar(SinOsc.kr(0.01 * [v.lfoRatio[6], v.lfoRatio[7]]).range(600,[900,1000])) * 0.5 + SinOsc.ar(v.baseTone * 0.9), 5) * 0.4 + SinOsc.ar(v.baseTone);
	'v.bassPat[4] - '.post;
	loTone;
});

v.bassPat = v.bassPat.add({
	var loTone = GVerb.ar(SinOsc.ar(v.baseTone) ** LFSaw.ar(SinOsc.kr(0.01 * [v.lfoRatio[6], v.lfoRatio[7]]).range(600,[900,1000])) * 0.5 + SinOsc.ar(v.baseTone * 0.9), 5) * 0.4 + SinOsc.ar(v.baseTone) * 0.2;
	'v.bassPat[5] - '.post;
	loTone;
});

v.bassPat = v.bassPat.add({
	var loTone = GVerb.ar(SinOsc.ar(v.baseTone) ** LFSaw.ar(SinOsc.kr(0.1 * [v.lfoRatio[6], v.lfoRatio[7]]).range(60,[90,100])) * 0.5 + SinOsc.ar(v.baseTone * 0.9), 5) * 0.8 * SinOsc.ar(v.baseTone * 7.5) + SinOsc.ar(v.baseTone) * 0.2;
	'v.bassPat[6] - '.post;
	loTone;
});

//---------TWEAKS---------
v.tweaksPat = Array.new();
~tweaks.fadeTime_(30);

v.tweaksPat = v.tweaksPat.add({
	var crackleLFO = LFTri.ar([0.1 * v.lfoRatio[0], 0.17 * v.lfoRatio[1]], 0).range(0.9, 2);
	var crackle = Crackle.ar(crackleLFO, 0.5);
	var comb1LFO = LFTri.ar([0.14 * v.lfoRatio[2], 0.19 * v.lfoRatio[3]], 0, 0.5, 0.5);
	var comb1 = CombC.ar(crackle, 2, comb1LFO, 4, 1, crackle);
	var comp = Compander.ar(comb1, comb1, 0.3, 1, 1/30);
	var comb2LFO = SinOsc.ar(0.0675 * v.lfoRatio[5]).range(0.9, 1.2);
	var comb2LoOsc = SinOsc.ar(v.baseTone + SinOsc.ar(0.0765 * v.lfoRatio[4]).range(-2, 2));
	var verbLine = Line.kr(0.1, 10, 100);
	var verb = GVerb.ar(comp, verbLine, 10);
	var comb2 = CombC.ar(verb * comb2LoOsc, 2, comb2LFO, 4, 1, verb);
	'v.tweaksPat[0] - '.post;
	comb2 * 3;
});

v.tweaksPat = v.tweaksPat.add({
	var crackleLFO = LFTri.ar([0.1 * v.lfoRatio[0], 0.17 * v.lfoRatio[1]], 0).range(0.9, 2);
	var crackle = Crackle.ar(crackleLFO, 0.5);
	var comb1LFO = LFTri.ar([0.14 * v.lfoRatio[2], 0.19 * v.lfoRatio[3]], 0, 0.5, 0.5);
	var comb1 = CombC.ar(crackle, 2, comb1LFO, 4, 1, crackle);
	var comp = Compander.ar(comb1, comb1, 0.3, 1, 1/30);
	var comb2LFO = SinOsc.ar(0.0675 * v.lfoRatio[5]).range(0.9, 1.2);
	var comb2LoOsc = SinOsc.ar(v.baseTone + SinOsc.ar(0.0765 * v.lfoRatio[4]).range(-2, 2));
	var verbLine = Line.kr(1, 10, 100);
	var verb = GVerb.ar(comp, verbLine, 30);
	var comb2 = CombC.ar(verb * comb2LoOsc, 2, comb2LFO, 4, 1, verb);
	'v.tweaksPat[1] - '.post;
	comb2 * 2;
});

v.tweaksPat = v.tweaksPat.add({
	var crackleLFO = LFTri.ar([0.1 * v.lfoRatio[0], 0.17 * v.lfoRatio[1]], 0).range(0.9, 2);
	var crackle = Crackle.ar(crackleLFO, 0.5);
	var comb1LFO = LFTri.ar([0.14 * v.lfoRatio[2], 0.19 * v.lfoRatio[3]], 0, 0.5, 0.5);
	var comb1 = CombC.ar(crackle, 2, comb1LFO, 4, 1, crackle);
	var comp = Compander.ar(comb1, comb1, 0.3, 1, 1/30);
	var comb2LFO = SinOsc.ar(0.0675 * v.lfoRatio[5]).range(0.9, 1.2);
	var comb2LoOsc = SinOsc.ar(v.baseTone + SinOsc.ar(0.0765 * v.lfoRatio[4]).range(-2, 2));
	var verbLine = Line.kr(5, 10, 100);
	var verb = GVerb.ar(comp, verbLine, 30);
	var comb2 = CombC.ar(verb * comb2LoOsc, 2, comb2LFO, 4, 1, verb);
	'v.tweaksPat[2] - '.post;
	comb2 * 4;
});

v.tweaksPat = v.tweaksPat.add({
	var crackleLFO = LFTri.ar([0.1 * v.lfoRatio[0], 0.17 * v.lfoRatio[1]], 0).range(0.9, 2);
	var crackle = Crackle.ar(crackleLFO, 0.5);
	var comb1LFO = LFTri.ar([0.14 * v.lfoRatio[2], 0.19 * v.lfoRatio[3]], 0, 0.5, 0.5);
	var comb1 = CombC.ar(crackle, 2, comb1LFO, 4, 1, crackle);
	var comp = Compander.ar(comb1, comb1, 0.3, 1, 1/30);
	var comb2LFO = SinOsc.ar(0.0675 * v.lfoRatio[5]).range(0.9, 1.2);
	var comb2LoOsc = SinOsc.ar(v.baseTone + SinOsc.ar(0.0765 * v.lfoRatio[4]).range(-2, 2));
	var verbLine = Line.kr(5, 10, 100);
	var verb = GVerb.ar(comp, verbLine, 30);
	var comb2 = CombC.ar(verb * comb2LoOsc, 2, comb2LFO / 10, 4, 1, verb);
	'v.tweaksPat[3] - '.post;
	comb2 * 2;
});

v.tweaksPat = v.tweaksPat.add({
	var crackleLFO = LFTri.ar([0.1 * v.lfoRatio[0], 0.17 * v.lfoRatio[1]], 0).range(0.9, 1);
	var crackle = Crackle.ar(crackleLFO, 0.5);
	var comb1LFO = LFTri.ar([0.14 * v.lfoRatio[2], 0.19 * v.lfoRatio[3]], 0, 0.5, 0.5);
	var comb1 = CombC.ar(crackle, 2, comb1LFO, 4, 1, crackle);
	var comp = Compander.ar(comb1, comb1, 0.3, 1, 1/30);
	var comb2LFO = SinOsc.ar(0.0675 * v.lfoRatio[5]).range(0.9, 1.2);
	var comb2LoOsc = SinOsc.ar(v.baseTone + SinOsc.ar(0.0765 * v.lfoRatio[4]).range(-2, 2));
	var verbLine = Line.kr(5, 10, 100);
	var verb = GVerb.ar(comp, verbLine, 30);
	var comb2 = CombC.ar(verb * comb2LoOsc, 2, comb2LFO / 10, 4, 1, verb);
	'v.tweaksPat[4] - '.post;
	comb2 * 5;
});

v.tweaksPat = v.tweaksPat.add({
	var crackleLFO = LFTri.ar([10 * v.lfoRatio[0], 17 * v.lfoRatio[1]], 0).range(0.9, 1.5);
	var crackle = Crackle.ar(crackleLFO, 0.5);
	var comb1LFO = LFTri.ar([14 * v.lfoRatio[2], 19 * v.lfoRatio[3]]).range(1, 2);
	var comb1 = CombC.ar(crackle, 2, comb1LFO, 4, 1, crackle);
	var comp = Compander.ar(comb1, comb1, 0.3, 1, 1/30);
	var comb2LFO = SinOsc.ar(0.0675 * v.lfoRatio[5]).range(0.9, 1.2);
	var comb2LoOsc = SinOsc.ar(v.baseTone + SinOsc.ar(0.0765 * v.lfoRatio[4]).range(-2, 2));
	var verbLine = Line.kr(0.1, 1, 100);
	var verb = GVerb.ar(comp, verbLine, 30);
	var comb2 = CombC.ar(verb * comb2LoOsc, 2, comb2LFO / 10, 4, 1, verb);
	'v.tweaksPat[5] - '.post;
	comb2 * 5;
});

//---------HIGH---------
v.highPat = Array.new();
~high.fadeTime_(30);
)

(
//-=-=-=-=-=-=-= JOB =-=-=-=-=-=-=-
fork{
	var pos = 0;
	30.do{''.postln};
	('v.baseTone: ' ++ v.baseTone).postln;
	('LFO Ratio: ' ++ v.lfoRatio).postln;
	while({pos < v.songLength},{
		var patLen = (20.rand + 42);
		if(((pos + patLen) > v.songLength), {patLen = (v.songLength - pos)});
		('Pos: ' ++ pos ++ ' - ').post;
		if(((0.7.coin) || (pos == 0)) , {~tweaks = v.tweaksPat.choose}); // 70% chance of change, always change on first beat
		if(((0.7.coin) && (pos >= 150)), {~bass = v.bassPat.choose}); // 70% chance of change, Doesn't start until 150
		('Waiting:' ++ patLen).postln;
		(patLen).wait;
		pos = pos + patLen;
	});
	~out.clear(3);
	'Done'.postln;
}
)



//-=-=-=-=-=-=-= WORKSPACE =-=-=-=-=-=-=-

//Test individual bass patterns
~bass.fadeTime_(0); ~bass = v.bassPat[2]
v.bassPat.size

//Test individual tweak patterns
~tweaks.fadeTime_(0); ~tweaks = v.tweaksPat[5];
v.tweaksPat.size

~high.fadeTime_(0); ~high = v.highPat[0];
v.highPat.size

(
~high = {
	HPF.ar(SinOsc.ar(v.baseTone * 10), 50) * EnvGen.ar(Env.perc(0.001, SinOsc.ar(0.02).range(0.01, 0.5)), Impulse.ar(1.3))!2;
};
)