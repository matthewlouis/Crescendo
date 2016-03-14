//
//  PlaneObject.m
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

#import "PlaneObject.h"
#import "cube.h"
#import "Crescendo-Swift.h"
#import "Constants.h"
#import "Plane.h"

@implementation PlaneObject

- (instancetype)initWithPlane:(Plane*)plane soundObject:(InteractiveSoundObject *)sound objectType:(int)type{
    self->type = type;
    switch (type) {
        case SoundPickup:
            if ((self = [super initWithName:"soundCube" shader:nil vertices:(Vertex*)cube_Vertices vertexCount:sizeof(cube_Vertices) / sizeof(cube_Vertices[0])])) {
                
                self->worldPosition = GLKVector3Make(0, 0, plane->worldPosition.z);
                //self->rotation = GLKVector3Make(-1.25, 3.14, 0);
                self->scale = GLKVector3Make(0.75, 0.75, 0.75);
                
                // Specify Drawing Mode
                renderMode = GL_TRIANGLES;
                
                self->soundObject = sound;
                self->color = GLKVector4Make(0.3f, 0.3f, 0.7f, 1);
            }
            break;
            
        default:
            if ((self = [super initWithName:"cube" shader:nil vertices:(Vertex*)cube_Vertices vertexCount:sizeof(cube_Vertices) / sizeof(cube_Vertices[0])])) {
                
                self->worldPosition = GLKVector3Make(0, 0, plane->worldPosition.z);
                //self->rotation = GLKVector3Make(-1.25, 3.14, 0);
                self->scale = GLKVector3Make(0.75, 0.75, 0.75);
                
                // Specify Drawing Mode
                renderMode = GL_TRIANGLES;
                
                self->soundObject = sound;
                self->color = GLKVector4Make(0.3f, 0.3f, 0.7f, 1);
            }
            break;
    }
   

    return self;
}

- (instancetype)initGlassCollidableWithPlane:(Plane*)plane{
    self->type = Collideable;
    if ((self = [super initWithName:"glassCollideable" shader:nil vertices:(Vertex*)cube_Vertices vertexCount:sizeof(cube_Vertices) / sizeof(cube_Vertices[0])])) {
        
        self->worldPosition = GLKVector3Make(0, 0, plane->worldPosition.z);
        //self->rotation = GLKVector3Make(-1.25, 3.14, 0);
        self->scale = GLKVector3Make(0.75, 0.75, 0.75);
        
        // Specify Drawing Mode
        renderMode = GL_TRIANGLES;
        
        self->color = GLKVector4Make(0.3f, 0.3f, 0.7f, 1);
    }
    
    return self;
}

/*
 * Updates position on each plane object based on plane movement and object behaviour
 */
-(void)updatePositionBasedOnPlane:(Plane *) plane
{
    worldPosition.z = plane->worldPosition.z;
    //[self updateActionBasedOnObjectType];
}


-(void)updateActionBasedOnObjectType
{
    switch (type) {
        case SoundPickup:
            
            break;
        case Collideable:
            
            break;
        case PowerPickup:
            
            break;
            
        default:
            break;
    }
}

@end
