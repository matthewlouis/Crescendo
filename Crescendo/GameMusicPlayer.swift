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
    func loadSampler(intoTrackNumber:Int, EXS24file: String){
        
        var sampler = AKSampler()
        sampler.loadEXS24(EXS24file)
        sequencer!.avTracks[intoTrackNumber].destinationAudioUnit = sampler.samplerUnit
        tracks[intoTrackNumber] = Track(instrument: sampler, fx: [AKNode?](), volume: nil)
    }
    
    
    func load(){
        AudioKit.output = mixer
        AudioKit.start()
        
        sequencer = AKSequencer(filename: currentMidiLoop, engine: AudioKit.engine)
        sequencer?.loopOn()
        
        loadSampler(1, EXS24file: "Sounds/Sampler Instruments/sqrTone1")
        loadSampler(2, EXS24file: "Sounds/Sampler Instruments/sawPiano1")
        loadSampler(3, EXS24file: "Sounds/Sampler Instruments/sawPad1")
        //loadSampler(4, EXS24file: "Sounds/Sampler Instruments/drumSimp")
        
        AudioKit.stop()
        //connects all tracks to mixer at default gain level
        for var index = 1; index < tracks.count; ++index {
            if(tracks[index] != nil){
                attachVolume(&tracks[index]!)
                mixer.connect(tracks[index]!.volume!)
            }
        }
        tracks[3]?.volume!.gain = 0.3
        AudioKit.start()
        sequencer!.setLength(8)
        
        
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
