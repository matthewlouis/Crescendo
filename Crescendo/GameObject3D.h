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
@public GLenum renderMode;  // Determines how object is rendered.  Current uses are GL_TRIANGLES (regular 3D models) and GL_LINES (for planes)
@public GLfloat lineWidth;  // Only used for GL_LINES rendering mode.
    
//bounding sphere collision detection
@public float boundingSphereRadius;
@public bool isCollidable;
}

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount;
- (void)CleanUp;

-(GLKVector3)GetUp;
-(GLKVector3)GetRight;
-(GLKVector3)GetFoward;

- (void)loadTexture:(NSString *)filename;

-(GLKMatrix4)GetModelViewMatrix;
-(GLKMatrix4)GetTranslationMatrix;
-(GLKMatrix4)GetRotationMatrix;
-(GLKMatrix4)GetScaleMatrix;

-(BOOL)checkCollision:(GameObject3D *)object;

@end