//
//  PlaneContainer.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "PlaneContainer.h"

@implementation PlaneContainer

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self->Planes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// Creates a plane and places it in the queue
-(void)CreatePlane
{
    Plane* newPlane = [[Plane alloc]init];
    newPlane->worldPosition.z = -20;
    [Planes enqueue: (newPlane)];
}

-(Plane*)GetPlane
{
    return (Plane*)[Planes peek];
}

-(void)update:(float)TimePassed
{
    // Update all planes
    for (NSObject* o in Planes)
    {
        [(Plane*)o update:TimePassed];
    }
    
    timePassed += TimePassed;
    if (timePassed > 2)
    {
        [self CreatePlane];
        timePassed = 0;
    }
}

@end
