//
//  3DGameObject.m
//  Crescendo
//
//  Created by Sean Wang on 2016-02-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "GameObject3D.h"
#import "BaseEffect.h"
#import <OpenGLES/ES2/glext.h>

@implementation GameObject3D{
    char *_name;
    
    GLuint _vertexBuffer;
    
    BaseEffect *_shader;
}

- (instancetype)initWithName:(char *)name shader:(
BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)p_vertexCount {
    if ((self = [super init])) {
        
        vertexCount = p_vertexCount;
        self->children = [NSMutableArray array];
        
        glGenVertexArraysOES(1, &vao);
        glBindVertexArrayOES(vao);
        
        // Generate vertex buffer
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(Vertex), vertices, GL_STATIC_DRAW);
        
        // Enable vertex attributes
        glEnableVertexAttribArray(VertexAttribPosition);
        glVertexAttribPointer(VertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
        glEnableVertexAttribArray(VertexAttribColor);
        glVertexAttribPointer(VertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
        glEnableVertexAttribArray(VertexAttribTexCoord);
        glVertexAttribPointer(VertexAttribTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
        glEnableVertexAttribArray(VertexAttribNormal);
        glVertexAttribPointer(VertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Normal));
        
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
    }
    return self;
}



- (void)updateWithDelta:(NSTimeInterval)dt {
    for (GameObject3D *child in self->children) {
        [child updateWithDelta:dt];
    }
}

- (void)loadTexture:(NSString *)filename {
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    
    NSDictionary *options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", error.localizedDescription);
    } else {
        self->texture = info.name;
    }
}

-(GLKVector3)GetFoward
{
    GLKVector3 forwardVector = GLKVector3Make(0, 0, 1);
    GLKMatrix4 transformation = GLKMatrix4Multiply([self GetTranslationMatrix], [self GetRotationMatrix]);
    return GLKMatrix4MultiplyVector3(transformation, forwardVector);
}

-(GLKVector3)GetRight
{
    GLKVector3 rightVector = GLKVector3Make(1, 0, 0);
    GLKMatrix4 transformation = GLKMatrix4Multiply([self GetTranslationMatrix], [self GetRotationMatrix]);
    return GLKMatrix4MultiplyVector3(transformation, rightVector);
}

-(GLKVector3)GetUp
{
    GLKVector3 upVector = GLKVector3Make(0, 1, 0);
    GLKMatrix4 transformation = GLKMatrix4Multiply([self GetTranslationMatrix], [self GetRotationMatrix]);
    return GLKMatrix4MultiplyVector3(transformation, upVector);
}

-(GLKMatrix4)GetTranslationMatrix
{
    return GLKMatrix4MakeTranslation(worldPosition.x, worldPosition.y, worldPosition.z);
}

-(GLKMatrix4)GetRotationMatrix
{
    GLKVector3 forwardVec = [self GetFoward];
    GLKVector3 rightVec = [self GetRight];
    GLKVector3 upVec = [self GetUp];
    
    GLKMatrix4 rotationXMat = GLKMatrix4MakeRotation(rotation.x, rightVec.x, rightVec.y, rightVec.z);
    GLKMatrix4 rotationYMat = GLKMatrix4MakeRotation(rotation.y, upVec.x, upVec.y, upVec.z);
    GLKMatrix4 rotationZMat = GLKMatrix4MakeRotation(rotation.y, forwardVec.x, forwardVec.y, forwardVec.z);
    
    return GLKMatrix4Multiply(GLKMatrix4Multiply(rotationXMat, rotationYMat),rotationZMat);
}

-(GLKMatrix4)GetScaleMatrix
{
    return GLKMatrix4MakeScale(scale.x, scale.y, scale.z);
}

-(GLKMatrix4)GetModelViewMatrix
{
    GLKMatrix4 result = [self GetTranslationMatrix];
    
    
    result = GLKMatrix4Multiply(result, GLKMatrix4MakeRotation(rotation.x, 1, 0, 0));
    result = GLKMatrix4Multiply(result, GLKMatrix4MakeRotation(rotation.y, 0, 1, 0));
    
    result = GLKMatrix4Multiply(result, [self GetScaleMatrix]);
    
    return result;
}

@end