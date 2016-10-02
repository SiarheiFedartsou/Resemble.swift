//
//  Resemble.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 30.9.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
import CoreGraphics
import Accelerate

struct ImageSize {
    let width: Int
    let height: Int
    
    var square: Int {
        return width * height
    }
}

extension ImageSize : Equatable {}


func ==(lhs: ImageSize, rhs: ImageSize) -> Bool {
    return lhs.width == rhs.width && lhs.height == lhs.height
}

struct Image {
    let buffer: vImage_Buffer
    
    
    init(buffer: vImage_Buffer)
    {
        self.buffer = buffer
    }
    
    init(data: UnsafeMutablePointer<Float>, size: ImageSize)
    {
        self.buffer = vImage_Buffer(data: data, height: vImagePixelCount(size.height), width: vImagePixelCount(size.width), rowBytes: 4 * MemoryLayout<Float>.size * size.width)
    }
    
    var data: UnsafeMutablePointer<Float> {
        return buffer.data.bindMemory(to: Float.self, capacity: buffer.rowBytes * Int(buffer.height))
    }
    var size: ImageSize {
        return ImageSize(width: Int(buffer.width), height: Int(buffer.height))
    }
    
//    deinit {
//        // TODO: deallocate `buffer`
//    }
}


extension Image : Equatable {}

func ==(lhs: Image, rhs: Image) -> Bool {
    guard lhs.size == rhs.size else { return false }
    
    // is not optimal, but currently it is used for test purposes only
    for index in 0 ..< lhs.size.width * rhs.size.height * 4 {
        if lhs.data[index] != rhs.data[index] {
            return false
        }
    }
    return true
}

enum ResizingPolicy {
    case toSmaller
    case toLarger
}


extension Image {
    func compare(to image: Image, errorPixelTransform: ErrorPixelTransform = .flat, resizingPolicy: ResizingPolicy = .toSmaller) -> Image {
        
    
        return generateDiff(between: image, and: self, errorPixelTransform: errorPixelTransform)
    }
    
    private func generateDiff(between image1: Image, and image2: Image, errorPixelTransform: ErrorPixelTransform) -> Image
    {
        let outputData = UnsafeMutablePointer<Float>.allocate(capacity: image1.size.width * image1.size.height * 4)
        
        var samePixelsCount = 0
        for pixelIndex in 0 ..< image1.size.width * image1.size.height {
            let pixel1 = Pixel(pixelData: image1.data.advanced(by: pixelIndex * 4))
            let pixel2 = Pixel(pixelData: image2.data.advanced(by: pixelIndex * 4))
            
            if pixel1 == pixel2 {
                pixel1.write(to: outputData.advanced(by: 4 * pixelIndex))
                samePixelsCount += 1
            } else {
                let errorPixel = errorPixelTransform.transform(errorColor: Pixel(r: 1.0, g: 0, b: 1.0, a: 1.0), pixel1: pixel1, pixel2: pixel2)
                errorPixel.write(to: outputData.advanced(by: 4 * pixelIndex))
            }
        }
        
        //print(Float(samePixelsCount) /  Float(image1.size.width * image1.size.height))
        
        
        return Image(data: outputData, size: image1.size)
    }
}
