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
#import "PlaneModel.h"
#import "PlaneContainer.h"

@implementation Plane


/**
 * Provides default parameter to generate empty planes (so we can start the game with no obstacles
 */
- (id)initWithPosition:(float)positon soundObject:(InteractiveSoundObject *)soundObject withThickness:(float)thickness soundQuadrant:(NSMutableArray *)soundQuadrantsForPickups inColor:(GLKVector4)color ofType:(ObjectType)otype
{
    self = [super initWithName:"plane" shader:nil vertices:(Vertex*)plane_vertices vertexCount:sizeof(plane_vertices)/sizeof(Vertex)];
    
    if (self)
    {
        self->type = otype;
        
        self->worldPosition = GLKVector3Make(0, 0, positon);
        self->rotation = GLKVector3Make(0, 0, 0);
        self->scale = GLKVector3Make(X_SCALE_FACTOR, Y_SCALE_FACTOR, Z_SCALE_FACTOR);
        
        // Initialize velocity;
        self->m_Velocity = 0;
        
        // Specify line drawing mode and thickness.     
        
        
        self->renderMode = GL_LINES;
        self->lineWidth = 0;
        
        _gridMovement = [GridMovement sharedClass];
        
        self->m_LineThickness = thickness;

        self->_color = color;
        
        self->soundQuadrants = soundQuadrantsForPickups;
        [self PopulateAvailableQuadrants];
        collideableDifficulty = COLLIDEABLE_FACTOR;
        
        [self resetColorState];
        [self updateLineWidth];
    }
    
  
        // Initialize new plane object storage
        self->m_PlaneObjects = [[NSMutableArray alloc] init];
    
    if([PlaneContainer gameStarted]){
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
        [currentPlane updatePositionBasedOnPlane:self Time:TimePassed];
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
    availableQuadrants = [[NSMutableArray alloc]init];
    // based in 2x2 quadrant
    [availableQuadrants addObject:[NSNumber numberWithInt:Grid2x2QuadrantBottomLeft]];
    [availableQuadrants addObject:[NSNumber numberWithInt:Grid2x2QuadrantBottomRight]];
    [availableQuadrants addObject:[NSNumber numberWithInt:Grid2x2QuadrantTopLeft]];
    [availableQuadrants addObject:[NSNumber numberWithInt:Grid2x2QuadrantTopRight]];
}

/*
 * Creates a plane and places it in the queue
 */
-(void)CreatePlaneObject:(InteractiveSoundObject *)soundObject
{
    int quadrant;
    for(int i = 0 ; i < soundQuadrants.count; i++)
    {
        if (soundObject !=nil) {
            quadrant = [soundQuadrants[i] intValue];
            [self CreateSoundPickupwithSoundObject:soundObject withQuadrant:quadrant];
            [availableQuadrants removeObject:@(quadrant)];
        }
        else
        {
            ;
        }
        
        
    }
    
    // creates the rest of the objects based on remaining quadrants. other objects are collidable/damaging and powerpickups
    
    [self CreateCollideableObjectwithSoundObject:soundObject];
    //[self CreatePowerPickupwithSoundObject:soundObject];

}

-(void)CreateSoundPickupwithSoundObject:(InteractiveSoundObject *)soundObject withQuadrant:(int)quadrant
{
    if(availableQuadrants.count >=1)
    {
        
    // create new object
    //newPlaneObject->worldPosition.x = [self randomMinFloat:0 MaxFloat:2] - 1;
    PlaneObject* newPlaneObject = [[PlaneObject alloc]initWithPlane:self soundObject:soundObject objectType:SoundPickup];
    // bounding sphere for collision detection
    newPlaneObject->boundingSphereRadius = 2;
    
    // gets position based on quadrant
    GLKVector3 position = [_gridMovement getGrid2x2Location:quadrant];
    newPlaneObject->worldPosition.x = position.x;
    newPlaneObject->worldPosition.y = position.y;
    
    // add new object to world
    [m_PlaneObjects enqueue: (newPlaneObject)];
    [self->children addObject:newPlaneObject];
    }
}

-(void)CreateCollideableObjectwithSoundObject:(InteractiveSoundObject *)soundObject
{
    int quadrant;
    int chance;
    // pick random amount of collideable objects for plane
    int amountPerPlane = [self getRandomNumberBetween:0 to:(availableQuadrants.count -1)];
    for(int i = 0; i < amountPerPlane; i++)
    {
        chance = [self getRandomNumberBetween:1 to:collideableDifficulty];
        
        if (chance == 1)
        {
            // create new object
            //newPlaneObject->worldPosition.x = [self randomMinFloat:0 MaxFloat:2] - 1;
            int randomQuadIndex = [self getRandomNumberBetween:0 to:(availableQuadrants.count-1)];
            
            PlaneObject* newPlaneObject = [[PlaneObject alloc]initGlassCollidableWithPlane:self soundObject:SoundEffectController.OBSTACLE_NOTE];
            
            
            // bounding sphere for collision detection
            newPlaneObject->boundingSphereRadius = 2;
            quadrant = [[availableQuadrants objectAtIndex:randomQuadIndex] intValue];
            // gets position based on quadrant
            GLKVector3 position = [_gridMovement getGrid2x2Location:quadrant];
            newPlaneObject->worldPosition.x = position.x;
            newPlaneObject->worldPosition.y = position.y;
            [availableQuadrants removeObjectAtIndex:randomQuadIndex];
            
            // add new object to world
            [m_PlaneObjects enqueue: (newPlaneObject)];
            [self->children addObject:newPlaneObject];
        }

    }
    
    
}

-(void)CreatePowerPickupwithSoundObject:(InteractiveSoundObject *)soundObject
{
    int quadrant;
    
    if ([self getRandomNumberBetween:1 to:15] == 1)
    {
        // create new object
        //newPlaneObject->worldPosition.x = [self randomMinFloat:0 MaxFloat:2] - 1;
        PlaneObject* newPlaneObject = [[PlaneObject alloc]initPowerPickupWithPlane:self soundObject:soundObject];
        int randomQuadIndex = [self getRandomNumberBetween:0 to:(availableQuadrants.count-1)];
        // bounding sphere for collision detection
        newPlaneObject->boundingSphereRadius = 2;
        quadrant = [[availableQuadrants objectAtIndex:randomQuadIndex] intValue];
        // gets position based on quadrant
        GLKVector3 position = [_gridMovement getGrid2x2Location:quadrant];
        newPlaneObject->worldPosition.x = position.x;
        newPlaneObject->worldPosition.y = position.y;
        
        [availableQuadrants removeObjectAtIndex:randomQuadIndex];
        
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
