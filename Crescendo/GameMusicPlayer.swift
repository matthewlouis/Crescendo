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
}

//Basic track struct
struct Track{
    
    //The instrument
    var instrument: AKNode
    //Array of insert effects
    var fx = [AKNode?]()
    //track volume
    var volume:AKBooster?
}

class GameMusicPlayer : NSObject{
    var sequencer:AKSequencer?
    var mixer = AKMixer()
    
    //Allots for 16 tracks, with a 1-based index
    var tracks = [Track?](count: 17, repeatedValue:nil)
    
    var currentMidiLoop = "";
    
    override init(){
        currentMidiLoop = "Songs/test";
        super.init()
            }
    
    init(withMidiLoopFileName midiLoopFileName: NSString){
        currentMidiLoop = midiLoopFileName as String
        super.init()
    }
    
    //loads a sampler instrument into
    func loadSampler(intoTrackNumber:Int, fileName: String, sampleFormat: SampleFormat){
        
        var sampler = AKSampler()
        
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
        sequencer!.avTracks[intoTrackNumber].destinationAudioUnit = sampler.samplerUnit
        tracks[intoTrackNumber] = Track(instrument: sampler, fx: [AKNode?](), volume: nil)
    }
    
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
        }
        
        //return the newly added effect
        return tracks[intoTrackNumber]!.fx[tracks[intoTrackNumber]!.fx.count - 1]!
    }
    
    
    func load(){
        AudioKit.output = mixer
        AudioKit.start()
        
        sequencer = AKSequencer(filename: currentMidiLoop, engine: AudioKit.engine)
        sequencer?.loopOn()
        
        loadSampler(10, fileName: "Sounds/Sampler Instruments/drumSimp", sampleFormat: SampleFormat.EXS24)
        loadSampler(1, fileName: "Sounds/Sampler Instruments/LoFiPiano_v2", sampleFormat: SampleFormat.EXS24)
        
        var verb = addFX(1, fxType: .REVERB) as! AKReverb2
        verb.dryWetMix = 0.2
        verb.decayTimeAt0Hz = 10.0
        verb.decayTimeAtNyquist = 10.0
        verb.randomizeReflections = 500
        
        
        AudioKit.stop()
        //connects all tracks to mixer at default gain level
        for var index = 1; index < tracks.count; ++index {
            if(tracks[index] != nil){
                attachVolume(&tracks[index]!)
                mixer.connect(tracks[index]!.volume!)
            }
        }

        AudioKit.start()
        sequencer!.setLength(64)
    }
    
    func play(){
        sequencer!.play();
    }
    
    func stop(){
        sequencer!.stop();
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
}
