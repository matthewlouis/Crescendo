//
//  PlaneContainer.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Queue.h"

@interface PlaneContainer : NSObject

@property (strong, atomic)NSMutableArray *planes;

-(void)update;
-(void)draw;

@end
