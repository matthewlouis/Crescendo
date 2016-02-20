//
//  InteractiveSoundObject.swift
//  Crescendo
//
//  Contains information about a playable sound object
//
//  Created by Matthew Moldowan on 2016-02-19.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import Foundation

enum ObjectType{
    case OBSTACLE
    case PICKUP
}

class InteractiveSoundObject:NSObject{
    
    var _type:ObjectType
    var _track:Int, _note:Int, _duration:Int, _position:Double
    
    init(type: ObjectType = .OBSTACLE, track: Int = 0, note: Int, duration: Int, position: Double){
        self._type = type
        _track = track
        _note = note
        _position = position
        _duration = duration
        super.init()
    }
}