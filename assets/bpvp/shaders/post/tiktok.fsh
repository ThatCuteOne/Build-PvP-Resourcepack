#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

uniform sampler2D InSampler;
uniform sampler2D OverlaySampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
    vec2 OverlaySize;
};

layout(location = 0) out vec4 fragColor;


void main(){
    float targetRatio = 0.5625;
    float targetX = InSize.y*targetRatio;
    float letterboxPercentage = targetX / InSize.x;
    if (abs(texCoord.x - 0.5) > letterboxPercentage/2) {
        fragColor = vec4(0,0,0,1);
    } else {
        fragColor = texture(InSampler, texCoord);
        float time = mod(GameTime * 9600, 1);
        float enable = mod(GameTime * 9600, 50);
        float enable2 = mod(GameTime * 9600, 70);
        vec2 samplePos = vec2((texCoord.x - 0.5 + letterboxPercentage/2)/ letterboxPercentage, 1- texCoord.y);
        if (enable < 1 || enable2 < 1) {
            float offset = mod(texCoord.y - time, 1);
            fragColor = texture(InSampler, vec2(texCoord.x, offset));
            samplePos = vec2(samplePos.x, 1- offset);
        }
        vec4 overlayColor = texture(OverlaySampler, samplePos);
        if (overlayColor.w > 0.1) {
            fragColor = mix(fragColor, overlayColor, overlayColor.w);
        }
        fragColor = mix(fragColor, overlayColor, overlayColor.w);
    }
}
