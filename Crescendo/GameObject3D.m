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
        
        // Instantiate children array
        self->children = [NSMutableArray array];
        
        // Store vertex count
        vertexCount = p_vertexCount;
        
        // Generate VAO
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
        
        // Free VAO and Buffers
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
        // Instantiate color parameters
        color = GLKVector4Make(0, 0, 0, 1); // Default color is black;
        m_ColorState = COLOR_STATIC;        // Default state is no operation;
        colorTimePassed = 0;                // Set all timers to nothing
        colorTimeStrobePassed = 0;
        colorTimeLimit = 0;
    }
    return self;
}

- (void)CleanUp
{
    // Clean up all children
    for (GameObject3D* o in children)
    {
        [o CleanUp];
    }
    
    // Clean up self;
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &vao);
}

- (void)update:(float)TimePassed
{
    
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    for (GameObject3D *child in self->children) {
        [child updateWithDelta:dt];
    }
}

-(GLKMatrix4)GetTranslationMatrix
{
    return GLKMatrix4MakeTranslation(worldPosition.x, worldPosition.y, worldPosition.z);
}

-(GLKMatrix4)GetScaleMatrix
{
    return GLKMatrix4MakeScale(scale.x, scale.y, scale.z);
}

-(GLKMatrix4)GetModelViewMatrix
{
    // Get Translation
    GLKMatrix4 result = [self GetTranslationMatrix];
    
    // Apply Rotation
    result = GLKMatrix4Multiply(result, GLKMatrix4MakeRotation(rotation.x, 1, 0, 0));
    result = GLKMatrix4Multiply(result, GLKMatrix4MakeRotation(rotation.y, 0, 1, 0));

    // Apply scale
    result = GLKMatrix4Multiply(result, [self GetScaleMatrix]);
    
    return result;
}

//check if this object has collided with another
-(BOOL)checkCollision:(GameObject3D *)object{
    //calculate distance between the two bounding objects
    
    float distance = sqrtf(
                           (self->worldPosition.x - object->worldPosition.x) * (self->worldPosition.x - object->worldPosition.x) +
                           (self->worldPosition.y - object->worldPosition.y) * (self->worldPosition.y - object->worldPosition.y) +
                           (self->worldPosition.z - object->worldPosition.z) * (self->worldPosition.z - object->worldPosition.z)
                           );
    
    //use radius to check for intersection of spheres
    if(distance <= object->boundingSphereRadius + self->boundingSphereRadius){
        return true;
    }else{
        return false;
    }
}

// The transition towards a destination color in the specified amount of time
- (void)fadeToColor:(GLKVector4)color In:(float)timeToFade
{
    
    
}

- (void)strobeBetweenColor:(GLKVector4)firstColor And:(GLKVector4)secondColor Every:(float)timeBetweenFlashes For:(float)timeToStrobe
{
    
}

@end