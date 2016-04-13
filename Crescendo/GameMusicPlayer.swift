//
//  GameMusicPlayer.swift
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-27.
//  Copyright © 2016 Equalizer. All rights reserved.
//


import Foundation
import UIKit
import AudioKit

enum SampleFormat {
    case EXS24
    case SF2
    case WAV
}

enum FXType {
    case REVERB
    case DELAY
    case BITCRUSH
    case COMPRESSOR
    case FATTEN
    case AMPLITUDE_TRACKER
}

enum InstrumentType{
    case FM
    case NOISE
    case PWM
    case KICK
    case SNARE
    case WAVE
    case ANALOGX
}

//Basic track struct
struct Track{
    //The instrument
    var instrument: AKNode
    //Array of insert effects
    var fx = [AKNode?]()
    //track volume
    var volume:AKBooster?
    //This allows polyphonic instruments to receive MIDI data
    var midiInstrument:AKMIDIInstrument?
}



class GameMusicPlayer : NSObject{
    
    //Original tempo for starting the music
    let DEFAULT_BPM:Float = 120
    
    var bpm:Float{
        didSet{
            sequencer!.setRate(bpm/DEFAULT_BPM)
        }
    }
    
    //variables for getting amplitude information outside of player
    var kickDrumTracker:AKAmplitudeTracker!
    var snareDrumTracker:AKAmplitudeTracker!
    var pianoLeadTracker:AKAmplitudeTracker!
    
    var sequencer:AKSequencer?
    var mixer = AKMixer()
    var masterComp: AKCompressor?
    var songStarted:Bool = false;
    
    
    //Allots for 16 tracks, with a 1-based index
    var tracks = [Track?](count: 17, repeatedValue:nil)
    
    let midi = AKMIDI()
    var currentMidiLoop = "";
    
    var tk:TempoKeeper
    
    var trackStart:UnsafeMutablePointer<MusicSequence>?
    var fadeTimer:NSTimer?
    
    init(tempoListener: PlaneContainer){
        currentMidiLoop = "Songs/testTimeCode";
        self.bpm = DEFAULT_BPM
        tk = TempoKeeper(listener:tempoListener)
        super.init()
    }
    
    init(withMidiLoopFileName tempoListener: PlaneContainer, midiLoopFileName: NSString){
        currentMidiLoop = midiLoopFileName as String
        self.bpm = DEFAULT_BPM
        tk = TempoKeeper(listener:tempoListener)
        super.init()
    }
    
    deinit{
        print("deinit")
        AudioKit.stop()
        sequencer?.stop()
        sequencer = nil
        for(var i = 0; i < tracks.count; ++i){
            tracks[i] = nil
        }
    }
    
    func cleanUp(){
        print("cleanup MusicPlayer")
        sequencer?.stop()
        AudioKit.stop()
        sequencer = nil
        for(var i = 0; i < tracks.count; ++i){
            tracks[i] = nil
        }
    }
    
