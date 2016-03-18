//
//  Shader.vsh
//  Crescendo
//
//  Created by Matthew Moldowan on 2016-01-15.
//  Copyright © 2016 Equalizer. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec4 color;
uniform bool isPlane;

void main()
{
    vec4 transformedPosition = modelViewProjectionMatrix * position;
    
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 1.0, 1.0);
    //vec4 diffuseColor = vec4(1.0, 0.1, 0.2, 1);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    // Fog
    float opaqueness = 1.0;
    float fogLength = 10.0;
    float fogStartZ = 60.0;
    float distance = transformedPosition.z - fogStartZ;
    if (distance > 0.0)
    {
        opaqueness = (fogLength - distance) / fogLength;
        opaqueness = clamp(opaqueness, 0.0, 1.0);
    }
    
    if (isPlane)
    {
        colorVarying = color;
        transformedPosition += 0.2 * vec4(normal.x, normal.y, normal.z, 0);
    }
    else
    {
        colorVarying = color * nDotVP;
    }

    colorVarying.w = opaqueness;
    
    gl_Position = transformedPosition; //modelViewProjectionMatrix *  position;
}
