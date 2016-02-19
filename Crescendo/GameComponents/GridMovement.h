//
//  GridMovement.h
//  Crescendo
//
//  Created by Steven Chen on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GridMovement : NSObject

- (id)initWithGridCount:(GLKVector2)count Size:(GLKVector2)size;
- (void)calculateCellsCenter;
- (void)debugLoop;
- (GLKVector2)gridLocation:(GLKVector2)screenLocation;

@end
