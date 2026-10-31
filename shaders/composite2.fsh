#version 120

#include "functions.glsl"

varying vec2 texCoords;

uniform sampler2D colortex0;

/*
const int colortex0Format = RGBA32F;
*/

const float saturation = 1.55f;

void main()
{
    vec3 albedo = texture2D(colortex0, texCoords).rgb;
    float greyScaleImage = luminance(albedo);
    vec3 saturated = mix(vec3(greyScaleImage), albedo, saturation);

    gl_FragColor = vec4(saturated, 1.0f);
}
