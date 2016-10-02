//
//  ResizingTests.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import XCTest
@testable import Resemble

class ResizingTests: XCTestCase {
    
    func testResized() {
        let testImage = Image(image: image(named: "test1.png").cgImage!)
        let expectedImage = Image(image: image(named: "resized.png").cgImage!)
        XCTAssertEqual(testImage.resized(to: ImageSize(width: 432, height: 702)).preparedForTest(), expectedImage)
    }
}
