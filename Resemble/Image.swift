//
//  Image.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 04.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Foundation
import Accelerate

public struct Image {
    let buffer: vImage_Buffer
    
    
    init(buffer: vImage_Buffer)
    {
        self.buffer = buffer
    }

    var data: UnsafeMutablePointer<UInt8> {
        return buffer.data.bindMemory(to: UInt8.self, capacity: buffer.rowBytes * Int(buffer.height))
    }
    var size: ImageSize {
        return ImageSize(width: Int(buffer.width), height: Int(buffer.height))
    }
    
    //    deinit {
    //        // TODO: deallocate `buffer`
    //    }
}


extension Image : Equatable {}

public func ==(lhs: Image, rhs: Image) -> Bool {
    guard lhs.size == rhs.size else { return false }
    
    // is not optimal, but currently it is used for test purposes only
    for index in 0 ..< lhs.size.width * rhs.size.height * 4 {
        if lhs.data[index] != rhs.data[index] {
            return false
        }
    }
    return true
}

