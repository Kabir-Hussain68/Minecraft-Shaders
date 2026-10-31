#version 120

varying vec2 texCoords;
varying vec2 lightmapCoords;
varying vec3 normal;
varying vec4 color;

uniform mat4 gbufferModelViewInverse;

void main() 
{
    // Transform the vertex
    gl_Position = ftransform();
    // Assign values to varying variables (changing to range [0 - 1])
    lightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
    lightmapCoords = (lightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);

    normal = mat3(gbufferModelViewInverse) * normalize(gl_NormalMatrix * gl_Normal);
    texCoords = mat2(gl_TextureMatrix[0]) * gl_MultiTexCoord0.st;
    color = gl_Color;
}