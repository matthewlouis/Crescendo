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
#import "GridMovement.h"

#define X_SCALE_FACTOR 3.5
#define Y_SCALE_FACTOR 2.5
#define Z_SCALE_FACTOR 3.5


@class InteractiveSoundObject;


@import GLKit;


@interface Plane : GameObject3D
{
@public float m_Velocity;
@public float m_LineThickness;
@public float m_LocalZOffset;
    
@public NSMutableArray *m_PlaneObjects;
@public float m_PlaneVelocity;
    
@private GridMovement *_gridMovement;
@private NSMutableArray *soundQuadrants;
}

- (void)move:(GLKVector3)amount;
- (BOOL)checkCollision;
- (id)initWithPosition:(float)positon soundObject: (InteractiveSoundObject *)soundObject withThickness:(float)thickness soundQuadrant:(NSMutableArray *)soundQuadrants;
- (void)update:(float)TimePassed;
//- (void)move:(GLKVector3)amount;
//- (BOOL)checkCollision;

- (void)updateLineWidth;
- (void)CreatePlaneObject:(InteractiveSoundObject *)soundObject;

@end
