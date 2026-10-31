#version 120

#include "functions.glsl"
#include "lighting.glsl"

varying vec2 texCoords;
varying vec2 lightmapCoords;
varying vec3 normal;
varying vec4 color;

uniform sampler2D gtexture;

void main() 
{
    vec4 albedo = texture2D(gtexture, texCoords) * color;
    //Change to linear space
    albedo = pow(albedo, vec4(2.2f));
    vec3 newNormal = normalize(normal);
    vec3 diffuse = CalculateLighting(albedo.rgb, newNormal, lightmapCoords, gl_FragCoord.xyz);

    /* DRAWBUFFERS:0 */
    // Write the values to the color textures
    gl_FragData[0] = vec4(diffuse, albedo.a);
}