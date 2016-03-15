//
//  GameViewController.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class BaseEffect;

@interface GameViewController : GLKViewController

-(BaseEffect *)GetShader;

@end
