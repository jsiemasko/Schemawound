{h={|f|1-LFTri.ar(f)};l={|s,e|Line.ar(s,e,1200,1,0,2)};FreeVerb.ar(h.(l.(147,5147))*h.(l.(1117,17))*h.(100)*h.([55,55.1])*0.05,0.7,1)}.play

(
{
	var hex = {|f| 1 - LFTri.ar(f)};
	var line = {|s,e| Line.ar(s,e,1200,1,0,2)};
	var hexes = hex.(line.(147,1147)) * hex.(line.(117,17)) * hex.(100) * hex.([55,55.1]) * 0.05;
	FreeVerb.ar(hexes, 0.7, 1)
}.play
)