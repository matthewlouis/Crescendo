//
//  PlaneObject.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "PlaneObject.h"
#import "cube.h"
#import "Crescendo-Swift.h"
#import "Plane.h"

@implementation PlaneObject

- (instancetype)initWithPlane:(Plane*)plane soundObject:(InteractiveSoundObject *)sound{
    if ((self = [super initWithName:"cube" shader:nil vertices:(Vertex*) cube_Vertices vertexCount:sizeof(cube_Vertices) / sizeof(cube_Vertices[0])])) {
        
        self->worldPosition = GLKVector3Make(0, 0, plane->worldPosition.z);
        //self->rotation = GLKVector3Make(-1.25, 3.14, 0);
        self->scale = GLKVector3Make(0.25, 0.25, 0.25);
        
        // Specify Drawing Mode
        renderMode = GL_TRIANGLES;
        
        self->soundObject = sound;
    }
    return self;
}



/*
 * Updates position on each plane object based on plane movement and object behaviour
 */
-(void)updatePositionBasedOnPlane:(Plane *) plane
{
    worldPosition.z = plane->worldPosition.z;
}


@end
