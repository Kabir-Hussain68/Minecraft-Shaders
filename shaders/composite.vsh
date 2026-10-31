#version 120

varying vec2 texCoords;

void main()
{
    gl_Position = ftransform();
    texCoords = mat2(gl_TextureMatrix[0]) * gl_MultiTexCoord0.st;
}