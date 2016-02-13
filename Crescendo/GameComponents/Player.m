//
//  Player.m
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Player.h"
//#import "playerModel.h"

#import "mushroom.h"


@implementation Player


- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"mushroom" shader:shader vertices:(Vertex*) Mushroom_Cylinder_mushroom_Vertices vertexCount:sizeof(Mushroom_Cylinder_mushroom_Vertices) / sizeof(Mushroom_Cylinder_mushroom_Vertices[0])])) {
        
        [self loadTexture:@"mushroom.png"];
        self.rotationY = M_PI;
        self.rotationX = M_PI_2;
        self.scale = 0.5;
        //self.matColor = GLKVector4Make(1, 0, 0, 1);
        
    }
    return self;
}


@end
