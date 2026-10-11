#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(location = 0) out vec4 fragColor;


void main(){
    vec2 sizeRatio = OutSize / InSize;


    vec2 center = vec2(0.5, 0.5);
    float Stretch = 0.65;
    vec2 uv = (texCoord - center) * vec2(1.0, Stretch) + center;

    vec4 color = texture(InSampler, uv);
    
    fragColor = vec4(color.rgb, 0.0);
}
