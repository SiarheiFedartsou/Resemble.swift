//
//  ColorProtocol.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation


protocol Color {
    var r: UInt8 { get }
    var g: UInt8 { get }
    var b: UInt8 { get }
    var a: UInt8 { get }
}

extension Color {
    func distance(from: Color) -> UInt8
    {
        let rDiff = abs(Int(r) - Int(from.r))
        let gDiff = abs(Int(g) - Int(from.g))
        let bDiff = abs(Int(b) - Int(from.b))
        let result = UInt8((rDiff + gDiff + bDiff) / 3)
        return result
    }
}
