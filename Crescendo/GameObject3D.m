//
//  3DGameObject.m
//  Crescendo
//
//  Created by Sean Wang on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameObject3D.h"

@implementation GameObject3D

-(GLKVector3)GetFoward
{
    GLKVector3 forwardVector = GLKVector3Make(0, 0, 1);
    GLKMatrix4 transformation = GLKMatrix4Multiply([self GetTranslationMatrix], [self GetRotationMatrix]);
    return GLKMatrix4MultiplyVector3(transformation, forwardVector);
}

-(GLKVector3)GetRight
{
    GLKVector3 rightVector = GLKVector3Make(1, 0, 0);
    GLKMatrix4 transformation = GLKMatrix4Multiply([self GetTranslationMatrix], [self GetRotationMatrix]);
    return GLKMatrix4MultiplyVector3(transformation, rightVector);
}

-(GLKVector3)GetUp
{
    GLKVector3 upVector = GLKVector3Make(0, 1, 0);
    GLKMatrix4 transformation = GLKMatrix4Multiply([self GetTranslationMatrix], [self GetRotationMatrix]);
    return GLKMatrix4MultiplyVector3(transformation, upVector);
}

-(GLKMatrix4)GetTranslationMatrix
{
    return GLKMatrix4MakeTranslation(worldPosition.x, worldPosition.y, worldPosition.z);
}

-(GLKMatrix4)GetRotationMatrix
{
    GLKVector3 forwardVec = [self GetFoward];
    GLKVector3 rightVec = [self GetRight];
    GLKVector3 upVec = [self GetUp];
    
    GLKMatrix4 rotationXMat = GLKMatrix4MakeRotation(rotation.x, rightVec.x, rightVec.y, rightVec.z);
    GLKMatrix4 rotationYMat = GLKMatrix4MakeRotation(rotation.y, upVec.x, upVec.y, upVec.z);
    GLKMatrix4 rotationZMat = GLKMatrix4MakeRotation(rotation.y, forwardVec.x, forwardVec.y, forwardVec.z);
    
    return GLKMatrix4Multiply(GLKMatrix4Multiply(rotationXMat, rotationYMat),rotationZMat);
}

@end