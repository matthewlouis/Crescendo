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

/*!
 * @discussion Creates a static class of itself if it is called the first time else returns the existing one
 */
+ (id)sharedClass;

/*!
 * @discussion Initializes and constructs the cells sizes based on device and plane size
 * @param deviceSize The view's size of the device
 * @param planeSize The size of the plane
 * @warning Should call sharedClass to initialize
 */
- (id)initWithGridCount:(GLKVector2)count deviceSize:(CGSize)deviceSize planeSize:(CGSize)planeSize;

/*!
 * @discussion Calculates each quadrants' center location in terms of world positions
 */
- (void)calculateCellsCenter;

/*!
 * @discussion Returns the world position based on the 2x2 quadrant specified with a z value of 0
 * @param quadrant One of the 4 available quadrants
 */
- (GLKVector3)getGrid2x2Location:(Grid2x2Quadrant)quadrant;

/*!
 * @discussion Returns the world position based on the quadrant specified with a z value of 0
 * @param quadrant One of the 9 available quadrants
 */
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
 * @discussion Returns the 2x2 quadrant's world location based on which direction to move in and by how much
 * @param moveDirection Direction the object should move in eg. (-1, 1) for Left and Up movement
 * @warning moveDirection value should not be greater than 1
 */
- (GLKVector2)grid2x2LocationWithMoveDirection:(GLKVector2)moveDirection;

/*!
 * @discussion Returns the quadrant's world location based on which direction to move in and by how much
 * @param moveDirection Direction the object should move in eg. (-1, 1) for Left and Up movement
 * @warning moveDirection should not be greater than 2
 */
- (GLKVector2)gridLocationWithMoveDirection:(GLKVector2)moveDirection;

/*!
 * @discussion Returns the 2x2 quadrant's world location based on the quadrant specified
 * @param quadrant One of the set 2x2 quadrant locations defined
 */
- (GLKVector2)gridLocationWithGrid2x2Quadrant:(Grid2x2Quadrant)quadrant;

/*!
 * @discussion Returns the quadrant's world location based on the quadrant specified
 * @param quadrant One of the set quadrant locations defined
 */
- (GLKVector2)gridLocationWithGridQuadrant:(GridQuadrant)quadrant;

@end
