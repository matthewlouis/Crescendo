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
    GLKMatrix4 _modelViewProjectionMatrix;
    Transformations *transformations;
    GridMovement *gridMovement;
    GLKVector2 _position;
    float _aspectRatio;
    float _timeElasped;
}

@end

@implementation HandleInputs

- (id)initWithViewSize:(CGSize)size
{
    if(self = [super init])
    {
        gridMovement = [[GridMovement alloc] initWithGridCount:GLKVector2Make(3.0f, 2.0f) Size:GLKVector2Make(size.width, size.height)];
        transformations = [[Transformations alloc] initWithDepth:1.0f Scale:0.25f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    }
    
    return self;
}

- (void)setModelViewProjectionMatrix:(GLKMatrix4)m
{
    _modelViewProjectionMatrix = m;
}

- (GLKMatrix4)modelViewMatrix:(float)time
{
    return [transformations getModelViewMatrix:time];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    MessageView * topView = recognizer.view.subviews[0];
    
    if([topView messageIsDisplayed] == YES){
        [topView messageConfirmed];
        return;
    }
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    GLKVector2 translation = [gridMovement gridLocation:GLKVector2Make(location.x, location.y)];
    
    GLKVector3 test = [self Vector3D:translation Width:recognizer.view.frame.size.width Height: recognizer.view.frame.size.height];
    
    NSLog(@"Placing Model At: (X: %f, Y: %f)", test.x, test.y);
    
    [transformations position:GLKVector2Make(test.x, test.y)];
    
    //[transformations setTranslationStart:GLKVector2Make(location.x, location.y)];
    float x = translation.x/recognizer.view.frame.size.width;
    float y = translation.y/recognizer.view.frame.size.height;
    _aspectRatio = recognizer.view.frame.size.width / recognizer.view.frame.size.height;
    
    NSLog(@"x %f, y %f", x, y);
    
    _position = GLKVector2Make(x, y);
}

- (void)animateMovement:(float)frame
{
    _timeElasped = frame;
}

- (void)handleSingleDrag:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    float x = translation.x/recognizer.view.frame.size.width;
    float y = translation.y/recognizer.view.frame.size.height;
    float aspectRatio = recognizer.view.frame.size.width / recognizer.view.frame.size.height;
    NSLog(@"x %f, y %f", x, y);
    [transformations translate:GLKVector2Make(x, y) withMultiplier:1.0f aspectRatio:aspectRatio];
}

- (GLKVector3)Vector3D:(GLKVector2)point2D Width:(int)w Height:(int)h
{
    double x = 2.0 * point2D.x / w - 1;
    double y = -2.0 * point2D.y / h + 1;
    
    bool isInvertible;
    GLKMatrix4 viewProjInv = GLKMatrix4Invert(_modelViewProjectionMatrix, &isInvertible);
    
    GLKVector3 point3D = GLKVector3Make(x, y, 0.0f);
    
    return GLKMatrix4MultiplyVector3(viewProjInv, point3D);
}

- (void)respondToTouchesBegan
{
    [transformations start];
}

@end
