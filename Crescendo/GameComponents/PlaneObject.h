//
//  PlaneObject.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject3D.h"
@import GLKit;

@interface PlaneObject : GameObject3D

@property GLKVector3 *relativePosition;
@property (strong, nonatomic) GLKMesh *mesh;

//Matt: texture property but unsure of types

-(void)move:(GLKVector3)amount;

@end
