//
//  Player.m
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Player.h"
#import "playerModel.h"

//#import "mushroom.h"


@implementation Player


- (instancetype)initWithShader:(BaseEffect *)shader {
    if ((self = [super initWithName:"player" shader:shader vertices:(Vertex*) player_Human_GEO_player_Vertices vertexCount:sizeof(player_Human_GEO_player_Vertices) / sizeof(player_Human_GEO_player_Vertices[0])])) {
        
        //[self loadTexture:@"mushroom.png"];
        //self.rotationY = M_PI;
        //self.rotationX = M_PI_2;
        self->worldPosition = GLKVector3Make(0, 0, -10);
        self->rotation = GLKVector3Make(1.0, 0, 0);
        self->scale = GLKVector3Make(1, 1, 1);
        //self.matColor = GLKVector4Make(1, 0, 0, 1);
        
    }
    return self;
}


@end
