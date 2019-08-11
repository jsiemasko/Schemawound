/*
Autumn Moonlight-
By Schemawound - http://www.schemawound.com/
All code by Jonathan Siemasko

Created for The Haiku Project by Subterranean Tide - http://www.subterraneantide.com/haiku.html
Description: Each artist has contributed a three track release in increments of five minutes, seven minutes, and five minutes accompanied by a Haiku poem.  Each song represents the line of the poem including title and reflection.
Source Haiku:

Autumn moonlight—

a worm digs silently

into the chestnut.

	- Basho Matsuo
*/

(
{
	FreeVerb.ar(
	SinOsc.ar(SinOsc.kr(0.01).range(60, [600, 500]))
	*
	SinOsc.ar(LFSaw.kr(SinOsc.ar(0.0354).range(0.001, [10, 7])).range(7, 9) * LFSaw.kr(0.215).range(6, 8))
	*
	SinOsc.ar(LFSaw.kr(SinOsc.ar(0.01).range(0.01, [1, 0.7])).range(4, 30) * LFSaw.kr(0.1215).range(4, 30))
	*
	LFTri.ar(SinOsc.kr(0.043).range(3, [30, 35]))
	*
	LFTri.ar(SinOsc.kr(0.033).range(30, [300.1, 300.14]))
	, 0.3, 10) * 0.25
}.play
)