//
//  Easing.h
//  Crescendo
//
//  Created by Steven Chen on 2016-03-11.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <math.h>

#ifndef Easing_h
#define Easing_h

#define BoundsCheck(t, start, end) \
if (t <= 0.f) return start;        \
else if (t >= 1.f) return end;

GLfloat LinearInterpolation(GLclampf t, GLfloat start, GLfloat end);
#pragma mark -
#pragma mark Quadratic
GLfloat QuadraticEaseOut(GLclampf t, GLfloat start, GLfloat end);
GLfloat QuadraticEaseIn(GLclampf t, GLfloat start, GLfloat end);
GLfloat QuadraticEaseInOut(GLclampf t, GLfloat start, GLfloat end);
#pragma mark -
#pragma mark Cubic
GLfloat CubicEaseOut(GLclampf t, GLfloat start, GLfloat end);
GLfloat CubicEaseIn(GLclampf t, GLfloat start, GLfloat end);
GLfloat CubicEaseInOut(GLclampf t, GLfloat start, GLfloat end);
#pragma mark -
#pragma mark Quintic
GLfloat QuarticEaseOut(GLclampf t, GLfloat start, GLfloat end);
GLfloat QuarticEaseIn(GLclampf t, GLfloat start, GLfloat end);
GLfloat QuarticEaseInOut(GLclampf t, GLfloat start, GLfloat end);
#pragma mark -
#pragma mark Quintic
GLfloat QuinticEaseOut(GLclampf t, GLfloat start, GLfloat end);
GLfloat QuinticEaseIn(GLclampf t, GLfloat start, GLfloat end);
GLfloat QuinticEaseInOut(GLclampf t, GLfloat start, GLfloat end);
#pragma mark -
#pragma mark Sinusoidal
GLfloat SinusoidalEaseOut(GLclampf t, GLfloat start, GLfloat end);
GLfloat SinusoidalEaseIn(GLclampf t, GLfloat start, GLfloat end);
GLfloat SinusoidalEaseInOut(GLclampf t, GLfloat start, GLfloat end);
#pragma mark -
#pragma mark Exponential
GLfloat ExponentialEaseOut(GLclampf t, GLfloat start, GLfloat end);
GLfloat ExponentialEaseIn(GLclampf t, GLfloat start, GLfloat end);
GLfloat ExponentialEaseInOut(GLclampf t, GLfloat start, GLfloat end);
#pragma mark -
#pragma mark Circular
GLfloat CircularEaseOut(GLclampf t, GLfloat start, GLfloat end);
GLfloat CircularEaseIn(GLclampf t, GLfloat start, GLfloat end);
GLfloat CircularEaseInOut(GLclampf t, GLfloat start, GLfloat end);

#endif /* Easing_h */

