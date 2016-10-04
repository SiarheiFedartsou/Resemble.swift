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


public enum ResizingPolicy {
    case toSmaller
    case toLarger
}


public extension Image {
    func compare(to image: Image, errorPixelTransform: ErrorPixelTransform = .flat, resizingPolicy: ResizingPolicy = .toSmaller) -> Image {
        return self.difference(with: image, errorPixelTransform: errorPixelTransform)        
    }
}
