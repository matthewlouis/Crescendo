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

@interface Bar : Plane
{
@public NSMutableArray *m_Planes;
@public float m_BPM;
@public float m_BarWidth;
    
@private TimeSignature m_TimeSignature;
@private float m_DelayPerBar;
}

- (id)init;

- (void)GeneratePlanes;
- (void)CreatePlane:(float)zOffset;
- (Plane*)GetNextPlane;

- (void)update:(float)TimePassed;
- (void)updatePlanePositions;

- (void)setTimeSignature:(TimeSignature)timeSig;

@end

#endif /* Bar_h */
