<CsoundSynthesizer>
<CsOptions>
-odac -iadc -+rtaudio=null -d
</CsOptions>
<CsInstruments>

;TO DO: finalise 'scale': a bit noisy on tempo change?
;add tempo-track to delay effect?
;file play: move to csound to enable overdubbiing to new file?? playback m4a?

;more trivial:
;pvscale bug? seems to add noise if used in signal flow a lot?
;try harmonic minor, more common? sharpened 7th...just move 7th up if recognised as opposed to putting it in scale.
;need to start record on click?: performer based test needed! 

ksmps = 256	  ;reduces any dropout
nchnls = 2

gistorage	ftgen	4, 0, 524288, -7, 0	;audio tab and globals

gklooplen init 0
gaout init 0
gawritel init 0
gawriter init 0
gipos init 0
gichrom init 0
gklooptype init 0

opcode Robotune, aa, akkkkkkkkkkkkk
asig, ksource, kcross, kscale, kkey, kmainlevel, kauto, kharm1, kharmlevel1, kharm1form, kharm2, kharmlevel2, kharm3, kharmlevel3 xin

if ksource == 2 kgoto end		;bypass

ksm = 0.0001		;hard tuning

ifftsize = 1024
iwtype = 1
ibase = 440
ibasemidi = 69

ktestnote init 0

; analyse
fsig pvsanal    asig, ifftsize, ifftsize / 4, ifftsize, iwtype

; pitch tracking, various options available
kfr, kamp ptrack asig, ifftsize

; don't let freq go below 20 Hz 
if (kfr > 20) kgoto ok
kfr = 440
ok:
; hz to midi
ktemp = 12 * (log(kfr / ibase) / log(2)) + ibasemidi
kmidi = round(ktemp)

; scale type
kscalech changed kscale

if (kscalech == 1) then
	if kscale == 0 kgoto majortab
	if kscale == 1 kgoto minortab
	if kscale == 2 kgoto scaleok

	majortab:
	tablew 4, 2, 3
	tablew 9, 5, 3
	tablew 11, 6, 3
	kgoto scaleok

	minortab:
	tablew 3, 2, 3
	tablew 8, 5, 3
	tablew 10, 6, 3
	kgoto scaleok

	scaleok:
endif

if (kscale == 0 || kscale == 1) then   ;change notes to scale (no need for chromatic)
	; get nearest position in chosen scale
	kpos init 0

	test:
	knote table kpos, 3  	; get a pitch class
	ktest = kmidi % 12 	; note mod 12
	knote = (knote + kkey) % 12

	if ktest == knote kgoto next 	; test if note matches pitch class + transposition
	kpos = kpos + 1 				; increment table pos
	if kpos >= 7 kgoto shift    	; if not in pitch class list, shift it up or down
	kgoto test 			     		; loop back

	shift:			; note up or down as required
	if (ktemp >= kmidi) kgoto plus
	kmidi = kmidi - 1
	kgoto next
	plus:
	kmidi = kmidi + 1
	next:
	kpos = 0
endif

; target frequency
ktarget = ibase * (2 ^ ((kmidi - ibasemidi) / 12))

; ratio to scale by
kratio = ktarget / kfr
kratioport portk kratio, ksm, 1 

