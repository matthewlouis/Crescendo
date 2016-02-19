//
//  3DGameObject.h
//  Crescendo
//
//  Created by Sean Wang on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"

@class BaseEffect;
#import <GLKit/GLKit.h>

@interface GameObject3D : NSObject
{
//@public GLfloat vertices[216];
@public GLKVector3 worldPosition;
@public GLKVector3 rotation;
@public GLKVector3 scale;
@public GLuint vao;
@public unsigned int vertexCount;
@public NSMutableArray* children;
@public GLuint texture;
}

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount;

-(GLKVector3)GetUp;
-(GLKVector3)GetRight;
-(GLKVector3)GetFoward;

- (void)renderWithProgram:(GLuint)program WithProjectionMatrix:(GLKMatrix4)projectionMatrix;
- (void)loadTexture:(NSString *)filename;

-(GLKMatrix4)GetModelViewMatrix;
-(GLKMatrix4)GetTranslationMatrix;
-(GLKMatrix4)GetRotationMatrix;
-(GLKMatrix4)GetScaleMatrix;

@end