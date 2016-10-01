//
//  ResembleTests.swift
//  ResembleTests
//
//  Created by Sergey Fedortsov on 30.9.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import XCTest
@testable import Resemble

class ResembleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let path1 = Bundle(for: type(of: self)).path(forResource: "test1", ofType: "png")
        let image1 = UIImage(contentsOfFile: path1!)?.cgImage
        
        let data1 = Image(image: image1!)
        
        let path2 = Bundle(for: type(of: self)).path(forResource: "test2", ofType: "png")
        let image2 = UIImage(contentsOfFile: path2!)?.cgImage
        
        let data2 = Image(image: image2!)
        
        let data = data1.compare(to: data2, errorPixelTransform: .flatDifferenceIntensity)
        
        let uiimage = UIImage(cgImage: data.CGImageRepresentation())
        try! UIImagePNGRepresentation(uiimage)?.write(to: URL(fileURLWithPath: "/Users/sergeyfedortsov/testtttt.png"), options: .atomicWrite);
//        

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