    //loads audiokit and settings, will be turned into loadSong
    func load(){
        AudioKit.output = mixer
        AudioKit.start()
        sequencer = AKSequencer(filename: currentMidiLoop, engine: AudioKit.engine)
        trackStart = sequencer?.sequencePointer;
        sequencer?.setBPM(bpm)
        
        loadSampler(3, fileName: "Sounds/Sampler Instruments/Drums", sampleFormat: SampleFormat.EXS24)
        
        AudioKit.stop()
        
        
        /**Add drum effects and amplitude analysis nodes into chain **/
        /**Matt: VERY IMPORTANT THAT ALL NODES GET SUMMED BACK TOGETHER PROPERLY OR
                 VERY BAD THINGS HAPPEN! **/
        let drumsfx1 = AKCompressor((tracks[3]?.instrument)!)
        drumsfx1.releaseTime = 1
        drumsfx1.attackTime = 0.05
        drumsfx1.threshold = -35
        drumsfx1.headRoom = 9
        drumsfx1.masterGain = 3
        let drumsfx2 = AKBitCrusher(drumsfx1)
        drumsfx2.bitDepth = 16
        
        let snareAnalysisFilter = AKBandPassFilter(drumsfx1, centerFrequency: 1500, bandwidth: 700)
        snareDrumTracker = AKAmplitudeTracker(snareAnalysisFilter)
        
        
        let kickAnalysisFilter = AKLowPassFilter(drumsfx1, cutoffFrequency: 75)
        kickDrumTracker = AKAmplitudeTracker(kickAnalysisFilter)
        let drumsWithTracker = AKMixer(kickDrumTracker)
        drumsWithTracker.connect(snareDrumTracker)
        let trackerbypass = AKDryWetMixer(drumsfx2, drumsWithTracker, balance:0)
        
        
        addFXChain(3, node: trackerbypass)
        
        loadSampler(1, fileName: "Sounds/Sampler Instruments/LoFiPiano_v2", sampleFormat: SampleFormat.EXS24)
        let pianofx1 = addFX(1, fxType: .FATTEN) as! Fatten
        pianofx1.time = 0.05
        let pianofx2 = addFX(1, fxType: .REVERB) as! AKReverb2
        pianofx2.decayTimeAt0Hz = 2
        pianofx2.decayTimeAtNyquist = 10 
        pianofx2.dryWetMix = 0.5
        let pianofx3 = addFX(1, fxType: .COMPRESSOR) as! AKCompressor
        pianofx3.masterGain = 6
        
        let bass = loadPolySynth(7, instrumentType: .ANALOGX, voiceCount: 2) as! CoreInstrument
        bass.releaseDuration = 0.05
        bass.attackDuration = 0.005
        bass.sustainLevel = 0.5
        bass.waveform1 = Double(3.0)
        bass.waveform2 = Double(0.0)
        bass.offset1 =  -12
        bass.offset2 = -12
        bass.morph = 0.9
        bass.vcoBalance = 0.7
        let bassfx1 = addFX(7, fxType: .DELAY) as! AKDelay
        bassfx1.time = 0.05
        bassfx1.dryWetMix = 0.1
        
        let dinky = loadPolySynth(5, instrumentType: .ANALOGX, voiceCount: 2) as! CoreInstrument
        dinky.releaseDuration = 0.3
        dinky.attackDuration = 0
        dinky.sustainLevel = 0.5
        dinky.waveform1 = Double(2.0)
        dinky.waveform2 = Double(2.0)
        dinky.morph = 1.0
        let dinkyfx1 = addFX(5, fxType: .DELAY) as! AKDelay
        dinkyfx1.time = 0.25
        dinkyfx1.feedback = 0.9
        dinkyfx1.dryWetMix = 0.2
        dinkyfx1.lowPassCutoff = 9000
        
        let synth2 = loadPolySynth(4, instrumentType: .ANALOGX, voiceCount: 4) as! CoreInstrument
        synth2.waveform1 = Double(2)
        synth2.waveform2 = Double(2)
        synth2.detune = -2.0
        synth2.morph = -0.99
        synth2.attackDuration = 0.2
        synth2.releaseDuration = 0.0
        
        
        /****SOUND EFFECTS********/
        
        //piano
        loadSampler(16, fileName: "Sounds/Sampler Instruments/BasicStacStrings", sampleFormat: SampleFormat.EXS24, soundEffect: true)
        let cueFX1 = Fatten((tracks[16]?.instrument)!)
        cueFX1.time = 0.2
        pianoLeadTracker = AKAmplitudeTracker(cueFX1) //amp tracker on before reverb fx
        let cuefx2 = AKReverb2(pianoLeadTracker)
        cuefx2.decayTimeAt0Hz = 5
        cuefx2.decayTimeAtNyquist = 10
        cuefx2.dryWetMix = 0.5
        let cuefx3 = AKCompressor(cuefx2)
        cuefx3.threshold = -20
        cuefx3.masterGain = 0
        addFXChain(16, node: cuefx3)
        
        loadSampler(15, fileName: "Sounds/Sampler Instruments/M1piano", sampleFormat: .EXS24, soundEffect: true)
        
        AudioKit.start()
        tk.enableMIDI(midi.midiClient, name: "TempoKeeper")
        sequencer!.avTracks[sequencer!.avTracks.capacity-1].destinationMIDIEndpoint = tk.midiIn
        
        
        AudioKit.stop()
        let vol = AKBooster(tk)
        mixer.connect(vol)
        
        
        
        //connects all tracks to mixer at default gain level
        for var index = 1; index < tracks.count; ++index {
            if(tracks[index] != nil){
                attachVolume(&tracks[index]!)
                mixer.connect(tracks[index]!.volume!)
            }
        }
        
        masterComp = AKCompressor(mixer)
        masterComp!.headRoom = 3
        masterComp!.releaseTime = 0.2
        masterComp!.masterGain = 9
        
        //level balances
        tracks[4]?.volume?.gain = 0.2
        tracks[1]?.volume?.gain = 0.3
        tracks[7]?.volume?.gain = 0.9
        
        AudioKit.output = masterComp
        
        AudioKit.start()
        
        sequencer?.loopOn()
    }
    
