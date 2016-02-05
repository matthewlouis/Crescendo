//
//  Plane.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface Plane : NSObject
{
    @public GLfloat vertices[216];
    @public GLKVector3 worldPosition;
}

- (void)update;
- (void)move:(GLKVector3)amount;
- (BOOL)checkCollision;




@end
