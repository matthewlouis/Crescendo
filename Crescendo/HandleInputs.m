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

}

@end

@implementation HandleInputs

- (id)init
{
    if(self = [super init])
    {
        _moveBuffer = [NSMutableArray array];
        gridMovement = [GridMovement sharedClass];
    }
    
    return self;
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionLeft];
    [_moveBuffer enqueue:direction];
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionUp];
    [_moveBuffer enqueue:direction];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionRight];
    [_moveBuffer enqueue:direction];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    NSNumber *direction = [NSNumber numberWithInteger:MoveDirectionDown];
    [_moveBuffer enqueue:direction];
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
        player.timeToAnimate = PLAYER_ANIMATE_SPEED;
    }
    
    // The direction the player should head in by the amount of quadrants
    if ([numberDirection longValue] == (long)MoveDirectionUp)
    {
        moveDirection = GLKVector2Make(0, 2);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionRight)
    {
        moveDirection = GLKVector2Make(1, 0);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionDown)
    {
        moveDirection = GLKVector2Make(0, -2);
    }
    else if ([numberDirection longValue] == (long)MoveDirectionLeft)
    {
        moveDirection = GLKVector2Make(-1, 0);
    }
    
    // Updates the player's position
    if (!_isMoving)
    {
        _isMoving = true;
        GLKVector2 gridLocation = [gridMovement gridLocationWithMoveDirection:moveDirection];
        _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
        player->worldPosition = _translation;
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    MessageView * topView = recognizer.view.subviews[0];
    
    if([topView messageIsDisplayed] == YES)
    {
        [topView messageConfirmed];
        [PlaneContainer startGame];
        
        _isMoving = true;
        
        GLKVector2 gridLocation   = [gridMovement gridLocationWithGridQuadrant:GridQuadrantBottom];
        _translation = GLKVector3Make(gridLocation.x, gridLocation.y, player->worldPosition.z);
        
        // Enables all the swipe gestures once the title is gone
        for (UIGestureRecognizer *gesture in recognizer.view.gestureRecognizers)
        {
            if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]])
            {
                gesture.enabled = true;
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