    //loads a sampler instrument into the track
    func loadSampler(intoTrackNumber:Int, fileName: String, sampleFormat: SampleFormat, soundEffect: Bool = false) -> AKSampler{
        
        let sampler = AKSampler()
        
        switch(sampleFormat){
        case .EXS24:
            sampler.loadEXS24(fileName)
            break
        case .SF2:
            sampler.loadSoundfont(fileName)
            break
        case .WAV:
            sampler.loadWav(fileName)
            break
        }
        
        sampler.loadEXS24(fileName)
        
        //soundEffects are played musical cues and are not connected to the sequencer.
        if(!soundEffect){
            sequencer!.avTracks[intoTrackNumber].destinationAudioUnit = sampler.samplerUnit
        }
        tracks[intoTrackNumber] = Track(instrument: sampler, fx: [AKNode?](), volume: nil, midiInstrument: nil)
        return sampler
            
    }
    
    //loads a polyphonic instrument into the track
    func loadPolySynth(intoTrackNumber:Int, instrumentType: InstrumentType, voiceCount: Int, whitePinkMix: Double? = nil, tableType: AKTableType? = nil, tableSize: Int? = nil, soundEffect: Bool = false) -> AKPolyphonicInstrument{
        var instrument: AKPolyphonicInstrument
        switch(instrumentType){
        case .FM:
            instrument = AKFMSynth(voiceCount: voiceCount)
            break
        case .NOISE:
            instrument = AKNoiseGenerator(whitePinkMix: whitePinkMix!, voiceCount: voiceCount)
            break
        case .PWM:
            instrument = AKPWMSynth(voiceCount: voiceCount)
            break
        case .KICK:
            instrument = AKSynthKick(voiceCount: voiceCount)
            break
        case .SNARE:
            instrument = AKSynthSnare(voiceCount: voiceCount)
            break
        case .WAVE:
            instrument = AKWavetableSynth(waveform: AKTable(tableType!, size:tableSize!), voiceCount: voiceCount)
            break
        case .ANALOGX:
            instrument = CoreInstrument(voiceCount: voiceCount);
        }
        
        //assign midiControl to instrument and connect to midi client
        let midiInstrument = AKMIDIInstrument(instrument: instrument)
        midiInstrument.enableMIDI(midi.midiClient, name: String(format: "Track %d midi in", intoTrackNumber))
        
        //add add midiInstrument and physical instrument to newly generated track
        tracks[intoTrackNumber] = Track(instrument: instrument, fx: [AKNode?](), volume: nil, midiInstrument: midiInstrument)
        
        //soundEffects are played musical cues and are not connected to the sequencer.
        if(!soundEffect){
            //set sequencer track to output to midi instrument
            sequencer!.avTracks[intoTrackNumber].destinationMIDIEndpoint = midiInstrument.midiIn
            tracks[intoTrackNumber]?.midiInstrument = midiInstrument
        }
        
        //return the physical instrument
        return instrument
    }
    
    
    //gets the specified effect chain
    func getFXChain(trackNumber: Int) -> [AKNode?]{
        return tracks[trackNumber]!.fx
    }
    
    //gets the specified effect
    func getFX(trackNumber: Int, fxIndex: Int) -> AKNode?{
        return tracks[trackNumber]!.fx[fxIndex]
    }
    
    
    //gets the instrument on specified track
    func getInstrument(trackNumber: Int) -> AKNode{
        return tracks[trackNumber]!.instrument
    }
    
    //gets the volume fader for the specified track
    func getVolume(trackNumber: Int) -> AKNode?{
        return tracks[trackNumber]!.volume
    }
    
