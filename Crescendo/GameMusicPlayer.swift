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

struct Track{
    var node: AKNode
    var volume:AKBooster?
}

class GameMusicPlayer : NSObject{
    let audiokit = AKManager.sharedInstance
    
    var sequencer:AKSequencer?
    var mixer = AKMixer()
    
    var track1 = AKSampler()
    var track2 = AKSampler()
    var track3 = AKSampler()
    var track4 = AKSampler()
    
    var track1Volume:AKBooster?
    var track2Volume:AKBooster?
    var track3Volume:AKBooster?
    var track4Volume:AKBooster?
    
    var currentMidiLoop = "";
    
    override init(){
        currentMidiLoop = "seqDemo";
        super.init()
            }
    
    init(withMidiLoopFileName midiLoopFileName: NSString){
        currentMidiLoop = midiLoopFileName as String
        super.init()
            }
    
    func loadInstrument(intoTrackNumber:Int, instrumentType: String){
        switch(intoTrackNumber){
        case 1:break
        case 2: break
        case 3: break
        case 4: break
        default:break
        }
    }
    
    
    func load(){
        track1Volume = AKBooster(track1)
        track2Volume = AKBooster(track2)
        track3Volume = AKBooster(track3)
        track4Volume = AKBooster(track4)
        
        track1Volume?.gain = 1
        track2Volume?.gain = 1
        track3Volume?.gain = 1
        track4Volume?.gain = 1
        
        mixer.connect(track1Volume!)
        mixer.connect(track2Volume!)
        mixer.connect(track3Volume!)
        mixer.connect(track4Volume!)
        
        audiokit.audioOutput = mixer
        
        track1.loadEXS24("Sounds/Sampler Instruments/sqrTone1")
        track2.loadEXS24("Sounds/Sampler Instruments/sawPiano1")
        track3.loadEXS24("Sounds/Sampler Instruments/sawPad1")
        track4.loadEXS24("Sounds/Sampler Instruments/drumSimp")
        audiokit.start();
        
        sequencer = AKSequencer(filename: currentMidiLoop, engine: audiokit.engine)
        sequencer?.loopOn()
        sequencer!.avTracks[1].destinationAudioUnit = track1.samplerUnit
        sequencer!.avTracks[2].destinationAudioUnit = track2.samplerUnit
        sequencer!.avTracks[3].destinationAudioUnit = track3.samplerUnit
        sequencer!.avTracks[4].destinationAudioUnit = track4.samplerUnit
        
        sequencer!.setLength(4)

        
    }
    
    func play(){
        sequencer!.play();
    }
    
    func stop(){
        sequencer!.stop();
    }
}
