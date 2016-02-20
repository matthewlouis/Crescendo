//
//  HandleInputs.h
//  Crescendo
//
//  Created by Steven Chen on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Transformations.h"
#import "GridMovement.h"
#import "GameViewController.h"
#import "Crescendo-Swift.h"]


@interface HandleInputs : NSObject

- (id)initWithViewSize:(CGSize)size;
- (void)setModelViewProjectionMatrix:(GLKMatrix4)m;
- (GLKMatrix4)modelViewMatrix:(float)time;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleSingleDrag:(UIPanGestureRecognizer *)recognizer;
- (void)respondToTouchesBegan;
- (void)animateMovement:(float)frame;

@end