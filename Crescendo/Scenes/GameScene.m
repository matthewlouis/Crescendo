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
    float _playerSpeed;
}

- (instancetype)initWithShader:(BaseEffect *)shader HandleInputs:(HandleInputs *)handleInput {
    
    if ((self = [super initWithName:"GameScene" shader:shader vertices:nil vertexCount:0])) {
        
        // Create the initial scene position (i.e. camera)
        self->worldPosition = GLKVector3Make(0, 0, 0);
        //self.rotationX = GLKMathDegreesToRadians(-20);
        
        // Create player near bottom center of screen

        _player = [[Player alloc] init];
        [self->children addObject:_player];
        
        self.handleInput = handleInput;
        [self.handleInput setPlayer:_player];
        
        // Create plane container and its planes
        planeContainer = [[PlaneContainer alloc]init];
        [self->children addObject:planeContainer];
        
        _playerSpeed = 3.0f;
        [planeContainer startMusic];
    }
    return self;
}

- (void) updateWithDeltaTime:(float)timePassed;
{
 
    
    //_player->worldPosition = [self.handleInput translation];
    

    if ([self.handleInput isMoving])
    {
        _player.timeElapsed += timePassed;
        if ([self.handleInput moveDirection] == MoveDirectionNone)
        {
            
        }
        else
        {
            self.handleInput.isMoving = [_player moveTo:[self.handleInput translation]];
        }
    }
    else
    {
        _player.startPosition = _player->worldPosition;
        _player.startRotation = _player->rotation;
        _player.timeElapsed = 0.0f;
    }
    //NSLog(@"%f, %f, %f", [self.handleInput Translation].x, [self.handleInput Translation].y, [self.handleInput Translation].z);
    [planeContainer update:timePassed];
    //[plane update:timePassed];
    //_player->rotation.x += 0.01f;
}




@end
