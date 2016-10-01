//
//  Pixel.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 1.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation

struct Pixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
}

extension Pixel : Color {
    init(color: Color) {
        r = color.r
        g = color.g
        b = color.b
        a = color.a
    }
}

extension Pixel {
    init(pixelData: UnsafeMutablePointer<UInt8>) {
        r = pixelData[0]
        g = pixelData[1]
        b = pixelData[2]
        a = pixelData[3]
    }
    
    func write(to output: UnsafeMutablePointer<UInt8>) {
        output[0] = r
        output[1] = g
        output[2] = b
        output[3] = a
    }
}


extension Pixel : Equatable {}

func ==(lhs: Pixel, rhs: Pixel) -> Bool {
    return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
}
