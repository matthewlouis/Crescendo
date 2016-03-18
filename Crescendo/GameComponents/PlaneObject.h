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
@class InteractiveSoundObject;

@interface PlaneObject : GameObject3D
{
    @public InteractiveSoundObject *soundObject;
@private Vertex *vertices;
    
}

- (instancetype)initWithPlane:(Plane*)plane soundObject:(InteractiveSoundObject *)soundObject objectType:(int)objectType;
-(void)updatePositionBasedOnPlane:(Plane *) plane;

@end
