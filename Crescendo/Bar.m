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

- (id)initWithPosition:(float)position atBPM:(float)bpm usingMusicBar:(MusicBar *)musicBar inColor:(GLKVector4)color
{
    InteractiveSoundObject *soundObject = [musicBar getSoundObject: 0];
    
    self = [super initWithName:"bar" shader:nil vertices:nil vertexCount:0];
    
    if (self)
    {
        //No longer scaling bars float bpmPercentage = DEFAULT_BPM/bpm;
        m_BarWidth = BAR_WIDTH; // No longer scaling bars * (bpmPercentage);
        worldPosition.z = position;
        
        self->m_Planes = [[NSMutableArray alloc] init];
        
        // generate sound quadrants for this bar. i.e. sound pickup to fall in these quadrants
        self->_quadrants = [[NSMutableArray alloc]init];
        [self GenerateSoundQuadrants];
        
        
        [self GeneratePlanes: musicBar inColor:color];
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
- (void)GeneratePlanes:(MusicBar *)musicBar inColor:(GLKVector4)color
{
    float quarterNoteOffset = m_BarWidth / 5.0f;
    
    // Generate first plane
    InteractiveSoundObject *soundObject = [musicBar getSoundObject: 0 / SoundEffectController.BAR_RESOLUTION];
    [self CreatePlane:0 withSoundObject:soundObject withThickness:1.5f inColor:color];
    
    // Generate Quarter Notes
    for(int i = 1; i < 4; ++i)
    {
        InteractiveSoundObject *soundObject = [musicBar getSoundObject: i / SoundEffectController.BAR_RESOLUTION];
        [self CreatePlane:-quarterNoteOffset * i withSoundObject:soundObject withThickness:0 inColor:color];
    }
}

/*
 * Generates sound quadrants to be used in bar, will be used to populate the quadrant with sound pickups
 */
-(void)GenerateSoundQuadrants
{
    int numberOfQuadrantsToGenerate = [self getRandomNumberBetween:1 to:MAX_SOUND_QUADRANT];
    int quadrant;
    
    for(int i = 0; i < numberOfQuadrantsToGenerate; i++)
    {
        quadrant = [self getRandomNumberBetween:1 to:(GRID_ROWS * GRID_COLS)]; // used to calculate random quad and add to list
        [_quadrants addObject:[NSNumber numberWithInt:quadrant]];
    }
}

/*
 * Creates a plane and places it in the queue
 */
-(void)CreatePlane:(float)zOffset withSoundObject:(InteractiveSoundObject *)soundObject withThickness:(float)thickness inColor:(GLKVector4)color
{
    Plane* newPlane = [[Plane alloc]initWithPosition:worldPosition.z + zOffset soundObject:soundObject withThickness:thickness soundQuadrant:_quadrants inColor:color];
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

// return a random number from to
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (void)fadeAllPlaneColorsTo:(GLKVector4)color In:(float)time
{
    for (NSObject* o in m_Planes)
    {
        Plane* currentPlane = (Plane*)o;
        [currentPlane fadeToColor:color In:time];
    }
}

- (void)strobeAllPlanesBetweenColors:(GLKVector4)color1 And:(GLKVector4)color2 Every:(float)timeBetweenFlashes For:(float)timeLimit
{
    for (NSObject* o in m_Planes)
    {
        Plane* currentPlane = (Plane*)o;
        [currentPlane strobeBetweenColor:color1 And:color2 Every:timeBetweenFlashes For:timeLimit];
    }
}

@end