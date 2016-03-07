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
@interface HandleInputs ()
{
    GridMovement *gridMovement;
    Player *player;
    
    GLKMatrix4 _modelViewMatrix;
    GLKMatrix4 _projectionMatrix;
    GLKVector3 _initialPosition;
    
    CGSize _view;
    float _aspectRatio;
}

@end

@implementation HandleInputs

- (id)initWithGameViewSize:(CGSize)view
{
    if(self = [super init])
    {
        _view = view;
        gridMovement = [[GridMovement alloc] initWithGridCount:GLKVector2Make(3.0, 3.0) deviceSize:_view planeSize:CGSizeMake(X_SCALE_FACTOR * 2, Y_SCALE_FACTOR * 2)];
    }
    
    return self;
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (!self.isMoving)
    {
        _isMoving = true;
        GLKVector2 gridLocation = [gridMovement gridLocationWithMoveDirection:GLKVector2Make(-1, 0)];
        _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
        player->worldPosition = _translation;
    }
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    if (!self.isMoving)
    {
        _isMoving = true;
        GLKVector2 gridLocation = [gridMovement gridLocationWithMoveDirection:GLKVector2Make(0, 2)];
        _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
        player->worldPosition = _translation;
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    if (!self.isMoving)
    {
        _isMoving = true;
        GLKVector2 gridLocation = [gridMovement gridLocationWithMoveDirection:GLKVector2Make(1, 0)];
        _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
        player->worldPosition = _translation;
    }
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    if (!self.isMoving)
    {
        _isMoving = true;
        GLKVector2 gridLocation = [gridMovement gridLocationWithMoveDirection:GLKVector2Make(0, -2)];
        _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
        player->worldPosition = _translation;
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    MessageView * topView = recognizer.view.subviews[0];
    
    //hack code to get player moving TODO: Steven please fix!
    CGPoint pointToMoveTo = [recognizer locationInView:recognizer.view];
    
    if([topView messageIsDisplayed] == YES){
        [topView messageConfirmed];
        [PlaneContainer startGame];
        pointToMoveTo = CGPointMake(recognizer.view.frame.size.width/2,recognizer.view.frame.size.width/2 - 20);
    }
    
    if (!self.isMoving)
    {
        CGPoint location          = pointToMoveTo;
//        GLKVector2 gridLocation   = [gridMovement gridLocation:GLKVector2Make(location.x, location.y)];
        GLKVector2 gridLocation   = [gridMovement gridLocationWithGridQuadrant:GridQuadrantBottom];

        //GLKVector3 translation    = [self Vector3D:gridLocation Width:recognizer.view.frame.size.width Height: recognizer.view.frame.size.height];
        GLKVector3 playerLocation = player->worldPosition;

        //translation = GLKVector3MultiplyScalar(translation, 5.0);
        //translation = GLKVector3Multiply(translation, player->scale);
        GLKVector3 translation    = GLKVector3Make(gridLocation.x, gridLocation.y, playerLocation.z);
        _translation = GLKVector3Make(translation.x, translation.y, playerLocation.z);

        _isMoving = true;
        
        if (playerLocation.x == _translation.x && playerLocation.y == _translation.y)
        {
            _moveDirection = MoveDirectionNone;
            _isMoving = false;
        }
        else
        {
            if (playerLocation.x == _translation.x && playerLocation.y < _translation.y)
            {
                _moveDirection = MoveDirectionUp;
            }
            else if (playerLocation.x < _translation.x && playerLocation.y < _translation.y)
            {
                _moveDirection = MoveDirectionUpRight;
            }
            else if (playerLocation.x < _translation.x && playerLocation.y == _translation.y)
            {
                _moveDirection = MoveDirectionRight;
            }
            else if (playerLocation.x < _translation.x && playerLocation.y > _translation.y)
            {
                _moveDirection = MoveDirectionDownRight;
            }
            else if (playerLocation.x == _translation.x && playerLocation.y > _translation.y)
            {
                _moveDirection = MoveDirectionDown;
            }
            else if (playerLocation.x > _translation.x && playerLocation.y > _translation.y)
            {
                _moveDirection = MoveDirectionDownLeft;
            }
            else if (playerLocation.x > _translation.x && playerLocation.y == _translation.y)
            {
                _moveDirection = MoveDirectionLeft;
            }
            else if (playerLocation.x > _translation.x && playerLocation.y < _translation.y)
            {
                _moveDirection = MoveDirectionUpLeft;
            }
        }
        recognizer.enabled = false; // Disabling the tap recognizer after the title is gone
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
