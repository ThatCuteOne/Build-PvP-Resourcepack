#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D LastSampler;
uniform sampler2D LastAvgSampler;
uniform sampler2D MainSampler;
uniform sampler2D MainAvgSampler;

layout(location = 0) in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(location = 0) out vec4 fragColor;

void main(){
    int blockSize = 2;
    int searchRange = 1;

    vec2 bestoffset = vec2(0,0);
    vec2 pixcoord = texCoord * InSize;
    float best = 1.0;

    for (int x = -searchRange; x <= searchRange; x++) {
        for (int y = -searchRange; y <= searchRange; y++) {
            vec2 offset = vec2(x*blockSize,y*blockSize);
            vec4 maincolor = texture(MainAvgSampler, (pixcoord + offset)/InSize);
            vec4 lastcolor = texture(LastAvgSampler, (pixcoord + offset)/InSize);
            float diff = (maincolor.x - lastcolor.x) * (maincolor.x - lastcolor.x);
            diff = diff + (maincolor.y - lastcolor.y) * (maincolor.y - lastcolor.y);
            diff = diff + (maincolor.z - lastcolor.z) * (maincolor.z - lastcolor.z);
            if (diff < best) {
                best = diff;
                bestoffset = offset;
            }
        }
    }

    vec4 color = texture(LastSampler, (pixcoord+ bestoffset)/ InSize);
    
    color = mix(texture(MainSampler, pixcoord/ InSize), color, 1 - best);

    fragColor = vec4(color.rgb, 1.0);
}