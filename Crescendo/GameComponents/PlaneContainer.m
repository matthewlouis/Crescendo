//
//  PlaneContainer.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "PlaneContainer.h"
#import "Crescendo-Swift.h"

@implementation PlaneContainer

const float SECONDS_PER_MINUTE = 60.0f;

- (id)init
{
    self = [super initWithName:"plane" shader:nil vertices:nil vertexCount:0];
    if (self)
    {
        // Default Plane Velocity of 5 per seconds
        [self setPlaneVelocity:5.0f];
    
        //Instantiate Music Player
        gameMusicPlayer = [[GameMusicPlayer alloc] initWithTempoListener:self];
        
        // Default BPM of 120
        self->m_BPM = [gameMusicPlayer getBPM];
        
        // Calculate Delays: TODO - grab from GameMusicPlayer
        [self setTimeSignature:FourFour];
    
        // Set Time on Screen
        [self setTimeOnScreen:10.0f];
    
        // Initialize a new Plane
        self->m_Planes = [[NSMutableArray alloc] init];
        
        self->buildBar = false;
    }
    
    return self;
}

/* 
 * Creates a plane and places it in the queue
 */
 -(void)CreatePlane
{
    Plane* newPlane = [[Plane alloc]initWithPosition:self->m_SpawnDistance];
    //newPlane->worldPosition.z = self->m_SpawnDistance;
    newPlane->m_PlaneVelocity = self->m_PlaneVelocity;
    [m_Planes enqueue: (newPlane)];
    [self->children addObject:newPlane];
}

/*
 * Returns the oldest plane in the queue
 */
-(Plane*)GetPlane
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
 * Set the time on screen and calculate the distance to be spawned
 */
-(void)setTimeOnScreen:(float)time
{
    m_TimeOnScreen = time;
    
    // Calculate distance required based on velocity
    m_SpawnDistance = -m_PlaneVelocity * m_TimeOnScreen;
}

/*
 * Set the velocity for the planes
 */
-(void)setPlaneVelocity:(float)velocity
{
    // Store velocity
    m_PlaneVelocity = velocity;
    
    // Calculate new distance required based on velocity
    m_SpawnDistance = -m_PlaneVelocity * m_TimeOnScreen;
}

/*
 * Updates all the planes based on the amount of time that has passed.
 */
 -(void)update:(float)timePassed
{
    // Update all planes
    for (NSObject* o in m_Planes)
    {
        Plane* currentPlane = (Plane*)o;
        [currentPlane update:timePassed];
    }
    
    // Clean up planes that are no longer valid
    while ([m_Planes peek] != nil && ((Plane*)[m_Planes peek])->worldPosition.z > 20)
    {
        [self->children removeObject:(Plane*)[m_Planes peek]];
        [m_Planes dequeue];
    }
    
    // Spawn new plane if flagged to do so.
    if (buildBar)
    {
        [self CreatePlane];
        buildBar = false;
    }
}

/**
 * Acts as a sort of "Tap Tempo" mechanism. When called, creates a plane in time with the music
 */
-(void)syncToBar{
    printf("\nstart of bar!");
    self->buildBar = true;
    
}

/*
 *Temporary music start
 */
-(void)startMusic{
    [gameMusicPlayer load];
    [gameMusicPlayer play];
}


@end
