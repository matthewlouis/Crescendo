//
//  Bar.m
//  Crescendo
//
//  Created by Sean Wang on 2016-02-19.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bar.h"
#import "Constants.h"

@implementation Bar

- (id)init
{
    self = [super init];
    if (self)
    {
        m_BarWidth = 10.0f;
        m_LineThickness = 2;
        
        self->m_Planes = [[NSMutableArray alloc] init];
        
        [self GeneratePlanes];
    }
    
    return self;
}

/*
 * Generates planes
 */
- (void)GeneratePlanes
{
    float quarterNoteOffset = m_BarWidth / 5;
    
    // Generate Quarter Notes
    for(int i = 1; i < 4; ++i)
    {
        [self CreatePlane:-quarterNoteOffset * i];
    }
}

/*
 * Creates a plane and places it in the queue
 */
-(void)CreatePlane:(float)zOffset
{
    Plane* newPlane = [[Plane alloc]init];
    newPlane->m_LocalZOffset = zOffset;
    newPlane->m_Velocity = 0;
    newPlane->m_LineThickness = 1;
    [m_Planes enqueue: (newPlane)];
    [self->children addObject:newPlane];
}

/*
 * Returns the oldest plane in the queue
 */
-(Plane*)GetNextPlane
{
    return (Plane*)[m_Planes peek];
}

/*
 * Sets the time signature and calculates all the delays
 */
-(void)setTimeSignature:(TimeSignature)timeSig
{
    // Set Time signature
    m_TimeSignature = timeSig;
    
    /* Calculate Delays */
    if (m_TimeSignature == FourFour)
    {
        m_DelayPerBar = m_BPM / SECONDS_PER_MINUTE;
    }
}

/*
 * Update the plane based on the amount of time that has passed/
 */
- (void)update:(float)TimePassed
{
    worldPosition.z += m_Velocity * TimePassed;
    [self updateLineWith];
    
    // Update all plane positions
    [self updatePlanePositions];
}

/*
 * Updates the positions of all the planes
 */
- (void)updatePlanePositions
{
    // Update all plane positions
    for (NSObject* o in m_Planes)
    {
        Plane* currentPlane = (Plane*)o;
        currentPlane->worldPosition.z = self->worldPosition.z + currentPlane->m_LocalZOffset;
    }
}

@end