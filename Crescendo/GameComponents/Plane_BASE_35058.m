//
//  Plane.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Plane.h"
#import "Crescendo-Swift.h"


@implementation Plane


/**
 * Provides default parameter to generate empty planes (so we can start the game with no obstacles
 */
- (id)initWithPosition:(float)positon soundObject:(InteractiveSoundObject *)soundObject
{
    const Vertex vertices[8] = {
    {{1, 1, 0}, {1, 1, 1, 1}, {0.206538, 0.909188}, {-0.809017, 0.587785, 0.000000}},
    {{-1, 1, 0}, {1, 1, 1, 1}, {0.167902, 0.904787}, {-0.809017, 0.587785, 0.000000}},
    {{-1, 1, 0}, {1, 1, 1, 1}, {0.167902, 0.904787}, {-0.809017, 0.587785, 0.000000}},
    {{-1, -1, 0}, {1, 1, 1, 1}, {0.170951, 0.594958}, {-0.809017, 0.587785, 0.000000}},
    {{-1, -1, 0}, {1, 1, 1, 1}, {0.170951, 0.594958}, {-0.809017, 0.587785, 0.000000}},
    {{1, -1, 0}, {1, 1, 1, 1}, {0.170951, 0.594958}, {-0.809017, 0.587785, 0.000000}},
    {{1, -1, 0}, {1, 1, 1, 1}, {0.170951, 0.594958}, {-0.809017, 0.587785, 0.000000}},
    {{1, 1, 0}, {1, 1, 1, 1}, {0.206538, 0.909188}, {-0.809017, 0.587785, 0.000000}},
    };
    
    self = [super initWithName:"plane" shader:nil vertices:(Vertex*)vertices vertexCount:sizeof(vertices)/sizeof(Vertex)];
    
    if (self)
    {
        self->worldPosition = GLKVector3Make(0, 0, positon);
        self->rotation = GLKVector3Make(0, 0, 0);
        self->scale = GLKVector3Make(3.5, 3.5, 3.5);
        
        // Default Plane Velocity of 5 per second;
        self->m_Velocity = 0;
        
        // Specify line drawing mode and thickness.
        renderMode = GL_LINES;
        lineWidth = 1;

        
        [self updateLineWith];
    }
    
    if(soundObject != nil){
        // Initialize new plane object storage
        self->m_PlaneObjects = [[NSMutableArray alloc] init];
        
        [self CreatePlaneObject:soundObject];
    }
    
    
    return self;
}

/*
 * Update the plane based on the amount of time that has passed/
 */
- (void)update:(float)TimePassed
{
    worldPosition.z += m_Velocity * TimePassed;
    
    // Update all planeObjects
    for (NSObject* o in m_PlaneObjects)
    {
        PlaneObject* currentPlane = (PlaneObject*)o;
        [currentPlane updatePositionBasedOnPlane:self];
    }
    
    
    
    //[self updateLineWith];
}

/*
 * Updates the line width to be rendered based on distance from origin (assumed camera position
 */
- (void)updateLineWith
{
    lineWidth = (float)(80.0f / (-worldPosition.z + 5)) * m_LineThickness;
    if (lineWidth < 1)
    {
        lineWidth = 1;
    }
}

/*
 * Creates a plane and places it in the queue
 */
-(void)CreatePlaneObject:(InteractiveSoundObject *)soundObject
{
    if ([self getRandomNumberBetween:-1 to:1] == 1)
    {
    PlaneObject* newPlaneObject = [[PlaneObject alloc]initWithPlane:self];
    //newPlaneObject->worldPosition.x = [self randomMinFloat:0 MaxFloat:2] - 1;
    newPlaneObject->worldPosition.x = [self getRandomNumberBetween:-1 to:1];
    newPlaneObject->worldPosition.y = [self getRandomNumberBetween:0 to:1] - 0.5f;
    
    [m_PlaneObjects enqueue: (newPlaneObject)];
    [self->children addObject:newPlaneObject];
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}
/*
 * Cleans up Plane data
 */
-(void) CleanUp
{
    // Cleanup self
    [super CleanUp];
    
    // Clean up all plane objects
    for (GameObject3D* o in m_PlaneObjects)
    {
        [o CleanUp];
    }
}


@end
