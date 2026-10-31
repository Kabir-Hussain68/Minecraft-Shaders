#version 460 compatibility

#include "functions.glsl"
#include "lighting.glsl"

uniform sampler2D lightmap;   
uniform sampler2D depthtex0;            //Depth Texture


uniform vec3 fogColor;

/* DRAWBUFFERS:012 */
layout(location = 0) out vec4 outColor0;
layout(location = 2) out vec4 outColor2;


in vec4 blockColor;
in vec2 lightMapCoords;
in vec3 viewSpacePosition;
in vec3 geoNormal;

void main()
{
    vec3 worldGeoNormal = normalize(mat3(gbufferModelViewInverse) * geoNormal);
     
    //LightMap
    vec4 lightMapColor = texture(lightmap, lightMapCoords);

    //Block Color sampling and Data
    vec4 blockData = blockColor;
    vec3 outputBlockColor = blockData.rgb;
    outputBlockColor *= lightMapColor.rgb;

    //Transparency for glass and grass
    float transparancy = blockData.a;
    if (transparancy < 0.1)
    {
        discard;
    }

    //Checking depth for blocks, if it not at max limit (sky) discard the DH block because a normal block is there
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;
    if (depth != 1.0)
    {
        discard;
    }

    //Distance of Fog From the camera
    float distanceFromCamera = distance(vec3(0), viewSpacePosition);
    float maxFogDistance = 4000;
    float minFogDistance = 2500;
    float fogBlendValue = clamp((distanceFromCamera - minFogDistance) / (maxFogDistance - minFogDistance), 0, 1);

    //Interpolating Fog 
    outputBlockColor = mix(outputBlockColor, fogColor, fogBlendValue);

    //vec3 diffuse = CalculateLighting(outputBlockColor.rgb, worldGeoNormal, lightMapCoords, gl_FragCoord.xyz);

    //Passing Normals to the screen shader pass
    outColor0 = vec4(pow(outputBlockColor, vec3(2.2f)), transparancy);
    outColor2 = vec4(worldGeoNormal * 0.5 + 0.5, 1.0);
}