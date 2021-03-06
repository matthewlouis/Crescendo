//
//  GameScene.h
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-13.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameObject3D.h"
#import "HandleInputs.h"

@interface GameScene : GameObject3D

@property (strong, nonatomic) HandleInputs *handleInput;
@property (weak) PlaneContainer* planeContainer;
@property (nonatomic) bool gameOver;
@property (nonatomic) bool restart;
@property (nonatomic) NSInteger score;
@property (nonatomic) Theme *theme;
@property (nonatomic) Player *player;

- (instancetype)initWithShader:(BaseEffect *)shader HandleInputs:(HandleInputs *)handleInput;

- (void) updateWithDeltaTime:(float)timePassed;

-(GameMusicPlayer *)getGlobalMusicPlayer;
-(void)restartGame;

- (GameObject3D*)GetPlanes;
- (GameObject3D*)GetPlaneObjects;
- (Player*)GetPlayer;

@end
