//
//  ColorProtocol.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation


protocol Color {
    var r: Float { get }
    var g: Float { get }
    var b: Float { get }
    var a: Float { get }
}

extension Color {
    func distance(from: Color) -> Float
    {
        let rDiff = abs(r - from.r)
        let gDiff = abs(g - from.g)
        let bDiff = abs(b - from.b)
        let result = (rDiff + gDiff + bDiff) / 3.0
        return result
    }
}
