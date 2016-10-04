//
//  MetalContext.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 02.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import Metal


class Hack {}

public struct MetalContext {
    public let device: MTLDevice
    public let library: MTLLibrary
    public let commandQueue: MTLCommandQueue

    public init() {
        device = MTLCreateSystemDefaultDevice()!
        
        let bundle = Bundle(for: Hack.self)
        library = try! device.makeDefaultLibrary(bundle: bundle)
        commandQueue = device.makeCommandQueue()
    }
}

