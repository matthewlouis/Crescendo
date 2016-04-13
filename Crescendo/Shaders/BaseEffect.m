//
//  BaseEffect.m
//  Crescendo
//
//  Created by Jarred Jardine on 2016-02-12.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "BaseEffect.h"
#import "Vertex.h"
#import "Player.h"
#import "Constants.h"
#import "PlaneObject.h"

@implementation BaseEffect

- (id)init
{
    self = [super init];
    
    if (self)
    {
        m_amplitude = 0;
        m_targetAmplitude = 0;
        [self loadShaders];
    }
    
    return self;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, VertexAttribPosition, "position");
    glBindAttribLocation(_program, VertexAttribColor, "color");
    glBindAttribLocation(_program, VertexAttribTexCoord, "texCoord");
    glBindAttribLocation(_program, VertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_COLOR] = glGetUniformLocation(_program, "color");
    uniforms[UNIFORM_ISPLANE] = glGetUniformLocation(_program, "isPlane");
    uniforms[UNIFORM_ISPLAYER] = glGetUniformLocation(_program, "isPlayer");
    uniforms[UNIFORM_BOB] = glGetUniformLocation(_program, "bob");
    uniforms[UNIFORM_AMPLITUDE] = glGetUniformLocation(_program, "amplitude");
    
    // Fail Case: Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)render:(GameObject3D*)gameObject3D
{    
    GLKMatrix4 cameraViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    
    GLKMatrix4 modelViewMatrix = [gameObject3D GetModelViewMatrix];
    modelViewMatrix = GLKMatrix4Multiply(cameraViewMatrix, modelViewMatrix);
    
    GLKMatrix3 _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    GLKMatrix4 _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    glUniform4fv(uniforms[UNIFORM_COLOR], 1, gameObject3D->_color.v);
    
    glBindVertexArrayOES(gameObject3D->vao);
    
    if ([gameObject3D isKindOfClass:[Player class]])
    {
        glUniform1i(uniforms[UNIFORM_ISPLAYER], true);
        glUniform1f(uniforms[UNIFORM_BOB], ((Player *)gameObject3D).bob);
        gameObject3D->_color = [Theme playerColor];
    }
    else if ([gameObject3D isKindOfClass:[PlaneObject class]])
    {
        PlaneObject *obj = (PlaneObject*) gameObject3D;
        
        switch (obj->type) {
            case Collideable:
                //obj->scale = GLKVector3Make(musicPlayer.pianoLeadTracker.amplitude * 5 + 1, musicPlayer.pianoLeadTracker.amplitude * 2 + 1, musicPlayer.pianoLeadTracker.amplitude * 5 + 1);
                obj->_color = [Theme getObstacles:0];
                break;
            case SoundPickup:
                obj->scale = GLKVector3Make(musicPlayer.pianoLeadTracker.amplitude * PICKUP_EXPAND_SCALE + PICKUP_BASE_SIZE, musicPlayer.pianoLeadTracker.amplitude * PICKUP_EXPAND_SCALE + PICKUP_BASE_SIZE, musicPlayer.pianoLeadTracker.amplitude * PICKUP_EXPAND_SCALE + PICKUP_BASE_SIZE);
                obj->_color = [Theme getPickups:0];
                break;
            default:
                break;
        }
        glUniform1i(uniforms[UNIFORM_ISPLAYER], false);
    }
    
    // Check rendering mode of object
    switch (gameObject3D->renderMode)
    {
        case GL_TRIANGLES:
            glUniform1i(uniforms[UNIFORM_ISPLANE], false);
            glDrawArrays(gameObject3D->renderMode, 0, gameObject3D->vertexCount);
            break;
        case GL_LINES:
            glUniform1i(uniforms[UNIFORM_ISPLANE], true);
            //glUniform1f(uniforms[UNIFORM_AMPLITUDE], m_amplitude);
            
            // Assign Amplitude based on type
            switch (gameObject3D->type)
            {
                case Plane1:
                    glUniform1f(uniforms[UNIFORM_AMPLITUDE], musicPlayer.kickDrumTracker.amplitude * KICKDRUM_AMPLITUDE_SCALE);
                    break;
                case Plane2:
                    glUniform1f(uniforms[UNIFORM_AMPLITUDE], musicPlayer.snareDrumTracker.amplitude * SNAREDRUM_AMPLITUDE_SCALE);
                    break;
            }
            
            glLineWidth(gameObject3D->lineWidth);
            glDrawArrays(gameObject3D->renderMode, 0, gameObject3D->vertexCount);
            break;
        case GL_LINE_LOOP:
            glUniform1i(uniforms[UNIFORM_ISPLANE], true);
                        glUniform1f(uniforms[UNIFORM_AMPLITUDE], m_amplitude);
            glLineWidth(gameObject3D->lineWidth);
            glDrawArrays(gameObject3D->renderMode, 0, gameObject3D->vertexCount);
            break;
        case GL_LINE_STRIP:
            glUniform1i(uniforms[UNIFORM_ISPLANE], true);
            glUniform1f(uniforms[UNIFORM_AMPLITUDE], m_amplitude);
            glLineWidth(gameObject3D->lineWidth);
            glDrawArrays(gameObject3D->renderMode, 0, gameObject3D->vertexCount);
            break;
        case GL_POINTS:
            glUniform1i(uniforms[UNIFORM_ISPLANE], false);
            glDrawArrays(gameObject3D->renderMode, 0, gameObject3D->vertexCount);
            break;
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
    
    for (GameObject3D *child in gameObject3D->children) {
        [self render:child];
    }
}

- (void)update:(float)deltaTime
{
    // Update amplitude
    m_amplitude += (MIN(m_targetAmplitude - m_amplitude, MAX_AMPLITUDE_SHIFT));
}

- (void)setAmplitude:(float)amplitude
{
    //m_targetAmplitude = amplitude * AMPLITUDE_SCALE;
}

- (void)tearDown
{
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

@end