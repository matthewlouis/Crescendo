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

enum PlayableTracks : Int{
    case PIANO = 0
    case STRINGS
    case NUMBER_OF_PLAYABLE
}

//Major and Minor scales
let scale1:[Int] = [0,2,4,7,9]
let scale2:[Int] = [0,3,5,7,10]

class SoundEffectController: NSObject{
    static let SEQ_LENGTH:Float = 1.0 //1.0 = 1 bar
    static let ROOT_NOTE = 26 //D2
    static let BAR_RESOLUTION:Float = 4
    static let DEFAULT_STEP:Float = 1/BAR_RESOLUTION
    
    static  let OBSTACLE_NOTE = InteractiveSoundObject(note: 86, duration: 0.25, position: 0)
    
    //keeps track of how many bars we've generated
    var barsGenerated:Int = 0
    
    var _musicSequences:[MusicNoteSequence]
    
    var isMinorScale = true
    
    var difficultyScale:Double = 70
    
    var _musicBars:[MusicBar]
    
    //Allots for 16 tracks, with a 1-based index
    var _soundeffectInstrument = [AKNode?](count: 17, repeatedValue:nil)
    
    
    let _musicPlayer:GameMusicPlayer
    
    init(musicPlayer: GameMusicPlayer){
        _musicSequences = [MusicNoteSequence]()
        _musicBars   = [MusicBar]()
        _musicPlayer = musicPlayer
        
        //gets reference to all instruments (so they can be played)
        for(var i = 1; i <= 16; ++i){
            _soundeffectInstrument[i] = (musicPlayer.tracks[i]?.instrument)
        }
    
        super.init()
        
        //get path for music seq file and read it in
        let url = NSBundle.mainBundle().URLForResource("Songs/preprogrammed", withExtension: "seq")
        _musicSequences = SequenceReader.readFile(url!)
    }
    
    
    func generateAndAddSection(stepSize:Float = DEFAULT_STEP, barLength:Float = SEQ_LENGTH){
        
        var barsToGenerate:Int = 1
        barsToGenerate = barsToGenerate << Int(random(1,4))
        
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
                    octaveOffset += Int(12 * ((maybe()*2.0)+(-1.0)));
                    octaveOffset = Int(maybe() * maybe() * Float(octaveOffset)) + 24;
                }
                
                let noteToAdd = SoundEffectController.ROOT_NOTE + scale[Int(scaleOffset)] + octaveOffset
                barOfMusic.events.append(InteractiveSoundObject(note: noteToAdd, duration: 1, position: Float(step)))
            }
        }
        if(possibly(4)){ //1 in 2 chance of adding simultaneous playing
            barOfMusic.duplicateTracksPlayedOn.append(15)
        }
        
        for(var j:Float = 0.0; j < Float(barsToGenerate); j += barLength){
            _musicBars.append(barOfMusic)
        }
        barsGenerated += barsToGenerate
    }
    
    func removeSection(){
        if(_musicBars.count > 0){
            _musicBars.removeFirst()
            --barsGenerated
        }
    }
    
    func clear(){
        _musicBars.removeAll()
        barsGenerated = 0
    }
    
    @objc func stopSound(timer:NSTimer){
        let inst = _soundeffectInstrument as! AKSampler;
    }
    //stops a sampled instrument note
    @objc func stopSoundSample(timer:NSTimer){
        let so = timer.userInfo as! InteractiveSoundObject;
        let inst = _soundeffectInstrument[so._track] as! AKSampler;
        
        inst.stopNote(so._note);
    }
    
    //stops a polyphonic instrument note
    @objc func stopSoundPoly(timer:NSTimer){
        let so = timer.userInfo as! InteractiveSoundObject;
        let inst = _soundeffectInstrument[so._track] as! AKPolyphonicInstrument;
        
        inst.stopNote(so._note);
    }
    
    //plays the sound from the sound object
    func playSound(soundObject: InteractiveSoundObject){
        //using reflection workaround to get type because AudioKit is dumb and classes don't inherit playNote method
        let ref = Mirror(reflecting:_soundeffectInstrument[soundObject._track]) //check type of instrument
        let (_, some) = ref.children.first!
        if let inst = some as? AKPolyphonicInstrument {
            inst.playNote(soundObject._note, velocity: 100)
            NSTimer.scheduledTimerWithTimeInterval(60 / Double(_musicPlayer.bpm) * Double(soundObject._duration), target: self, selector: Selector("stopSoundPoly:"), userInfo: soundObject, repeats: false)
        }else if let inst = some as? AKSampler{
            inst.playNote(soundObject._note, velocity: 100)
            NSTimer.scheduledTimerWithTimeInterval(60 / Double(_musicPlayer.bpm) * Double(soundObject._duration), target: self, selector: Selector("stopSoundSample:"), userInfo: soundObject, repeats: false)
        }
    }
    
    
    func maybe()->Float{
        let maybeVal = random(0,2)
        let outVal = Float((maybeVal > 1 ? 0 : 1))
        return (outVal)
    }
    
    func calculateMarkovMatrices(){
        
    }
    
    func calculateMarkovNote(){
        
    }
    
    func calculateMarkovDuration(){
    
    }
    
    func resetMusic(){
        _musicPlayer.sequencer?.rewind()
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
    
    //return a random bool based on input chance
    func possibly(oneIn:Int)->Bool{
        let maybe:Int = random() % oneIn
        if(maybe == 0){
            return true
        }
        return false
    }
}