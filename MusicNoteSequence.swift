//
//  MusicSequence.swift
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-03-14.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import Foundation

/**
 * Contains information to play a sequence of notes of a given length on a given track
**/

class MusicNoteSequence:NSObject{
    var track:Int
    var seqLengthBars:Int
    var notes:[SequenceNote]
    
    override init(){
        notes = [SequenceNote]()
        track = 0
        seqLengthBars = 0
        super.init()
    }
    
    //add note to the sequence
    func addNote(noteNumber:Int = 0, position: Float = 0, duration: Float = 0){
        let note = SequenceNote(noteNumber: noteNumber, position: position, duration: duration)
        notes.append(note)
    }
    
    //add note to the sequence
    func addNote(note:SequenceNote){
        notes.append(note)
    }
}