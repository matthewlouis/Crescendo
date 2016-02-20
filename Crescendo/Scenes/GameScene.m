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
        if ([self.handleInput moveDirection] == MoveDirectionNone)
        {
            
        }
        else if ([self.handleInput moveDirection] == MoveDirectionUp)
        {
            self.handleInput.isMoving = [_player moveUp:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
        else if ([self.handleInput moveDirection] == MoveDirectionUpRight)
        {
            self.handleInput.isMoving = [_player moveRight:[self.handleInput translation] timeSinceLastUpdate:timePassed];
            [_player moveUp:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
        else if ([self.handleInput moveDirection] == MoveDirectionRight)
        {
            self.handleInput.isMoving = [_player moveRight:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
        else if ([self.handleInput moveDirection] == MoveDirectionDownRight)
        {
            self.handleInput.isMoving = [_player moveRight:[self.handleInput translation] timeSinceLastUpdate:timePassed];
            [_player moveDown:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
        else if ([self.handleInput moveDirection] == MoveDirectionDown)
        {
            self.handleInput.isMoving = [_player moveDown:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
        else if ([self.handleInput moveDirection] == MoveDirectionDownLeft)
        {
            self.handleInput.isMoving = [_player moveLeft:[self.handleInput translation] timeSinceLastUpdate:timePassed];
            [_player moveDown:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
        else if ([self.handleInput moveDirection] == MoveDirectionLeft)
        {
            self.handleInput.isMoving = [_player moveLeft:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
        else if ([self.handleInput moveDirection] == MoveDirectionUpLeft)
        {
            self.handleInput.isMoving = [_player moveLeft:[self.handleInput translation] timeSinceLastUpdate:timePassed];
            [_player moveUp:[self.handleInput translation] timeSinceLastUpdate:timePassed];
        }
    }
    //NSLog(@"%f, %f, %f", [self.handleInput Translation].x, [self.handleInput Translation].y, [self.handleInput Translation].z);
    [planeContainer update:timePassed];
    //[plane update:timePassed];
    //_player->rotation.x += 0.01f;
}




@end
