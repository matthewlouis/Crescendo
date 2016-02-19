//
//  GameScene.m
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-13.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameScene.h"

#import "Player.h"
#import "PlaneContainer.h"

@implementation GameScene{
    CGSize _gameArea;
    Player *_player;
    
    float _sceneOffset;
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"GameScene" shader:shader vertices:nil vertexCount:0])) {
        
        // Create the initial scene position (i.e. camera)
        self->worldPosition = GLKVector3Make(0, 0, 0);
        //self.rotationX = GLKMathDegreesToRadians(-20);
        
        // Create player near bottom center of screen
        _player = [[Player alloc] initWithShader:shader];
        [self->children addObject:_player];
        
        // Create plane container and its planes
    
        
        
        
    }
    return self;
}

- (void) update
{
    _player->rotation.x += 0.01f;
}


@end
