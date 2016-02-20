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
{
@private SoundEffectController *soundEffectController;
}


- (id)init
{
    self = [super initWithName:"plane" shader:nil vertices:nil vertexCount:0];
    if (self)
    {
        self->m_SpawnDistance = -40.0f;
        
        // Default Plane Velocity of 5 per seconds
        [self setSpawnBarVelocity:5.0f];
    
        //Instantiate Music Player
        gameMusicPlayer = [[GameMusicPlayer alloc] initWithTempoListener:self];
        
        // Default BPM of 120
        self->m_BPM = [gameMusicPlayer getBPM];
        
        // Calculate Delays: TODO - grab from GameMusicPlayer
        [self setTimeSignature:FourFour];
    
        // Initialize a new Plane
        self->m_Bars = [[NSMutableArray alloc] init];
        
        self->buildBar = false;
    }
    
    return self;
}

/*
 * Creates a bar and places it in the queue
 */
- (void)CreateBar
{
    Bar* newBar = [[Bar alloc]init];
    newBar->worldPosition.z = self->m_SpawnDistance;
    newBar->m_Velocity = self->m_SpawnBarVelocity;
    [newBar updatePlanePositions];
    [m_Bars enqueue:newBar];
    [self->children addObject:newBar];
}

/*
 * Sets the time signature and calculates all the delays
 */
-(void)setTimeSignature:(TimeSignature)timeSig
{
    // Set Time signature
    m_TimeSignature = timeSig;
}

/*
 * Set the velocity for the planes
 */
-(void)setSpawnBarVelocity:(float)velocity
{
    // Store velocity
    m_SpawnBarVelocity = velocity;
}

/*
 * Updates all the planes based on the amount of time that has passed.
 */
 -(void)update:(float)timePassed
{
    // Update all planes
    for (NSObject* o in m_Bars)
    {
        Bar* currentBar = (Bar*)o;
        [currentBar update:timePassed];
    }
    
    // Clean up planes that are no longer valid
    while ([m_Bars peek] != nil)
    {
        Bar* nextBar = ((Bar*)[m_Bars peek]);
        
        if (nextBar->worldPosition.z > 20)
        {
            [self->children removeObject:(Bar*)[m_Bars peek]];
            [m_Bars dequeue];
        }
        else
        {
            break;
        }
    }
    
    // Spawn new plane if flagged to do so.
    if (buildBar)
    {
        [self CreateBar];
        buildBar = false;
    }
}

/*
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
    
    soundEffectController = [[SoundEffectController alloc]initWithMusicPlayer:gameMusicPlayer];
    
    [gameMusicPlayer play];
    
    [self CreateBar];
}


@end
