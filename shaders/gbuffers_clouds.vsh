#version 120

varying vec2 texCoords;
varying vec4 color;


void main() 
{
    // Transform the vertex
    gl_Position = ftransform();
    texCoords = mat2(gl_TextureMatrix[0]) * gl_MultiTexCoord0.st;
    color = gl_Color;
}