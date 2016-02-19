//
//  PlaneContainer.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Queue.h"

#import "Plane.h"
#import "TimeSignature.h"



@interface PlaneContainer : NSObject
{

    
@public NSMutableArray *m_Planes;
@public float m_BPM;
    
@private TimeSignature m_TimeSignature;
@private float m_TimePassed;
@private float m_DelayPerBar;
    
@private float m_SpawnDistance;
@private float m_PlaneVelocity;
@private float m_TimeOnScreen;
}

-(void)CreatePlane;
-(Plane*)GetPlane;

-(void)setTimeSignature:(TimeSignature)timeSig;
-(void)setTimeOnScreen:(float)time;
-(void)setPlaneVelocity:(float)velocity;

-(void)update:(float)timePassed;
-(void)draw;

@end
