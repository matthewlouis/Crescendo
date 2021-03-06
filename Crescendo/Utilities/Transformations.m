//
//  Transformations.m
//  Crescendo
//
//  Created by Steven Chen on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Transformations.h"

@interface Transformations ()
{
    // 1
    // Depth
    float   _depth;
    // Scale
    float   _scaleStart;
    float   _scaleEnd;
    // Translation
    GLKVector2  _translationStart;
    GLKVector2  _translationEnd;
    GLKVector2 _lastLocation;
    GLKVector2 _lastTranslation;
    // Rotation
    GLKVector3      _rotationStart;
    GLKQuaternion   _rotationEnd;
    // Vectors
    GLKVector3      _front;
    GLKMatrix4 _modelViewMatrix;
}

@end

@implementation Transformations

- (id)initWithDepth:(float)z Scale:(float)s Translation:(GLKVector2)t Rotation:(GLKVector3)r
{
    if(self = [super init])
    {
        // 2
        // Depth
        _depth = z;
        // Scale
        _scaleEnd = s;
        // Translation
        _translationEnd = t;
        _lastTranslation = _translationEnd;
        _lastLocation = GLKVector2Make(0.0f, 0.0f);
        // Vectors
        _front = GLKVector3Make(0.0f, 0.0f, 1.0f);
        r.z = GLKMathDegreesToRadians(r.z);
        _rotationEnd = GLKQuaternionIdentity;
        _rotationEnd = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-r.z, _front), _rotationEnd);
    }
    
    return self;
}

- (void)start
{
    _scaleStart = _scaleEnd;
    _translationStart = GLKVector2Make(0.0f, 0.0f);
}

- (void)setTranslationStart:(GLKVector2)t
{
    _translationStart = t;
}

- (void)scale:(float)s
{
    _scaleEnd = s * _scaleStart;
}

- (void)setDepth:(float)depth
{
    _depth = depth;
}
- (void)setModelViewMatrix:(GLKMatrix4)modelViewMatrix
{
    _modelViewMatrix = modelViewMatrix;
}
- (GLKVector3)position:(GLKVector2)t
{
    t = GLKVector2MultiplyScalar(t, _depth);
    t = GLKVector2MultiplyScalar(t, _scaleEnd);

    return GLKVector3Make(t.x, t.y, _depth);
}

- (void)translate2:(GLKVector2)t withMultiplier:(float)m aspectRatio:(float)aR
{
    // 1
    t.y *= m;
    t.x *= m * aR;
    
    // 2
    float dx = _translationEnd.x + (t.x-_lastLocation.x);
    float dy = _translationEnd.y - (t.y-_lastLocation.y);
    
    // 3
    _translationEnd = GLKVector2Make(dx, dy);
    _lastLocation = t;
}

- (void)translate:(GLKVector2)t withMultiplier:(float)m aspectRatio:(float)aR
{
    // 1
    t.y *= m;
    t.x *= m * aR;
    
    // 2
    float dx = _translationEnd.x + (t.x-_translationStart.x);
    float dy = _translationEnd.y - (t.y-_translationStart.y);
    
    // 3
    _translationEnd = GLKVector2Make(dx, dy);
    _translationStart = GLKVector2Make(t.x, t.y);
}

- (void)rotate:(GLKVector3)r withMultiplier:(float)m
{
}

- (GLKMatrix4)getModelViewMatrix:(float)time
{
    // 3
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(_rotationEnd);
    
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, _translationEnd.x, _translationEnd.y, -_depth);
    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, quaternionMatrix);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, _scaleEnd, _scaleEnd, _scaleEnd);

    return modelViewMatrix;
}

- (GLKVector3)getTranslationVector3
{
    return GLKVector3Make(_translationEnd.x, _translationEnd.y, -_depth);
}

@end
