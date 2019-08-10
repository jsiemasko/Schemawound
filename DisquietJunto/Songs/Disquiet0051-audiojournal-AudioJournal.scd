/*
AudioJournal by Jonathan Siemasko
http://www.schemawound.com/

Inspired by Disquiet Junto project 0051: http://disquiet.com/2012/12/20/disquiet0051-audiojournal/

This code will take 12 files (one representing each month) and make a chronological mix of random sections of each piece.

INSTRUCTIONS:
Set audiojournal to a location on your harddrive containing WAV files with the following 12 names: 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
WAV files must be stereo.
*/

(
{
	var audiojournal =  = 'C:/AudioJournal/';
	var fileFormat = 'wav';  //File extension
	var seconds = 5; //Seconds each file segment will last
	var monthFileNames, monthBuf = Array.newClear(12);
	var randSeed = 0; //Modify the random seed to try a different variation.  If you want a random run each time then comment out the line that states: "thisThread.randSeed = randSeed;"

	//-----SynthDefs-----

	SynthDef(\bufPlay2, {|out = 0, bufnum, gate = 1, rateScale = 1, amp = 1|
		var buf = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rateScale);
		var env = Linen.kr(gate, 0.01, 1, 0.01, doneAction: 2);
		Out.ar(out, buf * amp * env);
	}).add; //Stereo

	//-----Buffers-----
	monthFileNames = Array.with('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec');
	monthFileNames.do{|fileName, i| monthFileNames[i] = audiojournal ++ fileName ++ '.' ++ fileFormat}; //Expand to full filename and path
	monthFileNames.do{|fileName, i| monthBuf[i] = Buffer.read(s, monthFileNames[i], 0, -1)}; //Fill buffers so we can get the file sizes
	s.sync; //Sync to wait for the buffers to fill

	//-----Replace With Trimmed Buffers-----
	thisThread.randSeed = randSeed;
	monthBuf.do{|buf, i|
		var samples = seconds * s.sampleRate;
		var maxStartFrame = buf.numFrames - samples; //Ensure we do not run past the end of the buffer
		var newBuf;
		//If the file is smaller then the requested size then just the use the whole file.
		if ((buf.numFrames <= samples),
			{newBuf = Buffer.read(s, monthFileNames[i], 0, -1)},
			{newBuf = Buffer.read(s, monthFileNames[i], maxStartFrame.rand, samples)}
		);
		//Clear the current buffer and replace with the trimmed buffer
		monthBuf[i].free;
		monthBuf[i] = newBuf;
	}; //Get file sizes and free the buffers
	s.sync; //Wait for the new buffers to fill

	//-----Display-----
	3.do{''.dopostln};
	'-----BUFFERS-----'.postln; monthBuf.dopostln;

	//-----Play-----
	Pbind(*[instrument: \bufPlay2, bufnum: Pseq(monthBuf), dur: seconds, sustain: Pkey(\dur), amp: 1]).trace.play;

	//-----Clean Up------
	CmdPeriod.doOnce{monthBuf.do{|buf, i| buf.free}};
}.fork
)
