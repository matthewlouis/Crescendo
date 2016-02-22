//
//  Player.h
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameObject3D.h"

@interface Player : GameObject3D

@property (nonatomic, assign) float timeElapsed;
@property (nonatomic, assign) GLKVector3 startPosition;
@property (nonatomic, assign) GLKVector3 startRotation;

- (instancetype)init;
- (bool)moveTo:(GLKVector3)moveToPosition;
- (GLKVector3)lerpStartVector:(GLKVector3)startVector withEndVector:(GLKVector3)endVector lerpDistance:(float)percentage;
- (float)lerp:(float)startValue withEndValue:(float)endValue lerpDistance:(float)percentage;

@end