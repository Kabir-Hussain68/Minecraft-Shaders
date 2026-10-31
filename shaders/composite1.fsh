#version 120

#include "functions.glsl"

varying vec2 texCoords;

uniform sampler2D colortex0;

uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
vec2 texelSize = vec2(1.0 / viewWidth, 1.0 / viewHeight);

/*
const int colortex0Format = RGBA32F;
*/

const float TWOPIE = 6.28318;
const float SIGMA = 5.0;

float singleDimensionGaussianBlur(in float x)
{
    float sigmaSquared = SIGMA * SIGMA;
    float denominator = 1 / sqrt(TWOPIE * sigmaSquared);
    float power = exp(-(x * x) / (2 * sigmaSquared));
    return denominator * power;
}

void main()
{
    int kernelMax = 4;
    int kernelMin = -kernelMax;

    float gaussianSum = 0.0f;
    vec3 resultImage; 

    for (int x = kernelMin; x <= kernelMax; x++)
    {
        float gaussianWeight = singleDimensionGaussianBlur(x);
        gaussianSum += gaussianWeight;
        resultImage += gaussianWeight * texture2D(colortex0, texCoords + vec2(texelSize.x * x, 0.0)).rgb;
    }

    for (int y = kernelMin; y <= kernelMax; y++)
    {
        float gaussianWeight = singleDimensionGaussianBlur(y);
        gaussianSum += gaussianWeight;
        resultImage += gaussianWeight * texture2D(colortex0, texCoords + vec2(0.0, texelSize.y * y)).rgb;
    }    

    resultImage /= gaussianSum;

    vec3 albedo = texture2D(colortex0, texCoords).rgb;
    albedo += resultImage.rgb * mix(0.6, 1.5, luminance(resultImage)) * (1 - rainStrength);
    
    gl_FragColor = vec4(albedo, 1.0f);
}
