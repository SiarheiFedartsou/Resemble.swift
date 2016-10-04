//
//  ColorProtocol.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation


struct Color {
    let r: Float
    let g: Float
    let b: Float
    let a: Float
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
