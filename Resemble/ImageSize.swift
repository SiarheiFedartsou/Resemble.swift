//
//  ImageSize.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 04.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation


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
