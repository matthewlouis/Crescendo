//
//  MusicBar.swift
//  Crescendo
//
//  Created by Sean Wang on 2016-02-20.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import Foundation


class MusicBar:NSObject{
    
    var barLength: Float
    var events:[InteractiveSoundObject]
    
    init(length: Float){
        barLength = length
        events = [InteractiveSoundObject]()
        super.init()
    }
    
    /**
     * Given a step, returns the appropriate sound object
     */
    func getSoundObject(position: Float)->InteractiveSoundObject?{
        for(var i = 0; i < events.count; ++i){
            if(events[i]._position == Double(position)){
                return events[i]
            }
        }
        return nil
    }
}
