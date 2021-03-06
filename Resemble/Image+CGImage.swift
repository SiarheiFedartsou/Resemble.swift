//
//  Image+CGImage.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
import Accelerate

private func defaultImageFormat() -> vImage_CGImageFormat
{
    let bitmapInfo = CGBitmapInfo(rawValue:
        CGImageAlphaInfo.last.rawValue)
    
    return vImage_CGImageFormat(bitsPerComponent: UInt32(MemoryLayout<UInt8>.size * 8),
                                bitsPerPixel: UInt32(MemoryLayout<UInt8>.size * 4 * 8),
                                colorSpace: nil,
                                bitmapInfo: bitmapInfo,
                                version: 0,
                                decode: nil,
                                renderingIntent: .defaultIntent)
}

public extension Image {
    
    init(image: CGImage)
    {
        
        var imageFormat = defaultImageFormat()
        var buffer = vImage_Buffer()
        let error = vImageBuffer_InitWithCGImage(&buffer, &imageFormat, nil, image, vImage_Flags(kvImageNoFlags))
        print(error)
        self.buffer = buffer

    }
    
    
    func CGImageRepresentation() -> CGImage
    {
        var imageFormat = defaultImageFormat()
        
        var error: vImage_Error = kvImageNoError
        
        var buffer = self.buffer
        let image = vImageCreateCGImageFromBuffer(&buffer, &imageFormat, nil, nil, vImage_Flags(kvImageNoFlags), &error)
        print(error)
        return image!.takeUnretainedValue()
    }
}

