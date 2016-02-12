//
//  3DGameObject.h
//  Crescendo
//
//  Created by Sean Wang on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface GameObject3D : NSObject
{
    @public GLfloat vertices[216];
    @public GLKVector3 worldPosition;
}


@end