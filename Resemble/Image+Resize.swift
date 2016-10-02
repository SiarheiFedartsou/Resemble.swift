//
//  Image+Resize.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
import Accelerate

extension Image {
    func resized(to size: ImageSize) -> Image {
        var buffer = self.buffer
        
        
        let resizedData = UnsafeMutablePointer<Float>.allocate(capacity: size.width * size.height * 4)
        var resizedBuffer = vImage_Buffer(
            data: resizedData,
            height: vImagePixelCount(size.height),
            width: vImagePixelCount(size.width),
            rowBytes: 4 * MemoryLayout<Float>.size * size.width)
        
        vImageScale_ARGBFFFF(&buffer, &resizedBuffer, nil, vImage_Flags(kvImageHighQualityResampling))
        
        return Image(buffer: resizedBuffer)
    }
}
