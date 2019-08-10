/*
"Dawn" by Schemawound
Appears on the album "They Want To Make Your Body Move.  I Want To Hold You Perfectly Still."
Full album is available for download from http://www.schemawound.com

Code by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://www.schemawound.com/
*/

(
    {
        //-----Variables-----
        var mainout = 0;

        //-----SynthDefs-----
        SynthDef(\additivePad, { 
            |
                outbus = 0,     freq = 40,      amp = 1,    attack = 0.1,   decay = 0.1,    
                lfo0L = 0.5,    lfo0R = 0.5,    lfo1L= 0.1, lfo1R = 0.1,    lfo2L= 0.5,     lfo2R = 0.5
            |
            var syn, env, ampMod, output;
            var lfo2input = Array.new(2);
            var lfo = Array.new(3);
            lfo = lfo.add(SinOsc.kr([lfo0L, lfo0R]).range(0, 1));
            lfo = lfo.add(SinOsc.kr([lfo1L, lfo1R]).range(0, 1));
            lfo2input = lfo2input.add(lfo2L * lfo[0] * lfo[1]); //Left
            lfo2input = lfo2input.add((lfo2R * (1 - lfo[0])) * (1 - lfo[1])); //Right
            lfo = lfo.add(SinOsc.kr(lfo2input, 1.5pi).range(0, 1));
            env = EnvGen.kr(Env.perc(attack, decay), doneAction: 2);
            syn = SinOsc.ar(freq) * lfo[2];
            output = syn * env * amp;
            Out.ar(outbus, output);
        }).add; 

        //-----Sync-----
        Server.default.sync;

        //-----Patterns-----
        Pbind(*[instrument: \additivePad, 
            dur:        Pwhite(7, 11),
            amp:        0.1,
            freq:       Pseq([Pwhite(40, 100, 1), Pwhite(300, 1000, 3)], inf), //lo, hi, hi, hi
            lfo0L:      Pwhite(0.5, 400),   lfo0R:  Pwhite(0.5, 400),
            lfo1L:      Pwhite(0.1, 0.5),   lfo1R:  Pwhite(0.1, 0.5),
            lfo2L:      Pwhite(0.5, 200),   lfo2R:  Pwhite(0.5, 200),
            attack:     Pwhite(0.1, 30),    decay:  Pwhite(0.1, 30),
            outbus:     mainout
        ]).play;

    }.fork;
)
