//
//  Constants.h
//  Crescendo
//
//  Created by Sean Wang on 2016-02-20.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

static float SECONDS_PER_MINUTE = 60.0f;
static float DEFAULT_BPM = 120.0f;
static float BAR_WIDTH = 40.0f;
static float BARS_IN_SIGHT = 2;

static int GRID_ROWS = 2;
static int GRID_COLS = 3;

typedef NS_ENUM(NSInteger, GridQuadrant)
{
    GridQuadrantBottomLeft  = 1,
    GridQuadrantBottom      = 2,
    GridQuadrantBottomRight = 3,
    GridQuadrantLeft        = 4,
    GridQuadrantCenter      = 5,
    GridQuadrantRight       = 6,
    GridQuadrantTopLeft     = 7,
    GridQuadrantTop         = 8,
    GridQuadrantTopRight    = 9,
};

typedef NS_ENUM(NSInteger, ObjectType)
{
    SoundPickup             = 1,
    Collideable             = 2,
    PowerPickup             = 3,
    Plane1                  = 4,
    Plane2                  = 5,
    Plane3                  = 6,
    Plane4                  = 7,
};


// sound quadrant generation max number
static int MAX_SOUND_QUADRANT = 2;


//Music player constants
static int   DRUM_TRACK = 3;

// SPEEDUP CONSTANTS
static float TIME_BEFORE_SPEEDUP = 60;
static float SPEEDUP_INTERVAL = 3;
static float SPEEDUP_AMOUNT = 1.01f;

// Amplitude Smoothing
static float MAX_AMPLITUDE_SHIFT = 0.5f;
static float AMPLITUDE_SCALE = 5;

#endif /* Constants_h */
