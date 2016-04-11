//
//  Theme.swift
//  Crescendo
//
//  Colour information for visualizer
//
//  Created by Matthew Moldowan on 2016-04-07.
//  Copyright © 2016 Equalizer. All rights reserved.
//

import Foundation

class Theme:NSObject{
    
    //base environment
    static var background = GLKVector4Make(0.071, 0.016, 0.165, 1)
    static var bar_lines = GLKVector4Make(0.871, 0.812, 0.965,1)
    static var bar_react:[GLKVector4] = [GLKVector4Make(0.906, 0.886, 0.941,1), GLKVector4Make(0.576, 0.494, 0.714,1), GLKVector4Make(0.463, 0.365, 0.631,1)]
    static var player = GLKVector4Make(0.871, 0.812, 0.965,1)
    
    //interactive objects
    static var pickups:[GLKVector4] = [GLKVector4Make(0.871, 1, 0,1), GLKVector4Make(0,0,0,1)]
    static var obstacles:[GLKVector4] = [GLKVector4Make(1, 0, 0.369,1)]
    
    //message view
    static var titleColor = GLKVector4Make(0.435, 0.094, 1,1)
    static var messageColor = GLKVector4Make(0.435, 0.094, 1,1)
    static var gameOverScreenColor = GLKVector4Make(0.071, 0.016, 0.165,1)
    static var gameOverFontColor = GLKVector4Make(0.435, 0.094,1,1)
    
    static func getBarReact(atIndex: Int)->GLKVector4{
        return bar_react[atIndex]
    }
    
    static func getBarReactCount()->Int{
        return bar_react.count
    }
    
    static func getPickups(atIndex: Int)->GLKVector4{
        return pickups[atIndex]
    }
    
    static func getPickupsCount()->Int{
        return pickups.count
    }
    
    static func getObstacles(atIndex: Int)->GLKVector4{
        return obstacles[atIndex]
    }
    
    static func getObstaclesCount()->Int{
        return obstacles.count
    }
}