    //adds a specified effect into the effect chain and returns the new effect
    func addFX(intoTrackNumber: Int, fxType: FXType) -> AKNode{
        var lastNodeInChain:AKNode
        
        if(tracks[intoTrackNumber]!.fx.count > 0){ //if there are any FX in the chain
            lastNodeInChain = tracks[intoTrackNumber]!.fx[tracks[intoTrackNumber]!.fx.count - 1]!
        }else{ //connect directly to instrument
            lastNodeInChain = tracks[intoTrackNumber]!.instrument
        }
        
        
        switch(fxType){
        case .REVERB:
            tracks[intoTrackNumber]!.fx.append(AKReverb2(lastNodeInChain))
            break
        case .DELAY:
            tracks[intoTrackNumber]!.fx.append(AKDelay(lastNodeInChain))
            break
        case .BITCRUSH:
            tracks[intoTrackNumber]!.fx.append(AKBitCrusher(lastNodeInChain))
            break
        case .COMPRESSOR:
            tracks[intoTrackNumber]!.fx.append(AKCompressor(lastNodeInChain))
            break
        case .FATTEN:
            tracks[intoTrackNumber]!.fx.append(Fatten(lastNodeInChain))
            break
        case .AMPLITUDE_TRACKER:
            tracks[intoTrackNumber]!.fx.append(AKAmplitudeTracker(lastNodeInChain))
            break
        }
        
        //return the newly added effect
        return tracks[intoTrackNumber]!.fx[tracks[intoTrackNumber]!.fx.count - 1]!
    }
    
    //used to append last node of an fx combination into a track
    func addFXChain(intoTrackNumber: Int, node: AKNode){
        tracks[intoTrackNumber]!.fx.append(node)
    }
    
    //play sequencer
    func play(){
        sequencer!.play()
        songStarted = true
    }
    
    //stop sequencer
    func stop(){
        sequencer!.stop()
        songStarted = false
    }
    
    func getBPM() -> Float{
        return bpm;
    }
    
    
    /**
     * Plays a note on a given track
     */
    func playNoteOnInstrument(trackNumber:Int, note: Int, velocity: Int = 100, duration: Float){
        if(tracks[trackNumber]?.midiInstrument != nil){ //if a polyphonic instrument
            tracks[trackNumber]?.midiInstrument?.startNote(note, withVelocity: velocity, onChannel: 1)
            
            let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                sleep(UInt32(60000/self.bpm * duration)) //wait to turn off note
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tracks[trackNumber]?.midiInstrument?.stopNote(note, onChannel: 1)
                })
            })
        }else{ //sampler instrument
            let sampler = self.tracks[trackNumber]?.instrument as? AKSampler
            sampler?.playNote(note, velocity: velocity, channel: 1)
            
            let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                sleep(UInt32(60000/self.bpm * duration)) //wait to turn off note
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    sampler?.stopNote(note, channel: 1)
                })
            })
        }
    }
    
    
    @objc func masterFadeout(timer:NSTimer){
        if(masterComp!.masterGain <= -40){
            timer.invalidate()
        }else{
            masterComp!.masterGain -= 2
        }
    }
    
    @objc func masterFadeIn(timer:NSTimer){
        if(masterComp!.masterGain >= 9){
            timer.invalidate()
        }else{
            masterComp!.masterGain += 2
        }
    }
    
    @objc func fadeOutMusic(){
        
        for(var i = 0; i < tracks.count; i++){
            var inst = tracks[i]?.instrument as? AKPolyphonicInstrument
            inst?.panic()
        }
        
        sequencer!.stop()
        fadeTimer?.invalidate()
        fadeTimer = NSTimer.scheduledTimerWithTimeInterval(0.06, target: self, selector: Selector("masterFadeout:"), userInfo: nil, repeats: true)
    }
    
    @objc func fadeInMusic(){
        fadeTimer?.invalidate()
        fadeTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("masterFadeIn:"), userInfo: nil, repeats: true)
    }
    
    func rewind(){
        sequencer?.rewind()
    }
    
    func restart(){
        sequencer?.play()
        self.bpm = DEFAULT_BPM
        fadeInMusic()
        rewind()
    }
    
    
    /********************** PRIVATE FUNCTIONS *******************/
     
    //Attaches a master volume to track
    private func attachVolume(inout toTrack: Track, gainLevel: Double = 1){
        if(toTrack.fx.count > 0) //if there are effects, attach to last effect
        {
            toTrack.volume = AKBooster(toTrack.fx[toTrack.fx.count - 1]!)
        }else //attach to instrument
        {
            toTrack.volume = AKBooster(toTrack.instrument)
        }
        toTrack.volume!.gain = gainLevel
    }
    
    func getAmp()->Double{
        return pianoLeadTracker!.amplitude
    }
}
