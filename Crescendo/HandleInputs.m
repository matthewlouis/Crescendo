//
//  HandleInputs.m
//  Crescendo
//
//  Created by Steven Chen on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandleInputs.h"
#import "PlaneContainer.h"
#import "Player.h"

@interface HandleInputs ()
{
    GridMovement *gridMovement;
    Player *player;
    
    GLKMatrix4 _modelViewMatrix;
    GLKMatrix4 _projectionMatrix;
    GLKVector3 _initialPosition;
    
    NSMutableArray *_moveBuffer;
    CGPoint _startPanPosition;
    
    float _maxPanVelocity;
    float _panVelocityThreshold;
    float _lastDirection;
    
    bool _isValidSwipe;
}

@end

@implementation HandleInputs

- (id)init
{
    if(self = [super init])
    {
        _moveBuffer = [NSMutableArray array];
        gridMovement = [GridMovement sharedClass];
        _panVelocityThreshold = 100.0f;
        _isValidSwipe = true;
    }
    
    return self;
}


- (void)handleSwipes:(UIPanGestureRecognizer *)recognizer
{
    // Starting position of the user tap once the pan gesture starts
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _startPanPosition = [recognizer translationInView:recognizer.view];
        _isValidSwipe = false;
    }

    if (!_isValidSwipe)
    {
        CGPoint currentPanPosition = [recognizer translationInView:recognizer.view];
        float distance = GLKVector2Length(GLKVector2Make(currentPanPosition.x - _startPanPosition.x, currentPanPosition.y - _startPanPosition.y));
        if (distance > 10)
        {
            _isValidSwipe = true;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            float angle = atan2(velocity.y, velocity.x) * 180 / M_PI - 45 / 2 + 180;
            _lastDirection = ceilf(angle / 45.0f);
            
            // Appends 0 direction to 8
            if (_lastDirection == 0)
            {
                _lastDirection = 8;
            }
        }
    }
    
    float direction = -1.0;
    
    if (_isValidSwipe)
    {
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        float velocityLength = sqrtf(powf(velocity.x, 2) + powf(velocity.y, 2));
        float angle = atan2(velocity.y, velocity.x) * 180 / M_PI - 45 / 2 + 180;
        direction = ceilf(angle / 45.0f);
        
        // Appends 0 direction to 8
        if (direction == 0)
        {
            direction = 8;
        }
        
        
        // Checks for a valid swipe motion
        if (direction > _lastDirection + 1 || direction < _lastDirection - 1)
        {
            _isValidSwipe = false;
            if (_lastDirection == 8 && (direction == 7 || direction == 8 || direction == 1))
            {
                _isValidSwipe = true;
            }
            
            if (_lastDirection == 1 && (direction == 8 || direction == 1 || direction == 2))
            {
                _isValidSwipe = true;
            }
        }
        
        // Sets the highest velocity produced by the player
        if (_maxPanVelocity < velocityLength)
        {
            _maxPanVelocity = velocityLength;
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        // Only registers if the user's swipe motion goes past a threshold
        if (direction != -1.0 && _isValidSwipe && _maxPanVelocity >= _panVelocityThreshold)
        {
            if (direction == 4)
            {
                // Right
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionRight];
                [_moveBuffer enqueue:direction];
            }
            else if (direction == 3)
            {
                // UpRight
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionUpRight];
                [_moveBuffer enqueue:direction];
            }
            else if (direction == 2)
            {
                // Up
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionUp];
                [_moveBuffer enqueue:direction];
            }
            else if (direction == 1)
            {
                // UpLeft
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionUpLeft];
                [_moveBuffer enqueue:direction];
            }
            else if (direction == 8)
            {
                // Left
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionLeft];
                [_moveBuffer enqueue:direction];
            }
            else if (direction == 7)
            {
                // Downleft
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionDownLeft];
                [_moveBuffer enqueue:direction];
            }
            else if (direction == 6)
            {
                // Down
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionDown];
                [_moveBuffer enqueue:direction];
            }
            else if (direction == 5)
            {
                // DownRight
                NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionDownRight];
                [_moveBuffer enqueue:direction];
            }
        }
        
        _maxPanVelocity = 0;
        _isValidSwipe = true;
    }
}

