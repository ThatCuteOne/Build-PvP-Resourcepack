#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(location = 0) out vec4 fragColor;


const float LEVELS = 3.0;

void main(){


    vec4 color = texture(InSampler, texCoord);
    float gray = (color.r + color.g + color.b) / 3.0;
    gray = floor(gray * LEVELS) / (LEVELS - 1.0);

    fragColor = vec4(vec3(gray), 0.0);
}
