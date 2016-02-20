//
//  Plane.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Plane.h"



@implementation Plane


- (id)initWithPosition:(float)positon
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
        self->scale = GLKVector3Make(1, 1, 1);
        
        // Default Plane Velocity of 5 per second;
        self->m_PlaneVelocity = 2.5;
        
        // Specify line drawing mode and thickness.
        renderMode = GL_LINES;
        [self updateLineWith];
        
        
        
    }
    
    // Initialize new plane object storage
    self->m_PlaneObjects = [[NSMutableArray alloc] init];
    
    [self CreatePlaneObject];
    
    
    return self;
}

/*
 * Update the plane based on the amount of time that has passed/
 */
- (void)update:(float)TimePassed
{
    worldPosition.z += m_PlaneVelocity * TimePassed;
    
    // Update all planeObjects
    for (NSObject* o in m_PlaneObjects)
    {
        PlaneObject* currentPlane = (PlaneObject*)o;
        [currentPlane updatePositionBasedOnPlane:self];
    }
    
    [self updateLineWith];
}

/*
 * Updates the line width to be rendered based on distance from origin (assumed camera position
 */
- (void)updateLineWith
{
    lineWidth = (int)(20.0f / (-worldPosition.z + 5));
    if (lineWidth < 1)
    {
        lineWidth = 1;
    }
}

/*
 * Creates a plane and places it in the queue
 */
-(void)CreatePlaneObject
{
    PlaneObject* newPlaneObject = [[PlaneObject alloc]initWithPlane:self];
    newPlaneObject->worldPosition.x = -1.0f;
    //newPlaneObject->worldPosition.y = 0.0f;
    //newPlaneObject->worldPosition.z = self->worldPosition.z;
    
    [m_PlaneObjects enqueue: (newPlaneObject)];
    [self->children addObject:newPlaneObject];
}


@end
