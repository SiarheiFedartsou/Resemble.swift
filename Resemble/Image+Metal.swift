//
//  Image+Metal.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 04.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
import Accelerate

public extension Image {
    func texture(inContext context: MetalContext) -> MTLTexture? {
        let width = self.size.width
        let height = self.size.height
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba32Float,
            width: width,
            height: height,
            mipmapped: false)
        let texture = context.device.makeTexture(descriptor: textureDescriptor)
        
        let region = MTLRegionMake2D(0, 0, width, height)
        texture.replace(region: region, mipmapLevel: 0, withBytes: buffer.data, bytesPerRow: buffer.rowBytes)
        
        return texture
    }
    
    init(fromTexture texture: MTLTexture)
    {
        let width = texture.width
        let height = texture.height
    
        let data = UnsafeMutablePointer<Float>.allocate(capacity: width * height * 4)
        
        let bytesPerRow = width * 4 * MemoryLayout<Float>.size
        
        let region = MTLRegionMake2D(0, 0, width, height)
        
        texture.getBytes(data, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        buffer = vImage_Buffer(data: data,
                               height: vImagePixelCount(height),
                               width: vImagePixelCount(width),
                               rowBytes: bytesPerRow)
    }
}
