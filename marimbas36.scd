(
SynthDef.new(\blip,{
	arg out, fund=300, dens=0.06, decay=0.06;
	var freq, trig, sig;
	freq=LFNoise0.kr(3).exprange(fund,fund*4).round(fund);
	sig=SinOsc.ar(freq)*0.25;
	trig=Dust.kr(dens);
	sig=sig*EnvGen.kr(Env.perc(0.01,decay), trig);
	sig=Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb,{
	arg in, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out,sig);
}).add;
);
//Groups
~sourceGrp=Group.new;
~fxGrp = Group.after(~sourceGrp);

//reverb
y=Synth.new(\reverb,[\in, ~reverbBus2], ~fxGrp);

//blip do loop
8.do{Synth.new(\blip,[\out, ~reverbBus2,\fund, exprand(300,930).round(8203)],~sourceGrp);};

//Controls's group
~sourceGrp.set(\decay, 0.03);
~sourceGrp.set(\dens, 0.03);
~sourceGrp.set(\fund,1585); //3000
/////////////////////////////////////
(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=1000, detune=0.2, pan=0, cfhzmin=0.1, cfhzmax=0.3,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2,
	lsf=200, ldb=0, amp=1, out=0;
	var sig, env;

	env =EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig =Saw.ar(freq*{LFNoise1.kr(0.5,detune).midiratio}!2);
	sig=BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig= BLowShelf.ar(sig, lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1],pan);
	sig = sig*env*amp;
	Out.ar(out, sig);

}).add;
);

(
~marimba=Pbind(
	\instrument, \bpfsaw,

	\dur, Pexprand(0.1,1),
	//other frequencies, more close = not this aurea frequency
	\freq, Pexprand(42,1,1),

	\detune, 1,

	//Chromatic
	\rqmin, 0.03,
	\rqmax, 0.008,

	\cfmin, 0.060,
	\cfmax, 15000, //30000 - 5000
	\amp, 1,
	\out, 0,
).play;
);

~marimba.stop;

(
~marimba2=Pbind(
	\instrument, \bpfsaw,
	\dur, Pexprand(0.1,1,inf),
	\freq, Pexprand(0.25,9,inf),
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, 150,
	\cfmax, 1500,
	\amp, 1,
	\out, 0,
).play;
);
~marimba2.stop;


(
~marimba3=Pbind(
	\instrument, \bpfsaw,
	\dur, Prand([1,0.5],inf),
	\freq, Prand([1/2,2/3,1,4/3,2,5/2,3,4,6,8],inf),
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, Prand((Scale.major.degrees+64).midicps,inf)*Prand([0.5,1,2,4],inf),
	\cfmax, Pkey(\cfmin),
	\atk,3,
	\sus, 1,
	\rel, 5,
	\amp, 1,
	\out, 0,
).play;
);
~marimba3.stop;

(
b = Buffer.alloc(s,512,1,{|z|z.sine1Msg(1.0/[1,3,5,7,9,11,13,15,17])});
c = Buffer.read(s,"/home/nehemias/Documents/SuperCollider/Marimbas Errantes/kaqchikel.aiff");

fork{
    s.sync;
~sound = {
    var sig;
    var local;
    var f = [30,60,15]*Lag.kr(TChoose.kr(Impulse.kr(0.05),[0.75, 0.5, 1]), 8);
    sig = Mix(COsc.ar(b.bufnum,f + SinOsc.ar(f*25, 0, LFTri.kr(0.01).range(0, 10)), [0.1, 0.1001, 0.2], 0.2))*0.1;
sig = sig;
sig = LeakDC.ar(Ringz.ar(sig, TChoose.kr(Impulse.kr(0.1),[88, 97, 99, 100].midicps), LFTri.kr([0.05, 0.051]).range(0.2, 0.5)));
sig = sig + Decimator.ar(sig, 48000*LFNoise0.kr(1).range(0.25, 1), TChoose.kr(Impulse.kr(4), [8, 12, 16, 24]), 0.4);
    sig = LPF.ar(sig, 3000*LFTri.kr(0.01).range(0.1, 1));
    sig = sig + (Splay.ar(Array.fill(4, {PlayBuf.ar(2, c, rrand(-0.8, 0.8), loop: 2)*0.01}), 0.5));
    sig = CombC.ar(sig, 1.0, [0.1, 0.2], LFTri.kr(0.05).range(5, 9));

    local = sig + LocalIn.ar(2);
    15.do({
            local = AllpassN.ar(local, 0.06, Rand(0.001, 0.06), 3)
          });
    LocalOut.ar(local*0.4);

    Out.ar(0, Limiter.ar(LPF.ar(local, 5000), 0.8)*EnvGen.kr(Env([0, 1, 1, 0],[3, 100, 10])));
	}.play;
}
);
//-----------------------effects-----------------------------------
(
SynthDef.new(\multi,{
	var sig, amp, env;
	env =EnvGen.kr(
		Env.new([0,1,0],[10,10],[1,-1]), doneAction:2
	);
	amp= SinOsc.kr({ExpRand(0.2,2)}!2).range(0,1);
	sig=SinOsc.ar({ExpRand(20,100)}!2);
	sig=sig*amp*env;
	sig=Splay.ar(sig)*0.5;
	Out.ar(0, sig);
}).add;
);

m=Synth.new(\multi);

(
SynthDef.new(\sine,{
	arg freq=440, atk=0.005, rel=0.3, amp=0.01, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel],[1,-1]),doneAction:2);
	sig = Pan2.ar(sig,pan,amp);
	sig=sig*env;
	Out.ar(0,sig);
}).add;
);

(
Pdef(
	\sinepat,
	Pbind(
		\instrument,\sine,
		\dur, Pwhite(0.05,0.5,inf),
		\midinote, Pseq([10.midicps,14.midicps,17.midicps],inf),
		\harmonic, Pexprand(9,300,inf).round,
		\atk, Pwhite(0.01,0.1,inf).trace,
		\rel, Pwhite(5.0,10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8,0.8,inf),
	);
).play;
);

// now play it
