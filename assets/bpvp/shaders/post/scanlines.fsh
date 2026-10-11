#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:globals.glsl>

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(location = 0) out vec4 fragColor;

void main(){

    float thickness = 10;
    float offset = 2;
    vec2 samplepos = texCoord;
    if (mod((texCoord.y * InSize.y) + GameTime * 24000 * 5, thickness) < thickness/3 ) {
        samplepos = vec2(texCoord.x + offset/InSize.x, texCoord.y);
    }

    vec4 color = texture(InSampler, samplepos);
    fragColor = vec4(color.rgb, 1.0);
    if (mod((texCoord.y * InSize.y) + GameTime * 24000 * 5, thickness) < thickness/3 ) {
        fragColor = vec4(color.rgb * 0.95, 1.0);
    }

}