//
//  Player.h
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameObject3D.h"

@interface Player : GameObject3D

- (instancetype)initWithShader:(BaseEffect *)shader;
- (bool)moveUp:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time;
- (bool)moveDown:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time;
- (bool)moveLeft:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time;
- (bool)moveRight:(GLKVector3)moveToPosition timeSinceLastUpdate:(float)time;

@end
