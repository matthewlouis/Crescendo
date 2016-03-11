//
//  Bar.h
//  Crescendo
//
//  Created by Sean Wang on 2016-02-19.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#ifndef Bar_h
#define Bar_h

#import "GameObject3D.h"
#import "Plane.h"
#import "TimeSignature.h"
#import "NSMutableArray+Queue.h"

@class MusicBar, InteractiveSoundObject;

@interface Bar : GameObject3D
{
@public NSMutableArray *m_Planes;
@public float m_BPM;
@public float m_BarWidth;
@public float m_Velocity;
    
@private TimeSignature m_TimeSignature;
@private float m_DelayPerBar;

}

- (id)init;
- (id)initWithPosition:(float)position atBPM:(float)bpm usingMusicBar: (MusicBar *)musicBar;

- (void)GeneratePlanes:(MusicBar *)musicBar;
- (void)CreatePlane:(float)zOffset withSoundObject: (InteractiveSoundObject *)soundObject withThickness:(float)thickness;
- (Plane*)GetNextPlane;

- (void)update:(float)TimePassed;
- (void)updatePlanePositions;

- (void)setTimeSignature:(TimeSignature)timeSig;

@end

#endif /* Bar_h */