if(kauto == 1 || kauto == 2) then		; automate harmonies...

	kharmtest = (kmidi - kkey) % 12	; back to C major for ease. 

	if (kscale == 0) then		; major
		if (kharmtest == 0 || kharmtest == 5 || kharmtest == 7) then
		kgoto major
		endif
		if (kharmtest == 2 || kharmtest == 4 || kharmtest == 9) then
		kgoto minor
		endif
		if (kharmtest == 11) then
		kgoto diminished
		endif
	endif

	if (kscale == 1) then		; minor
		if (kharmtest == 3 || kharmtest == 8 || kharmtest == 10) then
		kgoto major
		endif
		if (kharmtest == 0 || kharmtest == 5 || kharmtest == 7) then
		kgoto minor
		endif
		if (kharmtest == 2) then
		kgoto diminished
		endif
	endif

	if (kscale == 2) then
		kgoto power
	endif

	major:
	if (kauto == 1) then
		kharm1 = 4		;M3
		kharm2 = -12	;-oct
		kharm3 = -17	;--5
	endif

	if (kauto == 2) then	;high harms
		kharm1 = 7		;5
		kharm2 = 4		;M3
		kharm3 = -12	;-oct



	endif

	kgoto harmsend

	minor:
	if (kauto == 1) then
		kharm1 = 3		;m3		
		kharm2 = -12	;-oct
		kharm3 = -17	;--5
	endif

	if (kauto == 2) then	;high harms
		kharm1 = 7		;5
		kharm2 = 3		;m3
		kharm3 = -12	;-oct
	endif

	kgoto harmsend

	diminished:
	if (kauto == 1) then
		kharm1 = 3		;m3
		kharm2 = -12	;-oct
		kharm3 = -18	;--dim5	
	endif

	if (kauto == 2) then	;high harms
		kharm1 = 6		;5
		kharm2 = 3		;m3
		kharm3 = -12	;-oct
	endif

	kgoto harmsend

	power:	
	if (kauto == 1) then
		kharm1 = 7		;5		;power chords
		kharm2 = -12	;-oct
		kharm3 = -17	;--5
	endif

	if (kauto == 2) then	;high harms
		kharm1 = 7		;5
		kharm2 = 12		;m3
		kharm3 = -12	;-oct
	endif

	kgoto harmsend

	harmsend:

	chnset kharm1, "harm1send"
	chnset kharm2, "harm2send"
	chnset kharm3, "harm3send"

endif

kharmlevel1 port kharmlevel1, 0.1
kharmlevel2 port kharmlevel2, 0.1
kharmlevel3 port kharmlevel3, 0.1
kmainlevel port kmainlevel, 0.1

kharm1chng changed kharm1
kharm2chng changed kharm2
kharm3chng changed kharm3  

if ksource == 0 kgoto clean
if ksource == 1 kgoto robo

clean:
fauto pvscale fsig, kratioport, 1		;transpose 
if abs(kharm1) > 0 then
	if kharm1chng == 1 then
		kscl1 = 2 ^ (kharm1 / 12)
	endif
	fharm1 pvscale fsig, kratioport * kscl1, kharm1form	;formant option
endif

if abs(kharm2) > 0 then	
	if kharm2chng == 1 then
		kscl2 = 2 ^ (kharm2 / 12)
	endif
	fharm2 pvscale fsig, kratioport * kscl2
endif

if abs(kharm3) > 0 then
	if kharm3chng == 1 then
		kscl3 = 2 ^ (kharm3 / 12)
	endif
	fharm3 pvscale fsig, kratioport * kscl3
endif 
kgoto resynth 

robo:		; cross synth tuned vocoder type effect
kcross port kcross, 0.1	; smooth changes    
    
abuzz buzz 30000 * ampdb(kamp), ktarget, 50, 1		;buzz source
fbuzz pvsanal    abuzz, ifftsize, ifftsize / 4, ifftsize, iwtype
; cross synthesis: voice to buzz, freqs of buzz, amps of voice, amps can be mix of both...
fauto pvscross fbuzz, fsig, kcross, 1. - kcross

if abs(kharm1) > 0 then
	if kharm1chng == 1 then
		kscl1 = 2 ^ (kharm1 / 12)
	endif
	fauto1 pvscross fbuzz, fsig, kcross, 1. - kcross	;why need to do this? noise if not!!
	fharm1 pvscale fauto1, kscl1, 1
endif
if abs(kharm2) > 0 then
	if kharm2chng == 1 then
		kscl2 = 2 ^ (kharm2 / 12)
	endif
	fauto2 pvscross fbuzz, fsig, kcross, 1. - kcross
	fharm2 pvscale fauto2, kscl2
endif
if abs(kharm3) > 0 then
	if kharm3chng == 1 then
		kscl3 = 2 ^ (kharm3 / 12)
	endif
	fauto3 pvscross fbuzz, fsig, kcross, 1. - kcross
	fharm3 pvscale fauto3, kscl3
endif 

kgoto resynth

resynth:

; resynthesis
aout pvsynth fauto
if abs(kharm1) > 0 then
	aout1 pvsynth fharm1
endif
if abs(kharm2) > 0 then
    aout2 pvsynth fharm2
