//
//  SoundEffectController.swift
//  Crescendo
//
//  Controls all audio effects
//
//
//  Created by Matthew Moldowan on 2016-02-19.
//  Copyright © 2016 Equalizer. All rights reserved.
//
import Foundation
import AudioKit
import AudioToolbox

//Major and Minor scales
let scale1:[Int] = [0,2,4,7,9]
let scale2:[Int] = [0,3,5,7,10]

class SoundEffectController: NSObject{
    static var theInstance:SoundEffectController?
    static let SEQ_LENGTH:Float = 1.0 //1.0 = 1 bar
    static let ROOT_NOTE = 26 //D2
    static let BAR_RESOLUTION:Float = 4
    static let DEFAULT_STEP:Float = 1/BAR_RESOLUTION
    
    var isMinorScale = true
    
    var difficultyScale:Double = 90
    
    //var _musicTracks:[AKMusicTrack] //may not need to use this
    var _musicBars:[MusicBar]
    
    
    let _musicPlayer:GameMusicPlayer
    
    init(musicPlayer: GameMusicPlayer){
        //_musicTracks = [AKMusicTrack]()
        _musicBars   = [MusicBar]()
        
        _musicPlayer = musicPlayer
        
        super.init()
        SoundEffectController.theInstance = self
    }
    
    func generateAndAddSection(stepSize:Float = DEFAULT_STEP, barLength:Float = SEQ_LENGTH){
        //let trackPtr = MusicTrack()
        //let musicTrack = AKMusicTrack(musicTrack: trackPtr)
        
        var barOfMusic:MusicBar
        barOfMusic = MusicBar(length: SoundEffectController.SEQ_LENGTH)
        
        let numSteps = Int(SoundEffectController.SEQ_LENGTH/stepSize)
        
        //generate random note in scale
        for (var i:Int = 0; i < numSteps; i++){
            if(random(1,100) < difficultyScale ){
                let step = Double(i) * Double(stepSize)
                let scale = (isMinorScale ? scale2 : scale1)
                let scaleOffset = random(0, Double(scale.count-1))
                var octaveOffset = 0
                for (var i = 0; i < 2; i++){
                    octaveOffset += Int(12 * ((maybe()*2.0)+(-1.0)))
                    octaveOffset = Int(maybe() * maybe() * Float(octaveOffset))
                }
                //print("octave offset is \(octaveOffset)")
                let noteToAdd = SoundEffectController.ROOT_NOTE + scale[Int(scaleOffset)] + octaveOffset
                //musicTrack.addNote(noteToAdd, vel: 100, position: step, dur: 1)
                barOfMusic.events.append(InteractiveSoundObject(note: noteToAdd, duration: 1, position: step))
            }
        }
        _musicBars.append(barOfMusic)
        //_musicTracks.append(musicTrack)
        
    }
    
    func removeSection(){
        if(_musicBars.count > 0){
            _musicBars.removeFirst()
        }
    }
    
    func playSound(soundObject: InteractiveSoundObject){
        print("\nPlay SOUND")
    }
    
    func maybe()->Float{
        let maybeVal = random(0,2)
        let outVal = Float((maybeVal > 1 ? 0 : 1))
        return (outVal)
    }
    
    func getEQFreq(track: Int, index: Int)->Double{
        let eqFX:AKLowPassFilter = _musicPlayer.getFX(track, fxIndex: index) as! AKLowPassFilter
        return eqFX.cutoffFrequency
    }
    
    func timerEQ(timer: NSTimer){
        var unpackedInfo:[AnyObject] = timer.userInfo as! [AnyObject]
        let eqFX:AKLowPassFilter = unpackedInfo[2] as! AKLowPassFilter
        eqFX.cutoffFrequency += unpackedInfo[1] as! Double
        print("\n",eqFX.cutoffFrequency)
        if(eqFX.cutoffFrequency >= unpackedInfo[0] as! Double){
            timer.invalidate()
        }

    }
    
    func changeEQ(track: Int, index: Int, frequency: Double){
        let eqFX:AKLowPassFilter = _musicPlayer.getFX(track, fxIndex: index) as! AKLowPassFilter
        
        let origFreq = self.getEQFreq(track, index: index)
        let targetFreq:Double = origFreq + frequency
        let freqStep:Double = (targetFreq - origFreq) / 8
        let stepTime:Double = Double(60/self._musicPlayer.bpm * 0.5)

        
        let userInfo = [targetFreq, freqStep, eqFX]
        
        var timer = NSTimer.init(timeInterval: stepTime, target: self, selector: "timerEQ:", userInfo: userInfo, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().run()
    }
    
    func test(){
        print("test")
    }
 
    
    /*Can use this to get apple MusicTrack event information (midi)
    func getMusicTrackEventInfo(index: Int){
    
    
        
        //gets concrete object from pointer
        var musicTrack = _musicTracks[index].trackPtr.memory
        
        var myIterator = MusicEventIterator()
        
        var hasCurrentEvent:DarwinBoolean = false
        MusicEventIteratorHasCurrentEvent(myIterator, &hasCurrentEvent)
        while (hasCurrentEvent) {
            var event = myIterator
    
            // do work here
            MusicEventIteratorNextEvent (myIterator);
            MusicEventIteratorHasCurrentEvent (myIterator, &hasCurrentEvent);
        }
    }*/
}