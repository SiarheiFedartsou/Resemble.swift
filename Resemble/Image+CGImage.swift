//
//  Image+CGImage.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation

extension Image {
    
    init(image: CGImage)
    {
        let width = image.width
        let height = image.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let info = image.bitmapInfo
        let data = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4);
        
        if let context = CGContext(data: data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: 4 * width,
                                   space: colorSpace,
                                   bitmapInfo: info.rawValue) {
            
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            
            context.clear(rect);
            context.draw(image, in: rect)
        }
        
        
        self.data = data
        size = ImageSize(width: width, height: height)
    }
    
    
    func CGImageRepresentation() -> CGImage
    {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapContext = CGContext(
            data: data,
            width: size.width,
            height: size.height,
            bitsPerComponent: 8, // bitsPerComponent
            bytesPerRow: 4 * size.width, // bytesPerRow
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue);
        
        
        let image = bitmapContext?.makeImage();
        return image!
    }
}

