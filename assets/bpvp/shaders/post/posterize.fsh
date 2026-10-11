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

    

    vec4 diffuseColor = texture(InSampler, texCoord);
    vec4 scaled = diffuseColor * 10;
    vec4 outColor = vec4(floor(scaled.x),floor(scaled.y),floor(scaled.z),10.0)/10;

    fragColor = vec4(outColor.rgb, 1.0);
}
