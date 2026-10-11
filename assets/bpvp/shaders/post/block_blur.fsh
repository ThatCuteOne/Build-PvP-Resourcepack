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
    int blockSize = 32;

    vec2 pixcoord = texCoord * InSize;
    vec2 blockStart = vec2(floor(pixcoord.x/blockSize), floor(pixcoord.y/blockSize)) * blockSize;
    
    vec4 color = texture(InSampler, texCoord);
    fragColor = vec4(color.rgb, 1.0);
    
    vec2 blockpos = pixcoord - blockStart;
    vec4 accum = vec4(0,0,0,0);
    int count = 0;
    int blursize = 12;
    for (float x = max(blockpos.x -blursize, 0); x < min(blockpos.x+blursize, blockSize-1); x++) {
        for (float y = max(blockpos.y -blursize, 0); y < min(blockpos.y+blursize, blockSize-1); y++) {
            count = count + 1;
            accum = accum + texture(InSampler, (blockStart + vec2(x,y)) / InSize);
    }
    }
    if (count > 0) {
        fragColor = accum / count;
    }

}
