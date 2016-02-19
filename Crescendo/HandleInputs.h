//
//  HandleInputs.h
//  Crescendo
//
//  Created by Steven Chen on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Transformations.h"
#import "GridMovement.h"
#import "GameViewController.h"
#import "Player.h"

@interface HandleInputs : NSObject

/*!
 * @discussion Initialization
 * @param size The size of the device's view to setup grid locations
 */
- (id)initWithViewSize:(CGSize)size;
/*!
 * @discussion Handles the single tap gesture for placing the player at set coordinates
 * @param recognizer The recognizer passed in by GameViewController
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
/*!
 * @discussion Handles the pan gesture for moving the player to touch coordinates
 * @warning No longer used at the moment
 * @param recognizer The recognizer passed in by GameViewController
 */
- (void)handleSingleDrag:(UIPanGestureRecognizer *)recognizer;
/*!
 * @discussion Sets the projection matrix
 * @param matrix The projection matrix of the game's camera
 */
- (void)setProjectionMatrix:(GLKMatrix4)matrix;
/*!
 * @discussion Sets the model view matrix
 * @param matrix The model view matrix of the player
 */
- (void)setModelViewMatrix:(GLKMatrix4)matrix;
/*!
 * @discussion Sets a reference to the player
 * @param player A Player reference to be used for it's vectors data
 */
- (void)setPlayer:(Player *)player;
/*!
 * @discussion Gets the position of the player
 * @return A Vector3 of the position
 */
- (GLKVector3)Translation;
- (bool)isMoving;
= (bool)setIsMoving:(bool)flag;
/*!
 * @discussion First to respond to touch events occuring and setting start locations for pan gestures
 * @warning No longer used at the moment
 */
- (void)respondToTouchesBegan;
@end