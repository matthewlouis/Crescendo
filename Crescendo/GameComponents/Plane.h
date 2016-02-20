//
//  Plane.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject3D.h"
#import <GLKit/GLKit.h>

@import GLKit;


@interface Plane : GameObject3D
{    
@public float m_Velocity;
@public float m_LineThickness;
@public float m_LocalZOffset;
}

- (void)move:(GLKVector3)amount;
- (BOOL)checkCollision;

- (void)updateLineWith;

@end
