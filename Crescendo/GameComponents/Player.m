//
//  Player.m
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "Player.h"
#import "playerModel.h"
#import "Easing.h"

//#import "mushroom.h"

@interface Player ()
{
    float _rotateDefault;
    float _rotateAmount;
    float _totalTimeElapsed;
    float _bobAmount;
    float _bobTime;
    float _bobScale;
    bool _isReverseBob;
}

@end

@implementation Player

- (instancetype)init {
    if ((self = [super initWithName:"player" shader:nil vertices:(Vertex*) player_Vertices vertexCount:sizeof(player_Vertices) / sizeof(player_Vertices[0])])) {
        _playerSpeed = 1.0f;
        _timeToAnimate = 0.5f;
        _rotateAmount = 2.0f;
        _bobAmount = 1.0f;
        _bobTime = 1.0f;
        _bobScale = 0.25f;
        _isReverseBob = false;
        //[self loadTexture:@"mushroom.png"];
        //self.rotationY = M_PI;
        //self.rotationX = M_PI_2;
        self->worldPosition = GLKVector3Make(0, -1, 0);
        self->rotation = GLKVector3Make(-1.25, 3.14 - 1, 0);
        self->scale = GLKVector3Make(0.5, 0.5, 0.5);
        
        _rotateDefault = self->rotation.y;
        // Specify Drawing Mode
        renderMode = GL_TRIANGLES;
        self->boundingSphereRadius = 0.2;
        
        // Set default color of red
        self->_color = GLKVector4Make(1.0f, 0.1f, 0.2f, 0.2);
    }
    return self;
}

- (void)updateBobMotion:(float)timeElapsed
{
    _totalTimeElapsed += timeElapsed;
    float result = SinusoidalEaseInOut(_totalTimeElapsed / _bobTime, 0, _bobAmount);
    
    // Ensures that the total time is exactly the bobTime if it exceeds it
    if (_totalTimeElapsed > _bobTime)
    {
        _totalTimeElapsed = _bobTime;
    }
    
    
    // Reverses the bob direction
    result = (1 - !_isReverseBob * 2) * (!_isReverseBob + result);
    
    if (result == 1 || result == -2)
    {
        result = -!_isReverseBob;
    }
    
    // Shifts the result by half
    _bob = result + _bobAmount / 2;
    
    _bob *= _bobScale;
    
    // Reverses and resets the time
    if (_totalTimeElapsed == _bobTime)
    {
        _totalTimeElapsed = 0;
        _isReverseBob = !_isReverseBob;
    }
    
}

- (bool)moveTo:(GLKVector3)moveToPosition
{
    float animationSpeed = _timeElapsed * _playerSpeed;
    
    if (animationSpeed > _timeToAnimate)
    {
        // When the animation is done
        self->worldPosition = moveToPosition;
        
        if (roundf(100 * _startPosition.x) / 100 != roundf(100 * moveToPosition.x) / 100)
        {
            if (_startPosition.x < moveToPosition.x)
            {
                // Rotation when moving right
                self->rotation.y = _startRotation.y - _rotateAmount;
            }
            else if (_startPosition.x > moveToPosition.x)
            {
                // Rotation when move left
                self->rotation.y = _startRotation.y + _rotateAmount;
            }
        }
        
        _startPosition = self->worldPosition;
        _startRotation = self->rotation;
        _timeElapsed = 0;
        
        return false;
    }
    else
    {
        // Animating
        self->worldPosition.x = _startPosition.x - CubicEaseInOut(animationSpeed / _timeToAnimate, 1, _startPosition.x - moveToPosition.x);
        self->worldPosition.y = _startPosition.y - CubicEaseInOut(animationSpeed / _timeToAnimate, 1, _startPosition.y - moveToPosition.y);
        if (roundf(100 * _startPosition.x) / 100 != roundf(100 * moveToPosition.x) / 100)
        {
            
            if (_startPosition.x < moveToPosition.x)
            {
                // Rotation when moving right
                self->rotation.y = _startRotation.y - SinusoidalEaseInOut(animationSpeed / _timeToAnimate, 1, _rotateAmount);
            }
            else
            {
                // Rotation when move left
                self->rotation.y = _startRotation.y + SinusoidalEaseInOut(animationSpeed / _timeToAnimate, 1, _rotateAmount);
            }
        }
        
        return true;
    }
}

@end
