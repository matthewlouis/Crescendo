//
//  Plane.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Plane.h"
#import "Crescendo-Swift.h"
#import "Constants.h"
#import "GridMovement.h"

@implementation Plane


/**
 * Provides default parameter to generate empty planes (so we can start the game with no obstacles
 */
- (id)initWithPosition:(float)positon soundObject:(InteractiveSoundObject *)soundObject withThickness:(float)thickness soundQuadrant:(NSMutableArray *)soundQuadrants
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
        self->scale = GLKVector3Make(X_SCALE_FACTOR, Y_SCALE_FACTOR, Z_SCALE_FACTOR);
        
        // Initialize velocity;
        self->m_Velocity = 0;
        
        // Specify line drawing mode and thickness.     
        _gridMovement = [GridMovement sharedClass];
        
        self->renderMode = GL_LINES;
        self->lineWidth = 0;
        
        self->m_LineThickness = thickness;

        self->color = GLKVector4Make(0.1, 1.0, 0.1, 1);
        
        self->soundQuadrants = soundQuadrants;
        
        [self updateLineWidth];
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
    [super update:TimePassed];
    
    [self updateLineWidth];
    
    worldPosition.z += m_Velocity * TimePassed;
    
    // Update all planeObjects
    for (NSObject* o in m_PlaneObjects)
    {
        PlaneObject* currentPlane = (PlaneObject*)o;
        [currentPlane updatePositionBasedOnPlane:self];
    }
}

/*
 * Updates the line width to be rendered based on distance from origin (assumed camera position
 */
- (void)updateLineWidth
{
    lineWidth = (float)((BAR_WIDTH * 5) / (-worldPosition.z + BAR_WIDTH)) * m_LineThickness;
    if (lineWidth < 1)
    {
        lineWidth = 1;
    }
}

/*
 * Populates a list of available quadrants based on a 2x3 grid. top and bottom, left center and right.
 */
-(void)PopulateAvailableQuadrants
{
    
    [availableQuadrants addObject:@(GridQuadrantBottom)];
    [availableQuadrants addObject:@(GridQuadrantBottomLeft)];
    [availableQuadrants addObject:@(GridQuadrantBottomRight)];
    [availableQuadrants addObject:@(GridQuadrantTop)];
    [availableQuadrants addObject:@(GridQuadrantTopLeft)];
    [availableQuadrants addObject:@(GridQuadrantTopRight)];
}

/*
 * Creates a plane and places it in the queue
 */
-(void)CreatePlaneObject:(InteractiveSoundObject *)soundObject
{
    int quadrant;
    for(int i = 0 ; i < soundQuadrants.count; i++)
    {
        quadrant = [soundQuadrants[i] intValue];
        [self CreateSoundPickupwithSoundObject:soundObject withQuadrant:quadrant];
        [availableQuadrants removeObject:@(quadrant)];
        
    }

}

-(void)CreateSoundPickupwithSoundObject:(InteractiveSoundObject *)soundObject withQuadrant:(int)quadrant
{
    // create new object
    //newPlaneObject->worldPosition.x = [self randomMinFloat:0 MaxFloat:2] - 1;
    PlaneObject* newPlaneObject = [[PlaneObject alloc]initWithPlane:self soundObject:soundObject objectType:SoundPickup];
    // bounding sphere for collision detection
    newPlaneObject->boundingSphereRadius = 1;
    
    // gets position based on quadrant
    GLKVector3 position = [_gridMovement getGridLocation:quadrant];
    newPlaneObject->worldPosition.x = position.x;
    newPlaneObject->worldPosition.y = position.y;
    
    // add new object to world
    [m_PlaneObjects enqueue: (newPlaneObject)];
    [self->children addObject:newPlaneObject];
}

-(void)CreateCollideableObjectwithSoundObject:(InteractiveSoundObject *)soundObject
{
    int quadrant;
    
     if ([self getRandomNumberBetween:-1 to:1] == 1) 
     {
         // create new object
         //newPlaneObject->worldPosition.x = [self randomMinFloat:0 MaxFloat:2] - 1;
         PlaneObject* newPlaneObject = [[PlaneObject alloc]initWithPlane:self soundObject:soundObject objectType:Collideable];
     
     
     int row = [self getRandomNumberBetween:1 to:GRID_ROWS]; // used to calculate row of object
     quadrant = [self getRandomNumberBetween:1 to:GRID_COLS]; // random quadrant between 1 and 3
     
     // calculates quadrant on second row between 7-9.
     if(row == 2)
     {
     quadrant += 6;
     }
     
     // bounding sphere for collision detection
     newPlaneObject->boundingSphereRadius = 2;
     
     // gets position based on quadrant
     GLKVector3 position = [_gridMovement getGridLocation:quadrant];
     newPlaneObject->worldPosition.x = position.x;
     newPlaneObject->worldPosition.y = position.y;
     
     // add new object to world
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
