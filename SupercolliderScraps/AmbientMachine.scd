(
s.waitForBoot{
	/* Start user values */
	var path = PathName.new("C:/test"); //Path to directory of WAV files.
	var debug = 0; // 0 = No debug info, 1 = Post debug info to the post window. May affect performance.
	var fadeTime = 0.3; //Time to fade between samples, 0 is no fade.
	var loopTime = 0.6; //Time to play a sample before switching. If FAILURE IN SERVER messages appear in the post window try to increase this setting.  Use care, you may be able to lock up your machine by setting this too low. On my test machine the lowest I could get with no glitches was 0.1 with debug off and 0.3 with it on.
	var delayAmp = 0.3; // 0 = No delay, 1 = Full delay
	var delayLength = 1; //Delay length, current max is 3. Use care with very small values.
	var delayDecay = 10; //Decay time for delay
	var numSlices = 1280; //sample will be randomly broken into this many pieces to pick where to start playing from. Set to 1 to always start at the begining. The higher the number, the smaller the slices the greater the chance that a slice hits the end of the file
	var amp = 0.5; //master volume.  0.5 is a good starting point.  Reduce it if you get clipping.
	var compThreshold = 0.2;
	var compAmount = 1/90; //compThreshold and compAmount set the values for the compressor.  1/90 amount is equal to 1:90 compression which is a batshit crazy number I put in just because my test field recordings were all over the place.  Feel free to adjust to taste.
	var baseRate = 0.8;
	var randRate = 0.4; //every time a sample is plays a random value between 0 and randRate is picked and added to baseRate.  I picked 0.4 and 0.8 as defaults, this gives you a rate between 0.8 and 1.2.  A rate of 1 is normal playback.
	/* End user values */

	var source, buffers;
	source = path.files.collect{|file| file.fullPath};
	Buffer.freeAll;
	b = buffers = source.collect{|source| Buffer.read(s, source)};
	p.pop;
	p = ProxySpace.push(s);
	~out.play;
	~samples.fadeTime_(fadeTime);
	s.sync;
	~out = {
		var comp = Compander.ar(~samples.ar, ~samples.ar, compThreshold, 1, compAmount);
		var comb = CombC.ar(comp * delayAmp, 3, delayLength, delayDecay, 1, comp);
		comb * amp;
	};
	loop{
		~samples= {
			var buffer = b.choose;
			var sliceSize = buffer.numFrames / numSlices;
			var offset = (sliceSize * numSlices.rand).round;
			var rate = randRate.rand + baseRate;
			if((debug == 1), {
				"Num: ".post; buffer.bufnum.post;
				" Rate: ".post; rate.post;
				" Frames: ".post; buffer.numFrames.post;
				" Offset: ".post; offset.post;
				" Channels: ".post; buffer.numChannels.post;
				" Sample Rate: ".post; buffer.sampleRate.post;
				" Path: ".post; buffer.path.postln;
			});
			if(buffer.numChannels == 2,
				{PlayBuf.ar(2, buffer, rate, 1, offset, 0)},
				{PlayBuf.ar(1, buffer, rate, 1, offset, 0)!2}
			);
		};
		loopTime.wait;
	};
}
)
