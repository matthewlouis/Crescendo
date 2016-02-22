//
//  Player.m
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Player.h"
#import "playerModel.h"

//#import "mushroom.h"

@interface Player ()
{
    float _playerSpeed;
    float _timeToAnimate;
    float _rotateDefault;
    float _rotateAmount;
}

@end

@implementation Player

- (instancetype)init {
    if ((self = [super initWithName:"player" shader:nil vertices:(Vertex*) player_Vertices vertexCount:sizeof(player_Vertices) / sizeof(player_Vertices[0])])) {
        _playerSpeed = 20.0f;
        _timeToAnimate = 0.4f;
        _rotateAmount = 1.0f;
        //[self loadTexture:@"mushroom.png"];
        //self.rotationY = M_PI;
        //self.rotationX = M_PI_2;
        self->worldPosition = GLKVector3Make(0, -1, 0);
        self->rotation = GLKVector3Make(-1.25, 3.14, 0);
        self->scale = GLKVector3Make(0.5, 0.5, 0.5);
        
        _rotateDefault = self->rotation.y;
        // Specify Drawing Mode
        renderMode = GL_TRIANGLES;
        
    }
    return self;
}

- (bool)moveTo:(GLKVector3)moveToPosition
{
    if (_timeElapsed / _timeToAnimate > 1.0f)
    {
        self->worldPosition = [self lerpStartVector:_startPosition withEndVector:moveToPosition lerpDistance:1.0f];
        
        if (_startPosition.x != moveToPosition.x)
        {
            if (_startPosition.x < moveToPosition.x)
            {
                self->rotation.y = [self lerp:_startRotation.y withEndValue:_startRotation.y - _rotateAmount lerpDistance:1.0f];
            }
            else if (_startPosition.x > moveToPosition.x)
            {
                self->rotation.y = [self lerp:_startRotation.y withEndValue:_startRotation.y + _rotateAmount lerpDistance:1.0f];
            }
        }
        _startPosition = self->worldPosition;
        _startRotation = self->rotation;
        _timeElapsed = 0;
        return false;
    }
    else
    {
        self->worldPosition = [self lerpStartVector:_startPosition withEndVector:moveToPosition lerpDistance:_timeElapsed/ _timeToAnimate];
        
        if (_startPosition.x != moveToPosition.x)
        {
            if (_startPosition.x < moveToPosition.x)
            {
                self->rotation.y = [self lerp:_startRotation.y withEndValue:_startRotation.y - _rotateAmount lerpDistance:_timeElapsed/ _timeToAnimate];
            }
            else
            {
                self->rotation.y = [self lerp:_startRotation.y withEndValue:_startRotation.y + _rotateAmount lerpDistance:_timeElapsed/ _timeToAnimate];
            }
        }
        return true;
    }
}

- (GLKVector3)lerpStartVector:(GLKVector3)startVector withEndVector:(GLKVector3)endVector lerpDistance:(float)percentage
{
    GLKVector3 result = GLKVector3Subtract(endVector, startVector);
    result = GLKVector3MultiplyScalar(result, percentage);
    result = GLKVector3Add(startVector, result);
    return result;
}

- (float)lerp:(float)startValue withEndValue:(float)endValue lerpDistance:(float)percentage
{
    return startValue + (endValue - startValue) * percentage;
}

@end
