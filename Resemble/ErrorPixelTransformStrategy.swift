//
//  ErrorPixelTransformStrategy.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 04.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation

protocol ErrorPixelTransformStrategy
{
    func difference(_ texture1: MTLTexture, _ texture2: MTLTexture, errorPixelColor: Color, context: MetalContext) -> MTLTexture
    
    var kernelFunctionName: String { get }
}

extension ErrorPixelTransformStrategy
{
    func difference(_ texture1: MTLTexture, _ texture2: MTLTexture, errorPixelColor: Color, context: MetalContext) -> MTLTexture
    {
        let kernelFunction = context.library.makeFunction(name: self.kernelFunctionName)
        let pipeline = try! context.device.makeComputePipelineState(function: kernelFunction!)
        
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: texture1.pixelFormat,
                                                                         width: texture1.width,
                                                                         height: texture1.height,
                                                                         mipmapped: false)
        let outputTexture = context.device.makeTexture(descriptor: textureDescriptor)
        
        let threadgroupCounts = MTLSizeMake(8, 8, 1)
        let threadgroups = MTLSizeMake(outputTexture.width / threadgroupCounts.width,
                                       outputTexture.height / threadgroupCounts.height,
                                       1);
        
        let commandBuffer = context.commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()
        
        commandEncoder.setComputePipelineState(pipeline)
        commandEncoder.setTexture(texture1, at: 0)
        commandEncoder.setTexture(texture2, at: 1)
        commandEncoder.setTexture(outputTexture, at: 2)
        
        var color = errorPixelColor
        commandEncoder.setBytes(&color, length: MemoryLayout<Color>.size, at: 0)
        
        
        commandEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadgroupCounts)
        
        commandEncoder.endEncoding()
        
        let blitEncoder = commandBuffer.makeBlitCommandEncoder()
        
        blitEncoder.synchronize(texture: outputTexture, slice: 0, level: 0)
        
        blitEncoder.endEncoding()
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return outputTexture
    }
}

struct FlatErrorPixelTransformStrategy : ErrorPixelTransformStrategy
{
    let kernelFunctionName: String = "flatTransform"
}

struct FlatDifferenceIntensityErrorPixelTransformStrategy : ErrorPixelTransformStrategy
{
    let kernelFunctionName: String = "flatDifferenceIntensityTransform"
}

struct MovementErrorPixelTransformStrategy : ErrorPixelTransformStrategy
{
    let kernelFunctionName: String = "movementTransform"
}

struct MovementDifferenceIntensityErrorPixelTransformStrategy : ErrorPixelTransformStrategy
{
    let kernelFunctionName: String = "movementDifferenceIntensityTransform"
}
