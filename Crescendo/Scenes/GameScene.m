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

@implementation GameScene{
    CGSize _gameArea;
    Player *_player;
    
    float _sceneOffset;
}

- (instancetype)initWithShader:(BaseEffect *)shader {
    
    if ((self = [super initWithName:"GameScene" shader:shader vertices:nil vertexCount:0])) {
        
        // Create the initial scene position (i.e. camera)
        _gameArea = CGSizeMake(48, 27);
        _sceneOffset = _gameArea.height/2 / tanf(GLKMathDegreesToRadians(85.0/2));
        self.position = GLKVector3Make(-_gameArea.width/2, -_gameArea.height/2 + 10, -_sceneOffset);
        //self.rotationX = GLKMathDegreesToRadians(-20);
        
        // Create player near bottom center of screen
        _player = [[Player alloc] initWithShader:shader];
        _player.position = GLKVector3Make(_gameArea.width/2, _gameArea.height * 0.05, 0);
        [self.children addObject:_player];
        
        // Create plane container and its planes
    
        
        
        
    }
    return self;
}



@end
