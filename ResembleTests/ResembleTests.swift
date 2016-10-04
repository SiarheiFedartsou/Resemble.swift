//
//  ResembleTests.swift
//  ResembleTests
//
//  Created by Sergey Fedortsov on 30.9.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import XCTest
@testable import ResembleMac
import ImageIO

import Metal

class ResembleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
//    BOOL CGImageWriteToFile(CGImageRef image, NSString *path) {
//    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
//    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
//    if (!destination) {
//    NSLog(@"Failed to create CGImageDestination for %@", path);
//    return NO;
//    }
//    
//    CGImageDestinationAddImage(destination, image, nil);
//    
//    if (!CGImageDestinationFinalize(destination)) {
//    NSLog(@"Failed to write image to %@", path);
//    CFRelease(destination);
//    return NO;
//    }
//    
//    CFRelease(destination);
//    return YES;
//    }
    
    
    
    func testExample() {
//        let image1 = Image(image: image(named: "test1.png").cgImage!)
//        let image2 = Image(image: image(named: "test2.png").cgImage!)
//        
//        let expectedImage = image1.compare(to: image2, errorPixelTransform: .flatDifferenceIntensity)
//        
//        
//        var uiimage = UIImage(cgImage: expectedImage.CGImageRepresentation())
//        uiimage = UIImage(data: UIImagePNGRepresentation(uiimage)!)!
//        try! UIImagePNGRepresentation(uiimage)?.write(to: URL(fileURLWithPath: "/Users/sergeyfedortsov/testtttt.png"), options: .atomicWrite);
//        
//        let x = Image(image: (UIImage(contentsOfFile: "/Users/sergeyfedortsov/testtttt.png")?.cgImage)!)
//        
//        XCTAssertEqual(x, expectedImage)
//        
       // XCTAssertEqual(image1.compare(to: image2, errorPixelTransform: .flatDifferenceIntensity), expectedImage)
        
        
//        let path1 = Bundle(for: type(of: self)).path(forResource: "test1", ofType: "png")
//        let image1 = UIImage(contentsOfFile: path1!)?.cgImage
//        
//        let data1 = Image(image: image1!)
//        
//        let path2 = Bundle(for: type(of: self)).path(forResource: "test2", ofType: "png")
//        let image2 = UIImage(contentsOfFile: path2!)?.cgImage
//        
//        let data2 = Image(image: image2!)
//        
//        let data = data1.compare(to: data2, errorPixelTransform: .flatDifferenceIntensity)
//        
//        
//        let uiimage = UIImage(cgImage: data.CGImageRepresentation())
//        
//        
//        try! UIImagePNGRepresentation(uiimage)?.write(to: URL(fileURLWithPath: "/Users/sergeyfedortsov/testtttt.png"), options: .atomicWrite);
//        
//        let x = Image(image: (UIImage(contentsOfFile: "/Users/sergeyfedortsov/testtttt.png")?.cgImage)!)
//        let uiimage2 = UIImage(cgImage: data.CGImageRepresentation())
//        
//         try! UIImagePNGRepresentation(uiimage2)?.write(to: URL(fileURLWithPath: "/Users/sergeyfedortsov/testtttt.png"), options: .atomicWrite);
        

        
        
        
     //   XCTAssertEqual(x, data)
        
//

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
