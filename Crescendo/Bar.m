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
#import "Crescendo-Swift.h"

@implementation Bar

- (id)initWithPosition:(float)position atBPM:(float)bpm usingMusicBar:(MusicBar *)musicBar
{
    InteractiveSoundObject *soundObject = [musicBar getSoundObject: 0];
    
    self = [super initWithName:"bar" shader:nil vertices:nil vertexCount:0];
    
    if (self)
    {
        float bpmPercentage = DEFAULT_BPM/bpm;
        m_BarWidth = BAR_WIDTH * (bpmPercentage);
        worldPosition.z = position;
        
        self->m_Planes = [[NSMutableArray alloc] init];
        
        [self GeneratePlanes: musicBar];
        [self updatePlanePositions];
    }
    
    return self;
}

- (void)CleanUp
{
    // Clean up Self
    [super CleanUp];
    
    // Clean up planes
    for (Plane* o in m_Planes)
    {
        [o CleanUp];
    }
}

/*
 * Generates planes
 */
- (void)GeneratePlanes:(MusicBar *)musicBar
{
    float quarterNoteOffset = m_BarWidth / 5.0f;
    
    // Generate first plane
    InteractiveSoundObject *soundObject = [musicBar getSoundObject: 0 / SoundEffectController.BAR_RESOLUTION];
    [self CreatePlane:0 withSoundObject:soundObject withThickness:1.5f];
    
    // Generate Quarter Notes
    for(int i = 1; i < 4; ++i)
    {
        InteractiveSoundObject *soundObject = [musicBar getSoundObject: i / SoundEffectController.BAR_RESOLUTION];
        [self CreatePlane:-quarterNoteOffset * i withSoundObject:soundObject withThickness:0];
    }
}

/*
 * Creates a plane and places it in the queue
 */
-(void)CreatePlane:(float)zOffset withSoundObject:(InteractiveSoundObject *)soundObject withThickness:(float)thickness
{
    Plane* newPlane = [[Plane alloc]initWithPosition:worldPosition.z + zOffset soundObject:soundObject withThickness:thickness];
    newPlane->m_LocalZOffset = zOffset;
    newPlane->m_Velocity = 0;
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
    
    // Update all plane positions
    [self updatePlanePositions];
    
    // Update all planes
    for (NSObject* o in m_Planes)
    {
        Plane* currentPlane = (Plane*)o;
        [currentPlane update:TimePassed];
    }
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