#version 120

varying vec2 texCoords;

uniform sampler2D colortex0;

//Courtesy of three.js repository on Github about shaderchunks/tonemapping
const mat3 ACESInputMat = mat3(
    vec3(0.59719f, 0.35458f, 0.04823f),
    vec3(0.07600f, 0.90834f, 0.01566f),
    vec3(0.02840f, 0.13383f, 0.83777f)
);

const mat3 ACESOutputMat = mat3(
    vec3( 1.60475f, -0.53108f, -0.07367f),
    vec3(-0.10208f,  1.10813f, -0.00605f),
    vec3(-0.00327f, -0.07276f,  1.07602f)
);

vec3 multiplyMatrix(in mat3 m, in vec3 v)
{
    float a = m[0][0] * v.x + m[0][1] * v.y + m[0][2] * v.z;
    float b = m[1][0] * v.x + m[1][1] * v.y + m[1][2] * v.z;
    float c = m[2][0] * v.x + m[2][1] * v.y + m[2][2] * v.z;
    return vec3(a, b, c);
}

vec3 RRTAndODTFit(in vec3 v)
{
    vec3 a = v * ( v + 0.0245786 ) - 0.000090537;
	vec3 b = v * ( 0.983729 * v + 0.4329510 ) + 0.238081;
	return a / b;
}

vec3 convertToACES(in vec3 color)
{
    vec3 ACES_Color = multiplyMatrix(ACESInputMat, color);
    ACES_Color = RRTAndODTFit(ACES_Color);
    vec3 display_Color = multiplyMatrix(ACESOutputMat, ACES_Color);
    return display_Color;
}

void main()
{
    vec3 albedo = texture2D(colortex0, texCoords).rgb;
    albedo = pow(albedo, vec3(1.5f));
    albedo.b = max(albedo.b, 0.0f);

    albedo = convertToACES(albedo);
    gl_FragColor = vec4(albedo, 1.0f);
}
