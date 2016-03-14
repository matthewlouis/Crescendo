//
//  SequenceNote.swift
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-03-14.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import Foundation

/**
 * A note to be played on an instrument
**/

class SequenceNote:NSObject{
    var noteNumber:Int
    var position:Float
    var duration:Float
    
    init(noteNumber:Int = 0, position: Float = 0, duration: Float = 0){
        self.noteNumber = noteNumber
        self.position = position
        self.duration = duration
        super.init()
    }
}