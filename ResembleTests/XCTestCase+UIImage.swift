//
//  XCTestCase+UIImage.swift
//  Resemble
//
//  Created by Sergey Fedortsov on 01.10.16.
//  Copyright © 2016 Sergey Fedortsov. All rights reserved.
//

import XCTest

extension XCTestCase {
    func image(named name: String) -> UIImage
    {
        let path = Bundle(for: type(of: self)).path(forResource: name, ofType: nil)
        let image = UIImage(contentsOfFile: path!)
        return image!
    }
}
