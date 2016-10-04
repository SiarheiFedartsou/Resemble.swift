//
//  Image+Diff.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 04.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation

extension Image {
    func difference(with anotherImage: Image, errorPixelTransform: ErrorPixelTransform = .movement) -> Image
    {
        let context = MetalContext()
        
        let texture1 = self.texture(inContext: context)
        let texture2 = anotherImage.texture(inContext: context)
        
        let strategy = errorPixelTransform.strategy
        
        
        let outputTexture = strategy.difference(texture1!, texture2!, errorPixelColor: Color(r: 1.0, g: 0.0, b: 1.0, a: 1.0), context: context)
        
        return Image(fromTexture: outputTexture)
    }
}
