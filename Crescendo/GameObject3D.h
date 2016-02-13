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
@public GLfloat vertices[216];
@public GLKVector3 worldPosition;
@public GLKVector3 rotation;
@public GLKVector3 scale;
}

@property (nonatomic, strong) BaseEffect *shader;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;
@property (nonatomic) GLuint texture;
@property (assign) GLKVector4 matColor;
@property (assign) float width;
@property (assign) float height;
-(GLKVector3)GetUp;
-(GLKVector3)GetRight;
-(GLKVector3)GetFoward;

@property (nonatomic, strong) NSMutableArray *children;

- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount;
- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;
- (void)updateWithDelta:(NSTimeInterval)dt;
- (void)loadTexture:(NSString *)filename;

-(GLKMatrix4)GetTranslationMatrix;
-(GLKMatrix4)GetRotationMatrix;
-(GLKMatrix4)GetScaleMatrix;

@end