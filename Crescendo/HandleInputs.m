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
    GLKVector3 _translation;

    float _aspectRatio;
    bool isMoving;
}

@end

@implementation HandleInputs

- (id)initWithViewSize:(CGSize)size
{
    if(self = [super init])
    {
        gridMovement = [[GridMovement alloc] initWithGridCount:GLKVector2Make(3.0f, 2.0f) Size:GLKVector2Make(size.width, size.height)];
    }
    
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location        = [recognizer locationInView:recognizer.view];
    GLKVector2 gridLocation = [gridMovement gridLocation:GLKVector2Make(location.x, location.y)];
    GLKVector3 translation  = [self Vector3D:gridLocation Width:recognizer.view.frame.size.width Height: recognizer.view.frame.size.height];
    float playerDepth       = player->worldPosition.z;
    
    translation = GLKVector3MultiplyScalar(translation, -playerDepth / 2);
    translation = GLKVector3Multiply(translation, player->scale);
    
    _translation = GLKVector3Make(translation.x, translation.y, playerDepth);
    
    isMoving = true;
    //_translation = [transformations position:GLKVector2Make(translation.x, translation.y)];
}

- (void)handleSingleDrag:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    float x = translation.x/recognizer.view.frame.size.width;
    float y = translation.y/recognizer.view.frame.size.height;
    float aspectRatio = recognizer.view.frame.size.width / recognizer.view.frame.size.height;

    //[transformations translate:GLKVector2Make(x, y) withMultiplier:1.0f aspectRatio:aspectRatio];
}

- (GLKVector3)Vector3D:(GLKVector2)point2D Width:(int)w Height:(int)h
{
    double x = 2.0 * point2D.x / w - 1;
    double y = -2.0 * point2D.y / h + 1;
    
    bool isInvertible;
    
    GLKMatrix4 modelViewMatrix = [player GetModelViewMatrix];
    GLKMatrix4 _modelViewProjectionMatrix = GLKMatrix4Multiply(modelViewMatrix, _projectionMatrix);
    GLKMatrix4 viewProjInv = GLKMatrix4Invert(_modelViewProjectionMatrix, &isInvertible);

    GLKVector3 point3D = GLKVector3Make(x, y, 0.0f);
    
    return GLKMatrix4MultiplyVector3(viewProjInv, point3D);
}

- (void)setPlayer:(Player *)_player
{
    player = _player;
    _translation = _player->worldPosition;
}

- (void)setProjectionMatrix:(GLKMatrix4)matrix
{
    _projectionMatrix = matrix;
}

- (void)setModelViewMatrix:(GLKMatrix4)matrix
{
    _modelViewMatrix = matrix;
}

- (GLKVector3)Translation
{
    return _translation;
}

- (void)respondToTouchesBegan
{
    //[transformations start];
}

- (bool)isMoving
{
    return isMoving;
}
- (void)setIsMoving:(bool)flag
{
    isMoving = flag;
}

@end
