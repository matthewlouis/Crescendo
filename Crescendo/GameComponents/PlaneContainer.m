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
    float musicTimePassed;
    float adjust;
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
        adjust = -0.175;
        
        // Set default spawn color
        self->spawnColor = GLKVector4Make(0, 0, 0, 1);
    }
    
    return self;
}

-(void)dealloc{
    gameMusicPlayer = nil;
    soundEffectController = nil;
}


- (void)CleanUp
{
    [gameMusicPlayer cleanUp];
    gameMusicPlayer = nil;
    soundEffectController = nil;
    
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
        newBar = [[Bar alloc]initWithPosition:self->m_SpawnDistance atBPM: gameMusicPlayer.bpm usingMusicBar: soundEffectController._musicBars[0] inColor:spawnColor];
    }else{
        newBar = [[Bar alloc]initWithPosition:self->m_SpawnDistance atBPM: gameMusicPlayer.bpm usingMusicBar: nil inColor:spawnColor];
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
    
    if(!gameStarted && gameMusicPlayer.songStarted){
        musicTimePassed += timePassed;
        
        //play for 2 bars, adjustment compensates for initial rewind delay
        if(musicTimePassed >= 60/gameMusicPlayer.bpm * 7 + adjust){
            musicTimePassed = 0;
            [gameMusicPlayer rewind];
            if(adjust != 0){
                adjust = 0;
            }
        }
    }
    
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

- (void)fadeAllBarsTo:(GLKVector4)color In:(float)time
{
    for (Bar* bar in m_Bars)
    {
        [bar fadeAllPlaneColorsTo:color In:time];
    }
}

- (void)strobeAllBarsBetweenColors:(GLKVector4)color1 And:(GLKVector4)color2 Every:(float)timeBetweenFlashes For:(float)timeLimit
{
    for (Bar* bar in m_Bars)
    {
        [bar strobeAllPlanesBetweenColors:color1 And:color2 Every:timeBetweenFlashes For:timeLimit];
    }
}

+(BOOL)gameStarted{
    return gameStarted;
}

+(void)notifyStopGame{
    gameStarted = NO;
}

@end
