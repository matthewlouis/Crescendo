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
        // Initialize a new Plane
        self->Planes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/* 
 * Creates a plane and places it in the queue
 */
 -(void)CreatePlane
{
    Plane* newPlane = [[Plane alloc]init];
    newPlane->worldPosition.z = -20;
    [Planes enqueue: (newPlane)];
}

/*
 * Returns the oldest plane in the queue
 */
-(Plane*)GetPlane
{
    return (Plane*)[Planes peek];
}

/*
 * Updates all the planes based on the amount of time that has passed.
 */
 -(void)update:(float)TimePassed
{

    
    // Update all planes
    for (NSObject* o in Planes)
    {
        Plane* currentPlane = (Plane*)o;
        [currentPlane update:TimePassed];
    }
    
    // Clean up planes that are no longer valid
    while (((Plane*)[Planes peek])->worldPosition.z > 0 && [Planes peek] != nil)
    {
        [Planes dequeue];
    }
    
    // Keep track of time passed.
    timePassed += TimePassed;
    
    // If the amount of time that has passed is more than 2 seconds, spawn new plane
    if (timePassed > 2)
    {
        [self CreatePlane];
        timePassed = 0;
    }
}

@end
