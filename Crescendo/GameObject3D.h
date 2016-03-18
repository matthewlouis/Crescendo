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

// Determines the current state of the color rendering.
typedef enum color_states
{
    COLOR_STATIC,   // Color is not changing.
    COLOR_FADING,   // Color is fading to another.
    COLOR_STROBE,   // Color is flashing between two colors
} ColorStates;

@interface GameObject3D : NSObject
{
// Type
@protected int type;
    
// Transformations
@public GLKVector3 worldPosition;
@public GLKVector3 rotation;
@public GLKVector3 scale;

// Rendering Data
@public GLuint vao;
@public unsigned int vertexCount;
@public NSMutableArray* children;
@public GLenum renderMode;  // Determines how object is rendered.  Current uses are GL_TRIANGLES (regular 3D models) and GL_LINES (for planes)
@public GLfloat lineWidth;  // Only used for GL_LINES rendering mode.
    
//bounding sphere collision detection
@public float boundingSphereRadius;
@public bool isCollidable;
    
// Color variables
@public GLKVector4 _color;               // Current Color
@public GLKVector4 previousColor;       // The color that was before operations
@private GLKVector4 targetColor;        // The color to become in operations
@private GLKVector4 strobeColor1;
@private GLKVector4 strobeColor2;
@private ColorStates m_ColorState;      // Current color operation being performed
@private float colorTimePassed;         // Overall time that has passed since the start of a color operation
@private float colorTimeStrobePassed;   // Time passed since the last flash in a strobe operation
@private float colorTimeStrobeLimit;
@private float colorTimeLimit;          // Total time to run the color operation
}

// Construction and Destruction
- (instancetype)initWithName:(char *)name shader:(BaseEffect *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount;
- (void)CleanUp;

// GameObject's update loop
- (void)update:(float)TimePassed;

// Transformation Methods
-(GLKMatrix4)GetModelViewMatrix;
-(GLKMatrix4)GetTranslationMatrix;
-(GLKMatrix4)GetScaleMatrix;

-(BOOL)checkCollision:(GameObject3D *)object;

// Color Changing Methods
- (void)fadeToColor:(GLKVector4)color In:(float)timeToFade;
- (void)strobeBetweenColor:(GLKVector4)firstColor And:(GLKVector4)secondColor Every:(float)timeBetweenFlashes For:(float)timeToStrobe;
- (void)updateColor:(float)timePassed;
- (void)resetColorState;

@end