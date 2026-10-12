#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

uniform sampler2D InSampler;
uniform sampler2D StoreSampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(location = 0) out vec4 fragColor;


void main(){
    float angle = mod(GameTime * 24000 * 0.1, 3.14159*2) - 3.14159;
    vec2 center = InSize/2;
    vec2 toTexel = (texCoord * InSize) - center;
    float texelAngle = atan(toTexel.y, toTexel.x);
    float angleDiff = min(3.14159*2 - abs(texelAngle - angle), abs(texelAngle - angle));
    
    vec4 trueColor = texture(InSampler, texCoord);
    vec4 storeColor = texture(StoreSampler, texCoord);
    fragColor = mix(trueColor, storeColor, angleDiff/ 3.14159*2);

}
