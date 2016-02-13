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
}

@end

@implementation HandleInputs

- (id)initWithTransformations:(Transformations*)t andGridMovement:(GridMovement*)g GameViewController:(GameViewController*)v
{
    if(self = [super init])
    {
        transformations = t;
        gridMovement = g;
    }
    
    return self;
}

- (void)setModelViewProjectionMatrix:(GLKMatrix4)m
{
    _modelViewProjectionMatrix = m;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    GLKVector2 translation = [gridMovement getGridLocation:GLKVector2Make(location.x, location.y)];
    
    GLKVector3 test = [self get3DVector:translation Width:recognizer.view.frame.size.width Height: recognizer.view.frame.size.height];
    
    [transformations position:GLKVector2Make(test.x, test.y)];
}

- (void)handleSingleDrag:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    float x = translation.x/recognizer.view.frame.size.width;
    float y = translation.y/recognizer.view.frame.size.height;
    float aspectRatio = recognizer.view.frame.size.width / recognizer.view.frame.size.height;

    [transformations translate:GLKVector2Make(x, y) withMultiplier:1.0f aspectRatio:aspectRatio];
}

- (GLKVector3)get3DVector:(GLKVector2)point2D Width:(int)w Height:(int)h
{
    double x = 2.0 * point2D.x / w - 1;
    double y = -2.0 * point2D.y / h + 1;
    
    bool isInvertible;
    GLKMatrix4 viewProjInv = GLKMatrix4Invert(_modelViewProjectionMatrix, &isInvertible);
    
    GLKVector3 point3D = GLKVector3Make(x, y, 0.0f);
    
    return GLKMatrix4MultiplyVector3(viewProjInv, point3D);
}

@end
