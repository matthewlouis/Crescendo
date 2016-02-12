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
    }
    
    return self;
}

- (void)start
{
    _scaleStart = _scaleEnd;
    _translationStart = GLKVector2Make(0.0f, 0.0f);
}

- (void)scale:(float)s
{
    _scaleEnd = s * _scaleStart;
}

- (void)position:(GLKVector2)t
{
    _translationEnd = t;
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

- (GLKMatrix4)getModelViewMatrix
{
    // 3
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, _translationEnd.x, _translationEnd.y, -_depth);
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, _scaleEnd, _scaleEnd, _scaleEnd);
    
    return modelViewMatrix;
}

@end
