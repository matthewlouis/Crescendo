//
//  Plane.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Queue.h"
#import "GameObject3D.h"
#import <GLKit/GLKit.h>
#import "PlaneObject.h"


@import GLKit;


@interface Plane : GameObject3D
{
@public NSMutableArray *m_PlaneObjects;
@public float m_PlaneVelocity;
}

- (id)initWithPosition:(float)positon;
- (void)update:(float)TimePassed;
//- (void)move:(GLKVector3)amount;
//- (BOOL)checkCollision;

- (void)updateLineWith;
- (void)CreatePlaneObject;



@end
