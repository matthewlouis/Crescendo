//
//  PlaneContainer.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Queue.h"

#import "Plane.h"

@interface PlaneContainer : NSObject
{
    @public NSMutableArray *Planes;
    @private float timePassed;
}

-(void)CreatePlane;
-(Plane*)GetPlane;
-(void)update:(float)TimePassed;
-(void)draw;

@end
