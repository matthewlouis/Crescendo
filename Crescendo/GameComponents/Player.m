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
}

@end

@implementation Player


- (instancetype)init {
    if ((self = [super initWithName:"player" shader:nil vertices:(Vertex*) player_Vertices vertexCount:sizeof(player_Vertices) / sizeof(player_Vertices[0])])) {
        _playerSpeed = 20.0f;
        //[self loadTexture:@"mushroom.png"];
        //self.rotationY = M_PI;
        //self.rotationX = M_PI_2;
        self->worldPosition = GLKVector3Make(0, -1, 0);
        self->rotation = GLKVector3Make(-1.25, 3.14, 0);
        self->scale = GLKVector3Make(0.5, 0.5, 0.5);
        
        // Specify Drawing Mode
        renderMode = GL_TRIANGLES;
        
    }
    return self;
}

- (bool)moveUp:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time
{
    float checkPlayPosition = self->worldPosition.y;
    checkPlayPosition += time * _playerSpeed;
    if (checkPlayPosition >= moveToPosition.y)
    {
        self->worldPosition.y = moveToPosition.y;
        return false;
    }
    else
    {
        self->worldPosition.y += time * _playerSpeed;
        return true;
    }
}

- (bool)moveDown:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time
{
    float checkPlayPosition = self->worldPosition.y;
    checkPlayPosition -= time * _playerSpeed;
    if (checkPlayPosition <= moveToPosition.y)
    {
        self->worldPosition.y = moveToPosition.y;
        return false;
    }
    else
    {
        self->worldPosition.y -= time * _playerSpeed;
        return true;
    }
}

- (bool)moveLeft:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time
{
    float checkPlayPosition = self->worldPosition.x;
    checkPlayPosition -= time * _playerSpeed;
    if (checkPlayPosition <= moveToPosition.x)
    {
        self->worldPosition.x = moveToPosition.x;
        return false;
    }
    else
    {
        self->worldPosition.x -= time * _playerSpeed;
        return true;
    }
}

- (bool)moveRight:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time
{
    float checkPlayPosition = self->worldPosition.x;
    checkPlayPosition += time * _playerSpeed;
    if (checkPlayPosition >= moveToPosition.x)
    {
        self->worldPosition.x = moveToPosition.x;
        return false;
    }
    else
    {
        self->worldPosition.x += time * _playerSpeed;
        return true;
    }
}



@end
