//
//  Plane.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Plane.h"



@implementation Plane

float const SPEED = 5.0f;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        GLfloat vertices[216] =
        {
            // Data layout for each line below is:
            // positionX, positionY, positionZ,     normalX, normalY, normalZ,
            0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
            0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
            0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
            0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
            0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
            0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
            
            0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
            -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
            0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
            0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
            -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
            -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
            
            -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
            -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
            -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
            -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
            -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
            -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
            
            -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
            0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
            -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
            -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
            0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
            0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
            
            0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
            -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
            0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
            0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
            -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
            -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
            
            0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
            -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
            0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
            0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
            -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
            -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
        };

        
        self->worldPosition = GLKVector3Make(0, 0, 0);
        
        memcpy(self->vertices, vertices, sizeof(float)*216);
    }
    return self;
}

- (void)update:(float)TimePassed
{
    worldPosition.z += SPEED * TimePassed;
}

@end
