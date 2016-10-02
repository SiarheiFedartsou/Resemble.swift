//
//  Pixel.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 1.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation

struct Pixel {
    let r: Float
    let g: Float
    let b: Float
    let a: Float
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
    init(pixelData: UnsafeMutablePointer<Float>) {
        a = pixelData[0]
        r = pixelData[1]
        g = pixelData[2]
        b = pixelData[3]
    }
    
    func write(to output: UnsafeMutablePointer<Float>) {
        output[0] = a
        output[1] = r
        output[2] = g
        output[3] = b
    }
}


extension Pixel : Equatable {}

func ==(lhs: Pixel, rhs: Pixel) -> Bool {
    return
        lhs.r.isEqual(to: rhs.r) &&
        lhs.g.isEqual(to: rhs.g) &&
        lhs.b.isEqual(to: rhs.b) &&
        lhs.a.isEqual(to: rhs.a)
}
