#version 120

varying vec2 texCoords;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;

/*
const int colortex0Format = RGBA32F;
const int colortex1Format = R8;
*/

uniform float far;
uniform float near;
uniform float rainStrength;

const float FOG_MODIFIER = 0.008f;
const float brightness = 0.25f;
const float contrast = 1.25f;

float linearizeDepth(in float depth)
{
    float factor = 1.0f / ((1.0 - far / near) * depth + (far / near));
    return factor;
}

float expFog2(in float viewDistance, in float density)
{
    float factor = viewDistance * (density / sqrt(log(2.0)));
    factor = (-factor * factor);
    return exp2(factor);
}

void main()
{
    //Read the Albedo of the blocks, and the depth map (R component only)
    vec3 albedo = pow(texture2D(colortex0, texCoords).rgb, vec3(1.0 / 2.2));
    float mask = 1 - texture2D(colortex1, texCoords).r;
    float depth = texture2D(depthtex0, texCoords).r;

    //Linearize the depth from world space to view
    depth = linearizeDepth(depth);
    float viewDistance = depth * far - near;

    //Calculate the Fog factor using the exponential squared fog
    float density = FOG_MODIFIER;
    float fogFactor = 1 - clamp(expFog2(viewDistance, density), 0.0f, 1.0f);
    fogFactor *= mask;

    //Calculating contrast for the close and further away blocks
    vec3 lessContrast = 0.33 * contrast * (albedo - 0.5f) + 0.5f + brightness;
    albedo = contrast * (albedo - 0.5f) + 0.5f + brightness;

    if (depth < 0.9999f)
    {
        albedo = mix(albedo, lessContrast, fogFactor);
    }

    gl_FragColor = vec4(albedo, 1.0f);
}
