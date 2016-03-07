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
        
        // Setup the handleinputs and grid size
        self.handleInput = handleInput;
        [self.handleInput setPlayer:_player];
        
        // Create plane container and its planes
        planeContainer = [[PlaneContainer alloc]init];
        [self->children addObject:planeContainer];
        
        //debug to show where player collides with plane objects
        Plane *collisionPlane = [[Plane alloc]initWithPosition:0.0 soundObject:nil];
        collisionPlane->lineWidth = 4;
        [self->children addObject:collisionPlane];

        [planeContainer startMusic];
    }
    return self;
}

- (void) updateWithDeltaTime:(float)timePassed;
{
    
    if ([self.handleInput isMoving])
    {
        _player.timeElapsed += timePassed;
        self.handleInput.isMoving = [_player moveTo:[self.handleInput translation]];
    }
    else
    {
        _player.startPosition = _player->worldPosition;
        _player.startRotation = _player->rotation;
        _player.timeElapsed = 0.0f;
    }
    
    [planeContainer update:timePassed];
}




@end
