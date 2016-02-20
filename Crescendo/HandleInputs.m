//
//  HandleInputs.m
//  Crescendo
//
//  Created by Steven Chen on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandleInputs.h"

@interface HandleInputs ()
{
    GridMovement *gridMovement;
    Player *player;
    
    GLKMatrix4 _modelViewMatrix;
    GLKMatrix4 _projectionMatrix;
    
    CGSize _view;
    float _aspectRatio;
}

@end

@implementation HandleInputs

- (id)initWithViewSize:(CGSize)size
{
    if(self = [super init])
    {
        gridMovement = [[GridMovement alloc] initWithGridCount:GLKVector2Make(3.0f, 2.0f) Size:GLKVector2Make(size.width, size.height)];
        _view = size;
    }
    
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    MessageView * topView = recognizer.view.subviews[0];
    
    if([topView messageIsDisplayed] == YES){
        [topView messageConfirmed];
        return;
    }
    
    if (!self.isMoving)
    {
        CGPoint location          = [recognizer locationInView:recognizer.view];
        GLKVector2 gridLocation   = [gridMovement gridLocation:GLKVector2Make(location.x, location.y)];
        GLKVector3 translation    = [self Vector3D:gridLocation Width:recognizer.view.frame.size.width Height: recognizer.view.frame.size.height];
        GLKVector3 playerLocation = player->worldPosition;

        translation = GLKVector3MultiplyScalar(translation, 5.0);
        //translation = GLKVector3Multiply(translation, player->scale);
        
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
    }
    
    NSLog(@"Move Direction: %li", (long)_moveDirection);
    //_translation = [transformations position:GLKVector2Make(translation.x, translation.y)];
}

- (void)handleSingleDrag:(UIPanGestureRecognizer *)recognizer
{
    //CGPoint translation = [recognizer translationInView:recognizer.view];
    //float x = translation.x/recognizer.view.frame.size.width;
    //float y = translation.y/recognizer.view.frame.size.height;
    //float aspectRatio = recognizer.view.frame.size.width / recognizer.view.frame.size.height;

    //[transformations translate:GLKVector2Make(x, y) withMultiplier:1.0f aspectRatio:aspectRatio];
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
    GLKVector2 location       = GLKVector2Make(_view.width / 2, _view.height / 2);
    GLKVector2 gridLocation   = [gridMovement gridLocation:location];
    GLKVector3 translation    = [self Vector3D:gridLocation Width:_view.width Height: _view.height];
    GLKVector3 playerLocation = player->worldPosition;
    
    translation = GLKVector3MultiplyScalar(translation, 5.0);
    //translation = GLKVector3Multiply(translation, player->scale);
    
    _translation = GLKVector3Make(translation.x, translation.y, playerLocation.z);
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
