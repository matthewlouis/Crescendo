//
//  Transformations.h
//  Crescendo
//
//  Created by Steven Chen on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Transformations : NSObject

- (id)initWithDepth:(float)z Scale:(float)s Translation:(GLKVector2)t Rotation:(GLKVector3)r;
- (void)start;
- (void)scale:(float)s;
- (void)translate:(GLKVector2)t withMultiplier:(float)m aspectRatio:(float)aR;
- (void)setDepth:(float)depth;
- (void)translate2:(GLKVector2)t withMultiplier:(float)m aspectRatio:(float)aR;
- (GLKVector3)position:(GLKVector2)t;
- (void)setTranslationStart:(GLKVector2)t;
- (void)rotate:(GLKVector3)r withMultiplier:(float)m;
- (GLKMatrix4)getModelViewMatrix:(float)time;
- (GLKVector3)getTranslationVector3;

@end