endif
if abs(kharm3) > 0 then
    aout3 pvsynth fharm3
endif

kgoto output

output:		; stereo, optimal

aoutl = aout * kmainlevel * .5
aoutr = aout * kmainlevel * .5

if abs(kharm1) > 0 then
	aoutl = aoutl + (aout1 * kharmlevel1 * .5)
	aoutr = aoutr + (aout1 * kharmlevel1 * .2)
endif
if abs(kharm2) > 0 then
	aoutl = aoutl + (aout2 * kharmlevel2 * .2)
	aoutr = aoutr + (aout2 * kharmlevel2 * .5)
endif

if abs(kharm3) > 0 then
	aoutl = aoutl + (aout3 * kharmlevel3 * .25)
	aoutr = aoutr + (aout3 * kharmlevel3 * .25)
endif

end:
if ksource == 2 then
	aoutl = asig * kmainlevel * .5
	aoutr = asig * kmainlevel * .5
endif

xout aoutl, aoutr

endop

opcode monogate, a, a
 
asig xin

kthresh chnget "gate"
kthresh port kthresh, 0.01

imax = 0dbfs * .1  ;ok for real time vox inout, not a very high rms, just to zero noise

krms rms asig
kgate = (krms < (kthresh * imax) ? 0: 1)
kgate port kgate, .05	

end:

xout asig*kgate

endop

instr 1		;read UI, gate, robo, effects 

ksource chnget "source"
kcross chnget "cross"
kscale chnget "scale"
kkey chnget "key"
kmainlevel chnget "mainlevel"
kauto chnget "autorobo"
kharm1 chnget "harm1"
kharmlevel1 chnget "harmlevel1"
kharm1form chnget "harm1form"
kharm2 chnget "harm2"
kharmlevel2 chnget "harmlevel2"
kharm3 chnget "harm3"
kharmlevel3 chnget "harmlevel3"
kdel chnget "appdelay"
kdist chnget "dist"
kreverb chnget "appreverb"
kgateswitch chnget "gateswitch"
gklooptype chnget "looptype" ;picking this up in an 'always on' instrument to grab i value

ainput, ainput2 ins

if kgateswitch == 1 then
ain monogate ainput 
aoutl, aoutr Robotune ain, ksource, kcross, kscale, kkey, kmainlevel, kauto, kharm1, kharmlevel1, kharm1form, kharm2, kharmlevel2, kharm3, kharmlevel3 
endif

if kgateswitch == 0 then
aoutl, aoutr Robotune ainput, ksource, kcross, kscale, kkey, kmainlevel, kauto, kharm1, kharmlevel1, kharm1form, kharm2, kharmlevel2, kharm3, kharmlevel3
endif

gaout = (aoutl + aoutr) * .5	; for mono loops
gawritel = gawritel + aoutl		; main o/p sent to main out instr
gawriter = gawriter + aoutr

kchdel changed kdel			; effects section
kchdist changed kdist		; distortion not currently implemented in UI
kchrev changed kreverb

if kchdel == 1 && kdel == 1 then
	event "i", 10, 0, -1
endif

if kchdel == 1 && kdel == 0 then
	turnoff2 10, 0, 1
endif

if kchdist == 1 && kdist == 1 then
	event "i", 11, 0, -1
endif

if kchdist == 1 && kdist == 0 then
	turnoff2 11, 0, 1
endif

if kchrev == 1 && kreverb == 1 then
	event "i", 12, 0, -1
endif

if kchrev == 1 && kreverb == 0 then
	turnoff2 12, 0, 1
endif

endin

instr 10	;delay processor

afdb init 0

idel chnget "delayinterval"
ifdb chnget "fdb"

adel delay (gawritel+gawriter)/2 + afdb, idel
afdb = adel * ifdb 	 		

; allow effect to smoothly come on and off
aout linenr adel, 0.1, .2, .01

gawritel = gawritel * .75 + aout * .25
gawriter = gawriter * .75 + aout * .25
gaout = (gawritel + gawriter) * .5

endin

instr 11	;dist

kdistlevel chnget "distlevel"
kdistlevelport port kdistlevel, .1

adist distort1 (gawritel+gawriter) / 2, (kdistlevelport * 10), .5, 0, 0

aout linenr adist, 0.1, .25, .01

