#version 120

#include "functions.glsl"

varying vec2 texCoords;
varying vec4 color;

uniform sampler2D gtexture;
uniform float rainStrength;

void main() 
{
    vec4 albedo = texture2D(gtexture, texCoords) * color;
    //Change to linear space
    //If pixel is not too bright
    if (luminance(albedo.rgb) <= 0.9)
    {
        albedo.rgb = pow(albedo.rgb, vec3(2.2)); 
    }
    //As the rain decreases makes the surface more visible 
    albedo.a *= 1 - rainStrength;

    /* DRAWBUFFERS:01 */
    gl_FragData[0] = albedo;
    //Stores values in greyscale for bloom masking, SSAO etc
    gl_FragData[1] = vec4(1 - luminance(albedo.rgb));
}