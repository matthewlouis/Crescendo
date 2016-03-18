//
//  BaseEffect.h
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>
#import "GameObject3D.h"
#import <OpenGLES/ES2/glext.h>
#import "Crescendo-Swift.h"

@interface BaseEffect : NSObject
{
    // Uniform index.
    enum
    {
        UNIFORM_MODELVIEWPROJECTION_MATRIX,
        UNIFORM_NORMAL_MATRIX,
        UNIFORM_COLOR,
        UNIFORM_ISPLANE,
        UNIFORM_AMPLITUDE,
        NUM_UNIFORMS
    };
    
@public GLuint _program;
@public GLKMatrix4 projectionMatrix;
    
@public GameMusicPlayer *musicPlayer;
    
@private float m_amplitude;
@private float m_targetAmplitude;
    
@private GLint uniforms[NUM_UNIFORMS];
}


- (id)init;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

- (void)render:(GameObject3D*)gameObject3D;
- (void)update:(float)deltaTime;

- (void)setAmplitude:(float)amplitude;

- (void)tearDown;

@end
