//
//  PlaneContainer.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "PlaneContainer.h"
#import "Crescendo-Swift.h"
#import "Constants.h"

@implementation PlaneContainer
{
    float totalTimePassed;
    float timeAccumBeforeStart;
}

static bool gameStarted;

- (id)init
{
    self = [super initWithName:"plane" shader:nil vertices:nil vertexCount:0];
    if (self)
    {
        self->m_SpawnDistance = -BAR_WIDTH * BARS_IN_SIGHT + (BAR_WIDTH / 4);
        
        // Default Plane Velocity of 5 per seconds
        [self setSpawnBarVelocity:BAR_WIDTH / 2];
    
        //Instantiate Music Player
        gameMusicPlayer = [[GameMusicPlayer alloc] initWithTempoListener:self];
        
        // Default BPM of 120
        self->m_BPM = [gameMusicPlayer getBPM];
        
        // Calculate Delays: TODO - grab from GameMusicPlayer
        [self setTimeSignature:FourFour];
    
        // Initialize a new Plane
        self->m_Bars = [[NSMutableArray alloc] init];
        
        self->buildBar = false;
        
        timeAccumBeforeStart = 0.0f;
    }
    
    return self;
}

- (void)CleanUp
{
    // Clean up all the Bars
    for (Bar* o in m_Bars)
    {
        [o CleanUp];
    }
    
    // Clean up self
    [super CleanUp];
}

/*
 * Creates a bar and places it in the queue
 */
- (void)CreateBar
{
    
    float step = SoundEffectController.DEFAULT_STEP;
    float barLength = SoundEffectController.SEQ_LENGTH;
    
    if(soundEffectController.barsGenerated == 0){
        [soundEffectController generateAndAddSection:step barLength:barLength];
    }
    
    Bar * newBar;
    //get musical info from soundeffectcontroller and remove it from the queue
    if(gameStarted){
        newBar = [[Bar alloc]initWithPosition:self->m_SpawnDistance atBPM: gameMusicPlayer.bpm usingMusicBar: soundEffectController._musicBars[0]];
    }else{
        newBar = [[Bar alloc]initWithPosition:self->m_SpawnDistance atBPM: gameMusicPlayer.bpm usingMusicBar: nil];
    }
    [soundEffectController removeSection];
    
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
    timeAccumBeforeStart += timePassed;
    
    if (timeAccumBeforeStart > TIME_BEFORE_SPEEDUP)
    {
        //Matt: test code to make the game go faster and faster: WORKS!
        totalTimePassed += timePassed;
        if(totalTimePassed > SPEEDUP_INTERVAL){
            totalTimePassed = 1;
            gameMusicPlayer.bpm *= SPEEDUP_AMOUNT;
            m_SpawnBarVelocity *= SPEEDUP_AMOUNT;
        }

    }
    
    if(timePassed)
    // Update all Bars
    for (NSObject* o in m_Bars)
    {
        Bar* currentBar = (Bar*)o;
        [currentBar update:timePassed];
    }
    
    // Clean up planes that are no longer valid
    while ([m_Bars peek] != nil)
    {
        Bar* nextBar = ((Bar*)[m_Bars peek]);
        
        if (nextBar->worldPosition.z > nextBar->m_BarWidth)
        {
            [self->children removeObject:(Bar*)[m_Bars peek]];
            [nextBar CleanUp];	
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
    
    [self findNextPlane];
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

- (void)findNextPlane
{
    bool done = false;
    
    // Iterate through all bars
    for (Bar* bar in m_Bars)
    {
        for (Plane* plane in bar->m_Planes)
        {
            if (plane->worldPosition.z < 0)
            {
                nextPlane = plane;
                done = true;
                break;
            }
        }
        if (done)
        {
            break;
        }
    }
}

/**
 *Start game (start generating obstacles and objects
 */
+(void)startGame{
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

/*
 * Pause audio
 */
-(void)pauseMusic{
    [gameMusicPlayer pause];
}

/*
 * Resume audio
 */
-(void)resumeMusic{
    [gameMusicPlayer resume];
}


@end
