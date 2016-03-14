//
//  GridMovement.h
//  Crescendo
//
//  Created by Steven Chen on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Constants.h"   



@interface GridMovement : NSObject

+ (id)sharedClass;

/*!
 * @discussion Initializes and constructs the cells sizes based on device and plane size
 * @param deviceSize The view's size of the device
 * @param planeSize The size of the plane
 */
- (id)initWithGridCount:(GLKVector2)count deviceSize:(CGSize)deviceSize planeSize:(CGSize)planeSize;

/*!
 * @discussion Calculates each quadrants' center location in terms of world positions
 */
- (void)calculateCellsCenter;
- (GLKVector3)getGridLocation:(GridQuadrant)quadrant;

/*!
 * @discussion Random debug loop
 */
- (void)debugLoop;

/*!
 * @discussion Returns the quadrant's world location based on the screen coordinates
 * @param screenLocation Location of where the input is
 */
- (GLKVector2)gridLocation:(GLKVector2)screenLocation;

/*!
 * @discussion Returns the quadrant's world location based on which direction to move in and by how much
 * @param moveDirection Direction the object should move in, one argument must be 0
 */
- (GLKVector2)gridLocationWithMoveDirection:(GLKVector2)moveDirection;

/*!
 * @discussion Returns the quadrant's world location based on the quadrant specified
 * @param quadrant One of the set quadrant locations defined
 */
- (GLKVector2)gridLocationWithGridQuadrant:(GridQuadrant)quadrant;

@end
