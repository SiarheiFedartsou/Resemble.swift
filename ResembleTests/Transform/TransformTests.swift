//
//  TransformTests.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import XCTest
@testable import ResembleMac


class TransformTests: XCTestCase {
    
    func testFlatTransform() {
        let image1 = Image(image: image(named: "test1.png").cgImage!)
        let image2 = Image(image: image(named: "test2.png").cgImage!)
        
        let expectedImage = Image(image: image(named: "flat.png").cgImage!)

        
        
        
        XCTAssertEqual(image1.compare(to: image2, errorPixelTransform: .flat).preparedForTest(), expectedImage)
    }
    
    func testFlatDifferenceIntensityTransform() {
        let image1 = Image(image: image(named: "test1.png").cgImage!)
        let image2 = Image(image: image(named: "test2.png").cgImage!)
        
        let expectedImage = Image(image: image(named: "flatDifferenceIntensity.png").cgImage!)
    
        
        XCTAssertEqual(image1.compare(to: image2, errorPixelTransform: .flatDifferenceIntensity).preparedForTest(), expectedImage)
    }
    
    
    func testMovementTransform() {
        let image1 = Image(image: image(named: "test1.png").cgImage!)
        let image2 = Image(image: image(named: "test2.png").cgImage!)
        
        let expectedImage = Image(image: image(named: "movement.png").cgImage!)
        
        
        XCTAssertEqual(image1.compare(to: image2, errorPixelTransform: .movement).preparedForTest(), expectedImage)
    }
    

    
    func testMovementDifferenceIntensityTransform() {
        let image1 = Image(image: image(named: "test1.png").cgImage!)
        let image2 = Image(image: image(named: "test2.png").cgImage!)
        
        let expectedImage = Image(image: image(named: "movementDifferenceIntensity.png").cgImage!)
        
        
        XCTAssertEqual(image1.compare(to: image2, errorPixelTransform: .movementDifferenceIntensity).preparedForTest(), expectedImage)
    }
    
}
