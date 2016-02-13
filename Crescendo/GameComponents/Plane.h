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


@interface Plane : GameObject3D
{    
    
}

- (void)update:(float)TimePassed;
- (void)move:(GLKVector3)amount;
- (BOOL)checkCollision;




@end
