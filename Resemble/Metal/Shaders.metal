//
//  Shaders.metal
//  Resemble
//
//  Created by Sergey Fedortsov on 02.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

#include <metal_stdlib>

using namespace metal;

struct AdjustSaturationUniforms
{
    float saturationFactor;
};

float colorDistance(float4 color1, float4 color2)
{
    return (abs(color1.r - color2.r) + abs(color1.g - color2.g) + abs(color1.b - color2.b)) / 3.0;
}

kernel void flatTransform(texture2d<float, access::read> inTexture1 [[texture(0)]],
                                        texture2d<float, access::read> inTexture2 [[texture(1)]],
                                        texture2d<float, access::write> outTexture [[texture(2)]],
                                        constant float4 &errorColor [[buffer(0)]],
                                        uint2 gid [[thread_position_in_grid]])
{
    float4 inColor1 = inTexture1.read(gid);
    float4 inColor2 = inTexture2.read(gid);
    
    if (all(inColor1 == inColor2)) {
        outTexture.write(inColor1, gid);
    } else {
        outTexture.write(errorColor, gid);
    }
}

kernel void movementTransform(texture2d<float, access::read> inTexture1 [[texture(0)]],
                          texture2d<float, access::read> inTexture2 [[texture(1)]],
                          texture2d<float, access::write> outTexture [[texture(2)]],
                          constant float4 &errorColor [[buffer(0)]],
                          uint2 gid [[thread_position_in_grid]])
{
    float4 inColor1 = inTexture1.read(gid);
    float4 inColor2 = inTexture2.read(gid);
    
    if (all(inColor1 == inColor2)) {
        outTexture.write(inColor1, gid);
    } else {
        outTexture.write((inColor2 * errorColor + errorColor) / 2.0, gid);
    }
}

kernel void flatDifferenceIntensityTransform(texture2d<float, access::read> inTexture1 [[texture(0)]],
                          texture2d<float, access::read> inTexture2 [[texture(1)]],
                          texture2d<float, access::write> outTexture [[texture(2)]],
                          constant float4 &errorColor [[buffer(0)]],
                          uint2 gid [[thread_position_in_grid]])
{
    float4 inColor1 = inTexture1.read(gid);
    float4 inColor2 = inTexture2.read(gid);
    
    if (all(inColor1 == inColor2)) {
        outTexture.write(inColor1, gid);
    } else {
        outTexture.write(float4(inColor1.rgb, colorDistance(inColor2, inColor1)), gid);
    }
}

kernel void movementDifferenceIntensityTransform(texture2d<float, access::read> inTexture1 [[texture(0)]],
                           texture2d<float, access::read> inTexture2 [[texture(1)]],
                           texture2d<float, access::write> outTexture [[texture(2)]],
                           constant float4 &errorColor [[buffer(0)]],
                           uint2 gid [[thread_position_in_grid]])
{
    float4 inColor1 = inTexture1.read(gid);
    float4 inColor2 = inTexture2.read(gid);
    
    if (all(inColor1 == inColor2)) {
        outTexture.write(inColor1, gid);
    } else {
        float ratio = colorDistance(inColor1, inColor2) * 0.8;
        
        float r = (1.0 - ratio) * inColor2.r * errorColor.r + ratio * errorColor.r;
        float g = (1.0 - ratio) * inColor2.g * errorColor.g + ratio * errorColor.g;
        float b = (1.0 - ratio) * inColor2.b * errorColor.b + ratio * errorColor.b;
        
        
        outTexture.write(float4(r, g, b, inColor2.a), gid);
    }
    
}