gawritel = gawritel * .75 + aout * .25
gawriter = gawriter * .75 + aout * .25
gaout = (gawritel + gawriter) * .5

endin

instr 12	;reverb

irev chnget "reverblevel"
itone chnget "reverbtone"

denorm gawritel, gawriter
arevl, arevr freeverb gawritel, gawriter, (irev / 2 + .4), itone, sr

aoutl linenr arevl, 0.1, .4, .01
aoutr linenr arevr, 0.1, .4, .01

gawritel = gawritel * .75 + aoutl * .25
gawriter = gawriter * .75 + aoutr * .25
gaout = (gawritel + gawriter) * .5

endin

instr 13		; click

ikey chnget "key"
idur = p3
ibase = 261.625565	;mid c

ifr = ibase * (2 ^ (ikey / 12))

asig oscili 20000, ifr, 1
aenv adsr idur*.01, idur*.05, .25, idur*.1
aout = asig * aenv

outs aout, aout

endin

instr 14		; scale play

ikey chnget "key"
iscale chnget "scale"
idur = p3
ibase = 261.625565	;mid c

if (iscale == 2) then	;chromatic
	inote = gichrom + ikey
igoto play
endif

inote table gipos, 3 	; get a pitch class
inote = (inote + ikey)

gipos = gipos + 1 ; increment table pos
if gipos == 8 then
	gipos = 0
endif

play:
    
ifr = ibase * (2 ^ (inote / 12))

aenv linen 10000, idur*.25, idur, idur*.5
aout oscili aenv, ifr, 1

outs aout, aout

if (iscale == 2) then	;chromatic
	gichrom = gichrom + 1
	if (gichrom == 12) then
		gichrom = 0
	endif
endif

endin

instr 20		; loop write 

kloopstate init -1	;there is an initial pass for first record...

ksyncflag init 0

aindex init 0

; channels:
kloop chnget "loop"
kloopplay chnget "loopplay"

;kbeatplay chnget "beatplay"

ktempo chnget "tempotoggle"
kbpm chnget "tempo"
kmetro chnget "click" 

itablelen = ftlen(gistorage)
		
kbps = kbpm / 60		

ktempoch changed ktempo			
if (ktempoch == 1 && ktempo == 1) then
	ksamplespb = sr / kbps
	ksamplespbover2 = ksamplespb / 2
endif

if kmetro == 1 || kmetro == 2 then 
	kclick metro kbps	
endif

if kmetro == 1 then		;play scale
	if kclick == 1 then
		event "i", 14, 0, .1
	endif
endif

if kmetro == 2 then		;play click
	kdur = 1 / kbps
	if kclick == 1 then
		event "i", 13, 0, kdur
	endif
endif

/*
kbeatplaych changed kbeatplay		;does this move to main play window?

if kbeatplaych == 1 && kbeatplay == 1 then
	event "i", 25, 0, -1
endif
	
if kbeatplaych == 1 && kbeatplay == 0 then
	turnoff2 25, 0, 1	
endif
*/

kloopchange changed kloop
akloopchange = kloopchange

if (kloopchange == 1 && kloop == 1) then	; this is to reset flag when record started again. 
	kloopstate = -1

	; sync: used to avoid recording beyond max loop length 
	chnset kloopstate, "loopsync"

	ksyncflag = 0
endif

; kloop1 state 0 is just initialisation: do nothing

if kloop == 1 then		; recording

	turnoff2 21, 0, 1	; turn off playback
	
	aindex, aloopsync syncphasor (sr/itablelen), akloopchange

	kTrigDisp metro	   10 	; downsamp for UI, update rate is 10 HZ
	kDispVal  max_k    aindex, kTrigDisp, 1 							
	chnset kDispVal, "looppos"

	aindex = aindex * itablelen
	
	; exit if loop full
	ktestmet metro kr		
	kloopsync max_k aloopsync, ktestmet, 1
	
	if (kloopsync == 1) then 		
		kloopstate = kloopstate + 1
	endif 

	chnset kloopstate, "loopsync"	;send to sync test channel
	
	if(kloopstate == 1) then 		; recorded, finish
		ksyncflag = 1	
		kgoto stop		;break out to get loop len etc. 
	endif	
	
	tablew gaout, aindex, gistorage		; write global out to tab
