#version 460 compatibility

//DH Pipeline passes lightMap coords differently 
in vec2 dhLightMapCoords;

out vec4 blockColor;
out vec2 lightMapCoords;
out vec3 viewSpacePosition;
out vec3 geoNormal;

void main()
{
    blockColor = gl_Color;
    geoNormal = gl_NormalMatrix * gl_Normal;
    lightMapCoords = dhLightMapCoords;

    viewSpacePosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

    gl_Position = ftransform();
}


