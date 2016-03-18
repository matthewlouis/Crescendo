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
    Player *_player;
    Plane* plane;
    PlaneContainer* planeContainer;
    
    float _sceneOffset;
    float _playerSpeed;
    
    Plane *collisionPlane;
    int i;
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
        _player.startPosition = _player->worldPosition;
        _player.startRotation = _player->rotation;
        _player.timeElapsed = 0.0f;
    }
    
    [planeContainer update:timePassed];
    
    [self checkForPlayerCollisions];
}

-(void)checkForPlayerCollisions{
    for (PlaneObject *planeObject in planeContainer->nextPlane->m_PlaneObjects) {
        if ([_player checkCollision:planeObject]){
            [planeContainer->soundEffectController playSound:planeObject->soundObject]; //play note
            [planeContainer->nextPlane->children removeObject:planeObject]; //remove object
            
            // Fade on collide
            /* Random color */
            //srand48(arc4random());  // Set seed for random
            //float r = drand48();
            //srand48(arc4random());
            //float g = drand48();
            //srand48(arc4random());
            //float b = drand48();
            
            //GLKVector4 newColor = GLKVector4Make(r, g, b, 1);
            
            // Fade all bars and planes to random color. Spawn in new color
            //[planeContainer fadeAllBarsTo:newColor In:1.0f];
            //planeContainer->spawnColor = newColor;
            
            GLKVector4 red = GLKVector4Make(1, 0, 0, 1);
            GLKVector4 black = GLKVector4Make(0, 0, 0, 1);
            
            [planeContainer strobeAllBarsBetweenColors:red And:black Every:0.25f For:5.0];
        }
    }
    
    /*Bar *bar = planeContainer->m_Bars[0];
    for (Plane *cPlane in bar->m_Planes) {
        for (PlaneObject *planeObject in cPlane->m_PlaneObjects) {
            if ([_player checkCollision:planeObject]){
                [planeContainer->soundEffectController playSound:planeObject->soundObject]; //play note
                [cPlane->children removeObject:planeObject]; //remove object
            }
        }
    }*/
}
- (void)CleanUp
{
    [self CleanUp];
    
    for (GameObject3D* o in children)
    {
        [o CleanUp];
    }
}

@end