endif

; stop:
if kloopchange == 1 && kloop == 2 && ksyncflag == 0 then		; only do this if loop changes to avoid size zero sent, syncflag makes sure an automatic UI change does not trigger it...
stop:
    
	kloopstate = -1		;reset
	klooplen downsamp aindex		
	
	if(ktempo == 1) then		;sort tempo quantize...
		kmod = klooplen % ksamplespb
		
		if (kmod > ksamplespbover2) then		;go up to nearest beat size
			klooplen = klooplen + (ksamplespb - kmod)
			if klooplen > itablelen then
				klooplen = klooplen - ksamplespb		; 1 beat back
			endif	
		kgoto next
		endif

		if (kmod < ksamplespbover2)  then
			klooplen = klooplen - kmod
			if klooplen == 0 then
				klooplen = klooplen + kmod		; 1 beat forward if 0
			endif	
		kgoto next
		endif
	endif

	next:
	gklooplen = klooplen
endif

kchplay changed kloopplay   ;playback	

if (kchplay == 1 && kloopplay == 0) then
	turnoff2 21, 0, 1	; send stop message to instrument.
endif

if (kchplay == 1 && kloopplay == 1) then
	event "i", 21, 0, -1		; send play message to instrument. 
	turnoff2 13, 0, 1		; turn off click and scale play. 
	turnoff2 14, 0, 1	
endif

gaout = 0

endin

instr 21	; play loop  

anosync init 0
klooplevel chnget "looplevel"

;add? init to 1
;klooppitch chnget "looppitch"

andx phasor (sr/gklooplen)
kTrigDisp metro	   10 
kDispVal  max_k    andx, kTrigDisp, 1 
chnset kDispVal, "looppos"

aloop flooper2 klooplevel, /*klooppitch*/ 1, 0, gklooplen/sr, .05, gistorage, 0, i(gklooptype)
asig linenr aloop, .1, .5, .01	; overall fade

gawritel = gawritel + asig
gawriter = gawriter + asig

endin

/*
instr 25	; play back a beat

kbeatlevel chnget "beatlevel"

Sbeat chnget "beat"

kfade linenr kbeatlevel, 0, .5, .01
ichnls filenchnls Sbeat

if ichnls == 1 then	; mono
	asig diskin2 Sbeat, 1, 0, 1
	asigl = asig * kfade
	asigr = asig * kfade
endif

if ichnls != 2 then	; stereo
	asigl, asigr diskin2 Sbeat, 1, 0, 1
	asigl = asigl * kfade
	asigr = asigr * kfade
endif

gawritel = gawritel + asigl
gawriter = gawriter + asigr

endin
*/

instr 30	; compress all...

aoutl dam gawritel, 30000, .1, 1, .01, .5
aoutr dam gawriter, 30000, .1, 1, .01, .5

outs aoutl, aoutr

/* ; not implementing UI due to cpu
kroboeyel downsamp (aoutl / 0dbfs)
kroboeyer downsamp (aoutr / 0dbfs)

kroboeyel = abs(kroboeyel)
kroboeyer = abs(kroboeyer)

if kroboeyel < .00005 then			;avoid /0 
	kroboeyel = .00005 
endif
if kroboeyer < .00005 then 
	kroboeyer = .00005 
endif

kroboeyellog10 = log10(kroboeyel)	; to dB
kroboeyerlog10 = log10(kroboeyer)

kdbl = 20 * kroboeyellog10 
kdbr = 20 * kroboeyerlog10 

kdblscale = (kdbl + 96) / 96	; 16 bit to 0-1 range...
kdbrscale = (kdbr + 96) / 96

kTrigDisp metro	   10 
kDispVall  max_k    a(kdblscale), kTrigDisp, 1 
kDispValr  max_k    a(kdbrscale), kTrigDisp, 1 

chnset kDispVall, "roboeyel"		
chnset kDispValr, "roboeyer"
*/

gawritel = 0
gawriter = 0

endin


</CsInstruments>
<CsScore>

f1 0 1024 10 1
f3 0 8 -2  0 2 4 5 7 9 11 12 ; scale table

i1 0 36000
i20 0 36000
i30 0 36000

</CsScore>
</CsoundSynthesizer>
