//
//  Plane.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Plane.h"



@implementation Plane



- (id)init
{
    self = [super init];
    
    if (self)
    {
        GLfloat plainData[216] =
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

        
        self.gPlainVertexData = plainData;
    }
    return self;
}


@end
