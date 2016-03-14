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
#import "Crescendo-Swift.h"//
#import "NSMutableArray+Queue.h"
#import <math.h>

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
 */
- (id)init;

/*!
 * @discussion Handles the single tap gesture for placing the player at set coordinates
 * @param recognizer The recognizer passed in by GameViewController
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;

/*!
 * @discussion Handles the swipe left gesture for placing the player at set coordinates
 * @param recognizer The recognizer passed in by GameViewController
 */
- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer;

/*!
 * @discussion Handles the swipe up gesture for placing the player at set coordinates
 * @param recognizer The recognizer passed in by GameViewController
 */
- (void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer;

/*!
 * @discussion Handles the swipe right gesture for placing the player at set coordinates
 * @param recognizer The recognizer passed in by GameViewController
 */
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer;

/*!
 * @discussion Handles the swipe down gesture for placing the player at set coordinates
 * @param recognizer The recognizer passed in by GameViewController
 */
- (void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer;

/*!
 * @discussion Handles the swipes in 8 directions
 */
- (void)handleSwipes:(UIPanGestureRecognizer *)recognizer;

/*!
 * @discussion Updates the player movement if there is any movements in the movement buffer
 */
- (void)updateMovement;

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
 * @discussion Sets a reference to the player and sets the player to start at the bottom quadrant
 * @param player A Player reference to be used for it's vectors data
 */
- (void)setPlayer:(Player *)player;

/*!
 * @discussion Converts screen points into world coordinates with a z value of 0
 * @param w X position of the view
 * @param h Y position of the view
 * @warning No longer used at the moment
 */
- (GLKVector3)Vector3D:(GLKVector2)point2D Width:(int)w Height:(int)h;

/*!
 * @discussion First to respond to touch events occuring and setting start locations for pan gestures
 * @warning No longer used at the moment
 */
- (void)respondToTouchesBegan;
@end