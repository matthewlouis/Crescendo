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
@public GLKVector3 rotation;
@public GLKVector3 scale;
}

-(GLKVector3)GetUp;
-(GLKVector3)GetRight;
-(GLKVector3)GetFoward;

-(GLKMatrix4)GetTranslationMatrix;
-(GLKMatrix4)GetRotationMatrix;
-(GLKMatrix4)GetScaleMatrix;

@end