#ifdef VERTEX_SHADER
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;

void main()
{
    TexCoords = aTexCoords;
    gl_Position = vec4(aPos,1.0);
}
#endif

#ifdef FRAGMENT_SHADER
layout (location = 0) out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D gPosition;
uniform sampler2D gNormal;
uniform sampler2D texNoise;

uniform vec3 samples[64];
uniform float power = 2.0F;

// parameters (you'd probably want to use them as uniforms to more easily tweak the effect)
int kernelSize = 64;
float radius = 0.5;
float bias = 0.025;
uniform int rangeCheckActive = 1;

// tile noise texture over screen based on screen dimensions divided by noise size
const vec2 noiseScale = vec2(1600.0/4.0, 900.0/4.0); 

uniform mat4 projection;
uniform mat4 view;
void main()
{
    // get input for SSAO algorithm
    vec3 fragPos = vec3(view * vec4(texture(gPosition, TexCoords).xyz,1.0));
    vec3 normal = normalize(texture(gNormal, TexCoords).rgb);
    vec3 randomVec = normalize(texture(texNoise, TexCoords * noiseScale).xyz);
    // create TBN change-of-basis matrix: from tangent-space to view-space
    vec3 tangent = normalize(randomVec - normal * dot(randomVec, normal));
    vec3 bitangent = cross(normal, tangent);
    mat3 TBN = mat3(tangent, bitangent, normal);
    // iterate over the sample kernel and calculate occlusion factor
    float occlusion = 0.0;
    for(int i = 0; i < kernelSize; ++i)
    {
        // get sample position
        vec3 samplePos = TBN * samples[i]; // from tangent to view-space
        samplePos = fragPos + samplePos * radius; 
        
        // project sample position (to sample texture) (to get position on screen/texture)
        vec4 offset = vec4(samplePos, 1.0);
        offset = projection * offset; // from view to clip-space
        offset.xyz /= offset.w; // perspective divide
        offset.xyz = offset.xyz * 0.5 + 0.5; // transform to range 0.0 - 1.0
        
        // get sample depth
        float sampleDepth = (view * vec4(texture(gPosition, offset.xy).xyz, 1.0)).z; // get depth value of kernel sample
        
        float rangeCheck = 1.0;
        // range check & accumulate
        if(rangeCheckActive == 1)
            rangeCheck = smoothstep(0.0, 1.0, radius / abs(fragPos.z - sampleDepth));
            
        occlusion += (sampleDepth >= samplePos.z + bias ? 1.0 : 0.0) * rangeCheck;           
    }
    occlusion = 1.0 - (occlusion / kernelSize);
    
    FragColor.xyz = vec3(pow(occlusion, power));
    FragColor.w = 1.0;
    //FragColor = texture(texNoise, TexCoords);
    //FragColor =  vec4(1.0);
}

#endif