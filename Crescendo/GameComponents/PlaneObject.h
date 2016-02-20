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

//Matt: texture property but unsure of types
- (instancetype)initWithPlane:(Plane*)plane ;
//-(void)move:(GLKVector3)amount;
-(void)updatePositionBasedOnPlane:(Plane *) plane;
@end