- (void)updateMovement
{
    GLKVector2 moveDirection;
    
    NSNumber *numberDirection = [_moveBuffer peek];
    
    // Checks the player movement buffer
    if (numberDirection == nil)
    {
        return;
    }
    
    // Pop the movement stored
    if (!_isMoving)
    {
        numberDirection = [_moveBuffer dequeue];
        player.playerSpeed = PLAYER_ANIMATE_SPEED;
    }
    
    // The direction the player should head in by the amount of quadrants
    if ([numberDirection longValue] == (long)MoveDirectionUp)
    {
        moveDirection = GLKVector2Make(0, 1);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionRight)
    {
        moveDirection = GLKVector2Make(1, 0);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionDown)
    {
        moveDirection = GLKVector2Make(0, -1);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionLeft)
    {
        moveDirection = GLKVector2Make(-1, 0);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionUpRight)
    {
        moveDirection = GLKVector2Make(1, 1);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionUpLeft)
    {
        moveDirection = GLKVector2Make(-1, 1);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionDownRight)
    {
        moveDirection = GLKVector2Make(1, -1);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionDownLeft)
    {
        moveDirection = GLKVector2Make(-1, -1);
    }
    
    // Updates the player's position
    if (!_isMoving)
    {
        GLKVector2 gridLocation = [gridMovement grid2x2LocationWithMoveDirection:moveDirection];
        
        if (gridLocation.x == player->worldPosition.x && gridLocation.y == player->worldPosition.y)
        {
            _isMoving = false;
        }
        else
        {
            _isMoving = true;
            _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
            player->worldPosition = _translation;
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    
    if([_messageView messageIsDisplayed] == YES)
    {
        [_messageView messageConfirmed];
        
        [PlaneContainer startGame];
        
        _isMoving = true;
        
        GLKVector2 gridLocation   = [gridMovement gridLocationWithGrid2x2Quadrant:Grid2x2QuadrantBottomRight];
        _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
        
        // Enables all the swipe gestures once the title is gone
        for (UIGestureRecognizer *gesture in recognizer.view.gestureRecognizers)
        {
            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
            {
                gesture.enabled = true;
            }
        }
    }
}

- (GLKVector3)Vector3D:(GLKVector2)point2D Width:(int)w Height:(int)h
{
    double x = 2.0 * point2D.x / w - 1;
    double y = -2.0 * point2D.y / h + 1;
    
    bool isInvertible;
    
    GLKMatrix4 modelViewMatrix = [player GetTranslationMatrix];
    GLKMatrix4 _modelViewProjectionMatrix = GLKMatrix4Multiply(modelViewMatrix, _projectionMatrix);
    GLKMatrix4 viewProjInv = GLKMatrix4Invert(_modelViewProjectionMatrix, &isInvertible);

    GLKVector3 point3D = GLKVector3Make(x, y, 0.0f);
    
    return GLKMatrix4MultiplyVector3(viewProjInv, point3D);
}

- (void)setPlayer:(Player *)_player
{
    player = _player;

    GLKVector2 gridLocation   = [gridMovement gridLocationWithGridQuadrant:GridQuadrantBottom];
    GLKVector3 playerLocation = player->worldPosition;
    GLKVector3 translation    = GLKVector3Make(gridLocation.x, gridLocation.y, playerLocation.z);

    _translation = GLKVector3Make(translation.x, translation.y - 5, playerLocation.z);
    _player->worldPosition = _translation;
    
}

- (void)setProjectionMatrix:(GLKMatrix4)matrix
{
    _projectionMatrix = matrix;
}

- (void)setModelViewMatrix:(GLKMatrix4)matrix
{
    _modelViewMatrix = matrix;
}

- (void)respondToTouchesBegan
{
    //[transformations start];
}

@end
