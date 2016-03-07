//
//  TempoKeeper.swift
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import Foundation
import AudioKit

class TempoKeeper:AKMIDIInstrument{
    
    var _listener:PlaneContainer
    
    init(listener: PlaneContainer){
        self._listener = listener
        super.init( instrument: CoreInstrument(voiceCount: 10))
    }
    
    override func startNote(note: Int, withVelocity velocity: Int, onChannel channel: Int) {
        if(note == 0){
            _listener.syncToBar()
        }
    }
    
    override func midiNoteOn(note: Int, velocity: Int, channel: Int) {
        print("received note: %d channel: %d", note ,channel);
    }
    
    func midiSystemCommand(data: [UInt8]) {
        print("received system data: %d", data)
    }
    func midiAfterTouch(pressure: Int, channel: Int) {
        print("received after touch data: %d", pressure)
    }
    func midiAftertouchOnNote(note: Int, pressure: Int, channel: Int) {
        print("received aftertouch on note data: %d", note)
    }
    func midiController(controller: Int, value: Int, channel: Int) {
        print("received controller : %d", controller)
    }
    func midiNoteOff(note: Int, velocity: Int, channel: Int) {
        print("received note: %d channel: %d", note ,channel);
    }
    func midiPitchWheel(pitchWheelValue: Int, channel: Int) {
       print("received pitchwheel: %d channel: %d", pitchWheelValue ,channel);
    }
    func midiProgramChange(program: Int, channel: Int) {
        print("received program change: %d", program)
    }
    
}