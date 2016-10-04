//
//  ResembleMacTests.swift
//  ResembleMacTests
//
//  Created by Sergey Fedortsov on 03.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import XCTest
@testable import ResembleMac


class ResembleMacTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    struct AdjustSaturationUniforms
    {
        let saturationFactor: Float
    };
    
    func testExample() {
        let image1 = (image(named: "test1.png").cgImage)!
        let image2 = (image(named: "test2.png").cgImage)!
        

        let time = CFAbsoluteTimeGetCurrent()
        
                let img1 = Image(image: image1)
                let img2 = Image(image: image2)
        
        let diff = img1.difference(with: img2)
        
        let cgImage = diff.CGImageRepresentation()
        let outputImage = NSImage(cgImage: cgImage, size:NSSize(width: cgImage.width, height: cgImage.height))
        
        print("Time \(CFAbsoluteTimeGetCurrent() - time)")
        
        outputImage.save(atPath: "/Users/sergeyfedortsov/testmac.png")
    
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
