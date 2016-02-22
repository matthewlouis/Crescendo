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
    float totalTimePassed;
    bool gameStarted;
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
    
    float step = SoundEffectController.DEFAULT_STEP;
    float barLength = SoundEffectController.SEQ_LENGTH;
    
    [soundEffectController generateAndAddSection:step barLength:barLength];
    
    //get musical info from soundeffectcontroller and remove it from the queue
    Bar* newBar = [[Bar alloc]initWithPosition:self->m_SpawnDistance usingMusicBar: soundEffectController._musicBars[0]];
    [soundEffectController removeSection];
    
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
    //Matt: test code to make the game go faster and faster: WORKS!
    totalTimePassed += timePassed;
    if(totalTimePassed > 5){
        totalTimePassed = 4;
        gameMusicPlayer.bpm += 1;
    }
    
    if(timePassed)
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
    self->buildBar = true;
    /*
    NSArray<MusicBar*> *barbar = soundEffectController._musicBars;
    for (MusicBar* bar in barbar)
    {
        if (bar != nil && bar.events.count > 0)
        {
            if (bar.events[0] != nil)
            {
                NSLog(@"%lu\n", bar.events.count);
                NSLog(@"%g\n", bar.events[0]._position);
            }
        }
    }
     */
}

/**
 *Start game (start generating obstacles and objects
 */
-(void)startGame{
    gameStarted = true;
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
