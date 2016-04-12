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
#import "glassPanel.h"
#import "sphere.h"

@implementation PlaneObject

- (instancetype)initWithPlane:(Plane*)plane soundObject:(InteractiveSoundObject *)sound objectType:(int)type{
    self->type = type;
    
        if ((self = [super initWithName:"soundCube" shader:nil vertices:(Vertex*)cube_Vertices vertexCount:sizeof(cube_Vertices) / sizeof(cube_Vertices[0])])) {
                
                self->worldPosition = GLKVector3Make(0, 0, plane->worldPosition.z);
                //self->rotation = GLKVector3Make(-1.25, 3.14, 0);
                self->scale = GLKVector3Make(0.75, 0.75, 0.75);
                
                // Specify Drawing Mode
                renderMode = GL_TRIANGLES;
                
                self->soundObject = sound;
                self->_color = [Theme getPickups:0];
            }
    return self;
}

- (instancetype)initGlassCollidableWithPlane:(Plane*)plane soundObject:(InteractiveSoundObject *)sound{
    self->type = Collideable;
    if ((self = [super initWithName:"glassCollideable" shader:nil vertices:(Vertex*)glassPanel_Vertices vertexCount:sizeof(glassPanel_Vertices) / sizeof(glassPanel_Vertices[0])])) {
        
        self->worldPosition = GLKVector3Make(0, 0, plane->worldPosition.z);
        //self->rotation = GLKVector3Make(-1.25, 3.14, 0);
        self->scale = GLKVector3Make(0.75, 0.75, 0.75);
        
        // Specify Drawing Mode
        renderMode = GL_TRIANGLES;
        
        self->soundObject = sound;
        self->_color = [Theme getObstacles:0];
    }
    return self;
}

- (instancetype)initPowerPickupWithPlane:(Plane*)plane soundObject:(InteractiveSoundObject *)sound{
    self->type = PowerPickup;
    if ((self = [super initWithName:"powerPickup" shader:nil vertices:(Vertex*)sphere_Vertices vertexCount:sizeof(sphere_Vertices) / sizeof(sphere_Vertices[0])])) {
        
        self->worldPosition = GLKVector3Make(0, 0, plane->worldPosition.z);
        //self->rotation = GLKVector3Make(-1.25, 3.14, 0);
        self->scale = GLKVector3Make(0.75, 0.75, 0.75);
        
        // Specify Drawing Mode
        renderMode = GL_TRIANGLES;
        
        self->soundObject = sound;
        self->_color = [Theme getPickups:0];
    }
    return self;
}

/*
 * Updates position on each plane object based on plane movement and object behaviour
 */
-(void)updatePositionBasedOnPlane:(Plane *) plane Time:(float)timePassed
{
    worldPosition.z = plane->worldPosition.z;
    [self updateActionBasedOnObjectType:timePassed];
}


-(void)updateActionBasedOnObjectType:(float)timePassed
{
    switch (type) {
        case SoundPickup:
            [self soundPickUpBehaviour:timePassed];
            break;
        case Collideable:
            
            break;
        case PowerPickup:
            
            break;
            
        default:
            break;
    }
}

-(void)soundPickUpBehaviour:(float)timePassed
{
    self->rotation.z += M_PI * timePassed;
}

@end
