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
#import "HandleInputs.h"



@implementation GameScene{
    CGSize _gameArea;
    Player *_player;
    Plane* plane;
    
    PlaneContainer* planeContainer;
    
    float _sceneOffset;
}

- (instancetype)initWithShader:(BaseEffect *)shader HandleInputs:(HandleInputs *)handleInput {
    
    if ((self = [super initWithName:"GameScene" shader:shader vertices:nil vertexCount:0])) {
        
        // Create the initial scene position (i.e. camera)
        self->worldPosition = GLKVector3Make(0, 0, 0);
        //self.rotationX = GLKMathDegreesToRadians(-20);
        
        // Create player near bottom center of screen
        _player = [[Player alloc] initWithShader:shader];
        [self->children addObject:_player];
        
        self.handleInput = handleInput;
        [self.handleInput setPlayer:_player];
        // Create plane container and its planes
        planeContainer = [[PlaneContainer alloc]init];
        [self->children addObject:planeContainer];
        
        [planeContainer startMusic];
    }
    return self;
}

- (void) updateWithDeltaTime:(float)timePassed;
{
    [self.handleInput setModelViewMatrix:([_player GetModelViewMatrix])];
    
    if ([self.handleInput isMoving])
    {
        if (_player->worldPosition.x < [self.handleInput Translation].x)
        {
            _player->worldPosition.x++;
        }
        else
        {
            _player->worldPosition.x--;
        }
    }
    //NSLog(@"%f, %f, %f", [self.handleInput Translation].x, [self.handleInput Translation].y, [self.handleInput Translation].z);
    [planeContainer update:timePassed];
    //[plane update:timePassed];
    //_player->rotation.x += 0.01f;
}


@end
