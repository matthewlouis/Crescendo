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

@interface HandleInputs : NSObject

- (id)initWithTransformations:(Transformations*)t andGridMovement:(GridMovement*)g GameViewController:(GameViewController*)v;
- (void)setModelViewProjectionMatrix:(GLKMatrix4)m;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleSingleDrag:(UIPanGestureRecognizer *)recognizer;

@end