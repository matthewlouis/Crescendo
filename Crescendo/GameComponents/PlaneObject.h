//
//  PlaneObject.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "GameObject3D.h"


@import GLKit;

@class Plane;

@interface PlaneObject : GameObject3D
{
    
}

- (instancetype)initWithPlane:(Plane*)plane ;
-(void)updatePositionBasedOnPlane:(Plane *) plane;

@end
