//
//  PlaneContainer.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#ifndef PlaneContainer_h
#define PlaneContainer_h

#import <Foundation/Foundation.h>
#import "NSMutableArray+Queue.h"

#import "Plane.h"
#import "TimeSignature.h"
#import "Constants.h"
#import "Bar.h"

@class GameMusicPlayer;
@class SoundEffectController;

@interface PlaneContainer : GameObject3D
{
@public NSMutableArray *m_Bars;
@public float m_BPM;
@public SoundEffectController *soundEffectController;
    
@public Plane* nextPlane;
    
@private TimeSignature m_TimeSignature;
@private float m_TimePassed;
    
@private float m_SpawnDistance;
@private float m_SpawnBarVelocity;

@private GameMusicPlayer *gameMusicPlayer;
    
@private bool buildBar;
}

- (void)CreateBar;
- (Bar*)GetBar;

- (void)setSpawnBarVelocity:(float)velocity;

-(void)setTimeSignature:(TimeSignature)timeSig;

-(void)update:(float)timePassed;
-(void)draw;

- (void)findNextPlane;

+(void)startGame;
-(void)startMusic;
-(void)pauseMusic;
-(void)resumeMusic;
-(void)syncToBar;

@end

#endif