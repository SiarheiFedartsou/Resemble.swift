//
//  ErrorPixelTransform.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation

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
                r: ((pixel2.r * errorColor.r + errorColor.r) / 2.0),
                g: ((pixel2.g * errorColor.g + errorColor.g) / 2.0),
                b:  ((pixel2.b * errorColor.b + errorColor.b) / 2.0),
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
            let ratio = pixel2.distance(from: pixel1) * 0.8
 
            let r = (1.0 - ratio) * pixel2.r * errorColor.r + ratio * errorColor.r
            let g = (1.0 - ratio) * pixel2.g * errorColor.g + ratio * errorColor.g
            let b = (1.0 - ratio) * pixel2.b * errorColor.b + ratio * errorColor.b
            
            return Pixel(
                r: r,
                g: g,
                b: b,
                a: pixel2.a
            )
        }
    }
}
