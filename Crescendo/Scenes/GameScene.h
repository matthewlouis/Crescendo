//
//  GameScene.h
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-13.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameObject3D.h"

@interface GameScene : GameObject3D

- (instancetype)initWithShader:(BaseEffect *)shader;

- (void) updateWithDeltaTime:(float)timePassed;

@end
