//
//  GameScene.m
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-13.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameScene.h"

#import "Player.h"
#import "PlaneContainer.h"
#import "HandleInputs.h"

#import "Plane.h"



@implementation GameScene{
    CGSize _gameArea;
    Plane* plane;
    PlaneContainer* planeContainer;
    
    float _sceneOffset;
    float _playerSpeed;
    
    Plane *collisionPlane;
    int i;
    NSInteger *previousHighScore;
    NSInteger *highScore;
}

- (instancetype)initWithShader:(BaseEffect *)shader HandleInputs:(HandleInputs *)handleInput {
    i = 0;
    
    if ((self = [super initWithName:"GameScene" shader:shader vertices:nil vertexCount:0])) {
        
        // Create the initial scene position (i.e. camera)
        self->worldPosition = GLKVector3Make(0, 0, 0);
        //self.rotationX = GLKMathDegreesToRadians(-20);
        
        // Create player near bottom center of screen
        _player = [[Player alloc] init];
        [self->children addObject:_player];
        
        // Setup the handleinputs and grid size
        self.handleInput = handleInput;
        [self.handleInput setPlayer:_player];
        
        // Create plane container and its planes
        planeContainer = [[PlaneContainer alloc]init];
        [self->children addObject:planeContainer];
        
        //debug to show where player collides with plane objects
        //Plane *collisionPlane = [[Plane alloc]initWithPosition:0.0 soundObject:nil withThickness:4];
        //[self->children addObject:collisionPlane];

        [planeContainer startMusic];
    }
    return self;
}

- (void) updateWithDeltaTime:(float)timePassed;
{
    [self.handleInput updateMovement];
    
    if ([self.handleInput isMoving])
    {
        _player.timeElapsed += timePassed;
        self.handleInput.isMoving = [_player moveTo:[self.handleInput translation]];
    }
    else
    {
        [_player updateBobMotion:timePassed];
        _player.startPosition = _player->worldPosition;
        _player.startRotation = _player->rotation;
        _player.timeElapsed = 0.0f;
    }
    
    [planeContainer update:timePassed];
    
    if(planeContainer->nextPlane != nil && planeContainer->nextPlane->collidedWith == false){
        [self checkForPlayerCollisions];
    }
}

-(void)checkForPlayerCollisions{
    for (PlaneObject *planeObject in planeContainer->nextPlane->m_PlaneObjects) {
        if ([_player checkCollision:planeObject]){
            
            planeContainer->nextPlane->collidedWith = true; //flag as collided
            
            if(planeObject->type == Collideable){ //game over
                _gameOver = true;
                [PlaneContainer notifyStopGame];
            }
            
            [planeContainer->soundEffectController playSound:planeObject->soundObject]; //play note
            
            if(planeObject->type == SoundPickup){
                ++_score;
            }
            
            [planeContainer->nextPlane->children removeObject:planeObject]; //remove object
            
            //uses one of 3 random colours for change.
            srand(arc4random());
            int ci = rand() % [Theme getBarReactCount];
            GLKVector4 newColor = [Theme getBarReact: ci];
            
            // Fade all bars and planes to random color. Spawn in new color
            [planeContainer fadeAllBarsTo:newColor In:1.0f];
            planeContainer->spawnColor = newColor;
            
            return;
        }
    }
}
- (void)CleanUp
{
    
    for (GameObject3D* o in children)
    {
        [o CleanUp];
    }
}

//Used to get the planeContainer's reference to the music player
-(GameMusicPlayer *)getGlobalMusicPlayer{
    return planeContainer->gameMusicPlayer;
}

//restart game
-(void)restartGame{
    _gameOver = false;
    [planeContainer restartContainer];
    _score = 0;
}

- (GameObject3D*)GetPlanes
{
    GameObject3D* planes = [[GameObject3D alloc]init];
    planes->children = [[NSMutableArray alloc]init];
                        
    for (Bar* bar in planeContainer->m_Bars)
    {
        for (Plane* p in bar->m_Planes)
        {
            p->children = nil;
            [planes->children addObject:p];
        }
    }
    
    return planes;
}

- (GameObject3D*)GetPlaneObjects
{
    GameObject3D* objects = [[GameObject3D alloc]init];
    objects->children = [[NSMutableArray alloc]init];
    
    for (Bar* bar in [planeContainer->m_Bars reverseObjectEnumerator])
    {
        for (Plane* p in [bar->m_Planes reverseObjectEnumerator])
        {
            for (PlaneObject* o in [p->m_PlaneObjects reverseObjectEnumerator])
            {
                [objects->children addObject:o];
            }
        }
    }

    return objects;
}

- (Player*)GetPlayer
{
    return _player;
}


@end
