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

typedef NS_ENUM(NSInteger, MoveDirection)
{
    MoveDirectionNone      = 0,
    MoveDirectionUp        = 1,
    MoveDirectionUpRight   = 2,
    MoveDirectionRight     = 3,
    MoveDirectionDownRight = 4,
    MoveDirectionDown      = 5,
    MoveDirectionDownLeft  = 6,
    MoveDirectionLeft      = 7,
    MoveDirectionUpLeft    = 8,
};

@interface HandleInputs : NSObject

@property (nonatomic) bool isMoving;
@property (nonatomic, assign) MoveDirection moveDirection;
@property (nonatomic, readonly) GLKVector3 translation;

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
 * @discussion First to respond to touch events occuring and setting start locations for pan gestures
 * @warning No longer used at the moment
 */
- (void)respondToTouchesBegan;
@end