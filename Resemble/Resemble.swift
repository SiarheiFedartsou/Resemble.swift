//
//  Resemble.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 30.9.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
import CoreGraphics

struct ImageSize {
    let width: Int
    let height: Int
}

extension ImageSize : Equatable {}


func ==(lhs: ImageSize, rhs: ImageSize) -> Bool {
    return lhs.width == rhs.width && lhs.height == lhs.height
}

struct Image {
    let data: UnsafeMutablePointer<UInt8>
    let size: ImageSize
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


enum ErrorPixelTransform {
    case flat
    case movement
    case flatDifferenceIntensity
    case movementDifferenceIntensity
    
    func transform(errorColor: Color, pixel1: Pixel, pixel2: Pixel) -> Pixel
    {
    
        
        switch self {
        case .flat:
            return Pixel(color: errorColor)
        case .movement:
            return Pixel(
                r: UInt8((Float(pixel2.r) * (Float(errorColor.r) / 255.0) + Float(errorColor.r)) / 2.0),
                g: UInt8((Float(pixel2.g) * (Float(errorColor.g) / 255.0) + Float(errorColor.g)) / 2.0),
                b: UInt8((Float(pixel2.b) * (Float(errorColor.b) / 255.0) + Float(errorColor.b)) / 2.0),
                a: pixel2.a
            )
        case .flatDifferenceIntensity:
            return Pixel(
                r: errorColor.r,
                g: errorColor.g,
                b: errorColor.b,
                a: pixel2.distance(from: pixel1)
            )
        case .movementDifferenceIntensity:
            let ratio = Float(pixel2.distance(from: pixel1)) / 255.0 * 0.8

            let errorColorR = Float(errorColor.r)
            let errorColorG = Float(errorColor.g)
            let errorColorB = Float(errorColor.b)
            
            let r = UInt8((1.0 - ratio) * (Float(pixel2.r) * (errorColorR / 255.0)) + ratio * errorColorR)
            let g = UInt8((1.0 - ratio) * (Float(pixel2.g) * (errorColorG / 255.0)) + ratio * errorColorG)
            let b = UInt8((1.0 - ratio) * (Float(pixel2.b) * (errorColorB / 255.0)) + ratio * errorColorB)
            
            return Pixel(
                r: r,
                g: g,
                b: b,
                a: pixel2.a
            )
        }
    }
}

extension Image {
    func compare(to image: Image, errorPixelTransform: ErrorPixelTransform = .flat) -> Image {
        
        let outputData = UnsafeMutablePointer<UInt8>.allocate(capacity: image.size.width * image.size.height * 4)
        
        var samePixelsCount = 0
        for pixelIndex in 0 ..< self.size.width * self.size.height {
            let pixel1 = Pixel(pixelData: image.data.advanced(by: pixelIndex * 4))
            let pixel2 = Pixel(pixelData: self.data.advanced(by: pixelIndex * 4))
            
            if pixel1 == pixel2 {
                pixel1.write(to: outputData.advanced(by: 4 * pixelIndex))
                samePixelsCount += 1
            } else {
                let errorPixel = errorPixelTransform.transform(errorColor: Pixel(r: 255, g: 0, b: 255, a: 255), pixel1: pixel1, pixel2: pixel2)
                errorPixel.write(to: outputData.advanced(by: 4 * pixelIndex))
            }
        }
        
    
        return Image(data: outputData, size: image.size)
        
    }
}
