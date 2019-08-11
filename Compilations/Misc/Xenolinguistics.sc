(
	Routine.run {
		//Variables
		var deusBuf, poutBuf, pat = Array(10);

		//SynthDef
		SynthDef(\buffRepeaterMono) //Stero Buffer
		{
			|outBus = 0, buf, startPosModFreq = 10, minStartPos = 1, maxStartPos = 100, restartFreq = 5, gate = 1, amp = 1, rateMult = 1, fmModFreq = 440|
			var bufScale = BufRateScale.kr(buf) * rateMult;
			var imp = Impulse.ar(restartFreq);
			var startPosMod = SinOsc.kr(startPosModFreq).range(minStartPos, maxStartPos);
			var playBuf = PlayBuf.ar(1, bufnum: buf, rate: bufScale, trigger: imp, startPos: startPosMod);
			var linen = Linen.kr(gate, 0.01, amp, 0.01, doneAction:2);
			var fmMod = SinOsc.ar(fmModFreq);
			var output = playBuf * fmMod * linen;
			Out.ar(outBus, output);
		}.add;

		SynthDef(\buffRepeaterStereo) //Stero Buffer
		{
			|outBus = 0, buf, startPosModFreq = 10, minStartPos = 1, maxStartPos = 100, restartFreq = 5, gate = 1, amp = 1, rateMult = 1, fmModFreq = 440|
			var bufScale = BufRateScale.kr(buf) * rateMult;
			var imp = Impulse.ar(restartFreq);
			var startPosMod = SinOsc.kr(startPosModFreq).range(minStartPos, maxStartPos);
			var playBuf = PlayBuf.ar(2, bufnum: buf, rate: bufScale, trigger: imp, startPos: startPosMod);
			var linen = Linen.kr(gate, 0.01, amp, 0.01, doneAction:2);
			var fmMod = SinOsc.ar(fmModFreq);
			var output = playBuf * fmMod * linen;
			Out.ar(outBus, output);
		}.add;

		//Load Buffer
		deusBuf = Buffer.read(Server.default, ~schema.mediaDirectory ++ "16-Schemawound-My_Time_As_A_Rat-Deus_Ex_Machina.wav"); //Stereo
		poutBuf = Buffer.read(Server.default, ~schema.mediaDirectory ++ "pout - 000.wav"); //Mono
		
		//Sync Load
		Server.default.sync;

		//Play
		pat.add(//Pat 0 - Bass Loop - 16 len
			Pbind(*[instrument: \buffRepeaterStereo,
				amp:				0.8,
				dur:				1,
				sustain:			Pkey(\dur),
				buf:				deusBuf,
				minStartPos:		100,
				maxStartPos:		deusBuf.numFrames,
				startPosModFreq:	Pseq([10, 15, 10, 0.1, 50, 15, 10, 0.1], inf),
				restartFreq:		Pseq([5, 10, 10, 15, 5, 10, 10, 5, 5, 10, 10, 15, 5, 10, 10, 25], inf),
				rateMult:			0.9,
				fmModFreq:			Pseq([Pn(440,4),Pn(880,4)], 2)
			])
		);
		pat.add(//Pat 1 - Bass Loop - 16 len
			Pbind(*[instrument: \buffRepeaterStereo,
				amp:				0.8,
				dur:				1,
				sustain:			Pkey(\dur),
				buf:				deusBuf,
				minStartPos:		100,
				maxStartPos:		deusBuf.numFrames,
				startPosModFreq:	Pseq([10, 15, 10, 0.1, 50, 15, 10, 0.1], inf),
				restartFreq:		Pseq([5, 10, 10, 15, 5, 10, 10, 5, 5, 10, 10, 15, 5, 10, 10, 25] * 2, inf),
				rateMult:			0.9,
				fmModFreq:			Pseq([Pn(440,4),Pn(880,4)], 2)
			])
		);

		pat.add(//Pat 2 - High Loop - 16 len
			Pbind(*[instrument: \buffRepeaterStereo,
				amp:				0.15,
				dur:				0.1,
				sustain:			Pkey(\dur),
				buf:				deusBuf,
				minStartPos:		100,
				maxStartPos:		deusBuf.numFrames,
				startPosModFreq:	Pwhite(5, 20),
				restartFreq:		30,
				rateMult:			4,
				fmModFreq:			Pwhite(1000, 10000, 160)
			])
		);
		pat.add(//Pat 3 - Bass Loop - 16 len
			Pbind(*[instrument: \buffRepeaterMono,
				amp:				1,
				dur:				2,
				sustain:			Pkey(\dur),
				buf:				poutBuf,
				minStartPos:		1000,
				maxStartPos:		poutBuf.numFrames,
				startPosModFreq:	Pseq([5, 5, 4, 4, 5, 5, 6, 6], inf),
				restartFreq:		Pseq([5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 3, 4]),
				rateMult:			1,
				fmModFreq:			100
			])
		);

		pat[0].play;
		20.wait;
		pat[1].play;
		20.wait;
		pat[2].play;
		20.wait;
		pat[3].play;

		//Cleanup
		CmdPeriod.doOnce({
			deusBuf.free;
			poutBuf.free;
		});
	};
)