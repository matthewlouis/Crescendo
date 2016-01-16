//
//  PlaneObject.h
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface PlaneObject : NSObject

@property GLKVector3 *relativePosition;
@property (strong, nonatomic) GLKMesh *mesh;

//Matt: texture property but unsure of types

-(void)move:(GLKVector3)amount;
-(GLKVector3)getWorldPosition;

@end
